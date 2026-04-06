class_name HRDiploma
extends AbstractTrinket

# All units recruited have +6 Max HP
# Un diplôme avec des cartes de divination pour mieux choisir ses recrues
const idItem = "set1:HRDiploma"
const img = "res://assets/sprites/trinkets/ArtOfWar"
const HP_GAIN = 6

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_COMMON, playerAssociated, HP_GAIN)

## Activate when you gain an unit
func onUnitGained(unitData: StoredUnit) -> StoredUnit :
	# Give max HP to all units recruited
	unitData.modifyStat("hpMax", value_A)
	return unitData
