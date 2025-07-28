extends AbstractUnit
class_name BerserkerBull

const idUnit = "test:BerserkerBull"
const GRADE = 3
const POTENTIAL = 2
const img = ""
#FAUDRA SEPARER LES 2 EFFETS DE L'UNITE JE PENSE
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 50, 24, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 5, 4, 0, POTENTIAL, 0)
	var effect1: AbstractEffect = BerserkerBullEffect.new(self, -1)
	effects.append(effect1)
	tags.append(Tags.tags.BULL)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
