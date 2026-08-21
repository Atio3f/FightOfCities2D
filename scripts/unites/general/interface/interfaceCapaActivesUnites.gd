extends Control
class_name menuCapa

var bouttonCapaBase= preload("res://nodes/Unite/interfaceUnite/boutton_capa.tscn")
var joueur : Node2D
var unite_cible : AbstractUnit


func _input(event) -> void:
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


func capaActivesUnite(uniteAssociee : AbstractUnit, player : AbstractPlayer) -> void:
	joueur = player.playerPointer
	unite_cible = uniteAssociee
	
	var capasActives : Array[AbstractCapacity] = []
	if uniteAssociee != null:
		capasActives = uniteAssociee.capacities
		
	for capaciteI : AbstractCapacity in capasActives :
		var boutonCapa : bouttonCapa = bouttonCapaBase.instantiate()
		
		boutonCapa.menuCapaI = self
		%ListeCapaDispos.add_child(boutonCapa)
		#%ContainerCapa.add_child(labelCapa)
		boutonCapa.placement(self, joueur, capaciteI)
		#%LabelCapacites.text += "%d" % [uniteAssociee.capacites[capacite]]
	

#Fonction appelée par bouttonCapa qui donne la capacité qui a été choisie pour être utilisée et de quel pointeurJoueur il vient
func recuSelectionCapa(capaciteActivee : AbstractCapacity, pointeurJoueurI : pointeurJoueur) -> void:
	pointeurJoueurI.capaActives(capaciteActivee, unite_cible)
	queue_free()
