class_name StartBattleWarningPopup
extends Control

## Fenêtre modale d'avertissement affichée avant de lancer le combat
## si le joueur n'a pas optimisé sa préparation (unités non placées, équipements inutilisés).

signal confirmed
signal cancelled

@onready var warnings_container: VBoxContainer = %WarningsList
@onready var btn_cancel: Button = %BtnCancel
@onready var btn_confirm: Button = %BtnConfirm

func _ready() -> void:
	if btn_cancel:
		btn_cancel.text = tr("UI_BUTTON_RETURN_TO_PREP")
		btn_cancel.pressed.connect(_on_cancel_pressed)
	if btn_confirm:
		btn_confirm.text = tr("UI_BUTTON_START_ANYWAY")
		btn_confirm.pressed.connect(_on_confirm_pressed)

## Vérifie les alertes de préparation pour un joueur donné.
## Retourne un tableau de chaînes d'avertissement (vide si tout est prêt).
static func get_warnings(player: AbstractPlayer) -> Array[String]:
	var warnings: Array[String] = []
	if player == null:
		return warnings

	# 1. Vérification des unités non placées alors qu'on peut encore en mettre
	if player.units.size() < player.maxUnits and player.hand.unitsStock.size() > 0:
		var has_placeable_tile := GameManager.getPlaceablesTiles().size() > 0
		if has_placeable_tile:
			var can_fit_any := false
			for stored: StoredUnit in player.hand.unitsStock:
				var stats = UnitDb.getUnitStats(stored.id)
				var unit_weight: int = stats.grade + stored.statModifiers.get("grade", 0)
				if player.weight + unit_weight <= player.maxWeight:
					can_fit_any = true
					break
			if can_fit_any:
				warnings.append("UI_WARNING_UNITS_REMAINING")

	# 2. Vérification des équipements : moins de la moitié des unités équipées alors qu'il reste du stock
	var deployed_units := player.getUnits()
	if deployed_units.size() > 0 and player.hand.equipmentsStock.size() > 0:
		var equipped_count := 0
		for unit: AbstractUnit in deployed_units:
			if unit.equipment != null:
				equipped_count += 1
		var min_required := int(ceil(deployed_units.size() / 2.0))
		if equipped_count < min_required:
			warnings.append("UI_WARNING_EQUIPMENTS_REMAINING")

	return warnings

## Affiche la popup avec la liste des avertissements fournis.
func display_warnings(warnings: Array[String]) -> void:
	for child in warnings_container.get_children():
		child.queue_free()

	for text_warning in warnings:
		var h_box := HBoxContainer.new()

		var icon_lbl := Label.new()
		icon_lbl.text = "⚠️"
		icon_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		h_box.add_child(icon_lbl)

		var lbl := Label.new()
		lbl.text = tr(text_warning)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h_box.add_child(lbl)

		warnings_container.add_child(h_box)

	visible = true

func _on_cancel_pressed() -> void:
	visible = false
	cancelled.emit()

func _on_confirm_pressed() -> void:
	visible = false
	confirmed.emit()
