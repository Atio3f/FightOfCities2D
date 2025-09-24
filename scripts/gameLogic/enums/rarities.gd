extends Node

enum raritiesTrinkets {
	COMMON = 15,	#Cheap, versatiles
	UNCOMMON = 9,	#Cost a little, versatiles?
	RARE = 3,	#Cost a lot, generally will influence your gameplay
	ANCIENT = 1,
	SPECIAL = 0	#Can be found on events
}


enum raritiesEquipments {
	COMMON = 13,	#Can be found everywhere and cheap
	UNCOMMON = 7,	#Can be found everywhere but cost a little bit
	RARE = 7,	#Can be found on elite battles or some events but will cost a lot
	MYTHIC = 10,	#Can be found on elite/boss battles or some events, each item is unique to a battle/mob
	HEROIC = 100,	#Can only be equipped on the hero, found at the end of each arc
	SPECIAL = 0	#Can be generate by an unit or find on a specific event
}

#Use to make weights
enum raritiesUnits {
	COMMON = 20,	#Can be found everywhere and cheap
	UNCOMMON = 12,	#Can be found everywhere but cost a little bit
	RARE = 4,	#Can be found on elite battles or some events but will cost a lot	#Value will be reduced to 1 when legendary multiplier will be implemented on player/GameManager
	MYTHIC = 5,	#Can be found on elite/boss battles or some events, each item is unique to a battle/mob
	HEROIC = 10,	#Can only be equipped on the hero, found at the end of each arc
	SPECIAL = 0	#Can be generate by an unit or find on a specific event
}
