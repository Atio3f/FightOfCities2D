class_name MonkeySoap 
extends AbstractTrinket

# All Monkeys gain 2 DR
# Ce nouveau savon aide les Monkey à rendre leur pelage plus épais
const idItem = "set1:MonkeySoap"
const img = "res://assets/sprites/trinkets/MonkeySoap"
const DR_GAIN_MONKEY = 2
const DR_GAIN = 1

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated,DR_GAIN_MONKEY, DR_GAIN)

func onUnitPlace(unit: AbstractUnit) -> void :
	# Give 2 DR to all Monkey placed on our team and 1 DR to other units
	if unit.player == playerAssociated :
		unit.dr += value_A if unit.tags.has(Tags.tags.MONKEY) else value_B
