extends AbstractUnit
class_name IroncladBull

const idUnit = "test:IroncladBull"
const GRADE = 1
const POTENTIAL = 3#Maybe 4?
const img = ""
const DR_VALUE = 3


func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 48, 21, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 3, 8, 0, POTENTIAL, 1)
	var effect1: AbstractEffect = IroncladBullEffect.new(self, -1, DR_VALUE)
	effects.append(effect1)
	tags.append(Tags.tags.BULL)
	self.movementTypes = [MovementTypes.movementTypes.WALK]
	self.actualMovementTypes = MovementTypes.movementTypes.WALK
