extends Node

const BattleScene = preload("res://Scene/main.tscn")
const TempleGateScene = preload("res://Scene/temple_gate.tscn")
const TempleHallScene = preload("res://Scene/temple_hall.tscn")
const ScenarioData = preload("res://Scene/scenario_database.gd")
const OutroData = preload("res://Scene/temple_battle_outro_database.gd")


func _ready() -> void:
	assert(TempleGateScene != null and TempleHallScene != null)
	var inside: Array[Dictionary] = OutroData.get_inside()
	var outside: Array[Dictionary] = OutroData.get_outside()
	var after_battle: Array[Dictionary] = OutroData.get_after_battle()
	assert(inside.any(func(step): return step.get("type") == "wind_burst"))
	assert(inside.any(func(step): return str(step.get("text", "")).contains("Já escolhi ficar")))
	assert(outside.any(func(step): return step.get("type") == "doors_close"))
	assert(outside.any(func(step): return str(step.get("text", "")).contains("Elimine os cultistas")))
	assert(after_battle.any(func(step): return str(step.get("text", "")).contains("Retorne à vila")))
	assert(ScenarioData.get_stage_4_victory_sequence()["next_scene"] == "res://Scene/main.tscn")
	var courtyard: Dictionary = ScenarioData.get_scenario_data(5)
	assert(courtyard["background_image"] == "res://Assets/Maps/Chegada ao templo.jpg")
	assert(courtyard["music"] == "res://Assets/Audio/Luta fora templo.mp3")
	assert(courtyard["music_start"] == "arrival")
	assert(courtyard["npcs"].size() == 3)
	assert(courtyard["enemies"].size() == 4)
	assert(Vector2i(26, 12) in courtyard["terrain"]["blocked"])
	for actor in courtyard["npcs"] + courtyard["enemies"]:
		assert(actor["position"] not in courtyard["terrain"]["blocked"])
	var test_save: String = "user://temple_courtyard_%d.json" % Time.get_ticks_usec()
	var file := FileAccess.open(test_save, FileAccess.WRITE)
	assert(file != null)
	file.store_string(JSON.stringify({
		"current_stage": 5,
		"current_location": "battle",
		"player_presets": {"player_name": "Teste", "player_class": "Guerreiro", "player_race": "Humano"},
		"party": {}, "inventory": {}, "missions": {}
	}))
	file.close()
	GameState.selected_save_path = test_save
	GameState.current_location = "battle"
	GameState.should_load_save = true
	var battle: Node2D = BattleScene.instantiate()
	add_child(battle)
	for frame in range(20):
		await get_tree().process_frame
	assert(battle.current_stage == 5)
	assert(battle.enemies.size() == 4)
	for cultist in battle.enemies:
		assert(cultist.get_node("BattleToken/BattlePortrait").texture != null)
	assert(battle.npcs.size() == 3)
	assert(not is_instance_valid(battle.temple_fire_wall))
	assert(is_instance_valid(battle.temple_courtyard_gate))
	assert(battle.find_scenario_npc_by_id("Hashagur") == null)
	assert(battle.scenario_intro_running)
	assert(not battle.temple_courtyard_gate.visible)
	assert(MusicManage.music_player.playing)
	assert(MusicManage.music_player.stream.resource_path == courtyard["music"])
	await get_tree().create_timer(1.2, true).timeout
	assert(is_instance_valid(battle.story_dialog_popup))
	assert(battle.story_dialog_popup.visible)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(test_save))
	battle.queue_free()
	await get_tree().process_frame
	get_tree().paused = false
	print("Temple courtyard test passed")
	get_tree().quit(0)
