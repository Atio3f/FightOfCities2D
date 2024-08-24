extends Node

var unitOn : Node2D
var unitSelec : Node2D

## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}


#Contient l'ordre des couleurs des équipes pour les tours
var ordreCouleur : Array = Array([], TYPE_STRING, &"", null)

#Contient le numéro du tour en cours
var couleurTour : int

#Les paramètres dans le ready seront à changer lorsqu'il y aura un système de sauvegarde
func _ready() -> void:
	ordreCouleur = ["Bleu", "Rouge"]
	couleurTour = 0


#Fonction permettant de passer au tour suivant, si 
func nextTurn():
	couleurTour += 1
	if couleurTour >= ordreCouleur.size():
		couleurTour = 0
