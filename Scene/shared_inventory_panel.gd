extends VBoxContainer
class_name SharedInventoryPanel

const TouchScrollSupport = preload("res://Scene/touch_scroll_support.gd")


signal equipment_changed(member_id: String)


var current_member_id: String = ""

var gold_label: Label
var inventory_list: VBoxContainer
var empty_inventory_label: Label
var feedback_label: Label


func _ready() -> void:
	name = "SharedInventoryPanel"
	
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	add_theme_constant_override(
		"separation",
		10
	)
	
	create_interface()
	connect_inventory_signals()
	refresh_inventory()


func create_interface() -> void:
	var title_label := Label.new()
	title_label.text = "Mochila Compartilhada"
	title_label.add_theme_font_size_override(
		"font_size",
		28 if OS.has_feature("mobile") else 22
	)
	title_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.86, 0.48, 1.0)
	)
	add_child(title_label)
	
	gold_label = Label.new()
	gold_label.text = "Ouro: 0"
	gold_label.add_theme_font_size_override(
		"font_size",
		23 if OS.has_feature("mobile") else 18
	)
	gold_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.78, 0.25, 1.0)
	)
	add_child(gold_label)
	
	var separator := HSeparator.new()
	add_child(separator)
	
	var scroll_container := ScrollContainer.new()
	scroll_container.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	scroll_container.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	scroll_container.horizontal_scroll_mode = (
		ScrollContainer.SCROLL_MODE_DISABLED
	)
	add_child(scroll_container)
	
	inventory_list = VBoxContainer.new()
	inventory_list.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	inventory_list.add_theme_constant_override(
		"separation",
		8
	)
	scroll_container.add_child(inventory_list)
	
	empty_inventory_label = Label.new()
	empty_inventory_label.text = (
		"A mochila compartilhada está vazia."
	)
	empty_inventory_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	empty_inventory_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	empty_inventory_label.add_theme_color_override(
		"font_color",
		Color(0.72, 0.72, 0.76, 1.0)
	)
	inventory_list.add_child(
		empty_inventory_label
	)
	
	feedback_label = Label.new()
	feedback_label.text = ""
	feedback_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	feedback_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	feedback_label.add_theme_font_size_override(
		"font_size",
		20 if OS.has_feature("mobile") else 15
	)
	add_child(feedback_label)


func connect_inventory_signals() -> void:
	if not InventoryManager.inventory_changed.is_connected(
		refresh_inventory
	):
		InventoryManager.inventory_changed.connect(
			refresh_inventory
		)
	
	if not InventoryManager.gold_changed.is_connected(
		update_gold_label
	):
		InventoryManager.gold_changed.connect(
			update_gold_label
		)


func set_current_member(
	member_id: String
) -> void:
	current_member_id = member_id
	
	clear_feedback()
	refresh_inventory()


func refresh_inventory() -> void:
	if not is_instance_valid(inventory_list):
		return
	
	update_gold_label(
		InventoryManager.get_gold()
	)
	
	clear_inventory_rows()
	create_equipped_items_section()
	
	var section_separator := HSeparator.new()
	inventory_list.add_child(
		section_separator
	)
	
	var backpack_title := Label.new()
	backpack_title.text = "Itens guardados"
	backpack_title.add_theme_font_size_override(
		"font_size",
		23 if OS.has_feature("mobile") else 18
	)
	backpack_title.add_theme_color_override(
		"font_color",
		Color(1.0, 0.86, 0.48, 1.0)
	)
	inventory_list.add_child(
		backpack_title
	)
	
	var inventory_entries: Array[Dictionary] = (
		InventoryManager.get_inventory_entries()
	)
	
	if inventory_entries.is_empty():
		create_empty_inventory_message()
		TouchScrollSupport.enable(inventory_list.get_parent() as ScrollContainer)
		return
	
	for item_data in inventory_entries:
		create_inventory_item_row(
			item_data
		)
	TouchScrollSupport.enable(inventory_list.get_parent() as ScrollContainer)

func create_equipped_items_section() -> void:
	var equipped_title := Label.new()
	equipped_title.text = "Equipamentos atuais"
	equipped_title.add_theme_font_size_override(
		"font_size",
		23 if OS.has_feature("mobile") else 18
	)
	equipped_title.add_theme_color_override(
		"font_color",
		Color(1.0, 0.86, 0.48, 1.0)
	)
	inventory_list.add_child(
		equipped_title
	)
	
	if current_member_id == "":
		var no_member_label := Label.new()
		no_member_label.text = (
			"Nenhum personagem selecionado."
		)
		no_member_label.add_theme_color_override(
			"font_color",
			Color(0.72, 0.72, 0.76, 1.0)
		)
		inventory_list.add_child(
			no_member_label
		)
		return
	
	create_equipped_item_row(
		"weapon",
		"Arma"
	)
	
	create_equipped_item_row(
		"armor",
		"Armadura"
	)
	
	create_equipped_item_row(
		"shield",
		"Escudo"
	)


func create_equipped_item_row(
	equipment_slot: String,
	slot_display_name: String
) -> void:
	var equipped_item_id: String = (
		PartyManager.get_member_equipped_item_id(
			current_member_id,
			equipment_slot
		)
	)
	
	var item_data: Dictionary = {}
	
	if equipped_item_id != "":
		item_data = ItemDatabase.get_item(
			equipped_item_id
		)
	
	var item_display_name: String = "Nenhum"
	
	if not item_data.is_empty():
		item_display_name = str(
			item_data.get(
				"display_name",
				equipped_item_id
			)
		)
	
	var row_panel := PanelContainer.new()
	row_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	var row_style := StyleBoxFlat.new()
	row_style.bg_color = Color(
		0.07,
		0.07,
		0.095,
		0.96
	)
	row_style.border_color = Color(
		0.32,
		0.28,
		0.18,
		1.0
	)
	row_style.set_border_width_all(1)
	row_style.corner_radius_top_left = 6
	row_style.corner_radius_top_right = 6
	row_style.corner_radius_bottom_left = 6
	row_style.corner_radius_bottom_right = 6
	row_style.content_margin_left = 10
	row_style.content_margin_top = 7
	row_style.content_margin_right = 10
	row_style.content_margin_bottom = 7
	
	row_panel.add_theme_stylebox_override(
		"panel",
		row_style
	)
	inventory_list.add_child(
		row_panel
	)
	
	var row_container := HBoxContainer.new()
	row_container.add_theme_constant_override(
		"separation",
		8
	)
	row_panel.add_child(
		row_container
	)
	
	var equipment_label := Label.new()
	equipment_label.text = (
		slot_display_name
		+ ": "
		+ item_display_name
	)
	equipment_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	equipment_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	equipment_label.add_theme_font_size_override("font_size", 21 if OS.has_feature("mobile") else 16)
	row_container.add_child(
		equipment_label
	)
	
	var can_return_to_inventory: bool = (
		equipped_item_id != ""
		and ItemDatabase.can_store_in_inventory(
			equipped_item_id
		)
	)
	
	var unequip_button := Button.new()
	unequip_button.custom_minimum_size = Vector2(
		140 if OS.has_feature("mobile") else 90,
		58 if OS.has_feature("mobile") else 34
	)
	unequip_button.add_theme_font_size_override("font_size", 20 if OS.has_feature("mobile") else 16)
	unequip_button.disabled = (
		not can_return_to_inventory
	)
	
	if can_return_to_inventory:
		unequip_button.text = "Guardar"
		unequip_button.tooltip_text = (
			"Devolver este item para a mochila."
		)
	else:
		unequip_button.text = "Padrão"
		unequip_button.tooltip_text = (
			"Este é o equipamento básico do personagem."
		)
	
	unequip_button.pressed.connect(
		unequip_current_item.bind(
			equipment_slot
		)
	)
	row_container.add_child(
		unequip_button
	)


func unequip_current_item(
	equipment_slot: String
) -> void:
	if current_member_id == "":
		show_feedback(
			"Selecione um integrante do grupo.",
			false
		)
		return
	
	var equipped_item_id: String = (
		PartyManager.get_member_equipped_item_id(
			current_member_id,
			equipment_slot
		)
	)
	
	if equipped_item_id == "":
		show_feedback(
			"Não existe item equipado nesse espaço.",
			false
		)
		return
	
	var item_data: Dictionary = (
		ItemDatabase.get_item(
			equipped_item_id
		)
	)
	
	var item_display_name: String = str(
		item_data.get(
			"display_name",
			equipped_item_id
		)
	)
	
	var unequipped_successfully: bool = (
		InventoryManager.unequip_member_slot(
			current_member_id,
			equipment_slot
		)
	)
	
	if not unequipped_successfully:
		show_feedback(
			"Não foi possível guardar "
			+ item_display_name
			+ ".",
			false
		)
		return
	
	show_feedback(
		item_display_name
		+ " foi devolvido para a mochila.",
		true
	)
	
	equipment_changed.emit(
		current_member_id
	)

func clear_inventory_rows() -> void:
	if not is_instance_valid(inventory_list):
		return
	
	for child in inventory_list.get_children():
		inventory_list.remove_child(child)
		child.queue_free()


func create_empty_inventory_message() -> void:
	empty_inventory_label = Label.new()
	empty_inventory_label.text = (
		"A mochila compartilhada está vazia."
	)
	empty_inventory_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	empty_inventory_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	empty_inventory_label.add_theme_color_override(
		"font_color",
		Color(0.72, 0.72, 0.76, 1.0)
	)
	
	inventory_list.add_child(
		empty_inventory_label
	)


func create_inventory_item_row(
	item_data: Dictionary
) -> void:
	var item_id: String = str(
		item_data.get(
			"id",
			""
		)
	)
	
	if item_id == "":
		return
	
	var display_name: String = str(
		item_data.get(
			"display_name",
			item_id
		)
	)
	
	var description: String = str(
		item_data.get(
			"description",
			""
		)
	)
	
	var item_type: String = str(
		item_data.get(
			"item_type",
			""
		)
	)
	
	var equipment_slot: String = str(
		item_data.get(
			"slot",
			""
		)
	)
	
	var quantity: int = int(
		item_data.get(
			"quantity",
			1
		)
	)
	
	var item_panel := PanelContainer.new()
	item_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(
		0.08,
		0.08,
		0.11,
		0.96
	)
	panel_style.border_color = Color(
		0.28,
		0.28,
		0.34,
		1.0
	)
	panel_style.set_border_width_all(1)
	panel_style.corner_radius_top_left = 7
	panel_style.corner_radius_top_right = 7
	panel_style.corner_radius_bottom_left = 7
	panel_style.corner_radius_bottom_right = 7
	panel_style.content_margin_left = 10
	panel_style.content_margin_top = 8
	panel_style.content_margin_right = 10
	panel_style.content_margin_bottom = 8
	
	item_panel.add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	inventory_list.add_child(
		item_panel
	)
	
	var item_container := VBoxContainer.new()
	item_container.add_theme_constant_override(
		"separation",
		5
	)
	item_panel.add_child(
		item_container
	)
	
	var header := HBoxContainer.new()
	item_container.add_child(
		header
	)
	
	var item_name_label := Label.new()
	item_name_label.text = display_name
	item_name_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	item_name_label.add_theme_font_size_override(
		"font_size",
		23 if OS.has_feature("mobile") else 17
	)
	item_name_label.add_theme_color_override(
		"font_color",
		Color(0.94, 0.94, 0.98, 1.0)
	)
	header.add_child(
		item_name_label
	)
	
	var quantity_label := Label.new()
	quantity_label.text = "x" + str(quantity)
	quantity_label.add_theme_font_size_override("font_size", 21 if OS.has_feature("mobile") else 16)
	quantity_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.82, 0.38, 1.0)
	)
	header.add_child(
		quantity_label
	)
	
	var type_label := Label.new()
	type_label.text = get_item_type_text(
		item_type
	)
	type_label.add_theme_font_size_override(
		"font_size",
		19 if OS.has_feature("mobile") else 14
	)
	type_label.add_theme_color_override(
		"font_color",
		Color(0.62, 0.72, 0.86, 1.0)
	)
	item_container.add_child(
		type_label
	)
	
	if description != "":
		var description_label := Label.new()
		description_label.text = description
		description_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		description_label.add_theme_font_size_override(
			"font_size",
			19 if OS.has_feature("mobile") else 14
		)
		description_label.add_theme_color_override(
			"font_color",
			Color(0.76, 0.76, 0.80, 1.0)
		)
		item_container.add_child(
			description_label
		)
	
	if equipment_slot in [
		"weapon",
		"armor",
		"shield"
	]:
		var equip_button := Button.new()
		equip_button.text = "Equipar"
		equip_button.custom_minimum_size = Vector2(
			150 if OS.has_feature("mobile") else 120,
			60 if OS.has_feature("mobile") else 36
		)
		equip_button.add_theme_font_size_override("font_size", 21 if OS.has_feature("mobile") else 16)
		equip_button.disabled = (
			current_member_id == ""
		)
		equip_button.tooltip_text = (
			"Equipar em "
			+ get_equipment_slot_text(
				equipment_slot
			)
		)
		equip_button.pressed.connect(
			equip_inventory_item.bind(
				item_id
			)
		)
		
		item_container.add_child(
			equip_button
		)


func equip_inventory_item(
	item_id: String
) -> void:
	if current_member_id == "":
		show_feedback(
			"Selecione um integrante do grupo.",
			false
		)
		return
	
	var item_data: Dictionary = (
		ItemDatabase.get_item(
			item_id
		)
	)
	
	if item_data.is_empty():
		show_feedback(
			"Item não encontrado.",
			false
		)
		return
	
	var equipped_successfully: bool = (
		InventoryManager.equip_item_to_member(
			current_member_id,
			item_id
		)
	)
	
	if not equipped_successfully:
		show_feedback(
			"Não foi possível equipar "
			+ str(
				item_data.get(
					"display_name",
					item_id
				)
			)
			+ ".",
			false
		)
		return
	
	show_feedback(
		str(
			item_data.get(
				"display_name",
				item_id
			)
		)
		+ " equipado com sucesso.",
		true
	)
	
	equipment_changed.emit(
		current_member_id
	)


func update_gold_label(
	new_gold: int
) -> void:
	if not is_instance_valid(gold_label):
		return
	
	gold_label.text = (
		"Ouro: "
		+ str(new_gold)
	)


func show_feedback(
	message: String,
	success: bool
) -> void:
	if not is_instance_valid(feedback_label):
		return
	
	feedback_label.text = message
	
	if success:
		feedback_label.add_theme_color_override(
			"font_color",
			Color(0.42, 0.92, 0.52, 1.0)
		)
	else:
		feedback_label.add_theme_color_override(
			"font_color",
			Color(1.0, 0.42, 0.42, 1.0)
		)


func clear_feedback() -> void:
	if not is_instance_valid(feedback_label):
		return
	
	feedback_label.text = ""


func get_item_type_text(
	item_type: String
) -> String:
	match item_type:
		"weapon":
			return "Arma"
		
		"armor":
			return "Armadura"
		
		"shield":
			return "Escudo"
		
		"consumable":
			return "Consumível"
		
		_:
			return "Item"


func get_equipment_slot_text(
	equipment_slot: String
) -> String:
	match equipment_slot:
		"weapon":
			return "Arma"
		
		"armor":
			return "Armadura"
		
		"shield":
			return "Escudo"
		
		_:
			return "Equipamento"
