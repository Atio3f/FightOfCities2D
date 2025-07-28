extends AbstractEffect
class_name SpeedPlusEffect

const idEffect = "test:SpeedPlusEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null) -> void:
	print("Boost speed pour "+unitAssociated.uid)
	#Value C = duration
	unitAssociated.speed += value_A if firstTime else oldEffect.value_A
	print(unitAssociated.speed)


func onEffectEnd() -> void:
	unitAssociated.speed -= value_A
	unitAssociated.effects.erase(self)
	self.free()
