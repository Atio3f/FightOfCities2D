extends Control
class_name menuCapa

var bouttonCapaBase= preload("res://nodes/Unite/interfaceUnite/boutton_capa.tscn")
var joueur : Node2D
var interface : Control


func _input(event) -> void:
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


#A REFAIRE
func capaActivesUnite(uniteAssociee : AbstractUnit, interfaceUnit : interfaceUnite, pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	if(!visibilite):
		visible = false
		joueur = null
		return
	
	joueur = pointeurJoueurI
	interface = interfaceUnit
	
	
	#On liste toutes les capacités de l'unité
	var capasActives : Array[AbstractCapacity] = uniteAssociee.capacities
	for capaciteI : AbstractCapacity in capasActives :
		var boutonCapa : bouttonCapa = bouttonCapaBase.instantiate()
		
		boutonCapa.menuCapaI = self
		%ListeCapaDispos.add_child(boutonCapa)
		#%ContainerCapa.add_child(labelCapa)
		boutonCapa.placement(self, pointeurJoueurI, capaciteI)
		boutonCapa.disabled = capaciteI.currentCooldown != 0
		print( capaciteI.currentCooldown)
		#%LabelCapacites.text += "%d" % [uniteAssociee.capacites[capacite]]
	

#Fonction appelée par bouttonCapa qui donne la capacité qui a été choisie pour être utilisée et de quel pointeurJoueur il vient
func recuSelectionCapa(capaciteActivee : AbstractCapacity, pointeurJoueurI : pointeurJoueur) -> void:
	interface.recuSelectionCapa(capaciteActivee, pointeurJoueurI)
	queue_free()
