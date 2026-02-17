extends Control
class_name MetaUI

var interfaceQueue: Array[AbstractMetaUI] = [] # Keep track of the next interface to show up
var current_interface: AbstractMetaUI = null

func placeInterface(interface: AbstractMetaUI, removeOld: bool = true) -> void :
	# Place on queue the interface if one is already displayed
	if current_interface != null:
		interfaceQueue.append(interface)
		return
	
	_displayInterface(interface, removeOld)

func _displayInterface(interface: AbstractMetaUI, removeOld: bool) -> void:
	if removeOld: 
		for child in get_children():
			if child is AbstractMetaUI:
				child.queue_free()
	
	current_interface = interface
	add_child(interface)
	interface.display(self)
	
	if $"../../..".has_method("toggleMetaUI"):
		$"../../..".toggleMetaUI()
	else : push_error("MISSING METHOD toggleMetaUI in supposed Node AbstractPlayer")


## Function to swap map when the reward have been taken
func onRewardInterfaceClosed() -> void:
	## Remove active interface
	print("CLOSED")
	if current_interface != null:
		current_interface.queue_free()
		current_interface = null
	
	# Check interfaces still waiting
	if interfaceQueue.is_empty() :
		## If no interface in queue, we start next mission
		GameManager.campaign.startNextMission()
		$"../../..".toggleCombatUI()
	else :
		## If one or more interface is waiting in queue, we display the first one
		var nextInterface = interfaceQueue.pop_front()
		# Display interface, we already clear last interface so we put false as second param
		_displayInterface(nextInterface, false)



func saveInterfaces() -> Array :
	var interfaces:= []
	for interface: AbstractMetaUI in get_children():
		interfaces.append(interface.saveInterface())
	return interfaces
