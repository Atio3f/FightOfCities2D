extends AbstractEffect
class_name BurnEffect

const idEffect = "test:BurnEffect"
const img = ""

const BASE_DAMAGE = 4

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	unitAssociated.onDamageTaken(null, 5, DamageTypes.DamageTypes.FIRE, false)
	super.onStartOfTurn(turnNumber, turnColor)
