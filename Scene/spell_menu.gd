extends Node

var popup: PopupPanel
var spell_list_container: VBoxContainer
var button_sfx_callback: Callable


func setup(
	new_button_sfx_callback: Callable = Callable()
) -> void:
	button_sfx_callback = new_button_sfx_callback
	
	if is_instance_valid(popup):
		popup.queue_free()
	
	popup = null
	spell_list_container = null
	
	create_interface()


func create_interface() -> void:
	popup = PopupPanel.new()
	popup.name = "SpellPopup"
	popup.size = Vector2(740, 800) if OS.has_feature("mobile") else Vector2(390, 520)
	
	add_child(popup)
	
	var main_box := VBoxContainer.new()
	main_box.name = "SpellPopupBox"
	main_box.custom_minimum_size = Vector2(
		720 if OS.has_feature("mobile") else 370,
		780 if OS.has_feature("mobile") else 500
	)
	main_box.add_theme_constant_override(
		"separation",
		8
	)
	
	popup.add_child(main_box)
	
	var title_label := Label.new()
	title_label.text = "Magias"
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	title_label.custom_minimum_size = Vector2(
		700 if OS.has_feature("mobile") else 360,
		60 if OS.has_feature("mobile") else 34
	)
	title_label.add_theme_font_size_override(
		"font_size",
		32 if OS.has_feature("mobile") else 20
	)
	
	main_box.add_child(title_label)
	
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(
		700 if OS.has_feature("mobile") else 360,
		600 if OS.has_feature("mobile") else 400
	)
	scroll.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	
	main_box.add_child(scroll)
	
	spell_list_container = VBoxContainer.new()
	spell_list_container.name = (
		"SpellListContainer"
	)
	spell_list_container.custom_minimum_size = (
		Vector2(
			680 if OS.has_feature("mobile") else 340,
			600 if OS.has_feature("mobile") else 400
		)
	)
	spell_list_container.add_theme_constant_override(
		"separation",
		6
	)
	
	scroll.add_child(spell_list_container)
	
	var close_button := Button.new()
	close_button.text = "Fechar"
	close_button.custom_minimum_size = Vector2(
		700 if OS.has_feature("mobile") else 360,
		80 if OS.has_feature("mobile") else 42
	)
	close_button.add_theme_font_size_override("font_size", 30 if OS.has_feature("mobile") else 18)
	close_button.pressed.connect(
		hide_menu
	)
	
	main_box.add_child(close_button)
	apply_button_sfx(close_button)


func show_entries(
	spell_entries: Array,
	selection_callback: Callable
) -> void:
	if not is_instance_valid(popup):
		return
	
	if not is_instance_valid(
		spell_list_container
	):
		return
	
	clear_entries()
	
	for entry_value in spell_entries:
		if not entry_value is Dictionary:
			continue
		
		var entry: Dictionary = entry_value
		
		var spell_name: String = str(
			entry.get(
				"name",
				""
			)
		)
		
		var spell_level: int = int(
			entry.get(
				"level",
				0
			)
		)
		
		var slot_text: String = str(
			entry.get(
				"slot_text",
				""
			)
		)
		
		var effect: String = str(
			entry.get(
				"effect",
				""
			)
		)
		
		var description: String = str(
			entry.get(
				"description",
				""
			)
		)
		
		var spell_disabled: bool = bool(
			entry.get(
				"disabled",
				false
			)
		)
		
		var spell_button := Button.new()
		spell_button.custom_minimum_size = (
			Vector2(
				680 if OS.has_feature("mobile") else 340,
				80 if OS.has_feature("mobile") else 48
			)
		)
		spell_button.add_theme_font_size_override("font_size", 28 if OS.has_feature("mobile") else 18)
		
		spell_button.text = (
			spell_name
			+ " | Nv "
			+ str(spell_level)
			+ " | "
			+ slot_text
		)
		
		spell_button.disabled = spell_disabled
		
		if selection_callback.is_valid():
			spell_button.pressed.connect(
				selection_callback.bind(
					spell_name
				)
			)
		
		spell_list_container.add_child(
			spell_button
		)
		
		apply_button_sfx(spell_button)
		
		var description_label := Label.new()
		description_label.custom_minimum_size = (
			Vector2(
				680 if OS.has_feature("mobile") else 340,
				56 if OS.has_feature("mobile") else 36
			)
		)
		description_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		description_label.text = (
			"Tipo: "
			+ effect
			+ " | "
			+ description
		)
		description_label.add_theme_font_size_override(
			"font_size",
			24 if OS.has_feature("mobile") else 12
		)
		
		spell_list_container.add_child(
			description_label
		)
	
	popup.popup_centered(
		Vector2(740, 800) if OS.has_feature("mobile") else Vector2(390, 520)
	)


func clear_entries() -> void:
	if not is_instance_valid(
		spell_list_container
	):
		return
	
	for child in spell_list_container.get_children():
		child.queue_free()


func hide_menu() -> void:
	if not is_instance_valid(popup):
		return
	
	popup.hide()


func apply_button_sfx(
	button: BaseButton
) -> void:
	if not is_instance_valid(button):
		return
	
	if button_sfx_callback.is_valid():
		button_sfx_callback.call(button)
