extends Node

var panel: PanelContainer
var scroll: ScrollContainer
var information_label: Label

var ui_parent: CanvasLayer


func setup(new_ui_parent: CanvasLayer) -> void:
	if not is_instance_valid(new_ui_parent):
		return
	
	ui_parent = new_ui_parent
	
	var old_panel := ui_parent.get_node_or_null(
		"CharacterSheetPanel"
	)
	
	if is_instance_valid(old_panel):
		old_panel.queue_free()
	
	panel = null
	scroll = null
	information_label = null
	
	create_panel()


func create_panel() -> void:
	if not is_instance_valid(ui_parent):
		return
	
	panel = PanelContainer.new()
	panel.name = "CharacterSheetPanel"
	
	# A ficha acompanha a altura da tela.
	panel.set_anchors_preset(
		Control.PRESET_LEFT_WIDE
	)
	
	panel.offset_left = 16
	panel.offset_right = 376 if OS.has_feature("mobile") else 320
	panel.offset_top = 150
	panel.offset_bottom = -120
	
	panel.custom_minimum_size = Vector2(
		360 if OS.has_feature("mobile") else 304,
		420
	)
	
	var panel_style := StyleBoxFlat.new()
	
	panel_style.bg_color = Color(
		0.015,
		0.02,
		0.025,
		0.95
	)
	
	panel_style.border_color = Color(
		0.72,
		0.55,
		0.22,
		0.95
	)
	
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(12)
	
	panel_style.content_margin_left = 8
	panel_style.content_margin_right = 8
	panel_style.content_margin_top = 8
	panel_style.content_margin_bottom = 8
	
	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	ui_parent.add_child(panel)
	
	var main_box := VBoxContainer.new()
	main_box.name = "CharacterSheetBox"
	
	main_box.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	main_box.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	
	main_box.add_theme_constant_override(
		"separation",
		7
	)
	
	panel.add_child(main_box)
	
	# =====================================================
	# CABEÇALHO
	# =====================================================
	var title_panel := PanelContainer.new()
	title_panel.name = "CharacterSheetHeader"
	
	title_panel.custom_minimum_size = Vector2(
		0,
		42
	)
	
	title_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	var title_style := StyleBoxFlat.new()
	
	title_style.bg_color = Color(
		0.16,
		0.105,
		0.035,
		0.98
	)
	
	title_style.border_color = Color(
		0.82,
		0.64,
		0.27,
		1.0
	)
	
	title_style.set_border_width_all(1)
	title_style.set_corner_radius_all(7)
	
	title_style.content_margin_left = 8
	title_style.content_margin_right = 8
	title_style.content_margin_top = 5
	title_style.content_margin_bottom = 5
	
	title_panel.add_theme_stylebox_override(
		"panel",
		title_style
	)
	
	main_box.add_child(title_panel)
	
	var title := Label.new()
	title.name = "CharacterSheetTitle"
	title.text = "FICHA DO PERSONAGEM"
	
	title.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	title.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	title.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	title.add_theme_font_size_override(
		"font_size",
		24 if OS.has_feature("mobile") else 17
	)
	
	title.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.88,
			0.60,
			1.0
		)
	)
	
	title.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	title.add_theme_constant_override(
		"outline_size",
		3
	)
	
	title_panel.add_child(title)
	
	var separator := HSeparator.new()
	separator.modulate = Color(
		0.72,
		0.55,
		0.22,
		0.65
	)
	
	main_box.add_child(separator)
	
	# =====================================================
	# ÁREA DE ROLAGEM
	# =====================================================
	scroll = ScrollContainer.new()
	scroll.name = "CharacterSheetScroll"
	
	scroll.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	scroll.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	
	scroll.horizontal_scroll_mode = (
		ScrollContainer.SCROLL_MODE_DISABLED
	)
	
	scroll.vertical_scroll_mode = (
		ScrollContainer.SCROLL_MODE_AUTO
	)
	
	var scroll_style := StyleBoxFlat.new()
	
	scroll_style.bg_color = Color(
		0.025,
		0.03,
		0.035,
		0.82
	)
	
	scroll_style.border_color = Color(
		0.25,
		0.21,
		0.13,
		0.90
	)
	
	scroll_style.set_border_width_all(1)
	scroll_style.set_corner_radius_all(7)
	
	scroll.add_theme_stylebox_override(
		"panel",
		scroll_style
	)
	
	main_box.add_child(scroll)
	
	var content_margin := MarginContainer.new()
	content_margin.name = "CharacterSheetContentMargin"
	
	content_margin.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	content_margin.add_theme_constant_override(
		"margin_left",
		10
	)
	
	content_margin.add_theme_constant_override(
		"margin_right",
		14
	)
	
	content_margin.add_theme_constant_override(
		"margin_top",
		10
	)
	
	content_margin.add_theme_constant_override(
		"margin_bottom",
		12
	)
	
	scroll.add_child(content_margin)
	
	information_label = Label.new()
	information_label.name = "CharacterSheetInformation"
	
	information_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	
	information_label.custom_minimum_size = Vector2(
		300 if OS.has_feature("mobile") else 258,
		0
	)
	
	information_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	information_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_TOP
	)
	
	information_label.add_theme_font_size_override(
		"font_size",
		23 if OS.has_feature("mobile") else 15
	)
	
	information_label.add_theme_color_override(
		"font_color",
		Color(
			0.93,
			0.92,
			0.86,
			1.0
		)
	)
	
	information_label.add_theme_color_override(
		"font_outline_color",
		Color(
			0.0,
			0.0,
			0.0,
			0.75
		)
	)
	
	information_label.add_theme_constant_override(
		"outline_size",
		1
	)
	
	information_label.add_theme_constant_override(
		"line_spacing",
		4
	)
	
	content_margin.add_child(
		information_label
	)
	
	# =====================================================
	# BARRA DE ROLAGEM
	# =====================================================
	var vertical_scroll_bar: VScrollBar = (
		scroll.get_v_scroll_bar()
	)
	
	if is_instance_valid(vertical_scroll_bar):
		vertical_scroll_bar.custom_minimum_size = Vector2(
			10,
			0
		)
		
		var scroll_grabber := StyleBoxFlat.new()
		
		scroll_grabber.bg_color = Color(
			0.68,
			0.50,
			0.20,
			0.90
		)
		
		scroll_grabber.set_corner_radius_all(5)
		
		var scroll_grabber_highlight := StyleBoxFlat.new()
		
		scroll_grabber_highlight.bg_color = Color(
			0.88,
			0.68,
			0.30,
			1.0
		)
		
		scroll_grabber_highlight.set_corner_radius_all(5)
		
		var scroll_background := StyleBoxFlat.new()
		
		scroll_background.bg_color = Color(
			0.04,
			0.045,
			0.05,
			0.75
		)
		
		scroll_background.set_corner_radius_all(5)
		
		vertical_scroll_bar.add_theme_stylebox_override(
			"scroll",
			scroll_background
		)
		
		vertical_scroll_bar.add_theme_stylebox_override(
			"grabber",
			scroll_grabber
		)
		
		vertical_scroll_bar.add_theme_stylebox_override(
			"grabber_highlight",
			scroll_grabber_highlight
		)
		
		vertical_scroll_bar.add_theme_stylebox_override(
			"grabber_pressed",
			scroll_grabber_highlight
		)

func build_companion_text(
	companion_unit: Node2D
) -> String:
	if not is_instance_valid(companion_unit):
		return ""
	
	var sheet_text: String = ""
	
	sheet_text += (
		str(companion_unit.companion_name)
		+ "\n"
	)
	
	sheet_text += "Companheiro animal\n\n"
	
	sheet_text += (
		"HP: "
		+ str(companion_unit.hp)
		+ "/"
		+ str(companion_unit.max_hp)
		+ "\n"
	)
	
	sheet_text += (
		"Mov: "
		+ str(
			companion_unit.current_movement_meters
		)
		+ "/"
		+ str(
			companion_unit.max_movement_meters
		)
		+ "m\n"
	)
	
	sheet_text += (
		"CA: "
		+ str(
			companion_unit.get_armor_class()
		)
		+ "\n"
	)
	
	sheet_text += (
		"Ataque: "
		+ str(companion_unit.attack_power)
		+ "\n"
	)
	
	return sheet_text

func build_npc_text(
	npc_unit: Node2D,
	display_name: String
) -> String:
	if not is_instance_valid(npc_unit):
		return ""

	var sheet_text: String = (
		display_name
	)

	if (
		str(npc_unit.race) != ""
		or str(npc_unit.character_class) != ""
	):
		sheet_text += (
			" - "
			+ str(npc_unit.race)
			+ " - "
			+ str(npc_unit.character_class)
		)

	sheet_text += "\n"

	sheet_text += (
		"Nv "
		+ str(npc_unit.level)
	)

	if (
		npc_unit.has_method(
			"get_xp_progress_in_current_level"
		)
		and npc_unit.has_method(
			"get_xp_needed_for_current_level"
		)
	):
		sheet_text += (
			" | XP "
			+ str(
				npc_unit
				.get_xp_progress_in_current_level()
			)
			+ "/"
			+ str(
				npc_unit
				.get_xp_needed_for_current_level()
			)
		)

	sheet_text += "\n"

	if (
		"pending_level_ups" in npc_unit
		and int(
			npc_unit.pending_level_ups
		) > 0
	):
		sheet_text += (
			"Evolução pendente: "
			+ str(
				npc_unit.pending_level_ups
			)
			+ "\n"
		)

	sheet_text += "\n"

	sheet_text += (
		"HP: "
		+ str(npc_unit.hp)
		+ "/"
		+ str(npc_unit.max_hp)
		+ "\n"
	)

	sheet_text += (
		"Mov: "
		+ str(
			npc_unit.current_movement_meters
		)
		+ "/"
		+ str(
			npc_unit.max_movement_meters
		)
		+ "m\n"
	)

	sheet_text += (
		"Arma: "
		+ str(
			npc_unit.equipped_weapon
		)
		+ "\n\n"
	)

	sheet_text += (
		"CA: "
		+ str(
			npc_unit.get_armor_class()
		)
		+ "\n"
	)

	sheet_text += (
		"FORT: "
		+ str(
			npc_unit.get_fortitude_save_bonus()
		)
		+ "\n"
	)

	sheet_text += (
		"REF: "
		+ str(
			npc_unit.get_reflex_save_bonus()
		)
		+ "\n"
	)

	sheet_text += (
		"VON: "
		+ str(
			npc_unit.get_will_save_bonus()
		)
		+ "\n"
	)

	sheet_text += (
		"\n--- Atributos ---\n"
	)

	var attributes: Array = [
		[
			"FOR",
			npc_unit.strength
		],
		[
			"DES",
			npc_unit.dexterity
		],
		[
			"CON",
			npc_unit.constitution
		],
		[
			"INT",
			npc_unit.intelligence
		],
		[
			"SAB",
			npc_unit.wisdom
		],
		[
			"CAR",
			npc_unit.charisma
		]
	]

	for attribute_data in attributes:
		sheet_text += (
			str(
				attribute_data[0]
			)
			+ " "
			+ str(
				attribute_data[1]
			)
			+ "\n"
		)

	sheet_text += (
		"\n--- Combate ---\n"
	)

	sheet_text += (
		"BBA: +"
		+ str(
			npc_unit.get_base_attack_bonus()
		)
		+ "\n"
	)

	sheet_text += (
		"Toque: "
		+ str(
			npc_unit.get_touch_armor_class()
		)
		+ "\n"
	)

	sheet_text += (
		"Surpreso: "
		+ str(
			npc_unit.get_flat_footed_armor_class()
		)
		+ "\n"
	)

	if not npc_unit.feats.is_empty():
		sheet_text += "\nTalentos:\n"

		for feat_name in npc_unit.feats:
			sheet_text += (
				"- "
				+ str(feat_name)
				+ "\n"
			)

	return sheet_text

func build_hero_text(
	hero_unit: Node2D,
	companion_unit: Node2D,
	smite_status_text: String
) -> String:
	if not is_instance_valid(hero_unit):
		return ""
	
	var sheet_text: String = ""
	
	sheet_text += (
		str(hero_unit.character_name)
		+ " - "
		+ str(hero_unit.character_race)
		+ " - "
		+ str(hero_unit.character_class)
		+ "\n"
	)
	
	sheet_text += (
		"Nv "
		+ str(hero_unit.level)
		+ " | XP "
		+ str(
			hero_unit.get_xp_progress_in_current_level()
		)
		+ "/"
		+ str(
			hero_unit.get_xp_needed_for_current_level()
		)
		+ "\n\n"
	)
	
	sheet_text += (
		"HP: "
		+ str(hero_unit.hp)
		+ "/"
		+ str(hero_unit.max_hp)
		+ "\n"
	)
	
	sheet_text += (
		"Mov: "
		+ str(hero_unit.current_movement_meters)
		+ "/"
		+ str(hero_unit.max_movement_meters)
		+ "m\n"
	)
	
	sheet_text += (
		"Arma: "
		+ str(hero_unit.equipped_weapon)
		+ "\n\n"
	)
	
	sheet_text += (
		"CA: "
		+ str(hero_unit.get_armor_class())
		+ "\n"
	)
	
	sheet_text += (
		"FORT: "
		+ str(hero_unit.get_fortitude_save())
		+ "\n"
	)
	
	sheet_text += (
		"REF: "
		+ str(hero_unit.get_reflex_save())
		+ "\n"
	)
	
	sheet_text += (
		"VON: "
		+ str(hero_unit.get_will_save())
		+ "\n"
	)
	
	if hero_unit.character_class == "Bárbaro":
		sheet_text += "\nFúria: "
		
		if hero_unit.is_raging:
			sheet_text += (
				"Ativa ("
				+ str(
					hero_unit.rage_turns_remaining
				)
				+ ")"
			)
		elif not hero_unit.can_use_rage():
			sheet_text += "Usada"
		else:
			sheet_text += "Pronta"
	
	if hero_unit.character_class == "Paladino":
		sheet_text += (
			"\nDestruir o Mal: "
			+ smite_status_text
		)
	
	if hero_unit.damage_reduction > 0:
		sheet_text += (
			"\nRD: "
			+ str(hero_unit.damage_reduction)
		)
	
	sheet_text += "\n\n--- Atributos ---\n"
	
	var attributes: Array = [
		{
			"name": "FOR",
			"value": hero_unit.strength,
			"modifier": (
				hero_unit.get_strength_modifier()
			)
		},
		{
			"name": "DES",
			"value": hero_unit.dexterity,
			"modifier": (
				hero_unit.get_dexterity_modifier()
			)
		},
		{
			"name": "CON",
			"value": hero_unit.constitution,
			"modifier": (
				hero_unit.get_constitution_modifier()
			)
		},
		{
			"name": "SAB",
			"value": hero_unit.wisdom,
			"modifier": (
				hero_unit.get_wisdom_modifier()
			)
		},
		{
			"name": "INT",
			"value": hero_unit.intelligence,
			"modifier": (
				hero_unit.get_intelligence_modifier()
			)
		},
		{
			"name": "CAR",
			"value": hero_unit.charisma,
			"modifier": (
				hero_unit.get_charisma_modifier()
			)
		}
	]
	
	for attribute_data in attributes:
		sheet_text += (
			str(attribute_data["name"])
			+ " "
			+ str(attribute_data["value"])
			+ " ("
			+ hero_unit.format_modifier(
				int(attribute_data["modifier"])
			)
			+ ")\n"
		)
	
	sheet_text += "\n--- Combate ---\n"
	
	sheet_text += (
		"BBA: +"
		+ str(
			hero_unit.get_base_attack_bonus()
		)
		+ "\n"
	)
	
	sheet_text += (
		"Toque: "
		+ str(
			hero_unit.get_touch_armor_class()
		)
		+ "\n"
	)
	
	sheet_text += (
		"Surpreso: "
		+ str(
			hero_unit.get_flat_footed_armor_class()
		)
		+ "\n"
	)
	
	sheet_text += (
		"Dado de Vida: d"
		+ str(hero_unit.class_hit_die)
		+ "\n"
	)
	
	sheet_text += (
		"Progressão HP: "
		+ str(hero_unit.hp_progression_mode)
		+ "\n"
	)
	
	sheet_text += "\n--- Raça ---\n"
	
	sheet_text += (
		"Tamanho: "
		+ str(hero_unit.character_size)
		+ "\n"
	)
	
	sheet_text += (
		"Classe favorecida: "
		+ str(hero_unit.favored_class)
		+ "\n"
	)
	
	sheet_text += "\nTraits raciais:\n"
	
	for race_trait_item in hero_unit.race_traits:
		sheet_text += (
			"- "
			+ str(race_trait_item)
			+ "\n"
		)
	
	sheet_text += "\nHabilidades de classe:\n"
	
	for class_feature_item in hero_unit.class_features:
		sheet_text += (
			"- "
			+ str(class_feature_item)
			+ "\n"
		)
	
	if is_instance_valid(companion_unit):
		sheet_text += (
			"\nCompanheiro: "
			+ str(companion_unit.companion_name)
			+ "\n"
		)
		
		sheet_text += (
			"HP Comp.: "
			+ str(companion_unit.hp)
			+ "/"
			+ str(companion_unit.max_hp)
			+ "\n"
		)
		
		sheet_text += (
			"CA Comp.: "
			+ str(companion_unit.armor_class)
			+ "\n"
		)
	
	return sheet_text

func set_text(new_text: String) -> void:
	if not is_instance_valid(information_label):
		return
	
	information_label.text = new_text


func set_panel_visible(
	should_be_visible: bool
) -> void:
	if not is_instance_valid(panel):
		return
	
	panel.visible = should_be_visible


func is_panel_visible() -> bool:
	if not is_instance_valid(panel):
		return false
	
	return panel.visible
