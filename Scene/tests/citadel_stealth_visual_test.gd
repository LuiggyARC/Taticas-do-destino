extends Node

const Rules = preload("res://Scene/citadel_stealth_rules.gd")
const CitadelScene = preload("res://Scene/citadel_stealth.tscn")


func _ready() -> void:
	var mission: Node2D = CitadelScene.instantiate()
	add_child(mission)
	await get_tree().process_frame
	mission.dialogue_box.hide()
	get_tree().paused = false
	var route: Array[Vector2i] = Rules.path(Rules.START, Rules.CHEST)
	mission.player_cell = route[-2]
	mission.player_token.position = Rules.cell_center(mission.player_cell) - Vector2(24, 24)
	mission.camera.position = Rules.cell_center(mission.player_cell)
	mission.completed = false
	mission.chest_claimed = false
	mission.failed = false
	mission.moving = false
	mission._refresh_vision()
	mission._refresh_interface()
	assert(not mission.clue_markers.has("chest"))
	assert(not mission.movement_overlay.reachable.is_empty())
	mission.is_stealthed = true
	mission._refresh_interface()
	assert(mission.player_token.modulate.a < 0.6)
	mission.is_stealthed = false
	mission._refresh_interface()
	assert(mission.player_token.modulate.a == 1.0)
	for frame in range(5):
		await get_tree().process_frame
	var preview: Image = get_viewport().get_texture().get_image()
	if preview != null:
		var path: String = ProjectSettings.globalize_path("user://citadel_stealth_preview.png")
		assert(preview.save_png(path) == OK)
		print("Citadel stealth visual test passed: ", path)
	else:
		print("Citadel stealth visual structure passed")
	mission._fail_mission("Teste de detecção.")
	assert(mission.capture_dialog.visible)
	assert(mission.capture_dialog.dialog_text.contains("capturada e morta"))
	mission.capture_dialog.hide()
	get_tree().quit(0)
