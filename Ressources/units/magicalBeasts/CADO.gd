extends AbstractUnit
class_name CADO

# Chat Adorant Dégager les Oiseaux 
const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/CADO.tres")
const DMG_MULTIPLIER_FLYING: int = 200 ## Bonus damage multiplier against flying targets

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect: AbstractEffect = CADOEffect.new(unit, -1, DMG_MULTIPLIER_FLYING)
	unit.addEffect(effect)
