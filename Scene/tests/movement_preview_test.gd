extends Node

const OverlayScript = preload("res://Scene/tactical_board_overlay.gd")


func _ready() -> void:
	var overlay: Node2D = OverlayScript.new()
	add_child(overlay)
	overlay.setup(64)
	var path: Array[Vector2i] = [Vector2i(1, 1), Vector2i(2, 1)]
	overlay.show_path_preview(path)
	var destination: Panel = overlay.movement_layer.get_node("SelectedDestinationTile")
	assert(destination.position.x > 100.0)
	assert(destination.get_child(0).text == "✓")
	overlay.show_path_preview(path, true)
	await get_tree().process_frame
	destination = overlay.movement_layer.get_node("SelectedDestinationTile")
	assert(destination.get_child(0).text == "!")
	overlay.clear_path_preview()
	await get_tree().process_frame
	assert(overlay.movement_layer.get_node_or_null("SelectedDestinationTile") == null)
	print("movement_preview_test passed")
	get_tree().quit(0)
