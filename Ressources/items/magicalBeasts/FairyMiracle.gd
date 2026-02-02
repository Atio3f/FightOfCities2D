extends AbstractItem
class_name FairyMiracle

# Heal 1 Unit at 100% and give it 15 HP temp.
# Objet très rare (et puissant) pê mettre 1 en coût en orbe ?
const idItem = "set1:FairyMiracle"
const img = "Monkey"
const ORB_COST = 0
const HEAL_PERCENT = 100
const BONUS_HP_TEMP = 15
 
func _init(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	unitAssociated.healHp(unitAssociated.hpMax)
	unitAssociated.gainHpTemp(BONUS_HP_TEMP)
	
# TODO Fonction s'active bien pour check objets utilisables mais il manque l'utilisation
static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unit: AbstractUnit, orbCost: int = ORB_COST) -> bool :
	if super.canBeUsedOnUnit(playerUsing, unit, orbCost) : return true
	else : return false

static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int = ORB_COST) -> bool:
	return false	#Can't be used on a player

static func getId() -> String:
	return idItem
