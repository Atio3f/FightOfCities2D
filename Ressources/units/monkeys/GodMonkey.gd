extends AbstractUnit
class_name GodMonkey

const idUnit = "test:GodMonkey"
const GRADE = 4
const POTENTIAL = 4
const img = ""

func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 45, 23, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 11, 6, 6, POTENTIAL, 24)
	var effect1: AbstractEffect = GodMonkeySpeedEffect.new(self, -1, 1)
	var effect2: AbstractEffect = GodMonkeyHealEffect.new(self, -1, 8)
	effects.append(effect1)
	effects.append(effect2)
	tags.append(Tags.tags.MONKEY)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
