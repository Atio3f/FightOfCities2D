extends AbstractEffect
class_name DreadCloakEffect

const idEffect = "set1:DreadCloakEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)


func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if(true && !visualisation):
		# Steal !VA! MR from target
		# + value_A for self
		var effectBonus: AbstractEffect = MRPlusEffect.new(unitAssociated, -1, value_A)
		unitAssociated.addEffect(effectBonus)
		# - value_A for attacked unit
		var effectMalus: AbstractEffect = MRPlusEffect.new(unit, -1, -value_A)
		unit.addEffect(effectMalus)
	return damage
