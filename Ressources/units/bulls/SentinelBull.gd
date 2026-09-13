extends AbstractUnit
class_name SentinelBull

const STATS: UnitStats = preload("res://Ressources/units/bulls/SentinelBull.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect1: AbstractEffect = SentinelBullEffect.new(unit, -1, 10) # +10 Damage at 2 tiles
	unit.addEffect(effect1)
