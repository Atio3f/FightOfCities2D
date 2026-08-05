extends Control
class_name interfaceInfosUnite

var effectDisplayI : PackedScene = preload("res://nodes/interface/effectDisplayInterface.tscn")

#func _process(delta):
	#%ItemPopUp.popup()


func _input(event) -> void:
	if(event.is_action_pressed("ui_cancel")):
		queue_free()


func apercuInfosUnite(unitAssociated : AbstractUnit, pointeurJoueurI : pointeurJoueur, visibilite : bool) -> void:
	if(!visibilite):
		visible = false
		return
	%ImageUnite.texture = load(unitAssociated.getImagePath() + "_p.png")
	%LabelName.text = unitAssociated.getName()
	%LabelPV.text = "❤︎%3d/%-3d" % [unitAssociated.hpActual + unitAssociated.hpTemp, unitAssociated.hpMax]
	%LabelDR.text = "DR|MR= %3d|%-3d" % [unitAssociated.dr, unitAssociated.mr] # TODO Replace emojis with other shield and something for magical reduction
	%LabelPuissance.text = "⚔️%3d" % [unitAssociated.power]
	%LabelDt.text = "🎯%2d" % [unitAssociated.range]
	%LabelVitesse.text = "⚡%2d/%-2d" % [unitAssociated.speedRemaining,unitAssociated.speed] # TODO CHange symbol for Hermes boots
	%LabelSagesse.text = "📘%3d" % [unitAssociated.wisdom]
	%LabelPotential.text = "Potential %1d" % [unitAssociated.level, unitAssociated.potential]
	%LabelEffects.text = "Effects : "	
	var effectDisplay : EffectDisplay
	for effect: AbstractEffect in unitAssociated.effects:
		#We don't show effects with hideEffect on
		if effect.hideEffect :
			return
	#for capaciteI : capacite in unitAssociated.capacites.getCapasDescription() :	#On défile les catégories des capacités
		#
		effectDisplay = effectDisplayI.instantiate()
		effectDisplay.generate(effect)
		%ContainerEffects.add_child(effectDisplay)
		##print("YEYE %s" % [capacite])
		#
		#labelCapa.append_text(capaciteI.nom)
		#%ContainerCapa.add_child(labelCapa)
		#labelCapa.placement(capaciteI)
	%LabelDescription.text = "Description : %s" % [unitAssociated.getName()]
	
	
