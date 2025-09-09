class_name ArtOfWar extends AbstractTrinket

#Gain 3 orb on obtain
const idItem = "set1:ArtOfWar"
const img = "res://assets/sprites/trinkets/ArtOfWar"
const WEIGHT_GAIN = 1

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.raritiesTrinkets.COMMON, playerAssociated, WEIGHT_GAIN)


func onGain() -> void :
	playerAssociated.addMaxWeight(value_A)
