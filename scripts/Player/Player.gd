extends Node2D

@export var playerRessource : Resource
var nom : String
var couleurEquipe : String
var id : String	#Identifiant unique en 10caractères

func _ready() -> void:
	startGame("Bleu")	#Changer comment accéder à startGame lorsqu'on mettra le multi + comment mettre la couleur de l'équipe

func startGame(couleurEquipeMatch : String) -> void:
	nom = playerRessource.pseudo
	id = playerRessource.id
	couleurEquipe = couleurEquipeMatch


var activeCapacity	#capacité active actuelle
