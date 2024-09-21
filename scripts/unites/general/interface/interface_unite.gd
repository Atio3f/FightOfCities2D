extends Control

@onready var barreVie = $BarreVie
@onready var barreVieTemp = $BarreVie/BarreVieTemporaire
@onready var affichageVie = $BarreVie/BarreVieTemporaire/AffichageVie
@onready var conteneurMenus = $GestionnairePossibilite/ConteneurMenus

@onready var infosUnites = preload("res://scenes/popUps/infosUnite.tscn")
@onready var noeudsTempInfosStats : CanvasLayer = $"../../NoeudsTemp/InterfaceInfosStats"	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)

var _entiteeAssociee : Node2D

func actualisationPV(entiteeAssociee : Node2D) -> void:
	_entiteeAssociee = entiteeAssociee
	barreVie.max_value = entiteeAssociee.pv_max
	barreVie.value = entiteeAssociee.pv_actuels
	barreVieTemp.max_value = entiteeAssociee.pv_max
	barreVieTemp.value = entiteeAssociee.pv_temporaires
	affichageVie.text = "%3d|%3d" % [barreVie.value + barreVieTemp.value, barreVie.max_value]
	

#S'active lorsque le joueur effectue un clic droit sur une unité/bâtiment(visibilite = true), 
#lorsqu'un des boutons des menus est actionné(visibilite -> true) ou que l'entité est désélectionnée (visibilite -> true)
 
func apercuMenusUnite(entiteAssociee : Node2D, visibilite : bool) -> void:
	if(!visibilite) :
		for child : Node in noeudsTempInfosStats.get_children() :
			child.queue_free()
	conteneurMenus.visible = visibilite
	_entiteeAssociee = entiteAssociee
	





func _on_menu_capacites_actives_focus_entered() -> void:
	print("WOUHOU")


func _on_menu_capacites_actives_pressed() -> void:
	print("WHOUH")


func _on_menu_stats_pressed():
	
	var infosUnit : Control = infosUnites.instantiate()
	print("FDP")
	print(get_path())
	
	infosUnit.apercuInfosUnite(_entiteeAssociee, true)
	noeudsTempInfosStats.add_child(infosUnit)
	
