extends AbstractEffect
class_name PowerPlusEffect

const idEffect = "test:PowerPlusEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)
	
	
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null):
	print("Boost power pour "+unitAssociated.uid)
	unitAssociated.power += value_A if firstTime else oldEffect.value_A
	print(unitAssociated.getPower())
