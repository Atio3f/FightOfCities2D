extends AbstractReward
class_name TrinketBossReward


func setData(_additionalData: String) -> void :
	rewardsAvailable = {
		## COMMON
		"set1:OrbCrate": Rarities.TRINKET_COMMON, "set1:ArtOfWar": Rarities.TRINKET_COMMON,
		"set1:MonkeySoap": Rarities.TRINKET_COMMON, "set1:FairyBenediction": Rarities.TRINKET_COMMON,
		"set1:WarBanner": Rarities.TRINKET_COMMON, "set1:HRDiploma": Rarities.TRINKET_COMMON,
		"set1:GiftedRecruit": Rarities.TRINKET_COMMON, "set1:LimitBreaker": Rarities.TRINKET_COMMON,
		"set1:Sundial": Rarities.TRINKET_COMMON,
		## UNCOMMON
		"set1:PunchingBallMonkey": Rarities.TRINKET_UNCOMMON, "set1:BananaRecipes": Rarities.TRINKET_UNCOMMON, 
		"set1:JellyfishSens": Rarities.TRINKET_UNCOMMON,
		## RARE
		"set1:ScorpioPalm": Rarities.TRINKET_RARE
	}
	initWeight()
