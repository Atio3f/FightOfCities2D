extends Control

@onready var barreVie = $BarreVie
@onready var barreVieTemp = $BarreVie/BarreVieTemporaire
@onready var affichageVie = $BarreVie/BarreVieTemporaire/AffichageVie
@onready var conteneurMenus = $GestionnairePossibilite/ConteneurMenus


func actualisationPV(entiteAssociee : Node2D) -> void:
	barreVie.max_value = entiteAssociee.pv_max
	barreVie.value = entiteAssociee.pv_actuels
	barreVieTemp.max_value = entiteAssociee.pv_max
	barreVieTemp.value = entiteAssociee.pv_temporaires
	affichageVie.text = "%3d|%3d" % [barreVie.value + barreVieTemp.value, barreVie.max_value]
	

#S'active lorsque le joueur effectue un clic droit sur une unité/bâtiment(visibilite = true), 
#lorsqu'un des boutons des menus est actionné(visibilite -> true) ou que l'entité est désélectionnée (visibilite -> true)
 
func apercuMenusUnite(entiteAssociee : Node2D, visibilite : bool) -> void:
	conteneurMenus.visible = visibilite





func _on_menu_capacites_actives_focus_entered():
	print("WOUHOU")


func _on_menu_capacites_actives_pressed():
	print("WHOUH")
