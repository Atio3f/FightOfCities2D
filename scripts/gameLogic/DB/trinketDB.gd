extends Node

const TRINKETS := {
	"set1:OrbCrate" : preload("uid://0ssld8jniod5"),
	"set1:ArtOfWar" : preload("uid://cvqc2xp146dk5"),
	"set1:BananaRecipes" : preload("uid://buo20ymbvg7g0"),
	"set1:PunchingBallMonkey" : preload("uid://dvqdqovu87md7"),
	"set1:MonkeySoap" : preload("uid://c4k4vrodr3acy"),
}


var trinkets: Dictionary = {}

func _ready(): #TODO Regrouper les load dans un script global ?
	load_trinkets_from_file("res://translations/trinkets.json")

## Load trinkets on start from the json file
func load_trinkets_from_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("File not found : " + path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.parse_string(content)
	
	if json:
		trinkets = json
	else:
		push_error("Erreur de syntaxe JSON dans le fichier de trinkets.")

# Use to get a specific trinket with its id
func getTrinket(trinket_id: String) -> Dictionary:
	if trinkets.has(trinket_id):
		var trinket_data : Dictionary = {}
		trinket_data.assign(trinkets[trinket_id])
		return trinket_data
	else:
		push_error("Trinket id not found : " + trinket_id)
		return {}
