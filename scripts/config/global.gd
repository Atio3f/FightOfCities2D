extends Node

var unitOn : Node2D
var unitSelec : Node2D

## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}

#Dictionnaire des différentes équipes contenant à l'intérieur clé = nomEquipe; 
var _unitsTeam := {}
#Contient l'ordre des couleurs des équipes pour les tours
var ordreCouleur : Array = Array([], TYPE_STRING, &"", null)

#Contient le numéro du tour en cours
var couleurTour : int


var equipesData : Dictionary = {"Bleu" : 
	{"SpawnBuff" :		#Confère des bonus aux unités lorsqu'elles sont posées
		{ 
		"Monkey" : [0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S
		"Chauve-Souris" : [0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S
		"Humain" : [0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S
		"All" : [0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S
		}
	}
}


#Les paramètres dans le ready seront à changer lorsqu'il y aura un système de sauvegarde
func _ready() -> void:
	ordreCouleur = ["Bleu", "Rouge"]
	couleurTour = 0
	_units = {}


#Fonction permettant de passer au tour suivant, si 
func nextTurn():
	couleurTour += 1
	if couleurTour >= ordreCouleur.size():
		couleurTour = 0
