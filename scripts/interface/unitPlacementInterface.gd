class_name unitPlacementInterface extends MarginContainer

var id: String 	#Id of the unit
var player: AbstractPlayer = GameManager.getMainPlayer()
var coords: Vector2i #Coords of the interface tile

##Set the unit preview label and texture
func setUnitPreview(unit: AbstractUnit, coords: Vector2i) -> void :
	self.id = unit.idUnit
	self.coords = coords
	%Preview.text = getPreviewText(unit, Global.unitsStrings["en"][id]["NAME"])
	if unit.img != null and unit.img != "" :
		%BtnUnit.icon = load(unit.getImagePath()+"_p.png")

##Add a preview text on top
func getPreviewText(unit:AbstractUnit, name: String) -> String :
	var finalText : String = name + "\nG"+ str(unit.GRADE)
	return finalText

func _on_btn_unit_button_up():
	#Check if we're on a preparation turn
	if TurnManager.turn == 0:
		Global.gameManager.placeUnit(id, player, MapManager.getTileAt(coords))
		player.hand.unitsStock.erase(id)
	else :
		print("NOT YOUR TURN")	#Will need a pop up message later
	deleteInterface()

func disableBtn() -> void:
	%BtnUnit.disabled = true

func deleteInterface() -> void:
	player.playerPointer.interfaceJoueurI.clearInterface()
