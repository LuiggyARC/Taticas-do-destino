extends Control


@export_range(0.5, 5.0, 0.1)
var display_duration: float = 1.8
var current_roll_text: String = ""
var panel: PanelContainer
var result_label: Label
var display_sequence: int = 0
var fade_tween: Tween
var spell_result_panels: Array[PanelContainer] = []

func _ready() -> void:
	name = "AttackRollBox"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	panel = PanelContainer.new()
	panel.name = "AttackRollPanel"
	panel.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	add_child(panel)
	
	panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	update_result_panel_position()
	get_viewport().size_changed.connect(update_result_panel_position)
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(
		0.025,
		0.025,
		0.035,
		0.94
	)
	panel_style.border_color = Color(
		0.78,
		0.62,
		0.28,
		1.0
	)
	panel_style.set_border_width_all(3)
	panel_style.set_corner_radius_all(10)
	panel_style.content_margin_left = 18
	panel_style.content_margin_right = 18
	panel_style.content_margin_top = 12
	panel_style.content_margin_bottom = 12
	
	panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	result_label = Label.new()
	result_label.name = "AttackRollLabel"
	result_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	result_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	result_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	result_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	result_label.add_theme_font_size_override(
		"font_size",
		30 if OS.has_feature("mobile") else 20
	)
	result_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	result_label.add_theme_constant_override(
		"outline_size",
		3
	)
	
	panel.add_child(result_label)
	
	visible = true
	panel.visible = false

func show_roll(
	dice_roll: int,
	attack_bonus: int,
	attack_total: int,
	target_ac: int,
	hit: bool,
	critical_hit: bool,
	attacker_name: String = "",
	target_name: String = ""
) -> void:
	var bonus_operator: String = "+"
	var bonus_value: int = attack_bonus
	
	if attack_bonus < 0:
		bonus_operator = "-"
		bonus_value = abs(
			attack_bonus
		)
	
	var result_text: String = "ERROU"
	var result_color := Color(
		1.0,
		0.35,
		0.30,
		1.0
	)
	
	if critical_hit:
		result_text = "ACERTO CRÍTICO!"
		result_color = Color(
			1.0,
			0.85,
			0.20,
			1.0
		)
	elif hit:
		result_text = "ACERTOU"
		result_color = Color(
			0.35,
			1.0,
			0.45,
			1.0
		)
	elif dice_roll == 1:
		result_text = "FALHA CRÍTICA!"
	
	var combatants_text: String = ""
	
	if (
		attacker_name != ""
		and target_name != ""
	):
		combatants_text = (
			attacker_name
			+ " atacando "
			+ target_name
			+ "\n"
		)
	elif attacker_name != "":
		combatants_text = (
			attacker_name
			+ " atacando\n"
		)
	
	current_roll_text = (
		combatants_text
		+ "d20 "
		+ str(dice_roll)
		+ " "
		+ bonus_operator
		+ " "
		+ str(bonus_value)
		+ " = "
		+ str(attack_total)
		+ "  vs  CA "
		+ str(target_ac)
		+ "\n"
		+ result_text
	)
	
	result_label.text = current_roll_text
	
	result_label.add_theme_color_override(
		"font_color",
		result_color
	)
	
	restart_display_timer()

func show_damage(damage_amount: int) -> void:
	if current_roll_text.is_empty():
		return
	
	result_label.text = (
		current_roll_text
		+ "\nDano: "
		+ str(max(damage_amount, 0))
	)
	
	restart_display_timer()
func restart_display_timer() -> void:
	display_sequence += 2
	
	var current_sequence: int = (
		display_sequence
	)
	
	if is_instance_valid(fade_tween):
		fade_tween.kill()
		fade_tween = null
	
	if not is_instance_valid(panel):
		return
	
	panel.modulate = Color.WHITE
	panel.visible = true
	
	await get_tree().create_timer(
		display_duration
	).timeout
	
	if current_sequence != display_sequence:
		return
	
	fade_tween = create_tween()
	
	fade_tween.tween_property(
		panel,
		"modulate:a",
		0.0,
		0.25
	)
	
	await fade_tween.finished
	
	if current_sequence == display_sequence:
		panel.visible = false
		panel.modulate = Color.WHITE
		
func show_spell_result(
	spell_name: String,
	target_name: String,
	dice_roll: int,
	save_bonus: int,
	save_total: int,
	save_dc: int,
	resisted: bool,
	damage_amount: int,
	effect_description: String = ""
) -> void:
	var spell_panel := PanelContainer.new()
	spell_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(spell_panel)
	spell_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	spell_panel.offset_left = -450
	spell_panel.offset_right = -14

	var spell_style := StyleBoxFlat.new()
	spell_style.bg_color = Color(0.025, 0.025, 0.035, 0.94)
	spell_style.border_color = Color(0.54, 0.40, 0.75)
	spell_style.set_border_width_all(2)
	spell_style.set_corner_radius_all(8)
	spell_style.set_content_margin_all(10)
	spell_panel.add_theme_stylebox_override("panel", spell_style)

	var save_text: String = "Sem teste de resistência"
	if save_dc > 0:
		var bonus_sign: String = "+" if save_bonus >= 0 else ""
		save_text = (
			"Teste: d20 " + str(dice_roll) + " "
			+ bonus_sign + str(save_bonus) + " = "
			+ str(save_total) + " vs CD " + str(save_dc)
			+ " — " + ("PASSOU" if resisted else "FALHOU")
		)

	var lines: Array[String] = [
		spell_name + " → " + target_name,
		save_text
	]
	if damage_amount > 0:
		lines.append("Dano: " + str(damage_amount))
	if not effect_description.is_empty():
		lines.append(effect_description)

	var spell_label := Label.new()
	spell_label.text = "\n".join(lines)
	spell_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	spell_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	spell_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	spell_label.add_theme_font_size_override("font_size", 28 if OS.has_feature("mobile") else 18)
	spell_label.add_theme_color_override(
		"font_color",
		Color(0.95, 0.92, 1.0) if resisted else Color(0.85, 1.0, 0.85)
	)
	spell_panel.add_child(spell_label)

	spell_result_panels.append(spell_panel)
	update_spell_result_panel_positions()
	await get_tree().create_timer(display_duration + 0.7).timeout
	if not is_instance_valid(spell_panel):
		return
	spell_result_panels.erase(spell_panel)
	spell_panel.queue_free()
	update_spell_result_panel_positions()


func update_spell_result_panel_positions() -> void:
	var valid_panels: Array[PanelContainer] = []
	
	for spell_panel in spell_result_panels:
		if is_instance_valid(spell_panel):
			valid_panels.append(
				spell_panel
			)
	
	spell_result_panels = valid_panels
	
	for panel_index in range(
		spell_result_panels.size()
	):
		var spell_panel: PanelContainer = (
			spell_result_panels[panel_index]
		)
		
		var base_bottom: float = -330.0
		var spell_height: float = 170.0 if OS.has_feature("mobile") else 130.0
		var bottom_offset: float = base_bottom - float(panel_index) * (spell_height + 10.0)
		spell_panel.offset_top = bottom_offset - spell_height
		spell_panel.offset_bottom = bottom_offset

func update_result_panel_position() -> void:
	if not is_instance_valid(panel):
		return
	panel.offset_left = -450.0
	panel.offset_right = -14.0
	var bottom_offset: float = -140.0
	panel.offset_top = bottom_offset - 174.0
	panel.offset_bottom = bottom_offset
	update_spell_result_panel_positions()
