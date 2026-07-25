extends Node

## Force le chargement de UnitStatsData.gd AVANT le dictionnaire UNITS pour éviter
## que MonkeyMC.STATS soit null à cause de l'ordre de résolution des classes
const _STATS_TYPE = preload("res://scripts/gameLogic/classes/UnitStatsData.gd")

const UNITS := {
	"set1:MonkeyMC": preload("res://Ressources/units/mainCharacters/monkeys/MonkeyMC.gd"),
	"set1:Monkey": preload("res://Ressources/units/monkeys/Monkey.gd"),
	"set1:QueenMonkey": preload("res://Ressources/units/monkeys/QueenMonkey.gd"),
	"set1:BerserkerBull": preload("res://Ressources/units/bulls/BerserkerBull.gd"),
	"set1:KnightMonkey": preload("res://Ressources/units/monkeys/KnightMonkey.gd"),
	"set1:GodMonkey": preload("res://Ressources/units/monkeys/GodMonkey.gd"),
	"set1:WingedBull": preload("res://Ressources/units/bulls/WingedBull.gd"),
	"set1:Bull": preload("res://Ressources/units/bulls/Bull.gd"),
	"set1:TemporalSnail": preload("res://Ressources/units/magicalBeasts/TemporalSnail.gd"),
	"set1:BlueMushroom": preload("res://Ressources/units/magicalBeasts/BlueMushroom.gd"),
	"set1:AbominationMonkey": preload("res://Ressources/units/monkeys/AbominationMonkey.gd"),
	"set1:IroncladBull": preload("res://Ressources/units/bulls/IroncladBull.gd"),
	"set1:CADO": preload("res://Ressources/units/magicalBeasts/CADO.gd"),
	"set1:StarvingShadow": preload("res://Ressources/units/magicalBeasts/StarvingShadow.gd"),
	"set1:Banâne": preload("res://Ressources/units/magicalBeasts/Banâne.gd"),
	"set1:Orangutan": preload("res://Ressources/units/monkeys/Orangutan.gd"),
	"set1:AssaultDroneMonkey": preload("res://Ressources/units/monkeys/AssaultDroneMonkey.gd"),
}


var units: Dictionary = {}
## Cache des stats chargées à l'exécution pour éviter les versions corrompues du cache compile-time
var _stats_cache: Dictionary = {}

func _ready():
	load_units_from_file("res://translations/unit.json")
	## Chargement de tous les .tres à l'exécution avec CACHE_MODE_IGNORE pour bypasser
	## la version corrompue mise en cache au compile-time (script UnitStats non attaché)
	for unit_id in UNITS:
		var script_path: String = UNITS[unit_id].resource_path
		var tres_path: String = script_path.replace(".gd", ".tres")
		var stats = ResourceLoader.load(tres_path, "", ResourceLoader.CACHE_MODE_IGNORE)
		if stats != null:
			_stats_cache[unit_id] = stats
		else:
			push_error("UnitDb._ready: impossible de charger les stats pour '%s' au chemin '%s'" % [unit_id, tres_path])

## Load units on start from the json file
func load_units_from_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("File not found : " + path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.parse_string(content)
	
	if json:
		units = json
	else:
		push_error("Erreur de syntaxe JSON dans le fichier Units.")

# Use to get a specific unit with its id
func getUnit(unit_id: String) -> Dictionary:
	if units.has(unit_id):
		var unit_data : Dictionary = units[unit_id]
		return unit_data
	else:
		push_error("unit id not found : " + unit_id)
		return {}

func getUnitStats(unit_id: String):
	if _stats_cache.has(unit_id):
		return _stats_cache[unit_id]
	## Fallback : si le cache n'est pas encore prêt, on charge directement
	if UNITS.has(unit_id):
		var script_path: String = UNITS[unit_id].resource_path
		var tres_path: String = script_path.replace(".gd", ".tres")
		return ResourceLoader.load(tres_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	push_error("Stats not found for unit id : " + unit_id)
	return null
