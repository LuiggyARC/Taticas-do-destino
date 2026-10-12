extends Node


const STARTING_VILLAGE_SHOP_ID := (
	"starting_village_general_store"
)

const STARTING_VILLAGE_HEALER_SHOP_ID := (
	"starting_village_healer_shop"
)

const SHOPS := {
	"starting_village_general_store": {
		"display_name": "O Fole & Fardo",
		"city_name": "Vila de Passos da Névoa",
		"stock_mode": "village_bridge_equipment",
		"max_buy_price_exclusive": 10,
		"allow_selling": true,
		"dialogues": {
			"welcome": {
				"speaker": "Vendedor",
				"text": "Bem-vindo!"
			},
			"purchase": {
				"speaker": "Vendedor",
				"text": "Uma ótima aquisição, guerreiro."
			},
			"sale": {
				"speaker": "Vendedor",
				"text": "Este seu item me parece valioso."
			}
		}
	},
	"starting_village_healer_shop": {
		"display_name": "Poções da Curandeira",
		"city_name": "Vila de Passos da Névoa",
		"stock_mode": "explicit",
		"unlock_event_id": "second_chance_healer_return",
		"item_ids": [
			"light_healing_potion",
			"bulls_strength_potion"
		],
		"stock_limits": {
			"light_healing_potion": 3,
			"bulls_strength_potion": 1
		},
		"allow_selling": false
	}
}

func has_shop(
	shop_id: String
) -> bool:
	return SHOPS.has(shop_id)


func get_shop(
	shop_id: String
) -> Dictionary:
	if not SHOPS.has(shop_id):
		return {}
	
	return SHOPS[shop_id].duplicate(true)


func get_shop_display_name(
	shop_id: String
) -> String:
	var shop_data: Dictionary = get_shop(
		shop_id
	)
	
	return str(
		shop_data.get(
			"display_name",
			"Loja"
		)
	)


func get_shop_city_name(
	shop_id: String
) -> String:
	var shop_data: Dictionary = get_shop(
		shop_id
	)
	
	return str(
		shop_data.get(
			"city_name",
			""
		)
	)


func shop_allows_selling(
	shop_id: String
) -> bool:
	var shop_data: Dictionary = get_shop(
		shop_id
	)
	
	return bool(
		shop_data.get(
			"allow_selling",
			true
		)
	)


func get_shop_stock(
	shop_id: String
) -> Array[Dictionary]:
	var shop_data: Dictionary = get_shop(
		shop_id
	)
	
	if shop_data.is_empty():
		return []
	
	var unlock_event_id: String = str(
		shop_data.get(
			"unlock_event_id",
			""
		)
	)
	
	if (
		unlock_event_id != ""
		and not SaveManager.has_completed_story_event(
			unlock_event_id
		)
	):
		return []
	
	var stock_mode: String = str(
		shop_data.get(
			"stock_mode",
			"explicit"
		)
	)
	
	match stock_mode:
		"village_bridge_equipment":
			if SaveManager.has_completed_story_event("emerald_bridge_village_return"):
				return get_bridge_village_stock()
			return get_basic_village_equipment_stock(10)
		"all_equipment":
			return get_all_equipment_stock()
		
		"basic_village_equipment":
			var maximum_price: int = int(
				shop_data.get(
					"max_buy_price_exclusive",
					10
				)
			)
			
			return get_basic_village_equipment_stock(
				maximum_price
			)
		
		"explicit":
			var available_stock: Array[Dictionary] = []
			var listed_items: Array[Dictionary] = (
				get_explicit_stock(
					shop_data.get(
						"item_ids",
						[]
					)
				)
			)
			
			for item_data in listed_items:
				var item_id: String = str(
					item_data.get(
						"id",
						""
					)
				)
				
				var remaining: int = (
					get_remaining_stock(
						shop_id,
						item_id
					)
				)
				
				if remaining == 0:
					continue
				
				if remaining > 0:
					item_data["quantity"] = remaining
				
				available_stock.append(
					item_data
				)
			
			return available_stock
		
		_:
			return []


func get_all_equipment_stock() -> Array[Dictionary]:
	var stock: Array[Dictionary] = []
	
	var all_items: Array[Dictionary] = (
		ItemDatabase.get_all_items()
	)
	
	for item_data in all_items:
		var item_id: String = str(
			item_data.get(
				"id",
				""
			)
		)
		
		var item_type: String = str(
			item_data.get(
				"item_type",
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
		
		if not item_type in [
			"weapon",
			"armor",
			"shield"
		]:
			continue
		
		if buy_price <= 0:
			continue
		
		if not ItemDatabase.can_store_in_inventory(
			item_id
		):
			continue
		
		stock.append(
			item_data
		)
	
	return stock


func get_bridge_village_stock() -> Array[Dictionary]:
	var stock: Array[Dictionary] = get_all_equipment_stock()
	for item_id in ["minor_healing_potion", "antidote"]:
		if ItemDatabase.has_item(item_id) and ItemDatabase.can_store_in_inventory(item_id):
			stock.append(ItemDatabase.get_item(item_id))
	return stock


func get_explicit_stock(
	item_ids: Array
) -> Array[Dictionary]:
	var stock: Array[Dictionary] = []
	
	for item_reference in item_ids:
		var item_id: String = (
			ItemDatabase.resolve_item_id(
				str(item_reference)
			)
		)
		
		if item_id == "":
			continue
		
		var item_data: Dictionary = (
			ItemDatabase.get_item(
				item_id
			)
		)
		
		if item_data.is_empty():
			continue
		
		if not ItemDatabase.can_store_in_inventory(
			item_id
		):
			continue
		
		if int(
			item_data.get(
				"buy_price",
				0
			)
		) <= 0:
			continue
		
		stock.append(
			item_data
		)
	
	return stock
func get_shop_dialogue(
	shop_id: String,
	dialogue_id: String
) -> Dictionary:
	var shop_data: Dictionary = get_shop(
		shop_id
	)
	
	if shop_data.is_empty():
		return {}
	
	var dialogues: Dictionary = (
		shop_data.get(
			"dialogues",
			{}
		)
	)
	
	if not dialogues.has(dialogue_id):
		return {}
	
	var dialogue_data: Dictionary = (
		dialogues.get(
			dialogue_id,
			{}
		)
	)
	
	return dialogue_data.duplicate(true)
func get_basic_village_equipment_stock(
	maximum_price_exclusive: int
) -> Array[Dictionary]:
	var stock: Array[Dictionary] = []
	
	var all_items: Array[Dictionary] = (
		ItemDatabase.get_all_items()
	)
	
	for item_data in all_items:
		var item_id: String = str(
			item_data.get(
				"id",
				""
			)
		)
		
		var item_type: String = str(
			item_data.get(
				"item_type",
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
		
		# A vila inicial vende somente armas
		# e armaduras simples.
		if not item_type in [
			"weapon",
			"armor"
		]:
			continue
		
		if buy_price <= 0:
			continue
		
		if buy_price >= maximum_price_exclusive:
			continue
		
		if not ItemDatabase.can_store_in_inventory(
			item_id
		):
			continue
		
		stock.append(
			item_data
		)
	
	return stock
func get_remaining_stock(
	shop_id: String,
	item_id: String
) -> int:
	var shop_data: Dictionary = get_shop(
		shop_id
	)
	
	var stock_limits: Dictionary = (
		shop_data.get(
			"stock_limits",
			{}
		)
	)
	
	if not stock_limits.has(item_id):
		return -1
	
	var initial_quantity: int = int(
		stock_limits[item_id]
	)
	
	var save_data: Dictionary = (
		SaveManager.read_save_data(
			SaveManager.get_active_save_path()
		)
	)
	
	var all_purchases: Dictionary = (
		save_data.get(
			"shop_purchases",
			{}
		)
	)
	
	var shop_purchases: Dictionary = (
		all_purchases.get(
			shop_id,
			{}
		)
	)
	
	var purchased_quantity: int = int(
		shop_purchases.get(
			item_id,
			0
		)
	)
	
	return maxi(
		0,
		initial_quantity - purchased_quantity
	)
func record_purchase(
	shop_id: String,
	item_id: String
) -> bool:
	var remaining: int = (
		get_remaining_stock(
			shop_id,
			item_id
		)
	)
	
	# -1 significa estoque ilimitado.
	if remaining < 0:
		return true
	
	if remaining == 0:
		return false
	
	var save_path: String = (
		SaveManager.get_active_save_path()
	)
	
	var save_data: Dictionary = (
		SaveManager.read_save_data(
			save_path
		)
	)
	
	if save_data.is_empty():
		return false
	
	var all_purchases: Dictionary = (
		save_data.get(
			"shop_purchases",
			{}
		)
	)
	
	var shop_purchases: Dictionary = (
		all_purchases.get(
			shop_id,
			{}
		)
	)
	
	shop_purchases[item_id] = (
		int(
			shop_purchases.get(
				item_id,
				0
			)
		)
		+ 1
	)
	
	all_purchases[shop_id] = (
		shop_purchases
	)
	
	save_data["shop_purchases"] = (
		all_purchases
	)
	
	return SaveManager.write_save_data(
		save_path,
		save_data
	)
