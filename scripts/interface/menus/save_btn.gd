extends MarginContainer
class_name SaveBtn
#Button containing one save
var save: Dictionary = {}
var menu: MainMenu
signal loadSaveSignal


func toggleSave(saveName: String, menu: MainMenu) -> void :
	save = GameManager.getSave(saveName)
	save["saveName"] = saveName
	self.menu = menu
	%SaveName.text = saveName

##Send save to the game on click
func _on_button_pressed():
	#JSP SI c'est faisable avec un signal pour ça que j'ai ajouté self.menu
	self.menu.loadSave(save)

## Display save name when hovering the btn
func _on_button_mouse_entered():
	%SaveName.visible = true


## Hide save name
func _on_button_mouse_exited():
	%SaveName.visible = false
