extends AbstractEquipment
class_name SplinteringMallet

## Have a capacity that deals a lot of damage but breaks the mallet
const idItem = "set1:SplinteringMallet"
const img = ""

var capacity: AbstractCapacity = null

func _init():
	value_A = 8 # Base damage
	value_B = 10 # % of P from unit, will increases total damage from Splintering Mallet
	super()

func getStatModifiers() -> Dictionary:
	return {"power": 2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	capacity = CapacityDb.CAPACITIES.get("set1:SplinteringMalletCapacity").new(unit)
	if capacity : unit.addCapacity(capacity)
	super.onEquip(unit)

func onUnequip() -> void :
	self.unitAssociated.removeCapacity(capacity)

	super.onUnequip()
