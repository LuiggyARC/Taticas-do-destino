extends Node


static func is_ranged(enemy_unit: Node2D) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	return str(enemy_unit.ai_behavior) == "ranged"


static func get_weapon_range(enemy_unit: Node2D) -> float:
	if not is_instance_valid(enemy_unit):
		return 1.5
	
	if enemy_unit.has_method("get_weapon_range_meters"):
		return float(enemy_unit.get_weapon_range_meters())
	
	return 1.5


static func get_preferred_ranged_distance(enemy_unit: Node2D) -> float:
	var weapon_range: float = get_weapon_range(enemy_unit)
	return weapon_range * 0.75


static func get_reachable_movement_costs(enemy_unit: Node2D, battlefield: Node) -> Dictionary:
	var start_position: Vector2i = enemy_unit.grid_position
	var max_movement: float = enemy_unit.current_movement_meters
	var costs: Dictionary = {}
	costs[start_position] = 0.0
	var frontier: Array[Vector2i] = [start_position]

	# Calcula uma vez as casas alcancaveis usando as mesmas regras do caminho final.
	while not frontier.is_empty():
		var current_index: int = 0
		var current_cost: float = float(costs[frontier[0]])

		for i in range(1, frontier.size()):
			var candidate_cost: float = float(costs[frontier[i]])
			if candidate_cost < current_cost:
				current_cost = candidate_cost
				current_index = i

		var current_position: Vector2i = frontier[current_index]
		frontier.remove_at(current_index)

		var neighbors: Array[Vector2i] = battlefield.get_path_neighbors(
			current_position,
			enemy_unit
		)
		for next_position in neighbors:
			var new_cost: float = current_cost + battlefield.get_movement_cost(
				current_position,
				next_position
			)
			if new_cost > max_movement:
				continue

			if not costs.has(next_position) or new_cost < float(costs[next_position]):
				costs[next_position] = new_cost
				if not frontier.has(next_position):
					frontier.append(next_position)

	return costs


static func ranged_should_reposition(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> bool:
	if not is_ranged(enemy_unit):
		return false
	
	if not is_instance_valid(enemy_unit):
		return false
	
	if not is_instance_valid(target_unit):
		return false
	
	var distance_to_target: float = battlefield.get_distance_in_meters(
		enemy_unit.grid_position,
		target_unit.grid_position
	)
	
	var enemy_range: float = get_weapon_range(enemy_unit)
	var minimum_safe_distance: float = 3.0
	
	if distance_to_target > enemy_range:
		return true
	
	if distance_to_target < minimum_safe_distance:
		return true
	
	return false


static func get_best_ranged_position(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> Vector2i:
	if not is_instance_valid(enemy_unit):
		return Vector2i.ZERO
	
	if not is_instance_valid(target_unit):
		return enemy_unit.grid_position
	
	var enemy_range: float = get_weapon_range(enemy_unit)
	var preferred_distance: float = get_preferred_ranged_distance(enemy_unit)
	var minimum_safe_distance: float = 3.0
	
	var current_distance: float = battlefield.get_distance_in_meters(
		enemy_unit.grid_position,
		target_unit.grid_position
	)
	
	var best_position: Vector2i = enemy_unit.grid_position
	var best_score: float = 999999.0
	
	var bounds: Dictionary = get_local_search_bounds(enemy_unit, battlefield)
	var reachable_costs: Dictionary = get_reachable_movement_costs(enemy_unit, battlefield)

	for x in range(int(bounds["start_x"]), int(bounds["end_x"]) + 1):
		for y in range(int(bounds["start_y"]), int(bounds["end_y"]) + 1):
			var test_position := Vector2i(x, y)
			
			if test_position == enemy_unit.grid_position:
				continue
			
			if not battlefield.is_inside_grid(test_position):
				continue
			
			if test_position == target_unit.grid_position:
				continue
			
			var unit_at_position: Node2D = battlefield.get_unit_at_grid_position(test_position)
			
			if is_instance_valid(unit_at_position):
				continue
			
			if not reachable_costs.has(test_position):
				continue
			
			var movement_cost: float = float(reachable_costs[test_position])
			
			if movement_cost > enemy_unit.current_movement_meters:
				continue
			
			var distance_to_target: float = battlefield.get_distance_in_meters(
				test_position,
				target_unit.grid_position
			)
			
			var danger_score: float = 0.0
			
			if battlefield.enemy_should_avoid_spell_areas():
				danger_score = battlefield.get_spell_area_danger_score(test_position)
			
			var total_score: float = 0.0
			
			if current_distance > enemy_range:
				total_score += distance_to_target * 10.0
				
				if distance_to_target <= enemy_range:
					total_score -= 500.0
				
				if distance_to_target < minimum_safe_distance:
					total_score += 300.0
				
				total_score += movement_cost * 0.2
			
			elif current_distance < minimum_safe_distance:
				total_score += abs(distance_to_target - preferred_distance) * 5.0
				
				if distance_to_target < minimum_safe_distance:
					total_score += 500.0
				
				if distance_to_target > enemy_range:
					total_score += 200.0
				
				total_score += movement_cost * 0.1
			
			else:
				if distance_to_target > enemy_range:
					continue
				
				if distance_to_target < minimum_safe_distance:
					continue
				
				total_score += abs(distance_to_target - preferred_distance) * 10.0
				total_score += movement_cost * 0.1
			
			total_score += danger_score
			
			if total_score < best_score:
				best_score = total_score
				best_position = test_position
	
	return best_position


static func get_best_melee_position(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> Vector2i:
	if not is_instance_valid(enemy_unit):
		return Vector2i.ZERO
	
	if not is_instance_valid(target_unit):
		return enemy_unit.grid_position
	
	var enemy_range: float = get_weapon_range(enemy_unit)
	
	var best_position: Vector2i = enemy_unit.grid_position
	var best_score: float = 999999.0
	
	var bounds: Dictionary = get_local_search_bounds(enemy_unit, battlefield)
	var reachable_costs: Dictionary = get_reachable_movement_costs(enemy_unit, battlefield)

	for x in range(int(bounds["start_x"]), int(bounds["end_x"]) + 1):
		for y in range(int(bounds["start_y"]), int(bounds["end_y"]) + 1):
			var test_position := Vector2i(x, y)
			
			if test_position == enemy_unit.grid_position:
				continue
			
			if not battlefield.is_inside_grid(test_position):
				continue
			
			if test_position == target_unit.grid_position:
				continue
			
			var unit_at_position: Node2D = battlefield.get_unit_at_grid_position(test_position)
			
			if is_instance_valid(unit_at_position):
				continue
			
			if not reachable_costs.has(test_position):
				continue
			
			var movement_cost: float = float(reachable_costs[test_position])
			
			if movement_cost > enemy_unit.current_movement_meters:
				continue
			
			var distance_after_move: float = battlefield.get_distance_in_meters(
				test_position,
				target_unit.grid_position
			)
			
			var danger_score: float = 0.0
			
			if battlefield.enemy_should_avoid_spell_areas():
				danger_score = battlefield.get_spell_area_danger_score(test_position)
			
			var attack_position_bonus: float = 0.0
			
			if distance_after_move <= enemy_range:
				attack_position_bonus = -500.0
			
			var total_score: float = distance_after_move * 10.0
			total_score += movement_cost * 0.1
			total_score += danger_score
			total_score += attack_position_bonus
			
			if total_score < best_score:
				best_score = total_score
				best_position = test_position
	
	return best_position


static func get_best_enemy_move_position(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> Vector2i:
	if not is_instance_valid(enemy_unit):
		return Vector2i.ZERO
	
	if not is_instance_valid(target_unit):
		return enemy_unit.grid_position
	
	if is_ranged(enemy_unit):
		return get_best_ranged_position(enemy_unit, target_unit, battlefield)
	
	return get_best_melee_position(enemy_unit, target_unit, battlefield)


static func decide_basic_action(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> Dictionary:
	if not is_instance_valid(enemy_unit):
		return {
			"type": "wait",
			"reason": "invalid_enemy"
		}
	
	if not is_instance_valid(target_unit):
		return {
			"type": "wait",
			"reason": "invalid_target"
		}
	
	var enemy_range: float = get_weapon_range(enemy_unit)
	
	var distance_to_target: float = battlefield.get_distance_in_meters(
		enemy_unit.grid_position,
		target_unit.grid_position
	)
	
	if distance_to_target <= enemy_range:
		if is_ranged(enemy_unit):
			var minimum_safe_distance: float = 3.0
			
			if distance_to_target < minimum_safe_distance:
				var ranged_position: Vector2i = get_best_ranged_position(
					enemy_unit,
					target_unit,
					battlefield
				)
				
				if ranged_position != enemy_unit.grid_position:
					return {
						"type": "move",
						"position": ranged_position,
						"reason": "ranged_too_close"
					}
		
		return {
			"type": "attack",
			"reason": "target_in_range"
		}
	
	var best_position: Vector2i = get_best_enemy_move_position(
		enemy_unit,
		target_unit,
		battlefield
	)
	
	if best_position == enemy_unit.grid_position:
		return {
			"type": "wait",
			"reason": "no_valid_position"
		}
	
	var distance_after_move: float = battlefield.get_distance_in_meters(
		best_position,
		target_unit.grid_position
	)
	
	if distance_after_move <= enemy_range:
		return {
			"type": "move_and_attack",
			"position": best_position,
			"reason": "move_into_attack_range"
		}
	
	return {
		"type": "move",
		"position": best_position,
		"reason": "move_closer"
	}
static func get_intelligence_score(enemy_unit: Node2D) -> int:
	if not is_instance_valid(enemy_unit):
		return 0
	
	return int(enemy_unit.intelligence_score)


static func can_use_tactical_ai(enemy_unit: Node2D) -> bool:
	return get_intelligence_score(enemy_unit) >= 11


static func can_use_advanced_ai(enemy_unit: Node2D) -> bool:
	return get_intelligence_score(enemy_unit) >= 14


static func can_use_master_ai(enemy_unit: Node2D) -> bool:
	return get_intelligence_score(enemy_unit) >= 17
static func can_cast_magic_missiles(
	enemy_unit: Node2D,
	target_unit: Node2D,
	battlefield: Node
) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	if not is_instance_valid(target_unit):
		return false
	
	if target_unit.hp <= 0:
		return false
	
	if not enemy_unit.has_method(
		"knows_spell"
	):
		return false
	
	if not enemy_unit.knows_spell(
		"Mísseis Mágicos"
	):
		return false
	
	if not enemy_unit.has_method(
		"has_spell_slot_available"
	):
		return false
	
	if not enemy_unit.has_spell_slot_available(
		1
	):
		return false
	
	var spell_range: float = 12.0
	
	if SpellDatabase != null:
		var spell_data: Dictionary = (
			SpellDatabase.get_spell_data(
				"Mísseis Mágicos"
			)
		)
		
		if not spell_data.is_empty():
			spell_range = float(
				spell_data.get(
					"range_meters",
					12.0
				)
			)
	
	var target_distance: float = (
		battlefield.get_distance_in_meters(
			enemy_unit.grid_position,
			target_unit.grid_position
		)
	)
	
	return target_distance <= spell_range
static func decide_advanced_action(
	enemy_unit: Node2D,
	target_unit: Node2D,
	battlefield: Node
) -> Dictionary:
	if not is_instance_valid(enemy_unit):
		return {
			"type": "none",
			"reason": "invalid_enemy"
		}
	
	if not is_instance_valid(target_unit):
		return {
			"type": "none",
			"reason": "invalid_target"
		}
	
	var intelligence_value: int = (
		get_intelligence_score(
			enemy_unit
		)
	)
	
	# IA simples não usa decisões avançadas.
	if intelligence_value <= 10:
		return {
			"type": "none",
			"reason": "simple_ai"
		}
	
	# =====================================================
	# SAIR DE ÁREA MÁGICA PERIGOSA
	# =====================================================
	if should_escape_dangerous_area(
		enemy_unit,
		battlefield
	):
		var safe_position: Vector2i = (
			get_best_safe_position_away_from_spell_area(
				enemy_unit,
				target_unit,
				battlefield
			)
		)
		
		if safe_position != enemy_unit.grid_position:
			return {
				"type": "move",
				"position": safe_position,
				"reason": "escape_spell_area"
			}
	
	# =====================================================
	# CONJURAR MÍSSEIS MÁGICOS
	# =====================================================
	if can_cast_magic_missiles(
		enemy_unit,
		target_unit,
		battlefield
	):
		return {
			"type": "cast_spell",
			"spell_name": "Mísseis Mágicos",
			"reason": "offensive_spell_available"
		}
	
	# =====================================================
	# USAR BUFF
	# =====================================================
	if should_use_buff(
		enemy_unit
	):
		return {
			"type": "buff",
			"reason": "use_buff"
		}
	
	# =====================================================
	# CURA PRÓPRIA
	# =====================================================
	if should_heal_self(
		enemy_unit
	):
		return {
			"type": "heal_self",
			"reason": "low_hp_heal"
		}
	
	# =====================================================
	# USAR POÇÃO
	# =====================================================
	if should_use_potion(
		enemy_unit
	):
		return {
			"type": "potion",
			"reason": "low_hp_potion"
		}
	
	# =====================================================
	# RECUAR
	# =====================================================
	if should_retreat(
		enemy_unit
	):
		var retreat_position: Vector2i = (
			get_best_retreat_position(
				enemy_unit,
				target_unit,
				battlefield
			)
		)
		
		if retreat_position != enemy_unit.grid_position:
			return {
				"type": "move",
				"position": retreat_position,
				"reason": "retreat"
			}
	
	return {
		"type": "none",
		"reason": "no_advanced_action"
	}

static func get_hp_ratio(enemy_unit: Node2D) -> float:
	if not is_instance_valid(enemy_unit):
		return 0.0
	
	if enemy_unit.max_hp <= 0:
		return 0.0
	
	return float(enemy_unit.hp) / float(enemy_unit.max_hp)


static func should_use_potion(enemy_unit: Node2D) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	if get_intelligence_score(enemy_unit) <= 10:
		return false
	
	if not enemy_unit.can_use_potions:
		return false
	
	if enemy_unit.potion_count <= 0:
		return false
	
	if enemy_unit.hp >= enemy_unit.max_hp:
		return false
	
	var hp_ratio: float = get_hp_ratio(enemy_unit)
	
	if get_intelligence_score(enemy_unit) >= 17:
		return hp_ratio <= 0.55
	
	if get_intelligence_score(enemy_unit) >= 14:
		return hp_ratio <= 0.40
	
	return hp_ratio <= 0.25


static func should_heal_self(enemy_unit: Node2D) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	if get_intelligence_score(enemy_unit) <= 10:
		return false
	
	if not enemy_unit.can_heal_self:
		return false
	
	if enemy_unit.self_heal_uses <= 0:
		return false
	
	if enemy_unit.hp >= enemy_unit.max_hp:
		return false
	
	var hp_ratio: float = get_hp_ratio(enemy_unit)
	
	if get_intelligence_score(enemy_unit) >= 17:
		return hp_ratio <= 0.55
	
	if get_intelligence_score(enemy_unit) >= 14:
		return hp_ratio <= 0.40
	
	return hp_ratio <= 0.25


static func should_use_buff(enemy_unit: Node2D) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	if get_intelligence_score(enemy_unit) <= 10:
		return false
	
	if not enemy_unit.can_use_buffs:
		return false
	
	if not enemy_unit.buff_available:
		return false
	
	if enemy_unit.is_buffed:
		return false
	
	return true


static func should_retreat(enemy_unit: Node2D) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	var hp_ratio: float = get_hp_ratio(enemy_unit)
	var intelligence_value: int = get_intelligence_score(enemy_unit)
	
	if intelligence_value >= 17:
		return hp_ratio <= 0.20
	
	if intelligence_value >= 14:
		return hp_ratio <= 0.15
	
	if intelligence_value >= 11:
		return hp_ratio <= 0.10
	
	return false


static func should_avoid_spell_areas(enemy_unit: Node2D) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	return get_intelligence_score(enemy_unit) >= 11


static func should_escape_dangerous_area(enemy_unit: Node2D, battlefield: Node) -> bool:
	if not is_instance_valid(enemy_unit):
		return false
	
	if not should_avoid_spell_areas(enemy_unit):
		return false
	
	return battlefield.is_grid_position_inside_dangerous_spell_area(enemy_unit.grid_position)
static func get_best_safe_position_away_from_spell_area(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> Vector2i:
	if not is_instance_valid(enemy_unit):
		return Vector2i.ZERO
	
	if not is_instance_valid(target_unit):
		return enemy_unit.grid_position
	
	var best_position: Vector2i = enemy_unit.grid_position
	var best_score: float = 999999.0
	
	var bounds: Dictionary = get_local_search_bounds(enemy_unit, battlefield)
	var reachable_costs: Dictionary = get_reachable_movement_costs(enemy_unit, battlefield)

	for x in range(int(bounds["start_x"]), int(bounds["end_x"]) + 1):
		for y in range(int(bounds["start_y"]), int(bounds["end_y"]) + 1):
			var test_position := Vector2i(x, y)
			
			if test_position == enemy_unit.grid_position:
				continue
			
			if not battlefield.is_inside_grid(test_position):
				continue
			
			if test_position == target_unit.grid_position:
				continue
			
			var unit_at_position: Node2D = battlefield.get_unit_at_grid_position(test_position)
			
			if is_instance_valid(unit_at_position):
				continue
			
			if not reachable_costs.has(test_position):
				continue
			
			var movement_cost: float = float(reachable_costs[test_position])
			
			if movement_cost > enemy_unit.current_movement_meters:
				continue
			
			var danger_score: float = battlefield.get_spell_area_danger_score(test_position)
			
			if danger_score > 0.0:
				continue
			
			var distance_to_target: float = battlefield.get_distance_in_meters(
				test_position,
				target_unit.grid_position
			)
			
			var total_score: float = distance_to_target + movement_cost * 0.1
			
			if total_score < best_score:
				best_score = total_score
				best_position = test_position
	
	return best_position


static func get_best_retreat_position(enemy_unit: Node2D, target_unit: Node2D, battlefield: Node) -> Vector2i:
	if not is_instance_valid(enemy_unit):
		return Vector2i.ZERO
	
	if not is_instance_valid(target_unit):
		return enemy_unit.grid_position
	
	var best_position: Vector2i = enemy_unit.grid_position
	var best_score: float = -999999.0
	
	var bounds: Dictionary = get_local_search_bounds(enemy_unit, battlefield)
	var reachable_costs: Dictionary = get_reachable_movement_costs(enemy_unit, battlefield)

	for x in range(int(bounds["start_x"]), int(bounds["end_x"]) + 1):
		for y in range(int(bounds["start_y"]), int(bounds["end_y"]) + 1):
			var test_position := Vector2i(x, y)
			
			if test_position == enemy_unit.grid_position:
				continue
			
			if not battlefield.is_inside_grid(test_position):
				continue
			
			if test_position == target_unit.grid_position:
				continue
			
			var unit_at_position: Node2D = battlefield.get_unit_at_grid_position(test_position)
			
			if is_instance_valid(unit_at_position):
				continue
			
			var direct_cost: float = battlefield.get_movement_cost(
				enemy_unit.grid_position,
				test_position
			)

			if direct_cost > enemy_unit.current_movement_meters:
				continue
			
			if not reachable_costs.has(test_position):
				continue
			
			var movement_cost: float = float(reachable_costs[test_position])
			
			if movement_cost > enemy_unit.current_movement_meters:
				continue
			
			var distance_to_target: float = battlefield.get_distance_in_meters(
				test_position,
				target_unit.grid_position
			)
			
			var danger_score: float = 0.0
			
			if should_avoid_spell_areas(enemy_unit):
				danger_score = battlefield.get_spell_area_danger_score(test_position)
			
			var score: float = distance_to_target * 10.0
			score -= movement_cost * 0.2
			score -= danger_score * 2.0
			
			if score > best_score:
				best_score = score
				best_position = test_position
	
	return best_position
static func choose_target(
	enemy_unit: Node2D,
	battlefield: Node
) -> Node2D:
	
	if not is_instance_valid(enemy_unit):
		return null
	
	var possible_targets: Array[Node2D] = []
	
	# =====================================================
	# HERÓI
	# =====================================================
	if is_instance_valid(battlefield.hero):
		if battlefield.hero.hp > 0:
			possible_targets.append(
				battlefield.hero
			)
	
	# =====================================================
	# COMPANHEIRO
	# =====================================================
	if is_instance_valid(battlefield.animal_companion):
		if battlefield.animal_companion.hp > 0:
			if battlefield.animal_companion.visible:
				possible_targets.append(
					battlefield.animal_companion
				)
	
	# =====================================================
	# NPCs ALIADOS
	# =====================================================
	for npc_unit in battlefield.npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if npc_unit.hp <= 0:
			continue
		
		if not npc_unit.visible:
			continue
		
		if str(npc_unit.faction) != "ally":
			continue
		
		possible_targets.append(npc_unit)
	
	if possible_targets.is_empty():
		return null
	
	# =====================================================
	# PRIORIDADE DEFINIDA PELO CENÁRIO
	# =====================================================
	var priority_list: Array = battlefield.current_scenario_data.get(
		"enemy_target_priority",
		[]
	)
	
	for priority_id in priority_list:
		var target_id: String = str(priority_id)
		
		for target_unit in possible_targets:
			
			if target_id == "hero":
				if target_unit == battlefield.hero:
					return target_unit
			
			elif target_id == "animal_companion":
				if is_instance_valid(
					battlefield.animal_companion
				):
					if target_unit == battlefield.animal_companion:
						return target_unit
			
			else:
				if battlefield.is_npc_unit(target_unit):
					if str(target_unit.npc_id) == target_id:
						return target_unit
	
	# =====================================================
	# SEM PRIORIDADE ESPECIAL
	# ESCOLHE O MAIS PRÓXIMO
	# =====================================================
	var best_target: Node2D = null
	var best_distance: float = 999999.0
	
	for target_unit in possible_targets:
		var distance: float = battlefield.get_distance_in_meters(
			enemy_unit.grid_position,
			target_unit.grid_position
		)
		
		if distance < best_distance:
			best_distance = distance
			best_target = target_unit
	
	return best_target

static func get_local_search_bounds(enemy_unit: Node2D, battlefield: Node) -> Dictionary:
	var max_tiles: int = int(ceil(enemy_unit.current_movement_meters / battlefield.STRAIGHT_MOVE_COST)) + 1
	
	var start_x: int = max(0, enemy_unit.grid_position.x - max_tiles)
	var end_x: int = min(battlefield.GRID_WIDTH - 1, enemy_unit.grid_position.x + max_tiles)
	var start_y: int = max(0, enemy_unit.grid_position.y - max_tiles)
	var end_y: int = min(battlefield.GRID_HEIGHT - 1, enemy_unit.grid_position.y + max_tiles)
	
	return {
		"start_x": start_x,
		"end_x": end_x,
		"start_y": start_y,
		"end_y": end_y
	}
