extends Node2D

@onready var Souris = $"../Pointeur_Selection"
@onready var scene = $"../../.."
@onready var caseSelec = $"../Pointeur_Selection/CaseSelecJ1"
@onready var joueurMov : joueur = $"../"

var x : float = 0
var y : float = 0
var emplacement : Vector2 = Vector2.ZERO

var vitesseX : float
var vitesseY : float

func _ready() -> void:
	x = 0
	y = 0
	vitesseX = joueurMov.ressourceJoueur.parametres.vitesseCamera[0]
	vitesseY = joueurMov.ressourceJoueur.parametres.vitesseCamera[1]

#Fonction continue permettant le déplacement dans toutes les directions
func _physics_process(_delta) -> void:
	if Input.is_action_pressed("up"):
		y -= Global.cellSize / vitesseY
	if Input.is_action_pressed("down"):
		y += Global.cellSize / vitesseY
	if Input.is_action_pressed("right"):
		x += Global.cellSize / vitesseX
	if Input.is_action_pressed("left"):
		x -= Global.cellSize / vitesseX
	emplacement.x = x
	emplacement.y = y
	x = x/3
	y = y/3
	var newPositionSouris : Vector2i = scene.get_global_mouse_position()
	#On fait l'équivalent d'un smoothyPosition
	#Centre les coords du curseur au centre d'une case
	newPositionSouris = Vector2i(newPositionSouris) / Global.cellSize
	
	if(Souris.positionSouris != newPositionSouris) :
		Souris.positionSouris = Vector2i(scene.get_global_mouse_position()) / Global.cellSize
		
		caseSelec.global_position = Souris.getMiddleMouseCell()
		Souris.pointeurHasMove(Souris.positionSouris)
	translate(emplacement)
	
	


