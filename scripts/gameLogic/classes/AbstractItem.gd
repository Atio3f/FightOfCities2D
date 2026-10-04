extends Node
class_name AbstractItem

static var id: String
var nameItem: String = "UNDEFINED"
var imgPath: String = ""
var playerAssociated: AbstractPlayer
var unitAssociated: AbstractUnit = null
var orbCost: int	#Coût en orbe de l'objet
var orbCostBase: int
var equipable: bool	#If the item is to be place on a unit(consumables counts like equipable)
var isMalus: bool
var tags: Array[Tags.tags] = []#3 values like effects to keep parameters for items 
var value_A: int
var value_B: int
var value_C: int 
var counter: int #Can be used to increment a value 

var itemId: String = "UNDEFINED"

var avgPrice: int #Price on shops, items can be sell from 40% of this value
func _init() -> void:
	
	var script = self.get_script()
	if script != null and script.has_method("getId"):
		itemId = script.call("getId")
	elif self.has_method("getId"):
		itemId = self.call("getId")
		
	if itemId != "UNDEFINED":
		if ItemDb.has_method("getItem"):
			var data: Dictionary = ItemDb.getItem(itemId)
			if data.has("name"):
				self.nameItem = tr(data["name"])
			if data.has("img"):
				self.imgPath = data["img"]

func applyEffect(playerAssociated: AbstractPlayer, unitAssociated: AbstractUnit) -> void:
	pass

func applyEffectOnTile(playerAssociated: AbstractPlayer, tileTargeted: AbstractTile) -> void:
	pass

# Define called functions to avoid calling canBeUsedOnTile on every tile when using an item that can only affect units
static func getTargetType() -> ItemTargets.itemTargets:
	return ItemTargets.itemTargets.UNIT

static func canBeUsedOnUnit(playerUsing: AbstractPlayer, unitTargeted: AbstractUnit, orbCost: int) -> bool:
	return orbCost <= playerUsing.orbs

static func canBeUsedOnTile(playerUsing: AbstractPlayer, tileTargeted: AbstractTile, orbCost: int) -> bool:
	return false

#Check when entering inventory
static func canBeUsedOnInventory(playerUsing: AbstractPlayer, orbCost: int) -> bool:
	return orbCost <= playerUsing.orbs

#To iterate through players and knows which players can be targeted
static func canBeUsedOnPlayer(playerUsing: AbstractPlayer, playerTargeted: AbstractPlayer, orbCost: int) -> bool:
	return orbCost <= playerUsing.orbs

static func useItem(playerUsing: AbstractPlayer, orbCost: int, item: AbstractItem, unitTargeted: AbstractUnit, isMalus: bool) -> bool:
	#if !canBeUsedOnUnit(unit) : return false
	playerUsing.orbs -= orbCost
	if unitTargeted != null : unitTargeted.onItemUsed(playerUsing, item, isMalus)	#Some items doesn't affected units
	if playerUsing.isGamePlayer : 
		for trinket: AbstractTrinket in playerUsing.trinkets :
			trinket.onItemUsed(playerUsing, item, isMalus, unitTargeted)
	return true

static func useItemOnTile(playerUsing: AbstractPlayer, orbCost: int, item: AbstractItem, tileTargeted: AbstractTile) -> bool:
	playerUsing.orbs -= orbCost
	item.applyEffectOnTile(playerUsing, tileTargeted)
	
	if playerUsing.isGamePlayer: 
		for trinket: AbstractTrinket in playerUsing.trinkets:
			trinket.onItemUsed(playerUsing, item, false, null)
			
	return true

static func getId() -> String:
	return "UNDEFINED"

func getImagePath() -> String :
	return imgPath

func getName() -> String :
	return nameItem

func getDescription() -> String:
	var desc: String = "DESCRIPTION NOT FOUND"
	if itemId != "UNDEFINED" and ItemDb.has_method("getItem"):
		var data = ItemDb.getItem(itemId)
		if data.has("description"):
			desc = tr(data["description"])

	var finalDesc : String = ""
	for t: String in desc.split("!"):
		match t:
			"VA":
				finalDesc += str(value_A)
			"VB":
				finalDesc += str(value_B)
			"VC":
				finalDesc += str(value_C)
			"C":
				finalDesc += str(counter)
			"OC":
				finalDesc += str(orbCost)
			_:
				finalDesc += t
	return TextParser.parse_icons(finalDesc)

func registerItem() -> Dictionary:
	return {}

static func recoverItem(data: Dictionary, hand: PlayerHand) -> void:#AbstractItem:
	return
