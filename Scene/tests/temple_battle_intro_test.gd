extends Node

const IntroDatabase = preload("res://Scene/temple_battle_intro_database.gd")
const ScenarioDatabase = preload("res://Scene/scenario_database.gd")
const IntroScene = preload("res://Scene/temple_battle_intro.tscn")
const BattleTokenVisual = preload("res://Scene/battle_unit_token.gd")


func _ready() -> void:
	assert(IntroScene != null)
	var scene_eight: Array[Dictionary] = IntroDatabase.get_scene(8)
	var scene_nine: Array[Dictionary] = IntroDatabase.get_scene(9)
	assert(scene_eight.size() > 40)
	assert(scene_nine.size() > 20)
	assert(_event_index(scene_eight, "breach") < _event_index(scene_eight, "reveal_elites"))
	assert(_event_index(scene_eight, "reveal_elites") < _event_index(scene_eight, "fire_wall"))
	assert(_event_index(scene_nine, "reveal_cultists") >= 0)
	var scenario: Dictionary = ScenarioDatabase.get_scenario_data(4)
	assert(scenario["background_image"] == "res://Assets/Maps/Templobatalha.jpg")
	assert(ResourceLoader.exists(scenario["background_image"]))
	assert(scenario["enemies"].size() == 10)
	assert(scenario["npcs"].size() == 4)
	assert(scenario["enemies"].filter(func(value): return value["monster_id"] == "Cultista").size() == 5)
	assert(scenario["enemies"].filter(func(value): return value["monster_id"] == "Guardião do Culto").size() == 2)
	assert(scenario["enemies"].filter(func(value): return value["monster_id"] == "Arqueiro do Culto").size() == 2)
	for y in range(24):
		assert(Vector2i(17, y) in scenario["terrain"]["blocked"])
	var intro := IntroScene.instantiate()
	intro.actor_layer = Control.new()
	intro.add_child(intro.actor_layer)
	var uiliam: Node2D = intro._make_actor(
		"Sir Uiliam", BattleTokenVisual.npc_portrait_path("Sr Uiliam"), Vector2i(12, 9), "ally"
	)
	assert(uiliam.get_script() == BattleTokenVisual)
	assert(uiliam.get_meta("grid_cell") == Vector2i(12, 9))
	assert(uiliam.get_node_or_null("BattlePortrait") != null)
	assert(uiliam.get_child_count() == 2)
	intro.free()
	print("Temple battle intro test passed")
	get_tree().quit(0)


func _event_index(steps: Array[Dictionary], event_type: String) -> int:
	for index in range(steps.size()):
		if str(steps[index].get("type", "")) == event_type:
			return index
	return -1
