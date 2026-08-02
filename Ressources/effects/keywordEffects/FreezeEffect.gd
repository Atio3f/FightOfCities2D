## Freeze: prevents unit from attacking and moving. If already frozen during this combat, deals 4 damage instead.
## counter = 0: active freeze, counter = 1: immune (already been frozen and unfrozen this combat)
extends AbstractEffect
class_name FreezeEffect

const idEffect = "set1:FreezeEffect"
const img = ""
const REFREEZE_DAMAGE = 4 # In case of freezing a second time an unit, it deals this amount of damage instead of freezing the unit

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

## When the effect is applied for the first time, freeze the unit
func onEffectApplied(firstTime: bool, oldEffect: AbstractEffect = null) -> void:
	if firstTime:
		unitAssociated.speedRemaining = 0
		unitAssociated.atkRemaining = 0

## When a freeze is merged (unit already has freeze effect - active or immune), deal pure damage instead
func mergeEffect(effectToMerge: AbstractEffect) -> void:
	unitAssociated.onDamageTaken(null, REFREEZE_DAMAGE, DamageTypes.DamageTypes.PURE, false)
	# Don't call super - don't accumulate values or turns

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	# Only apply freeze if active (not immune)
	if counter == 0 and turnColor == unitAssociated.team:
		unitAssociated.speedRemaining = 0
		unitAssociated.atkRemaining = 0
		counter = 1 # Avoid getting freeze 2 turns
	super.onStartOfTurn(turnNumber, turnColor)

## When freeze expires, become immune instead of fully removing the effect
func onEffectEnd() -> void:
	counter = 1			# Mark as immune to future freezes
	remainingTurns = -1	# Permanent immunity for the rest of the combat
	hideEffect = true	# Hide from UI since it's just an immunity marker
