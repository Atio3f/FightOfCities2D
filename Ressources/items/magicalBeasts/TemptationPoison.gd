extends AbstractItem
class_name TemptationPoison
# Deal 8 damage to an enemy and reduces it speed by 4 for 3 turns.

const idItem = "set1:TemptationPoison"
const img = "Monkey"
const ORB_COST = 0
const POISON_BASE_AMT = 6
const WISDOM_STEP = 4 # Diminish poison amt each 4 S from target
 
func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	var poisonAmount: int = POISON_BASE_AMT - (unitAssociated.wisdom / WISDOM_STEP)
	if poisonAmount > 0 :
		var poisonEffect: AbstractEffect = PoisonEffect.new(unitAssociated, -1, poisonAmount)
		unitAssociated.addEffect(poisonEffect)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team != playerUsing.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else :return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
