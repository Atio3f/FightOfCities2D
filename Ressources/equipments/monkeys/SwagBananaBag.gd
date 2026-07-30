extends AbstractEquipment
class_name SwagBananaBag

## TODO Add effect to get a banana at the end of the battle if unit survived (new hide objective, a certain unit must survive)
const idItem = "set1:SwagBananaBag"
const img = ""

func getStatModifiers() -> Dictionary:
	return {"mr": 1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem
