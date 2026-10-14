extends Node

var panel: PanelContainer
var effects_label: Label
var ui_parent: CanvasLayer


func setup(
	new_ui_parent: CanvasLayer
) -> void:
	if not is_instance_valid(new_ui_parent):
		return
	
	ui_parent = new_ui_parent
	
	if is_instance_valid(panel):
		if panel.get_parent() == ui_parent:
			return
		
		panel.queue_free()
		panel = null
		effects_label = null
	
	create_panel()


func create_panel() -> void:
	if not is_instance_valid(ui_parent):
		return
	
	var old_panel := ui_parent.get_node_or_null(
		"ActiveEffectsPanel"
	)
	
	if is_instance_valid(old_panel):
		old_panel.queue_free()
	
	panel = PanelContainer.new()
	panel.name = "ActiveEffectsPanel"
	ui_parent.add_child(panel)
	
	panel.set_anchors_preset(
		Control.PRESET_TOP_RIGHT
	)
	
	panel.offset_left = -260
	panel.offset_right = -12
	panel.offset_top = 150
	panel.offset_bottom = 230
	panel.grow_vertical = Control.GROW_DIRECTION_END
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(
		0.02,
		0.025,
		0.03,
		0.78
	)
	panel_style.border_color = Color(
		0.55,
		0.45,
		0.22,
		0.85
	)
	panel_style.set_border_width_all(2)
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8
	panel_style.content_margin_left = 8
	panel_style.content_margin_top = 6
	panel_style.content_margin_right = 8
	panel_style.content_margin_bottom = 6
	
	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	effects_label = Label.new()
	effects_label.name = "ActiveEffectsLabel"
	effects_label.text = (
		"Efeitos ativos:\nNenhum"
	)
	effects_label.custom_minimum_size = Vector2(230, 62)
	effects_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	effects_label.add_theme_font_size_override(
		"font_size",
		17 if OS.has_feature("mobile") else 13
	)
	effects_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.96,
			0.82,
			1.0
		)
	)
	
	panel.add_child(effects_label)
	panel.visible = false


func update_display(
	active_spell_areas: Array,
	enemy_units: Array,
	current_enemy: Node2D,
	hero_unit: Node2D,
	current_battle_turn: int,
	allied_units: Array = [],
	bard_song_rounds_remaining: int = 0
) -> void:
	if not is_instance_valid(panel):
		return
	
	if not is_instance_valid(effects_label):
		return
	
	var lines: Array[String] = []
	lines.append("Efeitos ativos:")
	
	append_spell_area_lines(
		lines,
		active_spell_areas,
		current_battle_turn
	)
	
	append_enemy_effect_lines(
		lines,
		enemy_units,
		current_enemy,
		current_battle_turn
	)
	
	append_hero_effect_lines(
		lines,
		hero_unit,
		current_battle_turn
	)
	append_allied_druid_effect_lines(lines, allied_units, current_battle_turn)
	if bard_song_rounds_remaining > 0:
		lines.append("Grupo: Refrão de Coragem | +1 para acertar armas | %d rodada(s)" % bard_song_rounds_remaining)
	
	if lines.size() <= 1:
		lines.append("Nenhum")
	
	effects_label.text = "\n".join(lines)
	
	panel.visible = not (
		lines.size() == 2
		and lines[1] == "Nenhum"
	)


func append_spell_area_lines(
	lines: Array[String],
	active_spell_areas: Array,
	current_battle_turn: int
) -> void:
	for area_value in active_spell_areas:
		if not area_value is Dictionary:
			continue
		
		var area_data: Dictionary = area_value
		
		var end_turn: int = int(
			area_data.get(
				"end_turn",
				current_battle_turn
			)
		)
		
		var turns_remaining: int = max(
			0,
			end_turn - current_battle_turn
		)
		
		if turns_remaining <= 0:
			continue
		
		var spell_name: String = str(
			area_data.get(
				"spell_name",
				"Área"
			)
		)
		
		var effect: String = str(
			area_data.get(
				"effect",
				""
			)
		)
		
		lines.append(
			"Área: "
			+ spell_name
			+ " | "
			+ get_effect_display_name(effect)
			+ " | "
			+ str(turns_remaining)
			+ "t"
		)


func append_enemy_effect_lines(
	lines: Array[String],
	enemy_units: Array,
	current_enemy: Node2D,
	current_battle_turn: int
) -> void:
	var checked_enemies: Array[Node2D] = []
	
	for enemy_value in enemy_units:
		if not enemy_value is Node2D:
			continue
		
		var enemy_unit: Node2D = enemy_value
		
		if not is_instance_valid(enemy_unit):
			continue
		
		if checked_enemies.has(enemy_unit):
			continue
		
		checked_enemies.append(enemy_unit)
		
		append_unit_effect_descriptions(
			lines,
			enemy_unit,
			current_battle_turn
		)
	
	if is_instance_valid(current_enemy):
		if not checked_enemies.has(current_enemy):
			append_unit_effect_descriptions(
				lines,
				current_enemy,
				current_battle_turn
			)


func append_unit_effect_descriptions(
	lines: Array[String],
	unit: Node2D,
	current_battle_turn: int
) -> void:
	if not is_instance_valid(unit):
		return
	
	if not unit.has_method(
		"get_active_effect_descriptions"
	):
		return
	
	var descriptions: Array = (
		unit.get_active_effect_descriptions(
			current_battle_turn
		)
	)
	
	for description in descriptions:
		lines.append(str(description))


func append_hero_effect_lines(
	lines: Array[String],
	hero_unit: Node2D,
	current_battle_turn: int
) -> void:
	if not is_instance_valid(hero_unit):
		return
	if "unstoppable_active" in hero_unit and bool(hero_unit.unstoppable_active):
		lines.append("Herói: Imparável | +1 resistências, +2 dano até o fim do próximo turno")
	if "druid_guard_active" in hero_unit and bool(hero_unit.druid_guard_active):
		lines.append("Herói: Casca Viva | até o próximo turno")
	if "cleric_guard_active" in hero_unit and bool(hero_unit.cleric_guard_active):
		lines.append("Herói: Luz Vigilante | +1 CA até o próximo turno")
	if "fighter_guard_active" in hero_unit and bool(hero_unit.fighter_guard_active):
		lines.append("Herói: Postura Firme | +2 CA até o próximo turno")
	if "druid_form_active" in hero_unit and bool(hero_unit.druid_form_active):
		lines.append("Herói: Aspecto Selvagem | %dt" % maxi(0, int(hero_unit.druid_form_end_turn) - current_battle_turn))
	if "status_effects" in hero_unit:
		var status_data: Dictionary = hero_unit.status_effects
		for effect_name in status_data.keys():
			var remaining: int = int(status_data[effect_name]) - current_battle_turn
			if remaining <= 0:
				continue
			var display_name: String = "Paralisia" if str(effect_name) == "paralyzed" else str(effect_name).capitalize()
			lines.append("Herói: " + display_name + " | " + str(remaining) + " rodada(s)")
	
	if (
		"character_class" in hero_unit
		and str(hero_unit.character_class)
		== "Bárbaro"
		and "is_raging" in hero_unit
		and bool(hero_unit.is_raging)
		and "rage_end_turn" in hero_unit
	):
		var rage_remaining: int = (
			int(hero_unit.rage_end_turn)
			- current_battle_turn
		)
		
		if rage_remaining > 0:
			lines.append(
				"Herói: Fúria | "
				+ str(rage_remaining)
				+ "t"
			)
	
	if (
		"temporary_effects_active" in hero_unit
		and bool(
			hero_unit.temporary_effects_active
		)
		and "temporary_effects_end_turn"
		in hero_unit
	):
		var buff_turns_remaining: int = (
			int(
				hero_unit
				.temporary_effects_end_turn
			)
			- current_battle_turn
		)
		
		if buff_turns_remaining > 0:
			lines.append(
				"Herói: Buff mágico | "
				+ str(buff_turns_remaining)
				+ "t"
			)


func append_allied_druid_effect_lines(lines: Array[String], allied_units: Array, current_battle_turn: int) -> void:
	for ally in allied_units:
		if not is_instance_valid(ally) or str(ally.faction) != "ally":
			continue
		if str(ally.character_class) == "Clérigo" and ally.cleric_guard_active:
			lines.append("%s: Luz Vigilante | +1 CA até o próximo turno" % str(ally.display_name))
		if str(ally.character_class) == "Guerreiro" and ally.fighter_guard_active:
			lines.append("%s: Postura Firme | +2 CA até o próximo turno" % str(ally.display_name))
		if str(ally.character_class) != "Druida":
			continue
		if ally.druid_guard_active:
			lines.append("%s: Casca Viva | até o próximo turno" % str(ally.display_name))
		if ally.druid_form_active:
			lines.append("%s: Aspecto Selvagem | %dt" % [str(ally.display_name), maxi(0, int(ally.druid_form_end_turn) - current_battle_turn)])


func get_effect_display_name(
	effect: String
) -> String:
	match effect:
		"damage":
			return "Dano"
		
		"heal":
			return "Cura"
		
		"buff":
			return "Buff"
		
		"control":
			return "Controle"
		
		"utility":
			return "Utilidade"
		
		_:
			return effect


func get_panel() -> PanelContainer:
	return panel


func get_effects_label() -> Label:
	return effects_label
