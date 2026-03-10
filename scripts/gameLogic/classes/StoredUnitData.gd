## Store unit infos and permanent upgrades & changes for save files and placement
extends Resource
class_name StoredUnit

# --- IDENTIFICATION ---
@export_group("Identity")
@export var id: String = ""       # Unit Id (ex: "set1:MonkeyWarrior")

# --- PROGRESSION ---

#@export_group("Progress")
#@export var potential: int = 0
#@export var level_bonus: int = 0


# --- UPGRADES ? ---
@export_group("Upgrades")
@export var permanentUpgrades: Array[String] = [] # List permanent upgrades
@export var markersEffects: Dictionary = {}   # Stock all permanents parts on some effects, exemple with Starving Shadow : hpMax needs to be reduced permanently and not just for one level so we need to stock maxHp value and its current max hp 

# --- MODIFICATEURS DE STATS (pas utile pour le moment) ---
# Servira pê pour les bonus des évènements ou pour le personnage principal à voir
# Si l'unité a mangé une "Pomme de Vie" qui donne +5 HP permanents
@export_group("Bonuses")
@export var statModifiers: Dictionary = {
}

# --- CONSTRUCTEURS & UTILITAIRES ---

# Create StoredUnit vide ou à partir d'un ID
func _init(_id: String):
	id = _id

## CAPTURE : Créer cette Ressource à partir d'une unité active sur le terrain
static func createFromUnit(unit: AbstractUnit) -> StoredUnit:
	var storedUnitData = StoredUnit.new(unit.id)
	
	# Get permanent buffs and apply them
	# TODO Faut trouver comment relier ça avec poids et tout parce que certains buffs jouent là dessus donc à voir si on récup pas juste UnitStats
	# storedUnitData.permanentUpgrades = unit.markers.duplicate()
	storedUnitData.permanentUpgrades  = unit.permanentUpgrades.duplicate()
	storedUnitData.markersEffects = unit.markersEffects.duplicate()
	storedUnitData.statModifiers = unit.statModifiers.duplicate()
	# Sauvegarde des effets
	# Get permanent effects that need to be keep, we will call all effects and some of them will added data on markersEffects dico
	# storedUnitData.markersEffects = unit.getPermanentsEffects()
	
	return storedUnitData

## Apply data on load
func applyToUnit(unit: AbstractUnit) -> void:
	# 1. On injecte les données de la sauvegarde dans l'unité active
	unit.permanentUpgrades = self.permanentUpgrades.duplicate()
	unit.statModifiers = self.statModifiers.duplicate()
	unit.markersEffects = self.markersEffects.duplicate()
	
	## Recalculate statModifiers with new permanentUpgrades
	unit.applyStatModifiers() # Apply stat changes from upgrades

	# Apply all permanent upgrades to the unit
	for upgradeId: String in permanentUpgrades:
		unit.activatePermanentUpgrade(upgradeId)

## Add a permanent upgrade and its stat changes to the model, used on upgrade reward interface and when collecting units from json
func addPermanentUpgrade(upgradeId: String) -> void:
	#permanentUpgrades.append(upgradeId)
	
	var modifiers = UpgradeDB.get_stat_modifiers(upgradeId)
	
	## Add a default cost of 1 if the cost isn't present
	if !modifiers.has("potentialCost") : modifiers["potentialCost"] = 1
	
	## Add every stat bonus to the unit
	for stat_name: String in modifiers:
		modifyStat(stat_name, modifiers[stat_name])

func modifyStat(statName: String, amt: int) -> void :
	if !statModifiers.has(statName) : 
		statModifiers[statName] = 0
	statModifiers[statName] += amt

## SERIALIZATION (JSON)
## Les Resources Godot ne se mettent pas directement dans JSON.stringify
func saveStoredUnit() -> Dictionary:
	return {
		"id": id,
		"permanentUpgrades": permanentUpgrades,
		"markersEffects": markersEffects,
		"modifiers": statModifiers
	}

## DESERIALIZATION (Load a Json)
static func loadStoredUnit(data: Dictionary) -> StoredUnit:
	var idUnit: String = data.get("id", "")
	if (idUnit == "") :
		push_warning("Unit have not be recovered bc its id was empty")
		return
	var storage = StoredUnit.new(idUnit)
	storage.permanentUpgrades.assign(data.get("permanentUpgrades", []))
	storage.markersEffects = data.get("markersEffects", {})
	# Check if data contains info about upgrades to add on unitData
	if data.has("markersEffects") :
		storage.statModifiers = data.get("modifiers", {})
	else :
		for upgradeId: String in storage.permanentUpgrades:
			storage.addPermanentUpgrade(upgradeId)
	return storage
