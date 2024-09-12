extends Control

@onready var barreVie = $BarreVie
@onready var barreVieTemp = $BarreVie/BarreVieTemporaire
@onready var affichageVie = $BarreVie/BarreVieTemporaire/AffichageVie



func actualisationPV(entiteAssociee : Node2D) -> void:
	barreVie.max_value = entiteAssociee.pv_max
	barreVie.value = entiteAssociee.pv_actuels
	barreVieTemp.max_value = entiteAssociee.pv_max
	barreVieTemp.value = entiteAssociee.pv_temporaires
	affichageVie.text = "%3d|%3d" % [barreVie.value + barreVieTemp.value, barreVie.max_value]
	
