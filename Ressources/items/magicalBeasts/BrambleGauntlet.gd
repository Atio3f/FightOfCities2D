extends AbstractItem
class_name BrambleGauntlet

const idItem = "test:BrambleGauntlet"
const img = ""
const ORB_COST = 0
const DAMAGE_BONUS = 2
const SPEED_MALUS = -3
const SPEED_MALUS_DURATION = 2

func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	var effect: AbstractEffect = BrambleGauntletEffect.new(unitAssociated, -1, DAMAGE_BONUS, SPEED_MALUS, SPEED_MALUS_DURATION)
	unitAssociated.addEffect(effect)


static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if unit.tags.has(Tags.tags.MAGICAL_BEAST) && super.canBeUsedOnUnit(playerUsing, unit, orbCost): return true
	else :return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
