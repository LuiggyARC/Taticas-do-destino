extends Node

var status_label: Label
var ui_parent: CanvasLayer
var order_panel: PanelContainer
var order_scroll: ScrollContainer
var order_row: HBoxContainer

func setup(
	new_ui_parent: CanvasLayer
) -> void:
	if not is_instance_valid(new_ui_parent):
		return
	
	ui_parent = new_ui_parent
	
	if is_instance_valid(status_label):
		if status_label.get_parent() == ui_parent:
			return
		
		status_label.queue_free()
		status_label = null
	
	create_status_label()


func create_status_label() -> void:
	if not is_instance_valid(ui_parent):
		return
	
	var old_label := ui_parent.get_node_or_null(
		"TurnCounterLabel"
	)
	if is_instance_valid(old_label):
		old_label.queue_free()
	
	var old_order := ui_parent.get_node_or_null(
		"InitiativeOrderPanel"
	)
	if is_instance_valid(old_order):
		old_order.queue_free()
	
	status_label = Label.new()
	status_label.name = "TurnCounterLabel"
	status_label.text = (
		"Preparação do combate - Role a iniciativa"
	)
	status_label.set_anchors_preset(
		Control.PRESET_TOP_WIDE
	)
	status_label.offset_left = 0
	status_label.offset_right = 0
	status_label.offset_top = 8
	status_label.offset_bottom = 58 if OS.has_feature("mobile") else 48
	status_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	status_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	status_label.add_theme_font_size_override(
		"font_size",
		32 if OS.has_feature("mobile") else 24
	)
	status_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.92, 0.65)
	)
	status_label.add_theme_color_override(
		"font_outline_color",
		Color(0.05, 0.03, 0.01)
	)
	status_label.add_theme_constant_override(
		"outline_size",
		5
	)
	ui_parent.add_child(status_label)
	
	order_panel = PanelContainer.new()
	order_panel.name = "InitiativeOrderPanel"
	ui_parent.add_child(order_panel)
	order_panel.set_anchors_preset(
		Control.PRESET_TOP_WIDE
	)
	order_panel.offset_left = 390
	order_panel.offset_right = -270
	order_panel.offset_top = 42
	order_panel.offset_bottom = 140
	order_panel.visible = false
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.02, 0.025, 0.03, 0.38)
	panel_style.border_color = Color(0.55, 0.43, 0.22, 0.30)
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(7)
	panel_style.set_content_margin_all(4)
	order_panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	order_scroll = ScrollContainer.new()
	order_scroll.horizontal_scroll_mode = (
		ScrollContainer.SCROLL_MODE_AUTO
	)
	order_scroll.vertical_scroll_mode = (
		ScrollContainer.SCROLL_MODE_DISABLED
	)
	order_panel.add_child(order_scroll)
	
	order_row = HBoxContainer.new()
	order_row.add_theme_constant_override(
		"separation",
		6
	)
	order_scroll.add_child(order_row)
	get_viewport().size_changed.connect(update_order_clearance)
	update_order_clearance()


func update_display(
	initiative_started: bool,
	battle_turn_count: int,
	unit_name: String
) -> void:
	if not is_instance_valid(status_label):
		return
	
	if not initiative_started:
		status_label.text = (
			"Preparação do combate"
			+ " - Role a iniciativa"
		)
		return
	
	var safe_unit_name: String = unit_name
	
	if safe_unit_name == "":
		safe_unit_name = "Nenhuma unidade"
	
	status_label.text = (
		"Rodada "
		+ str(battle_turn_count)
		+ " - Turno: "
		+ safe_unit_name
	)


func clear() -> void:
	if is_instance_valid(status_label):
		status_label.text = ""
	
	if is_instance_valid(order_panel):
		order_panel.visible = false


func get_label() -> Label:
	return status_label
func update_order(
	unit_names: Array[String],
	active_index: int,
	portraits: Array = [],
	enemy_flags: Array[bool] = []
) -> void:
	if not is_instance_valid(order_panel):
		return
	
	if not is_instance_valid(order_row):
		return
	
	update_order_clearance()
	
	for child in order_row.get_children():
		order_row.remove_child(child)
		child.queue_free()
	
	order_panel.visible = not unit_names.is_empty()
	
	if unit_names.is_empty():
		return
	
	for index in range(unit_names.size()):
		var is_active: bool = (
			index == active_index
		)
		
		var slot := PanelContainer.new()
		slot.custom_minimum_size.x = 82
		var slot_style := StyleBoxFlat.new()
		var is_enemy: bool = index < enemy_flags.size() and enemy_flags[index]
		if is_active:
			slot_style.bg_color = Color(0.24, 0.20, 0.08, 0.92)
			slot_style.border_color = Color(1.0, 0.79, 0.35)
		else:
			slot_style.bg_color = Color(0.06, 0.07, 0.08, 0.74)
			slot_style.border_color = Color(0.80, 0.25, 0.21) if is_enemy else Color(0.31, 0.66, 0.64)
		
		slot_style.set_border_width_all(2)
		slot_style.set_corner_radius_all(9)
		slot_style.set_content_margin_all(3)
		slot.add_theme_stylebox_override(
			"panel",
			slot_style
		)
		var slot_box := VBoxContainer.new()
		slot_box.add_theme_constant_override("separation", 1)
		slot.add_child(slot_box)
		var portrait_frame := PanelContainer.new()
		portrait_frame.custom_minimum_size = Vector2(66, 62)
		var portrait_style := StyleBoxFlat.new()
		portrait_style.bg_color = Color(0.09, 0.12, 0.12)
		portrait_style.border_color = slot_style.border_color
		portrait_style.set_border_width_all(2)
		portrait_style.set_corner_radius_all(32)
		portrait_style.set_content_margin_all(3)
		portrait_frame.add_theme_stylebox_override("panel", portrait_style)
		slot_box.add_child(portrait_frame)
		var portrait_texture: Texture2D = portraits[index] as Texture2D if index < portraits.size() else null
		if portrait_texture != null:
			var image := TextureRect.new()
			image.texture = portrait_texture
			image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			portrait_frame.add_child(image)
		else:
			var fallback := Label.new()
			fallback.text = unit_names[index].substr(0, 1).to_upper()
			fallback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			fallback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			fallback.add_theme_font_size_override("font_size", 27)
			portrait_frame.add_child(fallback)
		var name_label := Label.new()
		name_label.text = unit_names[index]
		name_label.tooltip_text = unit_names[index]
		name_label.custom_minimum_size.x = 70
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override(
			"font_size",
			15 if OS.has_feature("mobile") else 12
		)
		name_label.add_theme_color_override(
			"font_color",
			Color(1.0, 0.96, 0.84)
		)
		
		slot_box.add_child(name_label)
		order_row.add_child(slot)
		
		if is_active and is_instance_valid(
			order_scroll
		):
			order_scroll.call_deferred(
				"ensure_control_visible",
				slot
			)
func update_order_clearance() -> void:
	if not is_instance_valid(order_panel):
		return
	
	if not is_instance_valid(ui_parent):
		return
	
	var screen_width: float = get_viewport().get_visible_rect().size.x
	order_panel.offset_left = maxf(380.0, screen_width * 0.25)
	order_panel.offset_right = -270.0
	if is_instance_valid(status_label):
		status_label.offset_left = order_panel.offset_left
		status_label.offset_right = order_panel.offset_right
