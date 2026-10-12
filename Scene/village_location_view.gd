extends Control


signal return_to_village_requested


var background_rect: TextureRect
var location_title_label: Label
var return_button: Button


func _ready() -> void:
	name = "VillageLocationView"
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
	create_interface()
	
	visible = false


func create_interface() -> void:
	var black_background := ColorRect.new()
	black_background.name = "LocationBlackBackground"
	black_background.color = Color.BLACK
	
	black_background.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	black_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(
		black_background
	)
	
	background_rect = TextureRect.new()
	background_rect.name = "LocationBackground"
	
	background_rect.expand_mode = (
		TextureRect.EXPAND_IGNORE_SIZE
	)
	
	background_rect.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_COVERED
	)
	
	background_rect.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	background_rect.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(
		background_rect
	)
	
	var top_bar := PanelContainer.new()
	top_bar.name = "LocationTopBar"
	
	top_bar.set_anchors_preset(
		Control.PRESET_TOP_WIDE
	)
	
	top_bar.offset_left = 18
	top_bar.offset_right = -18
	top_bar.offset_top = 16
	top_bar.offset_bottom = 76
	
	var top_bar_style := StyleBoxFlat.new()
	
	top_bar_style.bg_color = Color(
		0.015,
		0.02,
		0.025,
		0.92
	)
	
	top_bar_style.border_color = Color(
		0.72,
		0.55,
		0.22,
		0.96
	)
	
	top_bar_style.set_border_width_all(2)
	top_bar_style.set_corner_radius_all(10)
	
	top_bar_style.content_margin_left = 8
	top_bar_style.content_margin_right = 8
	top_bar_style.content_margin_top = 5
	top_bar_style.content_margin_bottom = 5
	
	top_bar.add_theme_stylebox_override(
		"panel",
		top_bar_style
	)
	
	add_child(
		top_bar
	)
	
	var top_row := HBoxContainer.new()
	top_row.name = "LocationTopRow"
	
	top_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	top_row.alignment = (
		BoxContainer.ALIGNMENT_CENTER
	)
	
	top_row.add_theme_constant_override(
		"separation",
		12
	)
	
	top_bar.add_child(
		top_row
	)
	
	return_button = Button.new()
	return_button.name = "ReturnToVillageButton"
	return_button.text = "Voltar para a vila"
	
	return_button.custom_minimum_size = Vector2(
		190,
		46
	)
	
	var return_normal_style := (
		create_button_style(
			Color(
				0.18,
				0.115,
				0.035,
				0.98
			),
			Color(
				0.82,
				0.64,
				0.27,
				1.0
			)
		)
	)
	
	var return_hover_style := (
		create_button_style(
			Color(
				0.28,
				0.18,
				0.055,
				1.0
			),
			Color(
				1.0,
				0.82,
				0.38,
				1.0
			)
		)
	)
	
	var return_pressed_style := (
		create_button_style(
			Color(
				0.11,
				0.07,
				0.025,
				1.0
			),
			Color(
				0.72,
				0.52,
				0.18,
				1.0
			)
		)
	)
	
	return_button.add_theme_stylebox_override(
		"normal",
		return_normal_style
	)
	
	return_button.add_theme_stylebox_override(
		"hover",
		return_hover_style
	)
	
	return_button.add_theme_stylebox_override(
		"pressed",
		return_pressed_style
	)
	
	return_button.add_theme_stylebox_override(
		"focus",
		return_hover_style
	)
	
	return_button.add_theme_font_size_override(
		"font_size",
		16
	)
	
	return_button.add_theme_color_override(
		"font_color",
		Color.WHITE
	)
	
	return_button.add_theme_color_override(
		"font_hover_color",
		Color.WHITE
	)
	
	return_button.add_theme_color_override(
		"font_pressed_color",
		Color(
			1.0,
			0.90,
			0.62,
			1.0
		)
	)
	
	return_button.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	return_button.add_theme_constant_override(
		"outline_size",
		2
	)
	
	return_button.pressed.connect(
		on_return_button_pressed
	)
	
	top_row.add_child(
		return_button
	)
	
	location_title_label = Label.new()
	location_title_label.name = "LocationTitleLabel"
	location_title_label.text = "LOCAL"
	
	location_title_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	location_title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	location_title_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	location_title_label.add_theme_font_size_override(
		"font_size",
		22
	)
	
	location_title_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.88,
			0.60,
			1.0
		)
	)
	
	location_title_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	location_title_label.add_theme_constant_override(
		"outline_size",
		4
	)
	
	top_row.add_child(
		location_title_label
	)
	
	# Mantém o título centralizado compensando
	# a largura do botão localizado à esquerda.
	var right_spacer := Control.new()
	right_spacer.name = "RightTitleSpacer"
	
	right_spacer.custom_minimum_size = Vector2(
		190,
		46
	)
	
	top_row.add_child(
		right_spacer
	)


func create_button_style(
	background_color: Color,
	border_color: Color
) -> StyleBoxFlat:
	var button_style := StyleBoxFlat.new()
	
	button_style.bg_color = background_color
	button_style.border_color = border_color
	
	button_style.set_border_width_all(2)
	button_style.set_corner_radius_all(8)
	
	button_style.content_margin_left = 10
	button_style.content_margin_right = 10
	button_style.content_margin_top = 6
	button_style.content_margin_bottom = 6
	
	return button_style


func open_location(
	location_texture: Texture2D,
	location_title: String
) -> void:
	if not is_instance_valid(background_rect):
		return
	
	background_rect.texture = location_texture
	
	if is_instance_valid(location_title_label):
		location_title_label.text = (
			location_title.to_upper()
		)
	
	visible = true
	
	move_to_front()


func close_location() -> void:
	visible = false
	
	if is_instance_valid(background_rect):
		background_rect.texture = null


func on_return_button_pressed() -> void:
	close_location()
	
	return_to_village_requested.emit()
