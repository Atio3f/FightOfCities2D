extends Node2D

@onready var unite = "res://nodes/Unite/unite.tscn"
@onready var Souris = $"../Pointeur"
@onready var scene = $"../.."
@onready var interfaceFinTour : Control = $"../../CanvasInterface/InterfaceFinTour"
@onready var pointeurSouris : Node2D = $"../Pointeur"

func _input(_event) -> void:
	if interfaceFinTour.sourisOnInterface : 
		if Input.is_action_just_released("action") and Global.unitOn == null and interfaceFinTour.actionsRest > 0:
			var nvlUnite = preload("res://nodes/Unite/unite.tscn").instantiate()	#
			
			nvlUnite.global_position = Souris.positionSouris	#Gestion de la position de l'unité
			scene.add_child(nvlUnite)		#Place l'unité sur le terrain
			print("ezea")
			#print(pointeurSouris.get_tile_data_at(pointeurSouris.positionSouris))
			interfaceFinTour.setActionsRest(interfaceFinTour.actionsRest - 1)
			#print(interfaceFinTour.actionsRest)
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Global.unitOn != null:	#On fait que les cas de figures où il y a une unité sur la case pour le moment
			print("rere")
			Global.unitOn.selectSelf()	#Marche pas pour le moment car Global.unitOn toujours null
