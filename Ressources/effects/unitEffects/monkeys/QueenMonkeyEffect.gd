extends AbstractEffect
class_name QueenMonkeyEffect


const idEffect = "set1:QueenMonkeyEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, -1, false, value_A, value_B, 0, 0)

func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	#Check melee attack or not, nullify damage if it is
	if unit.tile.getCoords().distance_squared_to(unitAssociated.tile.getCoords()) <= 1 : return damage * (100 - value_A) / 100
	else : return damage
