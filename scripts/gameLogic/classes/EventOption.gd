class_name EventOption
extends RefCounted

## Represents a single choice available to the player during an event.
## Each option can have a condition, rewards, and a destination mission.

var label_key: String = ""          # Translation key for the short choice button text
var result_text_key: String = ""    # Translation key for the text shown after choosing
var rewards: Array[String] = []     # Reward ids (same format as map rewards: "reward:basicItems")
var next_mission: String = ""       # Mission id to go to after resolving ("map2", "shop1", etc.)
var condition: Callable             # func(stats: Dictionary) -> bool, null = always available

func _init(
	p_label_key: String,
	p_result_text_key: String,
	p_rewards: Array[String],
	p_next_mission: String,
	p_condition: Callable = Callable()
) -> void:
	label_key = p_label_key
	result_text_key = p_result_text_key
	rewards = p_rewards
	next_mission = p_next_mission
	condition = p_condition

## Returns true if this option is available given the last map statistics.
func is_available(last_map_stats: Dictionary) -> bool:
	if not condition.is_valid():
		return true
	return condition.call(last_map_stats)
