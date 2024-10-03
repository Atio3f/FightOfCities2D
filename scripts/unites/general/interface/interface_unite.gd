class_name interfaceUnite
extends Control

@onready var barreVie = $BarreVie
@onready var barreVieTemp = $BarreVie/BarreVieTemporaire
@onready var affichageVie = $BarreVie/BarreVieTemporaire/AffichageVie
@onready var conteneurMenus = $GestionnairePossibilite/ConteneurMenus

@onready var infosUnites = preload("res://scenes/popUps/infosUnite.tscn")
@onready var capaActives = preload("res://nodes/Unite/interfaceUnite/capaciteActivesUnites.tscn")
@onready var noeudsTempInfosStats : CanvasLayer = $"../../NoeudsTemp/InterfaceInfosStats"	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)

var _entiteeAssociee : Node2D
var pointeursSurInterface : Array = []

func actualisationPV(entiteeAssociee : Node2D) -> void:
	_entiteeAssociee = entiteeAssociee
	barreVie.max_value = entiteeAssociee.pv_max
	barreVie.value = entiteeAssociee.pv_actuels
	barreVieTemp.max_value = entiteeAssociee.pv_max
	barreVieTemp.value = entiteeAssociee.pv_temporaires
	affichageVie.text = "%3d|%3d" % [barreVie.value + barreVieTemp.value, barreVie.max_value]
	

#S'active lorsque le joueur effectue un clic droit sur une unité/bâtiment(visibilite = true), 
#lorsqu'un des boutons des menus est actionné(visibilite -> true) ou que l'entité est désélectionnée (visibilite -> true)
 
func apercuMenusUnite(entiteAssociee : Node2D, pointeurJoueur : Node2D, visibilite : bool) -> void:
	conteneurMenus.visible = visibilite
	if(!visibilite) :
		if(pointeursSurInterface.has(pointeurJoueur)):
			pointeursSurInterface.erase(pointeurJoueur)
			for child : Node in noeudsTempInfosStats.get_children() :
				
				child.queue_free()
	else :
		if(!pointeursSurInterface.has(pointeurJoueur)):
			pointeursSurInterface.append(pointeurJoueur) 
	conteneurMenus.visible = visibilite
	_entiteeAssociee = entiteAssociee
	





func _on_menu_capacites_actives_focus_entered() -> void:
	print("WOUHOU")


#Affichage des capacités actives de l'unité
func _on_menu_capacites_actives_pressed() -> void:
	if (pointeursSurInterface.size() == 1) :
		var capaAct : Control = capaActives.instantiate()
		
		
		capaAct.capaActivesUnite(_entiteeAssociee, self, pointeursSurInterface[0], true)
		noeudsTempInfosStats.add_child(capaAct)

#Affichage des infos de l'unité
func _on_menu_stats_pressed():
	if (pointeursSurInterface.size() == 1) :	#Si il y a + d'un pointeur sur l'interface ça va être 
												#compliqué à gérer je ferai plus tard
		var infosUnit : Control = infosUnites.instantiate()
		infosUnit.apercuInfosUnite(_entiteeAssociee, pointeursSurInterface[0], true)
		noeudsTempInfosStats.add_child(infosUnit)
	

func recuSelectionCapa(capaciteActivee : Dictionary, pointeurJoueur : Node2D):
	print(capaciteActivee)
	pointeurJoueur.capaActives(capaciteActivee, _entiteeAssociee)
	pass
