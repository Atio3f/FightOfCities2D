extends AbstractUnit
class_name BerserkerBull

#FAUDRA SEPARER LES 2 EFFETS DE L'UNITE JE PENSE
const STATS: UnitStats = preload("res://Ressources/units/bulls/BerserkerBull.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	var effect1: AbstractEffect = BerserkerBullEffect.new(unit, -1)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
