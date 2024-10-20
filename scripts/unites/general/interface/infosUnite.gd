extends Control


var capaciteTexte = preload("res://nodes/Unite/interfaceUnite/capaciteTexte.tscn")

#func _process(delta):
	#%ItemPopUp.popup()


func _input(event) -> void:
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


func apercuInfosUnite(uniteAssociee : unite, pointeurJoueur : Node2D, visibilite : bool) -> void:
	if(!visibilite):
		visible = false
		return
	%ImageUnite.texture = uniteAssociee.imageUnit
	%LabelPV.text = "PV = %3d /%3d" % [uniteAssociee.pv_actuels + uniteAssociee.pv_temporaires, uniteAssociee.pv_actuels]
	%LabelDR.text = "DR = %3d" % [uniteAssociee.DR]
	%LabelPuissance.text = "P = %3d" % [uniteAssociee.P]
	%LabelDt.text = "Dt = %2d" % [uniteAssociee.range]
	%LabelVitesse.text = "Vitesse = %3d/%3d" % [uniteAssociee.vitesseRestante, uniteAssociee.V]
	%LabelSagesse.text = "S = %3d" % [uniteAssociee.S]
	%LabelNiveau.text = "Niveau %2d" % [uniteAssociee.niveau]
	%LabelXP.text = "XP = %3d(%4d)" % [uniteAssociee.XP, uniteAssociee.paliersNiveaux[uniteAssociee.niveau+1]]
	%LabelCapacites.text = "Capacites : "

	
	
	for capaciteI : capacite in uniteAssociee.capacites.getCapasDescription() :	#On défile les catégories des capacités
		
		
		
		var labelCapa : capaciteTexte = capaciteTexte.instantiate()
		print("YEYE %s" % [capacite])
		
		labelCapa.append_text(capaciteI.nom)
		%ContainerCapa.add_child(labelCapa)
		labelCapa.placement(capaciteI)
			
		
	
	%LabelDescription.text = "Description : %s" % [uniteAssociee.description]
	
	




