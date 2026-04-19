extends AbstractItem
class_name AssaultDroneMonkeyDeployment
# Deploy an assault drone Monkey on an empty tile

const idItem = "set1:AssaultDroneMonkeyDeployment"
const img = "Monkey"
const ORB_COST = 0
 
func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	pass

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	return unit != null

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
