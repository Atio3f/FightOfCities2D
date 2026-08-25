extends AbstractEquipment
class_name DemonAxe

const idItem = "set1:WarAxe"
const img = ""

func _init():
	super()

func getStatModifiers() -> Dictionary:
	return {"power": 7, "dr": -3}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	super.onEquip(unit)
	
func onUnequip() -> void :
	super.onUnequip()
