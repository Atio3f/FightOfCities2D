extends Node


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
}


var units: Dictionary = {}

func _ready(): #TODO Regrouper les load dans un script global ?
	load_units_from_file("res://translations/unit.json")

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
		#unit_data.assign(units[unit_id])
		return unit_data
	else:
		push_error("unit id not found : " + unit_id)
		return {}
