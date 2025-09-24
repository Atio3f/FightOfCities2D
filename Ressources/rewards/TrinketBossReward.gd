extends AbstractReward
class_name TrinketBossReward


func _init() -> void:
	rewardsAvailable = {"set1:orbCrate": Rarities.raritiesTrinkets.COMMON, "set1:ArtOfWar": Rarities.raritiesTrinkets.COMMON}
	initWeight()
