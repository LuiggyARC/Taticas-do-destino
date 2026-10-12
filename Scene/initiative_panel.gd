extends Node

signal roll_requested

var panel: PanelContainer
var information_label: Label
var roll_button: Button
var ui_parent: CanvasLayer


func setup(
	new_ui_parent: CanvasLayer,
	scenario_text: String,
	button_sfx_callback: Callable = Callable()
) -> void:
	if not is_instance_valid(new_ui_parent):
		return
	
	ui_parent = new_ui_parent
	
	if is_instance_valid(panel):
		panel.queue_free()
	
	panel = null
	information_label = null
	roll_button = null
	
	create_panel(
		scenario_text,
		button_sfx_callback
	)


func create_panel(
	scenario_text: String,
	button_sfx_callback: Callable
) -> void:
	if not is_instance_valid(ui_parent):
		return
	
	var old_panel := ui_parent.get_node_or_null(
		"ScenarioStartPanel"
	)
	
	if is_instance_valid(old_panel):
		old_panel.queue_free()
	
	panel = PanelContainer.new()
	panel.name = "ScenarioStartPanel"
	
	panel.set_anchors_preset(
		Control.PRESET_CENTER
	)
	
	panel.offset_left = -360 if OS.has_feature("mobile") else -260
	panel.offset_right = 360 if OS.has_feature("mobile") else 260
	panel.offset_top = -260 if OS.has_feature("mobile") else -190
	panel.offset_bottom = 260 if OS.has_feature("mobile") else 190
	
	var panel_style := StyleBoxFlat.new()
	
	panel_style.bg_color = Color(
		0.02,
		0.025,
		0.03,
		0.92
	)
	
	panel_style.border_color = Color(
		0.78,
		0.62,
		0.28,
		0.95
	)
	
	panel_style.set_border_width_all(3)
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12
	
	panel_style.content_margin_left = 18
	panel_style.content_margin_top = 16
	panel_style.content_margin_right = 18
	panel_style.content_margin_bottom = 16
	
	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	ui_parent.add_child(panel)
	
	var main_box := VBoxContainer.new()
	main_box.name = "ScenarioStartBox"
	
	main_box.add_theme_constant_override(
		"separation",
		12
	)
	
	panel.add_child(main_box)
	
	var title_label := Label.new()
	title_label.text = "Preparação do Combate"
	
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	title_label.add_theme_font_size_override(
		"font_size",
		32 if OS.has_feature("mobile") else 24
	)
	
	title_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.92,
			0.65,
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
	
	main_box.add_child(title_label)
	
	information_label = Label.new()
	information_label.name = (
		"ScenarioStartLabel"
	)
	information_label.text = scenario_text
	
	information_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	
	information_label.custom_minimum_size = (
		Vector2(
			660 if OS.has_feature("mobile") else 470,
			300 if OS.has_feature("mobile") else 210
		)
	)
	
	information_label.add_theme_font_size_override(
		"font_size",
		28 if OS.has_feature("mobile") else 16
	)
	
	information_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.96,
			0.84,
			1.0
		)
	)
	
	main_box.add_child(information_label)
	
	roll_button = Button.new()
	roll_button.name = "RollInitiativeButton"
	roll_button.text = "Rolar Iniciativa"
	
	roll_button.custom_minimum_size = Vector2(
		660 if OS.has_feature("mobile") else 470,
		80 if OS.has_feature("mobile") else 48
	)
	roll_button.add_theme_font_size_override(
		"font_size",
		30 if OS.has_feature("mobile") else 18
	)
	
	roll_button.pressed.connect(
		request_roll
	)
	
	main_box.add_child(roll_button)
	
	if button_sfx_callback.is_valid():
		button_sfx_callback.call(
			roll_button
		)


func request_roll() -> void:
	if not is_instance_valid(roll_button):
		return
	
	if roll_button.disabled:
		return
	
	roll_requested.emit()


func mark_as_rolled() -> void:
	if not is_instance_valid(roll_button):
		return
	
	roll_button.disabled = true
	roll_button.text = "Iniciativa Rolada"


func show_initiative_results(
	initiative_order: Array,
	display_name_callback: Callable
) -> void:
	if not is_instance_valid(
		information_label
	):
		return
	
	var lines: Array[String] = []
	
	lines.append("Iniciativa rolada!")
	lines.append("")
	lines.append("Ordem de ação:")
	
	for unit_value in initiative_order:
		if not unit_value is Node2D:
			continue
		
		var unit: Node2D = unit_value
		
		if not is_instance_valid(unit):
			continue
		
		var unit_name: String = str(
			unit.name
		)
		
		if display_name_callback.is_valid():
			unit_name = str(
				display_name_callback.call(
					unit
				)
			)
		
		lines.append(
			str(lines.size() - 2)
			+ ". "
			+ unit_name
		)
	
	lines.append("")
	lines.append(
		"A batalha vai começar..."
	)
	
	information_label.text = "\n".join(
		lines
	)


func close_panel() -> void:
	if is_instance_valid(panel):
		panel.queue_free()
	
	panel = null
	information_label = null
	roll_button = null


func get_panel() -> PanelContainer:
	return panel


func get_information_label() -> Label:
	return information_label


func get_roll_button() -> Button:
	return roll_button
