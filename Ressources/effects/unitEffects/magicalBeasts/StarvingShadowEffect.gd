extends AbstractEffect
class_name StarvingShadowEffect


const idEffect = "set1:StarvingShadowEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, _value_B: int = 0, _value_C: int = 0, _counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, 0, 0, 0)


func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if (turnColor == unitAssociated.team) : 
		## Kill unit if hpMax have been reduced below the reduction amount we will provide
		if(unitAssociated.hpMax <= value_A):
			unitAssociated.hpMax = 0
			unitAssociated.onDeath()
		else :
			unitAssociated.hpMax -= value_A
			if (unitAssociated.hpMax < unitAssociated.hpActual) :
				unitAssociated.hpActual = unitAssociated.hpMax
	super.onStartOfTurn(turnNumber, turnColor)

func onKill(unitKilled: AbstractUnit) -> void :
	if (unitKilled != unitAssociated) :
		unitAssociated.hpMax = unitAssociated.hpBase
