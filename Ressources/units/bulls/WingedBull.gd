extends AbstractUnit
class_name WingedBull

const idUnit = "test:WingedBull"
const GRADE = 2
const POTENTIAL = 3
const img = ""
func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 40, 19, DamageTypes.DamageTypes.PHYSICAL, 1, 1, 8, 3, 4, POTENTIAL, 3)
	tags.append(Tags.tags.BULL)
	self.movementTypes = [MovementTypes.movementTypes.FLYING]
	self.actualMovementTypes = MovementTypes.movementTypes.FLYING
