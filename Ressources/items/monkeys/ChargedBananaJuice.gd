extends AbstractItem
class_name ChargedBananaJuice

const idItem = "set1:ChargedBananaJuice"
const img = "VitalLink"
const ORB_COST = 0
const SPEED_MALUS = 3

func _init() -> void:
	tags.append(Tags.tags.FOOD)
	tags.append(Tags.tags.BANANA)
	value_A = 80
	value_B = SPEED_MALUS
	super()

func applyPositiveEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	# Restore 80% of max V
	var restoredV = int(round(float(unitAssociated.speed) * (float(value_A) / 100.0))) * multiplier
	unitAssociated.speedRemaining += restoredV # Peut dépasser la valeur V de l'unité

func applyNegativeEffects(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit, multiplier: int = 1) -> void:
	# If not Monkey, -3 V for the rest of combat
	if not unitAssociated.tags.has(Tags.tags.MONKEY):
		var effectSpeed = SpeedPlusEffect.new(unitAssociated, -1, -value_B * multiplier)
		unitAssociated.addEffect(effectSpeed)
		unitAssociated.speedRemaining += value_B * multiplier

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.team == playerUsing.team && TurnManager.actualTurn() == unit.team && super.canBeUsedOnUnit(playerUsing, unit, orbCost) && !unit.isDead : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false

static func getId() -> String:
	return idItem
