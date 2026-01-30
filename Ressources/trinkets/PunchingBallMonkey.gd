class_name PunchingBallMonkey 
extends AbstractTrinket

# All units with less than ${POWER_THRESHOLD} power base gain ${POWER_GAIN} Power
# Le tout dernier punching ball inventé par les Monkey pour renforcer leurs membres les plus faibles
const idItem = "set1:PunchingBallMonkey"
const img = "res://assets/sprites/trinkets/ArtOfWar"
const POWER_GAIN = 3
const POWER_THRESHOLD = 8 # Max power base to gain buff from this

func _init(playerAssociated: AbstractPlayer) -> void:
	super.initialize(idItem, img, Rarities.TRINKET_UNCOMMON, playerAssociated, POWER_GAIN, POWER_THRESHOLD)


func onUnitPlace(unit: AbstractUnit) -> void :
	# Give Power to all units with less than a certain power threshold
	if unit.player == playerAssociated && unit.powerBase < value_B:
		unit.power += value_A
