extends AbstractReward
class_name TrinketBossReward


func _init() -> void:
	rewardsAvailable = {"set1:OrbCrate": Rarities.TRINKET_COMMON, "set1:ArtOfWar": Rarities.TRINKET_COMMON, "set1:MonkeySoap": Rarities.TRINKET_COMMON, "set1:PunchingBallMonkey": Rarities.TRINKET_UNCOMMON}
	initWeight()
