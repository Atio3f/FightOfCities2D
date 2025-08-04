extends AbstractUnit
class_name IroncladBull

const idUnit = "test:IroncladBull"
const GRADE = 1
const POTENTIAL = 3#Maybe 4?
const img = ""
const DR_VALUE = 3


static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 48, 21, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 3, 8, 0, POTENTIAL, 1)
	var effect1: AbstractEffect = IroncladBullEffect.new(unit, -1, DR_VALUE)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
