class_name interfaceUnite
extends Control

@onready var barreVie = $BarreVie
@onready var barreVieTemp = $BarreVie/BarreVieTemporaire
@onready var affichageVie = $BarreVie/BarreVieTemporaire/AffichageVie
@onready var conteneurMenus = $GestionnairePossibilite/ConteneurMenus

@onready var infosUnites = preload("res://scenes/popUps/unite/interfaceInfosUnite.tscn")
@onready var capaActives = preload("res://scenes/popUps/unite/interfaceCapaActivesUnites.tscn")
@onready var menuConsommables = preload("res://scenes/popUps/unite/interfaceConsommables.tscn")
@onready var noeudsTempInfosStats : CanvasLayer = $"../../NoeudsTemp/InterfaceInfosStats"	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)

var unitAssociated : Node2D
var pointeursSurInterface : Array = []

func actualisationPV(entiteeAssociee : Node2D) -> void:
	unitAssociated = entiteeAssociee
	barreVie.max_value = entiteeAssociee.pv_max
	barreVie.value = entiteeAssociee.pv_actuels
	barreVieTemp.max_value = entiteeAssociee.pv_max
	barreVieTemp.value = entiteeAssociee.pv_temporaires
	affichageVie.text = "%3d|%3d" % [barreVie.value + barreVieTemp.value, barreVie.max_value]
	

#S'active lorsque le joueur effectue un clic droit sur une unité/bâtiment(visibilite = true), 
#lorsqu'un des boutons des menus est actionné(visibilite -> true) ou que l'entité est désélectionnée (visibilite -> true)
 
func apercuMenusUnite(entiteAssociee : Node2D, pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	conteneurMenus.visible = visibilite
	if(!visibilite) :
		if(pointeursSurInterface.has(pointeurJoueurI)):
			pointeursSurInterface.erase(pointeurJoueurI)
			for child : Node in noeudsTempInfosStats.get_children() :
				
				child.queue_free()
	else :
		if(!pointeursSurInterface.has(pointeurJoueurI)):
			pointeursSurInterface.append(pointeurJoueurI) 
	conteneurMenus.visible = visibilite
	unitAssociated = entiteAssociee
	





func _on_menu_capacites_actives_focus_entered() -> void:
	print("WOUHOU")


#Affichage des capacités actives de l'unité
func _on_menu_capacites_actives_pressed() -> void:
	if (true):
	#if (pointeursSurInterface.size() == 1) :
		var capaAct : menuCapa = capaActives.instantiate()
		
		
		capaAct.capaActivesUnite(unitAssociated, self, GameManager.getMainPlayer().playerPointer, true)
		noeudsTempInfosStats.add_child(capaAct)

#Affichage des infos de l'unité
func _on_menu_stats_pressed():
	#if (pointeursSurInterface.size() == 1) :	#Si il y a + d'un pointeur sur l'interface ça va être 
												#compliqué à gérer je ferai plus tard
	var infosUnit : interfaceInfosUnite = infosUnites.instantiate()
	infosUnit.apercuInfosUnite(unitAssociated, GameManager.getMainPlayer().playerPointer, true)
	noeudsTempInfosStats.add_child(infosUnit)
	

func recuSelectionCapa(capaciteActivee : activeCapacite, pointeurJoueurI : pointeurJoueur):
	print(capaciteActivee)
	pointeurJoueurI.capaActives(capaciteActivee, unitAssociated)
	pass


##Signal envoyé par le menu des Consommables
func _on_menu_consommables_pressed():
	#if (pointeursSurInterface.size() == 1) :	#Si il y a + d'un pointeur sur l'interface ça va être 
												#compliqué à gérer je ferai plus tard
	var menuConso : interfaceConsommables = menuConsommables.instantiate()
	menuConso.apercuConsommables(unitAssociated, GameManager.getMainPlayer().playerPointer, true)
	noeudsTempInfosStats.add_child(menuConso)
