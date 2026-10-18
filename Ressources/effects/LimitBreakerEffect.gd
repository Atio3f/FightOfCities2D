extends AbstractEffect
class_name LimitBreakerEffect

const idEffect = "set1:LimitBreakerEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int = -1, value_A: int = 4, value_B: int = 3, value_C: int = 0, counter: int = 0):
	# value_A: minimum damage per attack (starts at 4 for 1 trinket)
	# value_B: minimum damage increase (+3 per copy of this trinket)
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func mergeEffect(effectToMerge: AbstractEffect) -> void:
	value_A += effectToMerge.value_B
	value_B += effectToMerge.value_B
	onEffectApplied(false, effectToMerge)

func onDamageDealedAfterReduction(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, _visualisation: bool) -> int:
	if damageType != DamageTypes.DamageTypes.THORNS and unit != null and unitAssociated != null and unit.team != unitAssociated.team:
		return max(value_A, damage)
	return damage
