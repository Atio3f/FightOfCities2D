## Thorns: deals value_A damage back to melee attackers when this unit takes damage
extends AbstractEffect
class_name ThornsEffect

const idEffect = "set1:ThornsEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)

## Reflects damage to melee attackers (range == 1) after taking damage
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	# Ignore THORNS damage to prevent infinite loops between two units with Thorns or reflect effects
	if unit != null && unit.range == 1 && damageType != DamageTypes.DamageTypes.THORNS:
		if visualisation :
			pass
		else :
			unit.onDamageTaken(unitAssociated, value_A, DamageTypes.DamageTypes.THORNS, false)
	return damage
