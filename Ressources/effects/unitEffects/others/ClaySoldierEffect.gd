extends AbstractEffect
class_name ClaySoldierEffect
# Give value_A HP Temp to ALL your units at the start of combat

const idEffect = "set1:ClaySoldierEffect"
const img = "ClaySoldier"

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, -1, false, value_A, value_B, 0, 0)

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	# Applique les PV Temp lors du 1er tour, une seule fois grâce au compteur
	if turnNumber == 1 && counter == 0 : 
		var unitsToBuff: Array[AbstractUnit] = GameManager.getUnits(turnColor)
		for unit in unitsToBuff :
			unit.gainHpTemp(value_A)
		counter = 1
