class_name AIController
extends Node

var player: AbstractPlayer
var is_playing: bool = false
var units_to_process: Array[AbstractUnit] = []
var current_unit: AbstractUnit = null

func setup(_player: AbstractPlayer) -> void:
	player = _player

func start_turn() -> void:
	print("AI Turn started for team: ", player.team)
	is_playing = true
	# Récupérer toutes les unités alliées capables de bouger ou d'attaquer
	units_to_process = player.getUnits().filter(func(u): return u.hpActual > 0 and (u.atkRemaining > 0 or u.speedRemaining > 0))
	process_next_unit()

func process_next_unit() -> void:
	# Purge de sécurité si une unité est morte entre temps
	units_to_process = units_to_process.filter(func(u): return is_instance_valid(u) and not u.isDead and (u.atkRemaining > 0 or u.speedRemaining > 0))
	
	if units_to_process.is_empty():
		end_turn()
		return
		
	current_unit = units_to_process.pop_front()
	
	var best_action = evaluate_best_action(current_unit)
	if best_action != null and not best_action.is_empty():
		execute_action(best_action)
	else:
		process_next_unit()

func evaluate_best_action(unit: AbstractUnit) -> Dictionary:
	var best_score: float = -1.0
	var best_action: Dictionary = {}
	
	var walkable_cells = GridUtils.get_walkable_cells(unit)
	
	for cell in walkable_cells.keys():
		var targets = []
		# On cherche les cibles depuis la case "cell" simulée
		for target_cell in GridUtils.flood_fill(cell, unit.range):
			var tile = MapManager.getTileAt(target_cell)
			if tile != null and tile.hasUnitOn() and tile.unitOn.team != unit.team:
				targets.append(tile.unitOn)
				
		if targets.size() > 0:
			for target in targets:
				var score = score_attack(unit, cell, target)
				if score > best_score:
					best_score = score
					best_action = {
						"type": "ATTACK",
						"unit": unit,
						"move_to": cell,
						"target": target
					}
		else:
			var score = score_move(unit, cell)
			if score > best_score:
				best_score = score
				best_action = {
					"type": "MOVE",
					"unit": unit,
					"move_to": cell,
					"target": null
				}
				
	return best_action

func score_attack(unit: AbstractUnit, destination: Vector2i, target: AbstractUnit) -> float:
	var score: float = 0.0
	
	# Simulate damage without applying effects (using visualisation=true)
	var damageBase = unit.onDamageDealed(target, unit.damageType, true)
	var infoDamagesTaked = target.onDamageTaken(unit, damageBase, unit.damageType, true)
	
	var estimated_damage = infoDamagesTaked["damage"]
	score += estimated_damage * 2.0
	
	# Fatality Bonus: if simulated remaining HP is 0 or less
	if infoDamagesTaked.has("hpActual") and infoDamagesTaked["hpActual"] <= 0:
		score += 50.0
		
	# Un score d'attaque doit toujours surpasser un mouvement simple
	return score + 100.0

func score_move(unit: AbstractUnit, destination: Vector2i) -> float:
	var nearest_enemy_dist = 9999
	for enemy in GameManager.getAllUnits():
		if enemy.team != unit.team and not enemy.isDead:
			var enemy_pos = enemy.tile.getCoords()
			var dist = abs(enemy_pos.x - destination.x) + abs(enemy_pos.y - destination.y)
			if dist < nearest_enemy_dist:
				nearest_enemy_dist = dist
				
	# Max 50 points : L'IA se rapproche mais préférera attaquer (100+) si possible
	return max(0.0, 50.0 - nearest_enemy_dist)

func execute_action(action: Dictionary) -> void:
	var unit: AbstractUnit = action.unit
	var destination: Vector2i = action.move_to
	var tile_dest = MapManager.getTileAt(destination)
	
	# Move if needed
	if unit.tile.getCoords() != destination:
		var walkable = GridUtils.get_walkable_cells(unit)
		
		# Calculate path and start movement
		var path = GridUtils.find_path(unit, unit.tile.getCoords(), destination)
		unit.walk_along(path)
		unit.deplacement(tile_dest)
		unit.speedRemaining -= walkable[destination]
		
		# Wait end of movement animation
		if unit.has_signal("signalFinMouvement"):
			await unit.signalFinMouvement
		else:
			await get_tree().create_timer(0.3).timeout
			
	# Attaque
	if action.type == "ATTACK" and action.target != null and unit.atkRemaining > 0:
		GameManager.fight(unit, action.target)
		# Visual feedback
		#await get_tree().create_timer(0.5).timeout
		
	# Passe à la suite
	process_next_unit()

func end_turn() -> void:
	is_playing = false
	print("AI Turn ended")
	# On informe le TurnManager que notre tour est fini
	TurnManager.nextTurn()
