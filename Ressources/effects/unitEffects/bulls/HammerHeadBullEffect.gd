extends AbstractEffect
class_name HammerHeadBullEffect
## Backslash/Aftermath of value_A damage

const idEffect = "set1:HammerHeadBullEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 100, false, value_A, 0, 0, 0)

func onDamageDealedAfterReduction(_unit: AbstractUnit, damage: int, _damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if !visualisation:
		unitAssociated.loseHp(value_A)
	return damage
