extends AbstractEffect
class_name BananaSaberEffect

const idEffect = "set1:BananaSaberEffect"
const img = ""

## Items with this tag are the only with 
var target_tag: Tags.tags = Tags.tags.BANANA

func _init(unit: AbstractUnit, remainingTurns: int = -1, value_A: int = 1, value_B: int = 0, value_C: int = 0, counter: int = 0):
	# value_A sert de bonus au multiplicateur (+1 pour doubler)
	super._init(idEffect, img, unit, remainingTurns, 0, false, value_A, value_B, value_C, counter)
	target_tag = Tags.tags.BANANA

func onItemUsed(player: AbstractPlayer, item: AbstractItem, isMalus: bool) -> void:
	if isMalus or unitAssociated == null or unitAssociated.isDead:
		return
		
	# Check if item has tag
	if not item.tags.has(target_tag):
		return
		
	# Add to the item's positive multiplier (1 base + value_A)
	item.positiveMultiplier += value_A
