extends AbstractEffect
class_name BrambleGauntletEffect

const idEffect = "test:BrambleGauntletEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)


func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if(true && !visualisation):	#true will be replaced by the check if it's a contact attack or not
		unit.addEffect(SpeedPlusEffect.new(unit, value_C, value_B))
	return damage + value_A
