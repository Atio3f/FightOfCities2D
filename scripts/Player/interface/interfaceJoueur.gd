class_name interfaceJoueur
extends Control

var pointeurInterface : pointeurJoueur

#Il y a sûrement des trucs à ajuster, genre il faudrait que le pointeurInterface soit affecté avant pour ne pas avoir à changer la variable à chaque fois
func apercuMenusJoueur(pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	%ConteneurMenus.visible = visibilite
	pointeurJoueurI.menuOpen = visibilite
	if(!visibilite) :
		pointeurInterface = null
		for child : Node in %noeudsTemp.get_children() :
		
			child.queue_free()
	else :
		
		pointeurInterface = pointeurJoueurI
	%ConteneurMenus.visible = visibilite
	
	




func _on_menu_placement_carte_pressed():
	pass # Replace with function body.
