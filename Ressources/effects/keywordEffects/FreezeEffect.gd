extends AbstractEffect
class_name FreezeEffect

const idEffect = "test:FreezeEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	unitAssociated.speedRemaining = 0
	super.onStartOfTurn(turnNumber, turnColor)
