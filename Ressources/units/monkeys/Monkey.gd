extends AbstractUnit
class_name Monkey

const idUnit = "set1:Monkey"
const GRADE = 1
const POTENTIAL = 3
const img = "Monkey"

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 23, 6, DamageTypes.DamageTypes.PHYSICAL, 1, 2, 6, 1, 3, POTENTIAL, 9)
	var effect1: AbstractEffect = MonkeyEffect.new(unit, -1, 3, 1)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
