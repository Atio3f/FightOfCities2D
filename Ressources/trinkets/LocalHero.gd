class_name LocalHero extends AbstractTrinket

# 
const idItem = "set1:LocalHero"
const img = "res://assets/sprites/trinkets/WarBanner"
const SLOT_GAIN = 1
const WEIGHT_GAIN = 2

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_SPECIAL, playerAssociated, SLOT_GAIN, WEIGHT_GAIN)


func onGain() -> void :
	playerAssociated.addMaxUnits(value_A)
	playerAssociated.addMaxWeight(value_B)
