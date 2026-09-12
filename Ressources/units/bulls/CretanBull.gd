extends AbstractUnit
class_name CretanBull

const STATS: UnitStats = preload("res://Ressources/units/bulls/CretanBull.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect1: AbstractEffect = LifeStealEffect.new(unit, -1, 35)
	unit.addEffect(effect1)
