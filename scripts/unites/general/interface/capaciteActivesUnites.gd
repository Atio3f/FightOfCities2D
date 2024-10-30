extends Control
class_name menuCapa

var bouttonCapaBase= preload("res://nodes/Unite/interfaceUnite/boutton_capa.tscn")
var joueur : Node2D
var interface : Control


func _input(event) -> void:
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


#A REFAIRE
func capaActivesUnite(uniteAssociee : unite, interfaceUnite : Control, pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	if(!visibilite):
		visible = false
		joueur = null
		return
	
	joueur = pointeurJoueurI
	interface = interfaceUnite
	
	
	#On ne défile que la catégorie des capacités actives
	var capasActives : Array = uniteAssociee.capacites.getCapasFrom("ActiveCapacitiesBased")
	print(capasActives)
	for capaciteI : activeCapacite in capasActives :
		var boutonCapa : bouttonCapa = bouttonCapaBase.instantiate()
		boutonCapa.text = capaciteI.descriptionCapa
		#print("YEYE %s" % [capacite])
		
		boutonCapa.text += capaciteI.nom
		boutonCapa.menuCapaI = self
		%ListeCapaDispos.add_child(boutonCapa)
		#%ContainerCapa.add_child(labelCapa)
		boutonCapa.placement(self, pointeurJoueurI, capaciteI)
		
		#%LabelCapacites.text += "%d" % [uniteAssociee.capacites[capacite]]
	

#Fonction appelée par bouttonCapa qui donne la capacité qui a été choisie pour être utilisée et de quel pointeurJoueur il vient
func recuSelectionCapa(capaciteActivee : activeCapacite, pointeurJoueurI : pointeurJoueur) -> void:
	interface.recuSelectionCapa(capaciteActivee, pointeurJoueurI)
	pointeurJoueurI	#Manque un truc
	queue_free()
