extends AbstractUnit
class_name TemporalSnail

const idUnit = "test:TemporalSnail"
const GRADE = 4
const POTENTIAL = 5
const img = ""
const BASE_ORB_COST = 1

func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 40, 3, DamageTypes.DamageTypes.MAGICAL, 1, 1, 4, 5, 0, POTENTIAL, 25)
	
	#Effets à mettre : 
	#Augmentation des dégâts et défense magique en fonction des orbes du joueur associé
	#Gain d'une orbe à chaque kill
	var effect2: AbstractEffect = TemporalSnailKillEffect.new(self, -1, 1)
	effects.append(effect2)
	#Peut être remis sur le terrain en échange d'une orbe(coût augmente de 1 à chaque fois)
	var effect3: AbstractEffect = TemporalSnailResurrectEffect.new(self, -1, 100, 0, 0, BASE_ORB_COST)
	effects.append(effect3)
	tags.append(Tags.tags.MAGICAL_BEAST)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK


#Compliqué d'en faire un pouvoir pour l'instant
# parce qu'il faudrait rajouter getPower pour les effets
func getPower() -> int:
	return power + player.orbs * 2
