extends AbstractCapacity
class_name BanâneBonusAttackCapacity

func _init(unit: AbstractUnit):
	# ID de la capacité utilisé pour sa traduction et sa récupération
	var id: String = "set1:BanâneBonusAttackCapacity"
	var imgPath: String = "res://assets/interface/CapaActiveTest.png" # Chemin temporaire ou icône générique
	
	super(id, imgPath, unit, 6, -1, -1)
	self.targetTypeZone = TargetZone.EVERYWHERE # N'importe où sur la carte

func conditionActivation(targetTile: AbstractTile, targetUnits: Array) -> bool:
	if targetUnits.is_empty():
		return false
	var targetUnit: AbstractUnit = targetUnits[0]
	
	# La cible doit être de notre équipe
	if targetUnit.team != unitAssociated.team:
		return false
		
	return true

func onActivation(targetTile: AbstractTile, targetUnits: Array) -> void:
	if targetUnits.is_empty():
		return
		
	var targetUnit: AbstractUnit = targetUnits[0]
	
	# Donne une attaque supplémentaire pour ce tour
	targetUnit.atkRemaining += 1
	
	# Check s'il n'y a pas besoin d'un indicateur de dégâts ou d'un affichage !
	# L'utilisateur a précisé pas besoin de texte visuel, juste le visuActions (déjà fait).
