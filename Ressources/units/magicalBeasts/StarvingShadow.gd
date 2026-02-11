extends AbstractUnit
class_name StarvingShadow

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/StarvingShadow.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect: AbstractEffect = StarvingShadowEffect.new(unit, -1, 4)
	unit.effects.append(effect)
