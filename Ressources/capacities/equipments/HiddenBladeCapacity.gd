extends AbstractCapacity
class_name HiddenBladeCapacity

const PERC_DMG = 0.8
const PARALYSIS_AMT = 3

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:HiddenBladeCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire
	
	super(id, imgPath, unit, 0, 1, 1, 1)
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
	
	# Les dégâts sont arrondis au supérieur comme les autres capacités
	var damage: int = ceil(unitAssociated.power * PERC_DMG)
	if damage < 0:
		damage = 0
		
	var unitRef: AbstractUnit = unitAssociated
	var dmgType = unitAssociated.damageType
	
	targetUnit.onDamageTaken(unitRef, damage, dmgType, false)
	targetUnit.addEffect(ParalysisEffect.new(targetUnit, -1, 0, 0, 0, PARALYSIS_AMT))
	
	super.onActivation(targetTile, targetUnits)
