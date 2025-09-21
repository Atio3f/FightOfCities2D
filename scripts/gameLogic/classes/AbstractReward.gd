extends Node
class_name AbstractReward

var rewardInterface: PackedScene = preload("res://nodes/interface/rewardChoiceInterface.tscn")
#Reward screen scene variable
var rewardsAvailable: Array = []#List of items obtainable from the reward
var rewards: Array[String] = []	#Rewards list for the returned screen reward
var rewardsNumber: int = 3	#Number of rewards on rewards list

## Randomize rewards 
func randomizeRewards() -> void: 
	rewards.clear()#Clear old choice
	#Add 3 randoms items of rewardsAvailable into rewards
	var i : int = 0
	rewardsAvailable.shuffle()
	while i < rewardsNumber :
		rewards.append(rewardsAvailable.pop_back())
		i += 1
	print("REWARDS")
	print(rewards)

##Return the screen reward, will be called on player to place it on interface
func getScreenReward() -> RewardChoiceInterface:
	var interface: RewardChoiceInterface = rewardInterface.instantiate()
	interface.reward = self
	return interface

###Use when selecting a reward, maybe will be placed on an interface
func obtainReward(player: AbstractPlayer, number: int) -> void :
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
