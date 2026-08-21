extends AbstractCapacity
class_name PreciseShotCapacity

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:PreciseShotCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire ou icône générique
	
	super(id, imgPath, unit, 3, 1, 4, -1)
	self.targetTypeZone = TargetZone.CIRCULAR # 4 de portée autour de soi comme une attaque

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
	
	# Attack for 200% power - enemy speed
	var damage = (unitAssociated.power * 2) - targetUnit.speed
	if damage < 0:
		damage = 0
	targetUnit.onDamageTaken(unitAssociated, damage, unitAssociated.damageType, false)
	
	super.onActivation(targetTile, targetUnits)
