class_name interfacePlacementCards
extends Control

var coords: Vector2i	#Coords of the interface tile
 
##Place elements on the interface
func setInterface(coords: Vector2i, unitPlacementIScene: PackedScene) -> void :
	clear()
	self.coords = coords
	var p: AbstractPlayer = GameManager.getMainPlayer()
	##NORMALEMENT ON RECUPERE LES UNITES QU'IL N'A PAS PLACE ET QU'IL PEUT PLACER
	
	#Pour le moment on va juste récupérer la liste des unités dispos
	var unit: AbstractUnit
	var unitPlacementI: unitPlacementInterface
	for unitS: String in p.hand.getUnitsStocked():
		unit = UnitDb.UNITS[unitS].new()	#Get unit
		unit.imgPath = unit.img
		unitPlacementI = unitPlacementIScene.instantiate()	#Get the scene which shows the unit infos
		unitPlacementI.setUnitPreview(unit, coords)	#Add infos and coords to the scene
		%UnitsToPlace.add_child(unitPlacementI)
		#Disable the button if player haven't enough weight or have max units reached to place it
		if !GameManager.unitCanBePlacedOnTile(p, MapManager.getTileAt(coords), unit.GRADE) or not p.maxUnits > p.units.size():
			unitPlacementI.disableBtn()

###Delete all children
func clear() -> void:
	for element: Node in %UnitsToPlace.get_children() :
		element.queue_free()
