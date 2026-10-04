extends AbstractEquipment
class_name Tomahawk

## Can be equipped by anyone
const idItem = "set1:Tomahawk"
const img = ""

var capacity: AbstractCapacity = null

func _init():
	value_A = 6 # Base damage, will be increases by BONUS_DMG_MONKEYS if equipped by a Monkey
	value_B = 33 # % of P from unit, total damage from Tomahawk capacity
	super()

func getStatModifiers() -> Dictionary:
	return {"dr": -1, "power": 3}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	capacity = CapacityDb.CAPACITIES.get("set1:TomahawkCapacity").new(unit)
	if capacity : unit.addCapacity(capacity)
	super.onEquip(unit)

func onUnequip() -> void :
	self.unitAssociated.removeCapacity(capacity)

	super.onUnequip()
