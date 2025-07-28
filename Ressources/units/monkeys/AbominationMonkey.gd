extends AbstractUnit
class_name AbominationMonkey

const idUnit = "test:AbominationMonkey"
const GRADE = 2
const POTENTIAL = 2
const img = ""
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 41, 13, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 4, 2, 3, POTENTIAL, 0)
	var effect1: AbstractEffect = AbominationMonkeyEffect.new(self, -1, 1, 1)
	effects.append(effect1)
	var effect2: AbstractEffect = PenetrationPhysicalEffect.new(self, -1, 100, 1)
	effects.append(effect2)
	tags.append(Tags.tags.MONKEY)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
