extends Node

const TouchScrollSupport = preload("res://Scene/touch_scroll_support.gd")

var popup: PopupPanel
var spell_list_container: VBoxContainer
var button_sfx_callback: Callable
var selection_callback: Callable
var entries: Array = []
var selected_filter: String = "Todas"
var filter_buttons: Dictionary = {}


func setup(new_button_sfx_callback: Callable = Callable()) -> void:
	button_sfx_callback = new_button_sfx_callback
	create_interface()


func create_interface() -> void:
	popup = PopupPanel.new()
	popup.name = "SpellGrimoire"
	popup.add_theme_stylebox_override("panel", make_style(
		Color("12171d"), Color("b78b43"), 2, 14
	))
	add_child(popup)

	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	popup.add_child(margin)

	var main_box: VBoxContainer = VBoxContainer.new()
	main_box.add_theme_constant_override("separation", 12)
	margin.add_child(main_box)

	var heading: HBoxContainer = HBoxContainer.new()
	main_box.add_child(heading)
	var title: Label = Label.new()
	title.text = "GRIMÓRIO"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 30 if OS.has_feature("mobile") else 23)
	title.add_theme_color_override("font_color", Color("f5dfad"))
	heading.add_child(title)
	var close_button: Button = Button.new()
	close_button.text = "Fechar"
	close_button.custom_minimum_size = Vector2(132, 64) if OS.has_feature("mobile") else Vector2(94, 40)
	close_button.add_theme_font_size_override("font_size", 22 if OS.has_feature("mobile") else 16)
	close_button.pressed.connect(hide_menu)
	heading.add_child(close_button)
	apply_button_sfx(close_button)

	var subtitle: Label = Label.new()
	subtitle.text = "Escolha uma magia; depois selecione o alvo no campo."
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 20 if OS.has_feature("mobile") else 14)
	subtitle.add_theme_color_override("font_color", Color("bfc8d0"))
	main_box.add_child(subtitle)

	var filters: HFlowContainer = HFlowContainer.new()
	filters.add_theme_constant_override("h_separation", 7)
	filters.add_theme_constant_override("v_separation", 7)
	main_box.add_child(filters)
	for filter_name in ["Todas", "Ataque", "Cura", "Suporte"]:
		var filter_button: Button = Button.new()
		filter_button.text = filter_name
		filter_button.toggle_mode = true
		filter_button.custom_minimum_size = Vector2(116, 62) if OS.has_feature("mobile") else Vector2(74, 38)
		filter_button.add_theme_font_size_override("font_size", 21 if OS.has_feature("mobile") else 15)
		filter_button.pressed.connect(select_filter.bind(filter_name))
		filters.add_child(filter_button)
		filter_buttons[filter_name] = filter_button
		apply_button_sfx(filter_button)

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_box.add_child(scroll)
	spell_list_container = VBoxContainer.new()
	spell_list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spell_list_container.add_theme_constant_override("separation", 9)
	scroll.add_child(spell_list_container)


func show_entries(spell_entries: Array, new_selection_callback: Callable) -> void:
	if not is_instance_valid(popup):
		return
	entries = spell_entries.duplicate(true)
	selection_callback = new_selection_callback
	selected_filter = "Todas"
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var popup_width: int = mini(900 if OS.has_feature("mobile") else 620, maxi(340, int(viewport_size.x) - 24))
	var popup_height: int = mini(750 if OS.has_feature("mobile") else 620, maxi(320, int(viewport_size.y) - 24))
	popup.popup_centered(Vector2i(popup_width, popup_height))
	refresh_entries()


func select_filter(filter_name: String) -> void:
	selected_filter = filter_name
	refresh_entries()


func refresh_entries() -> void:
	if not is_instance_valid(spell_list_container):
		return
	for child in spell_list_container.get_children():
		spell_list_container.remove_child(child)
		child.queue_free()
	for filter_name in filter_buttons:
		var filter_button: Button = filter_buttons[filter_name]
		filter_button.set_pressed_no_signal(filter_name == selected_filter)

	var shown_count: int = 0
	for entry_value in entries:
		if not entry_value is Dictionary:
			continue
		var entry: Dictionary = entry_value
		var category: String = category_for_effect(str(entry.get("effect", "")))
		if selected_filter != "Todas" and category != selected_filter:
			continue
		add_spell_card(entry, category)
		shown_count += 1
	if shown_count == 0:
		var empty_label: Label = Label.new()
		empty_label.text = "Nenhuma magia nesta categoria."
		empty_label.add_theme_color_override("font_color", Color("bfc8d0"))
		spell_list_container.add_child(empty_label)
	TouchScrollSupport.enable(spell_list_container.get_parent() as ScrollContainer)


func add_spell_card(entry: Dictionary, category: String) -> void:
	var spell_name: String = str(entry.get("name", ""))
	var spell_level: int = int(entry.get("level", 0))
	var slot_text: String = str(entry.get("slot_text", ""))
	var description: String = str(entry.get("description", ""))
	var disabled: bool = bool(entry.get("disabled", false))
	var accent: Color = color_for_entry(entry, category)

	var card: PanelContainer = PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", make_style(
		Color("202830") if not disabled else Color("26282b"), accent, 1, 9
	))
	spell_list_container.add_child(card)
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	card.add_child(row)
	var details: VBoxContainer = VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 4)
	row.add_child(details)
	var name_label: Label = Label.new()
	name_label.text = spell_name
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 25 if OS.has_feature("mobile") else 18)
	name_label.add_theme_color_override("font_color", Color("f5f1e6"))
	details.add_child(name_label)
	var meta_label: Label = Label.new()
	meta_label.text = "%s  •  Nível %d  •  %s" % [category, spell_level, slot_text]
	meta_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	meta_label.add_theme_color_override("font_color", accent)
	meta_label.add_theme_font_size_override("font_size", 19 if OS.has_feature("mobile") else 14)
	details.add_child(meta_label)
	var description_label: Label = Label.new()
	description_label.text = description
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description_label.add_theme_font_size_override("font_size", 20 if OS.has_feature("mobile") else 13)
	description_label.add_theme_color_override("font_color", Color("cbd2d5"))
	details.add_child(description_label)
	var cast_button: Button = Button.new()
	cast_button.text = "Sem slot" if disabled else "Conjurar"
	cast_button.disabled = disabled
	cast_button.custom_minimum_size = Vector2(156, 76) if OS.has_feature("mobile") else Vector2(100, 50)
	cast_button.add_theme_font_size_override("font_size", 23 if OS.has_feature("mobile") else 16)
	cast_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if selection_callback.is_valid():
		cast_button.pressed.connect(selection_callback.bind(spell_name))
	row.add_child(cast_button)
	apply_button_sfx(cast_button)


func category_for_effect(effect: String) -> String:
	match effect:
		"damage", "control":
			return "Ataque"
		"heal":
			return "Cura"
		_:
			return "Suporte"


func color_for_entry(entry: Dictionary, category: String) -> Color:
	var visual_kind: String = str(entry.get("visual_kind", ""))
	match visual_kind:
		"heal":
			return Color("78d894")
		"fire":
			return Color("ff9a53")
		"light":
			return Color("f3df8c")
		"energy":
			if category == "Ataque":
				return Color("95afff")
	var spell_name: String = str(entry.get("name", "")).to_lower()
	if category == "Cura":
		return Color("78d894")
	if "chama" in spell_name or "flame" in spell_name or "fogo" in spell_name:
		return Color("ff9a53")
	if "luz" in spell_name or "sagrada" in spell_name or "benção" in spell_name:
		return Color("f3df8c")
	if category == "Ataque":
		return Color("95afff")
	return Color("bea7e9")


func make_style(fill: Color, border: Color, border_width: int, radius: int) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 13
	style.content_margin_right = 13
	style.content_margin_top = 11
	style.content_margin_bottom = 11
	return style


func hide_menu() -> void:
	if is_instance_valid(popup):
		popup.hide()


func apply_button_sfx(button: BaseButton) -> void:
	if button_sfx_callback.is_valid():
		button_sfx_callback.call(button)
