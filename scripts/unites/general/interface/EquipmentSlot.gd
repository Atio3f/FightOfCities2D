class_name EquipmentSlot
extends Sprite2D

@onready var hover_area: Area2D = $HoverArea
@onready var tooltip_label: Label = $TooltipLabel

func _ready() -> void:
	tooltip_label.visible = false
	hover_area.mouse_entered.connect(_on_mouse_entered)
	hover_area.mouse_exited.connect(_on_mouse_exited)
	
	# Placeholder text, to be replaced by actual equipment data later
	tooltip_label.text = "Équipement Vide"

func _on_mouse_entered() -> void:
	tooltip_label.visible = true

func _on_mouse_exited() -> void:
	tooltip_label.visible = false
