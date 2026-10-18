class_name Sundial
extends AbstractTrinket

# All your units: +3 Power on odd turns, +1 DR and MR on even turns
const idItem = "set1:Sundial"
const img = "res://assets/sprites/trinkets/ArtOfWar"
const POWER_AMT = 3
const DR_MR_AMT = 1

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, POWER_AMT, DR_MR_AMT)

func onGain() -> void:
	for unit in playerAssociated.units:
		if unit != null and not unit.isDead:
			_apply_effect_to_unit(unit)

func onUnitPlace(unit: AbstractUnit) -> void:
	if unit != null and unit.player == playerAssociated and not unit.isDead:
		_apply_effect_to_unit(unit)

func _apply_effect_to_unit(unit: AbstractUnit) -> void:
	var effect: SundialEffect = SundialEffect.new(unit, -1, value_A, value_B)
	unit.addEffect(effect)
