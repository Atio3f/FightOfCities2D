class_name interfaceUnite
extends Control

@onready var healthBar = $HealthBar
@onready var tempHealthBar = $HealthBar/TempHealthBar
@onready var affichageVie = $HealthBar/TempHealthBar/AffichageVie
@onready var conteneurMenus = $PossibilityManager/ConteneurMenus

@onready var infosUnites = preload("res://scenes/popUps/unite/interfaceInfosUnite.tscn")
@onready var capaActives = preload("res://scenes/popUps/unite/interfaceCapaActivesUnites.tscn")
@onready var menuConsommables = preload("res://scenes/popUps/unite/unitItemsInterface.tscn")
@onready var noeudsTempInfosStats : CanvasLayer = $"../../NoeudsTemp/InterfaceInfosStats"	#Sert au stockage de tous les noeuds qui disparaissent(ex  popUpDegats)

var unitAssociated : AbstractUnit
var pointeursSurInterface : Array = []

func actualisationPV(entiteeAssociee : Node2D) -> void:
	unitAssociated = entiteeAssociee
	healthBar.max_value = entiteeAssociee.pv_max
	healthBar.value = entiteeAssociee.pv_actuels
	tempHealthBar.max_value = entiteeAssociee.pv_max
	tempHealthBar.value = entiteeAssociee.pv_temporaires
	affichageVie.text = "%3d|%3d" % [healthBar.value + tempHealthBar.value, healthBar.max_value]
	

#S'active lorsque le joueur effectue un clic droit sur une unité/bâtiment(visibilite = true), 
#lorsqu'un des boutons des menus est actionné(visibilite -> true) ou que l'entité est désélectionnée (visibilite -> true)
func apercuMenusUnite(entiteAssociee : Node2D, pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	unitAssociated = entiteAssociee
	if(!visibilite) :
		if(pointeursSurInterface.has(pointeurJoueurI)):
			pointeursSurInterface.erase(pointeurJoueurI)
			for child : Node in noeudsTempInfosStats.get_children() :
				
				child.queue_free()
	else :
		if(!pointeursSurInterface.has(pointeurJoueurI)):
			pointeursSurInterface.append(pointeurJoueurI) 
	conteneurMenus.visible = visibilite
	%DeleteUnitBtn.visible = (TurnManager.turn == 0 && unitAssociated.player.isGamePlayer)	#Hide the Delete button outside the preparation turn






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
	print("ff") # TODO Check pq ça marche pas quand unité case au dessus
	#if (pointeursSurInterface.size() == 1) :	#Si il y a + d'un pointeur sur l'interface ça va être 
												#compliqué à gérer je ferai plus tard
	var menuConso : UnitItemsInterface = menuConsommables.instantiate()
	menuConso.showItems(unitAssociated, GameManager.getMainPlayer())
	noeudsTempInfosStats.add_child(menuConso)

##Delete the unit if used during the preparation turn
func _on_delete_unit_btn_pressed():
	if !unitAssociated.player.isGamePlayer : return#Avoid crashes
	#Add the unit to the player inventory WILL NEED CHANGE IF CHANGE OF addUnitCard
	unitAssociated.player.addUnitCard(unitAssociated.id)
	#Add its tile on the placement tiles
	unitAssociated.player.playerPointer.draw_placeable_cells([unitAssociated.tile.getCoords()])
	#Delete the unit on board, we use onDeath to be sure we don't forget some effects
	unitAssociated.onDeath()
