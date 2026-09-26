extends AbstractCapacity
class_name SplinteringMalletCapacity
## Base damage
const FLAT_DMG = 8
## % of P from unit, will increases total damage from SplinteringMallet
const PERC_DMG = 1

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:SplinteringMalletCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire ou icône générique
	
	super(id, imgPath, unit, 0, 1, 1, -1)
	self.targetTypeZone = TargetZone.CIRCULAR # 1 de portée autour de soi comme une attaque

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
	
	# Attack for FLAT_DMG + PERC_DMG % of unit.P
	## Les dégâts sont arrondis au supérieur comme dans la 1ère version papier
	var damage: int = FLAT_DMG + ceil(unitAssociated.power * PERC_DMG)
	if damage < 0:
		damage = 0
		
	var unitRef: AbstractUnit = unitAssociated
	var dmgType = unitAssociated.damageType
	
	## Unequip equipment and remove it from inventory BEFORE dealing damage.
	## This prevents the equipment from being saved if the attack ends the mission.
	unitRef.unequipEquipment()
	unitRef.player.deleteEquipment("set1:SplinteringMallet")
	
	targetUnit.onDamageTaken(unitRef, damage, dmgType, false)
	
	super.onActivation(targetTile, targetUnits)
