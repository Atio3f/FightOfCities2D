extends AbstractUnit
class_name AbominationMonkey

const idUnit = "test:AbominationMonkey"
const GRADE = 2
const POTENTIAL = 2
const img = ""
static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 41, 13, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 4, 2, 3, POTENTIAL, 0)
	var effect1: AbstractEffect = AbominationMonkeyEffect.new(unit, -1, 1, 1)
	unit.effects.append(effect1)
	var effect2: AbstractEffect = PenetrationPhysicalEffect.new(unit, -1, 100, 1)
	unit.effects.append(effect2)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
