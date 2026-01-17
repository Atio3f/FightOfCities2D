extends Node


var dialogs: Dictionary = {}

func _ready(): #TODO Regrouper les load dans un script global ?
	load_dialogs_from_file("res://translations/dialogs.json")

## Load dialogs on start from the json file
func load_dialogs_from_file(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("File not found : " + path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.parse_string(content)
	
	if json:
		dialogs = json
	else:
		push_error("Erreur de syntaxe JSON dans le fichier de dialogues.")

# Use to get a specific dialog with its id
func getDialog(dialog_id: String) -> Array[Dictionary]:
	if dialogs.has(dialog_id):
		var dialogs_list: Array[Dictionary] = []
		dialogs_list.assign(dialogs[dialog_id])
		return dialogs_list
	else:
		push_error("Dialog id not found : " + dialog_id)
		return []
