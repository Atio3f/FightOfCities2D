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
			"Taureau" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	,"DeathBuff" :
		{
			"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Taureau" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	},
	"Rouge" : 
	{"SpawnBuff" :		#Confère des bonus aux unités lorsqu'elles sont posées
		{ 
		"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"Taureau" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		"All" : [0, 0, 0, 0, 0, 0, 0, 0]		#La liste contient les bonus pour toutes les unités sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
		}
	,"DeathBased" :
		{
			"Monkey" : [0, 0, 0, 0, 0, 0, 0, 0], #La liste contient les bonus pour tous les Monkeys sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Chauve-Souris" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les Chauve-Souris sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Humain" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les humains sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
			"Taureau" : [0, 0, 0, 0, 0, 0, 0, 0],	#La liste contient les bonus pour tous les taureaux sur les stats suivantes : PV, DR, P, V, S, attaquesMax, attaquesRestantes, vitesseRestante
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

#Opérateur vaut -1 pour faire du négatif ou 1 pour faire du positif
func buffEquipe(couleurEquipe : String, categorie : String, statsUp : Dictionary , cible : Array, operateur : int) -> void :		#cible->Monkey, Humain, All..., valeur
	var valeur : int
	
	for stat : String in statsUp :
		valeur = statsUp[stat] * operateur
		#print("---------")
		#print(stat)
		if cible == [] :		#Correspond aux == "All" d'avant
			equipesData[couleurEquipe][categorie]["All"][ordreBuffs.find(stat)] += valeur
			for unité in _unitsTeam[couleurEquipe] :
				
				unité.boostStat(stat, valeur)
		
		
		else :
			for race : String in cible :	#Parcourt les races ciblées par la capacité
				equipesData[couleurEquipe][categorie][race][ordreBuffs.find(stat)] += valeur	#On ajoute le bonus pour chaque race ciblée
				for uniteAff : unite in _unitsTeam[couleurEquipe][race] :
					
					uniteAff.boostStat(stat, valeur)
	
