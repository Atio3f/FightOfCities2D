extends Camera2D

@onready var Souris = $"../Pointeur_Selection"
@onready var caseSelec = $"../Pointeur_Selection/CaseSelecJ1"
@onready var joueurMov = $"../"

var x : float = 0
var y : float = 0
var emplacement : Vector2 = Vector2.ZERO

var speedX : float
var speedY : float

var limitUp: float
var limitDown: float
var limitRight: float
var limitLeft: float

func _ready() -> void:
	x = 0
	y = 0
	speedX = Global.parameters.vitesseCamera[0]
	speedY = Global.parameters.vitesseCamera[1]

#Fonction continue permettant le déplacement dans toutes les directions
func _physics_process(delta: float) -> void: 
	var dx = 0.0
	var dy = 0.0
	
	if Input.is_action_pressed("up"):
		dy -= speedY * delta * 500
	if Input.is_action_pressed("down"):
		dy += speedY * delta * 500
	if Input.is_action_pressed("right"):
		dx += speedX * delta * 500
	if Input.is_action_pressed("left"):
		dx -= speedX * delta * 500
	
	emplacement += Vector2(dx, dy)

	emplacement.x = clamp(emplacement.x, limitLeft + 10, limitRight - 10)
	emplacement.y = clamp(emplacement.y, limitUp + 10, limitDown - 10)
	position = emplacement  # au lieu de translate(emplacement)

	# Gestion souris
	var newPositionSouris: Vector2i = get_global_mouse_position() / MapManager.vectCellSize
	if Souris.positionSouris != newPositionSouris:
		Souris.positionSouris = newPositionSouris
		caseSelec.global_position = Souris.getMiddleMouseCell()
		Souris.pointeurHasMove(Souris.positionSouris)


	
	
