extends AbstractUnit
class_name TemporalSnail

const BASE_ORB_COST = 1
const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/TemporalSnail.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	#Effets à mettre : 
	#Augmentation des dégâts et défense magique en fonction des orbes du joueur associé
	#Gain d'une orbe à chaque kill
	var effect2: AbstractEffect = TemporalSnailKillEffect.new(unit, -1, 1)
	unit.effects.append(effect2)
	#Peut être remis sur le terrain en échange d'une orbe(coût augmente de 1 à chaque fois)
	var effect3: AbstractEffect = TemporalSnailResurrectEffect.new(unit, -1, 100, 0, 0, BASE_ORB_COST)
	unit.effects.append(effect3)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK


#Compliqué d'en faire un pouvoir pour l'instant
# parce qu'il faudrait rajouter getPower pour les effets
## Fonctionnera pas avec la nouvelle méthode de création d'unité on appellera jamais cette fonction
func getPower() -> int:
	return power + player.orbs * 2
