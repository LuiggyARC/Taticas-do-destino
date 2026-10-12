extends Node


signal inventory_changed
signal gold_changed(new_gold: int)


var gold: int = 0
var items: Dictionary = {}


func _ready() -> void:
	reset_inventory()


func reset_inventory() -> void:
	items.clear()
	gold = max(
		0,
		GameState.hero_gold
	)
	
	sync_gold_to_game_state()
	inventory_changed.emit()
	gold_changed.emit(gold)


func sync_gold_to_game_state() -> void:
	GameState.hero_gold = gold


func get_gold() -> int:
	return gold


func set_gold(
	new_gold: int
) -> void:
	gold = max(
		0,
		new_gold
	)
	
	sync_gold_to_game_state()
	gold_changed.emit(gold)


func add_gold(
	amount: int
) -> bool:
	if amount <= 0:
		return false
	
	set_gold(
		gold + amount
	)
	
	return true


func spend_gold(
	amount: int
) -> bool:
	if amount < 0:
		return false
	
	if gold < amount:
		return false
	
	set_gold(
		gold - amount
	)
	
	return true


func get_item_quantity(
	item_reference: String
) -> int:
	var item_id: String = (
		ItemDatabase.resolve_item_id(
			item_reference
		)
	)
	
	if item_id == "":
		return 0
	
	return int(
		items.get(
			item_id,
			0
		)
	)


func has_item(
	item_reference: String,
	quantity: int = 1
) -> bool:
	if quantity <= 0:
		return true
	
	return (
		get_item_quantity(item_reference)
		>= quantity
	)


func add_item(
	item_reference: String,
	quantity: int = 1
) -> bool:
	if quantity <= 0:
		return false
	
	var item_id: String = (
		ItemDatabase.resolve_item_id(
			item_reference
		)
	)
	
	if item_id == "":
		push_warning(
			"Item não encontrado: "
			+ item_reference
		)
		
		return false
	
	if not ItemDatabase.can_store_in_inventory(
		item_id
	):
		push_warning(
			"O item não pode ser guardado: "
			+ item_reference
		)
		
		return false
	
	var current_quantity: int = int(
		items.get(
			item_id,
			0
		)
	)
	
	items[item_id] = (
		current_quantity + quantity
	)
	
	inventory_changed.emit()
	
	return true


func remove_item(
	item_reference: String,
	quantity: int = 1
) -> bool:
	if quantity <= 0:
		return false
	
	var item_id: String = (
		ItemDatabase.resolve_item_id(
			item_reference
		)
	)
	
	if item_id == "":
		return false
	
	var current_quantity: int = int(
		items.get(
			item_id,
			0
		)
	)
	
	if current_quantity < quantity:
		return false
	
	var remaining_quantity: int = (
		current_quantity - quantity
	)
	
	if remaining_quantity <= 0:
		items.erase(item_id)
	else:
		items[item_id] = remaining_quantity
	
	inventory_changed.emit()
	
	return true


func get_inventory_entries() -> Array[Dictionary]:
	var inventory_entries: Array[Dictionary] = []
	
	for item_id in items.keys():
		var quantity: int = int(
			items[item_id]
		)
		
		if quantity <= 0:
			continue
		
		var item_data: Dictionary = (
			ItemDatabase.get_item(
				str(item_id)
			)
		)
		
		if item_data.is_empty():
			continue
		
		item_data["quantity"] = quantity
		
		inventory_entries.append(
			item_data
		)
	
	return inventory_entries


func buy_item(
	item_reference: String,
	quantity: int = 1
) -> bool:
	if quantity <= 0:
		return false
	
	var item_id: String = (
		ItemDatabase.resolve_item_id(
			item_reference
		)
	)
	
	if item_id == "":
		return false
	
	if not ItemDatabase.can_store_in_inventory(
		item_id
	):
		return false
	
	var total_price: int = (
		ItemDatabase.get_buy_price(
			item_id
		) * quantity
	)
	
	if not spend_gold(total_price):
		return false
	
	if not add_item(
		item_id,
		quantity
	):
		add_gold(total_price)
		return false
	
	return true


func sell_item(
	item_reference: String,
	quantity: int = 1
) -> bool:
	if quantity <= 0:
		return false
	
	var item_id: String = (
		ItemDatabase.resolve_item_id(
			item_reference
		)
	)
	
	if item_id == "":
		return false
	
	if not has_item(
		item_id,
		quantity
	):
		return false
	
	var total_value: int = (
		ItemDatabase.get_sell_price(
			item_id
		) * quantity
	)
	
	if not remove_item(
		item_id,
		quantity
	):
		return false
	
	add_gold(total_value)
	
	return true


func equip_item_to_member(
	member_id: String,
	item_reference: String
) -> bool:
	var new_item_id: String = (
		ItemDatabase.resolve_item_id(
			item_reference
		)
	)
	
	if new_item_id == "":
		return false
	
	var new_item_data: Dictionary = (
		ItemDatabase.get_item(
			new_item_id
		)
	)
	
	if new_item_data.is_empty():
		return false
	
	var equipment_slot: String = str(
		new_item_data.get(
			"slot",
			""
		)
	)
	
	if not equipment_slot in [
		"weapon",
		"armor",
		"shield"
	]:
		return false
	
	if not has_item(
		new_item_id,
		1
	):
		return false
	
	var previous_item_id: String = (
		PartyManager.get_member_equipped_item_id(
			member_id,
			equipment_slot
		)
	)
	
	if previous_item_id == new_item_id:
		return true
	
	if not PartyManager.equip_member_item(
		member_id,
		new_item_id
	):
		return false
	
	if not remove_item(
		new_item_id,
		1
	):
		PartyManager.equip_member_item(
			member_id,
			previous_item_id
		)
		
		return false
	
	if (
		previous_item_id != ""
		and ItemDatabase.can_store_in_inventory(
			previous_item_id
		)
	):
		add_item(
			previous_item_id,
			1
		)
	
	return true


func unequip_member_slot(
	member_id: String,
	equipment_slot: String
) -> bool:
	var previous_item_id: String = (
		PartyManager.get_member_equipped_item_id(
			member_id,
			equipment_slot
		)
	)
	
	if previous_item_id == "":
		return false
	
	if not PartyManager.unequip_member_slot(
		member_id,
		equipment_slot
	):
		return false
	
	if ItemDatabase.can_store_in_inventory(
		previous_item_id
	):
		add_item(
			previous_item_id,
			1
		)
	
	return true


func get_save_data() -> Dictionary:
	return {
		"gold": gold,
		"items": items.duplicate(true)
	}


func load_save_data(
	inventory_save_data: Dictionary
) -> void:
	items.clear()
	
	if inventory_save_data.is_empty():
		gold = max(
			0,
			GameState.hero_gold
		)
		
		sync_gold_to_game_state()
		inventory_changed.emit()
		gold_changed.emit(gold)
		return
	
	gold = max(
		0,
		int(
			inventory_save_data.get(
				"gold",
				GameState.hero_gold
			)
		)
	)
	
	var saved_items: Dictionary = (
		inventory_save_data.get(
			"items",
			{}
		)
	)
	
	for saved_item_reference in saved_items.keys():
		var item_id: String = (
			ItemDatabase.resolve_item_id(
				str(saved_item_reference)
			)
		)
		
		if item_id == "":
			continue
		
		if not ItemDatabase.can_store_in_inventory(
			item_id
		):
			continue
		
		var quantity: int = max(
			0,
			int(
				saved_items[
					saved_item_reference
				]
			)
		)
		
		if quantity <= 0:
			continue
		
		items[item_id] = quantity
	
	sync_gold_to_game_state()
	inventory_changed.emit()
	gold_changed.emit(gold)
