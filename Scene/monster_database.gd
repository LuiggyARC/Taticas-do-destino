extends Node

var monsters: Dictionary = {
	"Goblin Guerreiro": {
		"display_name": "Goblin Guerreiro",
		"creature_type": "Humanoide",
		"subtype": "Goblin",
		"size": "Pequeno",
		
		"max_hp": 6,
		"hp": 6,
		"initiative_bonus": 1,
		"max_movement_meters": 9.0,
		
		"armor_class": 13,
		"touch_armor_class": 12,
		"flat_footed_armor_class": 13,
		"base_attack_bonus": 2,
		
		"equipped_weapon": "Adaga",
		"weapon_type": "melee",
		"damage_dice": 2,
		"damage_dice_count": 1,
		"damage_bonus": 0,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Armadura de Acochoada",
		"equipped_shield": "Escudo Leve",
		
		"strength": 11,
		"dexterity": 13,
		"constitution": 12,
		"intelligence": 10,
		"wisdom": 9,
		"charisma": 6,
		
		"fortitude_bonus": 3,
		"reflex_bonus": 1,
		"will_bonus": -1,
		"observe_bonus": -1,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 10,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [],
		"secondary_attacks": [],
		
		"xp_reward": 100,
		"gold_reward": 3
	},
	
	"Goblin Dardeiro": {
		"display_name": "Goblin Dardeiro",
		"creature_type": "Humanoide",
		"subtype": "Goblin",
		"size": "Pequeno",
		
		"max_hp": 7,
		"hp": 7,
		"initiative_bonus": 1,
		"max_movement_meters": 9.0,
		
		"armor_class": 2,
		"touch_armor_class": 12,
		"flat_footed_armor_class": 12,
		"base_attack_bonus": 2,
		
		"equipped_weapon": "Dardo",
		"weapon_type": "ranged",
		"damage_dice": 3,
		"damage_dice_count": 1,
		"damage_bonus": 0,
		"weapon_range_meters": 4.5,
		
		"equipped_armor": "Armadura de Couro",
		"equipped_shield": "Nenhum",
		
		"strength": 11,
		"dexterity": 13,
		"constitution": 12,
		"intelligence": 10,
		"wisdom": 9,
		"charisma": 6,
		
		"fortitude_bonus": 3,
		"reflex_bonus": 1,
		"will_bonus": -1,
		"observe_bonus": -1,
		
		"ai_behavior": "ranged",
		"intelligence_score": 10,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [],
		"secondary_attacks": [],
		
		"xp_reward": 100,
		"gold_reward": 2
	},
	
	"Gnoll": {
		"display_name": "Gnoll",
		"creature_type": "Humanoide",
		"subtype": "Gnoll",
		"size": "Médio",
		
		"max_hp": 12,
		"hp": 12,
		"initiative_bonus": 0,
		"max_movement_meters": 9.0,
		
		"armor_class": 15,
		"touch_armor_class": 10,
		"flat_footed_armor_class": 15,
		"base_attack_bonus": 3,
		
		"equipped_weapon": "Machado de Batalha",
		"weapon_type": "melee",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"damage_bonus": 2,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Gibão de Peles",
		"equipped_shield": "Nenhum",
		
		"strength": 15,
		"dexterity": 10,
		"constitution": 13,
		"intelligence": 8,
		"wisdom": 11,
		"charisma": 8,
		
		"fortitude_bonus": 4,
		"reflex_bonus": 0,
		"will_bonus": 0,
		"observe_bonus": 0,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 8,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [],
		"secondary_attacks": [],
		
		"xp_reward": 150,
		"gold_reward": 5
	},

	"Bugbear Guerreiro": {
		"display_name": "Bugbear Guerreiro",
		"creature_type": "Humanoide",
		"subtype": "Goblinoide",
		"size": "Médio",
		
		"max_hp": 16,
		"hp": 16,
		"initiative_bonus": 1,
		"max_movement_meters": 9.0,
		
		"armor_class": 17,
		"touch_armor_class": 11,
		"flat_footed_armor_class": 16,
		"base_attack_bonus": 5,
		
		"equipped_weapon": "Maça",
		"weapon_type": "melee",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"damage_bonus": 2,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Armadura de Couro Batido",
		"equipped_shield": "Escudo Leve",
		
		"strength": 15,
		"dexterity": 12,
		"constitution": 13,
		"intelligence": 10,
		"wisdom": 10,
		"charisma": 9,
		
		"fortitude_bonus": 4,
		"reflex_bonus": 1,
		"will_bonus": 0,
		"observe_bonus": 0,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 10,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [],
		"secondary_attacks": [],
		
		"xp_reward": 250,
		"gold_reward": 8
	},
	"Rato": {
		"display_name": "Rato",
		"creature_type": "Animal",
		"subtype": "",
		"size": "Miúdo",
		
		"max_hp": 1,
		"hp": 1,
		"initiative_bonus": 2,
		"max_movement_meters": 4.5,
		
		"armor_class": 14,
		"touch_armor_class": 14,
		"flat_footed_armor_class": 12,
		"base_attack_bonus": 0,
		
		"equipped_weapon": "Mordida",
		"weapon_type": "melee",
		"damage_dice": 3,
		"damage_dice_count": 1,
		"damage_bonus": -4,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "",
		"equipped_shield": "",
		
		"strength": 2,
		"dexterity": 15,
		"constitution": 10,
		"intelligence": 2,
		"wisdom": 12,
		"charisma": 2,
		
		"fortitude_bonus": 2,
		"reflex_bonus": 4,
		"will_bonus": 1,
		"observe_bonus": 1,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 2,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [
			"Visão na penumbra",
			"Faro"
		],
		"secondary_attacks": [],
		
		"xp_reward": 50,
		"gold_reward": 0
	},

	"Rato Atroz": {
		"display_name": "Rato Atroz",
		"creature_type": "Animal",
		"subtype": "",
		"size": "Pequeno",
		
		"max_hp": 14,
		"hp": 14,
		"initiative_bonus": 3,
		"max_movement_meters": 12.0,
		
		"armor_class": 16,
		"touch_armor_class": 14,
		"flat_footed_armor_class": 12,
		"base_attack_bonus": 0,
		
		"equipped_weapon": "Mordida",
		"weapon_type": "melee",
		"damage_dice": 4,
		"damage_dice_count": 1,
		"damage_bonus": 0,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "",
		"equipped_shield": "",
		
		"strength": 10,
		"dexterity": 18,
		"constitution": 12,
		"intelligence": 1,
		"wisdom": 12,
		"charisma": 4,
		
		"fortitude_bonus": 3,
		"reflex_bonus": 5,
		"will_bonus": 3,
		"observe_bonus": 4,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 1,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [
			"Visão na penumbra",
			"Faro",
			"Doença: Febre do lixo"
		],
		"secondary_attacks": [],
		
		"xp_reward": 200,
		"gold_reward": 0
	},
	"Carniçal": {
		"display_name": "Carniçal",
		"creature_type": "Morto-vivo",
		"subtype": "",
		"size": "Médio",
		
		"max_hp": 13,
		"hp": 13,
		"initiative_bonus": 2,
		"max_movement_meters": 9.0,
		
		"armor_class": 14,
		"touch_armor_class": 12,
		"flat_footed_armor_class": 12,
		"base_attack_bonus": 2,
		
		"equipped_weapon": "Mordida",
		"weapon_type": "natural",
		"damage_dice": 4,
		"damage_dice_count": 1,
		"damage_bonus": 1,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Nenhuma",
		"equipped_shield": "Nenhum",
		
		"strength": 13,
		"dexterity": 15,
		"constitution": 10,
		"intelligence": 13,
		"wisdom": 14,
		"charisma": 12,
		
		"fortitude_bonus": 0,
		"reflex_bonus": 2,
		"will_bonus": 5,
		"observe_bonus": 2,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 13,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": ["paralysis"],
		"secondary_attacks": [
			{
				"name": "Garra",
				"damage_dice": 3,
				"damage_dice_count": 1,
				"damage_bonus": 1,
				"weapon_range_meters": 1.5
			},
			{
				"name": "Garra",
				"damage_dice": 3,
				"damage_dice_count": 1,
				"damage_bonus": 1,
				"weapon_range_meters": 1.5
			}
		],
		
		"paralysis_duration_dice": 4,
		"paralysis_duration_bonus": 1,
		"paralysis_save_dc": 11,
		"paralysis_save_type": "fortitude",
		"paralysis_immunity_races": ["Elfo"],
		
		"xp_reward": 200,
		"gold_reward": 0
	},
	
	"Lobo": {
		"display_name": "Lobo",
		"creature_type": "Animal",
		"subtype": "",
		"size": "Médio",
		
		"max_hp": 12,
		"hp": 12,
		"initiative_bonus": 2,
		"max_movement_meters": 12.0,
		
		"armor_class": 14,
		"touch_armor_class": 12,
		"flat_footed_armor_class": 12,
		"base_attack_bonus": 3,
		
		"equipped_weapon": "Mordida",
		"weapon_type": "natural",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"damage_bonus": 1,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Nenhuma",
		"equipped_shield": "Nenhum",
		
		"strength": 13,
		"dexterity": 15,
		"constitution": 15,
		"intelligence": 2,
		"wisdom": 12,
		"charisma": 6,
		
		"fortitude_bonus": 5,
		"reflex_bonus": 5,
		"will_bonus": 1,
		"observe_bonus": 3,
		
		"ai_behavior": "aggressive",
		"intelligence_score": 2,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": ["trip", "scent", "low_light_vision"],
		"secondary_attacks": [],
		"trip_bonus": 1,
		
		"xp_reward": 120,
		"gold_reward": 0
	},
		"Lobo da Ordem": {
		"display_name": "Lobo da Ordem",
		"creature_type": "Fera Mágica",
		"subtype": "",
		"size": "Médio",
		
		"max_hp": 13,
		"hp": 13,
		"initiative_bonus": 2,
		"max_movement_meters": 9.0,
		
		"armor_class": 14,
		"touch_armor_class": 12,
		"flat_footed_armor_class": 14,
		"base_attack_bonus": 4,
		
		"equipped_weapon": "Mordida Feroz",
		"weapon_type": "melee",
		"damage_dice": 3,
		"damage_dice_count": 1,
		"damage_bonus": 2,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Placas de Couro",
		"equipped_shield": "",
		
		"strength": 15,
		"dexterity": 15,
		"constitution": 15,
		"intelligence": 6,
		"wisdom": 14,
		"charisma": 10,
		
		"fortitude_bonus": 6,
		"reflex_bonus": 6,
		"will_bonus": 3,
		"observe_bonus": 6,
		
		"ai_behavior": "tactical_aggressive",
		"intelligence_score": 6,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [
			"darkvision_18m",
			"scent",
			"trip"
		],
		"secondary_attacks": [],
		"trip_bonus": 1,
		
		"xp_reward": 250,
		"gold_reward": 0
	},
	
	"Cultista": {
		"display_name": "Cultista",
		"creature_type": "Humanoide",
		"subtype": "Humano",
		"size": "Médio",
		
		"max_hp": 11,
		"hp": 11,
		"initiative_bonus": 1,
		"max_movement_meters": 9.0,
		
		"armor_class": 12,
		"touch_armor_class": 11,
		"flat_footed_armor_class": 12,
		"base_attack_bonus": 1,
		
		"equipped_weapon": "Adaga Cerimonial",
		"weapon_type": "melee",
		"damage_dice": 4,
		"damage_dice_count": 1,
		"damage_bonus": 1,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "Veste de Couro",
		"equipped_shield": "",
		
		"strength": 12,
		"dexterity": 13,
		"constitution": 12,
		"intelligence": 14,
				"can_cast_spells": true,
		"known_spells": [
			"Mísseis Mágicos"
		],
		"spellcasting_attribute": "intelligence",
		
		"spell_slots_level_1": 1,
		"max_spell_slots_level_1": 1,
		"wisdom": 15,
		"charisma": 14,
		
		"fortitude_bonus": 4,
		"reflex_bonus": 1,
		"will_bonus": 5,
		"observe_bonus": 2,
		
		"ai_behavior": "support_aggressive",
		"intelligence_score": 10,
		
		"can_use_potions": true,
		"potion_count": 1,
		"potion_heal_amount": 8,
		
		"can_use_buffs": true,
		"buff_available": true,
		
		"can_heal_self": true,
		"self_heal_uses": 1,
		"self_heal_amount": 8,
		"can_heal_allies": true,
		"healing_power": 8,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": true,
		
		"special_traits": [
			"minor_divine_casting"
		],
		"secondary_attacks": [],
		
		"xp_reward": 300,
		"gold_reward": 20
	},
	
	"Cão de Caça": {
		"display_name": "Cão de Caça",
		"creature_type": "Animal",
		"subtype": "",
		"size": "Médio",
		
		"max_hp": 13,
		"hp": 13,
		"initiative_bonus": 2,
		"max_movement_meters": 9.0,
		
		"armor_class": 15,
		"touch_armor_class": 12,
		"flat_footed_armor_class": 14,
		"base_attack_bonus": 1,
		
		"equipped_weapon": "Mordida",
		"weapon_type": "melee",
		"damage_dice": 3,
		"damage_dice_count": 1,
		"damage_bonus": 2,
		"weapon_range_meters": 1.5,
		
		"equipped_armor": "",
		"equipped_shield": "",
		
		"strength": 15,
		"dexterity": 15,
		"constitution": 15,
		"intelligence": 2,
		"wisdom": 12,
		"charisma": 6,
		
		"fortitude_bonus": 5,
		"reflex_bonus": 5,
		"will_bonus": 1,
		"observe_bonus": 5,
		
		"ai_behavior": "pack_hunter",
		"intelligence_score": 2,
		
		"can_use_potions": false,
		"potion_count": 0,
		"potion_heal_amount": 0,
		
		"can_use_buffs": false,
		"buff_available": false,
		
		"can_heal_self": false,
		"self_heal_uses": 0,
		"self_heal_amount": 0,
		"can_heal_allies": false,
		"healing_power": 0,
		
		"can_fly": false,
		"is_flying": false,
		"can_use_scenario": false,
		
		"special_traits": [
			"scent",
			"low_light_vision"
		],
		"secondary_attacks": [],
		
		"xp_reward": 200,
		"gold_reward": 0
	}
}


func get_monster_data(monster_name: String) -> Dictionary:
	if monsters.has(monster_name):
		return monsters[monster_name].duplicate(true)
	
	print("Monstro não encontrado no MonsterDatabase: ", monster_name)
	return {}


func has_monster(monster_name: String) -> bool:
	return monsters.has(monster_name)


func get_all_monster_names() -> Array:
	return monsters.keys()


func get_monsters_by_type(creature_type: String) -> Array:
	var result: Array = []
	
	for monster_name in monsters.keys():
		var monster_data: Dictionary = monsters[monster_name]
		
		if str(monster_data.get("creature_type", "")) == creature_type:
			result.append(monster_name)
	
	return result


func get_monsters_by_ai_behavior(ai_behavior: String) -> Array:
	var result: Array = []
	
	for monster_name in monsters.keys():
		var monster_data: Dictionary = monsters[monster_name]
		
		if str(monster_data.get("ai_behavior", "")) == ai_behavior:
			result.append(monster_name)
	
	return result
