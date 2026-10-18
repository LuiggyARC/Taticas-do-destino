extends Node2D


func _draw() -> void:
	draw_circle(Vector2(2, 4), 29.0, Color(0.0, 0.0, 0.0, 0.65))
	draw_rect(Rect2(-23, -7, 46, 29), Color(0.30, 0.15, 0.07))
	draw_rect(Rect2(-23, -7, 46, 29), Color(0.93, 0.70, 0.28), false, 3.0)
	draw_rect(Rect2(-25, -20, 50, 15), Color(0.51, 0.27, 0.11))
	draw_rect(Rect2(-25, -20, 50, 15), Color(1.0, 0.80, 0.36), false, 3.0)
	draw_rect(Rect2(-4, -6, 8, 12), Color(1.0, 0.87, 0.46))
	draw_circle(Vector2.ZERO, 2.2, Color(0.26, 0.17, 0.10))
