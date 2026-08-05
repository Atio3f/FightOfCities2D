extends AbstractEquipment
class_name BouquetOfLies

const idItem = "set1:BouquetOfLies"
const img = ""
const CONVERT_RATIO = 70
const RICOCHETS = 2
const RICOCHET_CONVERT_RATIO = 30
const LOST_HP_MAX_PER_HIT = 5

func _init():
	value_A = CONVERT_RATIO
	value_B = RICOCHETS
	value_C = RICOCHET_CONVERT_RATIO
	counter = LOST_HP_MAX_PER_HIT
	super()

func getStatModifiers() -> Dictionary:
	return {"mr": 1, "power": -2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void:
	var effect = BouquetOfLiesEffect.new(unit, -1, value_A, value_B, value_C, counter)
	unit.addEffect(effect)

	super.onEquip(unit)

func onUnequip() -> void:
	var effect = BouquetOfLiesEffect.new(unitAssociated, -1, -value_A, -value_B, -value_C, -counter)
	self.unitAssociated.addEffect(effect)

	super.onUnequip()
