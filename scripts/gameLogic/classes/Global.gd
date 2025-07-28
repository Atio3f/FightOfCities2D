extends Node
#S'occupe de tout charger et d'enregistrer les joueurs dans la partie

var effectsStrings := {}
var unitsStrings := {}


func _ready():
	effectsStrings = loadStrings("res://elements/effects/EffectsStrings.json")
	unitsStrings = loadStrings("res://elements/units/UnitsStrings.json")

#Load strings from a json
func loadStrings(filePath: String) -> Dictionary:
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var parsed = JSON.parse_string(json_text)
		return parsed
	else:
		push_error("Erreur : fichier UnitsStrings.json introuvable")
		return {}
