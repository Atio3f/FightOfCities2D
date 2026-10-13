extends AbstractItem
class_name ElectricBanana

const idItem = "set1:ElectricBanana"
const img = "ElectricBanana"
const ORB_COST = 0

const SPEED_AMT = 2
const PARALYSIS_AMT = 1
const MONKEY_HEAL_AMT = 5

func _init() -> void:
	value_A = SPEED_AMT
	value_B = PARALYSIS_AMT
	value_C = MONKEY_HEAL_AMT
	tags.append(Tags.tags.FOOD)
	tags.append(Tags.tags.BANANA)
	super()

func applyPositiveEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	# +value_A V pendant 4 tours
	var speedEffect = SpeedPlusEffect.new(unitAssociated, 4, value_A * multiplier)
	unitAssociated.addEffect(speedEffect)
	
	# Les attaques infligent value_B de paralysie pendant 4 tours
	var paralysisOnHitEffect = OnHitApplyStatusEffect.new(unitAssociated, 4, value_B * multiplier, 0, 0)
	unitAssociated.addEffect(paralysisOnHitEffect)
	
	# Heal value_C Monkey
	if unitAssociated.tags.has(Tags.tags.MONKEY):
		unitAssociated.healHp(value_C * multiplier)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
