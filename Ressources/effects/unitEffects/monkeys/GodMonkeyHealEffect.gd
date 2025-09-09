extends AbstractEffect
class_name GodMonkeyHealEffect


const idEffect = "test:GodMonkeyHealEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, 0, 0, 0)


func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if(unitAssociated.tile.id == "test:ForestTile"):
		var healValue = value_A
		healValue = unitAssociated.onHealed(unitAssociated, healValue)
		healValue = unitAssociated.onHeal(unitAssociated, healValue)
		unitAssociated.healHp(healValue)
