class_name AbstractCampaign extends Node
#Contains all levels from a campaign

var campaignFile: String	#File path of the file with all dialogs & list of units/items available for the campaign, will also contains mainCharacter id
var mainCharacter: String	#Id of the main character
var startingAllies: Array	#Array with all allies id on the starting team 
var startingItems: Array	#Array with all items id on the starting team 
var startingTrinkets: Array	#Array with all trinkets id on the starting team 
var startingOrbs: int #Number of orbs at the start of the campaign
var startingMaxOrbs: int #Max orbs at the start of the campaign

var difficulty: int	#Ascension like system, start at 0 and will go up to 5
var progress: int = 0	#Actual level on the campaign
var dataMaps: Dictionary = {}	#Data with all maps

func setupCampaign(difficulty: int, campaignFile: String) -> void :
	self.difficulty = difficulty
	self.progress = 1
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
func startMission(level: int) -> void :
	var file : FileAccess = FileAccess.open(self.campaignFile, FileAccess.READ)	#Pê créer un autre fichier pour ça
	if file :
		var content : String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(content)
		dataMaps = data.get("maps")
		var dataMap : Dictionary = dataMaps.get("map"+str(level))
		progress = level
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
	file.close()

func checkWin() -> bool :
	var isWinning: bool = true
	for player: AbstractPlayer in GameManager.getPlayers() :
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
		var dataMap : Dictionary = dataMaps.get("map"+str(progress))
		var mainPlayer: AbstractPlayer = GameManager.getMainPlayer()
		var reward: AbstractReward 
		for rewardS: String in dataMap["rewards"] :
			reward = RewardDb.REWARDS[rewardS].new()
			reward.randomizeRewards()
			reward.obtainReward(mainPlayer, 1)	#NORMALEMENT DOIT ÊTRE APPELLE par l'écran des récompenses
			reward.queue_free()	#Pas nécessaire mais on sait jamais
		##Start next mission
		startMission(progress + 1)
		print("WOUHOU")
