extends AbstractEffect
class_name BerserkerBullEffect

const idEffect = "set1:BerserkerBullEffect"
const img = ""
const DMG_MULTIPLIER = 2
const HEAL_VALUE = 10

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 100, false, DMG_MULTIPLIER, HEAL_VALUE, 0, 0)


func onDamageTaken(_unit: AbstractUnit, damage: int, _damageType: DamageTypes.DamageTypes, _visualisation: bool) -> int :
	return damage * value_A

func onDamageDealedAfterReduction(_unit: AbstractUnit, damage: int, _damageType: DamageTypes.DamageTypes, _visualisation: bool) -> int :
	return damage * value_A


func onKill(_unitKilled: AbstractUnit) -> void :
	var healValue: int = value_B
	unitAssociated.onHeal(null, healValue)
	unitAssociated.healHp(healValue)
