extends CanvasLayer

## Console de développement intégrée en jeu pour FightOfCities2D.
## S'ouvre avec la touche '²' (ou touche sous Echap).

var is_console_open: bool = false
var command_history: Array[String] = []
var history_index: int = -1

# Références UI créées dynamiquement
var panel: PanelContainer
var output_label: RichTextLabel
var line_edit: LineEdit
var scroll_container: ScrollContainer

func _ready() -> void:
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_build_ui()
	_log_info("[color=#66bb6a]Console de dev active ! Tapez [b]help[/b] pour voir les commandes disponibles.[/color]")

## Construction dynamique de l'interface graphique (propre et autonome)
func _build_ui() -> void:
	panel = PanelContainer.new()
	panel.anchor_right = 1.0
	panel.anchor_bottom = 0.45
	panel.offset_left = 16
	panel.offset_top = 16
	panel.offset_right = -16
	panel.offset_bottom = 0
	
	# Style de fond semi-transparent moderne
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

	# En-tête
	var header = HBoxContainer.new()
	var title = Label.new()
	title.text = "Fight Of Cities 2D — Console Dev (Touche '²' pour fermer)"
	title.modulate = Color(0.7, 0.8, 1.0, 0.8)
	header.add_child(title)
	vbox.add_child(header)

	# Zone de sortie avec défilement
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

	# Ligne de saisie
	line_edit = LineEdit.new()
	line_edit.placeholder_text = "Entrez une commande (ex: help, spawn Bull[Agility] red, gold 500, win)..."
	line_edit.clear_button_enabled = true
	line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	vbox.add_child(line_edit)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Détection touche '²' (AZERTY unicode 178 / physical KEY_QUOTELEFT / KEY_TWOSUPERIOR / KEY_SECTION)
		if event.is_action_pressed("debug_console") and not event.echo:
			toggle_console()
			get_viewport().set_input_as_handled()
			return

		if is_console_open:
			# Touche Echap ferme la console
			if event.pressed and event.keycode == KEY_ESCAPE:
				toggle_console(false)
				get_viewport().set_input_as_handled()
				return
			
			# Navigation dans l'historique avec Flèche Haut / Bas
			if event.pressed and line_edit.has_focus():
				if event.keycode == KEY_UP:
					_navigate_history(-1)
					get_viewport().set_input_as_handled()
				elif event.keycode == KEY_DOWN:
					_navigate_history(1)
					get_viewport().set_input_as_handled()

func toggle_console(force_state: Variant = null) -> void:
	if force_state != null:
		is_console_open = force_state
	else:
		is_console_open = not is_console_open

	visible = is_console_open
	if is_console_open:
		# Nettoie un éventuel caractère '²' accidentel
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
	
	# Gestion de l'historique
	if command_history.is_empty() or command_history[-1] != trimmed:
		command_history.append(trimmed)
	history_index = command_history.size()

	_log_info("[color=#90caf9]> %s[/color]" % trimmed)
	execute_command(trimmed)

# ==============================================================================
# PARSING ET EXÉCUTION DES COMMANDES
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
			_log_error("Commande inconnue : '%s'. Tapez [b]help[/b] pour la liste des commandes." % cmd)

## Tokenize la chaîne en préservant le contenu des crochets [ ... ]
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
# COMMANDES
# ==============================================================================

## Commande 'gold <montant>'
func _cmd_gold(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntaxe : gold <montant>  (ex: gold 500)")
		return

	var amount = args[0].to_int()
	var player = GameManager.getMainPlayer()
	if player == null:
		_log_error("Aucun joueur principal actif trouvé (partie non lancée ?)")
		return

	player.gainGold(amount)
	_log_success("Or modifié de %d. Total actuel : %d or." % [amount, player.gold])

## Commande 'item <id> [quantite]'
func _cmd_item(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntaxe : item <id_item> [quantité]  (ex: item Banana 3 ou item WarAxe)")
		return

	var item_query = args[0]
	var count = 1
	if args.size() > 1:
		count = max(1, args[1].to_int())

	var resolved_id = _resolve_item_id(item_query)
	if resolved_id.is_empty():
		_log_error("Objet ou équipement introuvable pour : '%s'." % item_query)
		return

	var player = GameManager.getMainPlayer()
	if player == null:
		_log_error("Aucun joueur principal actif.")
		return

	for i in range(count):
		player.addCard(resolved_id)

	var is_eq = ItemDb.ITEMS[resolved_id].get("IS_EQUIPMENT") == true
	var type_str = "Équipement" if is_eq else "Objet"
	_log_success("%s '%s' ajouté(e) x%d au joueur." % [type_str, resolved_id, count])

## Commande 'unit <id[bonus1,bonus2]>'
func _cmd_unit(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntaxe : unit <id_unite>[bonus1,bonus2]  (ex: unit Bull[Agility,Promotion])")
		return

	var unit_spec = _parse_unit_spec(args[0], args.slice(1))
	var resolved_id = _resolve_unit_id(unit_spec["id"])
	if resolved_id.is_empty():
		_log_error("Unité introuvable pour : '%s'." % unit_spec["id"])
		return

	var player = GameManager.getMainPlayer()
	if player == null:
		_log_error("Aucun joueur principal actif.")
		return

	var stored = StoredUnit.new(resolved_id)
	_apply_upgrades_to_stored_unit(stored, unit_spec["bonuses"])

	player.gainUnitCard(stored)
	
	var bonus_text = (" avec bonus: " + str(unit_spec["bonuses"])) if not unit_spec["bonuses"].is_empty() else ""
	_log_success("Unité '%s' ajoutée aux cartes du joueur%s." % [resolved_id, bonus_text])

## Commande 'spawn <id[bonus1,bonus2]> <camp: green|red> [x y]'
func _cmd_spawn(args: Array[String]) -> void:
	if args.size() < 2:
		_log_error("Syntaxe : spawn <id_unite>[bonus1,bonus2] <camp: green|red> [x y]")
		_log_info("Exemples :")
		_log_info("  spawn Bull[Agility] red          -> spawn sous la souris dans le camp ennemi")
		_log_info("  spawn QueenMonkey green 4 2      -> spawn aux coordonnées grille (4, 2)")
		return

	# 1. Parsing Unité + Bonus
	var unit_spec = _parse_unit_spec(args[0], args.slice(2))
	var resolved_unit_id = _resolve_unit_id(unit_spec["id"])
	if resolved_unit_id.is_empty():
		_log_error("Unité introuvable pour : '%s'." % unit_spec["id"])
		return

	# 2. Parsing Camp (green ou red)
	var team_str = args[1].to_lower()
	var target_player: AbstractPlayer = null
	var team_label: String = ""

	if team_str in ["green", "g", "player", "vert"]:
		target_player = GameManager.getMainPlayer()
		if target_player == null:
			target_player = GameManager.getPlayer(TeamsColor.TeamsColor.GREEN)
		team_label = "GREEN (Joueur)"
	elif team_str in ["red", "r", "enemy", "rouge"]:
		target_player = GameManager.getPlayer(TeamsColor.TeamsColor.RED)
		if target_player == null:
			# Recherche de n'importe quel joueur adverse
			for p in GameManager.getPlayers():
				if p != GameManager.getMainPlayer():
					target_player = p
					break
		# Si toujours aucun joueur adverse, on peut en créer un pour le test
		if target_player == null and Global.gameManager != null:
			target_player = Global.gameManager.createPlayer(TeamsColor.TeamsColor.RED, "Ennemi", false)
		team_label = "RED (Ennemi)"
	else:
		_log_error("Camp invalide : '%s'. Utilisez 'green' ('g') ou 'red' ('r')." % team_str)
		return

	if target_player == null:
		_log_error("Impossible de trouver le joueur pour le camp '%s'." % team_str)
		return

	# 3. Parsing Coordonnées (fournies ou sous la souris)
	var target_tile: AbstractTile = null
	var target_coords := Vector2i(-1, -1)

	# Vérifie si x et y sont passés en arguments numériques
	var numeric_args: Array[int] = []
	for arg in args.slice(2):
		if arg.is_valid_int():
			numeric_args.append(arg.to_int())

	if numeric_args.size() >= 2:
		target_coords = Vector2i(numeric_args[0], numeric_args[1])
		target_tile = MapManager.getTileAt(target_coords)
	else:
		# Pas de coordonnées explicites -> Récupère la case sous la souris
		var main_p = GameManager.getMainPlayer()
		if main_p != null and main_p.playerPointer != null:
			target_coords = main_p.playerPointer.positionSouris
			target_tile = MapManager.getTileAt(target_coords)

	if target_tile == null:
		_log_error("Aucune tuile valide trouvée (coords: %s). Êtes-vous bien sur une map active ?" % str(target_coords))
		return

	if target_tile.hasUnitOn():
		_log_warning("Attention : La case %s a déjà une unité dessus !" % str(target_coords))

	# 4. Création StoredUnit et application des bonus
	var stored = StoredUnit.new(resolved_unit_id)
	_apply_upgrades_to_stored_unit(stored, unit_spec["bonuses"])

	# 5. Placement de l'unité
	if Global.gameManager == null:
		_log_error("GameManager indisponible.")
		return

	var unit_instance = Global.gameManager.placeUnit(stored, target_player, target_tile)
	if unit_instance == null:
		_log_error("Échec lors de l'instanciation de l'unité.")
		return

	var bonus_text = (" avec bonus: " + str(unit_spec["bonuses"])) if not unit_spec["bonuses"].is_empty() else ""
	_log_success("Unité '%s' spawn en %s pour le camp %s%s." % [resolved_unit_id, str(target_coords), team_label, bonus_text])

## Commande 'win' ou 'end [true/false]'
func _cmd_win(args: Array[String]) -> void:
	var victory: bool = true
	if not args.is_empty():
		var arg = args[0].to_lower()
		if arg in ["false", "0", "loose", "lose", "defeat"]:
			victory = false

	if Global.gameManager == null:
		_log_error("Aucun GameManager actif.")
		return

	_log_success("Terminaison du niveau avec état : %s..." % ("VICTOIRE" if victory else "DÉFAITE"))
	GameManager.endMap(victory)

## Commande 'list <units|items|upgrades> [filtre]'
func _cmd_list(args: Array[String]) -> void:
	if args.is_empty():
		_log_error("Syntaxe : list <units|items|upgrades> [filtre]")
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
			_log_error("Catégorie inconnue : '%s'. Choisissez : units, items, upgrades." % category)
			return

	_log_info("[color=#ffd54f]Liste (%s - %d éléments) :[/color]" % [category, results.size()])
	_log_info(", ".join(results))

## Commande 'help'
func _cmd_help(args: Array[String]) -> void:
	_log_info("[color=#81d4fa][b]Commandes disponibles :[/b][/color]")
	_log_info("  [b]gold <montant>[/b] : Ajoute de l'or au joueur (ex: [color=#ce93d8]gold 500[/color])")
	_log_info("  [b]item <id> [quantite][/b] : Ajoute un objet ou équipement (ex: [color=#ce93d8]item Banana 2[/color], [color=#ce93d8]item WarAxe[/color])")
	_log_info("  [b]unit <id>[bonus1,bonus2][/b] : Ajoute une unité dans votre main (ex: [color=#ce93d8]unit Bull[Agility,Promotion][/color])")
	_log_info("  [b]spawn <id>[bonus] <green|red> [x y][/b] : Fait spawn l'unité sur le terrain.")
	_log_info("    (Si x y sont omis, spawn sur la case sous la souris. Camps: green/g ou red/r)")
	_log_info("  [b]win[/b] / [b]end [victory][/b] : Termine immédiatement le niveau (ex: [color=#ce93d8]win[/color])")
	_log_info("  [b]list <units|items|upgrades> [filtre][/b] : Affiche les IDs existants")
	_log_info("  [b]clear[/b] : Efface le journal de la console")

# ==============================================================================
# UTILITAIRES DE PARSING & RÉSOLUTION
# ==============================================================================

## Parse un token unité au format 'ID[bonus1,bonus2]' ou cherche un argument bonus=...
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

	# Format 2 : argument explicite bonus=[...] ou bonus=...
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

## Applique la liste de bonus résolus sur le StoredUnit
func _apply_upgrades_to_stored_unit(stored: StoredUnit, bonus_names: Array[String]) -> void:
	for b_name in bonus_names:
		var resolved_upgrade = _resolve_upgrade_id(b_name)
		if not resolved_upgrade.is_empty():
			stored.addPermanentUpgrade(resolved_upgrade)
		else:
			_log_warning("Bonus permanent inconnu ignoré : '%s'." % b_name)

## Résolution d'un ID d'unité (tolérant à 'set1:' et à la casse)
func _resolve_unit_id(query: String) -> String:
	if UnitDb.UNITS.has(query):
		return query

	var prefixed = "set1:" + query
	if UnitDb.UNITS.has(prefixed):
		return prefixed

	# Recherche insensible à la casse
	var query_lower = query.to_lower()
	for key in UnitDb.UNITS.keys():
		var name_without_prefix = key.split(":")[-1].to_lower()
		if key.to_lower() == query_lower or name_without_prefix == query_lower:
			return key

	return ""

## Résolution d'un ID d'item/équipement
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

## Résolution d'un ID de bonus permanent (ex: Agility -> UpgradeAgilityEffect)
func _resolve_upgrade_id(query: String) -> String:
	UpgradeDB.loadUpgradesData()
	var upgrades_dict = UpgradeDB.data if UpgradeDB.data else {}

	# 1. Correspondance exacte
	if upgrades_dict.has(query) or EffectDb.EFFECTS.has(query):
		return query

	# 2. Préfixe Upgrade + Suffixe Effect (ex: Agility -> UpgradeAgilityEffect)
	var standard_pattern = "Upgrade" + query + "Effect"
	for key in upgrades_dict.keys():
		if key.to_lower() == standard_pattern.to_lower():
			return key

	# 3. Recherche contenant le nom
	var query_lower = query.to_lower()
	for key in upgrades_dict.keys():
		if query_lower in key.to_lower():
			return key

	for key in EffectDb.EFFECTS.keys():
		if query_lower in key.to_lower():
			return key

	return ""

# ==============================================================================
# LOGS COLORÉS DANS LA CONSOLE
# ==============================================================================

func _log_info(msg: String) -> void:
	output_label.append_text(msg + "\n")

func _log_success(msg: String) -> void:
	output_label.append_text("[color=#66bb6a]✔ " + msg + "[/color]\n")

func _log_warning(msg: String) -> void:
	output_label.append_text("[color=#ffa726]⚠ " + msg + "[/color]\n")

func _log_error(msg: String) -> void:
	output_label.append_text("[color=#ef5350]✘ " + msg + "[/color]\n")
