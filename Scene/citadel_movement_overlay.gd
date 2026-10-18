extends Node2D

const Rules = preload("res://Scene/citadel_stealth_rules.gd")

var reachable: Dictionary = {}


func set_reachable(cells: Dictionary) -> void:
	reachable = cells
	queue_redraw()


func _draw() -> void:
	for cell in reachable:
		var rect := Rect2(Vector2(cell * Rules.TILE_SIZE), Vector2.ONE * Rules.TILE_SIZE)
		var inset := rect.grow(-4.0)
		draw_rect(inset, Color(0.10, 0.46, 0.95, 0.27))
		draw_rect(inset, Color(0.34, 0.75, 1.0, 0.72), false, 2.0)
