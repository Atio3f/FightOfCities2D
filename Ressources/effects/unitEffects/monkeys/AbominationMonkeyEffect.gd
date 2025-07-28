extends AbstractEffect
class_name AbominationMonkeyEffect

const idEffect = "test:AbominationMonkeyEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, 0, 0)

#Reduce the P and V of ennemies on contact by 1
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if(true && !visualisation):	#true will be replaced by the check if it's a contact attack or not
		unit.addEffect(PowerPlusEffect.new(unit, -1, -1))
		unit.addEffect(SpeedPlusEffect.new(unit, -1, -1))
	return damage

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if(true && !visualisation):	#true will be replaced by the check if it's a contact attack or not
		unit.addEffect(PowerPlusEffect.new(unit, -1, -1))
		unit.addEffect(SpeedPlusEffect.new(unit, -1, -1))
	return damage
