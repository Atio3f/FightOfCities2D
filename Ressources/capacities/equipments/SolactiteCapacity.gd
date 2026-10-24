extends AbstractCapacity
class_name SolactiteCapacity
# Freeze an unit at one tile
const PERC_DMG = 0
const FREEZE_AMT = 1

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:SolactiteCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire
	
	super(id, imgPath, unit, 0, -1, 1, -1) # Pas de cooldown mais consomme toutes les attaques
	self.targetTypeZone = TargetZone.CIRCULAR

func conditionActivation(targetTile: AbstractTile, targetUnits: Array) -> bool:
	if targetUnits.is_empty():
		return false
	var targetUnit: AbstractUnit = targetUnits[0]
	
	# La cible doit être d'une autre équipe
	if targetUnit.team == unitAssociated.team:
		return false
		
	return super.conditionActivation(targetTile, targetUnits)

func onActivation(targetTile: AbstractTile, targetUnits: Array) -> void:
	if targetUnits.is_empty():
		return
		
	var targetUnit: AbstractUnit = targetUnits[0]
	
	var unitRef: AbstractUnit = unitAssociated
	
	targetUnit.addEffect(FreezeEffect.new(targetUnit, FREEZE_AMT))
	
	super.onActivation(targetTile, targetUnits)
