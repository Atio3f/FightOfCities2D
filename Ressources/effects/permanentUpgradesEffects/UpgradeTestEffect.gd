extends AbstractEffect
class_name UpgradeTestEffect

const idEffect = "UpgradeTestEffect"
const img = ""
const ATK_BUFF = 4
const DR_BUFF = 2


func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 0, true, ATK_BUFF, DR_BUFF, 0, 0)
	hideEffect = true
	
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null):
	#print("Boost power pour "+unitAssociated.uid)
	unitAssociated.power += value_A
	unitAssociated.dr += value_B
	#print(unitAssociated.getPower())


func onEffectEnd() -> void:
	unitAssociated.power -= value_A
	unitAssociated.dr -= value_B
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
