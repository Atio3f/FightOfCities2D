extends AbstractUnit
class_name WingedBull

const idUnit = "set1:WingedBull"
const GRADE = 2
const POTENTIAL = 3
const img = ""
static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 40, 19, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 8, 3, 4, POTENTIAL, 3)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.FLYING]
	unit.actualMovementTypes = MovementTypes.movementTypes.FLYING
