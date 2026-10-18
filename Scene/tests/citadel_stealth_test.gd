extends Node

const Rules = preload("res://Scene/citadel_stealth_rules.gd")
const CitadelStory = preload("res://Scene/citadel_story_database.gd")
const CitadelScene = preload("res://Scene/citadel_stealth.tscn")


func _ready() -> void:
	assert(ResourceLoader.exists(Rules.MAP_PATH))
	assert(CitadelScene != null)
	assert(Rules.GUARDS.size() == 4)
	assert(Rules.ANIRI_VISION_METERS == 8.0)
	assert(Rules.CULTIST_VISION_METERS == 6.0)
	assert(Rules.observe_succeeds(12, 3, 10, 5))
	assert(not Rules.observe_succeeds(11, 3, 10, 5))
	assert(ResourceLoader.exists("res://Assets/Audio/Temafurtivo.mp3"))
	assert(ResourceLoader.exists("res://Assets/Audio/SFX/Caco de vidro.mp3"))
	assert(Rules.validate_layout().is_empty())
	assert(Rules.reachable_cells(Rules.START, 1).has(Rules.START + Vector2i.DOWN))
	assert(not Rules.reachable_cells(Rules.START, 1).has(Rules.START + Vector2i.RIGHT))
	assert(Rules.cover_near(Vector2i(18, 8)))
	assert(Rules.cover_near(Vector2i(20, 14)))
	assert(Rules.can_see(Vector2i(17, 8), Vector2i(19, 7), Rules.CULTIST_VISION_METERS))
	assert(not Rules.can_see(Vector2i(17, 8), Vector2i(19, 7), Rules.CULTIST_VISION_METERS, true))
	assert(Rules.path(Rules.START, Rules.CHEST).size() > 0)
	assert(Rules.path(Rules.START, Rules.BEDROOM_CLUE).size() > 0)
	assert(Rules.path(Rules.START, Rules.STRATEGY_CLUE).size() > 0)
	for stone_cell in [Vector2i(22, 3), Vector2i(23, 2), Vector2i(24, 2), Vector2i(25, 3), Vector2i(27, 3), Vector2i(28, 2), Vector2i(29, 2), Vector2i(30, 2)]:
		assert(Rules.blocked(stone_cell))
	assert(not Rules.blocked(Vector2i(26, 3)))
	assert(not Rules.can_step(Vector2i(23, 1), Vector2i(23, 2)))
	assert(Rules.can_step(Vector2i(26, 2), Vector2i(26, 3)))
	assert(not Rules.path(Vector2i(26, 1), Vector2i(27, 4)).is_empty())
	for objective in [Rules.CHEST, Rules.BEDROOM_CLUE, Rules.STRATEGY_CLUE]:
		var approach: Array[Vector2i] = Rules.path(Rules.START, objective)
		assert(Rules.can_see(approach[-2] if approach.size() > 1 else Rules.START, objective, Rules.ANIRI_VISION_METERS))
	assert(CitadelStory.get_arrival().size() >= 4)
	assert(CitadelStory.get_bedroom_report().any(func(step: Dictionary) -> bool: return str(step.get("text", "")).contains("Ebramir")))
	assert(CitadelStory.get_strategy_report().any(func(step: Dictionary) -> bool: return str(step.get("text", "")).contains("FUJA DA CIDADELA")))
	assert(Rules.has_line_of_sight(Vector2i(1, 2), Vector2i(1, 4)))
	assert(not Rules.has_line_of_sight(Vector2i(15, 10), Vector2i(18, 10)))
	for guard in Rules.GUARDS:
		for waypoint in guard["route"]:
			assert(not Rules.blocked(waypoint))
	var lower_patrol: Dictionary = Rules.GUARDS[1]
	var lower_route: Array = lower_patrol["route"]
	for index in range(lower_route.size()):
		var steps: Array[Vector2i] = Rules.path(lower_route[index], lower_route[(index + 1) % lower_route.size()])
		for cell in steps:
			assert(cell.y >= 19)
	var main_patrol: Dictionary = Rules.GUARDS[3]
	assert(main_patrol["route"] == [Vector2i(19, 4), Vector2i(19, 18)])
	for cell in Rules.path(Vector2i(19, 4), Vector2i(19, 18)):
		assert(cell.x == 19)
	var mission: Node2D = CitadelScene.instantiate()
	assert(not mission._can_interact_with_chest())
	mission.player_cell = Rules.path(Rules.START, Rules.CHEST)[-2]
	assert(mission._can_interact_with_chest())
	mission._restore_chest_state({"chest_claimed": true, "reward_notified": true})
	assert(not mission.chest_claimed)
	assert(mission.chest_reward_paid)
	assert(not mission._chest_gold_due())
	mission._restore_chest_state({"chest_reward_paid": false})
	assert(not mission.chest_claimed)
	assert(not mission.chest_reward_paid)
	mission.chest_claimed = true
	assert(mission._chest_gold_due())
	mission.chest_reward_paid = true
	assert(not mission._chest_gold_due())
	for definition in Rules.GUARDS:
		mission.guards.append({"cell": definition["start"], "name": definition["name"], "investigating": false})
	for glass_cell in Rules.GLASS:
		mission.player_cell = glass_cell
		mission._assign_noise_investigation(glass_cell)
		var investigator_found: bool = false
		for guard in mission.guards:
			if not guard["investigating"]:
				continue
			investigator_found = true
			assert(guard["noise_target"] != glass_cell)
			assert(not Rules.path(guard["cell"], guard["noise_target"], [glass_cell]).is_empty())
			guard["investigating"] = false
		assert(investigator_found)
	var previous_save_path: String = GameState.selected_save_path
	var previous_gold: int = InventoryManager.get_gold()
	var previous_missions: Dictionary = MissionManager.get_save_data()
	var test_save_path: String = "user://citadel_chest_flow_%d.json" % Time.get_ticks_usec()
	GameState.selected_save_path = test_save_path
	assert(SaveManager.write_save_data(test_save_path, {"test": true}))
	mission._restore_chest_state({})
	mission.chest_claimed = true
	assert(InventoryManager.get_gold() == previous_gold)
	var unfinished_retry: Node2D = CitadelScene.instantiate()
	unfinished_retry._restore_chest_state(SaveManager.read_save_data(test_save_path).get("citadel_stealth", {}))
	assert(not unfinished_retry.chest_claimed)
	assert(not unfinished_retry.chest_reward_paid)
	unfinished_retry.free()
	mission._complete_mission()
	assert(mission.completed)
	assert(InventoryManager.get_gold() == previous_gold + 50)
	var saved_progress: Dictionary = SaveManager.read_save_data(test_save_path).get("citadel_stealth", {})
	assert(saved_progress.get("chest_reward_paid", false))
	var retry_mission: Node2D = CitadelScene.instantiate()
	retry_mission._restore_chest_state(saved_progress)
	assert(not retry_mission.chest_claimed)
	assert(retry_mission.chest_reward_paid)
	retry_mission.chest_claimed = true
	retry_mission._complete_mission()
	assert(InventoryManager.get_gold() == previous_gold + 50)
	retry_mission.free()
	GameState.selected_save_path = previous_save_path
	InventoryManager.set_gold(previous_gold)
	MissionManager.load_save_data(previous_missions)
	assert(DirAccess.remove_absolute(ProjectSettings.globalize_path(test_save_path)) == OK)
	mission.free()
	print("Citadel stealth rules test passed")
	get_tree().quit(0)
