extends AbstractEffect
class_name UpgradeFortuneWheelEffect

const idEffect = "UpgradeFortuneWheelEffect"
const img = ""
const DR_GAIN = 2
const POWER_GAIN = 2
const SPEED_GAIN = 2
# At the start of battle, give +2 DR, +3 P and +2 V to a random ally (itself included)
func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 1, true, DR_GAIN, POWER_GAIN, SPEED_GAIN, 0)
	hideEffect = true

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void:
	if turnNumber == 1 :
		var unitToBuff: AbstractUnit = GameManager.getRandomUnits(1, [], unitAssociated.team)[0]
		var drGainEffect: AbstractEffect = DRPlusEffect.new(unitToBuff, -1, value_A)
		var powerGainEffect: AbstractEffect = PowerPlusEffect.new(unitToBuff, -1, value_B)
		var speedGainEffect: AbstractEffect = SpeedPlusEffect.new(unitToBuff, -1, value_C)
		unitToBuff.addEffect(drGainEffect)
		unitToBuff.addEffect(powerGainEffect)
		unitToBuff.addEffect(speedGainEffect)
	return

func onEffectEnd() -> void:
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
