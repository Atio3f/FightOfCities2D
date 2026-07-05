extends AbstractItem
class_name AssaultDroneMonkeyDeployment
# Deploy an assault drone Monkey on an empty tile

const idItem = "set1:AssaultDroneMonkeyDeployment"
const img = "Monkey"
const ORB_COST = 0
 
func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	pass

func applyEffectOnTile(playerAssociated: AbstractPlayer, tileTargeted: AbstractTile) -> void:
	# Place assault drone Monkey at the intend position 
	var droneData: StoredUnit = StoredUnit.new("set1:AssaultDroneMonkey")
	
	Global.gameManager.placeUnit(droneData, playerAssociated, tileTargeted)
	

static func getTargetType() -> ItemTargets.itemTargets :
	return ItemTargets.itemTargets.TILE

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	return false

static func canBeUsedOnTile(playerUsing: AbstractPlayer, tileTargeted: AbstractTile, orbCost: int = ORB_COST) -> bool:
	return tileTargeted != null and !tileTargeted.hasUnitOn() and orbCost <= playerUsing.orbs

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
