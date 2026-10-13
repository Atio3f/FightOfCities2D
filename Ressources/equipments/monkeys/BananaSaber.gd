extends AbstractEquipment
class_name BananaSaber

const idItem = "set1:BananaSaber"
const img = ""

var _equipped_effect: BananaSaberEffect = null # Serves to remove the effect when unequipping

func getStatModifiers() -> Dictionary:
	return {"power": 3, "speed": 1}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return unit.tags.has(Tags.tags.MONKEY)

func onEquip(unit: AbstractUnit) -> void:
	super.onEquip(unit)
	_equipped_effect = BananaSaberEffect.new(unit, -1, 1)
	unit.addEffect(_equipped_effect)

func onUnequip() -> void:
	if _equipped_effect != null and unitAssociated != null:
		unitAssociated.effects.erase(_equipped_effect)
		_equipped_effect.queue_free()
		_equipped_effect = null
	super.onUnequip()

static func getId() -> String:
	return idItem
