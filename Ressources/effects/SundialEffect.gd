extends AbstractEffect
class_name SundialEffect

const idEffect = "set1:SundialEffect"
const img = ""

var current_power: int = 0
var current_def: int = 0

func _init(unit: AbstractUnit, remainingTurns: int = -1, value_A: int = 3, value_B: int = 1, value_C: int = 0, counter: int = 0):
	# value_A: Bonus Puissance tours impairs (3)
	# value_B: Bonus DR et MR tours pairs (1)
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func mergeEffect(effectToMerge: AbstractEffect) -> void:
	value_A += effectToMerge.value_A
	value_B += effectToMerge.value_B
	_update_stats()
	onEffectApplied(false, effectToMerge)

func onPlacement(_tile: AbstractTile) -> void:
	_update_stats()

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	super.onStartOfTurn(turnNumber, turnColor)
	if unitAssociated != null and turnColor == unitAssociated.team:
		_update_stats()

func onEffectEnd() -> void:
	if unitAssociated != null:
		unitAssociated.power -= current_power
		unitAssociated.dr -= current_def
		unitAssociated.mr -= current_def
	super.onEffectEnd()

static func get_current_round() -> int:
	if TurnManager.turn <= 0:
		return 1
	return ((TurnManager.turn - 1) / max(1, TurnManager.teams.size())) + 1

func _update_stats() -> void:
	if unitAssociated == null:
		return
	# Calc stats changed : Power on odd turns, DR and MR on even turns
	var is_odd: bool = (get_current_round() % 2 == 1)
	var target_power: int = value_A if is_odd else 0
	var target_def: int = 0 if is_odd else value_B

	unitAssociated.power += target_power - current_power
	unitAssociated.dr += target_def - current_def
	unitAssociated.mr += target_def - current_def

	current_power = target_power
	current_def = target_def
