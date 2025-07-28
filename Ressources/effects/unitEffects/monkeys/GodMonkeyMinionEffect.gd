extends AbstractEffect
class_name GodMonkeyMinionEffect


const idEffect = "test:GodMonkeyMinionEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, 0, 0, 0, 0)
	self.hideEffect = true
	


func onDeath(unit: AbstractUnit) -> void :
	self.effectAssociated.updateValue(self.effectAssociated.counter - 1)
	self.effectAssociated.unitsStocked.erase(unitAssociated)
	unitAssociated.effects.erase(self)
	queue_free()
