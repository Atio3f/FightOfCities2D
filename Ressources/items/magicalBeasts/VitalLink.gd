extends AbstractItem
class_name VitalLink

const idItem = "set1:VitalLink"
const img = "Monkey"
const ORB_COST = 0
const HEAL_VALUE = 10
const BONUS_HEAL = 5
 
func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	if unitAssociated.tags.has(Tags.tags.MAGICAL_BEAST) : unitAssociated.healHp(HEAL_VALUE + BONUS_HEAL)
	else : unitAssociated.healHp(HEAL_VALUE)


static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.tile.id == "set1:ForestTile" && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && unit.hpActual < unit.hpMax: return true
	else :return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
