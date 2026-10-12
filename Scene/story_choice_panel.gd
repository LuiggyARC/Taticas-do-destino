extends PopupPanel
class_name StoryChoicePanel


signal choice_selected(choice_id: String)


@export var panel_width: int = 720
@export var panel_bottom_margin: int = 18

var prompt_label: Label
var options_container: VBoxContainer

var previous_tree_paused_state: bool = false
var waiting_for_choice: bool = false


func _ready() -> void:
	if OS.has_feature("mobile"):
		panel_width = 900
	name = "StoryChoicePanel"
	
	process_mode = (
		Node.PROCESS_MODE_WHEN_PAUSED
	)
	
	exclusive = true
	transient = false
	unresizable = true
	borderless = true
	
	popup_hide.connect(
		on_choice_popup_hidden
	)
	
	create_interface()

func on_choice_popup_hidden() -> void:
	if not waiting_for_choice:
		return
	
	call_deferred(
		"restore_required_choice_popup"
	)


func restore_required_choice_popup() -> void:
	if not waiting_for_choice:
		return
	
	if visible:
		return
	
	var restored_width: int = max(
		panel_width,
		size.x
	)
	
	var restored_height: int = max(
		250,
		size.y
	)
	
	popup_centered(
		Vector2i(
			restored_width,
			restored_height
		)
	)
	
	await get_tree().process_frame
	
	position_panel_at_bottom()

func create_interface() -> void:
	var panel_style := StyleBoxFlat.new()

	panel_style.bg_color = Color(
		0.025,
		0.025,
		0.035,
		0.98
	)

	panel_style.border_color = Color(
		0.78,
		0.62,
		0.28,
		1.0
	)

	panel_style.set_border_width_all(3)

	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12

	add_theme_stylebox_override(
		"panel",
		panel_style
	)

	var margin_container := MarginContainer.new()
	margin_container.name = "MarginContainer"

	margin_container.add_theme_constant_override(
		"margin_left",
		24
	)

	margin_container.add_theme_constant_override(
		"margin_top",
		20
	)

	margin_container.add_theme_constant_override(
		"margin_right",
		24
	)

	margin_container.add_theme_constant_override(
		"margin_bottom",
		20
	)

	add_child(
		margin_container
	)

	margin_container.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	var main_container := VBoxContainer.new()
	main_container.name = "MainContainer"

	main_container.add_theme_constant_override(
		"separation",
		14
	)

	margin_container.add_child(
		main_container
	)

	prompt_label = Label.new()
	prompt_label.name = "PromptLabel"

	prompt_label.text = (
		"Escolha uma resposta"
	)

	prompt_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)

	prompt_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	prompt_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	prompt_label.custom_minimum_size = Vector2(
		0,
		68 if OS.has_feature("mobile") else 48
	)

	prompt_label.add_theme_font_size_override(
		"font_size",
		32 if OS.has_feature("mobile") else 21
	)

	prompt_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.90,
			0.62,
			1.0
		)
	)

	prompt_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)

	prompt_label.add_theme_constant_override(
		"outline_size",
		3
	)

	main_container.add_child(
		prompt_label
	)

	var separator := HSeparator.new()
	separator.name = "Separator"

	main_container.add_child(
		separator
	)

	options_container = VBoxContainer.new()
	options_container.name = "OptionsContainer"

	options_container.add_theme_constant_override(
		"separation",
		10
	)

	options_container.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	main_container.add_child(
		options_container
	)


func show_choices(
	prompt_text: String,
	options: Array
) -> String:
	if options.is_empty():
		return ""
	
	if waiting_for_choice:
		return ""
	
	waiting_for_choice = true
	
	var scene_tree: SceneTree = (
		get_tree()
	)
	
	previous_tree_paused_state = (
		scene_tree.paused
	)
	
	scene_tree.paused = true
	
	if prompt_text.strip_edges() == "":
		prompt_label.text = (
			"Escolha uma resposta"
		)
	else:
		prompt_label.text = prompt_text
	
	clear_option_buttons()
	
	for option_value in options:
		if not option_value is Dictionary:
			continue
		
		var option_data: Dictionary = (
			option_value
		)
		
		var choice_id: String = str(
			option_data.get(
				"id",
				""
			)
		).strip_edges()
		
		var button_text: String = str(
			option_data.get(
				"button_text",
				""
			)
		).strip_edges()
		
		if choice_id == "":
			continue
		
		if button_text == "":
			continue
		
		var choice_button: Button = (
			create_choice_button(
				choice_id,
				button_text
			)
		)
		
		options_container.add_child(
			choice_button
		)
	
	if (
		options_container.get_child_count()
		<= 0
	):
		waiting_for_choice = false
		
		scene_tree.paused = (
			previous_tree_paused_state
		)
		
		return ""
	
	var option_height: int = 96 if OS.has_feature("mobile") else 76
	var panel_height: int = clampi(
		150 + options_container.get_child_count() * option_height,
		300 if OS.has_feature("mobile") else 250,
		min(700, int(scene_tree.root.get_visible_rect().size.y) - 30) if OS.has_feature("mobile") else 520
	)
	
	popup_centered(
		Vector2i(
			min(panel_width, int(scene_tree.root.get_visible_rect().size.x) - 24),
			panel_height
		)
	)
	
	await scene_tree.process_frame
	
	position_panel_at_bottom()
	
	var selected_choice_value = await (
		choice_selected
	)
	
	var selected_choice_id: String = str(
		selected_choice_value
	)
	
	# Precisa ser alterado antes de hide().
	# Assim, o fechamento normal após a escolha
	# não reabre o painel.
	waiting_for_choice = false
	
	hide()
	
	scene_tree.paused = (
		previous_tree_paused_state
	)
	
	return selected_choice_id


func create_choice_button(
	choice_id: String,
	button_text: String
) -> Button:
	var button := Button.new()

	button.name = (
		"Choice_"
		+ choice_id
	)

	button.text = button_text

	button.custom_minimum_size = Vector2(
		0,
		84 if OS.has_feature("mobile") else 62
	)

	button.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	button.add_theme_font_size_override(
		"font_size",
		30 if OS.has_feature("mobile") else 18
	)

	button.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.96,
			0.84,
			1.0
		)
	)

	button.add_theme_color_override(
		"font_hover_color",
		Color.WHITE
	)

	button.add_theme_color_override(
		"font_pressed_color",
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

	var normal_style := create_button_style(
		Color(
			0.10,
			0.075,
			0.035,
			0.98
		),
		Color(
			0.70,
			0.52,
			0.20,
			1.0
		)
	)

	var hover_style := create_button_style(
		Color(
			0.18,
			0.12,
			0.045,
			1.0
		),
		Color(
			0.95,
			0.72,
			0.28,
			1.0
		)
	)

	var pressed_style := create_button_style(
		Color(
			0.24,
			0.15,
			0.05,
			1.0
		),
		Color(
			1.0,
			0.80,
			0.36,
			1.0
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

	button.pressed.connect(
		on_choice_button_pressed.bind(
			choice_id
		)
	)

	return button


func create_button_style(
	background_color: Color,
	border_color: Color
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = background_color
	style.border_color = border_color

	style.set_border_width_all(2)

	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8

	style.content_margin_left = 18
	style.content_margin_top = 10
	style.content_margin_right = 18
	style.content_margin_bottom = 10

	return style


func position_panel_at_bottom() -> void:
	var current_viewport: Viewport = get_viewport()

	if not is_instance_valid(current_viewport):
		return

	var viewport_size := Vector2i(
		current_viewport.get_visible_rect().size
	)

	position = Vector2i(
		max(
			0,
			int(
				(
					viewport_size.x
					- size.x
				) / 2
			)
		),
		max(
			0,
			viewport_size.y
			- size.y
			- panel_bottom_margin
		)
	)


func clear_option_buttons() -> void:
	if not is_instance_valid(options_container):
		return

	for child in options_container.get_children():
		child.queue_free()


func set_buttons_disabled(
	disabled_value: bool
) -> void:
	if not is_instance_valid(options_container):
		return

	for child in options_container.get_children():
		if child is Button:
			child.disabled = disabled_value


func on_choice_button_pressed(
	choice_id: String
) -> void:
	if not waiting_for_choice:
		return

	set_buttons_disabled(
		true
	)

	choice_selected.emit(
		choice_id
	)
