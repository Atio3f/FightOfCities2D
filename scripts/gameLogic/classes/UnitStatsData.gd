extends Resource
class_name UnitStats

# --- IDENTITÉ ---
@export_group("Identity")
@export var id: String = "set1:" ## Id of the unit
@export var imgPath: String = "Monkey" ## 

# --- EFFECTIVE HEALTH STATS ---
@export_group("Effective Health Stats")
@export var hpBase: int = 28 ## Amount of HP
@export var drBase: int = 0 ## Physical Damage Reduction
@export var mrBase: int = 0 ## Magic Resistance

# --- PROGRESS STATS ---
@export_group("Progress Stats")
@export var grade: int = 1 ## Rarity of the unit, player is limited in term of grade value to place
@export var potential: int = 1 ## How many permanent upgrades can a unit have
@export var wisdomBase: int = 1 ## Influence number of permanent upgrades that can be applied to an unit (higher values increase 

# --- COMBAT ---
@export_group("Combat Stats")
@export var powerBase: int = 5 ## Damage dealed by the unit at each attack
@export var damageType: DamageTypes.DamageTypes = DamageTypes.DamageTypes.PHYSICAL ## Type of attack of the unit
@export var attackRange: int = 1 ## Attack range
@export var atkPerTurnBase: int = 1 ## Number of time the unit can attack in the same turn
@export var speedBase: int = 3 ## Speed of the unit
