extends AbstractEquipment
class_name HarpyBardiche

const idItem = "set1:HarpyBardiche"
const img = ""

func _init():
	value_A = 50
	super()

func getStatModifiers() -> Dictionary:
	return {"power": -1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	var effect = CADOEffect.new(unit, -1, value_A)
	unit.addEffect(effect)

	super.onEquip(unit)
	
func onUnequip() -> void :
	var effect = CADOEffect.new(unitAssociated, -1, -value_A)
	self.unitAssociated.addEffect(effect)

	super.onUnequip()
