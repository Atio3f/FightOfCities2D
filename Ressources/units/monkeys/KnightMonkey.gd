extends AbstractUnit
class_name KnightMonkey

const idUnit = "test:KnightMonkey"
const GRADE = 1
const POTENTIAL = 3
const img = ""

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 42, 13, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 1, 5, 1, POTENTIAL, 5)
	var effect1: AbstractEffect = KnightMonkeyEffect.new(unit, -1, 3)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
