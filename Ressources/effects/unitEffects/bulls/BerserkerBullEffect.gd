extends AbstractEffect
class_name BerserkerBullEffect

const idEffect = "test:BerserkerBullEffect"
const img = ""
const DMG_MULTIPLIER = 2
const HEAL_VALUE = 10

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 100, false, DMG_MULTIPLIER, HEAL_VALUE, 0, 0)


func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	return damage * value_A

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	#I can't find an unhardcoded solution to make it apply double damage after damage reduction 
	var damageReduction : int
	match damageType:
		DamageTypes.DamageTypes.PHYSICAL:
			damageReduction = unit.dr
		DamageTypes.DamageTypes.MAGICAL:
			damageReduction = unit.mr
		_:
			damageReduction = 0
	return (damage - damageReduction) * value_A + damageReduction


func onKill(unitKilled: AbstractUnit) -> void :
	var healValue: int = value_B
	unitAssociated.onHeal(null, healValue)
	unitAssociated.healHp(healValue)
