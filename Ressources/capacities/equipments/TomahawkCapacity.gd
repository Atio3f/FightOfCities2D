extends AbstractCapacity
class_name TomahawkCapacity
## % of P from unit, will increases total damage from Tomahawk
const PERC_DMG = 0.8
## Base reach
const BASE_REACH = 2
## Threshold to gain one more reach (3)
const THRESHOLD_REACH = 20
const BONUS_REACH_AMT = 1

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:TomahawkCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire ou icône générique
	if unit.power >= THRESHOLD_REACH :
		super(id, imgPath, unit, 0, 1, BASE_REACH + BONUS_REACH_AMT, -1)
	else:
		super(id, imgPath, unit, 0, 1, BASE_REACH, -1)
	self.targetTypeZone = TargetZone.CIRCULAR # 2 de portée autour de soi comme une attaque

func isUsable() -> bool:
	# Check just before that we have enough power to gain bonus reach
	targetRange = BASE_REACH
	if unitAssociated.power >= THRESHOLD_REACH :
		targetRange += BONUS_REACH_AMT
	return super.isUsable()

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
	
	# Attack for PERC_DMG % of unit.P
	## Les dégâts sont arrondis au supérieur comme les autres capacités
	var damage: int
	damage = ceil(unitAssociated.power * PERC_DMG)
	if damage < 0:
		damage = 0
	targetUnit.onDamageTaken(unitAssociated, damage, unitAssociated.damageType, false)
	
	super.onActivation(targetTile, targetUnits)
