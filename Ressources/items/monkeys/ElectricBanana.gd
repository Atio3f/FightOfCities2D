extends AbstractItem
class_name ElectricBanana

const idItem = "set1:ElectricBanana"
const img = "ElectricBanana"
const ORB_COST = 0

func _init() -> void:
	tags.append(Tags.tags.FOOD)
	tags.append(Tags.tags.BANANA)
	super()

func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	# +2 V pendant 4 tours
	var speedEffect = SpeedPlusEffect.new(unitAssociated, 4, 2)
	unitAssociated.addEffect(speedEffect)
	
	# Les attaques infligent 1 de paralysie pendant 4 tours
	var paralysisOnHitEffect = OnHitApplyStatusEffect.new(unitAssociated, 4, 1, 0, 0)
	unitAssociated.addEffect(paralysisOnHitEffect)
	
	# Soigne 5 PV si Monkey
	if unitAssociated.tags.has(Tags.tags.MONKEY):
		unitAssociated.healHp(5)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
