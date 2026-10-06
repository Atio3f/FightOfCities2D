extends AbstractEquipment
class_name Scope

const idItem = "set1:Scope"
const img = "Scope"

func _init():
	super()

func getStatModifiers() -> Dictionary:
	return {"range": 1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	if unit.baseStats.attackRange <= 1:
		return false
	return true

static func getId() -> String:
	return idItem
