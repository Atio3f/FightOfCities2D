extends Resource
class_name StoredUnit
## Store unit infos and permanent upgrades & changes for save files and placement

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
	
	# Sauvegarde des effets
	# Get permanent effects that need to be keep, we will call all effects and some of them will added data on markersEffects dico
	# storedUnitData.markersEffects = unit.getPermanentsEffects()
	
	
	return storedUnitData

## Apply data on load
func applyToUnit(unit: AbstractUnit) -> void:
	
	# Manage stat_modifiers activations
	if statModifiers.has("hp_bonus"):
		unit.hpMax += statModifiers["hp_bonus"]
		unit.hpActual += statModifiers["hp_bonus"]
	
	# Appliquer les effets
	# for effect_id in permanent_effects:
	# 	unit.add_effect(effect_id, true) # true = silent add (pas d'anim)

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
	storage.statModifiers = data.get("modifiers", {})
	return storage
