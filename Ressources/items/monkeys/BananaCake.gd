extends AbstractItem
class_name BananaCake

const idItem = "set1:BananaCake"
const img = "BananaCake"
const ORB_COST = 0
const POWER_BOOST_AMT = 3
const SPEED_DEBUFF_AMT = -5 # Only for non Monkeys
const BOOST_DURATION = 5
const HEAL_VALUE = 10

func _init() -> void:
	value_A = POWER_BOOST_AMT
	value_B = SPEED_DEBUFF_AMT
	value_C = HEAL_VALUE
	tags.append(Tags.tags.FOOD)
	tags.append(Tags.tags.BANANA)
	super()

func applyPositiveEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	# Heal unit
	unitAssociated.healHp(HEAL_VALUE * multiplier)
	
	# Power +3
	var effectPower: AbstractEffect = PowerPlusEffect.new(unitAssociated, BOOST_DURATION, POWER_BOOST_AMT * multiplier)
	unitAssociated.addEffect(effectPower)

func applyNegativeEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	# Speed -5 if not Monkey
	if not unitAssociated.tags.has(Tags.tags.MONKEY):
		var effectSpeed: AbstractEffect = SpeedPlusEffect.new(unitAssociated, BOOST_DURATION, SPEED_DEBUFF_AMT * multiplier)
		unitAssociated.addEffect(effectSpeed)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
