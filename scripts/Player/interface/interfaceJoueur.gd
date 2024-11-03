class_name interfaceJoueur
extends Control

@export var grid : Grid
var pointeurInterface : pointeurJoueur
@onready var placementCartes = preload("res://scenes/popUps/joueur/interfacePlacementCartes.tscn")

#Il y a sûrement des trucs à ajuster, genre il faudrait que le pointeurInterface soit affecté avant pour ne pas avoir à changer la variable à chaque fois
func apercuMenusJoueur(pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	%ConteneurMenus.visible = visibilite
	
	
	if(!visibilite) :
		pointeurInterface = null
		for child : Node in %noeudsTemp.get_children() :
		
			child.queue_free()
	else :
		pointeurInterface = pointeurJoueurI
		positionnement()
		
		
		
		print(position)
	%ConteneurMenus.visible = visibilite
	
	
	

##Permet de positionner correctement l'interface sur l'écran de jeu comme l'interface des unités
func positionnement() -> void :
	var pos : Vector2 = grid.calculate_map_position(pointeurInterface.positionSouris)
	position = Vector2(pos.x - 14, pos.y - 22)

func _on_menu_placement_carte_pressed():
	var menuPlacementCartes : Control = placementCartes.instantiate()
	menuPlacementCartes#Fonction dans placementCartes au lancement
	%noeudsTemp.add_child(menuPlacementCartes)
