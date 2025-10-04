class_name AbstractCampaign extends Node
#Contains all levels from a campaign

var campaignName: String	#Campaign name, serve when loading a save to load the right campaign class
var campaignFile: String	#File path of the file with all dialogs & list of units/items available for the campaign, will also contains mainCharacter id
var mainCharacter: String	#Id of the main character
var startingAllies: Array	#Array with all allies id on the starting team 
var startingItems: Array	#Array with all items id on the starting team 
var startingTrinkets: Array	#Array with all trinkets id on the starting team 
var startingOrbs: int #Number of orbs at the start of the campaign
var startingMaxOrbs: int #Max orbs at the start of the campaign

var difficulty: int	#Ascension like system, start at 0 and will go up to 5
var progress: String = ""	#Actual level on the campaign
var dataMaps: Dictionary = {}	#Data with all maps
var nextMission: String	#Next mission to be played, useful with reward interface

func _init(campaignName: String) -> void:
	self.campaignName = campaignName


func setupCampaign(difficulty: int, campaignFile: String) -> void :
	self.difficulty = difficulty
	self.nextMission = "map1"
	self.campaignFile = campaignFile
	#Get all informations from the campaign on its file
	var file : FileAccess = FileAccess.open(self.campaignFile, FileAccess.READ)
	if file :
		var content : String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(content)
		mainCharacter = data.get("mainCharacter", "")
		startingAllies = data.get("startingAllies", [])
		startingItems = data.get("startingItems", [])
		startingTrinkets = data.get("startingTrinkets", [])
		startingOrbs = data.get("startingOrbs", 0)
		startingMaxOrbs = data.get("startingMaxOrbs", 0)
	else :
		push_error("FILE FOR CAMPAIGN"+campaignFile+" NOT FOUND")
	file.close()

##Start a new map, will create the map, place units from enemies and make dialogs
func startNextMission() -> void :
	var file : FileAccess = FileAccess.open(self.campaignFile, FileAccess.READ)	#Pê créer un autre fichier pour ça
	if file :
		var content : String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(content)
		dataMaps = data.get("maps")
		var dataMap : Dictionary = dataMaps.get(nextMission)
		progress = nextMission
		##Generate map
		GameManager.generateMap(dataMap["size"]["length"], dataMap["size"]["width"])
		##Reset TurnManager
		TurnManager.reset()
		##Add opponents and allies players
		var player: AbstractPlayer = Global.gameManager.createPlayer(TeamsColor.TeamsColor.RED, "Ennemi", false)
		#ça sera comme ça plus tard mais pour le moment on va juste créer un adversaire rouge et lui donner les troupes
		#for ennemi: Dictionary in dataMap.get("ennemies"):
			#var player: AbstractPlayer = Global.gameManager.createPlayer()
		##Setup all ennemis/allies(will be on the players loop)
		var tile: AbstractTile
		for enemiesDico: Dictionary in dataMap.get("enemies"):
			tile = MapManager.getTileAt(Vector2i(enemiesDico["coords"][0], enemiesDico["coords"][1]))
			Global.gameManager.placeUnit(enemiesDico["id"], player, tile)
		
		##Add the placement tiles and the placement area, where the player will be able to place units
		var placementTiles : Array[Vector2i]
		if dataMap.get("placementArea") : #A voir pour retirer placementArea pas très cool à voir une zone pleine
			var pAreaData: Dictionary = dataMap.get("placementArea")
			for x in range(pAreaData["left"], pAreaData["right"]) :
				for y in range(pAreaData["top"], pAreaData["bottom"]) :
					placementTiles.append(Vector2i(x, y))
		for coordArray: Array in dataMap.get("placementTiles"):
			placementTiles.append(Vector2i(coordArray[0], coordArray[1]))
		#Draw tiles
		GameManager.getMainPlayer().playerPointer.draw_placeable_cells(placementTiles)
		#Hide Meta Interface
		GameManager.getMainPlayer().toggleCombatUI()
	file.close()

func checkWin() -> bool :
	var isWinning: bool = true
	for player: AbstractPlayer in GameManager.getPlayers() :
		if !player :	#Delete player if we forgot to remove it before
			GameManager.getPlayers().erase(player)
			continue
		#We don't check units from base player
		if player == GameManager.getMainPlayer() :
			continue
		else :
			if player.getUnits().size() != 0 :
				isWinning = false
				break
	return isWinning

##Function to check if the player has lose on the map
#Will be override by campaigns, the actual check is the default one
func checkLose() -> bool :
	return GameManager.getMainPlayer().getUnits().size() == 0

func endMap(victoryStatus: bool) -> void:
	if victoryStatus :
		##Clean le board(dans GameManager en fait)
		##Get rewards from map victory
		var dataMap : Dictionary = dataMaps.get(progress)
		##Update info about next mission
		if dataMap.has("nextMission") : 
			nextMission = dataMap["nextMission"]
		
		var mainPlayer: AbstractPlayer = GameManager.getMainPlayer()
		var reward: AbstractReward
		for rewardS: String in dataMap["rewards"] :
			reward = RewardDb.REWARDS[rewardS].new()
			reward.randomizeRewards()
			#Show interface to get rewards
			mainPlayer.metaInterface.placeInterface(reward.getScreenReward(), true)
		
		print("WOUHOU")
		print(progress)
	else :
		GameManager.campaign = null
		Global.gameManager.get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

###Save campaign progress, units will be saved on the player side
func saveCampaignProgress() -> Dictionary :
	return {
		"campaignName": self.campaignName,
		"campaignFile": self.campaignFile,
		"difficulty": self.difficulty,
		"progress": self.progress,
		"nextMission": self.nextMission
	}

static func recoverCampaign(campaignDico: Dictionary) -> AbstractCampaign :
	print("campaignRECOVER name")
	var campaign: AbstractCampaign = load(CampaignDb.CAMPAIGNS[campaignDico["campaignName"]]).new(campaignDico["campaignName"])
	campaign.campaignFile = campaignDico["campaignFile"]
	campaign.progress = campaignDico["progress"]
	campaign.nextMission = campaignDico["nextMission"]
	campaign.startCampaign(campaignDico["difficulty"])
	return campaign
