extends Control
class_name MetaUI

func placeInterface(interface: AbstractMetaUI, removeOld: bool) -> void :
	#Remove old interface
	if removeOld : 
		var removeable : bool
		for metaUI: AbstractMetaUI in self.get_children() :
			removeable = metaUI.deleteInterface()
			if removeable : metaUI.queue_free()
	##Place new interface
	add_child(interface)
	interface.display(self)
	$"../../..".toggleMetaUI()

##Function to swap map when the reward have been taken
func onRewardInterfaceClosed() -> void:
	print("CLOSED")
	GameManager.campaign.startNextMission()
	$"../../..".toggleCombatUI()
