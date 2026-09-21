extends PanelContainer
class_name UnitInfoCard


@onready var unit_icon: TextureRect = %UnitIcon
@onready var unit_name_label: Label = %UnitName
@onready var unit_grade_label: Label = %UnitGrade
@onready var unit_potentiel_label: Label = %UnitPotentiel

@onready var hp_label: Label = %HPLabel
@onready var power_label: Label = %PowerLabel
@onready var armor_label: Label = %ArmorLabel
@onready var speed_label: Label = %SpeedLabel
@onready var range_label: Label = %RangeLabel
@onready var wisdom_label: Label = %WisdomLabel

@onready var equipment_section: Control = %EquipmentSection
@onready var equipment_icon: TextureRect = %EquipmentIcon

@onready var effects_list: VBoxContainer = %EffectsList


func _ready() -> void:
	# Expand card size (would need maybe to be adjust on scene also)
	custom_minimum_size = Vector2(400, 0)
	
	var style = get_theme_stylebox("panel").duplicate()
	style.content_margin_left += 15
	style.content_margin_bottom += 15
	add_theme_stylebox_override("panel", style)


## Place the card at the top right of the viewport
## Basic placement for this card now
func placementTopRight(margin_right: float = 0, margin_top: float = 0) -> void:
	top_level = true # Detach the card from the parent's coordinate system (the whole screen becomes its reference)
	z_index = 30    # Ensure that it displays on top of all other interfaces
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	size = Vector2.ZERO # Force recalculation to min size
	position = Vector2(get_viewport_rect().size.x - size.x - margin_right, margin_top)


## Place the card to the right of a given UI control
## should not be used
func place_next_to(node: Control, offset_x: float = 25, offset_y: float = 0) -> void:
	top_level = true
	z_index = 10
	size = Vector2.ZERO
	var global_pos = node.global_position
	global_position = Vector2(global_pos.x + node.size.x + offset_x, global_pos.y + offset_y)


## Init with unit ID (Show base stats)
func setup_from_id(unit_id: String) -> void:
	var unit_data = UnitDb.getUnit(unit_id)
	var stats = UnitDb.getUnitStats(unit_id)
	
	if unit_data.is_empty() or stats == null:
		push_error("UnitInfoCard: Impossible de charger les données pour l'unité " + unit_id)
		return
		
	# Header
	unit_name_label.text = tr(unit_data["name"])
	unit_grade_label.text = "Grade: " + str(stats.grade)
	
	var img_path = "res://assets/sprites/units/" + stats.imgPath + "_p.png"
	if ResourceLoader.exists(img_path):
		unit_icon.texture = load(img_path)
	
	# Base stats
	update_stats(
		str(stats.hpBase),
		stats.powerBase,
		stats.drBase,
		stats.mrBase,
		str(stats.speedBase),
		stats.attackRange,
		stats.wisdomBase,
		"0/" + str(stats.potential)
	)
	
	# Hide equipment (generic card)
	equipment_section.hide()
	
	# Base effects (optional, not implemented as effects are often applied dynamically)
	clear_effects()


## Init with stored data (Create temp unit to get effects and upgrades)
func setup_from_stored_unit(stored_data: StoredUnit, player: AbstractPlayer = null) -> void:
	if stored_data == null:
		return
		
	if player == null and Global.gameManager != null:
		player = Global.gameManager.getMainPlayer()
		
	# Dummy unit
	var dummy_unit = UnitDb.UNITS[stored_data.id].new()
	
	# Initialize unit (get base effects and stats)
	UnitDb.UNITS[stored_data.id].initialize(dummy_unit, player)
	
	# Remove from player's units (not add in game)
	if player != null:
		player.units.erase(dummy_unit)
	
	# Apply stored data (equipments and stat modifiers)
	stored_data.applyToUnit(dummy_unit)
	
	# Setup card from this unit
	setup_from_unit(dummy_unit)
	
	# Free memory (nodes not in tree need to be freed manually)
	if dummy_unit.equipment != null:
		dummy_unit.equipment.free()
	for effect in dummy_unit.effects:
		if is_instance_valid(effect):
			effect.free()
	dummy_unit.free()


## Initialisation par instance d'unité (Affiche les statistiques actuelles en jeu)
func setup_from_unit(unit: AbstractUnit) -> void:
	# Header
	unit_name_label.text = unit.getName()
	unit_grade_label.text = "Grade: " + str(unit.grade)
	unit_icon.texture = load(unit.getImagePath() + "_p.png")
	
	# Stats actuelles
	var current_hp = unit.hpActual + unit.hpTemp
	var hp_str = str(current_hp) + "/" + str(unit.hpMax)
	var speed_str = str(unit.speedRemaining) + "/" + str(unit.speed)
	
	var used_pot = 0
	if unit.statModifiers.has("potentialCost"):
		used_pot = unit.statModifiers["potentialCost"]
	var pot_str = str(used_pot) + "/" + str(unit.potential)
	
	update_stats(
		hp_str,
		unit.power,
		unit.dr,
		unit.mr,
		speed_str,
		unit.range,
		unit.wisdom,
		pot_str
	)
	
	# Équipement
	if unit.equipment != null:
		equipment_section.show()
		equipment_icon.texture = load(unit.equipment.getImagePath())
	else:
		equipment_section.hide()
		
	# Effets
	clear_effects()
	var effects_text = ""
	for effect in unit.effects:
		if not effect.hideEffect:
			if effects_text != "":
				effects_text += "\n"
			effects_text += effect.getDescription()
			
	if effects_text != "":
		var label = Label.new()
		label.text = effects_text
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		# Give it fixed width to make it wrap
		label.custom_minimum_size = Vector2(380, 0)
		effects_list.add_child(label)


func clear_effects() -> void:
	for child in effects_list.get_children():
		child.queue_free()

## Met à jour les labels avec les préfixes de stats
func update_stats(hp_str: String, power: int, dr: int, mr: int, speed_str: String, range_val: int, wisdom: int, potential_str: String) -> void:
	hp_label.text = "HP: " + hp_str
	power_label.text = "Power: " + str(power)
	armor_label.text = "DR|MR: " + str(dr) + "|" + str(mr)
	speed_label.text = "Speed: " + speed_str
	range_label.text = "Range: " + str(range_val)
	wisdom_label.text = "Wisdom: " + str(wisdom)
	#unit_potentiel_label.text = "Potential: " + potential_str
