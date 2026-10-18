extends AbstractEffect
class_name JellyfishSensEffect

const idEffect = "set1:JellyfishSensEffect"
const img = ""

var has_triggered_this_turn: bool = false

func _init(unit: AbstractUnit, remainingTurns: int = -1, value_A: int = 1, value_B: int = 0, value_C: int = 0, counter: int = 0):
	# value_A: amount of Paralysis applied to attacker (defaults to 1)
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onPlacement(_tile: AbstractTile) -> void:
	has_triggered_this_turn = false

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	super.onStartOfTurn(turnNumber, turnColor)
	if unitAssociated != null and turnColor == unitAssociated.team:
		has_triggered_this_turn = false

func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	if visualisation:
		return damage
	if unit == null or unit.isDead:
		return damage
	if damageType == DamageTypes.DamageTypes.THORNS:
		return damage
	if unitAssociated == null or unit.team == unitAssociated.team:
		return damage

	if has_triggered_this_turn:
		return damage

	has_triggered_this_turn = true

	var paralysis_effect = ParalysisEffect.new(unit, -1, 0, 0, 0, value_A)
	unit.addEffect(paralysis_effect)

	return damage
