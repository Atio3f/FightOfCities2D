extends AbstractEffect
class_name PeasantMonkeyEffect


const idEffect = "set1:PeasantMonkeyEffect"
const img = "Monkey"

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, -1, false, 0, 0, 0, 0)

func onMovement() -> void:
	unitAssociated.atkRemaining = 0
	
