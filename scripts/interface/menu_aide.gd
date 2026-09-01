extends Control

@onready var list_container = %ListContainer
@onready var details_container = %DetailsContainer

@onready var help_list = %HelpList
@onready var help_title = %HelpTitle
@onready var help_icon = %HelpIcon
@onready var help_description = %HelpDescription

@onready var previous_button = %PreviousButton
@onready var next_button = %NextButton
@onready var page_label = %PageLabel

# Dictionary associating the help ID to its information and pages
# Description texts will use keys like HELP_DESC_COMBAT_0, HELP_DESC_COMBAT_1...
var helps_data = {
	"DEPLACEMENT": {
		"menu_icon": preload("res://assets/interface/unite/UIuniteInfosStats(512x512).png"),
		"pages": [
			preload("res://assets/interface/unite/UIuniteInfosStats(512x512).png") # Page 1 (index 0)
		]
	},
	"COMBAT": {
		"menu_icon": preload("res://assets/interface/unite/UIuniteInfosStats(512x512).png"),
		"pages": [
			preload("res://assets/interface/unite/UIuniteInfosStats(512x512).png"), # Page 1 (index 0)
			preload("res://assets/interface/unite/UIuniteInfosStats(512x512).png")  # Page 2 (index 1)
		]
	}
}

var unlocked_helps: Array[String] = []
var current_help: String = ""
var current_page: int = 0

func _ready():
	visible = false
	
	# Ensure it opens on the list view when made visible
	visibility_changed.connect(_on_visibility_changed)
	
	Global.unlock_help.connect(_on_help_unlocked)
	
	# Pre-unlocked helps for testing
	_on_help_unlocked("DEPLACEMENT")
	_on_help_unlocked("COMBAT")

func _on_visibility_changed():
	if visible:
		list_container.visible = true
		details_container.visible = false

# Handle Escape key (ui_cancel)
func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		if details_container.visible:
			_on_back_button_pressed() # If reading a help, Escape returns to the list
		else:
			_on_close_button_pressed() # If on the list, Escape closes the menu
		
		# Prevent the pause menu or other menus from opening at the same time
		get_viewport().set_input_as_handled() 

func _on_help_unlocked(help_id: String):
	if not unlocked_helps.has(help_id):
		unlocked_helps.append(help_id)
		refresh_list()

func refresh_list():
	for child in help_list.get_children():
		child.queue_free()
		
	for help_id in unlocked_helps:
		var btn = Button.new()
		btn.text = tr("HELP_TITLE_" + help_id) 
		
		if helps_data.has(help_id) and helps_data[help_id].has("menu_icon"):
			btn.icon = helps_data[help_id]["menu_icon"]
			
		btn.expand_icon = true
		btn.custom_minimum_size = Vector2(0, 70)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		btn.pressed.connect(func(): display_help(help_id))
		help_list.add_child(btn)

func display_help(help_id: String):
	current_help = help_id
	current_page = 0
	
	# Toggle views
	list_container.visible = false
	details_container.visible = true
	
	help_title.text = tr("HELP_TITLE_" + help_id)
	update_page()

func update_page():
	if not helps_data.has(current_help):
		return
		
	var nb_pages = helps_data[current_help]["pages"].size()
	
	# Translation key: use the index (0, 1, 2...) to fetch the text for the current page
	help_description.text = tr("HELP_DESC_" + current_help + "_" + str(current_page))
	
	# Load page image
	if nb_pages > 0 and current_page < nb_pages:
		help_icon.texture = helps_data[current_help]["pages"][current_page]
		
	# Update pagination UI
	page_label.text = str(current_page + 1) + " / " + str(max(1, nb_pages))
	
	# Enable/Disable arrows depending on position
	previous_button.disabled = (current_page == 0)
	next_button.disabled = (current_page >= nb_pages - 1)

func _on_previous_button_pressed():
	if current_page > 0:
		current_page -= 1
		update_page()

func _on_next_button_pressed():
	var nb_pages = helps_data[current_help]["pages"].size()
	if current_page < nb_pages - 1:
		current_page += 1
		update_page()

func _on_back_button_pressed():
	# Return to the list
	details_container.visible = false
	list_container.visible = true

func _on_close_button_pressed():
	# Completely close the help menu
	visible = false
