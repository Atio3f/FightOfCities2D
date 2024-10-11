extends Node2D

@onready var uniteStandard = "res://nodes/Unite/unite.tscn"
@onready var scene = get_tree().root
@onready var interfaceFinTour : Control = $"../CanvasInterface/InterfaceFinTour"
@onready var pointeurSouris : Node2D = $"../Pointeur_Selection"
@onready var map : Node2D = $"../../../Map"
@onready var joueur : Node2D = $".."

func _input(_event) -> void:
	if interfaceFinTour.sourisOnInterface : 
		#Permet de poser un nouveau monkey
		if Input.is_action_just_pressed("action") and Global._units.has(pointeurSouris.positionSouris) == false and interfaceFinTour.actionsRest > 0:
			print("CREATION SINGE BLEU")
			var nvlUnite = preload("res://nodes/Unite/unite.tscn").instantiate()	#
			
			#nvlUnite.position = pointeurSouris.getMiddleMouseCell()	#Gestion de la position de l'unité
			#nvlUnite.case = pointeurSouris.positionSouris
			
			scene.add_child(nvlUnite)		#Place l'unité sur le terrain
			nvlUnite.placement(joueur.couleurEquipe, pointeurSouris.getMiddleMouseCell(), pointeurSouris.positionSouris, load("res://Ressources/unites/Monkeys/singe.tres"))	#La fonction placement a comme paramètres : 
																									#couleurEquipe, position(Vector2), case(Vector2i) et la ressource de l'unité correspondante
			nvlUnite.vitesseRestante = nvlUnite.V	#On initialise la vitesseRestante après avoir placer l'unité pour éviter que sa valeur soit rechangé entre temps. Normalement sa vitesseRestante doit être de 0 avec les règles de base
			
			#print(pointeurSouris.get_tile_data_at(pointeurSouris.positionSouris))
			interfaceFinTour.setActionsRest(interfaceFinTour.actionsRest - 1)
			#print(interfaceFinTour.actionsRest)
			
		#Permet de créer un ennemi(sert à faire des tests ne coûte aucune action
		if Input.is_action_just_pressed("action2") and Global._units.has(pointeurSouris.positionSouris) == false:
			var nvlUnite = preload("res://nodes/Unite/unite.tscn").instantiate()	
			
			scene.add_child(nvlUnite)		#Place l'unité sur le terrain
			nvlUnite.placement("Rouge", pointeurSouris.getMiddleMouseCell(), pointeurSouris.positionSouris, load("res://Ressources/unites/Taureaux/G2/TaureauErudit.tres"))
			nvlUnite.vitesseRestante = nvlUnite.V	#On initialise la vitesseRestante après avoir placer l'unité pour éviter que sa valeur soit rechangé entre temps
			
			
		if Input.is_action_just_pressed("action3") and Global._units.has(pointeurSouris.positionSouris) == false:
			var nvlUnite = preload("res://nodes/Unite/unite.tscn").instantiate()	
			
			scene.add_child(nvlUnite)		#Place l'unité sur le terrain
			nvlUnite.placement("Rouge", pointeurSouris.getMiddleMouseCell(), pointeurSouris.positionSouris, load("res://Ressources/unites/Taureaux/G2/taureauAile.tres"))
			nvlUnite.vitesseRestante = nvlUnite.V	#On initialise la vitesseRestante après avoir placer l'unité pour éviter que sa valeur soit rechangé entre temps
			print(nvlUnite.couleurEquipe)
			
			
		
