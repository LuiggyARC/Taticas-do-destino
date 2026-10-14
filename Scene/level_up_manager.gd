extends RefCounted
class_name LevelUpManager

const LevelProgressionData = preload("res://Scene/level_progression.gd")
const ClassPowerProgressionData = preload("res://Scene/class_power_progression.gd")


const SPELLCASTING_CLASSES: Array[String] = [
	"Bardo",
	"Clérigo",
	"Druida",
	"Feiticeiro",
	"Mago"
]


func get_level_up_preview(
	hero_unit: Node,
	target_level: int = -1
) -> Dictionary:
	if not is_instance_valid(hero_unit):
		return {}
	
	var current_level: int = max(
		1,
		int(hero_unit.level)
	)
	
	var new_level: int = target_level
	
	if new_level <= current_level:
		new_level = current_level + 1
	
	new_level = min(
		new_level,
		int(hero_unit.max_level)
	)
	
	var character_class: String = str(
		hero_unit.character_class
	)
	
	var character_race: String = str(
		hero_unit.character_race
	)
	
	var constitution_modifier: int = (
		get_attribute_modifier(
			int(hero_unit.constitution)
		)
	)
	
	var current_spell_slots: Dictionary = (
		get_spell_slot_limits(
			character_class,
			current_level
		)
	)
	
	var new_spell_slots: Dictionary = (
		get_spell_slot_limits(
			character_class,
			new_level
		)
	)
	
	var feat_choices: Array = (
		get_feat_choices(
			hero_unit,
			new_level
		)
	)
	
	var available_spells: Array[String] = (
		get_available_spell_names(
			hero_unit,
			new_level
		)
	)
	
	var spell_choice_count: int = (
		get_spell_choice_count(
			character_class,
			new_level
		)
	)
	
	spell_choice_count = min(
		spell_choice_count,
		available_spells.size()
	)
	
	var preview: Dictionary = {
		"current_level": current_level,
		"new_level": new_level,
		"character_class": character_class,
		"character_race": character_race,
		"attribute_point_count": LevelProgressionData.attribute_points(new_level, character_race),
		"level_gains": LevelProgressionData.gains_for_level(new_level, character_race, ClassPowerProgressionData.has_class(character_class)),
		"current_xp_threshold": LevelProgressionData.xp_for_level(current_level),
		"new_xp_threshold": LevelProgressionData.xp_for_level(new_level),
		
		"hit_die": int(hero_unit.class_hit_die),
		"fixed_hp": int(hero_unit.hp_fixed_per_level),
		"hp_progression_mode": str(
			hero_unit.hp_progression_mode
		),
		"constitution_modifier": constitution_modifier,
		"minimum_hp_gain": 1,
		
		"current_base_attack_bonus": (
			calculate_base_attack_bonus(
				str(hero_unit.base_attack_bonus_type),
				current_level
			)
		),
		"new_base_attack_bonus": (
			calculate_base_attack_bonus(
				str(hero_unit.base_attack_bonus_type),
				new_level
			)
		),
		
		"current_fortitude": (
			calculate_save_bonus(
				str(hero_unit.fortitude_type),
				current_level
			)
		),
		"new_fortitude": (
			calculate_save_bonus(
				str(hero_unit.fortitude_type),
				new_level
			)
		),
		
		"current_reflex": (
			calculate_save_bonus(
				str(hero_unit.reflex_type),
				current_level
			)
		),
		"new_reflex": (
			calculate_save_bonus(
				str(hero_unit.reflex_type),
				new_level
			)
		),
		
		"current_will": (
			calculate_save_bonus(
				str(hero_unit.will_type),
				current_level
			)
		),
		"new_will": (
			calculate_save_bonus(
				str(hero_unit.will_type),
				new_level
			)
		),
		
		"feat_choice_count": feat_choices.size(),
		"feat_choices": feat_choices,
		
		"is_spellcaster": (
			is_spellcasting_class(
				character_class
			)
		),
		"spell_choice_count": spell_choice_count,
		"available_spells": available_spells,
		"current_spell_slots": current_spell_slots,
		"new_spell_slots": new_spell_slots,
		"unlocked_spell_levels": (
			get_unlocked_spell_levels(
				current_spell_slots,
				new_spell_slots
			)
		)
	}
	
	return preview


func get_character_attributes(
	hero_unit: Node
) -> Dictionary:
	if not is_instance_valid(hero_unit):
		return {}
	
	return {
		"strength": int(hero_unit.strength),
		"dexterity": int(hero_unit.dexterity),
		"constitution": int(hero_unit.constitution),
		"wisdom": int(hero_unit.wisdom),
		"intelligence": int(hero_unit.intelligence),
		"charisma": int(hero_unit.charisma)
	}


func get_attribute_modifier(
	attribute_value: int
) -> int:
	return int(
		floor(
			(attribute_value - 10) / 2.0
		)
	)


func calculate_base_attack_bonus(
	progression_type: String,
	character_level: int
) -> int:
	match progression_type:
		"alto":
			return character_level
		
		"medio":
			return int(
				floor(
					character_level * 0.75
				)
			)
		
		"baixo":
			return int(
				floor(
					character_level * 0.5
				)
			)
	
	return 0


func calculate_save_bonus(
	progression_type: String,
	character_level: int
) -> int:
	match progression_type:
		"bom":
			return (
				2
				+ int(
					floor(
						character_level / 2.0
					)
				)
			)
		
		"ruim":
			return int(
				floor(
					character_level / 3.0
				)
			)
	
	return 0


func get_feat_choices(
	hero_unit: Node,
	new_level: int
) -> Array:
	var choices: Array = []
	
	if not is_instance_valid(hero_unit):
		return choices
	
	var general_choice_count: int = (
		get_general_feat_choice_count(
			new_level
		)
	)
	
	for choice_index in range(
		general_choice_count
	):
		choices.append({
			"choice_type": "general",
			"title": "Escolha um talento",
			"only_combat_feats": false,
			"available_feats": (
				get_available_feat_names(
					hero_unit,
					new_level,
					false
				)
			)
		})
	
	var combat_choice_count: int = (
		get_combat_feat_choice_count(
			str(hero_unit.character_class),
			new_level
		)
	)
	
	for choice_index in range(
		combat_choice_count
	):
		choices.append({
			"choice_type": "combat",
			"title": "Talento adicional de Guerreiro",
			"only_combat_feats": true,
			"available_feats": (
				get_available_feat_names(
					hero_unit,
					new_level,
					true
				)
			)
		})
	
	return choices


func get_general_feat_choice_count(
	new_level: int
) -> int:
	return LevelProgressionData.general_feat_count(new_level)


func get_combat_feat_choice_count(
	character_class: String,
	new_level: int
) -> int:
	if character_class != "Guerreiro":
		return 0
	
	if new_level > 1 and new_level % 2 == 0:
		return 1
	
	return 0


func get_available_feat_names(
	hero_unit: Node,
	new_level: int,
	only_combat_feats: bool = false
) -> Array[String]:
	var result: Array[String] = []
	
	if not is_instance_valid(hero_unit):
		return result
	
	if FeatDatabase == null:
		return result
	
	var selected_feats: Array = (
		hero_unit.selected_feats.duplicate()
	)
	
	var available_feats: Array = (
		FeatDatabase.get_available_feats_for_character(
			str(hero_unit.character_class),
			str(hero_unit.character_race),
			new_level,
			only_combat_feats,
			selected_feats,
			get_character_attributes(hero_unit)
		)
	)
	
	for feat_name_value in available_feats:
		var feat_name: String = str(
			feat_name_value
		)
		
		if selected_feats.has(feat_name):
			continue
		
		if result.has(feat_name):
			continue
		
		result.append(feat_name)
	
	result.sort()
	return result


func is_spellcasting_class(
	character_class: String
) -> bool:
	return SPELLCASTING_CLASSES.has(
		character_class
	)


func get_spell_choice_count(
	character_class: String,
	new_level: int
) -> int:
	if new_level <= 1:
		return 0
	
	match character_class:
		"Mago":
			return 2
		
		"Bardo", "Feiticeiro":
			return 1
		
	
	return 0


func get_available_spell_names(
	hero_unit: Node,
	new_level: int
) -> Array[String]:
	var result: Array[String] = []
	
	if not is_instance_valid(hero_unit):
		return result
	
	if SpellDatabase == null:
		return result
	
	var character_class: String = str(
		hero_unit.character_class
	)
	
	if not is_spellcasting_class(
		character_class
	):
		return result
	
	var maximum_spell_level: int = (
		get_max_spell_level_for_class(
			character_class,
			new_level
		)
	)
	
	if maximum_spell_level < 0:
		return result
	
	var known_spells: Array = (
		hero_unit.known_spells.duplicate()
	)
	
	var class_spells: Array = (
		SpellDatabase.get_spells_for_class(
			character_class
		)
	)
	
	for spell_name_value in class_spells:
		var spell_name: String = str(
			spell_name_value
		)
		
		if known_spells.has(spell_name):
			continue
		
		var spell_data: Dictionary = (
			SpellDatabase.get_spell_data(
				spell_name
			)
		)
		
		if spell_data.is_empty():
			continue
		
		var spell_level: int = int(
			spell_data.get(
				"level",
				0
			)
		)
		
		if spell_level > maximum_spell_level:
			continue
		
		if result.has(spell_name):
			continue
		
		result.append(spell_name)
	
	result.sort()
	return result


func get_max_spell_level_for_class(
	character_class: String,
	character_level: int
) -> int:
	match character_class:
		"Bardo", "Feiticeiro":
			if character_level >= 4:
				return 2
			
			if character_level >= 1:
				return 1
		
		"Clérigo", "Druida", "Mago":
			if character_level >= 3:
				return 2
			
			if character_level >= 1:
				return 1
		
	
	return -1


func get_spell_slot_limits(
	character_class: String,
	character_level: int
) -> Dictionary:
	var slots: Dictionary = {
		0: 0,
		1: 0,
		2: 0
	}
	
	var safe_level: int = max(
		1,
		character_level
	)
	
	match character_class:
		"Bardo":
			slots[0] = min(
				4,
				2 + int(
					(safe_level - 1) / 3
				)
			)
			
			slots[1] = min(
				5,
				1 + int(
					(safe_level - 1) / 2
				)
			)
			
			if safe_level >= 4:
				slots[2] = min(
					4,
					1 + int(
						(safe_level - 4) / 2
					)
				)
		
		"Clérigo", "Druida", "Mago":
			slots[0] = min(
				5,
				3 + int(
					(safe_level - 1) / 4
				)
			)
			
			slots[1] = min(
				5,
				2 + int(
					(safe_level - 1) / 2
				)
			)
			
			if safe_level >= 3:
				slots[2] = min(
					4,
					1 + int(
						(safe_level - 3) / 2
					)
				)
		
		"Feiticeiro":
			slots[0] = min(
				6,
				4 + int(
					(safe_level - 1) / 4
				)
			)
			
			slots[1] = min(
				6,
				2 + int(
					(safe_level - 1) / 2
				)
			)
			
			if safe_level >= 4:
				slots[2] = min(
					5,
					1 + int(
						(safe_level - 4) / 2
					)
				)
		
	
	# O bônus é da classe e só se aplica a círculos já desbloqueados.
	# Quando os círculos 3 e 4 tiverem progressão, receberão o mesmo bônus.
	if character_class == "Mago":
		for spell_level in range(1, 5):
			if int(slots.get(spell_level, 0)) > 0:
				slots[spell_level] = int(slots[spell_level]) + 1
	
	return slots


func get_unlocked_spell_levels(
	current_slots: Dictionary,
	new_slots: Dictionary
) -> Array[int]:
	var unlocked_levels: Array[int] = []
	
	for spell_level in [0, 1, 2]:
		var old_amount: int = int(
			current_slots.get(
				spell_level,
				0
			)
		)
		
		var new_amount: int = int(
			new_slots.get(
				spell_level,
				0
			)
		)
		
		if old_amount <= 0 and new_amount > 0:
			unlocked_levels.append(
				spell_level
			)
	
	return unlocked_levels
