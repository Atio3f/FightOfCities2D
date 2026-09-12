extends AbstractEffect
class_name UpgradeFragileEffect

const idEffect = "UpgradeFragileEffect"
const img = ""
const DR_LOSE = 2
# Lose value_A DR when attacked
func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 1, true, DR_LOSE, 0, 0, 0)
	hideEffect = false # We need to see effect desc for this one

func onDamageTaken(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int :
	var result = super.onDamageTaken(unit, damage, damageType, visualisation)
	if !visualisation : 
		unitAssociated.dr -= value_A
	return result


func onEffectEnd() -> void:
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
