extends AbstractEquipment
class_name HiddenBlade

const idItem = "set1:HiddenBlade"
const img = ""

var capacity: AbstractCapacity = null

func _init() -> void:
	value_A = 3 # Paralysis amt from capacity
	value_B = 80 # % of P from unit, total damage from HiddenBlade capacity
	super()

func getStatModifiers() -> Dictionary:
	return {"power": 3, "speed": 1}

func canBeEquippedBy(unitTargeted: AbstractUnit) -> bool:
	return unitTargeted.tags.has(Tags.tags.MONKEY)

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void:
	capacity = CapacityDb.CAPACITIES.get("set1:HiddenBladeCapacity").new(unit)
	if capacity : unit.addCapacity(capacity)
	super.onEquip(unit)

func onUnequip() -> void:
	self.unitAssociated.removeCapacity(capacity)

	super.onUnequip()
