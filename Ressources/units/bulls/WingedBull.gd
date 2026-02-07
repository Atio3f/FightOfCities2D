extends AbstractUnit
class_name WingedBull

const STATS: UnitStats = preload("res://Ressources/units/bulls/WingedBull.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.FLYING]
	unit.actualMovementTypes = MovementTypes.movementTypes.FLYING
