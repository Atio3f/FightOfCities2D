extends AbstractReward
class_name LocalHeroReward

func _init() -> void:
	isSkippable = false
	rewardsNumber = 1

func setData(_additionalData: String) -> void:
	rewardsAvailable = {"set1:LocalHero": Rarities.TRINKET_SPECIAL}
	initWeight()

func randomizeRewards() -> void:
	rewards.clear()
	rewards.append("set1:LocalHero")
