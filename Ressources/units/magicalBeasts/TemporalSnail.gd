extends AbstractUnit
class_name TemporalSnail

const idUnit = "test:TemporalSnail"
const GRADE = 4
const POTENTIAL = 5
const img = ""
const BASE_ORB_COST = 1

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 40, 3, DamageTypes.DamageTypes.MAGICAL, 1, 1, 4, 5, 0, POTENTIAL, 25)
	
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
##Fonctionnera pas avec la nouvelle méthode de création d'unité on appellera jamais cette fonction
func getPower() -> int:
	return power + player.orbs * 2
