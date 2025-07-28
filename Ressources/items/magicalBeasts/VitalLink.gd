extends AbstractItem
class_name VitalLink

const idItem = "test:VitalLink"
const img = ""
const ORB_COST = 0
const HEAL_VALUE = 10
const BONUS_HEAL = 5
 
func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	if unitAssociated.tags.has(Tags.tags.MAGICAL_BEAST) : unitAssociated.healHp(HEAL_VALUE + BONUS_HEAL)
	else : unitAssociated.healHp(HEAL_VALUE)
	
#PAS ENCORE FONCTIONNELLE LA STRUC DES ITEMS
static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.tile.id == "test:ForestTile" && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && unit.hpActual < unit.hpMax: return true
	else :return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
