extends Node
class_name AbstractItem

static var id: String
var nameItem: String
var imgPath: String
var playerAssociated: AbstractPlayer
var unitAssociated: AbstractUnit = null
var orbCost: int	#Coût en orbe de l'objet
var orbCostBase: int
var equipable: bool	#If the item is to be place on a unit(consumables counts like equipable)
var isMalus: bool

#3 values like effects to keep parameters for items 
var value_A: int
var value_B: int
var value_C: int 
var counter: int #Can be used to increment a value 

#_init sera rarement appelé car généralement on va directement appliquer l'effet de l'objet dans les enfants de cette classe
#func _init(id: String, imgPath: String, playerAssociated: AbstractPlayer, orbsCost: int, equipable: bool, value_A: int, value_B: int = 0, value_C: int = 0, counter: int = 0):
	#self.id = id
	#self.nameItem = id.substr(5)
	#self.imgPath = imgPath
	##INSERER IMAGE A PARTIR DU PATH ICI
	#self.playerAssociated = playerAssociated
	#self.orbCost = orbCost
	#self.orbCostBase = orbCost
	#self.equipable = equipable
	#self.value_A = value_A
	#self.value_B = value_B
	#self.value_C = value_C
	#self.counter = counter

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unitTargeted: AbstractUnit, orbCost: int) -> bool:
	return orbCost <= playerUsing.orbs

#Check when entering inventory
static func canBeUsedOnInventory(playerUsing: AbstractPlayer, orbCost: int) -> bool:
	return orbCost <= playerUsing.orbs

#To iterate through players and knows which players can be targeted
static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int) -> bool:
	return orbCost <= playerUsing.orbs

static func useItem(playerUsing: AbstractPlayer, orbCost: int, unitTargeted: AbstractUnit, isMalus: bool) -> bool:
	#if !canBeUsedOnUnit(unit) : return false
	playerUsing.orbs -= orbCost
	if unitTargeted != null : unitTargeted.onItemUsed(playerUsing, isMalus)	#Some items doesn't affected units
	return true

static func getId() -> String:
	return "UNDEFINED"

func registerItem() -> Dictionary:
	return {}

static func recoverItem(data: Dictionary, hand: PlayerHand) -> void:#AbstractItem:
	return
