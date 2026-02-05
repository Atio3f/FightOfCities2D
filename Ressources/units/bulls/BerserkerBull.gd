extends AbstractUnit
class_name BerserkerBull

const idUnit = "set1:BerserkerBull"
const GRADE = 3
const POTENTIAL = 2
const img = "Bull" # TODO Changer l'image
#FAUDRA SEPARER LES 2 EFFETS DE L'UNITE JE PENSE
static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(idUnit, img, playerAssociated, GRADE, 50, 24, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 5, 4, 0, POTENTIAL, 0)
	var effect1: AbstractEffect = BerserkerBullEffect.new(unit, -1)
	unit.effects.append(effect1)
	unit.tags.append(Tags.tags.BULL)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK
