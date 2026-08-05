extends AbstractEquipment
class_name MudCharm

const idItem = "set1:MudCharm"
const img = ""

func _init():
	value_A = 6
	super()

func getStatModifiers() -> Dictionary:
	return {}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem
	
func onEquip(unit: AbstractUnit) -> void :
	var regen = RegenerationEffect.new(unit, -1, value_A)
	unit.addEffect(regen)

	super.onEquip(unit)
	
func onUnequip() -> void :
	var regen = RegenerationEffect.new(unitAssociated, -1, -value_A)
	self.unitAssociated.addEffect(regen)

	super.onUnequip()
