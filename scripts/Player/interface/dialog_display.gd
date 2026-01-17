extends PanelContainer
class_name DialogDisplay

## Set base goal infos & signal to update it later
func setDialog(dialog: DialogInterface) -> void :
	%DialogText.text = dialog.text
	# TODO Find a place to show the unit name who talk -> pê pas besoin ?
	# TODO Set img on DialogImg depending to dialog.imgPath, wil need to stock all img types in one folder
	#%DialogImg


## Remove this interface when the dialogs ended
func deleteDialog() -> void :
	queue_free()
