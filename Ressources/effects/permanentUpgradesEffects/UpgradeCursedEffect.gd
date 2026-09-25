extends AbstractEffect
class_name UpgradeCursedEffect

const idEffect = "UpgradeCursedEffect"
const img = ""


func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 0, true, 0, 0, 0, 0)
	hideEffect = true

func onStartOfTurn(turnNumber: int, turnColor: TeamsColor.TeamsColor) -> void :
	if turnColor == unitAssociated.team :
		var cursedEnnemy: AbstractUnit = GameManager.getRandomUnits(1, [unitAssociated.team])[0] # TODO Should concern all players allies teams too
		if cursedEnnemy :
			cursedEnnemy.addEffect(CurseEffect.new(cursedEnnemy, 1, 0)) # 0 has no purpose here, curse doesn't require a value
	super.onStartOfTurn(turnNumber, turnColor)


func onEffectEnd() -> void:
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
