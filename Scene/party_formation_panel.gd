extends Control
class_name PartyFormationPanel

const TouchScrollSupport = preload("res://Scene/touch_scroll_support.gd")


signal panel_closed


var active_grid: GridContainer
var reserve_list: VBoxContainer
var member_count_label: Label
var member_sheet: PartyMemberSheet

func _ready() -> void:
	name = "PartyFormationPanel"
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	create_interface()
	refresh_formation()


func create_interface() -> void:
	var dark_background := ColorRect.new()
	dark_background.color = Color(
		0.0,
		0.0,
		0.0,
		0.72
	)
	
	dark_background.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
	dark_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(dark_background)
	
	var window := PanelContainer.new()
	window.name = "FormationWindow"
	
	window.anchor_left = 0.08
	window.anchor_top = 0.06
	window.anchor_right = 0.92
	window.anchor_bottom = 0.94
	
	var window_style := StyleBoxFlat.new()
	window_style.bg_color = Color(
		0.035,
		0.035,
		0.05,
		0.98
	)
	window_style.border_color = Color(
		0.78,
		0.62,
		0.28,
		1.0
	)
	window_style.set_border_width_all(3)
	window_style.corner_radius_top_left = 14
	window_style.corner_radius_top_right = 14
	window_style.corner_radius_bottom_left = 14
	window_style.corner_radius_bottom_right = 14
	window_style.content_margin_left = 24
	window_style.content_margin_top = 20
	window_style.content_margin_right = 24
	window_style.content_margin_bottom = 20
	
	window.add_theme_stylebox_override(
		"panel",
		window_style
	)
	
	add_child(window)
	
	var main_container := VBoxContainer.new()
	main_container.add_theme_constant_override(
		"separation",
		14
	)
	window.add_child(main_container)
	
	var header := HBoxContainer.new()
	main_container.add_child(header)
	
	var title := Label.new()
	title.text = "Formação do Grupo"
	title.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	title.add_theme_font_size_override(
		"font_size",
		26
	)
	title.add_theme_color_override(
		"font_color",
		Color(1.0, 0.86, 0.48, 1.0)
	)
	header.add_child(title)
	
	var close_button := Button.new()
	close_button.text = "Fechar"
	close_button.custom_minimum_size = Vector2(
		110,
		42
	)
	close_button.pressed.connect(
		close_panel
	)
	header.add_child(close_button)
	
	member_count_label = Label.new()
	member_count_label.add_theme_font_size_override(
		"font_size",
		17
	)
	main_container.add_child(member_count_label)
	
	var active_title := Label.new()
	active_title.text = "Grupo ativo"
	active_title.add_theme_font_size_override(
		"font_size",
		21
	)
	active_title.add_theme_color_override(
		"font_color",
		Color.WHITE
	)
	main_container.add_child(active_title)
	
	active_grid = GridContainer.new()
	active_grid.columns = 2
	active_grid.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	active_grid.add_theme_constant_override(
		"h_separation",
		12
	)
	active_grid.add_theme_constant_override(
		"v_separation",
		12
	)
	main_container.add_child(active_grid)
	
	var separator := HSeparator.new()
	main_container.add_child(separator)
	
	var reserve_title := Label.new()
	reserve_title.text = "Personagens disponíveis"
	reserve_title.add_theme_font_size_override(
		"font_size",
		21
	)
	main_container.add_child(reserve_title)
	
	var reserve_scroll := ScrollContainer.new()
	reserve_scroll.custom_minimum_size = Vector2(
		0,
		150
	)
	reserve_scroll.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	main_container.add_child(reserve_scroll)
	
	reserve_list = VBoxContainer.new()
	reserve_list.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	reserve_list.add_theme_constant_override(
		"separation",
		8
	)
	reserve_scroll.add_child(reserve_list)


func refresh_formation() -> void:
	if not is_instance_valid(active_grid):
		return
	
	for old_card in active_grid.get_children():
		old_card.queue_free()
	
	for old_row in reserve_list.get_children():
		old_row.queue_free()
	
	var active_members: Array[Dictionary] = (
		PartyManager.get_active_members()
	)
	
	member_count_label.text = (
		"Integrantes ativos: "
		+ str(active_members.size())
		+ " / "
		+ str(PartyManager.MAX_ACTIVE_MEMBERS)
	)
	
	for slot_index in range(
		PartyManager.MAX_ACTIVE_MEMBERS
	):
		if slot_index < active_members.size():
			create_active_member_card(
				active_members[slot_index]
			)
		else:
			create_empty_member_card(
				slot_index
			)
	
	var reserve_found: bool = false
	
	for member_data in PartyManager.get_all_members():
		var member_id: String = str(
			member_data.get("id", "")
		)
		
		if PartyManager.active_party.has(member_id):
			continue
		
		reserve_found = true
		create_reserve_member_row(
			member_data
		)
	
	if not reserve_found:
		var empty_reserve_label := Label.new()
		empty_reserve_label.text = (
			"Nenhum personagem disponível na reserva."
		)
		empty_reserve_label.horizontal_alignment = (
			HORIZONTAL_ALIGNMENT_CENTER
		)
		empty_reserve_label.add_theme_color_override(
			"font_color",
			Color(0.72, 0.72, 0.72, 1.0)
		)
		reserve_list.add_child(
			empty_reserve_label
		)
	TouchScrollSupport.enable(reserve_list.get_parent() as ScrollContainer)


func create_active_member_card(
	member_data: Dictionary
) -> void:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(
		300,
		165
	)
	card.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	card.add_theme_stylebox_override(
		"panel",
		create_card_style(
			Color(0.10, 0.11, 0.15, 0.98),
			Color(0.58, 0.48, 0.25, 1.0)
		)
	)
	
	active_grid.add_child(card)
	
	var card_content := VBoxContainer.new()
	card_content.add_theme_constant_override(
		"separation",
		5
	)
	card.add_child(card_content)
	
	var display_name: String = str(
		member_data.get(
			"display_name",
			"Sem nome"
		)
	)
	
	var member_name_label := Label.new()
	member_name_label.text = display_name
	member_name_label.add_theme_font_size_override(
		"font_size",
		20
	)
	member_name_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.86, 0.48, 1.0)
	)
	card_content.add_child(member_name_label)
	
	var character_class_name: String = str(
		member_data.get(
			"class_name",
			"Sem Classe"
		)
	)
	
	var member_level: int = int(
		member_data.get(
			"level",
			1
		)
	)
	
	var class_label := Label.new()
	class_label.text = (
		character_class_name
		+ " — Nível "
		+ str(member_level)
	)
	card_content.add_child(class_label)
	
	var current_hp: int = int(
		member_data.get(
			"current_hp",
			0
		)
	)
	
	var max_hp: int = int(
		member_data.get(
			"max_hp",
			0
		)
	)
	
	var hp_label := Label.new()
	hp_label.text = (
		"PV: "
		+ str(current_hp)
		+ " / "
		+ str(max_hp)
	)
	card_content.add_child(hp_label)
	
	var member_id: String = str(
		member_data.get(
			"id",
			""
		)
	)
	
	var action_buttons := HBoxContainer.new()
	action_buttons.add_theme_constant_override(
		"separation",
		8
	)
	card_content.add_child(action_buttons)
	
	var sheet_button := Button.new()
	sheet_button.text = "Ficha"
	sheet_button.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	sheet_button.pressed.connect(
		open_member_sheet.bind(
			member_id
		)
	)
	action_buttons.add_child(sheet_button)
	
	if member_id != PartyManager.HERO_MEMBER_ID:
		var remove_button := Button.new()
		remove_button.text = "Reserva"
		remove_button.size_flags_horizontal = (
			Control.SIZE_EXPAND_FILL
		)
		remove_button.pressed.connect(
			remove_from_active_party.bind(
				member_id
			)
		)
		action_buttons.add_child(remove_button)


func create_empty_member_card(
	slot_index: int
) -> void:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(
		300,
		125
	)
	card.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	card.add_theme_stylebox_override(
		"panel",
		create_card_style(
			Color(0.055, 0.055, 0.07, 0.90),
			Color(0.28, 0.28, 0.32, 1.0)
		)
	)
	
	active_grid.add_child(card)
	
	var empty_label := Label.new()
	empty_label.text = (
		"Espaço "
		+ str(slot_index + 1)
		+ "\nVazio"
	)
	empty_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	empty_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	empty_label.add_theme_font_size_override(
		"font_size",
		18
	)
	empty_label.add_theme_color_override(
		"font_color",
		Color(0.55, 0.55, 0.60, 1.0)
	)
	card.add_child(empty_label)


func create_reserve_member_row(
	member_data: Dictionary
) -> void:
	var row := PanelContainer.new()
	row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	row.add_theme_stylebox_override(
		"panel",
		create_card_style(
			Color(0.075, 0.075, 0.10, 0.96),
			Color(0.30, 0.30, 0.38, 1.0)
		)
	)
	
	reserve_list.add_child(row)
	
	var row_content := HBoxContainer.new()
	row_content.add_theme_constant_override(
		"separation",
		12
	)
	row.add_child(row_content)
	
	var member_description := Label.new()
	member_description.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	member_description.text = (
		str(
			member_data.get(
				"display_name",
				"Sem nome"
			)
		)
		+ " — "
		+ str(
			member_data.get(
				"class_name",
				"Sem Classe"
			)
		)
		+ " — Nível "
		+ str(
			member_data.get(
				"level",
				1
			)
		)
	)
	
	row_content.add_child(
		member_description
	)
	
	var member_id: String = str(
		member_data.get(
			"id",
			""
		)
	)
	
	var sheet_button := Button.new()
	sheet_button.text = "Ficha"
	sheet_button.pressed.connect(
		open_member_sheet.bind(
			member_id
		)
	)
	row_content.add_child(sheet_button)
	
	var add_button := Button.new()
	add_button.text = "Adicionar"
	
	add_button.disabled = (
		PartyManager.active_party.size()
		>= PartyManager.MAX_ACTIVE_MEMBERS
	)
	
	add_button.pressed.connect(
		add_to_active_party.bind(
			member_id
		)
	)
	
	row_content.add_child(add_button)


func create_card_style(
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
	style.content_margin_left = 12
	style.content_margin_top = 10
	style.content_margin_right = 12
	style.content_margin_bottom = 10
	
	return style


func add_to_active_party(
	member_id: String
) -> void:
	var member_was_added: bool = (
		PartyManager.add_member_to_active_party(
			member_id
		)
	)
	
	if member_was_added:
		SaveManager.save_village_state()
	
	refresh_formation()


func remove_from_active_party(
	member_id: String
) -> void:
	PartyManager.remove_member_from_active_party(
		member_id
	)
	
	refresh_formation()


func open_panel() -> void:
	visible = true
	refresh_formation()


func close_panel() -> void:
	visible = false
	panel_closed.emit()
func open_member_sheet(
	member_id: String
) -> void:
	if not is_instance_valid(member_sheet):
		member_sheet = PartyMemberSheet.new()
		add_child(member_sheet)
	
	member_sheet.open_member(
		member_id
	)
