extends AbstractEffect
class_name PenetrationMagicalEffect
#All effects which ignore defense

const idEffect = "test:PenetrationMagicalEffect"
const img = ""

var damageType: DamageTypes.DamageTypes = DamageTypes.DamageTypes.MAGICAL
#param: percentagePen: if true attacks will negate a % of the defense, if false attacks will negate a   
func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, percentagePen: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 90, true, value_A, percentagePen, 0, 0)

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if damageType != self.damageType :
		return damage
	if value_B == 0:
		damage = damage - value_A
	else :
		damage = damage * value_A / 100 
	return damage
