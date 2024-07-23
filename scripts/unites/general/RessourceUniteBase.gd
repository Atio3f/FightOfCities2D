extends Resource

class_name uniteRessource

var pv_max : int
var pv_actuels : int
@export var image : Texture
@export var P : int		#Puissance permet de faire plus de dégâts
@export var D : int		#Défense permet d'avoir plus de PV
@export var V : int		#Vitesse permet de se déplacer plus loin
@export var S : int		#Sagesse permet d'xp plus vite
@export_enum("Monkey", "Penguin","Chauve-Souris", "Autres") var race : String
