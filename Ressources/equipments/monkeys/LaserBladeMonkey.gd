extends AbstractEquipment
class_name LaserBladeMonkey

const idItem = "set1:LaserBladeMonkey"
const img = ""

func getStatModifiers() -> Dictionary:
	return {"power": 2, "speed": 1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return unit.tags.has(Tags.tags.MONKEY)

static func getId() -> String:
	return idItem
