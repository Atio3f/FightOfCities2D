extends AbstractEffect
class_name LifeStealEffect
# Heal a value_A % of damage dealed
const idEffect = "set1:LifeStealEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)

func onDamageDealedAfterReduction(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if damage > 0 && !visualisation:
		var healAmt: int = onHeal(unitAssociated, damage * value_A / 100)
		# Don't use onHealed I think
		unitAssociated.healHp(healAmt)
	return damage
