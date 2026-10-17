extends Node

const BattleScene = preload("res://Scene/main.tscn")
const EnemyAI = preload("res://Scene/enemy_ai.gd")


func _ready() -> void:
	var battle: Node2D = BattleScene.instantiate()
	add_child(battle)
	await get_tree().process_frame
	await get_tree().process_frame
	var player: Node2D = battle.hero
	assert(is_instance_valid(player))
	battle.initiative_started = true
	battle.battle_finished = false
	battle.current_turn = 0
	battle.current_active_unit = player
	battle.selected_player_unit = player
	player.visible = true
	player.current_movement_meters = 12.0
	battle.is_movement_animating = false
	var start_position: Vector2i = player.grid_position
	var destination := Vector2i(-1, -1)
	for candidate in battle.get_reachable_positions_for_unit(player, 12.0).keys():
		if candidate != start_position and battle.get_unit_at_grid_position(candidate) == null and battle.get_opportunity_attackers_for_move(player, candidate).is_empty():
			destination = candidate
			break
	assert(destination != Vector2i(-1, -1))
	battle.handle_player_grid_click(destination)
	assert(battle.pending_movement_destination == destination)
	assert(player.grid_position == start_position)
	assert(battle.movement_preview_panel.visible)
	await battle.handle_player_grid_click(destination)
	assert(player.grid_position == destination)
	assert(battle.pending_movement_unit == null)
	battle.scenario_intro_running = false
	assert(not battle.enemies.is_empty())
	battle.enemies[0].visible = true
	battle.refresh_enemy_intent_overlay()
	var predictions: Array[Dictionary] = battle.get_predicted_enemy_targets()
	assert(not predictions.is_empty())
	assert(battle.enemy_intent_overlay.visible)
	assert(battle.enemy_intent_overlay.intents.size() == predictions.size())
	for prediction in predictions:
		assert(prediction["target"] == EnemyAI.choose_target(prediction["enemy"], battle))
	battle.set_enemy_intents_enabled(false)
	assert(not battle.enemy_intent_overlay.visible)
	print("movement_preview_flow_test passed")
	get_tree().quit(0)
