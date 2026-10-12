extends Node


static func decide_action(
	npc_unit: Node2D,
	battlefield: Node
) -> Dictionary:
	if not is_instance_valid(
		npc_unit
	):
		return {
			"type": "wait",
			"reason": "invalid_npc"
		}
	
	var behavior: String = str(
		npc_unit.ai_behavior
	)
	
	match behavior:
		"follow_hero":
			return decide_follow_hero(
				npc_unit,
				battlefield
			)
		
		"protect_jhon":
			return decide_protect_jhon(
				npc_unit,
				battlefield
			)
		
		"protected_passive":
			return {
				"type": "wait",
				"reason": "protected_passive"
			}
		
		_:
			return {
				"type": "wait",
				"reason": "unknown_behavior"
			}

static func decide_protect_jhon(
	npc_unit: Node2D,
	battlefield: Node
) -> Dictionary:
	if not is_instance_valid(
		npc_unit
	):
		return {
			"type": "wait",
			"reason": "invalid_guard"
		}
	
	var attack_range: float = 1.5
	
	if npc_unit.has_method(
		"get_weapon_range_meters"
	):
		attack_range = float(
			npc_unit.get_weapon_range_meters()
		)
	
	var nearest_enemy: Node2D = null
	var nearest_distance: float = 999999.0
	
	for enemy_unit in battlefield.enemies:
		if not is_instance_valid(
			enemy_unit
		):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		var enemy_distance: float = (
			battlefield.get_distance_in_meters(
				npc_unit.grid_position,
				enemy_unit.grid_position
			)
		)
		
		if enemy_distance > attack_range:
			continue
		
		if enemy_distance < nearest_distance:
			nearest_distance = enemy_distance
			nearest_enemy = enemy_unit
	
	if not is_instance_valid(
		nearest_enemy
	):
		return {
			"type": "wait",
			"reason": "protecting_jhon"
		}
	
	return {
		"type": "attack",
		"target": nearest_enemy,
		"reason": "enemy_near_jhon"
	}

static func decide_follow_hero(
	npc_unit: Node2D,
	battlefield: Node
) -> Dictionary:
	
	if not is_instance_valid(battlefield.hero):
		return {
			"type": "wait",
			"reason": "hero_invalid"
		}
	
	if battlefield.hero.hp <= 0:
		return {
			"type": "wait",
			"reason": "hero_dead"
		}
	
	var hero_position: Vector2i = battlefield.hero.grid_position
	var npc_position: Vector2i = npc_unit.grid_position
	
	var current_distance: float = battlefield.get_distance_in_meters(
		npc_position,
		hero_position
	)
	
	# Se já chegou perto do herói, permanece próximo.
	if current_distance <= 3.0:
		return {
			"type": "wait",
			"reason": "already_near_hero"
		}
	
	var best_position: Vector2i = get_best_follow_position(
		npc_unit,
		battlefield.hero,
		battlefield
	)
	
	if best_position == npc_position:
		return {
			"type": "wait",
			"reason": "no_path_to_hero"
		}
	
	return {
		"type": "move",
		"position": best_position,
		"reason": "follow_hero"
	}


static func get_best_follow_position(
	npc_unit: Node2D,
	target_unit: Node2D,
	battlefield: Node
) -> Vector2i:
	
	var best_position: Vector2i = npc_unit.grid_position
	var best_distance: float = battlefield.get_distance_in_meters(
		npc_unit.grid_position,
		target_unit.grid_position
	)
	
	var max_movement: float = min(
		3.0,
		npc_unit.current_movement_meters
	)
	
	var max_tiles: int = int(
		ceil(max_movement / battlefield.STRAIGHT_MOVE_COST)
	) + 1
	
	var start_x: int = max(
		0,
		npc_unit.grid_position.x - max_tiles
	)
	
	var end_x: int = min(
		battlefield.current_grid_width - 1,
		npc_unit.grid_position.x + max_tiles
	)
	
	var start_y: int = max(
		0,
		npc_unit.grid_position.y - max_tiles
	)
	
	var end_y: int = min(
		battlefield.current_grid_height - 1,
		npc_unit.grid_position.y + max_tiles
	)
	
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var test_position := Vector2i(x, y)
			
			if test_position == npc_unit.grid_position:
				continue
			
			if battlefield.is_grid_position_blocked_for_path(
				test_position,
				npc_unit
			):
				continue
			
			var direct_cost: float = battlefield.get_movement_cost(
				npc_unit.grid_position,
				test_position
			)
			
			if direct_cost > max_movement:
				continue
			
			var path: Array[Vector2i] = battlefield.get_grid_path_avoiding_units(
				npc_unit.grid_position,
				test_position,
				npc_unit,
				max_movement,
				false
			)
			
			if path.is_empty():
				continue
			
			var path_cost: float = battlefield.get_path_total_cost(
				npc_unit.grid_position,
				path
			)
			
			if path_cost > max_movement:
				continue
			
			var distance_to_hero: float = battlefield.get_distance_in_meters(
				test_position,
				target_unit.grid_position
			)
			
			if distance_to_hero < best_distance:
				best_distance = distance_to_hero
				best_position = test_position
	
	return best_position
