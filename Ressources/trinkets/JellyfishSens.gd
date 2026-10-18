class_name JellyfishSens 
extends AbstractTrinket

# All your units: Inflict 1 Paralysis to enemies that attack you, once per turn per attacked unit
const idItem = "set1:JellyfishSens"
const img = "res://assets/sprites/trinkets/MonkeySoap"
const PARALYSIS_AMT = 1

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_UNCOMMON, playerAssociated, PARALYSIS_AMT)

func onGain() -> void:
	for unit in playerAssociated.units:
		if unit != null and not unit.isDead:
			_apply_effect_to_unit(unit)

func onUnitPlace(unit: AbstractUnit) -> void:
	if unit != null and unit.player == playerAssociated and not unit.isDead:
		_apply_effect_to_unit(unit)

# Avoid misadd of the effect on the same unit
func _apply_effect_to_unit(unit: AbstractUnit) -> void:
	for eff in unit.effects:
		if eff.id == JellyfishSensEffect.idEffect:
			return
	var effect: JellyfishSensEffect = JellyfishSensEffect.new(unit, -1, value_A)
	unit.addEffect(effect)
