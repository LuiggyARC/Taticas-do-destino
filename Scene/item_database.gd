extends Node


const LEGACY_ITEM_ALIASES := {
	"soco": "unarmed",
	"adaga": "dagger",
	"espada curta": "short_sword",
	"espada longa": "long_sword",
	"espada bastarda": "bastard_sword",
	"machado de batalha": "battle_axe",
	"cimitarra": "scimitar",
	"martelo de combate": "warhammer",
	"martelo de guerra": "great_warhammer",
	"lança curta": "short_spear",
	"lanca curta": "short_spear",
	"lança longa": "long_spear",
	"lanca longa": "long_spear",
	"arco curto": "short_bow",
	"arco longo": "long_bow",
	"arco composto": "composite_bow",
	"besta pequena": "light_crossbow",
	"besta grande": "heavy_crossbow",
	"funda": "sling",
	"nenhuma": "no_armor",
	"roupa comum": "common_clothes",
	"armadura acolchoada": "padded_armor",
	"armadura de couro": "leather_armor",
	"couro batido": "studded_leather",
	"camisão de malha": "chain_shirt",
	"camisao de malha": "chain_shirt",
	"peitoral de aço": "steel_breastplate",
	"peitoral de aco": "steel_breastplate",
	"cota de malha": "chainmail",
	"armadura completa": "full_plate",
	"nenhum": "no_shield",
	"broquel": "buckler",
	"escudo leve": "light_shield",
	"escudo pesado": "heavy_shield",
	"poção de cura menor": "minor_healing_potion",
	"pocao de cura menor": "minor_healing_potion",
	"antídoto": "antidote",
	"antidoto": "antidote",
	"poção de cura leve": "light_healing_potion",
	"pocao de cura leve": "light_healing_potion",
	"poção de força do touro": "bulls_strength_potion",
	"pocao de forca do touro": "bulls_strength_potion",
}


const ITEMS := {
	"unarmed": {
		"id": "unarmed",
		"display_name": "Soco",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 0,
		"sell_price": 0,
		"description": "Ataque desarmado.",
		"inventory_allowed": false,
		"stackable": false,
		"weapon_type": "melee",
		"category": "desarmado",
		"damage_dice": 3,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"dagger": {
		"id": "dagger",
		"display_name": "Adaga",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 2,
		"sell_price": 1,
		"description": "Uma lâmina pequena e leve.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "adaga",
		"damage_dice": 4,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"short_sword": {
		"id": "short_sword",
		"display_name": "Espada Curta",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 10,
		"sell_price": 5,
		"description": "Uma espada leve e rápida.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "espada",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"long_sword": {
		"id": "long_sword",
		"display_name": "Espada Longa",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 15,
		"sell_price": 7,
		"description": "Uma espada equilibrada e confiável.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "espada",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"bastard_sword": {
		"id": "bastard_sword",
		"display_name": "Espada Bastarda",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 35,
		"sell_price": 17,
		"description": "Uma espada pesada usada com as duas mãos.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "espada",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},

	"battle_axe": {
		"id": "battle_axe",
		"display_name": "Machado de Batalha",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 0,
		"sell_price": 0,
		"description": "O machado de batalha de Kasum.",
		"inventory_allowed": false,
		"stackable": false,
		"weapon_type": "melee",
		"category": "machado",
		"damage_dice": 12,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"scimitar": {
		"id": "scimitar",
		"display_name": "Cimitarra",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 18,
		"sell_price": 9,
		"description": "Uma lâmina curva com maior chance de crítico.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "espada",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 18,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"warhammer": {
		"id": "warhammer",
		"display_name": "Martelo de Combate",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 12,
		"sell_price": 6,
		"description": "Um martelo próprio para combate.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "martelo",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"great_warhammer": {
		"id": "great_warhammer",
		"display_name": "Martelo de Guerra",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 30,
		"sell_price": 15,
		"description": "Um grande martelo usado com as duas mãos.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "martelo",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"short_spear": {
		"id": "short_spear",
		"display_name": "Lança Curta",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 6,
		"sell_price": 3,
		"description": "Uma lança curta usada por soldados.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "lanca",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"long_spear": {
		"id": "long_spear",
		"display_name": "Lança Longa",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 14,
		"sell_price": 7,
		"description": "Uma lança de maior alcance.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "melee",
		"category": "lanca",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 3.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"short_bow": {
		"id": "short_bow",
		"display_name": "Arco Curto",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 25,
		"sell_price": 12,
		"description": "Um arco leve para ataques a distância.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "ranged",
		"category": "arco",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 12.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"long_bow": {
		"id": "long_bow",
		"display_name": "Arco Longo",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 50,
		"sell_price": 25,
		"description": "Um arco de grande alcance.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "ranged",
		"category": "arco",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 18.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"composite_bow": {
		"id": "composite_bow",
		"display_name": "Arco Composto",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 75,
		"sell_price": 37,
		"description": "Um arco reforçado e poderoso.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "ranged",
		"category": "arco",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 24.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"light_crossbow": {
		"id": "light_crossbow",
		"display_name": "Besta Pequena",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 30,
		"sell_price": 15,
		"description": "Uma besta compacta.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "ranged",
		"category": "besta",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 9.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"heavy_crossbow": {
		"id": "heavy_crossbow",
		"display_name": "Besta Grande",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 50,
		"sell_price": 25,
		"description": "Uma besta pesada de grande impacto.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "ranged",
		"category": "besta",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 12.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true
	},
	
	"sling": {
		"id": "sling",
		"display_name": "Funda",
		"item_type": "weapon",
		"slot": "weapon",
		"buy_price": 1,
		"sell_price": 0,
		"description": "Uma arma simples para lançar pedras.",
		"inventory_allowed": true,
		"stackable": false,
		"weapon_type": "ranged",
		"category": "funda",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 12.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false
	},
	
	"no_armor": {
		"id": "no_armor",
		"display_name": "Nenhuma",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 0,
		"sell_price": 0,
		"description": "Nenhuma armadura equipada.",
		"inventory_allowed": false,
		"stackable": false,
		"armor_bonus": 0,
		"max_dex_bonus": 99,
		"armor_check_penalty": 0,
		"spell_failure_chance": 0,
		"movement_penalty": 0.0,
		"armor_type": "none"
	},
	
	"common_clothes": {
		"id": "common_clothes",
		"display_name": "Roupa Comum",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 1,
		"sell_price": 0,
		"description": "Roupas sem proteção adicional.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 0,
		"max_dex_bonus": 99,
		"armor_check_penalty": 0,
		"spell_failure_chance": 0,
		"movement_penalty": 0.0,
		"armor_type": "none"
	},
	
	"padded_armor": {
		"id": "padded_armor",
		"display_name": "Armadura Acolchoada",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 5,
		"sell_price": 2,
		"description": "Proteção leve de tecido acolchoado.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 1,
		"max_dex_bonus": 8,
		"armor_check_penalty": 0,
		"spell_failure_chance": 5,
		"movement_penalty": 0.0,
		"armor_type": "light"
	},
		"hide_jerkin": {
		"id": "hide_jerkin",
		"display_name": "Gibão de Peles",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 10,
		"sell_price": 5,
		"description": (
			"Uma proteção leve confeccionada com "
			+ "peles resistentes."
		),
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 2,
		"max_dex_bonus": 4,
		"armor_check_penalty": 0,
		"spell_failure_chance": 10,
		"movement_penalty": 0.0,
		"armor_type": "light"
	},
	"leather_armor": {
		"id": "leather_armor",
		"display_name": "Armadura de Couro",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 10,
		"sell_price": 5,
		"description": "Armadura leve de couro tratado.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 2,
		"max_dex_bonus": 6,
		"armor_check_penalty": 0,
		"spell_failure_chance": 10,
		"movement_penalty": 0.0,
		"armor_type": "light"
	},
	
	"studded_leather": {
		"id": "studded_leather",
		"display_name": "Couro Batido",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 20,
		"sell_price": 10,
		"description": "Couro reforçado com peças metálicas.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 3,
		"max_dex_bonus": 5,
		"armor_check_penalty": -1,
		"spell_failure_chance": 15,
		"movement_penalty": 0.0,
		"armor_type": "light"
	},
	
	"chain_shirt": {
		"id": "chain_shirt",
		"display_name": "Camisão de Malha",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 35,
		"sell_price": 17,
		"description": "Malha com proteção e mobilidade moderadas.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 4,
		"max_dex_bonus": 3,
		"armor_check_penalty": -2,
		"spell_failure_chance": 20,
		"movement_penalty": 1.5,
		"armor_type": "medium"
	},
	
	"steel_breastplate": {
		"id": "steel_breastplate",
		"display_name": "Peitoral de Aço",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 60,
		"sell_price": 30,
		"description": "Um resistente peitoral de aço.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 5,
		"max_dex_bonus": 2,
		"armor_check_penalty": -4,
		"spell_failure_chance": 25,
		"movement_penalty": 1.5,
		"armor_type": "medium"
	},
	
	"chainmail": {
		"id": "chainmail",
		"display_name": "Cota de Malha",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 80,
		"sell_price": 40,
		"description": "Uma pesada proteção de anéis metálicos.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 6,
		"max_dex_bonus": 2,
		"armor_check_penalty": -5,
		"spell_failure_chance": 30,
		"movement_penalty": 3.0,
		"armor_type": "heavy"
	},
	
	"full_plate": {
		"id": "full_plate",
		"display_name": "Armadura Completa",
		"item_type": "armor",
		"slot": "armor",
		"buy_price": 150,
		"sell_price": 75,
		"description": "Uma armadura pesada de placas completas.",
		"inventory_allowed": true,
		"stackable": false,
		"armor_bonus": 8,
		"max_dex_bonus": 1,
		"armor_check_penalty": -6,
		"spell_failure_chance": 35,
		"movement_penalty": 3.0,
		"armor_type": "heavy"
	},
	
	"no_shield": {
		"id": "no_shield",
		"display_name": "Nenhum",
		"item_type": "shield",
		"slot": "shield",
		"buy_price": 0,
		"sell_price": 0,
		"description": "Nenhum escudo equipado.",
		"inventory_allowed": false,
		"stackable": false,
		"shield_bonus": 0,
		"movement_penalty": 0.0
	},
	
	"buckler": {
		"id": "buckler",
		"display_name": "Broquel",
		"item_type": "shield",
		"slot": "shield",
		"buy_price": 8,
		"sell_price": 4,
		"description": "Um pequeno escudo preso ao braço.",
		"inventory_allowed": true,
		"stackable": false,
		"shield_bonus": 1,
		"movement_penalty": 0.0
	},
	
	"light_shield": {
		"id": "light_shield",
		"display_name": "Escudo Leve",
		"item_type": "shield",
		"slot": "shield",
		"buy_price": 12,
		"sell_price": 6,
		"description": "Um escudo leve e fácil de manejar.",
		"inventory_allowed": true,
		"stackable": false,
		"shield_bonus": 1,
		"movement_penalty": 0.0
	},
	
	"heavy_shield": {
		"id": "heavy_shield",
		"display_name": "Escudo Pesado",
		"item_type": "shield",
		"slot": "shield",
		"buy_price": 25,
		"sell_price": 12,
		"description": "Um escudo pesado com maior proteção.",
		"inventory_allowed": true,
		"stackable": false,
		"shield_bonus": 2,
		"movement_penalty": 1.5
	},
	
	"minor_healing_potion": {
		"id": "minor_healing_potion",
		"display_name": "Poção de Cura Menor",
		"item_type": "consumable",
		"slot": "",
		"buy_price": 15,
		"sell_price": 7,
		"description": "Recupera uma pequena quantidade de vida.",
		"inventory_allowed": true,
		"stackable": true,
		"effect_type": "healing",
		"healing_dice": 8,
		"healing_dice_count": 1,
		"healing_bonus": 1
	},
	"light_healing_potion": {
		"id": "light_healing_potion",
		"display_name": "Poção de Cura Leve",
		"item_type": "consumable",
		"slot": "",
		"buy_price": 15,
		"sell_price": 7,
		"description": "Recupera 1d8+1 pontos de vida.",
		"inventory_allowed": true,
		"stackable": true,
		"effect_type": "healing",
		"healing_dice": 8,
		"healing_dice_count": 1,
		"healing_bonus": 1
},
	"bulls_strength_potion": {
		"id": "bulls_strength_potion",
		"display_name": "Poção de Força do Touro",
		"item_type": "consumable",
		"slot": "",
		"buy_price": 25,
		"sell_price": 12,
		"description": "Concede +4 de Força temporariamente.",
		"inventory_allowed": true,
		"stackable": true,
		"effect_type": "buff_strength",
		"strength_bonus": 4,
		"duration_turns": 10
},
	"antidote": {
		"id": "antidote",
		"display_name": "Antídoto",
		"item_type": "consumable",
		"slot": "",
		"buy_price": 10,
		"sell_price": 5,
		"description": "Neutraliza efeitos de veneno.",
		"inventory_allowed": true,
		"stackable": true,
		"effect_type": "remove_poison"
	}
}


func has_item(
	item_id: String
) -> bool:
	return ITEMS.has(item_id)


func get_item(
	item_id: String
) -> Dictionary:
	if not ITEMS.has(item_id):
		return {}
	
	return ITEMS[item_id].duplicate(true)


func get_all_items() -> Array[Dictionary]:
	var item_list: Array[Dictionary] = []
	
	for item_id in ITEMS.keys():
		item_list.append(
			get_item(str(item_id))
		)
	
	return item_list


func get_items_by_type(
	item_type: String
) -> Array[Dictionary]:
	var filtered_items: Array[Dictionary] = []
	
	for item_id in ITEMS.keys():
		var item_data: Dictionary = (
			get_item(str(item_id))
		)
		
		if str(
			item_data.get("item_type", "")
		) != item_type:
			continue
		
		filtered_items.append(item_data)
	
	return filtered_items


func resolve_item_id(
	item_reference: String,
	expected_type: String = ""
) -> String:
	var clean_reference: String = (
		item_reference.strip_edges()
	)
	
	if clean_reference == "":
		return get_empty_item_id(
			expected_type
		)
	
	if ITEMS.has(clean_reference):
		var direct_item: Dictionary = (
			ITEMS[clean_reference]
		)
		
		if (
			expected_type == ""
			or str(
				direct_item.get(
					"item_type",
					""
				)
			) == expected_type
		):
			return clean_reference
	
	var normalized_reference: String = (
		clean_reference.to_lower()
	)
	
	if LEGACY_ITEM_ALIASES.has(
		normalized_reference
	):
		var alias_item_id: String = str(
			LEGACY_ITEM_ALIASES[
				normalized_reference
			]
		)
		
		var alias_item: Dictionary = (
			ITEMS.get(
				alias_item_id,
				{}
			)
		)
		
		if (
			expected_type == ""
			or str(
				alias_item.get(
					"item_type",
					""
				)
			) == expected_type
		):
			return alias_item_id
	
	for item_id in ITEMS.keys():
		var item_data: Dictionary = ITEMS[item_id]
		
		var display_name: String = str(
			item_data.get(
				"display_name",
				""
			)
		).strip_edges().to_lower()
		
		if display_name != normalized_reference:
			continue
		
		if (
			expected_type != ""
			and str(
				item_data.get(
					"item_type",
					""
				)
			) != expected_type
		):
			continue
		
		return str(item_id)
	
	return ""


func get_empty_item_id(
	item_type: String
) -> String:
	match item_type:
		"weapon":
			return "unarmed"
		
		"armor":
			return "no_armor"
		
		"shield":
			return "no_shield"
		
		_:
			return ""


func get_item_compatible(
	item_reference: String,
	expected_type: String = ""
) -> Dictionary:
	var item_id: String = resolve_item_id(
		item_reference,
		expected_type
	)
	
	return get_item(item_id)


func get_display_name(
	item_reference: String,
	expected_type: String = ""
) -> String:
	var item_data: Dictionary = (
		get_item_compatible(
			item_reference,
			expected_type
		)
	)
	
	if item_data.is_empty():
		return item_reference
	
	return str(
		item_data.get(
			"display_name",
			item_reference
		)
	)


func get_buy_price(
	item_reference: String
) -> int:
	var item_data: Dictionary = (
		get_item_compatible(
			item_reference
		)
	)
	
	return int(
		item_data.get(
			"buy_price",
			0
		)
	)


func get_sell_price(
	item_reference: String
) -> int:
	var item_data: Dictionary = (
		get_item_compatible(
			item_reference
		)
	)
	
	return int(
		item_data.get(
			"sell_price",
			0
		)
	)


func can_store_in_inventory(
	item_reference: String
) -> bool:
	var item_data: Dictionary = (
		get_item_compatible(
			item_reference
		)
	)
	
	return bool(
		item_data.get(
			"inventory_allowed",
			false
		)
	)


func is_stackable(
	item_reference: String
) -> bool:
	var item_data: Dictionary = (
		get_item_compatible(
			item_reference
		)
	)
	
	return bool(
		item_data.get(
			"stackable",
			false
		)
	)
