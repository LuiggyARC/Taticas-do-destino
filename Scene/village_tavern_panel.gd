extends Control
class_name VillageTavernPanel


signal drink_requested
signal rumor_requested
signal panel_closed


var service_panel: PanelContainer
var drink_button: Button
var rumor_button: Button
var close_button: Button


func _ready() -> void:
	name = "VillageTavernPanel"
	z_index = 300
	
	mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	create_interface()
	
	visible = false


func create_interface() -> void:
	var dark_background := ColorRect.new()
	dark_background.name = "TavernDarkBackground"
	
	dark_background.color = Color(
		0.0,
		0.0,
		0.0,
		0.58
	)
	
	dark_background.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
	dark_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(
		dark_background
	)
	
	service_panel = PanelContainer.new()
	service_panel.name = "TavernServicePanel"
	
	service_panel.set_anchors_preset(
		Control.PRESET_CENTER
	)
	
	service_panel.offset_left = -325
	service_panel.offset_right = 325
	service_panel.offset_top = -205
	service_panel.offset_bottom = 205
	
	var panel_style := StyleBoxFlat.new()
	
	panel_style.bg_color = Color(
		0.07,
		0.035,
		0.015,
		0.98
	)
	
	panel_style.border_color = Color(
		0.82,
		0.56,
		0.22,
		1.0
	)
	
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(14)
	
	panel_style.content_margin_left = 24
	panel_style.content_margin_right = 24
	panel_style.content_margin_top = 20
	panel_style.content_margin_bottom = 20
	
	service_panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	add_child(
		service_panel
	)
	
	var main_box := VBoxContainer.new()
	main_box.name = "TavernServiceBox"
	
	main_box.add_theme_constant_override(
		"separation",
		14
	)
	
	service_panel.add_child(
		main_box
	)
	
	var title_label := Label.new()
	title_label.name = "TavernTitle"
	title_label.text = "TAVERNA — O POÇO SEM FUNDO"
	
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	title_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	title_label.custom_minimum_size = Vector2(
		0,
		44
	)
	
	title_label.add_theme_font_size_override(
		"font_size",
		24
	)
	
	title_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.78,
			0.38,
			1.0
		)
	)
	
	title_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	title_label.add_theme_constant_override(
		"outline_size",
		4
	)
	
	main_box.add_child(
		title_label
	)
	
	var description_label := Label.new()
	description_label.name = "TavernDescription"
	
	description_label.text = (
		"Descanse por alguns instantes, compre uma "
		+ "bebida ou escute os rumores da vila."
	)
	
	description_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	description_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	
	description_label.custom_minimum_size = Vector2(
		0,
		54
	)
	
	description_label.add_theme_font_size_override(
		"font_size",
		17
	)
	
	description_label.add_theme_color_override(
		"font_color",
		Color(
			0.96,
			0.90,
			0.78,
			1.0
		)
	)
	
	main_box.add_child(
		description_label
	)
	
	var separator := HSeparator.new()
	
	separator.modulate = Color(
		0.82,
		0.56,
		0.22,
		0.72
	)
	
	main_box.add_child(
		separator
	)
	
	drink_button = create_service_button(
		"DrinkButton",
		"Comprar bebida — 1 PO",
		Color(
			0.28,
			0.12,
			0.035,
			0.98
		),
		Color(
			0.94,
			0.61,
			0.20,
			1.0
		)
	)
	
	drink_button.pressed.connect(
		on_drink_button_pressed
	)
	
	main_box.add_child(
		drink_button
	)
	
	rumor_button = create_service_button(
		"RumorButton",
		"Ouvir um boato",
		Color(
			0.15,
			0.09,
			0.20,
			0.98
		),
		Color(
			0.70,
			0.48,
			0.84,
			1.0
		)
	)
	
	rumor_button.pressed.connect(
		on_rumor_button_pressed
	)
	
	main_box.add_child(
		rumor_button
	)
	
	close_button = create_service_button(
		"CloseButton",
		"Sair da taverna",
		Color(
			0.15,
			0.10,
			0.055,
			0.98
		),
		Color(
			0.72,
			0.58,
			0.34,
			1.0
		)
	)
	
	close_button.pressed.connect(
		close_panel
	)
	
	main_box.add_child(
		close_button
	)


func create_service_button(
	button_name: String,
	button_text: String,
	background_color: Color,
	border_color: Color
) -> Button:
	var button := Button.new()
	button.name = button_name
	button.text = button_text
	
	button.custom_minimum_size = Vector2(
		0,
		54
	)
	
	button.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	var normal_style: StyleBoxFlat = (
		create_button_style(
			background_color,
			border_color
		)
	)
	
	var hover_style: StyleBoxFlat = (
		create_button_style(
			background_color.lightened(
				0.12
			),
			border_color.lightened(
				0.12
			)
		)
	)
	
	var pressed_style: StyleBoxFlat = (
		create_button_style(
			background_color.darkened(
				0.10
			),
			border_color
		)
	)
	
	button.add_theme_stylebox_override(
		"normal",
		normal_style
	)
	
	button.add_theme_stylebox_override(
		"hover",
		hover_style
	)
	
	button.add_theme_stylebox_override(
		"pressed",
		pressed_style
	)
	
	button.add_theme_stylebox_override(
		"focus",
		hover_style
	)
	
	button.add_theme_font_size_override(
		"font_size",
		18
	)
	
	button.add_theme_color_override(
		"font_color",
		Color.WHITE
	)
	
	button.add_theme_color_override(
		"font_hover_color",
		Color.WHITE
	)
	
	button.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	button.add_theme_constant_override(
		"outline_size",
		2
	)
	
	return button


func create_button_style(
	background_color: Color,
	border_color: Color
) -> StyleBoxFlat:
	var button_style := StyleBoxFlat.new()
	
	button_style.bg_color = background_color
	button_style.border_color = border_color
	
	button_style.set_border_width_all(2)
	button_style.set_corner_radius_all(9)
	
	button_style.content_margin_left = 12
	button_style.content_margin_right = 12
	button_style.content_margin_top = 8
	button_style.content_margin_bottom = 8
	
	return button_style


func open_panel(
	free_drink_available: bool = false
) -> void:
	if is_instance_valid(drink_button):
		if free_drink_available:
			drink_button.text = (
				"Aceitar bebida grátis"
			)
		else:
			drink_button.text = (
				"Comprar bebida — 1 PO"
			)
	
	visible = true
	move_to_front()


func close_panel() -> void:
	visible = false
	panel_closed.emit()


func on_drink_button_pressed() -> void:
	drink_requested.emit()


func on_rumor_button_pressed() -> void:
	rumor_requested.emit()
