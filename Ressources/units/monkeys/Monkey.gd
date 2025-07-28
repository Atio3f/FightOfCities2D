extends AbstractUnit
class_name Monkey

const idUnit = "test:Monkey"
const GRADE = 1
const POTENTIAL = 3
const img = ""

func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 23, 7, DamageTypes.DamageTypes.PHYSICAL, 1, 2, 7, 1, 3, POTENTIAL, 9)
	var effect1: AbstractEffect = MonkeyEffect.new(self, -1, 3, 1)
	effects.append(effect1)
	tags.append(Tags.tags.MONKEY)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
