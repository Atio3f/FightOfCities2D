extends AbstractEquipment
class_name WoodlandDoll

const idItem = "set1:WoodlandDoll"
const img = ""

func _init():
	value_A = 3
	super()

func getStatModifiers() -> Dictionary:
	return {"hpMax": 9}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	var effect = ThornsEffect.new(unit, -1, value_A)
	unit.addEffect(effect)

	super.onEquip(unit)

func onUnequip() -> void :
	var effect = ThornsEffect.new(unitAssociated, -1, -value_A)
	self.unitAssociated.addEffect(effect)

	super.onUnequip()
