extends Node
class_name AbstractReward

#Reward screen scene variable
var rewardsAvailable: Array = []#List of items obtainable from the reward
var rewards: Array = []	#Rewards list for the returned screen reward
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
func getScreenReward() -> PackedScene:
	return PackedScene.new()

##Use when selecting a reward, maybe will be placed on an interface
func obtainReward(player: AbstractPlayer, number: int) -> void :
	#Pour l'instant on gère que des unités en gain
	player.addUnitCard(rewards[number])
	queue_free()
