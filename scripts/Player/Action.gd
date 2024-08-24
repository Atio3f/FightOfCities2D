extends Node2D

@onready var unite = "res://nodes/Unite/unite.tscn"
@onready var scene = $"../.."
@onready var interfaceFinTour : Control = $"../../CanvasInterface/InterfaceFinTour"
@onready var pointeurSouris : Node2D = $"../Pointeur_Selection"
@onready var map : Node2D = $"../../Map"

func _input(_event) -> void:
	if interfaceFinTour.sourisOnInterface : 
		#Permet de poser un nouveau monkey
		if Input.is_action_just_pressed("action") and map._units.has(pointeurSouris.positionSouris) == false and interfaceFinTour.actionsRest > 0:
			var nvlUnite = preload("res://nodes/Unite/unite.tscn").instantiate()	#
			
			nvlUnite.position = pointeurSouris.getMiddleMouseCell()	#Gestion de la position de l'unité
			nvlUnite.case = pointeurSouris.positionSouris
			
			nvlUnite.couleurEquipe = "Bleu"
			scene.add_child(nvlUnite)		#Place l'unité sur le terrain
			nvlUnite.vitesseRestante = nvlUnite.V	#On initialise la vitesseRestante après avoir placer l'unité pour éviter que sa valeur soit rechangé entre temps
			map._units[nvlUnite.case]  = nvlUnite
			print("CREATION SINGE BLEU")
			#print(pointeurSouris.get_tile_data_at(pointeurSouris.positionSouris))
			interfaceFinTour.setActionsRest(interfaceFinTour.actionsRest - 1)
			#print(interfaceFinTour.actionsRest)
			
		#Permet de créer un ennemi(sert à faire des tests ne coûte aucune action
		if Input.is_action_just_pressed("action2") and map._units.has(pointeurSouris.positionSouris) == false:
			var nvlUnite = preload("res://nodes/Unite/unite.tscn").instantiate()	
			
			nvlUnite.position = pointeurSouris.getMiddleMouseCell()	#Gestion de la position de l'unité
			nvlUnite.case = pointeurSouris.positionSouris
			
			nvlUnite.couleurEquipe = "Rouge"	#Equipe des ennemis
			scene.add_child(nvlUnite)		#Place l'unité sur le terrain
			nvlUnite.vitesseRestante = nvlUnite.V	#On initialise la vitesseRestante après avoir placer l'unité pour éviter que sa valeur soit rechangé entre temps
			
			map._units[nvlUnite.case]  = nvlUnite
		#Permet de sélectionner une unité ça a été déplacé dans PointeurSelect je crois
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and map._units.has(pointeurSouris.positionSouris) == true:	#On fait que les cas de figures où il y a une unité sur la case pour le moment
			#print(Global.unitOn)
			#print(map._units[pointeurSouris.positionSouris])
			#Global.unitOn.selectSelf()
			pass
