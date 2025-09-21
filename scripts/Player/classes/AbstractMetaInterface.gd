extends ColorRect
class_name AbstractMetaUI
##Abstract Class used for every interface showed between fight like rewards interface or path interface

signal close_ui


##Will contains things that needed to be saved or last action
# Return true if the node can be deleted
func deleteInterface() -> bool :
	return true


func getEndSignal() -> Signal :
	return close_ui


func display(metaUI: MetaUI) -> void :
	pass
