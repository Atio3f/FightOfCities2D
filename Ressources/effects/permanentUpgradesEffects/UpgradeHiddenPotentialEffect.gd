extends AbstractEffect
class_name UpgradeHiddenPotentialEffect

const idEffect = "UpgradeHiddenPotentialEffect"
const img = ""

func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 0, true, 0, 0, 0, 0)
	hideEffect = true

func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
