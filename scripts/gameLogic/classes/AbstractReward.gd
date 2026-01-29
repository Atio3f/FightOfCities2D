extends Node
class_name AbstractReward

var rewardInterface: PackedScene = preload("res://nodes/interface/metaUI/placeholderScreens/rewardChoiceInterface.tscn")
#Reward screen scene variable
var rewardsAvailable: Dictionary = {}#List of items obtainable from the reward, key is item id and value is item weight
var totalWeight: int = 0	#Total weight of all items on rewardsAvailable
var rewards: Array[String] = []	#Rewards list for the returned screen reward
var rewardsNumber: int = 3	#Number of rewards on rewards list

## Init total weight
func initWeight() -> void :
	totalWeight = 0
	for rewardId in rewardsAvailable:
		totalWeight += rewardsAvailable[rewardId].weight


## Randomize rewards 
func randomizeRewards() -> void: 
	rewards.clear()#Clear old choice
	#Add 3 randoms items of rewardsAvailable into rewards
	var i : int = 0
	while i < rewardsNumber :
		rewards.append(pickReward())
		i += 1
	print("REWARDS")
	print(rewards)

func pickReward() -> String :
	var random = randi() % totalWeight
	var current = 0
	var tile: AbstractTile
	
	for rewardId in rewardsAvailable:
		current += rewardsAvailable[rewardId].weight
		if random < current:
			return rewardId
	return ""

##Return the screen reward, will be called on player to place it on interface
func getScreenReward() -> RewardChoiceInterface:
	var interface: RewardChoiceInterface = rewardInterface.instantiate()
	interface.reward = self
	return interface

###Use when selecting a reward, maybe will be placed on an interface
func obtainReward(player: AbstractPlayer, number: int) -> void :
	if number == -1 : skipReward()
	var rewardId: String = rewards[number]
	var reward: Dictionary = RewardDb.REWARDS_DICO[rewardId]
	match reward["rewardType"] :
		RewardTypes.rewardTypes.UNIT :
			print("OBTAIN IT")
			GameManager.getMainPlayer().addUnitCard(reward["idReward"])
		RewardTypes.rewardTypes.ITEM :
			GameManager.getMainPlayer().addCard(reward["idReward"])
		RewardTypes.rewardTypes.TRINKET :
			GameManager.addTrinket(GameManager.getMainPlayer(), reward["idReward"])
		RewardTypes.rewardTypes.GOLD :
			GameManager.getMainPlayer().addCard(reward["goldAmt"])
		RewardTypes.rewardTypes.ORB :
			GameManager.getMainPlayer().addCard(reward["orbAmt"])
		RewardTypes.rewardTypes.BONUS :
			GameManager.getMainPlayer().addCard(reward["idReward"])	#Will need one more thing to attribute the bonus to an unit
	queue_free()

## We will add trinkets effects here if some activates on skip
func skipReward() -> void:
	queue_free()
