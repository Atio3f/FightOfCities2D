## Next attack deals +!VA! damage for each attack taken.(Currently +!C!)
extends AbstractEffect
class_name ThunderHelmetEffect

const idEffect = "set1:ThunderHelmetEffect"
const img = ""

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if !visualisation:
		counter += value_A # Stack damage for next attack dealed when attacked
	return damage

func onDamageDealed(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	if !visualisation:
		damage = damage + counter
		counter = 0 # Reset counter when attacking
	return damage
