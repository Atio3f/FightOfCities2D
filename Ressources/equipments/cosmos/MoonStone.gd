extends AbstractEquipment
class_name MoonStone

const idItem = "set1:MoonStone"
const img = ""

func getStatModifiers() -> Dictionary:
	return {"hpMax": 2, "mr": 2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem
