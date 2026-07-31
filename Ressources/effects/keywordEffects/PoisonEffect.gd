## Poison: deals value_A poison damage at the start of each turn, permanent effect
extends AbstractEffect
class_name PoisonEffect
# TODO normalment ça aurait dû être fin du tour il faudra pê adapter la classe
const idEffect = "set1:PoisonEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, -1, 0, true, value_A, value_B, value_C, 0)

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if turnColor == unitAssociated.team:
		unitAssociated.onDamageTaken(null, value_A, DamageTypes.DamageTypes.POISON, false)
	super.onStartOfTurn(turnNumber, turnColor)
