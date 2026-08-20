extends AbstractUnit
class_name AtlasLion

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/AtlasLion.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
	var effect: AbstractEffect = AtlasLionEffect.new(unit, -1, 10) # +10% damage dealed on lion grade - target grade
	unit.effects.append(effect)
