extends AbstractItem
class_name VitalLink

const idItem = "set1:VitalLink"
const img = "Monkey"
const ORB_COST = 0
const HEAL_VALUE = 14
const BONUS_HEAL = 6
func _init() -> void:
	value_A = HEAL_VALUE
	value_B = HEAL_VALUE + BONUS_HEAL
	super()

func applyPositiveEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	var healAmt: int = value_B if unitAssociated.tags.has(Tags.tags.MAGICAL_BEAST) else value_A
	unitAssociated.healHp(healAmt * multiplier)


static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.tile.id == "set1:ForestTile" && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && unit.hpActual < unit.hpMax: return true
	else :return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
