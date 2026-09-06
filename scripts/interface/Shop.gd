extends AbstractMetaUI
class_name ShopUI

var shop_logic: AbstractShop
var shop_data: Dictionary

# Assure-toi d'ajouter ces noeuds dans ta scène Shop.tscn
# @onready var background = $Background # TextureRect
# @onready var vendor_sprite = $VendorArea/VendorSprite # TextureRect
# @onready var items_container = $ItemsContainer # HBoxContainer ou GridContainer
# @onready var leave_button = $LeaveButton # Button

func display(metaUI: MetaUI) -> void:
	pass

func _ready() -> void:
	# Connect leave button
	if has_node("LeaveButton"):
		get_node("LeaveButton").pressed.connect(_on_leave_button_pressed)
		
	# Connect gold signal
	Global.update_gold.connect(_on_update_gold)
	if GameManager.getMainPlayer():
		_on_update_gold(GameManager.getMainPlayer().gold)

func _on_update_gold(gold_amount: int) -> void:
	if has_node("GoldLabel"):
		get_node("GoldLabel").text = str(gold_amount) + " Or"

func setup(logic: AbstractShop, data: Dictionary) -> void:
	shop_logic = logic
	shop_data = data
	
	if not is_node_ready():
		await ready
		
	# TODO: Appliquer le background et le sprite du vendor
	# if shop_logic.background_id != "":
	# 	background.texture = load(shop_logic.background_id)
		
	refresh_items()

func refresh_items() -> void:
	var container = get_node_or_null("ItemsContainer")
	if not container:
		push_error("ItemsContainer manquant dans Shop.tscn")
		return
		
	if shop_logic.get("layout_columns") != null and container is GridContainer:
		container.columns = shop_logic.layout_columns
		
	# Clean last screen
	for child in container.get_children():
		child.queue_free()
		
	# Regenerate available items
	for i in range(shop_logic.available_items.size()):
		var shop_item = shop_logic.available_items[i]
		var item_id = shop_item.id
		var item_price = shop_item.price
		
		# Si c'est un espace vide dans le layout
		if item_id == "":
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(120, 120)
			container.add_child(spacer)
			continue
		
		var reward_data = RewardDb.REWARDS_DICO.get(item_id, {})
		var title = reward_data.get("title", item_id)
		var icon_name = reward_data.get("icon_name", "")
		
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.custom_minimum_size = Vector2(120, 120)
		
		if icon_name != "":
			var icon = TextureRect.new()
			icon.texture = load("res://assets/sprites/" + icon_name)
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.custom_minimum_size = Vector2(64, 64)
			vbox.add_child(icon)
		
		var btn = Button.new()
		btn.text = title + "\n" + str(item_price) + " Or"
		btn.custom_minimum_size = Vector2(120, 40)
		
		# Disable button if player hasn't enough gold
		if GameManager.getMainPlayer().gold < item_price:
			btn.disabled = true
			btn.add_theme_color_override("font_disabled_color", Color(1, 0.3, 0.3)) # Red
		
		btn.pressed.connect(func(): _on_buy_button_pressed(i))
		vbox.add_child(btn)
		
		container.add_child(vbox)

func _on_buy_button_pressed(index: int) -> void:
	var success = shop_logic.buy_item(GameManager.getMainPlayer(), index)
	if success:
		print("Successful buy")
		refresh_items() # Refresh display
	else:
		print("Not enough gold")

func _on_leave_button_pressed() -> void:
	if shop_data.has("nextMission"):
		GameManager.campaign.nextMission = shop_data["nextMission"]
		GameManager.campaign.startNextMission()
		
	# Destroy shop scene to let place for next zone/map
	self.queue_free()
