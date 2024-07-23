extends Node2D

@onready var Souris = $"../Pointeur"
@onready var scene = $"../.."
@onready var caseSelec = $"../../Map/CaseSelec"

var x : float = 0
var y : float = 0
var emplacement : Vector2 = Vector2.ZERO

func _ready() -> void:
	x = 0
	y = 0

#Fonction continue permettant le déplacement dans toutes les directions
func _physics_process(_delta) -> void:
	if Input.is_action_pressed("up"):
		y -= 6
	if Input.is_action_pressed("down"):
		y += 6
	if Input.is_action_pressed("right"):
		x += 6
	if Input.is_action_pressed("left"):
		x -= 6
	emplacement.x = x
	emplacement.y = y
	x = x/3
	y = y/3
	Souris.positionSouris = scene.get_global_mouse_position()
	Souris.smoothyPosition()	#Centre les coords du curseur au centre d'une case
	caseSelec.position = Souris.positionSouris 						#On place caseSelec sur la case où se trouve la souris
	translate(emplacement)
	
