extends AbstractItem
class_name MagicalCoconut

# Deal 18 physical damage to a random ennemi. Gain 1 orb. -> c'était 14 dans mon livret mais y'avait pas de DR à l'époque, y'avait 2 cibles max et c'était sur le cocotier les dégâts

const idItem = "set1:MagicalCoconut"
const img = "Monkey"
const ORB_COST = 0
const DMG_VALUE = 18
const ORB_GAIN = 1
 
func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	playerAssociated.gainOrbs(ORB_GAIN)
	# Get one random unit from other team
	var units: Array[AbstractUnit] = GameManager.getRandomUnits(1, [playerAssociated.team])
	
	if units.size() > 0 :
		units[0].onDamageTaken(null, DMG_VALUE, DamageTypes.DamageTypes.PHYSICAL, false)

# TODO Fonction s'active bien pour check objets utilisables mais il manque l'utilisation
static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if super.canBeUsedOnUnit(playerUsing, unit, orbCost) && TurnManager.turn != 0 : return true # Can't be used 
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	if super.canBeUsedOnPlayer(playerUsing, playerTargeted, orbCost) && TurnManager.turn != 0 : return true # Can't be used on preparation turn
	else : return false # Random target so it can be used at any time

static func getId() -> String:
	return idItem
