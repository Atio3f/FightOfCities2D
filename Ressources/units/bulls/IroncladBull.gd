extends AbstractUnit
class_name IroncladBull

const POTENTIAL = 3 # Maybe 4?
const DR_VALUE = 3

const STATS: UnitStats = preload("res://Ressources/units/bulls/IroncladBull.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = IroncladBullEffect.new(unit, -1, DR_VALUE)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
