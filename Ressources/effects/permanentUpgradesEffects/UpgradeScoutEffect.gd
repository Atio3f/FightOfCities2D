extends AbstractEffect
class_name UpgradeScoutEffect

const idEffect = "UpgradeScoutEffect"
const img = ""
const HP_BUFF = 3
const HEAL_AMT = 1 # Heal for each tile travelled


func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 0, true, HP_BUFF, HEAL_AMT, 0, 0)
	hideEffect = true
	
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null):
	#print("Boost power pour "+unitAssociated.uid)
	unitAssociated.hpMax += value_A
	unitAssociated.hpActual += value_A
	#print(unitAssociated.getPower())

func onMovement() -> void:
	unitAssociated.healHp(unitAssociated.onHealed(null, value_B))
	# On va avoir un souci ici parce qu'il faudrait qu'on mémorise combien de cases l'unité emprunte


func onEffectEnd() -> void:
	unitAssociated.power -= value_A
	unitAssociated.dr -= value_B
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
