extends AbstractItem
class_name SpiritualCurse

const idItem = "set1:SpiritualCurse"
const img = "SpiritualCurse"
const ORB_COST = 1

func _init() -> void:
	super()

func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	var curseEffect = CurseEffect.new(unitAssociated, -1, 0)
	unitAssociated.addEffect(curseEffect)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	# Target can be any unit
	if TurnManager.actualTurn() == playerUsing.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead && unit.team != playerUsing.team: 
		return true
	return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
