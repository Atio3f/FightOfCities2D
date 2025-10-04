extends MarginContainer
class_name SaveBtn
#Button containing one save
var save: Dictionary = {}
var menu: MainMenu
signal loadSaveSignal


func toggleSave(saveName: String, menu: MainMenu) -> void :
	save = GameManager.getSave(saveName)
	self.menu = menu

##Send save to the game on click
func _on_button_pressed():
	#JSP SI c'est faisable avec un signal pour ça que j'ai ajouté self.menu
	self.menu.loadSave(save)
