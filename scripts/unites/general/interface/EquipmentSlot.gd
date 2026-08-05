class_name EquipmentSlot
extends TextureRect

@onready var tooltip_label: Label = $TooltipLabel

func _ready() -> void:
	tooltip_label.visible = false
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	# Placeholder text, to be replaced by actual equipment data later
	tooltip_label.text = "Aucun Équipement"

func _on_mouse_entered() -> void:
	tooltip_label.visible = true

func _on_mouse_exited() -> void:
	tooltip_label.visible = false

func updateEquipment(equipment: AbstractEquipment) -> void :
	self.texture = load(equipment.getImagePath())
	self.visible = true
	tooltip_label.text = equipment.getName()

# Clear self in case of removed equipment
func clear() -> void :
	self.texture = null
	self.visible = false
	tooltip_label.text = "Aucun Équipement"
