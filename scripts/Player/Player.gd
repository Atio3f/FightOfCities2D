extends Node2D

@export var ressourceJoueur : playerRessource
var nom : String
var couleurEquipe : String
var id : String	#Identifiant unique en 10caractères

func _ready() -> void:
	startGame("Bleu")	#Changer comment accéder à startGame lorsqu'on mettra le multi + comment mettre la couleur de l'équipe

func startGame(couleurEquipeMatch : String) -> void:
	nom = ressourceJoueur.pseudo
	id = ressourceJoueur.id
	couleurEquipe = couleurEquipeMatch


var activeCapacity	#capacité active actuelle


##Affichage des fps pour chaque joueur
func _process(delta):
	var fps : int = Engine.get_frames_per_second()
	%FPSMeter.text = "FPS: %03d" % [fps]
	if(fps < 100 and fps > 40):	#Check lorsqu'on fera beaucoup de conneries
		print(fps)
		print("PROBLEME DE PERFORMANCES")
