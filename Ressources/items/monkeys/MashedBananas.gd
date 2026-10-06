extends AbstractItem
class_name MashedBananas

const idItem = "set1:MashedBananas"
const img = "MashedBananas"
const ORB_COST = 0
const DURATION = 3

func _init() -> void:
	tags.append(Tags.tags.FOOD)
	tags.append(Tags.tags.BANANA)
	super()

func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	var endureEffect = MashedBananasEffect.new(unitAssociated, DURATION, 1)
	unitAssociated.addEffect(endureEffect)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : 
		if unit.tags.has(Tags.tags.MONKEY):
			return true
	return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
