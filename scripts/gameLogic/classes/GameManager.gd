extends Node
class_name GameManager

static var players: Array[AbstractPlayer] = []
static var mainPlayer: AbstractPlayer	#Main player
static var scenePlayer: PackedScene = preload("res://nodes/joueur/player.tscn")
static var sceneOtherPlayer: PackedScene = preload("res://nodes/joueur/otherPlayer.tscn")
static var sceneUnit: PackedScene = preload("res://nodes/Unite/unite.tscn")
var mapManager: MapManager
static var campaign: AbstractCampaign	#Campaign, will be add by the main_menu
static var currentGoals: Array[AbstractGoal] = [] #All goals for the active mission
#var turnManager: TurnManager

var nodePlayers: Node
var nodeStorage: Node

##Initialize storage nodes for game elements
func _ready():
	nodePlayers = Node.new()
	self.add_child(nodePlayers)
	nodeStorage = Node.new()
	self.add_child(nodeStorage)

##A CHANGER AVEC LE NOUVEAU SYSTEME
#Return value is to wait the load of all elements and check if we got an error during the loading
func loadGame() -> bool : 
	##Load all units from all player into players and place them on the map(and setup their effects?)
	
	###POUR LE MOMENT ON FAIT JUSTE UNE CONFIG PAR DEFAUT
	##A CHANGER POUR N'ÊTRE QUE LORSQU'ON DEMARRE UNE NOUVELLE PARTIE
	#var player1: AbstractPlayer = createPlayer(TeamsColor.TeamsColor.GREEN, "Player1", true)
	#configPlayer(player1)
	#campaign.startNextMission()
	#var ennemi: AbstractPlayer = createPlayer(TeamsColor.TeamsColor.RED, "Ennemi", false)
	#placeUnit("set1:Bull", ennemi, MapManager.getTileAt(Vector2i(5, 10)))
	
	#print(mainPlayer.orbs)
	#Ajout d'un trinket test
	#obtainTrinket(mainPlayer, "set1:OrbCrate")
	#obtainTrinket(mainPlayer, "set1:ArtOfWar")
	#print(mainPlayer.orbs)
	
	
	return true

## Config function to setup every stats of the player based of the actual campaign
func configPlayer(player: AbstractPlayer) -> void:
	player.maxOrbs = campaign.startingMaxOrbs
	player.orbs = campaign.startingOrbs
	##Add starting trinkets
	for trinketId: String in campaign.startingTrinkets:
		addTrinket(player, trinketId)
	##Add starting units
	for unitId: String in campaign.startingAllies:
		player.addUnitCard(StoredUnit.new(unitId))
	## Add items
	for itemId: String in campaign.startingItems:
		player.addCard(itemId)

## Get all units
static func getAllUnits() -> Array[AbstractUnit] :
	var units: Array[AbstractUnit] = []
	for player: AbstractPlayer in players: 
		if !player :
			GameManager.getPlayers().erase(player)
			continue
		units.append_array(player.getUnits())
	return units

## Get units list from an team
static func getUnits(team: TeamsColor.TeamsColor) -> Array[AbstractUnit] :
	for player: AbstractPlayer in players: 
		if !player :
			GameManager.getPlayers().erase(player)
			continue
		if(player.team == team):
			return player.getUnits()
	return []

## Get random units from teams not in teamsToExlude and in specificTeam if precised
static func getRandomUnits(nbrUnits: int = 1, teamsToExclude: Array[TeamsColor.TeamsColor] = [], specificTeam: TeamsColor.TeamsColor = -1) -> Array[AbstractUnit] :
	var candidates: Array[AbstractUnit] = []
	## Get all units if no specificTeam is entered. Else, get units from specificTeam
	if specificTeam != -1:
		candidates = getUnits(specificTeam)
	else:
		candidates = getAllUnits()
	
	## FILTER : Remove units from excluded teams or dead. This will keep all potentials units that can be selected by the randomizer
	var validUnits = candidates.filter(func(unit):
		# Check unit alive
		if not is_instance_valid(unit) or unit.isDead: 
			return false
		# Check in excluded team or not
		if unit.player.team in teamsToExclude:
			return false
			
		return true
	)
	## Randomize units position
	validUnits.shuffle() 
	return validUnits.slice(0, min(nbrUnits, validUnits.size())) # Return selected units

static func getPlayers() -> Array[AbstractPlayer]:
	return players

static func getMainPlayer() -> AbstractPlayer:
	return mainPlayer

static func getPlayer(team: TeamsColor.TeamsColor) -> AbstractPlayer :
	for player: AbstractPlayer in players: 
		if(player.team == team):
			return player
	return null

func createPlayer(team: TeamsColor.TeamsColor, name: String, isGamePlayer: bool) -> AbstractPlayer :
	var p : Node 
	if isGamePlayer :
		p = scenePlayer.instantiate()
		p.name = name
	else :
		p = sceneOtherPlayer.instantiate()
	var player = p as AbstractPlayer
	nodePlayers.add_child(p)
	player.initialize(team, name, isGamePlayer)	#We initialize AbstractPlayer infos here
		#Add to the scene
	if isGamePlayer : mainPlayer = player
	#player.$Actions.player = self
	if !TurnManager.teams.has(team) : TurnManager.addTeam(team)
	return player

## Return if the unit can be placed on the tile, we just send the weight actually
static func unitCanBePlacedOnTile(player: AbstractPlayer, tile: AbstractTile, weight: int = 1) -> bool :
	return tile != null and !tile.hasUnitOn() and player.maxWeight >= player.weight + weight

#Pour les tests on a besoin d'être sûr du type de case
func placeUnit(storedUnitData: StoredUnit, player: AbstractPlayer, tile: AbstractTile) -> AbstractUnit:#pê pas besoin de renvoyer l'unité produite
	var u := sceneUnit.instantiate()
	var unit : AbstractUnit = u as AbstractUnit
	nodeStorage.add_child(unit, true)
	print(unit)
	UnitDb.UNITS[storedUnitData.id].initialize(unit, player)
	storedUnitData.applyToUnit(unit) # TODO Vérifier si c'est assez pour appliquer les effets
	unit.onPlacement(tile)
	player.addWeight(unit.grade)	#POTENTIELLEMENT A CHANGER DE PLACE SI ON NE DOIT PAS TJRS CHANGER LE POIDS
	return unit

## Use on recoverUnit to get the unit without weight change or onPlacement call
func createUnit(id: String, player: AbstractPlayer, tile: AbstractTile) -> AbstractUnit:
	var u := sceneUnit.instantiate()
	var unit : AbstractUnit = u as AbstractUnit
	nodeStorage.add_child(unit, true)
	print(unit)
	UnitDb.UNITS[id].initialize(unit, player)
	return unit

## Activate all onUnitPlace capacities for units and player trinkets
static func whenUnitPlace(unit: AbstractUnit) -> void :
	var units = getAllUnits()
	for _unit: AbstractUnit in units:
		if(_unit.uid != unit.uid):#Avoid to count 2 time the same effect for the unit which spawn
			_unit.onUnitPlace(unit)
	## Iterate all trinkets
	for trinket: AbstractTrinket in getMainPlayer().trinkets :
		trinket.onUnitPlace(unit)

static func fight(unitAttacking: AbstractUnit, unitAttacked: AbstractUnit) -> void:
	if((unitAttacked.hpActual <= 0) or (unitAttacking.atkRemaining <= 0)):
		return
	var damageType: DamageTypes.DamageTypes = unitAttacking.damageType
	var damageBase: int = unitAttacking.onDamageDealed(unitAttacked, damageType, false)
	var infoDamagesTaked  = unitAttacked.onDamageTaken(unitAttacking, damageBase, damageType, false)
	print("DAMAGE TAKED: "+ str(infoDamagesTaked["damage"]))
	
	unitAttacking.atkRemaining -= 1
	unitAttacking.speedRemaining = 0
	#Manage experience gained
	#if(unitAttacking.hpActual > 0):
		#unitAttacking.gainXp(ActionTypes.actionTypes.ATTACK, infoDamagesTaked)	#We could also create a dictionary {"damage": infoDamagesTaked["damage"]} but idk if its more efficient or not
	#if(unitAttacked.hpActual > 0):
		#unitAttacked.gainXp(ActionTypes.actionTypes.ATTACKED, infoDamagesTaked)	#We could also create a dictionary {"damage": infoDamagesTaked["damage"]} but idk if its more efficient or not

## Activate item effect on units
static func useItemOnUnits(itemId: String, player: AbstractPlayer, units: Array[AbstractUnit]) -> void:
	player.useCard(itemId, units)

static func generateMap(width: int, length: int) -> void :
	MapManager.initMap( width, length)
	if getMainPlayer() != null : getMainPlayer().fixCameraLimit(length, width)	#Update camera limit
	return

## Draw placeables tiles for the main player
static func drawPlaceablesTiles(placementTiles: Array[Vector2i]) -> void :
	getMainPlayer().playerPointer.draw_placeable_cells(placementTiles)

static func getPlaceablesTiles() -> Array[Vector2i] :
	if getMainPlayer().playerPointer :
		return getMainPlayer().playerPointer.get_placeables_cells()
	else :
		return []

##Like addTrinket function but activate the obtain effet of the trinket
static func obtainTrinket(player: AbstractPlayer, idTrinket: String) -> void:
	var trinket : AbstractTrinket = TrinketDb.TRINKETS[idTrinket].new(player)
	if trinket == null :
		print("ERROR TRINKET NOT FOUND ON DB!")
		return
	else: 
		player.setTrinket(trinket)#Place the trinket on screen
	trinket.onGain()

##Add a trinket to a player, used during save load and doesn't activate obtain effect
# dataTrinket serves to recover data on save
static func addTrinket(player: AbstractPlayer, idTrinket: String, dataTrinket: Dictionary = {}) -> void:
	var trinket : AbstractTrinket = TrinketDb.TRINKETS[idTrinket].new(player)
	if trinket == null :
		print("ERROR TRINKET NOT FOUND ON DB!")
		return
	else: 
		#For recover cases
		if dataTrinket != {} :
			trinket.value_A = dataTrinket["value_A"]
			trinket.value_B = dataTrinket["value_B"]
			trinket.value_C = dataTrinket["value_C"]
			trinket.counter = dataTrinket["counter"]
			trinket.counter2 = dataTrinket["counter2"]
		player.setTrinket(trinket)#Place the trinket on screen

## Function
static func checkGoals() -> void :
	for goal: AbstractGoal in currentGoals :
		goal.updateObjective()


## Function called to check if the player have win or lose
static func checkWin() -> void :
	checkGoals() #Pourra être déplacer plus tard ou ajouter à d'autres fonctions
	print(campaign)
	var isWinning: bool = campaign.checkWin()
	var isLosing: bool = campaign.checkLose()	#Can serve if there are some ways to lose other than units
	if isWinning && !isLosing:
		endMap(true)
	elif isLosing :
		endMap(false)
	getMainPlayer().addWeight(0)	#Update interface

## Function used to clean the board, show dialogs and when the win have been obtained go to the next map
# victoryStatus is true if player have win and false if not
static func endMap(victoryStatus: bool) -> void :
	#TODO Add rewards from each goal
	## Remove current goals and associated interface
	for goal: AbstractGoal in currentGoals :
		goal.goal_delete.emit()
		currentGoals.erase(goal)
		goal.free()
	for unit: AbstractUnit in getMainPlayer().getUnits().duplicate() :
		unit.placeOnInventory()	#Return the unit card on the mainPlayer hand and delete it from the map
	##Delete all players except the main one
	players.erase(getMainPlayer())
	for player: AbstractPlayer in players:
		players.erase(player)
		if player : 
			# If it delete also the main player it is because players had multiple exemples of him
			player.queue_free()
			#TODO Check si ça marche réellement dans des scénarios sans
			for unit: AbstractUnit in player.getUnits() :
				unit.removeSelf(false)
	players.append(getMainPlayer())
	##Play dialogs and then go to the next map on the endMap method from AbstractCampaign
	campaign.endMap(victoryStatus)

static var file_name: String = "";

## Save state of the game
# State is saved before each fight
static func savingGame() -> void :
	
	var gameData := {
		"turnData": TurnManager.registerTurnM(),
		"mapData": MapManager.registerMap(),
		"players": [],
		"campaign": campaign.saveCampaignProgress(),
		"goals": []#currentGoals.map(func(element: AbstractGoal): element.registerGoal())
	}
	for goal: AbstractGoal in currentGoals :
		gameData.goals.append(goal.registerGoal())
	for player in players :
		gameData["players"].append(player.registerPlayer())
	var json = JSON.new()
	json = json.stringify(gameData)
	#print(json)
	saveJson(json)

#From datas on savingGame, we save the json on the computer
static func saveJson(json: String) -> void:
	var dir_path := "user://saves"
	var dir := DirAccess.open(dir_path)
	print(dir_path)
	if dir == null:
		DirAccess.make_dir_absolute(dir_path)
		dir = DirAccess.open(dir_path)
	# Check if we have already a file name for this file
	var full_path : String = ""
	if file_name == "" :
		var existing_files := dir.get_files()
		var i := 1
		var filename : String = "save%d.json" % i
		while filename in existing_files:
			filename = "save%d.json" % i
			i += 1
		file_name = filename
		full_path = "%s/%s" % [dir_path, "save%d.json" % i]
	else :
		full_path = "%s/%s" % [dir_path, file_name]
	
	var file := FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
		print("Sauvegarde enregistrée dans : ", full_path)
	else:
		push_error("Erreur lors de l'ouverture du fichier pour écrire.")

static func getSavesList() -> Array[String]:
	var saveFiles : Array[String] = []
	var dir := DirAccess.open("user://saves")

	if dir == null:
		return saveFiles

	dir.list_dir_begin()
	var fileName = dir.get_next()

	while fileName != "":
		if !dir.current_is_dir() and fileName.begins_with("save") and fileName.ends_with(".json"):
			saveFiles.append(fileName)
		fileName = dir.get_next()

	dir.list_dir_end()
	return saveFiles

#Permet de supprimer une save à partir de son nom
static func deleteSave(save: String) -> bool:
	var file_path := "user://saves/%s" % save
	if FileAccess.file_exists(file_path):
		var err := DirAccess.remove_absolute(file_path)
		if err == OK:
			return true
		else:
			return false
	else :
		return false

#Permet de récupérer les infos d'une sauvegarde à partir de son numéro
static func getSave(save: String) -> Dictionary:
	#On récupère le fichier json
	var file_path := "user://saves/%s" % save
	if not FileAccess.file_exists(file_path):
		return {}
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	#Si le fichier n'existe pas on renvoie un dictionaire vide
	if file == null:
		return {}

	var content := file.get_as_text()
	file.close()

	var json := JSON.new()
	var err := json.parse(content)
	if err != OK:
		return {}
	var data = json.get_data()
	return data

static func loadSave(save: Dictionary) -> void :
	Global.change_gameM_instance()	#Add the gameManager singleton to Global
	if save["saveName"] : file_name = save["saveName"]
	TurnManager.recoverTurnManager(save["turnData"])
	MapManager.recoverMap(save["mapData"])
	players = []
	var playersDico: Dictionary = {}
	for player: Dictionary in save["players"]:
		playersDico.merge(AbstractPlayer.recoverPlayer(player))
	##Iterate through all units to add unitsStocked and effectStocked on all effects
	for unit: AbstractUnit in getAllUnits() :
		unit.recoverUnitsStocked(playersDico)
	## Recover file name
	##Recover campaign at the end
	campaign = AbstractCampaign.recoverCampaign(save["campaign"])
	# Not usage of that while 
	#if campaign.progress != campaign.nextMission : campaign.startNextMission()# progress != nextMission bc this could cause ennemi duplication or other probs
	### Recover goals from current mission
	loadGoals(save["goals"])
	print(GameManager.players)
	print(save)
	#print(save["players"])
	print(GameManager.getAllUnits())
	print(playersDico)
	#Hide Meta Interface -> no check here bc save will be done after charging the map for each fight
	GameManager.getMainPlayer().toggleCombatUI()

## Load goals for the actual mission
# Use on the loadSave to replace goals and on the startNextMission from AbstractCampaign to place goals for the actual mission
static func loadGoals(goalsData: Array) -> void :
	currentGoals = []
	var goal
	for goal_dico: Dictionary in goalsData:
		goal = AbstractGoal.recoverObjective(goal_dico)
		if goal != null : currentGoals.append(goal)

## Load goals for the actual mission
# Use on the loadSave to replace goals and on the startNextMission from AbstractCampaign to place goals for the actual mission
static func loadDialogs(dialogsData: Array) -> void :
	var dialogs: Array[DialogInterface] = []
	for dialog_id: String in dialogsData:
		dialogs.append_array(DialogInterface.recoverDialog(dialog_id))
	GameManager.getMainPlayer().openDialogs(dialogs) #TODO Trouver quoi faire du reste de dialogs

#Allow to delete all saves during test because I can't find the user://saves repo
static func deleteAllSaves() -> void :
	for save: String in getSavesList():
		print(deleteSave(save))

##Change the only instance of gameManager
#static func change_instance() -> void :
	###Remove old gameManager if there is one
	#if Global.gameManager :
		#Global.gameManager.queue_free()
	#var gameM: GameManager = GameManager.new()
	#Global.gameManager = gameM
	#get_tree().root.add_child(gameM)
	
