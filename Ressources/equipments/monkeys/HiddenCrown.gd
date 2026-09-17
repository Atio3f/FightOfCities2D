extends AbstractEquipment
class_name HiddenCrown
# RARE
# Help to control everything without getting targeted
const idItem = "set1:HiddenCrown"
const img = ""

var _equipped_effect: DreadCloakEffect = null # Serves to remove the effect when unequipping

func getStatModifiers() -> Dictionary:
	return {"hpMax": 2, "mr": 2, "aggro": -3}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem
