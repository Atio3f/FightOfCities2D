extends AbstractEffect
class_name AtlasLionEffect

const idEffect = "set1:AtlasLionEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 20, false, value_A, 0, 0, 0)

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, _visualisation: bool) -> int :
	damage = damage * (100 + value_A * (unitAssociated.grade - unit.grade)) / 100 # +value_A% damage per unitAssociated grade - target grade diff
	return damage
