extends AbstractCapacity
class_name BananarangCapacity
## Base damage, will be increases by BONUS_DMG_MONKEYS if equipped by a Monkey
const FLAT_DMG = 6
## MONKEYS deals 2 more damage with Bananarang ability
const BONUS_DMG_MONKEYS: int = 2
## % of P from unit, will increases total damage from Bananarang
const PERC_DMG = 0.33

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:BananarangCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire ou icône générique
	
	super(id, imgPath, unit, 0, 1, 3, -1)
	self.targetTypeZone = TargetZone.CIRCULAR # 3 de portée autour de soi comme une attaque

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
	
	# Attack for FLAT_DMG + BONUS_DMG_MONKEYS + PERC_DMG % of unit.P if not a Monkey
	## Les dégâts sont arrondis au supérieur comme dans la 1ère version papier
	var damage: int
	if unitAssociated.tags.has(Tags.tags.MONKEY): 
		damage = FLAT_DMG + BONUS_DMG_MONKEYS + ceil(unitAssociated.power * PERC_DMG)
	# Attack for FLAT_DMG + PERC_DMG % of unit.P if not a Monkey
	else :
		damage = FLAT_DMG + ceil(unitAssociated.power * PERC_DMG)
	if damage < 0:
		damage = 0
	targetUnit.onDamageTaken(unitAssociated, damage, unitAssociated.damageType, false)
	
	super.onActivation(targetTile, targetUnits)
