extends AbstractUnit
class_name MonkeyMC

const idUnit = "set1:MonkeyMC"
const GRADE = 0
const POTENTIAL = 0
const img = "Monkey"

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 37, 12, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 5, 4, 1, POTENTIAL, 13)
	#Il faudra un effet switch qui permet de changer d'arme pê à voir si on fait pas une Class MainCharacters
	#Vu que y'a un système de boost de stat va sûrement falloir que je fasse une classe MC
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
