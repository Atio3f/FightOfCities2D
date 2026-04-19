extends AbstractEffect
class_name OrangutanEffect


const idEffect = "set1:OrangutanEffect"
const img = "Monkey"

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, -1, false, value_A, value_B, 0, 0)

func onItemUsed(player: AbstractPlayer, item: AbstractItem, isMalus: bool) -> void:
	if item.tags.has(Tags.tags.BANANA) && player.team == unitAssociated.team && !isMalus :
		player.addCard("set1:BananaPeel")
