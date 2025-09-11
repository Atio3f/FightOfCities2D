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

##Start a new map, will create the map, place units from enemies and make dialogs
func startMission(level: int) -> void :
	var file : FileAccess = FileAccess.open(self.campaignFile, FileAccess.READ)	#Pê créer un autre fichier pour ça
	if file :
		var content : String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(content)
		data = data.get("map"+str(level))
		##Generate map
		GameManager.generateMap(data["size"]["width"], data["size"]["length"])
		##Add opponents and allies players
		var player: AbstractPlayer = Global.gameManager.createPlayer(TeamsColor.TeamsColor.RED, "Ennemi", false)
		#ça sera comme ça plus tard mais pour le moment on va juste créer un adversaire rouge et lui donner les troupes
		#for ennemi: Dictionary in data.get("ennemies"):
			#var player: AbstractPlayer = Global.gameManager.createPlayer()
		##Setup all ennemis/allies(will be on the players loop)
		var tile: AbstractTile
		for enemiesDico: Dictionary in data.get("enemies"):
			tile = MapManager.getTileAt(Vector2i(enemiesDico["coords"][0], enemiesDico["coords"][1]))
			Global.gameManager.placeUnit(enemiesDico["id"], player, tile)
		
		##Add the placement tiles and the placement area, where the player will be able to place units
		var pAreaData: Dictionary = data.get("placementArea")
		var placementTiles : Array[Vector2i]
		for x in range(pAreaData["left"], pAreaData["right"]) :
			for y in range(pAreaData["top"], pAreaData["bottom"]) :
				placementTiles.append(Vector2i(x, y))
		for coordArray: Array in data.get("placementTiles"):
			placementTiles.append(Vector2i(coordArray[0], coordArray[1]))
		#Draw tiles
		GameManager.getMainPlayer().playerPointer.draw_placeable_cells(placementTiles)
