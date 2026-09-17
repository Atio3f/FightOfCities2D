extends AbstractEquipment
class_name ChallengeBoots

const idItem = "set1:ChallengeBoots"
const img = ""
# These boots cause enemies to focus you

func _init():
	super()

func getStatModifiers() -> Dictionary:
	return {"hpMax": 5, "dr": 2, "aggro": 3}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	super.onEquip(unit)
	
func onUnequip() -> void :
	super.onUnequip()
