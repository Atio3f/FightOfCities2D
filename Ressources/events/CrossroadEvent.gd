class_name CrossroadEvent
extends AbstractEvent

## Event: a crossroads after map1.
## The player must choose a direction:
##   - Right: une auberge 5km away -> item reward then map2
##   - Left: une ville 9km away, dispo que si on a réussi le combat en moins de 3 tours  -> MonkeyShop (shop_crossroad) then map2

func _init() -> void:
	title_key = "EVENT_CROSSROAD_TITLE"
	background_id = ""
	intro_text_key = "EVENT_CROSSROAD_INTRO"
	super._init()

func setup_options() -> void:
	# Option A: take the road to the inn (always available)
	var opt_inn := EventOption.new(
		"EVENT_CROSSROAD_OPT_INN",
		"EVENT_CROSSROAD_RESULT_INN",
		["reward:basicItems"],
		"map2"
	)

	# Option B: take the road to the town (leads to shop, only if finished in 3 rounds or less)
	var opt_town := EventOption.new(
		"EVENT_CROSSROAD_OPT_TOWN",
		"EVENT_CROSSROAD_RESULT_TOWN",
		[], 
		"shop_crossroad",
		func(stats: Dictionary) -> bool:
			return stats.get("rounds", 999) <= 3
	)

	options = [opt_inn, opt_town]
