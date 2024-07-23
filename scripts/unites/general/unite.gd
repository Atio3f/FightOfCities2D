extends Node2D

@export var ressource : Resource	#On importe en ressource les stats de l'unité

@onready var sprite = $SpriteUnite
@onready var contourSelec : Sprite2D = $ContourSelection
var positionUnite : Vector2

var pv_max : int
var pv_actuels : int
@export var P : int		#Puissance permet de faire plus de dégâts
@export var D : int		#Défense permet d'avoir plus de PV
@export var V : int		#Vitesse permet de se déplacer plus loin
@export var S : int		#Sagesse permet d'xp plus vite
@export_enum("Monkey", "Penguin","Chauve-Souris", "Autres") var race : String

func _ready() -> void:
	sprite.texture = ressource.image
	pv_max = ressource.D * 2 + 14
	pv_actuels = ressource.pv_actuels
	P = ressource.P
	D = ressource.D
	V = ressource.V
	S = ressource.S
	race = ressource.race
	#await get_tree().create_timer(3).timeout #Test temporaire du déplacement(fonctionne)
	#deplacement(Vector2(200, 80 ))
	
func deplacement(nouvellePosition : Vector2) -> void:
	position = nouvellePosition
	positionUnite = position

#Lorsque l'unité est sélectionné, on retire d'abord l'affichage du contour de l'ancienne unité sélectionnée puis on affiche celui de cette unité 
#avant de stocker cette unité dans Global 
func selectSelf() -> void:
	if Global.unitSelec != null :
		Global.unitSelec.contourSelec.visible = false
	contourSelec.visible = true

	Global.unitSelec = self

	
#Création de 2fonctions pour vérifier quelle unité se trouve à l'emplacement du pointeur de souris
func _on_zone_occupe_mouse_entered() -> void:
	Global.unitOn = self
	print(Global.unitOn)


func _on_zone_occupe_mouse_exited() -> void:
	Global.unitOn = null
	print(Global.unitOn)
