extends Control

var bouttonCapaBase= preload("res://nodes/Unite/interfaceUnite/boutton_capa.tscn")
var joueur : Node2D

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


func capaActivesUnite(uniteAssociee : unite, interfaceUnite : Control, pointeurJoueur : Node2D, visibilite : bool) -> void:
	if(!visibilite):
		visible = false
		joueur = null
		return
	
	joueur = pointeurJoueur

	
	
	#On ne défile que la catégorie des capacités actives
	var capasCat : Dictionary = uniteAssociee.capacites["ActiveCapacitiesBased"]
	
	for capacite : String in capasCat :
		var bouttonCapa : Button = bouttonCapaBase.instantiate()
		var descrip : Array = capacite.split("|", false)
		for bout in descrip :
			print(bout)
			bouttonCapa.text += bout
		#print("YEYE %s" % [capacite])
		#
		bouttonCapa.text = capacite.replace("|", "") + " /" + str(capasCat[capacite][0])
		%ListeCapaDispos.add_child(bouttonCapa)
		#%ContainerCapa.add_child(labelCapa)
		bouttonCapa.placement(self, capacite, capasCat[capacite])
		
		#%LabelCapacites.text += "%d" % [uniteAssociee.capacites[capacite]]
	
	

