extends AbstractEffect
class_name BandageEffect

const idEffect = "set1:BandageEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onEndOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if turnColor == unitAssociated.team:
		unitAssociated.healHp(value_A)
	super.onEndOfTurn(turnNumber, turnColor)
