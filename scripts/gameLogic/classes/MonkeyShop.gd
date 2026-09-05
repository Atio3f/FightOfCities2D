class_name MonkeyShop
extends AbstractShop

func _init() -> void:
	vendor_id = "set1:Monkey"
	background_id = "" # Will need to create background

func generate_items() -> void:
	# Example layout
	var layout = "ii u\\ii e"
	populate_from_layout(layout)
