extends AbstractUnit
class_name GreenRoot

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/GreenRoot.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	# Drain life from nearby enemies and heal nearby allies effect (maybe 2 effects ?)
