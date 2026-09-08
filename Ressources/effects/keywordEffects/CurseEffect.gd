## Curse: takes double damage
extends AbstractEffect
class_name CurseEffect

const idEffect = "set1:CurseEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, false, value_A, value_B, value_C, 0)

## Take double damage
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	return damage * 2
