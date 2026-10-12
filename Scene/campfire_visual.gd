extends Node2D

var flame_time: float = 0.0


func _process(delta: float) -> void:
	flame_time += delta
	queue_redraw()


func _draw() -> void:
	var flicker: float = sin(flame_time * 8.0) * 3.0
	var glow: Color = Color(1.0, 0.48, 0.10, 0.12)
	draw_circle(Vector2.ZERO, 70.0 + flicker, glow)
	draw_circle(Vector2.ZERO, 43.0, Color(1.0, 0.52, 0.12, 0.20))
	draw_circle(Vector2(0.0, 8.0), 17.0, Color(0.17, 0.11, 0.08))

	draw_line(Vector2(-22.0, 12.0), Vector2(20.0, -8.0), Color(0.30, 0.16, 0.08), 10.0)
	draw_line(Vector2(-20.0, -8.0), Vector2(21.0, 13.0), Color(0.40, 0.22, 0.10), 10.0)
	draw_line(Vector2(-22.0, 12.0), Vector2(20.0, -8.0), Color(0.62, 0.35, 0.16), 2.0)

	var flame_height: float = 32.0 + sin(flame_time * 9.0) * 5.0
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-17.0, 3.0),
			Vector2(-9.0, -flame_height * 0.65),
			Vector2(-2.0, -flame_height * 0.28),
			Vector2(5.0 + flicker, -flame_height),
			Vector2(17.0, 3.0)
		]),
		Color(1.0, 0.35, 0.05, 0.92)
	)
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(-9.0, 3.0),
			Vector2(0.0, -flame_height * 0.70),
			Vector2(5.0, -flame_height * 0.35),
			Vector2(11.0, 3.0)
		]),
		Color(1.0, 0.77, 0.18, 0.98)
	)
	draw_circle(Vector2(0.0, -5.0), 5.0, Color(1.0, 0.95, 0.55))
