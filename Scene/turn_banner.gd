extends Node

var banner_layer: CanvasLayer
var banner_label: Label
var banner_tween: Tween
var last_group: String = ""


func setup() -> void:
	create_banner_layer()


func create_banner_layer() -> void:
	if is_instance_valid(banner_layer):
		reset()
		return
	
	banner_layer = CanvasLayer.new()
	banner_layer.name = "TurnBannerLayer"
	banner_layer.layer = 40
	
	add_child(banner_layer)
	
	var root_control := Control.new()
	root_control.name = "TurnBannerRoot"
	
	root_control.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	root_control.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	banner_layer.add_child(root_control)
	
	banner_label = Label.new()
	banner_label.name = "TurnBannerLabel"
	banner_label.text = ""
	banner_label.visible = false
	banner_label.modulate = Color(
		1.0,
		1.0,
		1.0,
		0.0
	)
	
	banner_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	banner_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	banner_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	banner_label.add_theme_font_size_override(
		"font_size",
		42
	)
	
	banner_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.90,
			0.45,
			1.0
		)
	)
	
	banner_label.add_theme_color_override(
		"font_shadow_color",
		Color(
			0.0,
			0.0,
			0.0,
			0.95
		)
	)
	
	banner_label.add_theme_constant_override(
		"shadow_offset_x",
		3
	)
	
	banner_label.add_theme_constant_override(
		"shadow_offset_y",
		3
	)
	
	banner_label.set_anchors_preset(
		Control.PRESET_CENTER
	)
	
	banner_label.custom_minimum_size = Vector2(
		900,
		90
	)
	
	banner_label.position = Vector2(
		-450,
		-45
	)
	
	root_control.add_child(banner_label)


func reset() -> void:
	last_group = ""
	
	if is_instance_valid(banner_tween):
		banner_tween.kill()
	
	banner_tween = null
	
	if is_instance_valid(banner_label):
		banner_label.text = ""
		banner_label.visible = false
		banner_label.scale = Vector2.ONE
		banner_label.modulate = Color(
			1.0,
			1.0,
			1.0,
			0.0
		)


func show_for_group(
	group_name: String
) -> void:
	if group_name == "":
		return
	
	if group_name == last_group:
		return
	
	var banner_text: String = (
		get_text_for_group(group_name)
	)
	
	if banner_text == "":
		return
	
	last_group = group_name
	show_text(banner_text)


func get_text_for_group(
	group_name: String
) -> String:
	match group_name:
		"hero":
			return "TURNO DOS ALIADOS"
		
		"enemy":
			return "TURNO DOS INIMIGOS"
		
		_:
			return ""


func show_text(
	text: String
) -> void:
	if not is_instance_valid(banner_label):
		create_banner_layer()
	
	if not is_instance_valid(banner_label):
		return
	
	if text == "":
		return
	
	if is_instance_valid(banner_tween):
		banner_tween.kill()
	
	banner_label.text = text
	banner_label.visible = true
	banner_label.scale = Vector2(
		0.90,
		0.90
	)
	banner_label.modulate = Color(
		1.0,
		1.0,
		1.0,
		0.0
	)
	
	banner_tween = create_tween()
	banner_tween.set_parallel(false)
	banner_tween.set_trans(
		Tween.TRANS_SINE
	)
	banner_tween.set_ease(
		Tween.EASE_IN_OUT
	)
	
	banner_tween.tween_property(
		banner_label,
		"modulate",
		Color(
			1.0,
			1.0,
			1.0,
			1.0
		),
		0.25
	)
	
	banner_tween.parallel().tween_property(
		banner_label,
		"scale",
		Vector2.ONE,
		0.25
	)
	
	banner_tween.tween_interval(2.5)
	
	banner_tween.tween_property(
		banner_label,
		"modulate",
		Color(
			1.0,
			1.0,
			1.0,
			0.0
		),
		0.25
	)
	
	banner_tween.tween_callback(
		hide_banner
	)


func hide_banner() -> void:
	if is_instance_valid(banner_label):
		banner_label.visible = false


func get_last_group() -> String:
	return last_group
