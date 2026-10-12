extends Node2D


func _draw() -> void:
	draw_wagon(Vector2.ZERO)
	draw_wagon(Vector2(0.0, -150.0))
	draw_banner(Vector2(-72.0, -70.0))
	draw_banner(Vector2(72.0, -210.0))


func draw_wagon(center: Vector2) -> void:
	var body := Rect2(center + Vector2(-35.0, -43.0), Vector2(70.0, 86.0))
	draw_rect(body.grow(4.0), Color(0.14, 0.09, 0.05))
	draw_rect(body, Color(0.43, 0.26, 0.11))
	for plank in range(4):
		var plank_y: float = center.y - 31.0 + float(plank) * 20.0
		draw_line(
			Vector2(center.x - 32.0, plank_y),
			Vector2(center.x + 32.0, plank_y),
			Color(0.67, 0.44, 0.22),
			3.0
		)
	for side in [-1.0, 1.0]:
		for axle in [-27.0, 27.0]:
			draw_circle(
				center + Vector2(side * 43.0, axle),
				12.0,
				Color(0.16, 0.12, 0.08)
			)
			draw_circle(
				center + Vector2(side * 43.0, axle),
				4.0,
				Color(0.62, 0.53, 0.32)
			)
	draw_line(
		center + Vector2(-16.0, -43.0),
		center + Vector2(-16.0, -77.0),
		Color(0.35, 0.24, 0.14),
		4.0
	)
	draw_line(
		center + Vector2(16.0, -43.0),
		center + Vector2(16.0, -77.0),
		Color(0.35, 0.24, 0.14),
		4.0
	)
	draw_circle(
		center + Vector2(0.0, -85.0),
		15.0,
		Color(0.38, 0.27, 0.16)
	)


func draw_banner(at: Vector2) -> void:
	draw_line(
		at + Vector2(0.0, 24.0),
		at + Vector2(0.0, -34.0),
		Color(0.72, 0.65, 0.45),
		3.0
	)
	draw_colored_polygon(
		PackedVector2Array([
			at + Vector2(2.0, -32.0),
			at + Vector2(31.0, -26.0),
			at + Vector2(2.0, -6.0)
		]),
		Color(0.18, 0.33, 0.70)
	)
	draw_circle(at + Vector2(10.0, -20.0), 5.0, Color(0.92, 0.76, 0.35))
