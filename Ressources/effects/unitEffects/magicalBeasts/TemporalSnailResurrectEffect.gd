extends AbstractEffect
class_name TemporalSnailResurrectEffect

const idEffect = "test:TemporalSnailResurrectEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 1):
	super._init(idEffect, img, unit, remainingTurns, 100, true, value_A, 0, 0, counter)

func onDeath(unit: AbstractUnit = null) -> void:
	if(unitAssociated.player.orbs >= counter):
		unitAssociated.hpActual = unitAssociated.hpMax * value_A / 100
		unitAssociated.isDead = false
		unitAssociated.player.orbs -= counter
		counter += 1	#Increases the cost by 1 each time
