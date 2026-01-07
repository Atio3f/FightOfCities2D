###Interface with all rewards after a map
extends AbstractMetaUI
class_name RewardChoiceInterface

@onready var interfaceRewardScene: PackedScene = preload("res://nodes/interface/metaUI/placeholderScreens/rewardBtnInterface.tscn")

var reward: AbstractReward

signal reward_interface_closed

func display(metaUI: MetaUI) -> void :
	var interfaceReward: RewardBtnInterface
	var index: int = 0
	for rewardS: String in reward.rewards :
		interfaceReward = interfaceRewardScene.instantiate()
		interfaceReward.generate(reward, index)
		%RewardList.add_child(interfaceReward)
		index += 1
	reward_interface_closed.connect(metaUI.onRewardInterfaceClosed)

##Close the interface
func closeRewardInterface() -> void :
	#Send a signal to continue
	emit_signal("reward_interface_closed")
	queue_free()	#Delete the interface


func getEndSignal() -> Signal :
	return reward_interface_closed


func _on_skip_btn_pressed() -> void:
	reward.obtainReward(GameManager.getMainPlayer(), -1)	#Return skip action
	closeRewardInterface()

func saveInterface() -> Dictionary :
	var dico := {
		"type": "RewardChoiceInterface"
	}
	return dico
