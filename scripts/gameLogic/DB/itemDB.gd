extends Node

const ITEMS := {
	"set1:VitalLink" : preload("res://Ressources/items/magicalBeasts/VitalLink.gd"),
	"set1:BrambleGauntlet": preload("res://Ressources/items/magicalBeasts/BrambleGauntlet.gd"),
	"set1:MagicalCoconut": preload("res://Ressources/items/others/farmsLoot/MagicalCoconut.gd"),
	"set1:FairyMiracle": preload("res://Ressources/items/magicalBeasts/FairyMiracle.gd"),
	"set1:BananaPeel": preload("res://Ressources/items/monkeys/BananaPeel.gd"),
	"set1:Banana": preload("res://Ressources/items/monkeys/Banana.gd"),
}

var items: Dictionary = {}

func _ready(): #TODO Regrouper les load dans un script global ?
	load_items_from_file("res://translations/items.json")

## Load items on start from the json file
func load_items_from_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("File not found : " + path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.parse_string(content)
	
	if json:
		items = json
	else:
		push_error("Erreur de syntaxe JSON dans le fichier de items.")

# Use to get a specific item with its id
func getItem(item_id: String) -> Dictionary:
	if items.has(item_id):
		var item_data : Dictionary = {}
		item_data.assign(items[item_id])
		return item_data
	else:
		push_error("Trinket id not found : " + item_id)
		return {}
