extends Resource

class_name uniteRessource

var pv_max : int
var pv_actuels : int
@export var image : Texture
@export var P : int		#Puissance permet de faire plus de dégâts
@export var D : int		#Défense permet d'avoir plus de PV
@export var V : int		#Vitesse permet de se déplacer plus loin
@export var S : int		#Sagesse permet d'xp plus vite
@export_range(1, 4) var G : int		#Grade permet de classer les unités, les unités G1 seront présent en 4exemplaires, les G2 en 3exemplaires
@export_enum("Monkey", "Penguin","Chauve-Souris", "Autres") var race : String
@export_range(1, 20) var range : int
@export var couleurEquipe : String 
@export var attaquesMax : int	#Le nombre d'attaques maximales réalisables par l'unité
@export var attaquesRestantes : int 	#Le nombre d'attaques qu'il reste à l'unité ce tour
@export var vitesseRestante : int

##Capacités est un dictionnaire avec comme clé le moment où la capacité est utilisée et comme valeur une liste de toutes les capacités de l'unité :
	#Précision pour les clés :
	#PlacementBased = tout ce qui s'active lorsque l'unité est placée
	#PermanentBuff = tout les buffs qui durent tant que l'unité est en vie
	#TurnBased = tout ce qui s'active au début où à la fin des tours
	#ItemBased = tout ce qui s'active lorsque l'on utilise un objet sur l'unité
	#MovementBased = tout ce qui s'active lorsque l'unité bouge
	#AttackBased = tout ce qui s'active lorsque l'unité attaquez
	#KillBased = tout ce qui s'active lorsque l'unité tue une autre unité
	#DefenseBased = tout ce qui s'active lorsque l'unité prend des dégâts ou se fait attaquer
	#DeathBased = tout ce qui s'active quand l'unité meurt
@export var capacites : Dictionary = {"PlacementBased" : {},"TurnBased" : {}, "ItemBased" : {}, "MovementBased" : {}, "AttackBased" : {}, "KillBased" : {},"DefenseBased" : {}, "DeathBased": {}}
