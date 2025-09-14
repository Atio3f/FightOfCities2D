extends AbstractUnit
class_name QueenMonkey

const idUnit = "set1:QueenMonkey"
const GRADE = 3
const POTENTIAL = 4
const img = "Monkey"

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 21, 6, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 6, 0, 0, POTENTIAL, 13)
	var effect1: AbstractEffect = QueenMonkeyEffect.new(unit, -1, 100)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
