extends AbstractEffect
class_name CADOEffect

const idEffect = "set1:CADOEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 20, false, value_A, 0, 0, 0)

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, _visualisation: bool) -> int :
	if (unit.getPositionType() == MovementTypes.positionCategories.FLYING) :
		damage = damage * value_A
	return damage
