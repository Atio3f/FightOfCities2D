extends AbstractEffect
class_name MonkeyEffect


const idEffect = "test:MonkeyEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, 0, 0)


func onPlacement(tile: AbstractTile) -> void:
	unitsStocked = unitAssociated.player.getUnitsByTag(Tags.tags.MONKEY)
	var effectAdd : AbstractEffect
	var effectAdd2 : AbstractEffect
	for unit: AbstractUnit in unitsStocked :
		effectAdd = PowerPlusEffect.new(unit, -1, value_A)
		unit.addEffect(effectAdd)
		effectAdd2 = SpeedPlusEffect.new(unit, -1, value_B)
		unit.addEffect(effectAdd2)

func onUnitPlace(unit: AbstractUnit) -> void:
	if(unit.tags.has(Tags.tags.MONKEY) && unit.player.team == unitAssociated.team):
		unitsStocked.append(unit)
		var effectAdd : AbstractEffect = PowerPlusEffect.new(unit, -1, value_A)
		unit.addEffect(effectAdd)
		var effectAdd2 : AbstractEffect = SpeedPlusEffect.new(unit, -1, value_B)
		unit.addEffect(effectAdd2)

func onDeath(unit: AbstractUnit) -> void :
	var effectAdd : AbstractEffect
	var effectAdd2 : AbstractEffect
	for _unit: AbstractUnit in unitsStocked :
		effectAdd = PowerPlusEffect.new(_unit, -1, -value_A)
		_unit.addEffect(effectAdd)
		effectAdd2 = SpeedPlusEffect.new(unit, -1, -value_B)
		_unit.addEffect(effectAdd2)
