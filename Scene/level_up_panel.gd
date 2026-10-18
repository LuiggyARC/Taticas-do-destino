extends CanvasLayer
class_name LevelUpPanel

const ClassPowerProgressionData = preload("res://Scene/class_power_progression.gd")
const LevelProgressionData = preload("res://Scene/level_progression.gd")


signal level_up_confirmed(level_up_data: Dictionary)


var level_up_manager: LevelUpManager
var hero_unit: Node
var level_up_preview: Dictionary = {}

var interface_root: Control
var window_panel: PanelContainer
var content_container: VBoxContainer

var title_label: Label
var level_label: Label
var hp_description_label: Label
var hp_result_label: Label
var roll_hp_button: Button
var progression_label: Label
var validation_label: Label
var confirm_button: Button

var feat_selection_container: VBoxContainer
var feat_option_buttons: Array[OptionButton] = []
var feat_detail_buttons: Array[OptionButton] = []
var feat_description_labels: Array[Label] = []
var attribute_option_buttons: Array[OptionButton] = []
var power_choice_cards: Dictionary = {}
var power_choice_buttons: Dictionary = {}
var power_options: Array[Dictionary] = []
var selected_power_id: String = ""

var spell_section: VBoxContainer
var spell_list: ItemList
var spell_instruction_label: Label
var spell_description_label: Label

var rolled_hp_die: int = 0
var calculated_hp_gain: int = 0
var required_spell_choices: int = 0
var hp_rolling: bool = false
var hp_roll_generation: int = 0


func _ready() -> void:
	layer = 200
	level_up_manager = LevelUpManager.new()
	create_interface()
	hide_panel()


func create_interface() -> void:
	interface_root = Control.new()
	interface_root.name = "LevelUpInterfaceRoot"
	interface_root.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	interface_root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(interface_root)
	
	var dark_background := ColorRect.new()
	dark_background.name = "DarkBackground"
	dark_background.color = Color(
		0.0,
		0.0,
		0.0,
		0.82
	)
	dark_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	dark_background.mouse_filter = Control.MOUSE_FILTER_STOP
	interface_root.add_child(dark_background)
	
	window_panel = PanelContainer.new()
	window_panel.name = "LevelUpWindow"
	window_panel.set_anchors_preset(
		Control.PRESET_CENTER
	)
	update_window_bounds()
	get_viewport().size_changed.connect(update_window_bounds)
	window_panel.add_theme_stylebox_override(
		"panel",
		create_panel_style()
	)
	interface_root.add_child(window_panel)
	
	var margin_container := MarginContainer.new()
	margin_container.add_theme_constant_override(
		"margin_left",
		24
	)
	margin_container.add_theme_constant_override(
		"margin_right",
		24
	)
	margin_container.add_theme_constant_override(
		"margin_top",
		20
	)
	margin_container.add_theme_constant_override(
		"margin_bottom",
		20
	)
	window_panel.add_child(margin_container)
	
	var main_container := VBoxContainer.new()
	main_container.add_theme_constant_override(
		"separation",
		12
	)
	margin_container.add_child(main_container)
	
	title_label = Label.new()
	title_label.text = "EVOLUÇÃO DE PERSONAGEM"
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	title_label.add_theme_font_size_override(
		"font_size",
		28
	)
	title_label.add_theme_color_override(
		"font_color",
		Color(0.95, 0.78, 0.30)
	)
	title_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	title_label.add_theme_constant_override(
		"outline_size",
		6
	)
	main_container.add_child(title_label)
	
	level_label = Label.new()
	level_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	level_label.add_theme_font_size_override(
		"font_size",
		20
	)
	main_container.add_child(level_label)
	
	var separator := HSeparator.new()
	main_container.add_child(separator)
	
	var scroll_container := ScrollContainer.new()
	scroll_container.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	scroll_container.horizontal_scroll_mode = (
		ScrollContainer.SCROLL_MODE_DISABLED
	)
	main_container.add_child(scroll_container)
	
	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	content_container.add_theme_constant_override(
		"separation",
		14
	)
	scroll_container.add_child(content_container)
	
	validation_label = Label.new()
	validation_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	validation_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	validation_label.add_theme_font_size_override(
		"font_size",
		16
	)
	validation_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.42, 0.35)
	)
	main_container.add_child(validation_label)
	
	confirm_button = Button.new()
	confirm_button.text = "Confirmar evolução"
	confirm_button.custom_minimum_size = Vector2(
		0,
		48
	)
	confirm_button.add_theme_font_size_override(
		"font_size",
		19
	)
	confirm_button.pressed.connect(
		on_confirm_button_pressed
	)
	main_container.add_child(confirm_button)


func update_window_bounds() -> void:
	if not is_instance_valid(window_panel):
		return
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var panel_width: float = minf(840.0, maxf(320.0, viewport_size.x - 24.0))
	var panel_height: float = minf(860.0, maxf(320.0, viewport_size.y - 24.0))
	window_panel.offset_left = -panel_width * 0.5
	window_panel.offset_right = panel_width * 0.5
	window_panel.offset_top = -panel_height * 0.5
	window_panel.offset_bottom = panel_height * 0.5


func open_for_hero(
	new_hero_unit: Node,
	target_level: int = -1
) -> void:
	if not is_instance_valid(new_hero_unit):
		return
	
	hero_unit = new_hero_unit
	
	level_up_preview = (
		level_up_manager.get_level_up_preview(
			hero_unit,
			target_level
		)
	)
	
	if level_up_preview.is_empty():
		return
	
	reset_selections()
	rebuild_level_up_content()
	interface_root.visible = true


func hide_panel() -> void:
	if is_instance_valid(interface_root):
		interface_root.visible = false


func reset_selections() -> void:
	hp_roll_generation += 1
	hp_rolling = false
	rolled_hp_die = 0
	calculated_hp_gain = 0
	required_spell_choices = 0
	feat_option_buttons.clear()
	feat_detail_buttons.clear()
	feat_description_labels.clear()
	attribute_option_buttons.clear()
	power_choice_cards.clear()
	power_choice_buttons.clear()
	power_options.clear()
	selected_power_id = ""
	validation_label.text = ""


func rebuild_level_up_content() -> void:
	clear_content_container()
	
	var current_level: int = int(
		level_up_preview.get(
			"current_level",
			1
		)
	)
	
	var new_level: int = int(
		level_up_preview.get(
			"new_level",
			current_level + 1
		)
	)
	
	level_label.text = (
		str(hero_unit.character_name)
		+ " — Nível "
		+ str(current_level)
		+ " → "
		+ str(new_level)
	)
	
	create_hp_section()
	create_level_gains_section()
	create_progression_section()
	create_attribute_section()
	create_feat_section()
	create_spell_section()
	
	validation_label.text = ""
	confirm_button.disabled = false


func clear_content_container() -> void:
	if not is_instance_valid(content_container):
		return
	
	for child in content_container.get_children():
		child.free()


func create_level_gains_section() -> void:
	var section := create_section_panel("Conquistas deste nível")
	content_container.add_child(section)
	var section_content: VBoxContainer = section.get_meta("content")
	var gains: Array = level_up_preview.get("level_gains", [])
	var new_level: int = int(level_up_preview.get("new_level", 2))
	var character_class: String = str(level_up_preview.get("character_class", ""))
	power_options = ClassPowerProgressionData.get_power_options_for_level(character_class, new_level)
	for gain in gains:
		var label := Label.new()
		label.text = "• " + str(gain)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_font_size_override("font_size", 17)
		section_content.add_child(label)
	if ClassPowerProgressionData.has_class(character_class):
		var totals: Dictionary = LevelProgressionData.power_totals_for_level(new_level)
		var tpc_label := Label.new()
		tpc_label.text = "Poderes conhecidos (TPC) após evoluir\n%d sem limite / %d encontro / %d diários / %d utilitários" % [totals["at_will"], totals["encounter"], totals["daily"], totals["utility"]]
		tpc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tpc_label.add_theme_font_size_override("font_size", 17)
		tpc_label.add_theme_color_override("font_color", Color(0.73, 0.88, 0.77))
		section_content.add_child(tpc_label)
	var xp_label := Label.new()
	xp_label.text = "XP necessário para este nível: %d" % int(level_up_preview.get("new_xp_threshold", 0))
	section_content.add_child(xp_label)
	if not power_options.is_empty():
		create_power_choice_section(new_level)


func create_power_choice_section(new_level: int) -> void:
	var section := create_section_panel("Escolha seu novo poder")
	content_container.add_child(section)
	var section_content: VBoxContainer = section.get_meta("content")
	var instruction := Label.new()
	instruction.text = "Nível %d · Selecione uma das duas opções. A escolha ficará registrada no personagem." % new_level
	instruction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instruction.add_theme_font_size_override("font_size", 17)
	section_content.add_child(instruction)
	var options_row: BoxContainer = VBoxContainer.new() if OS.has_feature("mobile") else HBoxContainer.new()
	options_row.add_theme_constant_override("separation", 12)
	section_content.add_child(options_row)
	for power in power_options:
		var power_id: String = str(power["id"])
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", create_power_card_style(false))
		options_row.add_child(card)
		power_choice_cards[power_id] = card
		var card_margin := MarginContainer.new()
		card_margin.add_theme_constant_override("margin_left", 12)
		card_margin.add_theme_constant_override("margin_right", 12)
		card_margin.add_theme_constant_override("margin_top", 10)
		card_margin.add_theme_constant_override("margin_bottom", 10)
		card.add_child(card_margin)
		var column := VBoxContainer.new()
		column.add_theme_constant_override("separation", 8)
		card_margin.add_child(column)
		var frequency := Label.new()
		frequency.text = ("UTILITÁRIO · " if bool(power.get("utility", false)) else "ATAQUE · ") + str(power["frequency"]).to_upper()
		frequency.add_theme_font_size_override("font_size", 15)
		frequency.add_theme_color_override("font_color", Color(0.94, 0.75, 0.28))
		column.add_child(frequency)
		var power_name := Label.new()
		power_name.text = str(power["name"])
		power_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		power_name.add_theme_font_size_override("font_size", 20)
		column.add_child(power_name)
		var description := Label.new()
		description.text = str(power["description"])
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.size_flags_vertical = Control.SIZE_EXPAND_FILL
		description.add_theme_font_size_override("font_size", 16)
		column.add_child(description)
		var select_button := Button.new()
		select_button.text = "Escolher este poder"
		select_button.custom_minimum_size.y = 64 if OS.has_feature("mobile") else 46
		select_button.add_theme_font_size_override("font_size", 18)
		select_button.pressed.connect(select_new_power.bind(power_id))
		column.add_child(select_button)
		power_choice_buttons[power_id] = select_button


func create_power_card_style(selected: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.10, 0.19, 0.15) if selected else Color(0.12, 0.12, 0.15)
	style.border_color = Color(0.35, 0.88, 0.52) if selected else Color(0.45, 0.37, 0.24)
	style.set_border_width_all(3 if selected else 2)
	style.set_corner_radius_all(10)
	return style


func select_new_power(power_id: String) -> void:
	selected_power_id = power_id
	for option_id in power_choice_cards:
		var selected: bool = str(option_id) == power_id
		var card: PanelContainer = power_choice_cards[option_id]
		card.add_theme_stylebox_override("panel", create_power_card_style(selected))
		var button: Button = power_choice_buttons[option_id]
		button.text = "✓ Poder escolhido" if selected else "Escolher este poder"
	validation_label.text = ""

func create_attribute_section() -> void:
	var point_count: int = int(level_up_preview.get("attribute_point_count", 0))
	if point_count <= 0:
		return
	var section: PanelContainer = create_section_panel("Pontos de atributo — escolha %d" % point_count)
	content_container.add_child(section)
	var section_content: VBoxContainer = section.get_meta("content") as VBoxContainer
	var explanation := Label.new()
	explanation.text = "A cada 4 níveis, todas as raças distribuem 2 pontos. Meio-Elfo distribui 3. Você pode repetir um atributo."
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	section_content.add_child(explanation)
	for point_index in range(point_count):
		var option := OptionButton.new()
		option.custom_minimum_size.y = 72 if OS.has_feature("mobile") else 50
		option.add_theme_font_size_override("font_size", 28 if OS.has_feature("mobile") else 20)
		option.add_item("Escolha o atributo para o ponto %d" % (point_index + 1))
		for attribute_name in ["Força", "Destreza", "Constituição", "Sabedoria", "Inteligência", "Carisma"]:
			option.add_item(attribute_name)
		option.select(0)
		section_content.add_child(option)
		attribute_option_buttons.append(option)

func get_selected_attribute_increases() -> Dictionary:
	var attribute_keys: Array[String] = ["strength", "dexterity", "constitution", "wisdom", "intelligence", "charisma"]
	var increases: Dictionary = {}
	for option in attribute_option_buttons:
		if option.selected <= 0:
			return {}
		var key: String = attribute_keys[option.selected - 1]
		increases[key] = int(increases.get(key, 0)) + 1
	return increases


func create_hp_section() -> void:
	var section := create_section_panel(
		"Pontos de Vida"
	)
	
	content_container.add_child(section)
	
	var section_content: VBoxContainer = (
		section.get_meta("content")
	)
	
	var hit_die: int = int(
		level_up_preview.get(
			"hit_die",
			1
		)
	)
	
	var fixed_hp: int = int(
		level_up_preview.get(
			"fixed_hp",
			1
		)
	)
	
	var constitution_modifier: int = int(
		level_up_preview.get(
			"constitution_modifier",
			0
		)
	)
	
	var hp_mode: String = str(
		level_up_preview.get(
			"hp_progression_mode",
			"fixed"
		)
	)
	
	hp_description_label = Label.new()
	hp_description_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	section_content.add_child(
		hp_description_label
	)
	
	hp_result_label = Label.new()
	hp_result_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	hp_result_label.add_theme_font_size_override(
		"font_size",
		20
	)
	hp_result_label.add_theme_color_override(
		"font_color",
		Color(0.45, 1.0, 0.52)
	)
	section_content.add_child(
		hp_result_label
	)
	
	roll_hp_button = Button.new()
	roll_hp_button.text = (
		"Rolar vida — 1d"
		+ str(hit_die)
	)
	roll_hp_button.custom_minimum_size = Vector2(
		0,
		42
	)
	roll_hp_button.pressed.connect(
		on_roll_hp_button_pressed
	)
	section_content.add_child(
		roll_hp_button
	)
	
	if hp_mode == "roll":
		hp_description_label.text = (
			"Role 1d"
			+ str(hit_die)
			+ " e some o modificador de Constituição "
			+ format_modifier(
				constitution_modifier
			)
			+ ". A rolagem poderá ser feita apenas uma vez."
		)
		
		hp_result_label.text = (
			"Aguardando rolagem"
		)
		
		roll_hp_button.visible = true
		roll_hp_button.disabled = false
	else:
		calculated_hp_gain = max(
			1,
			fixed_hp + constitution_modifier
		)
		
		hp_description_label.text = (
			"Progressão fixa: "
			+ str(fixed_hp)
			+ " + Constituição "
			+ format_modifier(
				constitution_modifier
			)
		)
		
		hp_result_label.text = (
			"Vida máxima aumentará em "
			+ str(calculated_hp_gain)
		)
		
		roll_hp_button.visible = false
	if str(hero_unit.character_race) == "Anão":
		hp_description_label.text += "\nSangue de Ferro: +1 PV máximo extra neste nível."
		if hp_mode != "roll":
			hp_result_label.text = "Vida máxima aumentará em %d (inclui Sangue de Ferro)" % (calculated_hp_gain + 1)


func create_progression_section() -> void:
	var section := create_section_panel(
		"Progressão da Classe"
	)
	
	content_container.add_child(section)
	
	var section_content: VBoxContainer = (
		section.get_meta("content")
	)
	
	progression_label = Label.new()
	progression_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	progression_label.add_theme_font_size_override(
		"font_size",
		17
	)
	section_content.add_child(
		progression_label
	)
	
	var progression_lines: Array[String] = []
	
	append_progression_line(
		progression_lines,
		"Bônus Base de Ataque",
		int(
			level_up_preview.get(
				"current_base_attack_bonus",
				0
			)
		),
		int(
			level_up_preview.get(
				"new_base_attack_bonus",
				0
			)
		)
	)
	
	append_progression_line(
		progression_lines,
		"Fortitude",
		int(
			level_up_preview.get(
				"current_fortitude",
				0
			)
		),
		int(
			level_up_preview.get(
				"new_fortitude",
				0
			)
		)
	)
	
	append_progression_line(
		progression_lines,
		"Reflexos",
		int(
			level_up_preview.get(
				"current_reflex",
				0
			)
		),
		int(
			level_up_preview.get(
				"new_reflex",
				0
			)
		)
	)
	
	append_progression_line(
		progression_lines,
		"Vontade",
		int(
			level_up_preview.get(
				"current_will",
				0
			)
		),
		int(
			level_up_preview.get(
				"new_will",
				0
			)
		)
	)
	
	var current_slots: Dictionary = (
		level_up_preview.get(
			"current_spell_slots",
			{}
		)
	)
	
	var new_slots: Dictionary = (
		level_up_preview.get(
			"new_spell_slots",
			{}
		)
	)
	
	for spell_level in [0, 1, 2]:
		append_progression_line(
			progression_lines,
			"Espaços de magia — círculo "
			+ str(spell_level),
			int(
				current_slots.get(
					spell_level,
					0
				)
			),
			int(
				new_slots.get(
					spell_level,
					0
				)
			)
		)
	
	if progression_lines.is_empty():
		progression_label.text = (
			"Nenhuma progressão automática "
			+ "neste nível."
		)
	else:
		progression_label.text = (
			"\n".join(
				progression_lines
			)
		)


func append_progression_line(
	lines: Array[String],
	stat_name: String,
	old_value: int,
	new_value: int
) -> void:
	if old_value == new_value:
		return
	
	lines.append(
		stat_name
		+ ": "
		+ format_modifier(old_value)
		+ " → "
		+ format_modifier(new_value)
	)


func create_feat_section() -> void:
	var feat_choices: Array = (
		level_up_preview.get(
			"feat_choices",
			[]
		)
	)
	
	var section := create_section_panel(
		"Talentos"
	)
	
	content_container.add_child(section)
	
	feat_selection_container = (
		section.get_meta("content")
	)
	
	if feat_choices.is_empty():
		var no_feat_label := Label.new()
		no_feat_label.text = (
			"Nenhum novo talento é recebido neste nível."
		)
		no_feat_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		no_feat_label.add_theme_color_override(
			"font_color",
			Color(0.72, 0.72, 0.76)
		)
		feat_selection_container.add_child(
			no_feat_label
		)
		
		return
	var feat_hint := Label.new()
	feat_hint.text = "Selecione um talento para ler o benefício. Você pode mudar a escolha antes de confirmar."
	feat_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feat_hint.add_theme_color_override("font_color", Color(0.73, 0.82, 0.77))
	feat_selection_container.add_child(feat_hint)
	
	for choice_data_value in feat_choices:
		var choice_data: Dictionary = (
			choice_data_value
		)
		
		var choice_title := Label.new()
		choice_title.text = str(
			choice_data.get(
				"title",
				"Escolha um talento"
			)
		)
		choice_title.add_theme_font_size_override(
			"font_size",
			16
		)
		feat_selection_container.add_child(
			choice_title
		)
		
		var feat_option := OptionButton.new()
		feat_option.custom_minimum_size = Vector2(
			0,
			64 if OS.has_feature("mobile") else 46
		)
		feat_option.add_item(
			"Selecione um talento..."
		)
		feat_option.set_item_disabled(
			0,
			true
		)
		
		var available_feats: Array = (
			choice_data.get(
				"available_feats",
				[]
			)
		)
		
		for feat_name_value in available_feats:
			var feat_name: String = str(feat_name_value)
			feat_option.add_item(feat_name)
			feat_option.get_popup().set_item_tooltip(
				feat_option.item_count - 1,
				FeatDatabase.get_feat_description(feat_name)
			)
		
		feat_option_buttons.append(
			feat_option
		)
		
		feat_selection_container.add_child(
			feat_option
		)
		var detail_option := OptionButton.new()
		detail_option.custom_minimum_size = Vector2(0, 42)
		detail_option.visible = false
		feat_detail_buttons.append(detail_option)
		feat_selection_container.add_child(detail_option)
		var feat_description := Label.new()
		feat_description.text = "Benefício: selecione um talento acima."
		feat_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		feat_description.add_theme_font_size_override("font_size", 16)
		feat_description.add_theme_color_override("font_color", Color(0.85, 0.86, 0.80))
		feat_selection_container.add_child(feat_description)
		feat_description_labels.append(feat_description)
		var slot_index: int = feat_option_buttons.size() - 1
		feat_option.item_selected.connect(on_level_up_feat_selected.bind(slot_index))


func on_level_up_feat_selected(_selected: int, slot_index: int) -> void:
	update_feat_detail_option(slot_index)
	update_feat_description(slot_index)
	validation_label.text = ""


func update_feat_description(slot_index: int) -> void:
	if slot_index < 0 or slot_index >= feat_option_buttons.size():
		return
	var feat_option: OptionButton = feat_option_buttons[slot_index]
	var description_label: Label = feat_description_labels[slot_index]
	if feat_option.selected <= 0:
		description_label.text = "Benefício: selecione um talento acima."
		return
	var feat_name: String = feat_option.get_item_text(feat_option.selected)
	var description: String = FeatDatabase.get_feat_description(feat_name)
	description_label.text = "Benefício: " + (description if not description.is_empty() else "Descrição indisponível.")


func update_feat_detail_option(slot_index: int) -> void:
	var feat_option: OptionButton = feat_option_buttons[slot_index]
	var detail_option: OptionButton = feat_detail_buttons[slot_index]
	detail_option.clear()
	detail_option.visible = false
	if feat_option.selected <= 0:
		return
	var feat_name: String = feat_option.get_item_text(feat_option.selected)
	var feat_data: Dictionary = FeatDatabase.get_feat_data(feat_name)
	var choice_type: String = str(feat_data.get("choice_type", ""))
	if choice_type == "":
		return
	var choices: Array = feat_data.get("choices", []).duplicate()
	if choice_type == "weapon_specialization" or choice_type == "spell_specialization":
		choices.clear()
		var required_base: String = "Foco em Arma" if choice_type == "weapon_specialization" else "Foco em Magia"
		var existing_feats: Array = hero_unit.get("selected_feats") if is_instance_valid(hero_unit) else []
		for selected_feat in existing_feats:
			var full_name: String = str(selected_feat)
			if full_name.begins_with(required_base + ":"):
				choices.append(full_name.split(":", false, 1)[1].strip_edges())
	detail_option.add_item("Escolha a especialidade...")
	detail_option.set_item_disabled(0, true)
	for choice in choices:
		detail_option.add_item(str(choice))
	detail_option.visible = true


func create_spell_section() -> void:
	required_spell_choices = int(
		level_up_preview.get(
			"spell_choice_count",
			0
		)
	)
	
	var is_spellcaster: bool = bool(
		level_up_preview.get(
			"is_spellcaster",
			false
		)
	)
	
	if not is_spellcaster:
		return
	
	var available_spells: Array = (
		level_up_preview.get(
			"available_spells",
			[]
		)
	)
	
	var section := create_section_panel(
		"Novas Magias"
	)
	
	content_container.add_child(section)
	
	spell_section = section.get_meta(
		"content"
	)
	
	if required_spell_choices <= 0:
		var no_spell_choice_label := Label.new()
		
		var character_class: String = str(
			level_up_preview.get(
				"character_class",
				""
			)
		)
		
		if character_class in [
			"Clérigo",
			"Druida"
		]:
			no_spell_choice_label.text = (
				"As magias disponíveis para a classe "
				+ "serão atualizadas automaticamente."
			)
		else:
			no_spell_choice_label.text = (
				"Nenhuma nova escolha de magia "
				+ "é recebida neste nível."
			)
		
		no_spell_choice_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		no_spell_choice_label.add_theme_color_override(
			"font_color",
			Color(0.72, 0.72, 0.76)
		)
		spell_section.add_child(
			no_spell_choice_label
		)
		
		return
	
	if available_spells.is_empty():
		var no_available_spell_label := Label.new()
		no_available_spell_label.text = (
			"Não existem novas magias disponíveis "
			+ "para este nível."
		)
		no_available_spell_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		no_available_spell_label.add_theme_color_override(
			"font_color",
			Color(0.72, 0.72, 0.76)
		)
		spell_section.add_child(
			no_available_spell_label
		)
		
		required_spell_choices = 0
		return
	
	spell_instruction_label = Label.new()
	spell_instruction_label.text = (
		"Escolha "
		+ str(required_spell_choices)
		+ (
			" magia."
			if required_spell_choices == 1
			else " magias."
		)
		+ " Toque em uma magia para ver seu efeito."
	)
	spell_instruction_label.add_theme_font_size_override(
		"font_size",
		16
	)
	spell_section.add_child(
		spell_instruction_label
	)
	
	spell_list = ItemList.new()
	spell_list.custom_minimum_size = Vector2(
		0,
		min(
			260,
			70 + available_spells.size() * 32
		)
	)
	spell_list.select_mode = (
		ItemList.SELECT_MULTI
	)
	spell_list.allow_reselect = true
	spell_list.multi_selected.connect(on_level_up_spell_selected)
	spell_section.add_child(
		spell_list
	)
	spell_description_label = Label.new()
	spell_description_label.text = "Selecione uma magia para ver sua descrição."
	spell_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	spell_description_label.add_theme_font_size_override("font_size", 16)
	spell_description_label.add_theme_color_override("font_color", Color(0.85, 0.86, 0.80))
	spell_section.add_child(spell_description_label)
	
	for spell_name_value in available_spells:
		var spell_name: String = str(
			spell_name_value
		)
		
		var spell_data: Dictionary = (
			SpellDatabase.get_spell_data(
				spell_name
			)
		)
		
		var spell_level: int = int(
			spell_data.get(
				"level",
				0
			)
		)
		
		spell_list.add_item(
			spell_name
			+ " — círculo "
			+ str(spell_level)
		)
		
		spell_list.set_item_metadata(
			spell_list.item_count - 1,
			spell_name
		)


func on_level_up_spell_selected(index: int, _selected: bool) -> void:
	if not is_instance_valid(spell_list) or not is_instance_valid(spell_description_label):
		return
	var spell_name: String = str(spell_list.get_item_metadata(index))
	var spell_data: Dictionary = SpellDatabase.get_spell_data(spell_name)
	spell_description_label.text = spell_name + " — " + str(spell_data.get("description", "Descrição indisponível."))


func create_section_panel(
	section_title: String
) -> PanelContainer:
	var section_panel := PanelContainer.new()
	section_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	section_panel.add_theme_stylebox_override(
		"panel",
		create_section_style()
	)
	
	var margin := MarginContainer.new()
	margin.add_theme_constant_override(
		"margin_left",
		14
	)
	margin.add_theme_constant_override(
		"margin_right",
		14
	)
	margin.add_theme_constant_override(
		"margin_top",
		12
	)
	margin.add_theme_constant_override(
		"margin_bottom",
		12
	)
	section_panel.add_child(margin)
	
	var section_content := VBoxContainer.new()
	section_content.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	section_content.add_theme_constant_override(
		"separation",
		8
	)
	margin.add_child(section_content)
	
	var section_title_label := Label.new()
	section_title_label.text = section_title
	section_title_label.add_theme_font_size_override(
		"font_size",
		20
	)
	section_title_label.add_theme_color_override(
		"font_color",
		Color(0.94, 0.75, 0.28)
	)
	section_content.add_child(
		section_title_label
	)
	
	section_panel.set_meta(
		"content",
		section_content
	)
	
	return section_panel


func create_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(
		0.055,
		0.055,
		0.075,
		0.98
	)
	style.border_color = Color(
		0.72,
		0.52,
		0.14,
		1.0
	)
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	return style


func create_section_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(
		0.10,
		0.10,
		0.13,
		0.96
	)
	style.border_color = Color(
		0.30,
		0.27,
		0.20,
		1.0
	)
	style.set_border_width_all(1)
	style.set_corner_radius_all(7)
	return style


func on_roll_hp_button_pressed() -> void:
	if rolled_hp_die > 0 or hp_rolling:
		return
	
	var hit_die: int = max(
		1,
		int(
			level_up_preview.get(
				"hit_die",
				1
			)
		)
	)
	
	var constitution_modifier: int = int(
		level_up_preview.get(
			"constitution_modifier",
			0
		)
	)
	
	# O resultado é sorteado uma única vez; os quadros seguintes são apenas visuais.
	var final_roll: int = randi_range(1, hit_die)
	hp_rolling = true
	roll_hp_button.disabled = true
	roll_hp_button.text = "Rolando..."
	confirm_button.disabled = true
	animate_hp_roll(final_roll, hit_die, constitution_modifier, hp_roll_generation)


func animate_hp_roll(final_roll: int, hit_die: int, constitution_modifier: int, generation: int) -> void:
	for frame in range(12):
		if generation != hp_roll_generation or not is_inside_tree():
			return
		hp_result_label.text = "1d%d  •  %d" % [hit_die, randi_range(1, hit_die)]
		hp_result_label.add_theme_font_size_override("font_size", 24 if frame % 2 == 0 else 20)
		await get_tree().create_timer(0.045 + float(frame) * 0.008).timeout
	if generation != hp_roll_generation or not is_inside_tree():
		return
	rolled_hp_die = final_roll
	calculated_hp_gain = max(1, final_roll + constitution_modifier)
	hp_result_label.add_theme_font_size_override("font_size", 20)
	hp_result_label.text = (
		"1d"
		+ str(hit_die)
		+ ": "
		+ str(rolled_hp_die)
		+ " "
		+ format_modifier(
			constitution_modifier
		)
		+ " = "
		+ str(calculated_hp_gain)
		+ " pontos de vida"
	)
	if str(hero_unit.character_race) == "Anão":
		hp_result_label.text += " +1 Sangue de Ferro"
	roll_hp_button.text = "Vida rolada"
	hp_rolling = false
	confirm_button.disabled = false


func on_confirm_button_pressed() -> void:
	validation_label.text = ""
	if hp_rolling:
		validation_label.text = "Aguarde o fim da rolagem de vida."
		return
	
	if not validate_hp_selection():
		return
	var attribute_increases: Dictionary = get_selected_attribute_increases()
	if not attribute_option_buttons.is_empty() and attribute_increases.is_empty():
		validation_label.text = "Distribua todos os pontos de atributo antes de continuar."
		return
	if not power_options.is_empty() and selected_power_id.is_empty():
		validation_label.text = "Escolha um dos novos poderes antes de continuar."
		return
	
	var selected_feats: Array[String] = (
		get_selected_feats()
	)
	
	if selected_feats.size() != (
		feat_option_buttons.size()
	):
		validation_label.text = (
			"Escolha todos os talentos disponíveis."
		)
		return
	
	if has_duplicate_strings(
		selected_feats
	):
		validation_label.text = (
			"Não é possível escolher o mesmo "
			+ "talento duas vezes."
		)
		return
	
	var selected_spells: Array[String] = (
		get_selected_spells()
	)
	
	if selected_spells.size() != (
		required_spell_choices
	):
		validation_label.text = (
			"Escolha exatamente "
			+ str(required_spell_choices)
			+ (
				" magia."
				if required_spell_choices == 1
				else " magias."
			)
		)
		return
	
	var result: Dictionary = {
		"current_level": int(
			level_up_preview.get(
				"current_level",
				1
			)
		),
		"new_level": int(
			level_up_preview.get(
				"new_level",
				2
			)
		),
		"hp_die_roll": rolled_hp_die,
		"hp_gain": calculated_hp_gain,
		"attribute_increases": attribute_increases,
		"selected_class_power": selected_power_id,
		"selected_feats": selected_feats,
		"selected_spells": selected_spells,
		"new_base_attack_bonus": int(
			level_up_preview.get(
				"new_base_attack_bonus",
				0
			)
		),
		"new_fortitude": int(
			level_up_preview.get(
				"new_fortitude",
				0
			)
		),
		"new_reflex": int(
			level_up_preview.get(
				"new_reflex",
				0
			)
		),
		"new_will": int(
			level_up_preview.get(
				"new_will",
				0
			)
		),
		"new_spell_slots": (
			level_up_preview.get(
				"new_spell_slots",
				{}
			)
		)
	}
	
	confirm_button.disabled = true
	
	level_up_confirmed.emit(
		result
	)


func validate_hp_selection() -> bool:
	var hp_mode: String = str(
		level_up_preview.get(
			"hp_progression_mode",
			"fixed"
		)
	)
	
	if hp_mode == "roll" and rolled_hp_die <= 0:
		validation_label.text = (
			"Role os pontos de vida antes de continuar."
		)
		return false
	
	if calculated_hp_gain <= 0:
		validation_label.text = (
			"Não foi possível calcular os pontos de vida."
		)
		return false
	
	return true


func get_selected_feats() -> Array[String]:
	var result: Array[String] = []
	
	for feat_option in feat_option_buttons:
		if not is_instance_valid(feat_option):
			continue
		
		if feat_option.selected <= 0:
			continue
		
		var slot_index: int = feat_option_buttons.find(feat_option)
		var feat_name: String = feat_option.get_item_text(feat_option.selected)
		var detail_option: OptionButton = feat_detail_buttons[slot_index]
		if detail_option.visible:
			if detail_option.selected <= 0:
				continue
			feat_name += ": " + detail_option.get_item_text(detail_option.selected)
		result.append(feat_name)
	
	return result


func get_selected_spells() -> Array[String]:
	var result: Array[String] = []
	
	if not is_instance_valid(spell_list):
		return result
	
	var selected_indexes: PackedInt32Array = (
		spell_list.get_selected_items()
	)
	
	for selected_index in selected_indexes:
		result.append(
			str(
				spell_list.get_item_metadata(
					selected_index
				)
			)
		)
	
	return result


func has_duplicate_strings(
	values: Array[String]
) -> bool:
	var unique_values: Dictionary = {}
	
	for value in values:
		if unique_values.has(value):
			return true
		
		unique_values[value] = true
	
	return false


func format_modifier(
	value: int
) -> String:
	if value >= 0:
		return "+" + str(value)
	
	return str(value)
