extends Node2D

var visual_kind: String = "energy"
var elapsed: float = 0.0
var lifetime: float = 0.8
var particles: Array[Dictionary] = []


func configure(kind: String) -> void:
	visual_kind = kind
	z_index = 80
	particles.clear()
	for index in range(14):
		particles.append({
			"x": randf_range(-27.0, 27.0),
			"y": randf_range(-35.0, 26.0),
			"speed": randf_range(25.0, 72.0),
			"size": randf_range(2.0, 4.5),
			"phase": randf_range(0.0, TAU)
		})
	queue_redraw()


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var fade: float = clampf(1.0 - elapsed / lifetime, 0.0, 1.0)
	var pulse: float = 1.0 + 0.15 * sin(elapsed * 18.0)
	match visual_kind:
		"fire":
			draw_fire(fade, pulse)
		"light":
			draw_light(fade, pulse)
		"heal":
			draw_heal(fade, pulse)
		_:
			draw_energy(fade, pulse)


func draw_fire(fade: float, pulse: float) -> void:
	draw_circle(Vector2.ZERO, 29.0 * pulse, Color(1.0, 0.3, 0.04, 0.16 * fade))
	draw_circle(Vector2.ZERO, 14.0 * pulse, Color(1.0, 0.76, 0.12, 0.38 * fade))
	for particle in particles:
		var x: float = float(particle["x"]) + sin(elapsed * 10.0 + float(particle["phase"])) * 6.0
		var y: float = float(particle["y"]) - elapsed * float(particle["speed"])
		var size: float = float(particle["size"]) * pulse
		var tip: Vector2 = Vector2(x, y - size * 2.7)
		var flame: PackedVector2Array = PackedVector2Array([
			Vector2(x - size, y + size), tip, Vector2(x + size, y + size)
		])
		draw_colored_polygon(flame, Color(1.0, 0.35, 0.05, fade))
		draw_circle(Vector2(x, y), size * 0.65, Color(1.0, 0.82, 0.18, fade))


func draw_light(fade: float, pulse: float) -> void:
	draw_circle(Vector2.ZERO, 32.0 * pulse, Color(1.0, 0.95, 0.55, 0.16 * fade))
	draw_circle(Vector2.ZERO, 13.0 * pulse, Color(1.0, 1.0, 0.9, 0.68 * fade))
	for ray in range(12):
		var angle: float = TAU * float(ray) / 12.0 + elapsed * 0.7
		var direction: Vector2 = Vector2(cos(angle), sin(angle))
		draw_line(direction * 18.0, direction * (37.0 * pulse),
			Color(1.0, 0.9, 0.48, 0.8 * fade), 3.0, true)
	for particle in particles:
		var point: Vector2 = Vector2(float(particle["x"]), float(particle["y"]))
		draw_circle(point, float(particle["size"]) * 0.65,
			Color(1.0, 1.0, 0.73, 0.8 * fade))


func draw_energy(fade: float, pulse: float) -> void:
	draw_circle(Vector2.ZERO, 28.0 * pulse, Color(0.24, 0.39, 1.0, 0.18 * fade))
	for arc in range(6):
		var angle: float = TAU * float(arc) / 6.0 + elapsed * 5.0
		var start: Vector2 = Vector2(cos(angle), sin(angle)) * 10.0
		var middle: Vector2 = Vector2(cos(angle + 0.22), sin(angle + 0.22)) * 24.0
		var finish: Vector2 = Vector2(cos(angle - 0.1), sin(angle - 0.1)) * 39.0
		draw_line(start, middle, Color(0.5, 0.72, 1.0, fade), 3.0, true)
		draw_line(middle, finish, Color(0.82, 0.91, 1.0, fade), 2.0, true)
	for particle in particles:
		var point: Vector2 = Vector2(float(particle["x"]), float(particle["y"]))
		draw_circle(point, float(particle["size"]) * 0.7,
			Color(0.47, 0.76, 1.0, fade))


func draw_heal(fade: float, pulse: float) -> void:
	draw_circle(Vector2.ZERO, 31.0 * pulse, Color(0.1, 0.95, 0.36, 0.13 * fade))
	draw_arc(Vector2.ZERO, 23.0 * pulse, 0.0, TAU, 32,
		Color(0.45, 1.0, 0.56, 0.67 * fade), 2.5, true)
	for particle in particles:
		var x: float = float(particle["x"])
		var y: float = float(particle["y"]) + elapsed * float(particle["speed"])
		if y > 34.0:
			y -= 72.0
		var size: float = float(particle["size"])
		var drop: PackedVector2Array = PackedVector2Array([
			Vector2(x, y - size * 1.8),
			Vector2(x - size, y + size * 0.3),
			Vector2(x, y + size),
			Vector2(x + size, y + size * 0.3)
		])
		draw_colored_polygon(drop, Color(0.37, 1.0, 0.47, fade))
		draw_circle(Vector2(x, y + size * 0.3), size * 0.35,
			Color(0.86, 1.0, 0.83, fade))
