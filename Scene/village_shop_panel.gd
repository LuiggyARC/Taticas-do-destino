extends Control
class_name VillageShopPanel

const TouchScrollSupport = preload("res://Scene/touch_scroll_support.gd")


signal panel_closed
signal item_purchased(item_id: String)
signal item_sold(item_id: String)

var gold_label: Label
var buy_list: VBoxContainer
var sell_list: VBoxContainer
var feedback_label: Label
var shop_title_label: Label

var current_shop_id: String = (
	ShopDatabase.STARTING_VILLAGE_SHOP_ID
)

func _ready() -> void:
	name = "VillageShopPanel"
	z_index = 300
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	create_interface()
	connect_inventory_signals()
	refresh_shop()
	
	visible = false


func create_interface() -> void:
	var dark_background := ColorRect.new()
	dark_background.color = Color(
		0.0,
		0.0,
		0.0,
		0.82
	)
	dark_background.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	dark_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	add_child(dark_background)
	
	var window := PanelContainer.new()
	window.anchor_left = 0.08
	window.anchor_top = 0.06
	window.anchor_right = 0.92
	window.anchor_bottom = 0.94
	
	var window_style := StyleBoxFlat.new()
	window_style.bg_color = Color(
		0.035,
		0.03,
		0.025,
		0.99
	)
	window_style.border_color = Color(
		0.72,
		0.52,
		0.24,
		1.0
	)
	window_style.set_border_width_all(3)
	window_style.corner_radius_top_left = 14
	window_style.corner_radius_top_right = 14
	window_style.corner_radius_bottom_left = 14
	window_style.corner_radius_bottom_right = 14
	window_style.content_margin_left = 22
	window_style.content_margin_top = 18
	window_style.content_margin_right = 22
	window_style.content_margin_bottom = 18
	
	window.add_theme_stylebox_override(
		"panel",
		window_style
	)
	add_child(window)
	
	var main_container := VBoxContainer.new()
	main_container.add_theme_constant_override(
		"separation",
		12
	)
	window.add_child(main_container)
	
	var header := HBoxContainer.new()
	main_container.add_child(header)
	
	shop_title_label = Label.new()
	shop_title_label.text = "Loja"
	shop_title_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	shop_title_label.add_theme_font_size_override(
		"font_size",
		27
	)
	shop_title_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.84, 0.46, 1.0)
	)
	header.add_child(shop_title_label)
	
	gold_label = Label.new()
	gold_label.text = "Ouro: 0"
	gold_label.add_theme_font_size_override(
		"font_size",
		19
	)
	gold_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.76, 0.20, 1.0)
	)
	header.add_child(gold_label)
	
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
	
	var lists_container := HBoxContainer.new()
	lists_container.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	lists_container.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	lists_container.add_theme_constant_override(
		"separation",
		18
	)
	main_container.add_child(lists_container)
	
	var buy_column := create_shop_column(
		"Comprar"
	)
	buy_column.size_flags_stretch_ratio = 1.0
	lists_container.add_child(buy_column)
	
	buy_list = create_scroll_list()
	buy_column.add_child(
		buy_list.get_parent()
	)
	
	var vertical_separator := VSeparator.new()
	lists_container.add_child(
		vertical_separator
	)
	
	var sell_column := create_shop_column(
		"Vender da mochila"
	)
	sell_column.size_flags_stretch_ratio = 1.0
	lists_container.add_child(sell_column)
	
	sell_list = create_scroll_list()
	sell_column.add_child(
		sell_list.get_parent()
	)
	
	feedback_label = Label.new()
	feedback_label.text = ""
	feedback_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	feedback_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	feedback_label.add_theme_font_size_override(
		"font_size",
		16
	)
	main_container.add_child(
		feedback_label
	)


func create_shop_column(
	title_text: String
) -> VBoxContainer:
	var column := VBoxContainer.new()
	column.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	column.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)
	column.add_theme_constant_override(
		"separation",
		8
	)
	
	var title_label := Label.new()
	title_label.text = title_text
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	title_label.add_theme_font_size_override(
		"font_size",
		21
	)
	title_label.add_theme_color_override(
		"font_color",
		Color(0.94, 0.78, 0.42, 1.0)
	)
	column.add_child(title_label)
	
	return column


func create_scroll_list() -> VBoxContainer:
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
	
	var item_list := VBoxContainer.new()
	item_list.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	item_list.add_theme_constant_override(
		"separation",
		8
	)
	
	scroll_container.add_child(item_list)
	
	return item_list


func connect_inventory_signals() -> void:
	if not InventoryManager.inventory_changed.is_connected(
		refresh_shop
	):
		InventoryManager.inventory_changed.connect(
			refresh_shop
		)
	
	if not InventoryManager.gold_changed.is_connected(
		update_gold_label
	):
		InventoryManager.gold_changed.connect(
			update_gold_label
		)


func refresh_shop() -> void:
	if not is_instance_valid(buy_list):
		return
	
	if not is_instance_valid(sell_list):
		return
	
	clear_item_list(buy_list)
	clear_item_list(sell_list)
	
	update_gold_label(
		InventoryManager.get_gold()
	)
	
	create_buy_entries()
	create_sell_entries()
	TouchScrollSupport.enable(buy_list.get_parent() as ScrollContainer)
	TouchScrollSupport.enable(sell_list.get_parent() as ScrollContainer)


func clear_item_list(
	item_list: VBoxContainer
) -> void:
	for child in item_list.get_children():
		item_list.remove_child(child)
		child.queue_free()


func create_buy_entries() -> void:
	var available_items: Array[Dictionary] = (
		ShopDatabase.get_shop_stock(
			current_shop_id
		)
	)
	
	if available_items.is_empty():
		create_empty_message(
			buy_list,
			"Nenhum item disponível nesta loja."
		)
		return
	
	for item_data in available_items:
		var item_id: String = str(
			item_data.get(
				"id",
				""
			)
		)
		
		var buy_price: int = int(
			item_data.get(
				"buy_price",
				0
			)
		)
		
		if item_id == "":
			continue
		
		if buy_price <= 0:
			continue
		
		create_shop_item_row(
			buy_list,
			item_data,
			"Comprar — "
			+ str(buy_price)
			+ " moedas",
			buy_item.bind(item_id),
			InventoryManager.get_gold()
				< buy_price
		)


func create_sell_entries() -> void:
	if not ShopDatabase.shop_allows_selling(
		current_shop_id
	):
		create_empty_message(
			sell_list,
			"Esta loja não compra itens."
		)
		return
	
	var inventory_entries: Array[Dictionary] = (
		InventoryManager.get_inventory_entries()
	)
	
	if inventory_entries.is_empty():
		create_empty_message(
			sell_list,
			"A mochila está vazia."
		)
		return
	
	for item_data in inventory_entries:
		var item_id: String = str(
			item_data.get(
				"id",
				""
			)
		)
		
		if item_id == "":
			continue
		
		var sell_price: int = int(
			item_data.get(
				"sell_price",
				0
			)
		)
		
		if sell_price <= 0:
			continue
		
		create_shop_item_row(
			sell_list,
			item_data,
			"Vender — "
			+ str(sell_price)
			+ " moedas",
			sell_item.bind(item_id),
			false
		)


func create_shop_item_row(
	target_list: VBoxContainer,
	item_data: Dictionary,
	button_text: String,
	button_action: Callable,
	button_disabled: bool
) -> void:
	var display_name: String = str(
		item_data.get(
			"display_name",
			"Item"
		)
	)
	
	var description: String = str(
		item_data.get(
			"description",
			""
		)
	)
	
	var quantity: int = int(
		item_data.get(
			"quantity",
			0
		)
	)
	
	var item_panel := PanelContainer.new()
	item_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	
	var item_style := StyleBoxFlat.new()
	item_style.bg_color = Color(
		0.075,
		0.065,
		0.055,
		0.96
	)
	item_style.border_color = Color(
		0.28,
		0.24,
		0.18,
		1.0
	)
	item_style.set_border_width_all(1)
	item_style.corner_radius_top_left = 7
	item_style.corner_radius_top_right = 7
	item_style.corner_radius_bottom_left = 7
	item_style.corner_radius_bottom_right = 7
	item_style.content_margin_left = 10
	item_style.content_margin_top = 8
	item_style.content_margin_right = 10
	item_style.content_margin_bottom = 8
	
	item_panel.add_theme_stylebox_override(
		"panel",
		item_style
	)
	target_list.add_child(item_panel)
	
	var item_container := VBoxContainer.new()
	item_container.add_theme_constant_override(
		"separation",
		5
	)
	item_panel.add_child(item_container)
	
	var name_label := Label.new()
	
	if quantity > 0:
		name_label.text = (
			display_name
			+ "  x"
			+ str(quantity)
		)
	else:
		name_label.text = display_name
	
	name_label.add_theme_font_size_override(
		"font_size",
		17
	)
	name_label.add_theme_color_override(
		"font_color",
		Color(0.96, 0.94, 0.88, 1.0)
	)
	item_container.add_child(name_label)
	
	if description != "":
		var description_label := Label.new()
		description_label.text = description
		description_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		description_label.add_theme_font_size_override(
			"font_size",
			14
		)
		description_label.add_theme_color_override(
			"font_color",
			Color(0.75, 0.73, 0.69, 1.0)
		)
		item_container.add_child(
			description_label
		)
	
	var action_button := Button.new()
	action_button.text = button_text
	action_button.disabled = button_disabled
	action_button.custom_minimum_size = Vector2(
		0,
		36
	)
	action_button.pressed.connect(
		button_action
	)
	item_container.add_child(action_button)


func create_empty_message(
	target_list: VBoxContainer,
	message: String
) -> void:
	var empty_label := Label.new()
	empty_label.text = message
	empty_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	empty_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	empty_label.add_theme_color_override(
		"font_color",
		Color(0.72, 0.72, 0.74, 1.0)
	)
	target_list.add_child(empty_label)


func buy_item(
	item_id: String
) -> void:
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
	
	if ShopDatabase.get_remaining_stock(
		current_shop_id,
		item_id
	) == 0:
		show_feedback(
			"Este item acabou no estoque.",
			false
		)
		refresh_shop()
		return
	
	var success: bool = (
		InventoryManager.buy_item(
			item_id,
			1
		)
	)
	
	if not success:
		show_feedback(
			"Ouro insuficiente para comprar "
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
	
	if not ShopDatabase.record_purchase(
		current_shop_id,
		item_id
	):
		InventoryManager.remove_item(
			item_id,
			1
		)
		
		InventoryManager.add_gold(
			int(
				item_data.get(
					"buy_price",
					0
				)
			)
		)
		
		show_feedback(
			"Não foi possível registrar a compra.",
			false
		)
		refresh_shop()
		return
	
	var save_successful: bool = (
		SaveManager.save_village_state()
	)
	
	refresh_shop()
	
	if save_successful:
		show_feedback(
			str(
				item_data.get(
					"display_name",
					item_id
				)
			)
			+ " foi colocado na mochila.",
			true
		)
	else:
		show_feedback(
			"Compra realizada, mas não foi "
			+ "possível salvar o progresso.",
			false
		)
	
	item_purchased.emit(
		item_id
	)


func sell_item(
	item_id: String
) -> void:
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
	
	var success: bool = (
		InventoryManager.sell_item(
			item_id,
			1
		)
	)
	
	if not success:
		show_feedback(
			"Não foi possível vender o item.",
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
		+ " foi vendido.",
		true
	)
	
	item_sold.emit(
		item_id
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

func open_shop(
	shop_id: String
) -> void:
	if not ShopDatabase.has_shop(
		shop_id
	):
		push_warning(
			"Loja não encontrada: "
			+ shop_id
		)
		return
	
	current_shop_id = shop_id
	
	var shop_name: String = (
		ShopDatabase.get_shop_display_name(
			current_shop_id
		)
	)
	
	var city_name: String = (
		ShopDatabase.get_shop_city_name(
			current_shop_id
		)
	)
	
	if is_instance_valid(shop_title_label):
		if city_name == "":
			shop_title_label.text = shop_name
		else:
			shop_title_label.text = (
				shop_name
				+ " — "
				+ city_name
			)
	
	if is_instance_valid(feedback_label):
		feedback_label.text = ""
	
	refresh_shop()
	visible = true

func open_panel() -> void:
	refresh_shop()
	visible = true


func close_panel() -> void:
	visible = false
	panel_closed.emit()
