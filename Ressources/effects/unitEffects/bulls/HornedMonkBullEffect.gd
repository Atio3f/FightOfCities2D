extends AbstractEffect
class_name HornedMonkBullEffect

const idEffect = "set1:HornedMonkBullEffect"
const img = ""
# Attacked enemies lose value_A power 

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 100, false, value_A, 0, 0, 0)


func onDamageDealedAfterReduction(unit: AbstractUnit, damage: int, _damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if !visualisation :
		var malusPower: AbstractEffect = PowerPlusEffect.new(unit, -1, -value_A)
		unit.addEffect(malusPower)
	return damage
