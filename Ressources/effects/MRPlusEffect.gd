extends AbstractEffect
class_name MRPlusEffect

const idEffect = "set1:MRPlusEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)
	hideEffect = true

func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null) -> void:
	unitAssociated.mr += value_A if firstTime else oldEffect.value_A

func onEffectEnd() -> void:
	unitAssociated.mr -= value_A
	super.onEffectEnd()
