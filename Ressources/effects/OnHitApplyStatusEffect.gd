extends AbstractEffect
class_name OnHitApplyStatusEffect

const idEffect = "set1:OnHitApplyStatusEffect"
const img = ""

# value_A: amount of stacks to apply
# value_B: condition (0 = Any attack, 1 = Melee only, 2 = Ranged only)
# value_C: status index

const STATUS_IDS = [
	"set1:ParalysisEffect",
	"set1:FreezeEffect",
	"set1:PoisonEffect",
	"set1:BurnEffect",
	"set1:BleedEffect"
]

func _init(unit: AbstractUnit, remainingTurns: int, value_A: int = 0, value_B: int = 0, value_C: int = 0, counter: int = 0):
	super._init(idEffect, img, unit, remainingTurns, 0, true, value_A, value_B, value_C, counter)

func onDamageDealedAfterReduction(unit: AbstractUnit, damage: int, damageType: DamageTypes.DamageTypes, visualisation: bool) -> int:
	if !visualisation and unit != null and damage > 0:
		# Calc distance with target
		var diff: Vector2i = (unitAssociated.tile.getCoords() - unit.tile.getCoords()).abs()
		var distance: int = diff.x + diff.y
		
		var conditionMet = false
		if value_B == 0:
			conditionMet = true
		elif value_B == 1 and unitAssociated.range == 1 and distance == 1:
			conditionMet = true
		elif value_B == 2 and distance > 1:
			conditionMet = true
			
		if conditionMet and value_C >= 0 and value_C < STATUS_IDS.size():
			var status_id = STATUS_IDS[value_C]
			if EffectDb.EFFECTS.has(status_id):
				# Apply the status effect to the target (unit), passing value_A as the stack amount
				var effect = EffectDb.EFFECTS[status_id].new(unit, -1, 0, 0, 0, value_A)
				unit.addEffect(effect)
	return damage

func getDescription() -> String:
	# Get the base parsed description from AbstractEffect (which handles !VA!, etc. and parses icons)
	var desc = super.getDescription()
	
	# Replace !STATUS! with the right tag
	var status_tag = ""
	match value_C:
		0: status_tag = "[PARALYSIS]"
		1: status_tag = "[FREEZE]"
		2: status_tag = "[POISON]"
		3: status_tag = "[BURN]"
		4: status_tag = "[BLEED]"
	desc = desc.replace("!STATUS!", status_tag)
	
	# Replace !COND! with the localized condition string
	var cond_key = ""
	match value_B:
		0: cond_key = "COND_ANY_ATTACK"
		1: cond_key = "COND_MELEE_ATTACK"
		2: cond_key = "COND_RANGED_ATTACK"
	desc = desc.replace("!COND!", tr(cond_key))
	
	# Parse icons again since we just injected a BBCode tag like [PARALYSIS]
	return TextParser.parse_icons(desc)
