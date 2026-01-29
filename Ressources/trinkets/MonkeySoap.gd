class_name MonkeySoap 
extends AbstractTrinket

# All Monkeys gain 2 DR
# Ce nouveau savon aide les Monkey à rendre leur pelage plus épais
const idItem = "set1:MonkeySoap"
const img = "res://assets/sprites/trinkets/ArtOfWar"
const DR_GAIN = 2

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, DR_GAIN)

func onUnitPlace(unit: AbstractUnit) -> void :
	# Give DR to all Monkey placed on our team
	if unit.player == playerAssociated && unit.tags.has(Tags.tags.MONKEY):
		unit.dr += value_A
