extends Node

const LevelProgressionData = preload("res://Scene/level_progression.gd")


const MAX_ACTIVE_MEMBERS: int = 5
const MAX_MEMBER_LEVEL: int = 30
const HERO_MEMBER_ID: String = "hero"
const NPC_DATABASE_SCRIPT = preload(
	"res://Scene/npc_database.gd"
)

var members: Dictionary = {}
var active_party: Array[String] = []


func _ready() -> void:
	sync_hero_from_game_state()


func create_default_member(
	member_id: String,
	display_name: String,
	source_type: String = "npc"
) -> Dictionary:
	return {
		"id": member_id,
		"display_name": display_name,
		"source_type": source_type,
		"level": 1,
		"total_xp": 0,
		"xp_to_next_level": 1000,
		"current_hp": 10,
		"max_hp": 10,
		"class_name": "Sem Classe",
		"race_name": "Humano",
		"attributes": {
			"strength": 10,
			"dexterity": 10,
			"constitution": 10,
			"wisdom": 10,
			"intelligence": 10,
			"charisma": 10
		},
		"equipment": {
			"weapon": "Nenhum",
			"armor": "Roupa Comum",
			"shield": "Nenhum",
			"accessory": "Nenhum"
		},
		"personal_inventory": [],
		"feats": [],
		"features": [],
		"daily_powers_used": [],
		"available": true
	}

func get_total_xp_required_for_member_level(
	target_level: int
) -> int:
	return LevelProgressionData.xp_for_level(target_level)


func calculate_member_level_from_xp(
	total_xp: int
) -> int:
	var calculated_level: int = 1

	for target_level in range(
		2,
		MAX_MEMBER_LEVEL + 1
	):
		var required_xp: int = (
			get_total_xp_required_for_member_level(
				target_level
			)
		)

		if total_xp >= required_xp:
			calculated_level = target_level
		else:
			break

	return calculated_level


func get_member_xp_step_for_level(
	member_level: int
) -> int:
	if member_level >= MAX_MEMBER_LEVEL:
		return 0

	var current_level_start: int = (
		get_total_xp_required_for_member_level(
			member_level
		)
	)

	var next_level_start: int = (
		get_total_xp_required_for_member_level(
			member_level + 1
		)
	)

	return max(
		0,
		next_level_start - current_level_start
	)


func grant_xp_to_active_members(
	amount: int,
	excluded_member_id: String = "",
	additional_member_ids: Array[String] = []
) -> Array[String]:
	var reward_candidates: Array[String] = []
	for active_member_id in active_party:
		if not reward_candidates.has(active_member_id):
			reward_candidates.append(active_member_id)
	for additional_member_id in additional_member_ids:
		if not reward_candidates.has(additional_member_id):
			reward_candidates.append(additional_member_id)
	return grant_xp_to_selected_members(amount, reward_candidates, excluded_member_id)


func grant_xp_to_selected_members(
	amount: int,
	selected_member_ids: Array[String],
	excluded_member_id: String = ""
) -> Array[String]:
	var rewarded_member_ids: Array[String] = []
	if amount <= 0:
		return rewarded_member_ids

	for member_id in selected_member_ids:
		if member_id == excluded_member_id:
			continue
		if rewarded_member_ids.has(member_id):
			continue

		if not members.has(member_id):
			continue

		var member_data: Dictionary = (
			members[member_id].duplicate(true)
		)

		var is_available: bool = bool(
			member_data.get(
				"available",
				true
			)
		)

		if not is_available:
			continue

		var member_level: int = clampi(
			int(
				member_data.get(
					"level",
					1
				)
			),
			1,
			MAX_MEMBER_LEVEL
		)

		if member_level >= MAX_MEMBER_LEVEL:
			continue

		# Personagens cadastrados acima do nível 1
		# precisam começar pelo mínimo de XP correspondente
		# ao seu nível atual.
		var minimum_xp_for_current_level: int = (
			get_total_xp_required_for_member_level(
				member_level
			)
		)

		var current_total_xp: int = max(
			int(
				member_data.get(
					"total_xp",
					0
				)
			),
			minimum_xp_for_current_level
		)

		current_total_xp += amount

		var target_level: int = clampi(
			calculate_member_level_from_xp(
				current_total_xp
			),
			member_level,
			MAX_MEMBER_LEVEL
		)

		var pending_level_ups: int = max(
			0,
			target_level - member_level
		)

		member_data["total_xp"] = (
			current_total_xp
		)

		member_data["xp_to_next_level"] = (
			get_member_xp_step_for_level(
				member_level
			)
		)

		member_data["pending_level_ups"] = (
			pending_level_ups
		)

		members[member_id] = member_data

		rewarded_member_ids.append(
			member_id
		)

		print(
			str(
				member_data.get(
					"display_name",
					member_id
				)
			),
			" ganhou ",
			amount,
			" XP. XP total: ",
			current_total_xp,
			" | Evoluções pendentes: ",
			pending_level_ups
		)

	return rewarded_member_ids
func build_hero_member_data() -> Dictionary:
	var hero_data: Dictionary = create_default_member(
		HERO_MEMBER_ID,
		GameState.player_name,
		"hero"
	)
	
	hero_data["level"] = GameState.hero_level
	hero_data["total_xp"] = (
		GameState.hero_total_xp
	)
	
	hero_data["xp_to_next_level"] = (
		GameState.hero_xp_to_next_level
	)
	
	hero_data["current_hp"] = (
		GameState.hero_max_hp
	)
	hero_data["max_hp"] = (
		GameState.hero_max_hp
	)
	
	hero_data["class_name"] = (
		GameState.player_class
	)
	
	hero_data["race_name"] = (
		GameState.player_race
	)
	
	hero_data["attributes"] = {
		"strength": GameState.hero_strength,
		"dexterity": GameState.hero_dexterity,
		"constitution": GameState.hero_constitution,
		"wisdom": GameState.hero_wisdom,
		"intelligence": GameState.hero_intelligence,
		"charisma": GameState.hero_charisma
	}
	
	hero_data["equipment"] = {
		"weapon": (
			GameState.hero_equipped_weapon
		),
		"armor": (
			GameState.hero_equipped_armor
		),
		"shield": (
			GameState.hero_equipped_shield
		),
		"accessory": "Nenhum"
	}
	
	hero_data["feats"] = (
		GameState.hero_feats.duplicate(true)
	)
	
	hero_data["features"] = (
		GameState.hero_class_features.duplicate(true)
	)
	
	hero_data["known_spells"] = (
		GameState.hero_known_spells.duplicate(true)
	)
	
	hero_data["spell_slots_level_0"] = (
		GameState.hero_spell_slots_level_0
	)
	hero_data["spell_slots_level_1"] = (
		GameState.hero_spell_slots_level_1
	)
	hero_data["spell_slots_level_2"] = (
		GameState.hero_spell_slots_level_2
	)
	
	hero_data["max_spell_slots_level_0"] = (
		GameState.hero_max_spell_slots_level_0
	)
	hero_data["max_spell_slots_level_1"] = (
		GameState.hero_max_spell_slots_level_1
	)
	hero_data["max_spell_slots_level_2"] = (
		GameState.hero_max_spell_slots_level_2
	)
	
	return hero_data

func normalize_equipment_data(
	equipment_data: Dictionary
) -> Dictionary:
	var weapon_reference: String = str(
		equipment_data.get(
			"weapon_id",
			equipment_data.get(
				"weapon",
				"Soco"
			)
		)
	)
	
	var armor_reference: String = str(
		equipment_data.get(
			"armor_id",
			equipment_data.get(
				"armor",
				"Roupa Comum"
			)
		)
	)
	
	var shield_reference: String = str(
		equipment_data.get(
			"shield_id",
			equipment_data.get(
				"shield",
				"Nenhum"
			)
		)
	)
	
	var weapon_id: String = (
		ItemDatabase.resolve_item_id(
			weapon_reference,
			"weapon"
		)
	)
	
	var armor_id: String = (
		ItemDatabase.resolve_item_id(
			armor_reference,
			"armor"
		)
	)
	
	var shield_id: String = (
		ItemDatabase.resolve_item_id(
			shield_reference,
			"shield"
		)
	)
	
	if weapon_id == "":
		weapon_id = "unarmed"
	
	if armor_id == "":
		armor_id = "no_armor"
	
	if shield_id == "":
		shield_id = "no_shield"
	
	return {
		"weapon_id": weapon_id,
		"weapon": ItemDatabase.get_display_name(
			weapon_id,
			"weapon"
		),
		"armor_id": armor_id,
		"armor": ItemDatabase.get_display_name(
			armor_id,
			"armor"
		),
		"shield_id": shield_id,
		"shield": ItemDatabase.get_display_name(
			shield_id,
			"shield"
		),
		"accessory_id": str(
			equipment_data.get(
				"accessory_id",
				""
			)
		),
		"accessory": str(
			equipment_data.get(
				"accessory",
				"Nenhum"
			)
		)
	}


func normalize_member_equipment(
	member_data: Dictionary
) -> Dictionary:
	var normalized_member: Dictionary = (
		member_data.duplicate(true)
	)
	
	var equipment_data: Dictionary = (
		normalized_member.get(
			"equipment",
			{}
		)
	)
	
	normalized_member["equipment"] = (
		normalize_equipment_data(
			equipment_data
		)
	)
	
	return normalized_member



func sync_hero_from_game_state() -> void:
	var previous_hero_data: Dictionary = members.get(
		HERO_MEMBER_ID,
		{}
	)
	
	var hero_data: Dictionary = (
		build_hero_member_data()
	)
	
	if not previous_hero_data.is_empty():
		hero_data["daily_powers_used"] = (
			previous_hero_data.get("daily_powers_used", [])
		).duplicate()
		hero_data["personal_inventory"] = (
			previous_hero_data.get(
				"personal_inventory",
				[]
			)
		)
		
		var previous_current_hp: int = int(
			previous_hero_data.get(
				"current_hp",
				hero_data["max_hp"]
			)
		)
		
		hero_data["current_hp"] = clampi(
			previous_current_hp,
			0,
			int(hero_data["max_hp"])
		)
	
	hero_data = normalize_member_equipment(
		hero_data
	)
	
	members[HERO_MEMBER_ID] = hero_data
	
	if not active_party.has(HERO_MEMBER_ID):
		active_party.push_front(
			HERO_MEMBER_ID
		)


func register_member(
	member_data: Dictionary
) -> bool:
	var member_id: String = str(
		member_data.get(
			"id",
			""
		)
	).strip_edges()
	
	if member_id == "":
		push_warning(
			"Não foi possível registrar integrante sem ID."
		)
		
		return false
	
	var display_name: String = str(
		member_data.get(
			"display_name",
			member_id
		)
	).strip_edges()
	
	var source_type: String = str(
		member_data.get(
			"source_type",
			"npc"
		)
	)
	
	var normalized_data: Dictionary = (
		create_default_member(
			member_id,
			display_name,
			source_type
		)
	)
	
	for data_key in member_data.keys():
		normalized_data[data_key] = (
			member_data[data_key]
		)
	
	normalized_data = normalize_member_equipment(
		normalized_data
	)
	
	members[member_id] = normalized_data
	
	return true


func recruit_member(
	member_data: Dictionary
) -> bool:
	if not register_member(member_data):
		return false
	
	var member_id: String = str(
		member_data.get(
			"id",
			""
		)
	)
	
	if active_party.size() < MAX_ACTIVE_MEMBERS:
		add_member_to_active_party(
			member_id
		)
	
	return true


func has_member(
	member_id: String
) -> bool:
	return members.has(member_id)


func get_member(
	member_id: String
) -> Dictionary:
	var member_data: Dictionary = members.get(
		member_id,
		{}
	)
	
	return member_data.duplicate(true)


func is_daily_power_available(member_id: String, power_id: String) -> bool:
	if not members.has(member_id):
		return false
	var used: Array = members[member_id].get("daily_powers_used", [])
	return not used.has(power_id)


func consume_daily_power(member_id: String, power_id: String) -> bool:
	if not is_daily_power_available(member_id, power_id):
		return false
	var member_data: Dictionary = members[member_id]
	var used: Array = member_data.get("daily_powers_used", []).duplicate()
	used.append(power_id)
	member_data["daily_powers_used"] = used
	members[member_id] = member_data
	return true


func get_all_members() -> Array[Dictionary]:
	var all_members: Array[Dictionary] = []
	
	for member_id in members.keys():
		var member_data: Dictionary = (
			get_member(
				str(member_id)
			)
		)
		
		if member_data.is_empty():
			continue
		
		all_members.append(member_data)
	
	return all_members


func get_active_members() -> Array[Dictionary]:
	var active_members: Array[Dictionary] = []
	
	for member_id in active_party:
		var member_data: Dictionary = (
			get_member(member_id)
		)
		
		if member_data.is_empty():
			continue
		
		if not bool(
			member_data.get(
				"available",
				true
			)
		):
			continue
		
		active_members.append(member_data)
	
	return active_members


func add_member_to_active_party(
	member_id: String
) -> bool:
	if not members.has(member_id):
		return false
	
	if active_party.has(member_id):
		return true
	
	if active_party.size() >= MAX_ACTIVE_MEMBERS:
		return false
	
	active_party.append(member_id)
	
	return true


func remove_member_from_active_party(
	member_id: String
) -> bool:
	if member_id == HERO_MEMBER_ID:
		return false
	
	if not active_party.has(member_id):
		return false
	
	active_party.erase(member_id)
	
	return true


func update_member(
	member_id: String,
	updated_values: Dictionary
) -> bool:
	if not members.has(member_id):
		return false
	
	var member_data: Dictionary = members[member_id]
	
	for data_key in updated_values.keys():
		member_data[data_key] = (
			updated_values[data_key]
		)
	
	members[member_id] = member_data
	
	return true

func restore_active_party_after_rest() -> void:
	for member_id in active_party:
		if not members.has(member_id):
			continue
		
		var member_data: Dictionary = (
			members[member_id].duplicate(true)
		)
		member_data["daily_powers_used"] = []
		
		var maximum_hp: int = max(
			1,
			int(
				member_data.get(
					"max_hp",
					1
				)
			)
		)
		
		member_data["current_hp"] = (
			maximum_hp
		)
		
		for spell_level in range(3):
			var current_slots_key: String = (
				"spell_slots_level_"
				+ str(spell_level)
			)
			
			var maximum_slots_key: String = (
				"max_spell_slots_level_"
				+ str(spell_level)
			)
			
			var maximum_slots: int = max(
				0,
				int(
					member_data.get(
						maximum_slots_key,
						0
					)
				)
			)
			
			member_data[current_slots_key] = (
				maximum_slots
			)
		
		members[member_id] = member_data
		
		if member_id == HERO_MEMBER_ID:
			GameState.hero_spell_slots_level_0 = int(
				member_data.get(
					"spell_slots_level_0",
					0
				)
			)
			
			GameState.hero_spell_slots_level_1 = int(
				member_data.get(
					"spell_slots_level_1",
					0
				)
			)
			
			GameState.hero_spell_slots_level_2 = int(
				member_data.get(
					"spell_slots_level_2",
					0
				)
			)
			
			GameState.hero_max_spell_slots_level_0 = int(
				member_data.get(
					"max_spell_slots_level_0",
					0
				)
			)
			
			GameState.hero_max_spell_slots_level_1 = int(
				member_data.get(
					"max_spell_slots_level_1",
					0
				)
			)
			
			GameState.hero_max_spell_slots_level_2 = int(
				member_data.get(
					"max_spell_slots_level_2",
					0
				)
			)
			
			GameState.hero_known_spells = (
				member_data.get(
					"known_spells",
					[]
				)
			).duplicate(true)
	
	print(
		"Grupo ativo recuperado após o descanso."
	)

func reset_party() -> void:
	members.clear()
	active_party.clear()
	
	sync_hero_from_game_state()
func build_member_from_npc(
	npc_id: String
) -> Dictionary:
	var npc_data: Dictionary = (
		NPC_DATABASE_SCRIPT.get_npc_data(
			npc_id
		)
	)

	if npc_data.is_empty():
		push_warning(
			"Não foi possível converter o NPC: "
			+ npc_id
		)

		return {}

	var member_id: String = str(
		npc_data.get(
			"id",
			npc_id
		)
	)

	var display_name: String = str(
		npc_data.get(
			"display_name",
			npc_id
		)
	)

	var member_data: Dictionary = (
		create_default_member(
			member_id,
			display_name,
			"npc"
		)
	)

	var member_level: int = clampi(
		int(
			npc_data.get(
				"level",
				1
			)
		),
		1,
		MAX_MEMBER_LEVEL
	)

	var minimum_level_xp: int = (
		get_total_xp_required_for_member_level(
			member_level
		)
	)

	member_data["level"] = member_level

	member_data["total_xp"] = maxi(
		int(
			npc_data.get(
				"total_xp",
				minimum_level_xp
			)
		),
		minimum_level_xp
	)

	member_data["xp_to_next_level"] = int(
		npc_data.get(
			"xp_to_next_level",
			get_member_xp_step_for_level(
				member_level
			)
		)
	)

	member_data["pending_level_ups"] = int(
		npc_data.get(
			"pending_level_ups",
			0
		)
	)

	member_data["current_hp"] = int(
		npc_data.get(
			"hp",
			10
		)
	)

	member_data["max_hp"] = int(
		npc_data.get(
			"max_hp",
			10
		)
	)

	member_data["class_name"] = str(
		npc_data.get(
			"character_class",
			"Sem Classe"
		)
	)

	member_data["race_name"] = str(
		npc_data.get(
			"race",
			"Humano"
		)
	)

	member_data["size"] = str(
		npc_data.get(
			"size",
			"Médio"
		)
	)

	member_data["size_modifier"] = int(
		npc_data.get(
			"size_modifier",
			0
		)
	)

	member_data["favored_class"] = str(
		npc_data.get(
			"favored_class",
			"Qualquer"
		)
	)

	member_data["attributes"] = {
		"strength": int(
			npc_data.get(
				"strength",
				10
			)
		),
		"dexterity": int(
			npc_data.get(
				"dexterity",
				10
			)
		),
		"constitution": int(
			npc_data.get(
				"constitution",
				10
			)
		),
		"wisdom": int(
			npc_data.get(
				"wisdom",
				10
			)
		),
		"intelligence": int(
			npc_data.get(
				"intelligence",
				10
			)
		),
		"charisma": int(
			npc_data.get(
				"charisma",
				10
			)
		)
	}

	member_data["equipment"] = {
		"weapon": str(
			npc_data.get(
				"equipped_weapon",
				"Nenhum"
			)
		),
		"armor": str(
			npc_data.get(
				"equipped_armor",
				"Roupa Comum"
			)
		),
		"shield": str(
			npc_data.get(
				"equipped_shield",
				"Nenhum"
			)
		),
		"accessory": "Nenhum"
	}
	if member_id == "Kasum":
		member_data["starting_weapon_migrated"] = true

	member_data["feats"] = (
		npc_data.get(
			"feats",
			[]
		).duplicate(true)
	)

	member_data["race_traits"] = (
		npc_data.get(
			"race_traits",
			[]
		).duplicate(true)
	)

	member_data["class_features"] = (
		npc_data.get(
			"class_features",
			[]
		).duplicate(true)
	)

	var combined_features: Array = []

	for race_trait in member_data["race_traits"]:
		if not combined_features.has(
			race_trait
		):
			combined_features.append(
				race_trait
			)

	for class_feature in member_data["class_features"]:
		if not combined_features.has(
			class_feature
		):
			combined_features.append(
				class_feature
			)

	var additional_features: Array = (
		npc_data.get(
			"features",
			[]
		).duplicate(true)
	)

	for additional_feature in additional_features:
		if not combined_features.has(
			additional_feature
		):
			combined_features.append(
				additional_feature
			)

	member_data["features"] = (
		combined_features
	)

	member_data["skills"] = (
		npc_data.get(
			"skills",
			{}
		).duplicate(true)
	)

	member_data["combat_stats"] = {
		"initiative_bonus": int(
			npc_data.get(
				"initiative_bonus",
				0
			)
		),
		"max_movement_meters": float(
			npc_data.get(
				"max_movement_meters",
				6.0
			)
		),
		"armor_class": int(
			npc_data.get(
				"armor_class",
				10
			)
		),
		"touch_armor_class": int(
			npc_data.get(
				"touch_armor_class",
				10
			)
		),
		"flat_footed_armor_class": int(
			npc_data.get(
				"flat_footed_armor_class",
				10
			)
		),
		"base_attack_bonus": int(
			npc_data.get(
				"base_attack_bonus",
				0
			)
		),
		"weapon_type": str(
			npc_data.get(
				"weapon_type",
				"melee"
			)
		),
		"damage_dice": int(
			npc_data.get(
				"damage_dice",
				6
			)
		),
		"damage_dice_count": int(
			npc_data.get(
				"damage_dice_count",
				1
			)
		),
		"damage_bonus": int(
			npc_data.get(
				"damage_bonus",
				0
			)
		),
		"weapon_range_meters": float(
			npc_data.get(
				"weapon_range_meters",
				1.5
			)
		),
		"fortitude_base_bonus": int(
			npc_data.get(
				"fortitude_base_bonus",
				0
			)
		),
		"reflex_base_bonus": int(
			npc_data.get(
				"reflex_base_bonus",
				0
			)
		),
		"will_base_bonus": int(
			npc_data.get(
				"will_base_bonus",
				0
			)
		),
		"racial_save_bonus": int(
			npc_data.get(
				"racial_save_bonus",
				0
			)
		),
		"fortitude_bonus": int(
			npc_data.get(
				"fortitude_bonus",
				0
			)
		),
		"reflex_bonus": int(
			npc_data.get(
				"reflex_bonus",
				0
			)
		),
		"will_bonus": int(
			npc_data.get(
				"will_bonus",
				0
			)
		),
		"observe_bonus": int(
			npc_data.get(
				"observe_bonus",
				0
			)
		),
		"hide_bonus": int(
			npc_data.get(
				"hide_bonus",
				0
			)
		),
		"feat_attack_bonus": int(
			npc_data.get(
				"feat_attack_bonus",
				0
			)
		),
		"feat_damage_bonus": int(
			npc_data.get(
				"feat_damage_bonus",
				0
			)
		),
		"weapon_focus_name": str(
			npc_data.get(
				"weapon_focus_name",
				""
			)
		),
		"weapon_focus_attack_bonus": int(
			npc_data.get(
				"weapon_focus_attack_bonus",
				0
			)
		),
		"sneak_attack_dice": int(
			npc_data.get(
				"sneak_attack_dice",
				0
			)
		)
	}

	member_data["special_abilities"] = {
		"trapfinding": bool(
			npc_data.get(
				"trapfinding",
				false
			)
		),
		"evasion": bool(
			npc_data.get(
				"evasion",
				false
			)
		),
		"trap_sense_bonus": int(
			npc_data.get(
				"trap_sense_bonus",
				0
			)
		),
		"sneak_attack_dice": int(
			npc_data.get(
				"sneak_attack_dice",
				0
			)
		)
	}

	member_data["source_npc_data"] = (
		npc_data.duplicate(true)
	)

	return member_data


func recruit_npc(
	npc_id: String,
	activate_immediately: bool = false
) -> bool:
	if has_member(npc_id):
		if activate_immediately:
			add_member_to_active_party(
				npc_id
			)
		
		return true
	
	var member_data: Dictionary = (
		build_member_from_npc(
			npc_id
		)
	)
	
	if member_data.is_empty():
		return false
	
	if not register_member(member_data):
		return false
	
	if activate_immediately:
		add_member_to_active_party(
			npc_id
		)
	
	return true

func get_member_equipped_item_id(
	member_id: String,
	equipment_slot: String
) -> String:
	if not members.has(member_id):
		return ""
	
	var member_data: Dictionary = members[member_id]
	
	var equipment_data: Dictionary = (
		member_data.get(
			"equipment",
			{}
		)
	)
	
	equipment_data = normalize_equipment_data(
		equipment_data
	)
	
	return str(
		equipment_data.get(
			equipment_slot + "_id",
			""
		)
	)


func equip_member_item(
	member_id: String,
	item_reference: String
) -> bool:
	if not members.has(member_id):
		push_warning(
			"Integrante não encontrado: "
			+ member_id
		)
		
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
	
	var item_data: Dictionary = (
		ItemDatabase.get_item(
			item_id
		)
	)
	
	if item_data.is_empty():
		return false
	
	var equipment_slot: String = str(
		item_data.get(
			"slot",
			""
		)
	)
	
	if not equipment_slot in [
		"weapon",
		"armor",
		"shield"
	]:
		push_warning(
			"O item não pode ser equipado: "
			+ item_reference
		)
		
		return false
	
	var member_data: Dictionary = (
		members[member_id].duplicate(true)
	)
	
	var equipment_data: Dictionary = (
		normalize_equipment_data(
			member_data.get(
				"equipment",
				{}
			)
		)
	)
	
	equipment_data[
		equipment_slot + "_id"
	] = item_id
	
	equipment_data[equipment_slot] = str(
		item_data.get(
			"display_name",
			item_id
		)
	)
	
	member_data["equipment"] = equipment_data
	
	member_data = update_member_equipment_stats(
		member_data
	)
	
	members[member_id] = member_data
	
	if member_id == HERO_MEMBER_ID:
		match equipment_slot:
			"weapon":
				GameState.hero_equipped_weapon = str(
					equipment_data["weapon"]
				)
			
			"armor":
				GameState.hero_equipped_armor = str(
					equipment_data["armor"]
				)
			
			"shield":
				GameState.hero_equipped_shield = str(
					equipment_data["shield"]
				)
	
	return true


func unequip_member_slot(
	member_id: String,
	equipment_slot: String
) -> bool:
	if not members.has(member_id):
		return false
	
	var empty_item_id: String = (
		ItemDatabase.get_empty_item_id(
			equipment_slot
		)
	)
	
	if empty_item_id == "":
		return false
	
	return equip_member_item(
		member_id,
		empty_item_id
	)


func update_member_equipment_stats(
	member_data: Dictionary
) -> Dictionary:
	var updated_member: Dictionary = (
		member_data.duplicate(true)
	)
	
	var equipment_data: Dictionary = (
		normalize_equipment_data(
			updated_member.get(
				"equipment",
				{}
			)
		)
	)
	
	var weapon_data: Dictionary = (
		ItemDatabase.get_item(
			str(
				equipment_data.get(
					"weapon_id",
					"unarmed"
				)
			)
		)
	)
	
	var armor_data: Dictionary = (
		ItemDatabase.get_item(
			str(
				equipment_data.get(
					"armor_id",
					"no_armor"
				)
			)
		)
	)
	
	var shield_data: Dictionary = (
		ItemDatabase.get_item(
			str(
				equipment_data.get(
					"shield_id",
					"no_shield"
				)
			)
		)
	)
	
	var combat_stats: Dictionary = (
		updated_member.get(
			"combat_stats",
			{}
		).duplicate(true)
	)
	
	combat_stats["weapon_type"] = str(
		weapon_data.get(
			"weapon_type",
			"melee"
		)
	)
	
	combat_stats["damage_dice"] = int(
		weapon_data.get(
			"damage_dice",
			3
		)
	)
	
	combat_stats["damage_dice_count"] = int(
		weapon_data.get(
			"damage_dice_count",
			1
		)
	)
	
	combat_stats["weapon_range_meters"] = float(
		weapon_data.get(
			"range_meters",
			1.5
		)
	)
	
	combat_stats["critical_min"] = int(
		weapon_data.get(
			"critical_min",
			20
		)
	)
	
	combat_stats["critical_multiplier"] = int(
		weapon_data.get(
			"critical_multiplier",
			2
		)
	)
	
	combat_stats["armor_bonus"] = int(
		armor_data.get(
			"armor_bonus",
			0
		)
	)
	
	combat_stats["max_dex_bonus"] = int(
		armor_data.get(
			"max_dex_bonus",
			99
		)
	)
	
	combat_stats["shield_bonus"] = int(
		shield_data.get(
			"shield_bonus",
			0
		)
	)
	
	combat_stats["equipment_movement_penalty"] = (
		float(
			armor_data.get(
				"movement_penalty",
				0.0
			)
		)
		+ float(
			shield_data.get(
				"movement_penalty",
				0.0
			)
		)
	)
	
	updated_member["equipment"] = equipment_data
	updated_member["combat_stats"] = combat_stats
	
	return updated_member


func get_save_data() -> Dictionary:
	return {
		"members": members.duplicate(true),
		"active_party": active_party.duplicate()
	}


func load_save_data(
	party_save_data: Dictionary
) -> void:
	members.clear()
	active_party.clear()
	
	if party_save_data.is_empty():
		sync_hero_from_game_state()
		return
	
	var saved_members: Dictionary = (
		party_save_data.get(
			"members",
			{}
		)
	)
	
	for saved_member_id in saved_members.keys():
		var member_data_variant = (
			saved_members[saved_member_id]
		)
		
		if not member_data_variant is Dictionary:
			continue
		
		var member_data: Dictionary = (
			member_data_variant.duplicate(true)
		)
		
		if str(
			member_data.get("id", "")
		).strip_edges() == "":
			member_data["id"] = str(
				saved_member_id
			)
		
		if not register_member(member_data):
			continue
		# Saves antigos normalizavam o machado ausente para Soco.
		# A marcação evita reverter uma troca feita depois pelo jogador.
		if str(saved_member_id) == "Kasum" and not bool(member_data.get("starting_weapon_migrated", false)):
			if get_member_equipped_item_id("Kasum", "weapon") == "unarmed":
				equip_member_item("Kasum", "battle_axe")
			var kasum_data: Dictionary = members["Kasum"]
			kasum_data["starting_weapon_migrated"] = true
			members["Kasum"] = kasum_data
	
	var saved_active_party: Array = (
		party_save_data.get(
			"active_party",
			[]
		)
	)
	
	for saved_member_id in saved_active_party:
		var member_id: String = str(
			saved_member_id
		)
		
		if not members.has(member_id):
			continue
		
		if active_party.has(member_id):
			continue
		
		if (
			active_party.size()
			>= MAX_ACTIVE_MEMBERS
		):
			break
		
		active_party.append(member_id)
	
	if not members.has(HERO_MEMBER_ID):
		sync_hero_from_game_state()
	
	if not active_party.has(HERO_MEMBER_ID):
		active_party.push_front(
			HERO_MEMBER_ID
		)
	
	while active_party.size() > MAX_ACTIVE_MEMBERS:
		active_party.pop_back()
