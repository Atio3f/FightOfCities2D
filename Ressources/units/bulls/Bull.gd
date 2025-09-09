extends AbstractUnit
class_name Bull

const idUnit = "test:Bull"
const GRADE = 1
const POTENTIAL = 1
const img = "Bull"

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 43, 19, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 8, 5, 0, POTENTIAL, 1)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
