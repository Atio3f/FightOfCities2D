extends AbstractEquipment
class_name MudCharm

const idItem = "set1:MudCharm"
const img = ""

func getStatModifiers() -> Dictionary:
	return {}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem
	
func onEquip(unit: AbstractUnit) -> void :
	var regen = RegenerationEffect.new(unit, -1, 4)
	unit.addEffect(regen)

	super.onEquip(unit)
	
func onUnequip() -> void :
	var regen = RegenerationEffect.new(unitAssociated, -1, -4)
	self.unitAssociated.removeEffect(regen)

	super.onUnequip()
