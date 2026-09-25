extends AbstractEquipment
class_name Bananarang

## Supposed to be equipabled to non Monkey too, but not the case for the moment
const idItem = "set1:Bananarang"
const img = ""

## MONKEYS deals 2 more damage with Bananarang ability
const BONUS_DMG_MONKEYS: int = 2

var capacity: AbstractCapacity = null

func _init():
	value_A = 6 # Base damage, will be increases by BONUS_DMG_MONKEYS if equipped by a Monkey
	value_B = 33 # % of P from unit, will increases total damage from Bananarang
	super()

func getStatModifiers() -> Dictionary:
	return {"power": 1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	capacity = CapacityDb.CAPACITIES.get("set1:BananarangCapacity").new(unit)
	if capacity : unit.addCapacity(capacity)
	super.onEquip(unit)

func onUnequip() -> void :
	self.unitAssociated.removeCapacity(capacity)

	super.onUnequip()
