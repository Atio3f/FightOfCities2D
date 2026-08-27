class_name WarBanner 
extends AbstractTrinket

# All your units gain 3 HP and 1 P
# Une bannière 
const idItem = "set1:WarBanner"
const img = "res://assets/sprites/trinkets/WarBanner"
const HP_GAIN = 3
const POWER_GAIN = 1

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, HP_GAIN, POWER_GAIN)

func onUnitPlace(unit: AbstractUnit) -> void :
	# Give Power to all units placed on our team
	if unit.player == playerAssociated :
		unit.hpMax += value_A
		unit.power += value_B
