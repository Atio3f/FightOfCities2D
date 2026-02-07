extends AbstractUnit
class_name BlueMushroom

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/BlueMushroom.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
