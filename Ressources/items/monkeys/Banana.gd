extends AbstractItem
class_name Banana
# Give 3 P and 3 V for 2 turns and heal 5 HP. Give +1 P and V and heal 1 more on Monkeys. 

const idItem = "set1:Banana"
const img = "Monkey"
const ORB_COST = 0
const POWER_BOOST_AMT = 3
#const SPEED_BOOST_AMT = 3
const BOOST_DURATION = 2
const HEAL_VALUE = 5
const MONKEY_STATS_BUFF = 1 # Vu que c'est 3 et 3, 1 et 1 on fusionne en une value_ pour rendre l'affichage dynamique
#const MONKEY_HEAL_BUFF = 1

func _init() -> void:
	tags.append(Tags.tags.FOOD)
	tags.append(Tags.tags.BANANA)
	value_A = POWER_BOOST_AMT
	value_B = HEAL_VALUE
	value_C = MONKEY_STATS_BUFF
	super()

func applyPositiveEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	# Add buffs to unit
	var speedBoost: int = value_A
	var powerBoost: int = value_A
	var healAmt: int = value_B
	# Stronger buffs for monkeys
	if unitAssociated.tags.has(Tags.tags.MONKEY):
		speedBoost += value_C
		powerBoost += value_C
		healAmt += value_C
	var effectSpeed: AbstractEffect = SpeedPlusEffect.new(unitAssociated, BOOST_DURATION, speedBoost * multiplier)
	unitAssociated.addEffect(effectSpeed)
	var effectPower: AbstractEffect = PowerPlusEffect.new(unitAssociated, BOOST_DURATION, powerBoost * multiplier)
	unitAssociated.addEffect(effectPower)
	# Heal unit
	unitAssociated.healHp(healAmt * multiplier)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
