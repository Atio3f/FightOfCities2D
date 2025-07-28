extends Node
class_name GameManager

static var players: Array[AbstractPlayer] = []
var turnManager: TurnManager

#Return value is to wait the load of all elements and check if we got an error during the loading
static func loadGame() -> bool : 
	#Load all units from all player into players and place them on the map(and setup their effects?)
	
	return true


static func getAllUnits() -> Array[AbstractUnit] :
	var units: Array[AbstractUnit] = []
	for player: AbstractPlayer in players: 
		units.append_array(player.getUnits())
	return units

static func getUnits(team: TeamsColor.TeamsColor) -> Array[AbstractUnit] :
	for player: AbstractPlayer in players: 
		if(player.team == team):
			return player.getUnits()
	return []

static func getPlayers() -> Array[AbstractPlayer]:
	return players

static func getPlayer(team: TeamsColor.TeamsColor) -> AbstractPlayer :
	for player: AbstractPlayer in players: 
		if(player.team == team):
			return player
	return null

static func createPlayer(team: TeamsColor.TeamsColor, name: String) -> AbstractPlayer :
	var player: AbstractPlayer = AbstractPlayer.new(team, name)
	if !TurnManager.teams.has(team) : TurnManager.addTeam(team)
	return player


static func placeUnit(id: String, player: AbstractPlayer, tileCoord: Vector2i) -> AbstractUnit:
	var unit: AbstractUnit = UnitDb.UNITS[id].new(player)#We only keep the second id part to get the class corresponding
	unit.onPlacement(MapManager.getTileAt(tileCoord))
	return unit

#Pour les tests on a besoin d'être sûr du type de case
static func placeUnitForTest(id: String, player: AbstractPlayer, tile: AbstractTile) -> AbstractUnit:#pê pas besoin de renvoyer l'unité produite
	var unit: AbstractUnit = UnitDb.UNITS[id].new(player)#We only keep the second id part to get the class corresponding
	unit.onPlacement(tile)
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
	if(unitAttacking.hpActual > 0):
		unitAttacking.gainXp(ActionTypes.actionTypes.ATTACK, infoDamagesTaked)	#We could also create a dictionary {"damage": infoDamagesTaked["damage"]} but idk if its more efficient or not
	if(unitAttacked.hpActual > 0):
		unitAttacked.gainXp(ActionTypes.actionTypes.ATTACKED, infoDamagesTaked)	#We could also create a dictionary {"damage": infoDamagesTaked["damage"]} but idk if its more efficient or not

static func generateMap(length: int, width: int) -> void :

	MapManager.initMap(length, width)
	return

static func savingGame() -> void :
	
	var gameData := {
		"turnData": {},
		"players": []
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

static func loadSave(save: int) -> void :
	var data = getSave(save)
	players = []
	for player: Dictionary in data.players:
		players.append(AbstractPlayer.recoverPlayer(player))

#Allow to delete all saves during test because I can't find the user://saves repo
static func deleteAllSaves() -> void :
	var i:=1
	for save: String in getSavesList():
		print(deleteSave(i))
		i += 1
