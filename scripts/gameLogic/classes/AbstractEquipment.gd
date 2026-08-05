### Equipments are a type of item that can be equipped to all units 
class_name AbstractEquipment extends AbstractItem

## Marker to identify equipment on ItemDb list, used in PlayerHand.addCard
static var IS_EQUIPMENT: bool = true

static var rarity: RarityData # All data about equipment rarity

var counter2: int #Can be used to increment a value, will be used to increment a value

func _init() -> void:
	super()

## Returns the equipment modifiers, redefine on subclass to add modifiers list
func getStatModifiers() -> Dictionary:
	assert(false, "getStatModifiers() should be implemented in the subclass "+ self.name)
	return {}

## Check if the equipment can be equipped by the unit, maybe will be use on some equipments to limit species or stats
func canBeEquippedBy(unit: AbstractUnit) -> bool :
	return true

## Equip the equipment to the unit, manage stat changes
func onEquip(unit: AbstractUnit) -> void:
	unitAssociated = unit
	unitAssociated.addStatModifiers(getStatModifiers(), true)

## Unequip the equipment from the unit, manage stat changes
func onUnequip() -> void:
	if unitAssociated != null:
		unitAssociated.addStatModifiers(getStatModifiers(), false)
	unitAssociated = null
