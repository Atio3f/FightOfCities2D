## Paralysis: voir freeze pour faire la desc
## 
extends AbstractEffect
class_name ParalysisEffect

const idEffect = "set1:ParalysisEffect"
const img = ""
const BASE_AMT = 2 # Base amount of stack to get paralysis
const INCREASED_AMT = 1 # Amount added to the requirement after each paralysis

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	# value_A: Current amount of stacks required to trigger the stun (starts at BASE_AMT)
	# value_B: Number of turns the unit is currently stunned
	if value_A == 0:
		value_A = BASE_AMT
	super._init(idEffect, img, unit, -1, 0, true, value_A, value_B, value_C, counter)

func mergeEffect(effectToMerge: AbstractEffect) -> void:
	counter += effectToMerge.counter
	onEffectApplied(false, effectToMerge)

## When the effect is applied and have enough counter to paralysis
func onEffectApplied(firstTime: bool, oldEffect: AbstractEffect = null) -> void:
	while counter >= value_A:
		counter -= value_A
		value_B += 1
		unitAssociated.speedRemaining = 0
		unitAssociated.atkRemaining = 0
		value_A += INCREASED_AMT

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if value_B > 0 and turnColor == unitAssociated.team:
		unitAssociated.speedRemaining = 0
		unitAssociated.atkRemaining = 0
		value_B -= 1
	super.onStartOfTurn(turnNumber, turnColor)
