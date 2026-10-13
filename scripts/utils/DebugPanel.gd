extends CanvasLayer

## In-game developer debug console for FightOfCities2D.
## Toggleable via the 'debug_console' action (e.g. '²' key).

var is_console_open: bool = false
var command_history: Array[String] = []
var history_index: int = -1

# UI references (instantiated dynamically)
var panel: PanelContainer
var output_label: RichTextLabel
var line_edit: LineEdit
var scroll_container: ScrollContainer

func _ready() -> void:
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_build_ui()
	_log_info("[color=#66bb6a]Debug panel active! Type [b]help[/b] for available commands.[/color]")

## Dynamically creates the UI elements (clean and self-contained)
func _build_ui() -> void:
	panel = PanelContainer.new()
	panel.anchor_right = 1.0
	panel.anchor_bottom = 0.45
	panel.offset_left = 16
	panel.offset_top = 16
	panel.offset_right = -16
	panel.offset_bottom = 0
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Modern semi-transparent dark background
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.08, 0.09, 0.12, 0.92)
	style_box.border_color = Color(0.25, 0.45, 0.75, 0.8)
	style_box.border_width_bottom = 2
	style_box.border_width_left = 2
	style_box.border_width_right = 2
	style_box.border_width_top = 2
	style_box.corner_radius_bottom_left = 8
	style_box.corner_radius_bottom_right = 8
	style_box.corner_radius_top_left = 8
	style_box.corner_radius_top_right = 8
	style_box.content_margin_bottom = 10
	style_box.content_margin_top = 10
	style_box.content_margin_left = 12
	style_box.content_margin_right = 12
	panel.add_theme_stylebox_override("panel", style_box)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	# Header
	var header = HBoxContainer.new()
	var title = Label.new()
	title.text = "Fight Of Cities 2D — Debug Panel"
	title.modulate = Color(0.7, 0.8, 1.0, 0.8)
	header.add_child(title)
	vbox.add_child(header)

	# Scrollable output log
	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	output_label = RichTextLabel.new()
	output_label.bbcode_enabled = true
	output_label.scroll_following = true
	output_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	output_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	output_label.selection_enabled = true
	scroll_container.add_child(output_label)
	vbox.add_child(scroll_container)

	# Input text field
	line_edit = LineEdit.new()
	line_edit.placeholder_text = "Enter command (e.g. help, spawn Bull[Agility] red, gold 500, win)..."
	line_edit.clear_button_enabled = true
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	vbox.add_child(line_edit)

func _input(event: InputEvent) -> void:
	# Toggle console input action
	if event.is_action("debug_console"):
		if event.pressed and not event.echo:
			toggle_console()
			get_viewport().set_input_as_handled()
		return

	if is_console_open:
		if event is InputEventKey:
			# Close console with Escape key
			if event.pressed and event.keycode == KEY_ESCAPE:
				toggle_console(false)
				get_viewport().set_input_as_handled()
				return
			
			# History navigation with Up / Down arrows
			if event.pressed and line_edit.has_focus():
				if event.keycode == KEY_UP:
					_navigate_history(-1)
					get_viewport().set_input_as_handled()
					return
				elif event.keycode == KEY_DOWN:
					_navigate_history(1)
					get_viewport().set_input_as_handled()
					return

			# Prevent key release events from leaking to gameplay while console is open
			# (e.g. prevents releasing the spacebar from triggering 'pass_turn' in PointeurPlayer)
			if not event.pressed:
				get_viewport().set_input_as_handled()
				return

## Consumes unhandled key input so game shortcuts never trigger while console is active
func _unhandled_key_input(event: InputEvent) -> void:
	if is_console_open:
		get_viewport().set_input_as_handled()

## Consumes unhandled general input (mouse clicks outside, shortcuts, etc.) while console is active
func _unhandled_input(event: InputEvent) -> void:
	if is_console_open:
		get_viewport().set_input_as_handled()

func toggle_console(force_state: Variant = null) -> void:
	if force_state != null:
		is_console_open = force_state
	else:
		is_console_open = not is_console_open

	visible = is_console_open
	if is_console_open:
		# Clean up any accidental leading character from toggling
		if line_edit.text.begins_with("²"):
			line_edit.text = line_edit.text.substr(1)
		line_edit.grab_focus()
		line_edit.caret_column = line_edit.text.length()
		history_index = command_history.size()
	else:
		line_edit.release_focus()

func _navigate_history(direction: int) -> void:
	if command_history.is_empty():
		return
	
	history_index = clamp(history_index + direction, 0, command_history.size())
	if history_index < command_history.size():
		line_edit.text = command_history[history_index]
	else:
		line_edit.text = ""
	line_edit.caret_column = line_edit.text.length()

func _on_line_edit_text_submitted(text: String) -> void:
	var trimmed = text.strip_edges()
	line_edit.clear()
	
	if trimmed.is_empty():
		return
	
	# History management
	if command_history.is_empty() or command_history[-1] != trimmed:
		command_history.append(trimmed)
	history_index = command_history.size()

	_log_info("[color=#90caf9]> %s[/color]" % trimmed)
	execute_command(trimmed)

# ==============================================================================
# COMMAND PARSING & DISPATCHING
# ==============================================================================

func execute_command(command_line: String) -> void:
	var tokens = _tokenize(command_line)
	if tokens.is_empty():
		return

	var cmd = tokens[0].to_lower()
	var args = tokens.slice(1)

	match cmd:
		"help", "h", "?":
			_cmd_help(args)
		"clear", "cls":
			output_label.clear()
		"gold", "or", "money":
			_cmd_gold(args)
		"item", "equip", "give_item":
			_cmd_item(args)
		"unit", "give_unit":
			_cmd_unit(args)
		"spawn", "spawn_unit":
			_cmd_spawn(args)
		"win", "end", "end_level", "victory":
			_cmd_win(args)
		"list":
			_cmd_list(args)
		_:
			_log_error("Unknown command: '%s'. Type [b]help[/b] for command list." % cmd)

## Tokenizes command line while preserving content enclosed in brackets [ ... ]
func _tokenize(line: String) -> Array[String]:
	var tokens: Array[String] = []
	var current: String = ""
	var in_brackets: bool = false
	
	for i in range(line.length()):
		var char = line[i]
		if char == '[':
			in_brackets = true
			current += char
		elif char == ']':
			in_brackets = false
			current += char
		elif char == ' ' and not in_brackets:
			if not current.is_empty():
				tokens.append(current)
				current = ""
		else:
			current += char

	if not current.is_empty():
		tokens.append(current)

	return tokens

# ==============================================================================
# COMMAND IMPLEMENTATIONS
# ==============================================================================

## Command 'gold <amount>'
func _cmd_gold(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntax: gold <amount>  (e.g.: gold 500)")
		return

	var amount = args[0].to_int()
	var player = GameManager.getMainPlayer()
	if player == null:
		_log_error("No active main player found (game not started?).")
		return

	player.gainGold(amount)
	_log_success("Gold adjusted by %d. Current total: %d gold." % [amount, player.gold])

## Command 'item <id> [quantity]'
func _cmd_item(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntax: item <item_id> [quantity]  (e.g.: item Banana 3 or item WarAxe)")
		return

	var item_query = args[0]
	var count = 1
	if args.size() > 1:
		count = max(1, args[1].to_int())

	var resolved_id = _resolve_item_id(item_query)
	if resolved_id.is_empty():
		_log_error("Item or equipment not found for: '%s'." % item_query)
		return

	var player = GameManager.getMainPlayer()
	if player == null:
		_log_error("No active main player found.")
		return

	for i in range(count):
		player.addCard(resolved_id)

	var is_eq = ItemDb.ITEMS[resolved_id].get("IS_EQUIPMENT") == true
	var type_str = "Equipment" if is_eq else "Item"
	_log_success("%s '%s' added x%d to player." % [type_str, resolved_id, count])

## Command 'unit <id[bonus1,bonus2]>'
func _cmd_unit(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntax: unit <unit_id>[bonus1,bonus2]  (e.g.: unit Bull[Agility,Promotion])")
		return

	var unit_spec = _parse_unit_spec(args[0], args.slice(1))
	var resolved_id = _resolve_unit_id(unit_spec["id"])
	if resolved_id.is_empty():
		_log_error("Unit not found for: '%s'." % unit_spec["id"])
		return

	var player = GameManager.getMainPlayer()
	if player == null:
		_log_error("No active main player found.")
		return

	var stored = StoredUnit.new(resolved_id)
	_apply_upgrades_to_stored_unit(stored, unit_spec["bonuses"])

	player.gainUnitCard(stored)
	
	var bonus_text = (" with bonuses: " + str(unit_spec["bonuses"])) if not unit_spec["bonuses"].is_empty() else ""
	_log_success("Unit '%s' added to player cards%s." % [resolved_id, bonus_text])

## Command 'spawn <id[bonus1,bonus2]> <team: green|red> [x y]'
func _cmd_spawn(args: Array[String]) -> void:
	if args.size() < 2:
		_log_error("Syntax: spawn <unit_id>[bonus1,bonus2] <team: green|red> [x y]")
		_log_info("Examples:")
		_log_info("  spawn Bull[Agility] red          -> spawns under mouse cursor on enemy team")
		_log_info("  spawn QueenMonkey green 4 2      -> spawns at grid coordinates (4, 2)")
		return

	# 1. Parse Unit and Bonuses
	var unit_spec = _parse_unit_spec(args[0], args.slice(2))
	var resolved_unit_id = _resolve_unit_id(unit_spec["id"])
	if resolved_unit_id.is_empty():
		_log_error("Unit not found for: '%s'." % unit_spec["id"])
		return

	# 2. Parse Team (green / g or red / r)
	var team_str = args[1].to_lower()
	var target_player: AbstractPlayer = null
	var team_label: String = ""

	if team_str in ["green", "g", "player", "vert"]:
		target_player = GameManager.getMainPlayer()
		if target_player == null:
			target_player = GameManager.getPlayer(TeamsColor.TeamsColor.GREEN)
		team_label = "GREEN (Player)"
	elif team_str in ["red", "r", "enemy", "rouge"]:
		target_player = GameManager.getPlayer(TeamsColor.TeamsColor.RED)
		if target_player == null:
			# Look for any opponent player
			for p in GameManager.getPlayers():
				if p != GameManager.getMainPlayer():
					target_player = p
					break
		# If still no opponent player, create one for testing
		if target_player == null and Global.gameManager != null:
			target_player = Global.gameManager.createPlayer(TeamsColor.TeamsColor.RED, "Enemy", false)
		team_label = "RED (Enemy)"
	else:
		_log_error("Invalid team: '%s'. Use 'green' ('g') or 'red' ('r')." % team_str)
		return

	if target_player == null:
		_log_error("Could not find a player for team '%s'." % team_str)
		return

	# 3. Parse Coordinates (explicit x y or cursor position)
	var target_tile: AbstractTile = null
	var target_coords := Vector2i(-1, -1)

	var numeric_args: Array[int] = []
	for arg in args.slice(2):
		if arg.is_valid_int():
			numeric_args.append(arg.to_int())

	if numeric_args.size() >= 2:
		target_coords = Vector2i(numeric_args[0], numeric_args[1])
		target_tile = MapManager.getTileAt(target_coords)
	else:
		# No coordinates passed -> get tile under mouse pointer
		var main_p = GameManager.getMainPlayer()
		if main_p != null and main_p.playerPointer != null:
			target_coords = main_p.playerPointer.positionSouris
			target_tile = MapManager.getTileAt(target_coords)

	if target_tile == null:
		_log_error("No valid tile found at %s. Is a level currently loaded?" % str(target_coords))
		return

	if target_tile.hasUnitOn():
		_log_warning("Warning: Tile %s already has a unit on it!" % str(target_coords))

	# 4. Create StoredUnit and apply permanent upgrades
	var stored = StoredUnit.new(resolved_unit_id)
	_apply_upgrades_to_stored_unit(stored, unit_spec["bonuses"])

	# 5. Place unit on map
	if Global.gameManager == null:
		_log_error("GameManager is unavailable.")
		return

	var unit_instance = Global.gameManager.placeUnit(stored, target_player, target_tile)
	if unit_instance == null:
		_log_error("Failed to instantiate unit.")
		return

	var bonus_text = (" with bonuses: " + str(unit_spec["bonuses"])) if not unit_spec["bonuses"].is_empty() else ""
	_log_success("Unit '%s' spawned at %s for team %s%s." % [resolved_unit_id, str(target_coords), team_label, bonus_text])

## Command 'win' or 'end [true/false]'
func _cmd_win(args: Array[String]) -> void:
	var victory: bool = true
	if not args.is_empty():
		var arg = args[0].to_lower()
		if arg in ["false", "0", "loose", "lose", "defeat"]:
			victory = false

	if Global.gameManager == null:
		_log_error("No active GameManager.")
		return

	_log_success("Ending mission with state: %s..." % ("VICTORY" if victory else "DEFEAT"))
	GameManager.endMap(victory)

## Command 'list <units|items|upgrades> [filter]'
func _cmd_list(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntax: list <units|items|upgrades> [filter]")
		return

	var category = args[0].to_lower()
	var filter = args[1].to_lower() if args.size() > 1 else ""
	var results: Array[String] = []

	match category:
		"units", "unit":
			for key in UnitDb.UNITS.keys():
				if filter.is_empty() or filter in key.to_lower():
					results.append(key)
		"items", "item", "equip", "equipments":
			for key in ItemDb.ITEMS.keys():
				if filter.is_empty() or filter in key.to_lower():
					results.append(key)
		"upgrades", "upgrade", "bonus":
			UpgradeDB.loadUpgradesData()
			if UpgradeDB.data:
				for key in UpgradeDB.data.keys():
					if filter.is_empty() or filter in key.to_lower():
						results.append(key)
		_:
			_log_error("Unknown category: '%s'. Choose: units, items, upgrades." % category)
			return

	_log_info("[color=#ffd54f]List (%s - %d entries):[/color]" % [category, results.size()])
	_log_info(", ".join(results))

## Command 'help'
func _cmd_help(args: Array[String]) -> void:
	_log_info("[color=#81d4fa][b]Available commands:[/b][/color]")
	_log_info("  [b]gold <amount>[/b] : Adds gold to player (e.g.: [color=#ce93d8]gold 500[/color])")
	_log_info("  [b]item <id> [quantity][/b] : Adds item or equipment (e.g.: [color=#ce93d8]item Banana 2[/color], [color=#ce93d8]item WarAxe[/color])")
	_log_info("  [b]unit <id>[bonus1,bonus2][/b] : Adds unit to player cards (e.g.: [color=#ce93d8]unit Bull[Agility,Promotion][/color])")
	_log_info("  [b]spawn <id>[bonus] <green|red> [x y][/b] : Spawns unit directly on map.")
	_log_info("    (If x y omitted: spawns on cell under mouse cursor. Teams: green/g or red/r)")
	_log_info("  [b]win[/b] / [b]end [victory][/b] : Immediately finishes level (e.g.: [color=#ce93d8]win[/color])")
	_log_info("  [b]list <units|items|upgrades> [filter][/b] : Displays available database IDs")
	_log_info("  [b]clear[/b] : Clears console log")

# ==============================================================================
# PARSING & RESOLUTION HELPERS
# ==============================================================================

## Parses unit specification token in format 'ID[bonus1,bonus2]' or explicit bonus=... parameter
func _parse_unit_spec(primary_token: String, extra_args: Array[String] = []) -> Dictionary:
	var unit_id = primary_token
	var bonuses: Array[String] = []

	# Format 1 : Bull[Agility,Promotion]
	var bracket_open = primary_token.find("[")
	var bracket_close = primary_token.rfind("]")
	if bracket_open != -1 and bracket_close > bracket_open:
		unit_id = primary_token.substr(0, bracket_open).strip_edges()
		var inside = primary_token.substr(bracket_open + 1, bracket_close - bracket_open - 1)
		for part in inside.split(","):
			var clean = part.strip_edges()
			if not clean.is_empty():
				bonuses.append(clean)

	# Format 2 : explicit bonus=[...] or bonus=... parameter
	for arg in extra_args:
		if arg.begins_with("bonus=") or arg.begins_with("b="):
			var val = arg.split("=")[1].strip_edges()
			val = val.trim_prefix("[").trim_suffix("]")
			for part in val.split(","):
				var clean = part.strip_edges()
				if not clean.is_empty():
					bonuses.append(clean)

	return {
		"id": unit_id,
		"bonuses": bonuses
	}

## Applies list of resolved upgrades to StoredUnit
func _apply_upgrades_to_stored_unit(stored: StoredUnit, bonus_names: Array[String]) -> void:
	for b_name in bonus_names:
		var resolved_upgrade = _resolve_upgrade_id(b_name)
		if not resolved_upgrade.is_empty():
			stored.addPermanentUpgrade(resolved_upgrade)
		else:
			_log_warning("Unknown permanent upgrade skipped: '%s'." % b_name)

## Resolves unit ID (supports short names without 'set1:' and case-insensitive matching)
func _resolve_unit_id(query: String) -> String:
	if UnitDb.UNITS.has(query):
		return query

	var prefixed = "set1:" + query
	if UnitDb.UNITS.has(prefixed):
		return prefixed

	var query_lower = query.to_lower()
	for key in UnitDb.UNITS.keys():
		var name_without_prefix = key.split(":")[-1].to_lower()
		if key.to_lower() == query_lower or name_without_prefix == query_lower:
			return key

	return ""

## Resolves item/equipment ID
func _resolve_item_id(query: String) -> String:
	if ItemDb.ITEMS.has(query):
		return query

	var prefixed = "set1:" + query
	if ItemDb.ITEMS.has(prefixed):
		return prefixed

	var query_lower = query.to_lower()
	for key in ItemDb.ITEMS.keys():
		var name_without_prefix = key.split(":")[-1].to_lower()
		if key.to_lower() == query_lower or name_without_prefix == query_lower:
			return key

	return ""

## Resolves upgrade ID (e.g. Agility -> UpgradeAgilityEffect)
func _resolve_upgrade_id(query: String) -> String:
	UpgradeDB.loadUpgradesData()
	var upgrades_dict = UpgradeDB.data if UpgradeDB.data else {}

	# 1. Exact match
	if upgrades_dict.has(query) or EffectDb.EFFECTS.has(query):
		return query

	# 2. Standard pattern: Upgrade<Name>Effect
	var standard_pattern = "Upgrade" + query + "Effect"
	for key in upgrades_dict.keys():
		if key.to_lower() == standard_pattern.to_lower():
			return key

	# 3. Substring match
	var query_lower = query.to_lower()
	for key in upgrades_dict.keys():
		if query_lower in key.to_lower():
			return key

	for key in EffectDb.EFFECTS.keys():
		if query_lower in key.to_lower():
			return key

	return ""

# ==============================================================================
# CONSOLE LOGGING HELPERS
# ==============================================================================

func _log_info(msg: String) -> void:
	output_label.append_text(msg + "\n")

func _log_success(msg: String) -> void:
	output_label.append_text("[color=#66bb6a]✔ " + msg + "[/color]\n")

func _log_warning(msg: String) -> void:
	output_label.append_text("[color=#ffa726]⚠ " + msg + "[/color]\n")

func _log_error(msg: String) -> void:
	output_label.append_text("[color=#ef5350]✘ " + msg + "[/color]\n")
