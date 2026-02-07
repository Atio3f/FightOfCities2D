extends AbstractUnit
class_name MonkeyMC

const STATS: UnitStats = preload("res://Ressources/units/mainCharacters/monkeys/MonkeyMC.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	#Il faudra un effet switch qui permet de changer d'arme pê à voir si on fait pas une Class MainCharacters
	#Vu que y'a un système de boost de stat va sûrement falloir que je fasse une classe MC
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
