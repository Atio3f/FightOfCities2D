class_name OrbCrate extends AbstractTrinket

#Gain 3 orb on obtain
const idItem = "set1:OrbCrate"
const img = "res://assets/sprites/trinkets/OrbCrate"
const ORB_GAIN = 3

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_UNCOMMON, playerAssociated, ORB_GAIN)


func onGain() -> void :
	playerAssociated.gainOrbs(value_A)
