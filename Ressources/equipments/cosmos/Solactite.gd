extends AbstractEquipment
class_name Solactite

const idItem = "set1:Solactite"
const img = ""

var capacity: AbstractCapacity = null

func getStatModifiers() -> Dictionary:
	return {"power": -2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	capacity = CapacityDb.CAPACITIES.get("set1:SolactiteCapacity").new(unit)
	if capacity : unit.addCapacity(capacity)
	super.onEquip(unit)

func onUnequip() -> void :
	self.unitAssociated.removeCapacity(capacity)

	super.onUnequip()
