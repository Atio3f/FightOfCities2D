extends AbstractEquipment
class_name DreadCloak

const idItem = "set1:DreadCloak"
const img = ""
const STEAL_MR_AMT = 1

var _equipped_effect: DreadCloakEffect = null # Serves to remove the effect when unequipping

func getStatModifiers() -> Dictionary:
	return {"hpMax": 3, "power": 2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

func onEquip(unit: AbstractUnit) -> void:
	super.onEquip(unit)
	_equipped_effect = DreadCloakEffect.new(unit, -1, STEAL_MR_AMT)
	unit.addEffect(_equipped_effect)

func onUnequip() -> void:
	if _equipped_effect != null and unitAssociated != null:
		unitAssociated.effects.erase(_equipped_effect)
		_equipped_effect.queue_free()
		_equipped_effect = null
	super.onUnequip()

static func getId() -> String:
	return idItem
