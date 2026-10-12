extends Node

var panel: PanelContainer
var combat_info_label: Label

var class_skill_button: Button
var items_button: Button
var magic_button: Button
var end_turn_button: Button
var save_button: Button
var abandon_button: Button
var tutorial_button: Button

var ui_parent: CanvasLayer
var button_callbacks: Dictionary = {}
var button_sfx_callback: Callable
var cancel_spell_button: Button
var end_turn_container: HBoxContainer
var gear_button: Button
var secondary_menu: PopupPanel
var actions_collapsed: bool = false
var gameplay_visible: bool = true

func setup(
	new_ui_parent: CanvasLayer,
	new_button_callbacks: Dictionary,
	new_button_sfx_callback: Callable = Callable()
) -> void:
	if not is_instance_valid(new_ui_parent):
		return
	
	ui_parent = new_ui_parent
	button_callbacks = new_button_callbacks
	button_sfx_callback = new_button_sfx_callback
	
	var old_panel := ui_parent.get_node_or_null(
		"ActionPanel"
	)
	
	if is_instance_valid(old_panel):
		old_panel.queue_free()
	
	panel = null
	actions_collapsed = false
	gameplay_visible = true
	end_turn_container = null
	gear_button = null
	secondary_menu = null
	combat_info_label = null
	class_skill_button = null
	items_button = null
	magic_button = null
	end_turn_button = null
	save_button = null
	abandon_button = null
	tutorial_button = null
	
	create_panel()

func get_action_button_colors(
	button_name: String
) -> Dictionary:
	match button_name:
		"ClassSkillButton":
			return {
				"background": Color(
					0.14,
					0.22,
					0.12,
					0.96
				),
				"border": Color(
					0.55,
					0.78,
					0.34,
					1.0
				)
			}
		
		"MagicButton":
			return {
				"background": Color(
					0.18,
					0.10,
					0.28,
					0.96
				),
				"border": Color(
					0.66,
					0.42,
					0.90,
					1.0
				)
			}
		"ItemsButton":
			return {
				"background": Color(0.12, 0.21, 0.19, 0.96),
				"border": Color(0.38, 0.78, 0.67)
			}
		
		"EndTurnButton":
			return {
				"background": Color(
					0.25,
					0.17,
					0.055,
					0.96
				),
				"border": Color(
					0.88,
					0.66,
					0.24,
					1.0
				)
			}
		
		"SaveButton":
			return {
				"background": Color(
					0.075,
					0.18,
					0.25,
					0.96
				),
				"border": Color(
					0.30,
					0.68,
					0.88,
					1.0
				)
			}
		
		"AbandonButton":
			return {
				"background": Color(
					0.27,
					0.065,
					0.055,
					0.96
				),
				"border": Color(
					0.88,
					0.28,
					0.20,
					1.0
				)
			}
		
		_:
			return {
				"background": Color(
					0.10,
					0.11,
					0.12,
					0.96
				),
				"border": Color(
					0.62,
					0.50,
					0.25,
					1.0
				)
			}

func create_action_button_style(
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
	button_style.content_margin_top = 7
	button_style.content_margin_bottom = 7
	
	return button_style

func create_panel() -> void:
	if not is_instance_valid(ui_parent):
		return
	
	panel = PanelContainer.new()
	panel.name = "ActionPanel"
	panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	panel.offset_left = 400
	panel.offset_top = -140 if OS.has_feature("mobile") else -120
	panel.offset_bottom = -16
	
	var panel_style := StyleBoxFlat.new()
	
	panel_style.bg_color = Color(
		0.015,
		0.02,
		0.025,
		0.94
	)
	
	panel_style.border_color = Color(
		0.72,
		0.55,
		0.22,
		0.95
	)
	
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(12)
	
	panel_style.content_margin_left = 14
	panel_style.content_margin_top = 10
	panel_style.content_margin_right = 14
	panel_style.content_margin_bottom = 12
	
	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	ui_parent.add_child(panel)
	
	var main_box := VBoxContainer.new()
	main_box.name = "ActionPanelBox"
	main_box.add_theme_constant_override(
		"separation",
		7
	)
	
	panel.add_child(main_box)
	
	combat_info_label = Label.new()
	combat_info_label.name = "CombatInfoLabel"
	combat_info_label.text = "Ações do turno"
	
	combat_info_label.custom_minimum_size = Vector2(400, 28)
	
	combat_info_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	combat_info_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	combat_info_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	combat_info_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	
	combat_info_label.add_theme_font_size_override(
		"font_size",
		17
	)
	
	combat_info_label.add_theme_color_override(
		"font_color",
		Color(
			0.96,
			0.85,
			0.58,
			1.0
		)
	)
	
	combat_info_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	combat_info_label.add_theme_constant_override(
		"outline_size",
		3
	)
	
	main_box.add_child(combat_info_label)
	
	var separator := HSeparator.new()
	separator.modulate = Color(
		0.72,
		0.55,
		0.22,
		0.70
	)
	
	main_box.add_child(separator)
	
	var buttons_row := HBoxContainer.new()
	buttons_row.name = "ActionButtonsRow"
	buttons_row.alignment = BoxContainer.ALIGNMENT_CENTER
	
	buttons_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	buttons_row.add_theme_constant_override(
		"separation",
		9
	)
	
	main_box.add_child(buttons_row)
	
	class_skill_button = create_button(
		buttons_row,
		"ClassSkillButton",
		"",
		150,
		get_button_callback(
			"class_skill"
		)
	)

	items_button = create_button(
		buttons_row,
		"ItemsButton",
		"Itens",
		95,
		get_button_callback("items")
	)
	
	magic_button = create_button(
		buttons_row,
		"MagicButton",
		"Magias",
		110,
		get_button_callback(
			"magic"
		)
	)
	
	create_secondary_controls()
	update_panel_layout()
	if not get_viewport().size_changed.is_connected(update_panel_layout):
		get_viewport().size_changed.connect(update_panel_layout)

func create_secondary_controls() -> void:
	end_turn_container = HBoxContainer.new()
	end_turn_container.name = "EndTurnContainer"
	end_turn_container.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	end_turn_container.offset_top = -78
	end_turn_container.offset_bottom = -16
	ui_parent.add_child(end_turn_container)
	end_turn_button = create_button(end_turn_container, "EndTurnButton", "Terminar Turno", 200, get_button_callback("end_turn"))
	end_turn_button.add_theme_font_size_override("font_size", 20)

	gear_button = Button.new()
	gear_button.name = "BattleMenuButton"
	gear_button.text = "⚙"
	gear_button.tooltip_text = "Opções da batalha"
	gear_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	gear_button.offset_left = -66
	gear_button.offset_right = -14
	gear_button.offset_top = 12
	gear_button.offset_bottom = 64
	gear_button.add_theme_font_size_override("font_size", 30)
	gear_button.add_theme_stylebox_override("normal", create_action_button_style(Color(0.04, 0.05, 0.06, 0.95), Color(0.75, 0.60, 0.30)))
	gear_button.pressed.connect(toggle_secondary_menu)
	ui_parent.add_child(gear_button)
	if button_sfx_callback.is_valid():
		button_sfx_callback.call(gear_button)

	secondary_menu = PopupPanel.new()
	secondary_menu.name = "BattleSecondaryMenu"
	var menu_style := StyleBoxFlat.new()
	menu_style.bg_color = Color(0.02, 0.025, 0.03, 0.98)
	menu_style.border_color = Color(0.74, 0.58, 0.28)
	menu_style.set_border_width_all(2)
	menu_style.set_corner_radius_all(9)
	menu_style.set_content_margin_all(10)
	secondary_menu.add_theme_stylebox_override("panel", menu_style)
	ui_parent.add_child(secondary_menu)
	var menu_items := VBoxContainer.new()
	menu_items.custom_minimum_size.x = 200
	menu_items.add_theme_constant_override("separation", 6)
	secondary_menu.add_child(menu_items)
	save_button = create_button(menu_items, "SaveButton", "Salvar", 190, get_button_callback("save"))
	abandon_button = create_button(menu_items, "AbandonButton", "Abandonar jogo", 190, get_button_callback("abandon"))
	tutorial_button = create_button(menu_items, "TutorialButton", "Ajuda", 190, get_button_callback("tutorial"))
	tutorial_button.tooltip_text = "Rever o tutorial de combate no primeiro cenário"
	for menu_button in [save_button, abandon_button, tutorial_button]:
		menu_button.pressed.connect(secondary_menu.hide)

func toggle_secondary_menu() -> void:
	if not is_instance_valid(secondary_menu):
		return
	if secondary_menu.visible:
		secondary_menu.hide()
		return
	var screen_width: int = int(get_viewport().get_visible_rect().size.x)
	var menu_height: int = 180 if is_instance_valid(tutorial_button) and tutorial_button.visible else 125
	secondary_menu.popup(Rect2i(screen_width - 228, 66, 214, menu_height))

func update_panel_layout() -> void:
	if not is_instance_valid(panel):
		return
	var screen_width: float = get_viewport().get_visible_rect().size.x
	var panel_left: float = maxf(16.0, screen_width * 0.28)
	var panel_right: float = screen_width - 235.0
	var end_width: float = 210.0
	if screen_width >= 1380.0:
		panel_left = screen_width * 0.285
		panel_right = screen_width - 330.0
		end_width = 300.0
	panel.offset_left = panel_left
	panel.offset_right = panel_right
	if is_instance_valid(end_turn_container):
		end_turn_container.offset_left = -end_width - 14.0
		end_turn_container.offset_right = -14.0


func get_button_callback(
	callback_name: String
) -> Callable:
	var callback_value: Variant = button_callbacks.get(
		callback_name,
		Callable()
	)
	
	if callback_value is Callable:
		return callback_value
	
	return Callable()


func create_button(
	parent: Control,
	button_name: String,
	button_text: String,
	minimum_width: float,
	pressed_callback: Callable
) -> Button:
	var button := Button.new()
	
	button.name = button_name
	button.text = button_text
	
	button.custom_minimum_size = Vector2(
		minimum_width,
		62 if OS.has_feature("mobile") else 46
	)
	
	button.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	button.focus_mode = (
		Control.FOCUS_ALL
	)
	
	var button_colors: Dictionary = (
		get_action_button_colors(
			button_name
		)
	)
	
	var background_color: Color = (
		button_colors.get(
			"background",
			Color(
				0.10,
				0.11,
				0.12,
				0.96
			)
		)
	)
	
	var border_color: Color = (
		button_colors.get(
			"border",
			Color(
				0.62,
				0.50,
				0.25,
				1.0
			)
		)
	)
	
	var normal_style: StyleBoxFlat = (
		create_action_button_style(
			background_color,
			border_color
		)
	)
	
	var hover_style: StyleBoxFlat = (
		create_action_button_style(
			background_color.lightened(
				0.12
			),
			border_color.lightened(
				0.12
			)
		)
	)
	
	var pressed_style: StyleBoxFlat = (
		create_action_button_style(
			background_color.darkened(
				0.10
			),
			border_color
		)
	)
	
	var disabled_style: StyleBoxFlat = (
		create_action_button_style(
			Color(
				0.055,
				0.06,
				0.065,
				0.75
			),
			Color(
				0.28,
				0.28,
				0.28,
				0.65
			)
		)
	)
	
	var focus_style: StyleBoxFlat = (
		create_action_button_style(
			background_color.lightened(
				0.06
			),
			Color.WHITE
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
		"disabled",
		disabled_style
	)
	
	button.add_theme_stylebox_override(
		"focus",
		focus_style
	)
	
	button.add_theme_font_size_override(
		"font_size",
		21 if OS.has_feature("mobile") else 16
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
		"font_pressed_color",
		Color(
			1.0,
			0.94,
			0.75,
			1.0
		)
	)
	
	button.add_theme_color_override(
		"font_disabled_color",
		Color(
			0.48,
			0.48,
			0.48,
			1.0
		)
	)
	
	button.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	button.add_theme_constant_override(
		"outline_size",
		2
	)
	
	if pressed_callback.is_valid():
		button.pressed.connect(
			pressed_callback
		)
	
	parent.add_child(button)
	
	if button_sfx_callback.is_valid():
		button_sfx_callback.call(
			button
		)
	
	return button

func set_cancel_spell_visible(
	should_be_visible: bool
) -> void:
	if not is_instance_valid(cancel_spell_button):
		return
	
	cancel_spell_button.visible = should_be_visible

func create_cancel_spell_control(
	new_ui_parent: CanvasLayer,
	pressed_callback: Callable,
	sfx_callback: Callable = Callable()
) -> Button:
	if not is_instance_valid(new_ui_parent):
		return null
	
	var old_button := new_ui_parent.get_node_or_null(
		"CancelSpellButton"
	)
	
	if is_instance_valid(old_button):
		old_button.queue_free()
	
	cancel_spell_button = Button.new()
	cancel_spell_button.name = "CancelSpellButton"
	cancel_spell_button.text = "Cancelar Magia"
	cancel_spell_button.visible = false
	
	cancel_spell_button.custom_minimum_size = Vector2(
		240 if OS.has_feature("mobile") else 180,
		70 if OS.has_feature("mobile") else 44
	)
	cancel_spell_button.add_theme_font_size_override(
		"font_size",
		26 if OS.has_feature("mobile") else 16
	)
	
	cancel_spell_button.set_anchors_preset(
		Control.PRESET_BOTTOM_RIGHT
	)
	
	cancel_spell_button.offset_left = -270 if OS.has_feature("mobile") else -210
	cancel_spell_button.offset_right = -20
	cancel_spell_button.offset_top = -235 if OS.has_feature("mobile") else -185
	cancel_spell_button.offset_bottom = -165 if OS.has_feature("mobile") else -135
	
	if pressed_callback.is_valid():
		cancel_spell_button.pressed.connect(
			pressed_callback
		)
	
	new_ui_parent.add_child(
		cancel_spell_button
	)
	
	if sfx_callback.is_valid():
		sfx_callback.call(
			cancel_spell_button
		)
	
	return cancel_spell_button


func configure_control_buttons(
	end_turn_disabled: bool,
	save_disabled: bool,
	abandon_disabled: bool
) -> void:
	if is_instance_valid(end_turn_button):
		end_turn_button.disabled = (
			end_turn_disabled
		)
	if is_instance_valid(items_button):
		items_button.disabled = end_turn_disabled
	
	if is_instance_valid(save_button):
		save_button.disabled = save_disabled
	
	if is_instance_valid(abandon_button):
		abandon_button.disabled = (
			abandon_disabled
		)

func set_tutorial_button_visible(should_be_visible: bool) -> void:
	if is_instance_valid(tutorial_button):
		tutorial_button.visible = should_be_visible

func configure_class_skill_button(
	should_be_visible: bool,
	should_be_disabled: bool,
	button_text: String
) -> void:
	if not is_instance_valid(class_skill_button):
		return
	
	class_skill_button.visible = should_be_visible
	class_skill_button.disabled = should_be_disabled
	class_skill_button.text = button_text

func configure_magic_button(
	should_be_visible: bool,
	should_be_disabled: bool,
	button_text: String
) -> void:
	if not is_instance_valid(magic_button):
		return
	
	magic_button.visible = should_be_visible
	magic_button.disabled = should_be_disabled
	magic_button.text = button_text

func set_combat_info_text(
	new_text: String
) -> void:
	if not is_instance_valid(combat_info_label):
		return
	
	combat_info_label.text = new_text

func set_turn_resources(movement_current: float, movement_max: float, action_available: bool) -> void:
	if not is_instance_valid(combat_info_label):
		return
	var action_text: String = "livre" if action_available else "usada"
	combat_info_label.text = "◆ Ação principal: %s    ◇ Mov: %.1f/%.1f m" % [action_text, movement_current, movement_max]

func set_panel_visible(
	should_be_visible: bool
) -> void:
	if not is_instance_valid(panel):
		return
	gameplay_visible = should_be_visible
	panel.visible = should_be_visible and not actions_collapsed
	if is_instance_valid(end_turn_container):
		end_turn_container.visible = should_be_visible
	if is_instance_valid(gear_button):
		gear_button.visible = should_be_visible
	if not should_be_visible and is_instance_valid(secondary_menu):
		secondary_menu.hide()

func toggle_actions_collapsed() -> bool:
	actions_collapsed = not actions_collapsed
	if is_instance_valid(panel):
		panel.visible = gameplay_visible and not actions_collapsed
	return actions_collapsed


func is_panel_visible() -> bool:
	if not is_instance_valid(panel):
		return false
	return gameplay_visible
