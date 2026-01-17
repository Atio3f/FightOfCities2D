extends Node
class_name DialogInterface

var nameTalking: String = ""
var text: String = ""
var imgPath: String = ""

## Set base goal infos & signal to update it later
func setDialog(dialogData: Dictionary) -> void :
	nameTalking = dialogData["name"] #TODO Use name on DialogDisplay
	text = dialogData["text"]
	if dialogData.has("feeling") :
		imgPath = dialogData["unit"] + dialogData["feeling"]
	else : 
		imgPath = dialogData["unit"] + "_neutral"

## Recover dialog, use on a context of load save or on new mission to start
static func recoverDialog(dialogId: String) -> Array[DialogInterface] : 
	var dialogsList: Array[DialogInterface] = []
	# Get dialogs list associated to dialog id
	var dialogsData: Array[Dictionary] = DialogDb.getDialog(dialogId)
	var dialog: DialogInterface
	for dialogData: Dictionary in dialogsData :
		dialog = DialogInterface.new()
		# Find dialog id on db
		dialog.setDialog(dialogData)
		dialogsList.append(dialog)
		# TODO Trouver meilleur moyen d'enregistrer dialogue
	return dialogsList
