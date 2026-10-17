extends Node

const TEST_SAVE_PATH := "res://Scene/tests/.save_resume_transition_test.json"


class ResumeProbe extends Node:
	var save_path: String

	func _ready() -> void:
		await get_tree().create_timer(1.5).timeout
		var current_scene: Node = get_tree().current_scene
		var actual_path: String = current_scene.scene_file_path if is_instance_valid(current_scene) else ""
		var passed: bool = actual_path == "res://Scene/temple_hall.tscn" and not SceneTransition.is_transitioning
		if passed:
			print("Save resume transition test passed")
		else:
			push_error("Save retomado na cena incorreta: " + actual_path)
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
		get_tree().quit(0 if passed else 1)


func _ready() -> void:
	call_deferred("_start_test")


func _start_test() -> void:
	var test_save: Dictionary = {
		"current_location": "temple_hall",
		"current_stage": 3,
		"completed_story_events": ["temple_hashagur_briefing"],
		"player_presets": {"player_name": "Teste", "player_class": "Guerreiro"},
		"party": {},
		"inventory": {},
		"missions": {}
	}
	var source_save_path: String = OS.get_environment("AVIANT_TEST_SAVE_PATH")
	if not source_save_path.is_empty():
		var existing_save: Dictionary = SaveManager.read_save_data(source_save_path)
		assert(not existing_save.is_empty())
		test_save = existing_save.duplicate(true)
		assert(str(test_save.get("current_location", "")) == "temple_hall")
	assert(SaveManager.write_save_data(TEST_SAVE_PATH, test_save))
	GameState.selected_save_path = TEST_SAVE_PATH
	GameState.current_location = "temple_hall"
	GameState.should_load_save = true
	var probe := ResumeProbe.new()
	probe.save_path = TEST_SAVE_PATH
	get_tree().root.add_child(probe)
	SceneTransition.change_scene_to_file("res://Scene/main.tscn", 0.05)
