extends Control
class_name PartyMemberSheet


signal panel_closed


var details_label: RichTextLabel
var current_member_id: String = ""
var inventory_panel: SharedInventoryPanel

func _ready() -> void:
	name = "PartyMemberSheet"
	z_index = 200
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	create_interface()
	visible = false


func create_interface() -> void:
	var dark_background := ColorRect.new()
	dark_background.color = Color(
		0.0,
		0.0,
		0.0,
		0.78
	)
	dark_background.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	dark_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	add_child(dark_background)
	
	var window := PanelContainer.new()
	window.anchor_left = 0.05
	window.anchor_top = 0.05
	window.anchor_right = 0.95
	window.anchor_bottom = 0.95
	
	var window_style := StyleBoxFlat.new()
	window_style.bg_color = Color(
		0.03,
		0.03,
		0.045,
		0.99
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
	title.text = "Ficha do Personagem"
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
	
	var separator := HSeparator.new()
	main_container.add_child(separator)
	
	var content_container := HBoxContainer.new()
	content_container.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	content_container.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	content_container.add_theme_constant_override(
		"separation",
		18
	)
	main_container.add_child(
		content_container
	)
	
	var character_panel := PanelContainer.new()
	character_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	character_panel.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	character_panel.size_flags_stretch_ratio = 1.25
	
	var character_style := StyleBoxFlat.new()
	character_style.bg_color = Color(
		0.045,
		0.045,
		0.065,
		0.92
	)
	character_style.border_color = Color(
		0.22,
		0.22,
		0.28,
		1.0
	)
	character_style.set_border_width_all(1)
	character_style.corner_radius_top_left = 8
	character_style.corner_radius_top_right = 8
	character_style.corner_radius_bottom_left = 8
	character_style.corner_radius_bottom_right = 8
	character_style.content_margin_left = 16
	character_style.content_margin_top = 14
	character_style.content_margin_right = 16
	character_style.content_margin_bottom = 14
	
	character_panel.add_theme_stylebox_override(
		"panel",
		character_style
	)
	content_container.add_child(
		character_panel
	)
	
	details_label = RichTextLabel.new()
	details_label.bbcode_enabled = true
	details_label.fit_content = false
	details_label.scroll_active = true
	details_label.selection_enabled = true
	
	details_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	details_label.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	
	details_label.add_theme_font_size_override(
		"normal_font_size",
		18
	)
	
	character_panel.add_child(
		details_label
	)
	
	var vertical_separator := VSeparator.new()
	content_container.add_child(
		vertical_separator
	)
	
	var inventory_wrapper := PanelContainer.new()
	inventory_wrapper.custom_minimum_size = Vector2(
		390,
		0
	)
	inventory_wrapper.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	inventory_wrapper.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	inventory_wrapper.size_flags_stretch_ratio = 0.85
	
	var inventory_style := StyleBoxFlat.new()
	inventory_style.bg_color = Color(
		0.045,
		0.045,
		0.065,
		0.92
	)
	inventory_style.border_color = Color(
		0.22,
		0.22,
		0.28,
		1.0
	)
	inventory_style.set_border_width_all(1)
	inventory_style.corner_radius_top_left = 8
	inventory_style.corner_radius_top_right = 8
	inventory_style.corner_radius_bottom_left = 8
	inventory_style.corner_radius_bottom_right = 8
	inventory_style.content_margin_left = 14
	inventory_style.content_margin_top = 14
	inventory_style.content_margin_right = 14
	inventory_style.content_margin_bottom = 14
	
	inventory_wrapper.add_theme_stylebox_override(
		"panel",
		inventory_style
	)
	content_container.add_child(
		inventory_wrapper
	)
	
	inventory_panel = SharedInventoryPanel.new()
	inventory_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	inventory_panel.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	inventory_panel.equipment_changed.connect(
		on_inventory_equipment_changed
	)
	
	inventory_wrapper.add_child(
		inventory_panel
	)


func open_member(
	member_id: String
) -> void:
	var member_data: Dictionary = (
		PartyManager.get_member(
			member_id
		)
	)
	
	if member_data.is_empty():
		push_warning(
			"Integrante não encontrado: "
			+ member_id
		)
		
		return
	
	current_member_id = member_id
	
	update_member_details(
		member_data
	)
	
	if is_instance_valid(inventory_panel):
		inventory_panel.set_current_member(
			current_member_id
		)
	
	visible = true

func update_member_details(
	member_data: Dictionary
) -> void:
	if not is_instance_valid(details_label):
		return
	
	var display_name: String = str(
		member_data.get(
			"display_name",
			"Sem nome"
		)
	)
	
	var character_class: String = str(
		member_data.get(
			"class_name",
			"Sem Classe"
		)
	)
	
	var race_name: String = str(
		member_data.get(
			"race_name",
			"Humano"
		)
	)
	
	var level: int = int(
		member_data.get("level", 1)
	)
	
	var total_xp: int = int(
		member_data.get("total_xp", 0)
	)
	
	var xp_to_next_level: int = int(
		member_data.get(
			"xp_to_next_level",
			1000
		)
	)
	var level_start_xp: int = PartyManager.get_total_xp_required_for_member_level(level)
	var xp_in_current_level: int = maxi(0, total_xp - level_start_xp)
	
	var current_hp: int = int(
		member_data.get("current_hp", 0)
	)
	
	var max_hp: int = int(
		member_data.get("max_hp", 0)
	)
	
	var attributes: Dictionary = (
		member_data.get(
			"attributes",
			{}
		)
	)
	
	var equipment: Dictionary = (
		member_data.get(
			"equipment",
			{}
		)
	)
	
	var combat_stats: Dictionary = (
		member_data.get(
			"combat_stats",
			{}
		)
	)
	
	var feats: Array = member_data.get(
		"feats",
		[]
	)
	
	var feat_text: String = "Nenhum"
	
	if not feats.is_empty():
		var feat_names: PackedStringArray = []
		
		for feat_name in feats:
			feat_names.append(
				str(feat_name)
			)
		
		feat_text = ", ".join(feat_names)
	
	var details_text: String = ""
	
	details_text += (
		"[font_size=28][color=#f4d67d]"
		+ display_name
		+ "[/color][/font_size]\n"
	)
	
	details_text += (
		race_name
		+ " — "
		+ character_class
		+ " — Nível "
		+ str(level)
		+ "\n\n"
	)
	
	details_text += (
		"[font_size=21][b]Progressão[/b][/font_size]\n"
	)
	
	details_text += (
		"PV: "
		+ str(current_hp)
		+ " / "
		+ str(max_hp)
		+ "\n"
	)
	
	details_text += (
		"Experiência neste nível: "
		+ str(xp_in_current_level)
		+ " / "
		+ str(xp_to_next_level)
		+ " (total: " + str(total_xp) + ")"
		+ "\n\n"
	)
	
	details_text += (
		"[font_size=21][b]Atributos[/b][/font_size]\n"
	)
	
	details_text += (
		"Força: "
		+ str(attributes.get("strength", 10))
		+ "     Destreza: "
		+ str(attributes.get("dexterity", 10))
		+ "\n"
	)
	
	details_text += (
		"Constituição: "
		+ str(attributes.get("constitution", 10))
		+ "     Sabedoria: "
		+ str(attributes.get("wisdom", 10))
		+ "\n"
	)
	
	details_text += (
		"Inteligência: "
		+ str(attributes.get("intelligence", 10))
		+ "     Carisma: "
		+ str(attributes.get("charisma", 10))
		+ "\n\n"
	)
	
	details_text += (
		"[font_size=21][b]Equipamentos[/b][/font_size]\n"
	)
	
	details_text += (
		"Arma: "
		+ str(equipment.get("weapon", "Nenhum"))
		+ "\n"
	)
	
	details_text += (
		"Armadura: "
		+ str(equipment.get("armor", "Nenhum"))
		+ "\n"
	)
	
	details_text += (
		"Escudo: "
		+ str(equipment.get("shield", "Nenhum"))
		+ "\n"
	)
	
	details_text += (
		"Acessório: "
		+ str(equipment.get("accessory", "Nenhum"))
		+ "\n\n"
	)
	
	details_text += (
		"[font_size=21][b]Combate[/b][/font_size]\n"
	)
	
	details_text += (
		"Classe de Armadura: "
		+ str(combat_stats.get("armor_class", "-"))
		+ "\n"
	)
	
	details_text += (
		"Bônus Base de Ataque: "
		+ str(combat_stats.get("base_attack_bonus", "-"))
		+ "\n"
	)
	
	details_text += (
		"Movimento: "
		+ str(
			combat_stats.get(
				"max_movement_meters",
				"-"
			)
		)
		+ " m\n"
	)
	
	details_text += (
		"Dano: "
		+ str(combat_stats.get("damage_dice_count", 1))
		+ "d"
		+ str(combat_stats.get("damage_dice", 6))
		+ " + "
		+ str(combat_stats.get("damage_bonus", 0))
		+ "\n\n"
	)
	
	details_text += (
		"[font_size=21][b]Talentos[/b][/font_size]\n"
		+ feat_text
	)
	
	details_label.text = details_text
	details_label.scroll_to_line(0)

func on_inventory_equipment_changed(
	member_id: String
) -> void:
	if member_id != current_member_id:
		return
	
	var updated_member_data: Dictionary = (
		PartyManager.get_member(
			member_id
		)
	)
	
	if updated_member_data.is_empty():
		return
	
	update_member_details(
		updated_member_data
	)

func close_panel() -> void:
	visible = false
	current_member_id = ""
	
	if is_instance_valid(inventory_panel):
		inventory_panel.set_current_member("")
	
	panel_closed.emit()
