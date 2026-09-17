extends AbstractEffect
class_name UpgradeWasteTreatmentEffect

const idEffect = "UpgradeWasteTreatmentEffect"
const img = ""
const HEAL_ON_ITEM = 6
# On item used : heal 6 HP
func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 1, true, HEAL_ON_ITEM, 0, 0, 0)
	hideEffect = true

func onItemUsed(player: AbstractPlayer, item: AbstractItem, isMalus: bool) -> void:
	if player.team == unitAssociated.team :
		var final_heal: int = unitAssociated.onHealed(unitAssociated, value_A)
		unitAssociated.healHp(final_heal)
	return

func onEffectEnd() -> void:
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
