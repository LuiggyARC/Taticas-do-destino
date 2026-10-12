extends Node

var panel: PanelContainer
var portrait: TextureRect
var portrait_fallback: Label
var name_label: Label
var hp_bar: ProgressBar
var details_label: Label
var sheet_button: Button
var actions_button: Button
var ui_parent: CanvasLayer

func setup(new_ui_parent: CanvasLayer, sheet_callback: Callable, actions_callback: Callable) -> void:
	ui_parent = new_ui_parent
	panel = PanelContainer.new()
	panel.name = "BattleUnitHUD"
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.offset_left = 14
	panel.offset_top = 18
	panel.offset_right = 364
	panel.offset_bottom = 140
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.035, 0.04, 0.91)
	style.border_color = Color(0.65, 0.54, 0.31)
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.set_content_margin_all(8)
	panel.add_theme_stylebox_override("panel", style)
	ui_parent.add_child(panel)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	panel.add_child(row)
	var portrait_frame := PanelContainer.new()
	portrait_frame.custom_minimum_size = Vector2(102, 102)
	var frame_style := StyleBoxFlat.new()
	frame_style.bg_color = Color(0.08, 0.12, 0.13)
	frame_style.border_color = Color(0.40, 0.81, 0.89)
	frame_style.set_border_width_all(3)
	frame_style.set_corner_radius_all(48)
	frame_style.set_content_margin_all(5)
	portrait_frame.add_theme_stylebox_override("panel", frame_style)
	row.add_child(portrait_frame)
	portrait_fallback = Label.new()
	portrait_fallback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_fallback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	portrait_fallback.add_theme_font_size_override("font_size", 38)
	portrait_frame.add_child(portrait_fallback)
	portrait = TextureRect.new()
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_frame.add_child(portrait)

	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 5)
	row.add_child(details)
	name_label = Label.new()
	name_label.text = "Herói"
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.add_theme_font_size_override("font_size", 21)
	name_label.add_theme_color_override("font_color", Color(0.98, 0.92, 0.78))
	details.add_child(name_label)
	hp_bar = ProgressBar.new()
	hp_bar.custom_minimum_size.y = 18
	hp_bar.show_percentage = false
	var hp_background := StyleBoxFlat.new()
	hp_background.bg_color = Color(0.12, 0.06, 0.05)
	hp_background.border_color = Color(0.76, 0.66, 0.41)
	hp_background.set_border_width_all(1)
	hp_background.set_corner_radius_all(4)
	hp_bar.add_theme_stylebox_override("background", hp_background)
	var hp_fill := StyleBoxFlat.new()
	hp_fill.bg_color = Color(0.20, 0.80, 0.33)
	hp_fill.set_corner_radius_all(3)
	hp_bar.add_theme_stylebox_override("fill", hp_fill)
	details.add_child(hp_bar)
	details_label = Label.new()
	details_label.add_theme_font_size_override("font_size", 17)
	details_label.add_theme_color_override("font_color", Color(0.92, 0.82, 0.55))
	details.add_child(details_label)
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 5)
	details.add_child(buttons)
	sheet_button = Button.new()
	sheet_button.text = "Ver ficha"
	sheet_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sheet_button.custom_minimum_size.y = 30
	sheet_button.add_theme_font_size_override("font_size", 14)
	sheet_button.pressed.connect(sheet_callback)
	buttons.add_child(sheet_button)
	actions_button = Button.new()
	actions_button.text = "Ações −"
	actions_button.tooltip_text = "Mostrar ou ocultar as ações do turno"
	actions_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions_button.custom_minimum_size.y = 30
	actions_button.add_theme_font_size_override("font_size", 14)
	actions_button.pressed.connect(actions_callback)
	buttons.add_child(actions_button)

func update_unit(unit_name: String, hp: int, max_hp: int, armor_class: int, portrait_texture: Texture2D) -> void:
	if not is_instance_valid(panel):
		return
	name_label.text = unit_name
	hp_bar.max_value = maxi(1, max_hp)
	hp_bar.value = clampi(hp, 0, maxi(1, max_hp))
	details_label.text = "PV: %d/%d   CA: %d" % [hp, max_hp, armor_class]
	portrait.texture = portrait_texture
	portrait.visible = portrait_texture != null
	portrait_fallback.text = unit_name.substr(0, 1).to_upper() if not unit_name.is_empty() else "?"
	portrait_fallback.visible = portrait_texture == null

func set_panel_visible(should_be_visible: bool) -> void:
	if is_instance_valid(panel):
		panel.visible = should_be_visible

func set_sheet_open(is_open: bool) -> void:
	if is_instance_valid(sheet_button):
		sheet_button.text = "Fechar ficha" if is_open else "Ver ficha"

func set_actions_collapsed(is_collapsed: bool) -> void:
	if is_instance_valid(actions_button):
		actions_button.text = "Ações +" if is_collapsed else "Ações −"
