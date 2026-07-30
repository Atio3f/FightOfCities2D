extends AbstractEquipment
class_name CoolCapMonkey

## Supposed to be equipabled to non Monkey too, but not the case for the moment
const idItem = "set1:CoolCapMonkey"
const img = ""

func getStatModifiers() -> Dictionary:
	return {"hpMax": 5, "dr": 1, "speed": 1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return unit.tags.has(Tags.tags.MONKEY)

static func getId() -> String:
	return idItem
