extends AbstractEquipment
class_name WarAxe

const idItem = "set1:WarAxe"
const img = ""

func _init():
	value_A = 5
	super()

func getStatModifiers() -> Dictionary:
	return {"power": 3}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	var effect = WarAxeEffect.new(unit, -1, value_A)
	unit.addEffect(effect)

	super.onEquip(unit)
	
func onUnequip() -> void :
	var effect = WarAxeEffect.new(unitAssociated, -1, -value_A)
	self.unitAssociated.addEffect(effect)

	super.onUnequip()
