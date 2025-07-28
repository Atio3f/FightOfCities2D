extends AbstractUnit
class_name KnightMonkey

const idUnit = "test:KnightMonkey"
const GRADE = 1
const POTENTIAL = 3
const img = ""

func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 42, 13, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 1, 5, 1, POTENTIAL, 5)
	var effect1: AbstractEffect = KnightMonkeyEffect.new(self, -1, 3)
	effects.append(effect1)
	tags.append(Tags.tags.MONKEY)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
