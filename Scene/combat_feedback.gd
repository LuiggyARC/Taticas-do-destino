extends Node

var feedback_layer: CanvasLayer
var board_root: Node2D


func setup(
	new_board_root: Node2D
) -> void:
	board_root = new_board_root
	create_feedback_layer()


func set_board_root(
	new_board_root: Node2D
) -> void:
	board_root = new_board_root


func create_feedback_layer() -> void:
	if is_instance_valid(feedback_layer):
		return
	
	feedback_layer = CanvasLayer.new()
	feedback_layer.name = "FloatingTextLayer"
	feedback_layer.layer = 20
	
	add_child(feedback_layer)


func clear_feedback() -> void:
	if not is_instance_valid(feedback_layer):
		return
	
	for child in feedback_layer.get_children():
		child.queue_free()


func show_floating_text(
	text: String,
	world_position: Vector2,
	font_size: int = 26,
	feedback_type: String = "neutral"
) -> void:
	if not is_instance_valid(feedback_layer):
		create_feedback_layer()
	
	var label := Label.new()
	
	label.text = text
	label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	label.custom_minimum_size = Vector2(
		180,
		46
	)
	label.size = Vector2(
		180,
		46
	)
	
	label.add_theme_font_size_override(
		"font_size",
		font_size
	)
	
	var font_color: Color = Color.WHITE
	var outline_color: Color = Color.BLACK
	var outline_size: int = 3
	
	match feedback_type:
		"damage":
			font_color = Color(
				1.0,
				0.12,
				0.08,
				1.0
			)
			outline_color = Color(
				0.15,
				0.0,
				0.0,
				1.0
			)
			outline_size = 4
		
		"heal":
			font_color = Color(
				0.20,
				1.0,
				0.30,
				1.0
			)
			outline_color = Color(
				0.0,
				0.18,
				0.03,
				1.0
			)
			outline_size = 4
		
		"critical":
			font_color = Color(
				1.0,
				0.88,
				0.05,
				1.0
			)
			outline_color = Color(
				0.35,
				0.16,
				0.0,
				1.0
			)
			outline_size = 5
		
		"miss":
			font_color = Color(
				0.85,
				0.85,
				0.85,
				1.0
			)
			outline_color = Color(
				0.05,
				0.05,
				0.05,
				1.0
			)
			outline_size = 3
		
		"buff", "control", "utility":
			font_color = Color.WHITE
			outline_color = Color(
				0.0,
				0.35,
				1.0,
				1.0
			)
			outline_size = 4
		
		_:
			font_color = Color.WHITE
			outline_color = Color.BLACK
			outline_size = 3
	
	label.add_theme_color_override(
		"font_color",
		font_color
	)
	
	label.add_theme_color_override(
		"font_outline_color",
		outline_color
	)
	
	label.add_theme_constant_override(
		"outline_size",
		outline_size
	)
	
	label.add_theme_color_override(
		"font_shadow_color",
		Color(
			0.0,
			0.0,
			0.0,
			0.85
		)
	)
	
	label.add_theme_constant_override(
		"shadow_offset_x",
		2
	)
	
	label.add_theme_constant_override(
		"shadow_offset_y",
		2
	)
	
	var screen_position: Vector2 = (
		world_position
	)
	
	if is_instance_valid(board_root):
		screen_position = (
			board_root
			.get_global_transform_with_canvas()
			* world_position
		)
	
	label.position = (
		screen_position
		- Vector2(
			90,
			54
		)
	)
	
	feedback_layer.add_child(label)
	
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		label,
		"position",
		label.position
		+ Vector2(
			0,
			-48
		),
		0.85
	)
	
	tween.tween_property(
		label,
		"modulate:a",
		0.0,
		0.85
	)
	
	tween.set_parallel(false)
	tween.tween_callback(
		label.queue_free
	)


func show_on_unit(
	unit: Node2D,
	text: String,
	font_size: int = 26,
	feedback_type: String = "neutral"
) -> void:
	if not is_instance_valid(unit):
		return
	
	show_floating_text(
		text,
		unit.position,
		font_size,
		feedback_type
	)


func shake_unit(
	unit: Node2D,
	strength: float = 6.0,
	duration: float = 0.22
) -> void:
	if not is_instance_valid(unit):
		return
	
	var original_position: Vector2 = (
		unit.position
	)
	
	var tween := create_tween()
	
	tween.tween_property(
		unit,
		"position",
		original_position
		+ Vector2(strength, 0),
		duration / 6.0
	)
	
	tween.tween_property(
		unit,
		"position",
		original_position
		+ Vector2(-strength, 0),
		duration / 6.0
	)
	
	tween.tween_property(
		unit,
		"position",
		original_position
		+ Vector2(
			strength * 0.7,
			0
		),
		duration / 6.0
	)
	
	tween.tween_property(
		unit,
		"position",
		original_position
		+ Vector2(
			-strength * 0.7,
			0
		),
		duration / 6.0
	)
	
	tween.tween_property(
		unit,
		"position",
		original_position
		+ Vector2(
			strength * 0.35,
			0
		),
		duration / 6.0
	)
	
	tween.tween_property(
		unit,
		"position",
		original_position,
		duration / 6.0
	)


func pulse_unit(
	unit: Node2D,
	scale_bonus: float = 0.18,
	duration: float = 0.25
) -> void:
	if not is_instance_valid(unit):
		return
	
	var original_scale: Vector2 = unit.scale
	var tween := create_tween()
	
	tween.tween_property(
		unit,
		"scale",
		original_scale
		+ Vector2(
			scale_bonus,
			scale_bonus
		),
		duration / 2.0
	)
	
	tween.tween_property(
		unit,
		"scale",
		original_scale,
		duration / 2.0
	)


func flash_unit(
	unit: Node2D,
	flash_color: Color = Color.WHITE,
	duration: float = 0.18
) -> void:
	if not is_instance_valid(unit):
		return
	
	var original_modulate: Color = (
		unit.modulate
	)
	
	var tween := create_tween()
	
	tween.tween_property(
		unit,
		"modulate",
		flash_color,
		duration / 2.0
	)
	
	tween.tween_property(
		unit,
		"modulate",
		original_modulate,
		duration / 2.0
	)
