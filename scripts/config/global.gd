extends Node

var unitOn : Node2D
var unitSelec : Node2D

## Mapping of coordinates of a cell to a reference to the unit it contains.
var _units := {}

#Dictionnaire des différentes équipes contenant à l'intérieur clé = nomEquipe; Structure de _unitsTeam : {"Bleu" : {"Monkey": [monkey1, monkey2]}, "Rouge" : {"Monkey": [monkey1, monkey2]}
var _unitsTeam := {}
#Contient l'ordre des couleurs des équipes pour les tours
var ordreCouleur : Array = Array([], TYPE_STRING, &"", null)

#Contient le numéro du tour en cours
var couleurTour : int

var ordreBuffs : Array = ["PV", "DR", "P", "V", "S", "attaquesMax", "attaquesRestantes", "vitesseRestante"]
var equipesData : Dictionary = {"Bleu" : 
	{"SpawnBuff" :		#Confère des bonus aux unités lorsqu'elles sont posées
		{ 
			"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Taureaux" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	,"DeathBuff" :
		{
			"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Taureaux" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	},
	"Rouge" : 
	{"SpawnBuff" :		#Confère des bonus aux unités lorsqu'elles sont posées
		{ 
		"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"Taureaux" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	,"DeathBased" :
		{
			"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Taureaux" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	}
}


#Les paramètres dans le ready seront à changer lorsqu'il y aura un système de sauvegarde
func _ready() -> void:
	ordreCouleur = ["Bleu", "Rouge"]
	couleurTour = 0
	_units = {}


#Fonction permettant de passer au tour suivant, si 
func nextTurn() -> void:
	couleurTour += 1
	if couleurTour >= ordreCouleur.size():
		couleurTour = 0


func buffEquipe(couleurEquipe : String, categorie : String, statUp : String , cible : String, valeur : int) -> void :		#cible->Monkey, Humain, All..., valeur
	var indiceStatUp : int
	indiceStatUp = ordreBuffs.find(statUp)
	print(indiceStatUp)
	
	equipesData[couleurEquipe][categorie][cible][indiceStatUp] += valeur
	if cible != "All" :
		
		for unité in _unitsTeam[couleurEquipe][cible] :
			
			unité.boostStat(statUp, valeur)
	else :
		for i in _unitsTeam[couleurEquipe] :
			
			
			for unité in _unitsTeam[couleurEquipe][i] :
				
				unité.boostStat(statUp, valeur)
