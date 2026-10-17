extends Node2D

var tile_size: int = 64
var intents: Array[Dictionary] = []


func setup(new_tile_size: int) -> void:
	name = "EnemyIntentOverlay"
	tile_size = maxi(1, new_tile_size)
	z_index = 15


func set_intents(new_intents: Array[Dictionary]) -> void:
	intents = new_intents.duplicate(true)
	queue_redraw()


func _draw() -> void:
	for intent in intents:
		var source: Vector2 = intent.get("source", Vector2.ZERO)
		var target: Vector2 = intent.get("target", Vector2.ZERO)
		var toward_target: Vector2 = target - source
		if toward_target.length() < float(tile_size) * 0.8:
			continue
		var direction: Vector2 = toward_target.normalized()
		var side := Vector2(-direction.y, direction.x)
		var line_start: Vector2 = source + direction * float(tile_size) * 0.32
		var tip: Vector2 = target - direction * float(tile_size) * 0.36
		var main_color := Color(1.0, 0.32, 0.24, 0.88) if bool(intent.get("in_range", false)) else Color(1.0, 0.72, 0.23, 0.82)
		var dark_color := Color(0.04, 0.02, 0.02, 0.75)
		draw_line(line_start, tip - direction * 7.0, dark_color, 8.0, true)
		draw_line(line_start, tip - direction * 7.0, main_color, 4.0, true)
		draw_colored_polygon(PackedVector2Array([
			tip + direction * 2.0,
			tip - direction * 19.0 + side * 10.0,
			tip - direction * 19.0 - side * 10.0
		]), dark_color)
		draw_colored_polygon(PackedVector2Array([
			tip,
			tip - direction * 15.0 + side * 7.0,
			tip - direction * 15.0 - side * 7.0
		]), main_color)
