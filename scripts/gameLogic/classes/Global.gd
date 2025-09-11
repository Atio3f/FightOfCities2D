extends Node
#S'occupe de tout charger et d'enregistrer les joueurs dans la partie

var effectsStrings := {}
var unitsStrings := {}
var trinketsStrings := {}

var parameters: ParamPlayer = preload("res://Ressources/old/player/joueur1/paramJoueur1.tres")
var unitOn : Node2D
var unitSelec : Node2D
var gameManager: GameManager

func _ready():
	effectsStrings = loadStrings("res://Ressources/effects/EffectsStrings.json")
	unitsStrings = loadStrings("res://Ressources/units/UnitsStrings.json")
	trinketsStrings = loadStrings("res://Ressources/trinkets/TrinketsStrings.json")

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


##Affichage des fps pour chaque joueur
func _process(delta):
	pass
	#var fps : int = Engine.get_frames_per_second()
	#%FPSMeter.text = "FPS: %03d" % [fps]
	#if(fps < 30):	#Check lorsqu'on fera beaucoup de conneries
		#print(fps)
		#print("PROBLEME DE PERFORMANCES")



func colorSelector(couleurEq : String) -> Color :
	if couleurEq == "Rouge":
		return Color.hex(0xde2d0da0)
	elif couleurEq == "Vert":
		return Color.hex(0x71d61e80)
	elif couleurEq == "Bleu":
		return Color.hex(0x89ff5e80)
	else:
		return Color.hex(0xf7f7f740)  # Blanc par défaut


### All scenes to preload here
#Interface of an trinket on the trinket list
var trinketInterface: PackedScene = preload("res://nodes/interface/trinketInterface.tscn")
#Damage indicator when an unit taked damage
var popUpDegats : PackedScene = preload("res://nodes/Unite/interfaceUnite/indicateur_degats.tscn")
