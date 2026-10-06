extends AbstractEffect
class_name MashedBananasEffect

const idEffect = "set1:MashedBananasEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, false, value_A, value_B, value_C, counter)

# TODO Se demander si c'est pas mieux de faire l'effet dans onLoseHp plutôt
func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	if damage >= unitAssociated.hpActual + unitAssociated.hpTemp:
		damage = (unitAssociated.hpActual + unitAssociated.hpTemp) - value_A
		if not visualisation:
			self.onEffectEnd()
	return damage
