extends AbstractUnit
class_name GodMonkey

const idUnit = "test:GodMonkey"
const GRADE = 4
const POTENTIAL = 4
const img = ""

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 45, 23, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 11, 6, 6, POTENTIAL, 24)
	var effect1: AbstractEffect = GodMonkeySpeedEffect.new(unit, -1, 1)
	var effect2: AbstractEffect = GodMonkeyHealEffect.new(unit, -1, 8)
	unit.effects.append(effect1)
	unit.effects.append(effect2)
	unit.tags.append(Tags.tags.MONKEY)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
