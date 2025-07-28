extends AbstractEffect
class_name TemporalSnailKillEffect

const idEffect = "test:TemporalSnailKillEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 1):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, 0, 0, 0)


func onKill(unitKilled: AbstractUnit) -> void :
	if(unitAssociated.player.orbs < unitAssociated.player.maxOrbs):
		unitAssociated.player.orbs += 1
