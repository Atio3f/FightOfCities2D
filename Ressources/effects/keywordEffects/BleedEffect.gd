extends AbstractEffect
class_name BleedEffect
# Pas sûr que l'effet soit bon en terme d'effet, faudra se décider avec Burn
const idEffect = "set1:BleedEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, 0)

func onEndOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	unitAssociated.onDamageTaken(null, value_A, DamageTypes.DamageTypes.UNKNOW, false)
	super.onEndOfTurn(turnNumber, turnColor)
