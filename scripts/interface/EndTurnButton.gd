class_name EndTurnButton
extends MarginContainer

## Composant gérant le bouton de fin de tour et de lancement de combat.
## Gère l'apparence visuelle (thème rouge en prépa vs neutre en combat)
## ainsi que l'effet de pulsation (respiration) quand le joueur peut lancer le combat.

@onready var button: Button = %ButtonFinTour
@onready var texture_bg: TextureRect = $TextureBackground
@onready var label: Label = %LabelEndTurn

var pulse_tween: Tween = null
var battle_style_normal: StyleBoxFlat
var battle_style_hover: StyleBoxFlat
var battle_style_pressed: StyleBoxFlat
var battle_style_disabled: StyleBoxFlat

func _ready() -> void:
	if button:
		button.focus_mode = Control.FOCUS_NONE
		button.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
		button.toggle_mode = false
	_init_battle_styles()

func _init_battle_styles() -> void:
	battle_style_normal = StyleBoxFlat.new()
	battle_style_normal.bg_color = Color(0.85, 0.16, 0.16, 0.95)
	battle_style_normal.set_corner_radius_all(6)
	battle_style_normal.border_width_bottom = 3
	battle_style_normal.border_width_top = 1
	battle_style_normal.border_width_left = 1
	battle_style_normal.border_width_right = 1
	battle_style_normal.border_color = Color(1.0, 0.38, 0.38, 0.9)

	battle_style_hover = StyleBoxFlat.new()
	battle_style_hover.bg_color = Color(0.96, 0.22, 0.22, 1.0)
	battle_style_hover.set_corner_radius_all(6)
	battle_style_hover.border_width_bottom = 3
	battle_style_hover.border_width_top = 1
	battle_style_hover.border_width_left = 1
	battle_style_hover.border_width_right = 1
	battle_style_hover.border_color = Color(1.0, 0.6, 0.6, 1.0)

	battle_style_pressed = StyleBoxFlat.new()
	battle_style_pressed.bg_color = Color(0.65, 0.1, 0.1, 1.0)
	battle_style_pressed.set_corner_radius_all(6)

	battle_style_disabled = StyleBoxFlat.new()
	battle_style_disabled.bg_color = Color(0.42, 0.16, 0.16, 0.6)
	battle_style_disabled.set_corner_radius_all(6)
	battle_style_disabled.border_color = Color(0.5, 0.2, 0.2, 0.4)

## Configure l'état du bouton selon qu'on est en phase de préparation (tour 0) ou en combat.
func setup_mode(is_prep: bool, is_disabled: bool) -> void:
	button.disabled = is_disabled
	if is_prep:
		_apply_battle_theme(true)
		label.text = tr("UI_BUTTON_START_BATTLE")
		if not is_disabled:
			start_pulse()
		else:
			stop_pulse()
	else:
		stop_pulse()
		_apply_battle_theme(false)
		label.text = tr("UI_BUTTON_END_TURN")

func set_btn_disabled(p_disabled: bool) -> void:
	button.disabled = p_disabled
	if p_disabled:
		stop_pulse()

func _apply_battle_theme(is_battle_start: bool) -> void:
	if is_battle_start:
		texture_bg.visible = false
		button.add_theme_stylebox_override("normal", battle_style_normal)
		button.add_theme_stylebox_override("hover", battle_style_hover)
		button.add_theme_stylebox_override("pressed", battle_style_pressed)
		button.add_theme_stylebox_override("disabled", battle_style_disabled)
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	else:
		texture_bg.visible = true
		button.remove_theme_stylebox_override("normal")
		button.remove_theme_stylebox_override("hover")
		button.remove_theme_stylebox_override("pressed")
		button.remove_theme_stylebox_override("disabled")
		button.remove_theme_stylebox_override("focus")
		label.remove_theme_color_override("font_color")

func start_pulse() -> void:
	if pulse_tween and pulse_tween.is_valid():
		return
	var btn_size: Vector2 = size
	if btn_size == Vector2.ZERO:
		btn_size = get_combined_minimum_size()
	pivot_offset = btn_size / 2.0
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(self, "scale", Vector2(1.06, 1.06), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_pulse() -> void:
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
		pulse_tween = null
	scale = Vector2.ONE
