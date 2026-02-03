extends AbstractItem
class_name BananaPeel
# Deal 8 damage to an enemy and reduces it speed by 4 for 3 turns.

const idItem = "set1:BananaPeel"
const img = "Monkey"
const ORB_COST = 0
const DMG_VALUE = 8
const SPEED_LOSE_AMT = 4
const SPEED_LOSE_DURATION = 3
 
func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	unitAssociated.onDamageTaken(null, DMG_VALUE, DamageTypes.DamageTypes.PHYSICAL, false)
	var effectSpeed: AbstractEffect = SpeedPlusEffect.new(unitAssociated, SPEED_LOSE_DURATION, -SPEED_LOSE_AMT)
	unitAssociated.addEffect(effectSpeed)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team != playerUsing.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else :return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
