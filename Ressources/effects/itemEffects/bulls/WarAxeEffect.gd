## Grants temporary HP on kill, A=amount of temp HP gained per kill
extends AbstractEffect
class_name WarAxeEffect

const idEffect = "set1:WarAxeEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onKill(_unitKilled: AbstractUnit) -> void :
	unitAssociated.gainHpTemp(value_A)
