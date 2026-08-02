extends AbstractItem
class_name IcyBreeze
# All units lose 3 V for 1 turn. Freeze a random enemy

const idItem = "set1:IcyBreeze"
const img = "Monkey"
const ORB_COST = 0
const SPEED_LOSE_AMT = 3
const SPEED_LOSE_DURATION = 1
 
func applyEffect(playerAssociated: AbstractPlayer, _unitAssociated: AbstractUnit) -> void:
	# Reduce speed of ALL units (allies and enemies)
	for unit: AbstractUnit in GameManager.getAllUnits():
		var effectSpeed: AbstractEffect = SpeedPlusEffect.new(unit, SPEED_LOSE_DURATION, -SPEED_LOSE_AMT)
		unit.addEffect(effectSpeed)

	# Freeze a random enemy unit
	var randomEnemies: Array[AbstractUnit] = GameManager.getRandomUnits(1, [playerAssociated.team]) # Exclude player team
	if randomEnemies.size() > 0:
		var targetEnemy: AbstractUnit = randomEnemies[0]
		var effectFreeze: AbstractEffect = FreezeEffect.new(targetEnemy, 1)
		targetEnemy.addEffect(effectFreeze)

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if super.canBeUsedOnUnit(playerUsing, unit, orbCost) && TurnManager.turn != 0 : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	if super.canBeUsedOnPlayer(playerUsing, playerTargeted, orbCost) && TurnManager.turn != 0 : return true
	else : return false

static func getId() -> String:
	return idItem
