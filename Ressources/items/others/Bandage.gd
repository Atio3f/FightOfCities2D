extends AbstractItem
class_name Bandage

const idItem = "set1:Bandage"
const img = ""
const ORB_COST = 0
const DURATION = 3
const HEAL_VALUE = 5

func _init() -> void:
	super()

func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	var effect = BandageEffect.new(unitAssociated, DURATION, HEAL_VALUE)
	unitAssociated.addEffect(effect)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
