extends AbstractEffect
class_name GodMonkeySpeedEffect


const idEffect = "test:GodMonkeySpeedEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, false, value_A, 0, 0, counter)
	

func onPlacement(tile: AbstractTile) -> void:
	unitsStocked = unitAssociated.player.getUnitsByTag(Tags.tags.MONKEY)
	var effectAdd : AbstractEffect
	for unit: AbstractUnit in unitsStocked :
		#We remove the god Monkey from this effect
		if unit == unitAssociated : 
			unitsStocked.erase(unit)
			continue
		effectAdd = GodMonkeyMinionEffect.new(unit, -1, 0)
		effectAdd.effectAssociated = self
		unit.addEffect(effectAdd)
	updateValue(unitsStocked.size())

func onUnitPlace(unit: AbstractUnit) -> void:
	if(unit.tags.has(Tags.tags.MONKEY) && unit.player.team == unitAssociated.team):
		unitsStocked.append(unit)
		var effectAdd : AbstractEffect = GodMonkeyMinionEffect.new(unit, -1, 0)
		effectAdd.effectAssociated = self
		unit.addEffect(effectAdd)
		updateValue(counter + 1)

func onDeath(unit: AbstractUnit) -> void :
	for _unit: AbstractUnit in unitsStocked :
		#Find effect on each unit and remove it
		1

#newValue == number of Monkey alived
func updateValue(newValue: int) -> void:
	print("fzesd2f")
	if (counter - newValue) == 0 : return
	var speedCgtEffect = SpeedPlusEffect.new(unitAssociated, -1, (newValue - counter) * value_A)
	unitAssociated.addEffect(speedCgtEffect)
	counter = newValue
