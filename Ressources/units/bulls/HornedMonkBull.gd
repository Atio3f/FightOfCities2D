extends AbstractUnit
class_name HornedMonkBull

const STATS: UnitStats = preload("res://Ressources/units/bulls/HornedMonkBull.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect1: AbstractEffect = HornedMonkBullEffect.new(unit, -1, 2)
	unit.addEffect(effect1)
