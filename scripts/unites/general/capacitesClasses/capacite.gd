##Modèle de base d'une capacité
extends Resource
class_name capacite

@export var nom : String = ""
@export var descriptionCapa : String = ""

##Variable permettant de noter le type d'effet que réalise la capacité
@export var operateur : String

##Dictionnaire stockant les différentes stats stockées par la capacité clé = stat, valeur associée = boost à cette stat en question
@export var statsAffectees : Dictionary

##Liste de toutes les cibles de la capacités
@export var typeCible : Array

##typeCapacité est défini dans le constructeur des capacités
@export_enum("PlacementBased", "PermanentBuff",  "ActiveCapacitiesBased", "TurnBased", "ItemBased", 
"MovementBased", "AttackBased", "KillBased", "DefenseBased", "LevelUpBased",  "DeathBased", "undefined") var typeCapacite : String

#
#func _init(newNom : String, newDescription : String, newOperateur : String, newStatsAffectees : Dictionary, newTypeCible : Array, _typeCapacite : String):
	#nom = newNom
	#descriptionCapa = newDescription
	#operateur = newOperateur
	#statsAffectees = newStatsAffectees
	#typeCible = newTypeCible
	#typeCapacite = _typeCapacite
	#
