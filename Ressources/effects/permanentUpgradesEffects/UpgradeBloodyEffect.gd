extends AbstractEffect
class_name UpgradeBloodyEffect

const idEffect = "UpgradeBloodyEffect"
const img = ""
const HP_BUFF = 2 # Max hp gained each kill
const HEAL_AMT = 4 # Heal on kill


func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 0, true, HP_BUFF, HEAL_AMT, 0, counter)
	hideEffect = true

func onKill(unitKilled: AbstractUnit) -> void :
	if unitAssociated != unitKilled :
		counter += 1 # Faudra trouver un moyen pour connaître le compteur juste pour l'affichage de l'utilité de l'upgrade
		unitAssociated.modifyStat("hpMax", value_A) # Add permanent max hp
		unitAssociated.hpActual += value_B


func onEffectEnd() -> void:
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
