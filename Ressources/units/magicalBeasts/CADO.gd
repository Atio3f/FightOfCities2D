extends AbstractUnit
class_name CADO

# Chat Adorant Dégager les Oiseaux 
const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/CADO.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
