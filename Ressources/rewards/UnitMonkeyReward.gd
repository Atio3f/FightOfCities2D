extends AbstractReward
class_name UnitMonkeyReward


func _init() -> void:
	rewardsAvailable = ["set1:KnightMonkey", "set1:AbominationMonkey", "set1:GodMonkey"]
	randomizeRewards()
