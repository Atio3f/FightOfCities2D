extends AbstractReward
class_name MagicalBeastReward


func _init() -> void:
	rewardsAvailable = {"set1:BlueMushroom": Rarities.raritiesUnits.COMMON, "set1:TemporalSnail": Rarities.raritiesUnits.RARE}
	initWeight()
