extends AbstractEffect
class_name IroncladBullEffect

const idEffect = "test:IroncladBullEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 100, false, value_A, 0, 0, 0)


func onLevelUp(level: int) -> void :
	unitAssociated.dr += value_A
	counter += value_A	#If we need one day to reset the buff
