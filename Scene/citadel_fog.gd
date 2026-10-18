extends Node2D

const Rules = preload("res://Scene/citadel_stealth_rules.gd")

var visible_cells: Dictionary = {}
var explored_cells: Dictionary = {}
var danger_cells: Dictionary = {}


func set_visibility(new_visible: Dictionary, new_explored: Dictionary, new_danger: Dictionary) -> void:
	visible_cells = new_visible
	explored_cells = new_explored
	danger_cells = new_danger
	queue_redraw()


func _draw() -> void:
	for y in range(Rules.GRID_SIZE.y):
		for x in range(Rules.GRID_SIZE.x):
			var cell := Vector2i(x, y)
			var rect := Rect2(Vector2(cell * Rules.TILE_SIZE), Vector2.ONE * Rules.TILE_SIZE)
			if not visible_cells.has(cell):
				draw_rect(rect, Color(0.0, 0.01, 0.02, 0.74 if explored_cells.has(cell) else 0.985))
			else:
				draw_rect(rect, Color(0.0, 0.01, 0.02, 0.10))
				if danger_cells.has(cell):
					draw_rect(rect, Color(0.93, 0.12, 0.08, 0.38))
					for edge in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
						if danger_cells.has(cell + edge):
							continue
						var line_start: Vector2 = rect.position
						var line_end: Vector2 = rect.position
						if edge == Vector2i.LEFT:
							line_end.y += Rules.TILE_SIZE
						elif edge == Vector2i.RIGHT:
							line_start.x += Rules.TILE_SIZE
							line_end = line_start + Vector2(0, Rules.TILE_SIZE)
						elif edge == Vector2i.UP:
							line_end.x += Rules.TILE_SIZE
						else:
							line_start.y += Rules.TILE_SIZE
							line_end = line_start + Vector2(Rules.TILE_SIZE, 0)
						draw_line(line_start, line_end, Color(1.0, 0.25, 0.15, 0.92), 3.0)
