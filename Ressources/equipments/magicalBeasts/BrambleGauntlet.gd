extends AbstractEquipment
class_name BrambleGauntlet

const idItem = "set1:BrambleGauntlet"
const img = ""
const DAMAGE_BONUS = 4
const SPEED_MALUS = -3
const SPEED_MALUS_DURATION = 2

var _equipped_effect: BrambleGauntletEffect = null # Serves to remove the effect when unequipping

func getStatModifiers() -> Dictionary:
	return {}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return unit.tags.has(Tags.tags.MAGICAL_BEAST)

func onEquip(unit: AbstractUnit) -> void:
	super.onEquip(unit)
	_equipped_effect = BrambleGauntletEffect.new(unit, -1, DAMAGE_BONUS, SPEED_MALUS, SPEED_MALUS_DURATION)
	unit.addEffect(_equipped_effect)

func onUnequip() -> void:
	if _equipped_effect != null and unitAssociated != null:
		unitAssociated.effects.erase(_equipped_effect)
		_equipped_effect.queue_free()
		_equipped_effect = null
	super.onUnequip()

static func getId() -> String:
	return idItem
