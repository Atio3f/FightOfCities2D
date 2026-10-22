extends AbstractMetaUI
class_name EventUI

## Interface displayed during a campaign event.
## Shows an intro text and one button per available option.
## After the player picks an option, displays the result text with a "Continuer" button.
## Then rewards are distributed via the existing AbstractReward/MetaUI queue,
## and startNextMission() is called automatically when the queue empties.

@onready var title_label: Label = %TitleLabel
@onready var intro_label: Label = %IntroLabel
@onready var options_container: VBoxContainer = %OptionsContainer

var event_logic: AbstractEvent
var last_map_stats: Dictionary
var _meta_ui: MetaUI

signal event_closed

func setup(logic: AbstractEvent, stats: Dictionary) -> void:
	event_logic = logic
	last_map_stats = stats

func display(meta_ui: MetaUI) -> void:
	_meta_ui = meta_ui
	event_closed.connect(meta_ui.onRewardInterfaceClosed)

	if not is_node_ready():
		await ready

	# Title & Intro text
	if event_logic:
		if title_label and event_logic.title_key != "":
			title_label.text = tr(event_logic.title_key)
		if intro_label:
			intro_label.text = tr(event_logic.intro_text_key)

	# Build one button per option (disabled if unavailable)
	for child in options_container.get_children():
		child.queue_free()

	if not event_logic:
		return

	for opt: EventOption in event_logic.options:
		var btn := Button.new()
		btn.text = tr(opt.label_key)
		btn.custom_minimum_size = Vector2(350, 48)
		if not opt.is_available(last_map_stats):
			btn.disabled = true
		else:
			btn.pressed.connect(func(): _on_option_chosen(opt))
		options_container.add_child(btn)

func _on_option_chosen(opt: EventOption) -> void:

	# Clear previous choice buttons
	for child in options_container.get_children():
		child.queue_free()

	# If there is a result text, display it with a "Continue" button
	if opt.result_text_key != "":
		if intro_label:
			intro_label.text = tr(opt.result_text_key)
		var cont_btn := Button.new()
		cont_btn.text = "Continuer"
		cont_btn.custom_minimum_size = Vector2(250, 48)
		cont_btn.pressed.connect(func(): _proceed_after_choice(opt))
		options_container.add_child(cont_btn)
	else:
		_proceed_after_choice(opt)

func _proceed_after_choice(opt: EventOption) -> void:
	# Set next mission now so it's ready when the reward queue empties
	GameManager.campaign.nextMission = opt.next_mission

	# Distribute rewards through the existing AbstractReward/MetaUI pipeline
	for reward_str: String in opt.rewards:
		var parts := reward_str.split(":")
		if parts.size() < 2:
			push_error("EventUI: malformed reward id: " + reward_str)
			continue
		var reward_id := parts[0] + ":" + parts[1]
		var additional_data := ""
		if parts.size() > 2:
			additional_data = parts[2]
		if not RewardDb.REWARDS.has(reward_id):
			push_error("EventUI: reward not found: " + reward_id)
			continue
		var reward: AbstractReward = RewardDb.REWARDS[reward_id].new()
		reward.setData(additional_data)
		reward.randomizeRewards()
		_meta_ui.placeInterface(reward.getScreenReward(), true)

	# Close the event itself; MetaUI.onRewardInterfaceClosed will free this node
	# and pop the next interface in queue (or start the next mission if empty).
	emit_signal("event_closed")
