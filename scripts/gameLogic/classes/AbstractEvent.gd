class_name AbstractEvent
extends RefCounted

## Base class for all campaign events.
## An event contains a background image, an intro text,
## and 2–5 options, each with its own condition, rewards, and next mission.
## Subclasses must implement setup_options() to populate the options array.

var title_key: String = ""          # Translation key or display name for the event title
var background_id: String = ""      # Background image id (empty = no background for now)
var intro_text_key: String = ""     # Translation key for the introductory text shown to the player

var options: Array[EventOption] = []

func _init() -> void:
	setup_options()

## Override in each subclass to define options.
func setup_options() -> void:
	assert(false, "setup_options() must be implemented in the derived class")

## Returns only the options available given the last map statistics.
func get_available_options(last_map_stats: Dictionary) -> Array[EventOption]:
	var available: Array[EventOption] = []
	for opt: EventOption in options:
		if opt.is_available(last_map_stats):
			available.append(opt)
	return available

## Called by the event interface when the player confirms a choice.
## Distributes rewards then sets the next mission and starts it.
func resolve_option(player: AbstractPlayer, option_index: int, last_map_stats: Dictionary) -> void:
	var available := get_available_options(last_map_stats)
	if option_index < 0 or option_index >= available.size():
		push_error("AbstractEvent.resolve_option: invalid option_index %d" % option_index)
		return

	var opt: EventOption = available[option_index]

	# Distribute rewards via AbstractReward, same flow as after a map
	for reward_str: String in opt.rewards:
		var parts := reward_str.split(":")
		if parts.size() < 2:
			push_error("AbstractEvent: malformed reward id: " + reward_str)
			continue
		var reward_id := parts[0] + ":" + parts[1]
		var additional_data := ""
		if parts.size() > 2:
			additional_data = parts[2]
		if not RewardDb.REWARDS.has(reward_id):
			push_error("AbstractEvent: reward not found in RewardDb: " + reward_id)
			continue
		var reward: AbstractReward = RewardDb.REWARDS[reward_id].new()
		reward.setData(additional_data)
		reward.randomizeRewards()
		player.metaInterface.placeInterface(reward.getScreenReward(), true)

	# Navigate to the next mission
	GameManager.campaign.nextMission = opt.next_mission
	# startNextMission will be called after the last reward interface is closed (same flow as endMap)
