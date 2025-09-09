extends Camera2D

@onready var Souris = $"../Pointeur_Selection"
@onready var scene = $"../../.."
@onready var caseSelec = $"../Pointeur_Selection/CaseSelecJ1"
@onready var joueurMov = $"../"

var x : float = 0
var y : float = 0
var emplacement : Vector2 = Vector2.ZERO

var vitesseX : float
var vitesseY : float

func _ready() -> void:
	x = 0
	y = 0
	vitesseX = Global.parameters.vitesseCamera[0]
	vitesseY = Global.parameters.vitesseCamera[1]

#Fonction continue permettant le déplacement dans toutes les directions
func _physics_process(_delta) -> void:
	if Input.is_action_pressed("up"):
		if limit_top < (y - (MapManager.cellSize / vitesseY)) :
			y -= MapManager.cellSize / vitesseY
	if Input.is_action_pressed("down"):
		if limit_bottom > (y + (MapManager.cellSize / vitesseY)) :
			y += MapManager.cellSize / vitesseY
	if Input.is_action_pressed("right"):
		if limit_right > (x + (MapManager.cellSize / vitesseX)) :
			x += MapManager.cellSize / vitesseX
	if Input.is_action_pressed("left"):
		if limit_left < (x - (MapManager.cellSize / vitesseX)) :
			x -= MapManager.cellSize / vitesseX
	emplacement.x = x
	emplacement.y = y
	x = x/3
	y = y/3
	var newPositionSouris : Vector2i = scene.get_global_mouse_position()
	#On fait l'équivalent d'un smoothyPosition
	#Centre les coords du curseur au centre d'une case
	newPositionSouris = Vector2i(newPositionSouris) / Vector2i(MapManager.vectCellSize)
	
	if(Souris.positionSouris != newPositionSouris) :
		Souris.positionSouris = Vector2i(scene.get_global_mouse_position()) / Vector2i(MapManager.vectCellSize)
		
		caseSelec.global_position = Souris.getMiddleMouseCell()
		Souris.pointeurHasMove(Souris.positionSouris)
	translate(emplacement)
	
	
