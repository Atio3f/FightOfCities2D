extends AbstractUnit
class_name BlueMushroom

const idUnit = "test:BlueMushroom"
const GRADE = 2
const POTENTIAL = 3
const img = ""

func _init(playerAssociated: AbstractPlayer):
	super._init(idUnit, img, playerAssociated, GRADE, 28, 5, DamageTypes.DamageTypes.MAGICAL, 3, 1, 10, 0, 5, POTENTIAL, 3)
	tags.append(Tags.tags.MAGICAL_BEAST)
