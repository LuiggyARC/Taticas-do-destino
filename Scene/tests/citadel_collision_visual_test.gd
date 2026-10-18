extends Node2D

const Rules = preload("res://Scene/citadel_stealth_rules.gd")


func _ready() -> void:
	var map := Sprite2D.new()
	map.texture = load(Rules.MAP_PATH)
	map.centered = false
	map.scale = Vector2(0.5, 0.5)
	map.z_index = -1
	add_child(map)
	queue_redraw()
	for frame in range(4):
		await get_tree().process_frame
	var preview: Image = get_viewport().get_texture().get_image()
	var path: String = ProjectSettings.globalize_path("user://citadel_collision_preview.png")
	assert(preview.save_png(path) == OK)
	print("Citadel collision preview: ", path)
	get_tree().quit(0)


func _draw() -> void:
	for wall in Rules.WALLS:
		draw_rect(Rect2(wall.position * 0.5, wall.size * 0.5), Color(0.72, 0.19, 0.95, 0.46))
	for furniture in Rules.FURNITURE:
		draw_rect(Rect2(furniture.position * 0.5, furniture.size * 0.5), Color(1.0, 0.10, 0.07, 0.32))
	for y in range(Rules.GRID_SIZE.y):
		for x in range(Rules.GRID_SIZE.x):
			var cell := Vector2i(x, y)
			var rect := Rect2(Vector2(cell) * 32.0, Vector2(32, 32))
			if Rules.blocked(cell):
				draw_rect(rect, Color(1.0, 0.05, 0.08, 0.44))
			draw_rect(rect, Color(0.8, 0.9, 1.0, 0.32), false, 1.0)
