extends AbstractEquipment
class_name VampiricFangs

const idItem = "set1:VampiricFangs"
const img = ""

func _init():
	value_A = 25 # LifeSteal %
	super()

func getStatModifiers() -> Dictionary:
	return {"power": 2}

func canBeEquippedBy(unit: AbstractUnit) -> bool:
	return true

static func getId() -> String:
	return idItem

func onEquip(unit: AbstractUnit) -> void :
	var effect = LifeStealEffect.new(unit, -1, value_A)
	unit.addEffect(effect)
	super.onEquip(unit)
	
func onUnequip() -> void :
	var effect = LifeStealEffect.new(self.unitAssociated, -1, -value_A)
	self.unitAssociated.addEffect(effect)
	super.onUnequip()
