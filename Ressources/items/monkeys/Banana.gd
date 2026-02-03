extends AbstractItem
class_name Banana
# Give 3 P and 3 V for 2 turns and heal 5 HP. Give +1 P and V and heal 1 more on Monkeys. 

const idItem = "set1:Banana"
const img = "Monkey"
const ORB_COST = 0
const POWER_BOOST_AMT = 3
const SPEED_BOOST_AMT = 3
const BOOST_DURATION = 2
const HEAL_VALUE = 5
const MONKEY_STATS_BUFF = 1
const MONKEY_HEAL_BUFF = 1

func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	# Add buffs to unit
	var speedBoost: int = SPEED_BOOST_AMT
	var powerBoost: int = POWER_BOOST_AMT
	var healAmt: int = HEAL_VALUE
	# Stronger buffs for monkeys
	if (unitAssociated.tags.has(Tags.tags.MONKEY)) :
		speedBoost += MONKEY_STATS_BUFF
		powerBoost += MONKEY_STATS_BUFF
		healAmt += MONKEY_HEAL_BUFF
	var effectSpeed: AbstractEffect = SpeedPlusEffect.new(unitAssociated, BOOST_DURATION, speedBoost)
	unitAssociated.addEffect(effectSpeed)
	var effectPower: AbstractEffect = PowerPlusEffect.new(unitAssociated, BOOST_DURATION, powerBoost)
	unitAssociated.addEffect(effectPower)
	# Heal unit
	unitAssociated.healHp(healAmt)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
