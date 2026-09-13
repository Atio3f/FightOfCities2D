extends AbstractEffect
class_name SentinelBullEffect

const idEffect = "set1:SentinelBullEffect"
const img = ""
# + value_a damage at 2 tiles from target when attacking

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 100, false, value_A, 0, 0, 0)

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if !visualisation :
		var distance: int = unit.tile.getCoords().distance_squared_to(unitAssociated.tile.getCoords())
		if distance in [2, 4]: # TODO Se demander si on veut que en ligne droite, dans ce cas c'est 4 mais c'est chiant à expliquer dans la descrip
			damage = damage + value_A
		print(unit.tile.getCoords().distance_squared_to(unitAssociated.tile.getCoords()))
	return damage
