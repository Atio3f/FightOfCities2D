extends AbstractEffect
class_name UpgradeAgilityEffect

const idEffect = "UpgradeAgilityEffect"
const img = ""
const SPEED_BUFF = 4
const DODGE_CHANCE = 2


func _init(unit: AbstractUnit):
	super._init(idEffect, img, unit, remainingTurns, 0, true, SPEED_BUFF, DODGE_CHANCE, 0, 0)
	hideEffect = true
	
func onEffectApplied(firstTime: bool, oldEffect:AbstractEffect = null):
	#print("Boost power pour "+unitAssociated.uid)
	unitAssociated.speed += value_A
	unitAssociated.speedRemaining += value_A
	# Séparer dans un autre effet le dodge je pense pour permettre le stack et de pouvoir l'afficher
	

func onEffectEnd() -> void:
	unitAssociated.speed -= value_A
	unitAssociated.speedRemaining -= value_A
	
	# TODO Part with dodge chance
	
	unitAssociated.effects.erase(self)
	self.queue_free()


func registerEffect() -> Dictionary:
	return {} # Pas besoin d'enregistrer les effets permanents comme ça, on les récupère avec la liste enregistrée des bonus
