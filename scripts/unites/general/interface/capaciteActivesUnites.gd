extends Control

var bouttonCapaBase= preload("res://nodes/Unite/interfaceUnite/boutton_capa.tscn")
var joueur : Node2D
var interface : Control


func _input(event) -> void:
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


func capaActivesUnite(uniteAssociee : unite, interfaceUnite : Control, pointeurJoueur : Node2D, visibilite : bool) -> void:
	if(!visibilite):
		visible = false
		joueur = null
		return
	
	joueur = pointeurJoueur
	interface = interfaceUnite
	
	
	#On ne défile que la catégorie des capacités actives
	var capasCat : Dictionary = uniteAssociee.capacites["ActiveCapacitiesBased"]
	
	for capacite : String in capasCat :
		var boutonCapa : Button = bouttonCapaBase.instantiate()
		var descrip : Array = capacite.split("|", false)
		for bout in descrip :
			print(bout)
			boutonCapa.text += bout
		#print("YEYE %s" % [capacite])
		
		boutonCapa.text += capacite.replace("|", "") + " /" + str(capasCat[capacite][0])
		boutonCapa.menuCapa = self
		%ListeCapaDispos.add_child(boutonCapa)
		#%ContainerCapa.add_child(labelCapa)
		boutonCapa.placement(self, pointeurJoueur, capacite, capasCat[capacite])
		
		#%LabelCapacites.text += "%d" % [uniteAssociee.capacites[capacite]]
	

#Fonction appelée par bouttonCapa qui donne la capacité qui a été choisie pour être utilisée et de quel pointeurJoueur il vient
func recuSelectionCapa(capaciteActivee : Dictionary, pointeurJoueur : Node2D) -> void:
	interface.recuSelectionCapa(capaciteActivee, pointeurJoueur)
	pointeurJoueur	#Manque un truc
	queue_free()
