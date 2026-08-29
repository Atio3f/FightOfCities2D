extends AbstractEffect
class_name UnyieldingBearEffect

const idEffect = "set1:UnyieldingBearEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int = -1, value_A: int = 1, value_B: int = 0, value_C: int = 0, counter: int = 0):
	# value_A = amount of DR gained when attacked
	super._init(idEffect, img, unit, remainingTurns, 0, false, value_A, value_B, value_C, counter)

func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	if not visualisation:
		# +value_A DR until next turn
		var dr_effect = DRPlusEffect.new(unitAssociated, 0, value_A) # 0 = next turn
		unitAssociated.addEffect(dr_effect)
	return damage
