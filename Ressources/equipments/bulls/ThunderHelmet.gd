extends AbstractEquipment
class_name ThunderHelmet

const idItem = "set1:ThunderHelmet"
const img = ""

func _init():
	value_A = 2
	super()

func getStatModifiers() -> Dictionary:
	return {"dr": 2, "speed": 2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	var effect = ThunderHelmetEffect.new(unit, -1, value_A)
	unit.addEffect(effect)

	super.onEquip(unit)
	
func onUnequip() -> void :
	var effect = ThunderHelmetEffect.new(unitAssociated, -1, -value_A)
	self.unitAssociated.addEffect(effect)

	super.onUnequip()
