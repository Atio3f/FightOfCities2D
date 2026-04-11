extends AbstractUnit
class_name Banâne

const STATS: UnitStats = preload("res://Ressources/units/magicalBeasts/Banâne.tres")

static func initialize(unit: AbstractUnit, playerAssociated: AbstractPlayer):
	unit.initializeStats(STATS, playerAssociated)
	## 2 abilities, onObtain one unit gain 2V permanently (like a permanently upgrade but w/out cost) and a second ability that can be activate on corresponding action menu to give an unit a bonus attack this turn with a 6 turns cooldown
	unit.tags.append(Tags.tags.MAGICAL_BEAST)
	unit.movementTypes = [MovementTypes.movementTypes.WALK]
	unit.actualMovementTypes = MovementTypes.movementTypes.WALK

static func onObtained(unitData: StoredUnit, player: AbstractPlayer, reward: AbstractReward = null) -> bool:
	# and a second ability that can be activate on corresponding action menu to give an unit a bonus attack this turn with a 6 turns cooldown
	if reward:
		reward.openUnitSelectionForUpgrade("UpgradeBanâneEffect")
	else:
		var selectionUI: BonusUnitSelectionInterface = preload("res://nodes/interface/metaUI/placeholderScreens/rewardUpgradeUnitSelectionInterface.tscn").instantiate()
		selectionUI.setup("UpgradeBanâneEffect", null)
		var metaUI = player.metaInterface
		metaUI.add_child(selectionUI)
	return true
