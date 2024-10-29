##Gère les capacités de l'unité pour éviter de surcharger le script principal
extends Node2D
class_name gestionnaireCapacites

var listeCapas : Array = []	#Liste des capacités décrites

#Liste des capacités en jeu activables
var capacites : Dictionary = {
"PlacementBased" : [],
"PermanentBuff" : [], 
"ActiveCapacitiesBased" : [],
"TurnBased" : [], 
"ItemBased" : [], 
"MovementBased" : [], 
"AttackBased" : [], 
"KillBased" : [],
"DefenseBased" : [], 
"LevelUpBased" : [], 
"DeathBased": []
}


func initialisationCapas(newListeCapa : Array) -> void:
	for capa : capacite in newListeCapa :
		print("TEST")
		print(capa.typeCapacite)
		if capa.typeCapacite == "PermanentBuff":
			addCapas(capa.capaciteesAssociees)
		listeCapas.append(capa)
		capacites[capa.typeCapacite].append(capa)

func addCapas(newCapacites : Array) -> void:
	
	for capa : capacite in newCapacites :
		capacites[capa.typeCapacite].append(capa)

##Renvoie les capacités de la catégorie mise en entrée
func getCapasFrom(categorie : String) -> Array:
	print(capacites)
	return capacites[categorie]

##Renvoie la liste des capacités décrites
func getCapasDescription() -> Array :
	return listeCapas


func supprCapa(capaciteASuppr : capacite) -> void :
	capacites[capaciteASuppr.typeCapacite].erase(capaciteASuppr)
