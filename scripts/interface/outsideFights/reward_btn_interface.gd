extends Button
class_name RewardBtnInterface

var rewards: AbstractReward
var rewardNbr: int

##Nbr is the place on rewards
func generate(rewards: AbstractReward, nbr: int) -> void :
	var rewardId: String = rewards.rewards[nbr]
	var reward: Dictionary = RewardDb.REWARDS_DICO[rewardId]
	self.rewardNbr = nbr
	self.rewards = rewards
	#Missing icon reward
	%DescReward.visible = false
	%TitleReward.text = reward["title"]
	%DescReward.text = reward["desc"]

func _on_mouse_entered():
	%DescReward.visible = true


func _on_mouse_exited():
	%DescReward.visible = false


func _on_pressed():
	rewards.obtainReward(GameManager.getMainPlayer(), rewardNbr)
	print("GET IT")
	get_parent().get_parent().closeRewardInterface()	#Close interface
