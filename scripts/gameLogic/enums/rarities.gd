extends Node

enum raritiesTrinkets {
	COMMON = 15,	#Cheap, versatiles
	UNCOMMON = 9,	#Cost a little, versatiles?
	RARE = 3,	#Cost a lot, generally will influence your gameplay
	ANCIENT = 1,
	SPECIAL = 0	#Can be found on events
}

# --- CONFIGS UNIT REWARDS ---
var UNIT_COMMON := RarityData.new("COMMON", 18, TYPE_UNIT, RARITY_COLORS["COMMON"])
var UNIT_UNCOMMON := RarityData.new("UNCOMMON", 12, TYPE_UNIT, RARITY_COLORS["UNCOMMON"])
var UNIT_RARE := RarityData.new("RARE", 6, TYPE_UNIT, RARITY_COLORS["RARE"])
var UNIT_LEGENDARY := RarityData.new("LEGENDARY", 3, TYPE_UNIT, RARITY_COLORS["LEGENDARY"])
var UNIT_HEROIC := RarityData.new("HEROIC", 10, TYPE_UNIT, RARITY_COLORS["HEROIC"])
var UNIT_SPECIAL := RarityData.new("SPECIAL", 0, TYPE_UNIT, RARITY_COLORS["SPECIAL"])

# --- CONFIGS ITEM REWARDS ---
var ITEM_COMMON := RarityData.new("COMMON", 17, TYPE_ITEM, RARITY_COLORS["COMMON"])
var ITEM_UNCOMMON := RarityData.new("UNCOMMON", 11, TYPE_ITEM, RARITY_COLORS["UNCOMMON"])
var ITEM_RARE := RarityData.new("RARE", 4, TYPE_ITEM, RARITY_COLORS["RARE"]) # Unusual item to found
var ITEM_SPECIAL := RarityData.new("SPECIAL", 12, TYPE_ITEM, RARITY_COLORS["SPECIAL"])

# --- CONFIGS EQUIPMENT REWARDS ---
var EQUIP_COMMON := RarityData.new("COMMON", 13, TYPE_EQUIPMENT, RARITY_COLORS["COMMON"]) #Can be found everywhere and cheap
var EQUIP_UNCOMMON := RarityData.new("UNCOMMON", 7, TYPE_EQUIPMENT, RARITY_COLORS["UNCOMMON"]) #Can be found everywhere but cost a little bit
var EQUIP_RARE := RarityData.new("RARE", 7, TYPE_EQUIPMENT, RARITY_COLORS["RARE"]) #Can be found on elite battles or some events but will cost a lot
var EQUIP_MYTHIC := RarityData.new("MYTHIC", 10, TYPE_EQUIPMENT, RARITY_COLORS["MYTHIC"]) #Can be found on elite/boss battles or some events, each item is unique to a battle/mob
var EQUIP_HEROIC := RarityData.new("HEROIC", 100, TYPE_EQUIPMENT, RARITY_COLORS["HEROIC"]) #Can only be equipped on the hero, found at the end of each arc
var EQUIP_SPECIAL := RarityData.new("SPECIAL", 0, TYPE_EQUIPMENT, RARITY_COLORS["SPECIAL"]) #Can be generate by an unit or find on a specific event

# --- CONFIGS TRINKET REWARDS ---
var TRINKET_COMMON := RarityData.new("COMMON", 15, TYPE_TRINKET, RARITY_COLORS["COMMON"]) #Cheap, versatiles
var TRINKET_UNCOMMON := RarityData.new("UNCOMMON", 9, TYPE_TRINKET, RARITY_COLORS["UNCOMMON"]) #Cost a little, versatiles?
var TRINKET_RARE := RarityData.new("RARE", 3, TYPE_TRINKET, RARITY_COLORS["RARE"]) #Cost a lot, generally will influence your gameplay
var TRINKET_ANCIENT := RarityData.new("ANCIENT", 1, TYPE_TRINKET, RARITY_COLORS["ANCIENT"])
var TRINKET_SPECIAL := RarityData.new("SPECIAL", 0, TYPE_TRINKET, RARITY_COLORS["SPECIAL"]) #Can be found on events


# --- CONFIGS GOLD REWARDS ---
var GOLD_T1 := RarityData.new("T1", 1, TYPE_GOLD, RARITY_COLORS["COMMON"])


## Couleurs du contour des récompenses
const RARITY_COLORS = {
	"COMMON": Color("bdc3c7"),     # Gray, for Grade 1 units
	"UNCOMMON": Color("2ecc71"),   # Green, for Grade 2 units
	"RARE": Color("9b59b6"),       # Violet Epic, for Grade 3 units
	"LEGENDARY": Color("f1c40f"),  # Gold, for Grade 4 units
	"ANCIENT": Color("e67e22"),    # Orange (Trinket)
	"MYTHIC": Color("febb8e"),     # Pêche (Equipment/Unit)
	"HEROIC": Color("f1c40f"),     # Gold, will have a special border later (Equipment/Unit)
	"SPECIAL": Color("e74c3c")     # Rouge
}

## Types de récompense obtenables
const TYPE_UNIT = "UNIT"
const TYPE_ITEM = "ITEM"
const TYPE_GOLD = "GOLD"
const TYPE_EQUIPMENT = "EQUIPMENT"
const TYPE_TRINKET = "TRINKET"
