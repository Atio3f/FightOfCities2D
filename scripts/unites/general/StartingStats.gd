extends Resource

class_name StartingStats

@export var unitName : String = "Job"

var pv_max : int
var pv_actuels : int
@export var P : int		#Puissance permet de faire plus de dégâts
@export var D : int		#Défense permet d'avoir plus de PV
@export var V : int		#Vitesse permet de se déplacer plus loin
@export var S : int		#Sagesse permet d'xp plus vite
@export_enum("Monkey", "Penguin","Chauve-Souris", "Autres") var race : String


func get_pv_actuels() -> int :
	return pv_actuels

func get_P() -> int :
	return P
	
func get_D() -> int :
	return D
	
func get_V() -> int :
	return V
	
func get_S() -> int :
	return S
