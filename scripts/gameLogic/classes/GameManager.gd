extends Node
class_name GameManager

static var players: Array[AbstractPlayer] = []
static var mainPlayer: AbstractPlayer	#Main player
static var scenePlayer: PackedScene = preload("res://nodes/joueur/player.tscn")
static var sceneOtherPlayer: PackedScene = preload("res://nodes/joueur/otherPlayer.tscn")
static var sceneUnit: PackedScene = preload("res://nodes/Unite/unite.tscn")
var mapManager: MapManager
static var campaign: AbstractCampaign	#Campaign, will be add by the main_menu

#var turnManager: TurnManager

##JSP SI IL FAUT VRAIMENT QUE JE LE PLACE GAMEMANAGER ni que je dois init mapManager ici
func _ready():
	loadGame()

#Return value is to wait the load of all elements and check if we got an error during the loading
func loadGame() -> bool : 
	##On ajoute le GameManager dans Global pour être accessible partout
	Global.gameManager = self
	##Load all units from all player into players and place them on the map(and setup their effects?)
	
	#Generate Map
	mapManager = %Map
	generateMap(12, 16)
	
	
	###POUR LE MOMENT ON FAIT JUSTE UNE CONFIG PAR DEFAUT
	var player1: AbstractPlayer = createPlayer(TeamsColor.TeamsColor.GREEN, "Player1", true)
	configPlayer(player1)#A CHANGER POUR N'ÊTRE QUE LORSQU'ON DEMARRE UNE NOUVELLE PARTIE
	campaign.startNextMission()
	#var ennemi: AbstractPlayer = createPlayer(TeamsColor.TeamsColor.RED, "Ennemi", false)
	#placeUnit("set1:Bull", ennemi, MapManager.getTileAt(Vector2i(5, 10)))
	
	#print(mainPlayer.orbs)
	#Ajout d'un trinket test
	#obtainTrinket(mainPlayer, "set1:OrbCrate")
	#obtainTrinket(mainPlayer, "set1:ArtOfWar")
	#print(mainPlayer.orbs)
	
	
	return true

##Config function to setup every stats of the player based of the actual campaign
func configPlayer(player: AbstractPlayer) -> void:
	player.maxOrbs = campaign.startingMaxOrbs
	player.orbs = campaign.startingOrbs
	##Add starting trinkets
	for trinketId: String in campaign.startingTrinkets:
		addTrinket(player, trinketId)
	##Add starting units
	for unitId: String in campaign.startingAllies:
		player.addUnitCard(unitId)
	##Add items
	for itemId: String in campaign.startingItems:
		player.addCard(itemId)

static func getAllUnits() -> Array[AbstractUnit] :
	var units: Array[AbstractUnit] = []
	for player: AbstractPlayer in players: 
		if !player :
			GameManager.getPlayers().erase(player)
			continue
		units.append_array(player.getUnits())
	return units

static func getUnits(team: TeamsColor.TeamsColor) -> Array[AbstractUnit] :
	for player: AbstractPlayer in players: 
		if !player :
			GameManager.getPlayers().erase(player)
			continue
		if(player.team == team):
			return player.getUnits()
	return []

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
	else :
		p = sceneOtherPlayer.instantiate()
	var player = p as AbstractPlayer
	%Players.add_child(p)
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
func placeUnit(id: String, player: AbstractPlayer, tile: AbstractTile) -> AbstractUnit:#pê pas besoin de renvoyer l'unité produite
	var u := sceneUnit.instantiate()
	var unit : AbstractUnit = u as AbstractUnit
	%UnitsStorage.add_child(unit, true)
	print(unit)
	UnitDb.UNITS[id].initialize(unit, player)
	unit.onPlacement(tile)
	player.addWeight(unit.grade)	#POTENTIELLEMENT A CHANGER DE PLACE SI ON NE DOIT PAS TJRS CHANGER LE POIDS
	return unit

static func whenUnitPlace(unit: AbstractUnit) -> void :
	var units = getAllUnits()
	for _unit: AbstractUnit in units:
		if(_unit.uid != unit.uid):#Avoid to count 2 time the same effect for the unit which spawn
			_unit.onUnitPlace(unit)

static func fight(unitAttacking: AbstractUnit, unitAttacked: AbstractUnit) -> void:
	if((unitAttacked.hpActual <= 0) or (unitAttacking.atkRemaining <= 0)):
		return
	var damageType: DamageTypes.DamageTypes = unitAttacking.damageType
	var damageBase: int = unitAttacking.onDamageDealed(unitAttacked, damageType, false)
	var infoDamagesTaked  = unitAttacked.onDamageTaken(unitAttacking, damageBase, damageType, false)
	print("DAMAGE TAKED: "+ str(infoDamagesTaked["damage"]))
	
	unitAttacking.atkRemaining -= 1
	unitAttacking.speedRemaining = 0
	#We resolve cases when the attacker died while attacking
	if(unitAttacking.hpActual <= 0):
		unitAttacked.onKill(unitAttacking)
		unitAttacking.onDeath(unitAttacked)
		if(infoDamagesTaked["hpActual"] == 0):
			unitAttacking.onKill(unitAttacked)
			unitAttacked.onDeath(unitAttacking)
	#We also check if the unit attacked has survived or not
	elif(infoDamagesTaked["hpActual"] == 0):
		unitAttacking.onKill(unitAttacked)
		unitAttacked.onDeath(unitAttacking)
		if(unitAttacking.hpActual <= 0):
			unitAttacked.onKill(unitAttacking)
			unitAttacking.onDeath(unitAttacked)
	#Manage experience gained
	#if(unitAttacking.hpActual > 0):
		#unitAttacking.gainXp(ActionTypes.actionTypes.ATTACK, infoDamagesTaked)	#We could also create a dictionary {"damage": infoDamagesTaked["damage"]} but idk if its more efficient or not
	#if(unitAttacked.hpActual > 0):
		#unitAttacked.gainXp(ActionTypes.actionTypes.ATTACKED, infoDamagesTaked)	#We could also create a dictionary {"damage": infoDamagesTaked["damage"]} but idk if its more efficient or not

static func generateMap(length: int, width: int) -> void :

	MapManager.initMap(length, width)
	return

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

## Function called to check if the player have win or lose
static func checkWin() -> void :
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
	for unit: AbstractUnit in getMainPlayer().getUnits() :
		unit.placeOnInventory()	#Return the unit card on the mainPlayer hand
	#We duplicate to avoid the iteration to skip some elements bc we delete the first one
	for unit: AbstractUnit in getMainPlayer().getUnits().duplicate() :	#On est obligé de boucler 2 fois pour le moment, 
		unit.removeSelf(false)	#Alors jsp si faudra pas revoir l'organisation de cette partie à voir
	#Maybe delete enemies units bc they could still lived
	print(getMainPlayer().getUnits())
	##Delete all players except the main one
	players.erase(getMainPlayer())
	for player: AbstractPlayer in players:
		players.erase(player)
		if player : player.queue_free()
	players.append(getMainPlayer())
	##Play dialogs and then go to the next map on the endMap method from AbstractCampaign
	campaign.endMap(victoryStatus)


static func savingGame() -> void :
	
	var gameData := {
		"turnData": TurnManager.registerTurnM(),
		"players": [],
		"campaign": campaign.saveCampaignProgress()
	}
	for player in players :
		gameData["players"].append(player.registerPlayer())
	var json = JSON.new()
	json = json.stringify(gameData)
	print(json)
	saveJson(json)

#From datas on savingGame, we save the json on the computer
static func saveJson(json: String) -> void:
	var dir_path := "user://saves"
	var dir := DirAccess.open(dir_path)
	print(dir_path)
	if dir == null:
		DirAccess.make_dir_absolute(dir_path)
		dir = DirAccess.open(dir_path)

	var existing_files := dir.get_files()
	var i := 1
	while true:
		var filename := "save%d.json" % i
		if not filename in existing_files:
			break
		i += 1

	var full_path := "%s/%s" % [dir_path, "save%d.json" % i]
	var file := FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
		print("Sauvegarde enregistrée dans : ", full_path)
	else:
		push_error("Erreur lors de l'ouverture du fichier pour écrire.")

static func getSavesList() -> Array:
	var saveFiles := []
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

#Permet de supprimer une save à partir de son numéro
static func deleteSave(save: int) -> bool:
	var file_path := "user://saves/save%d.json" % save
	if FileAccess.file_exists(file_path):
		var err := DirAccess.remove_absolute(file_path)
		if err == OK:
			return true
		else:
			return false
	else:
		return false

#Permet de récupérer les infos d'une sauvegarde à partir de son numéro
static func getSave(save: int) -> Dictionary:
	#On récupère le fichier json
	var file_path := "user://saves/save%d.json" % save
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
	TurnManager.recoverTurnManager(save["turnData"])
	players = []
	for player: Dictionary in save.players:
		players.append(AbstractPlayer.recoverPlayer(player))
	##Recover campaign at the end
	campaign = AbstractCampaign.recoverCampaign(save["campaign"])
	if campaign.progress != campaign.nextMission : campaign.startNextMission()# progress != nextMission bc this could cause ennemi duplication or other probs

#Allow to delete all saves during test because I can't find the user://saves repo
static func deleteAllSaves() -> void :
	var i:=1
	for save: String in getSavesList():
		print(deleteSave(i))
		i += 1
