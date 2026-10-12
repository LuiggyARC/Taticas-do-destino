extends Node2D

const TILE_SIZE := 64
var grid_position: Vector2i = Vector2i(10, 7)

var health_bar_background: ColorRect
var health_bar_fill: ColorRect
var health_name_label: Label
var status_effects: Dictionary = {}
var monster_id: String = ""
var display_name: String = "Inimigo"

var creature_type: String = ""
var subtype: String = ""
var character_size: String = "Médio"

var max_hp: int = 30
var hp: int = 30

var initiative_bonus: int = 0
var max_movement_meters: float = 9.0
var current_movement_meters: float = 9.0

var armor_class: int = 10
var touch_armor_class: int = 10
var flat_footed_armor_class: int = 10

var base_attack_bonus: int = 0
var xp_reward: int = 0
var gold_reward: int = 0
var reward_given: bool = false

var equipped_weapon: String = "Soco"
var weapon_type: String = "melee"
var damage_dice: int = 3
var damage_dice_count: int = 1
var damage_bonus: int = 0
var weapon_range_meters: float = 1.5

var equipped_armor: String = "Nenhuma"
var equipped_shield: String = "Nenhum"

var strength: int = 10
var dexterity: int = 10
var constitution: int = 10
var intelligence: int = 10
var wisdom: int = 10
var charisma: int = 10

var fortitude_bonus: int = 0
var reflex_bonus: int = 0
var will_bonus: int = 0
var observe_bonus: int = 0

var intelligence_score: int = 10

var can_use_potions: bool = false
var potion_count: int = 0
var potion_heal_amount: int = 0

var can_use_buffs: bool = false
var buff_available: bool = false
var is_buffed: bool = false

var buff_attack_bonus: int = 2
var buff_damage_bonus: int = 2
var buff_armor_bonus: int = 1
var buff_movement_bonus: float = 0.0

var temporary_attack_bonus: int = 0
var temporary_damage_bonus: int = 0
var temporary_armor_class_bonus: int = 0
var temporary_movement_bonus: float = 0.0
var temporary_effects_end_turn: int = 0

var can_heal_self: bool = false
var self_heal_uses: int = 0
var self_heal_amount: int = 0

var can_heal_allies: bool = false
var healing_power: int = 0
var can_cast_spells: bool = false
var known_spells: Array = []
var spellcasting_attribute: String = "intelligence"

var spell_slots_level_1: int = 0
var max_spell_slots_level_1: int = 0

var can_fly: bool = false
var is_flying: bool = false
var can_use_scenario: bool = false

var special_traits: Array = []
var secondary_attacks: Array = []

var paralysis_duration_dice: int = 0
var paralysis_duration_bonus: int = 0
var paralysis_save_dc: int = 0
var paralysis_save_type: String = "fortitude"
var paralysis_immunity_races: Array = []

var trip_bonus: int = 0

var has_attacked: bool = false
var has_opportunity_attacked: bool = false

var attack_power: int = 10

var damage: int = 0

var ai_behavior: String = "aggressive" # aggressive, defensive, coward, ranged, support, strategic
var control_attack_penalty: int = 0
var control_armor_penalty: int = 0
var control_movement_penalty: float = 0.0
var control_effect_end_turn: int = 0

func _ready():
	create_visual()
	update_world_position()

func create_visual():
	var body := ColorRect.new()
	body.name = "Body"
	body.size = Vector2(48, 48)
	body.position = Vector2(-24, -24)
	body.color = Color(1.0, 0.1, 0.1)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(body)
	
	create_health_display()

func update_world_position():
	position = Vector2(
		grid_position.x * TILE_SIZE + TILE_SIZE * 0.5,
		grid_position.y * TILE_SIZE + TILE_SIZE * 0.5
	)
	
	update_health_display()

func reset_movement() -> void:
	current_movement_meters = max(
		0.0,
		max_movement_meters
		- control_movement_penalty
	)
	
	has_attacked = false
	has_opportunity_attacked = false
	
func take_damage(amount: int):
	if hp <= 0:
		return
	if amount > 0 and UIAudioManager != null:
		UIAudioManager.play_enemy_hit(monster_id)
	
	hp -= amount
	hp = max(hp, 0)
	
	update_health_display()
	
	print(
		get_display_name(),
		" recebeu ",
		amount,
		" de dano. HP: ",
		hp,
		"/",
		max_hp
	)
	
	if hp <= 0:
		die()
func die():
	print(display_name, " foi derrotado.")
	hp = 0
	visible = false
	set_process(false)
	
func get_enemy_display_name() -> String:
	return display_name


func get_armor_class() -> int:
	var final_armor_class: int = (
		armor_class
		+ temporary_armor_class_bonus
		- control_armor_penalty
	)
	
	return max(
		final_armor_class,
		1
	)


func get_touch_armor_class() -> int:
	return touch_armor_class


func get_flat_footed_armor_class() -> int:
	return flat_footed_armor_class


func get_base_attack_bonus() -> int:
	var final_attack_bonus: int = (
		base_attack_bonus
		- control_attack_penalty
	)
	
	return final_attack_bonus


func get_weapon_range_meters() -> float:
	return weapon_range_meters


func get_equipped_weapon_data() -> Dictionary:
	return {
		"name": equipped_weapon,
		"type": weapon_type,
		"damage_dice": damage_dice,
		"damage_dice_count": damage_dice_count,
		"damage_bonus": damage_bonus,
		"range_meters": weapon_range_meters
	}


func roll_total_weapon_damage() -> int:
	var total_damage: int = 0
	
	for i in range(damage_dice_count):
		total_damage += randi_range(1, damage_dice)
	
	total_damage += damage_bonus
	total_damage += temporary_damage_bonus
	
	if total_damage < 1:
		total_damage = 1
	
	return total_damage


func get_strength_modifier() -> int:
	return int(floor((float(strength) - 10.0) / 2.0))


func get_dexterity_modifier() -> int:
	return int(floor((float(dexterity) - 10.0) / 2.0))


func get_constitution_modifier() -> int:
	if constitution <= 0:
		return 0
	
	return int(floor((float(constitution) - 10.0) / 2.0))


func get_wisdom_modifier() -> int:
	return int(floor((float(wisdom) - 10.0) / 2.0))


func get_charisma_modifier() -> int:
	return int(floor((float(charisma) - 10.0) / 2.0))


func get_fortitude_save_bonus() -> int:
	return fortitude_bonus


func get_reflex_save_bonus() -> int:
	return reflex_bonus


func get_will_save_bonus() -> int:
	return will_bonus


func has_special_trait(trait_name: String) -> bool:
	return special_traits.has(trait_name)
	
func get_attribute_modifier(attribute_value: int) -> int:
	return int(floor((attribute_value - 10) / 2.0))

func setup_from_monster_data(
	monster_data: Dictionary
) -> void:
	if monster_data.is_empty():
		print("Ficha de monstro vazia.")
		return
	
	monster_id = str(
		monster_data.get(
			"display_name",
			"Inimigo"
		)
	)
	
	display_name = str(
		monster_data.get(
			"display_name",
			"Inimigo"
		)
	)
	
	creature_type = str(
		monster_data.get(
			"creature_type",
			""
		)
	)
	
	subtype = str(
		monster_data.get(
			"subtype",
			""
		)
	)
	
	character_size = str(
		monster_data.get(
			"size",
			"Médio"
		)
	)
	
	max_hp = int(
		monster_data.get(
			"max_hp",
			30
		)
	)
	
	hp = int(
		monster_data.get(
			"hp",
			max_hp
		)
	)
	
	initiative_bonus = int(
		monster_data.get(
			"initiative_bonus",
			0
		)
	)
	
	max_movement_meters = float(
		monster_data.get(
			"max_movement_meters",
			9.0
		)
	)
	
	current_movement_meters = (
		max_movement_meters
	)
	
	armor_class = int(
		monster_data.get(
			"armor_class",
			10
		)
	)
	
	touch_armor_class = int(
		monster_data.get(
			"touch_armor_class",
			armor_class
		)
	)
	
	flat_footed_armor_class = int(
		monster_data.get(
			"flat_footed_armor_class",
			armor_class
		)
	)
	
	base_attack_bonus = int(
		monster_data.get(
			"base_attack_bonus",
			0
		)
	)
	
	equipped_weapon = str(
		monster_data.get(
			"equipped_weapon",
			"Soco"
		)
	)
	
	weapon_type = str(
		monster_data.get(
			"weapon_type",
			"melee"
		)
	)
	
	damage_dice = int(
		monster_data.get(
			"damage_dice",
			3
		)
	)
	
	damage_dice_count = int(
		monster_data.get(
			"damage_dice_count",
			1
		)
	)
	
	damage_bonus = int(
		monster_data.get(
			"damage_bonus",
			0
		)
	)
	
	weapon_range_meters = float(
		monster_data.get(
			"weapon_range_meters",
			1.5
		)
	)
	
	equipped_armor = str(
		monster_data.get(
			"equipped_armor",
			"Nenhuma"
		)
	)
	
	equipped_shield = str(
		monster_data.get(
			"equipped_shield",
			"Nenhum"
		)
	)
	
	strength = int(
		monster_data.get(
			"strength",
			10
		)
	)
	
	dexterity = int(
		monster_data.get(
			"dexterity",
			10
		)
	)
	
	constitution = int(
		monster_data.get(
			"constitution",
			10
		)
	)
	
	intelligence = int(
		monster_data.get(
			"intelligence",
			10
		)
	)
	
	wisdom = int(
		monster_data.get(
			"wisdom",
			10
		)
	)
	
	charisma = int(
		monster_data.get(
			"charisma",
			10
		)
	)
	
	fortitude_bonus = int(
		monster_data.get(
			"fortitude_bonus",
			0
		)
	)
	
	reflex_bonus = int(
		monster_data.get(
			"reflex_bonus",
			0
		)
	)
	
	will_bonus = int(
		monster_data.get(
			"will_bonus",
			0
		)
	)
	
	observe_bonus = int(
		monster_data.get(
			"observe_bonus",
			0
		)
	)
	
	ai_behavior = str(
		monster_data.get(
			"ai_behavior",
			"aggressive"
		)
	)
	
	intelligence_score = int(
		monster_data.get(
			"intelligence_score",
			intelligence
		)
	)
	
	can_use_potions = bool(
		monster_data.get(
			"can_use_potions",
			false
		)
	)
	
	potion_count = int(
		monster_data.get(
			"potion_count",
			0
		)
	)
	
	potion_heal_amount = int(
		monster_data.get(
			"potion_heal_amount",
			0
		)
	)
	
	can_use_buffs = bool(
		monster_data.get(
			"can_use_buffs",
			false
		)
	)
	
	buff_available = bool(
		monster_data.get(
			"buff_available",
			false
		)
	)
	
	is_buffed = false
	
	can_heal_self = bool(
		monster_data.get(
			"can_heal_self",
			false
		)
	)
	
	self_heal_uses = int(
		monster_data.get(
			"self_heal_uses",
			0
		)
	)
	
	self_heal_amount = int(
		monster_data.get(
			"self_heal_amount",
			0
		)
	)
	
	can_heal_allies = bool(
		monster_data.get(
			"can_heal_allies",
			false
		)
	)
	
	healing_power = int(
		monster_data.get(
			"healing_power",
			0
		)
	)
	
	can_cast_spells = bool(
		monster_data.get(
			"can_cast_spells",
			false
		)
	)
	
	known_spells = monster_data.get(
		"known_spells",
		[]
	).duplicate(true)
	
	spellcasting_attribute = str(
		monster_data.get(
			"spellcasting_attribute",
			"intelligence"
		)
	)
	
	max_spell_slots_level_1 = int(
		monster_data.get(
			"max_spell_slots_level_1",
			0
		)
	)
	
	spell_slots_level_1 = clampi(
		int(
			monster_data.get(
				"spell_slots_level_1",
				max_spell_slots_level_1
			)
		),
		0,
		max_spell_slots_level_1
	)
	
	can_fly = bool(
		monster_data.get(
			"can_fly",
			false
		)
	)
	
	is_flying = bool(
		monster_data.get(
			"is_flying",
			false
		)
	)
	
	can_use_scenario = bool(
		monster_data.get(
			"can_use_scenario",
			false
		)
	)
	
	special_traits = monster_data.get(
		"special_traits",
		[]
	).duplicate(true)
	
	secondary_attacks = monster_data.get(
		"secondary_attacks",
		[]
	).duplicate(true)
	
	paralysis_duration_dice = int(
		monster_data.get(
			"paralysis_duration_dice",
			0
		)
	)
	
	paralysis_duration_bonus = int(
		monster_data.get(
			"paralysis_duration_bonus",
			0
		)
	)
	
	paralysis_save_dc = int(
		monster_data.get(
			"paralysis_save_dc",
			0
		)
	)
	
	paralysis_save_type = str(
		monster_data.get(
			"paralysis_save_type",
			"fortitude"
		)
	)
	
	paralysis_immunity_races = monster_data.get(
		"paralysis_immunity_races",
		[]
	).duplicate(true)
	
	trip_bonus = int(
		monster_data.get(
			"trip_bonus",
			0
		)
	)
	
	has_attacked = false
	has_opportunity_attacked = false
	
	xp_reward = int(
		monster_data.get(
			"xp_reward",
			0
		)
	)
	
	gold_reward = int(
		monster_data.get(
			"gold_reward",
			0
		)
	)
	
	reward_given = false
	
	update_world_position()
	
	print("====================================")
	print("MONSTRO CARREGADO")
	print("Nome: ", display_name)
	print("Tipo: ", creature_type)
	print("PV: ", hp, "/", max_hp)
	print("CA: ", armor_class)
	print("Arma: ", equipped_weapon)
	print("IA: ", ai_behavior)
	print("Inteligência: ", intelligence_score)
	print("Especiais: ", special_traits)
	print("Magias: ", known_spells)
	print(
		"Espaços de nível 1: ",
		spell_slots_level_1,
		"/",
		max_spell_slots_level_1
	)
	print("====================================")

func knows_spell(
	spell_name: String
) -> bool:
	if not can_cast_spells:
		return false
	
	return known_spells.has(
		spell_name
	)


func has_spell_slot_available(
	spell_level: int
) -> bool:
	if not can_cast_spells:
		return false
	
	match spell_level:
		1:
			return (
				spell_slots_level_1 > 0
			)
		
		_:
			return false


func consume_spell_slot(
	spell_level: int
) -> bool:
	if not has_spell_slot_available(
		spell_level
	):
		return false
	
	match spell_level:
		1:
			spell_slots_level_1 = max(
				spell_slots_level_1 - 1,
				0
			)
			
			return true
		
		_:
			return false
	
func apply_status_effect(effect_name: String, end_turn: int):
	status_effects[effect_name] = end_turn
	print(name, " recebeu condição: ", effect_name, " até a rodada ", end_turn)


func remove_status_effect(effect_name: String):
	if status_effects.has(effect_name):
		status_effects.erase(effect_name)


func has_status_effect(effect_name: String, current_battle_turn: int) -> bool:
	if not status_effects.has(effect_name):
		return false
	
	var end_turn: int = int(status_effects[effect_name])
	
	if current_battle_turn >= end_turn:
		status_effects.erase(effect_name)
		return false
	
	return true

func apply_control_effect(
	attack_penalty: int,
	armor_penalty: int,
	movement_penalty: float,
	effect_end_turn: int
) -> void:
	var previous_movement_penalty: float = (
		control_movement_penalty
	)
	
	control_attack_penalty = max(
		control_attack_penalty,
		attack_penalty
	)
	
	control_armor_penalty = max(
		control_armor_penalty,
		armor_penalty
	)
	
	control_movement_penalty = max(
		control_movement_penalty,
		movement_penalty
	)
	
	control_effect_end_turn = max(
		control_effect_end_turn,
		effect_end_turn
	)
	
	var additional_movement_penalty: float = max(
		0.0,
		control_movement_penalty
		- previous_movement_penalty
	)
	
	if additional_movement_penalty > 0.0:
		current_movement_meters = max(
			0.0,
			current_movement_meters
			- additional_movement_penalty
		)
	
	print(
		get_display_name(),
		" recebeu controle até a rodada ",
		control_effect_end_turn
	)


func clear_control_effects() -> void:
	control_attack_penalty = 0
	control_armor_penalty = 0
	control_movement_penalty = 0.0
	control_effect_end_turn = 0


func has_active_control_effect(
	current_battle_turn: int
) -> bool:
	if control_effect_end_turn <= 0:
		return false
	
	if current_battle_turn >= control_effect_end_turn:
		clear_control_effects()
		return false
	
	return true

func get_active_effect_descriptions(
	current_battle_turn: int
) -> Array[String]:
	var descriptions: Array[String] = []
	
	if has_active_control_effect(
		current_battle_turn
	):
		var control_turns_remaining: int = (
			control_effect_end_turn
			- current_battle_turn
		)
		
		descriptions.append(
			get_display_name()
			+ ": Controle | "
			+ str(control_turns_remaining)
			+ "t"
		)
	
	if is_buffed:
		var buff_turns_remaining: int = (
			temporary_effects_end_turn
			- current_battle_turn
		)
		
		if buff_turns_remaining > 0:
			descriptions.append(
				get_display_name()
				+ ": Buff | "
				+ str(buff_turns_remaining)
				+ "t"
			)
	
	if (
		can_heal_self
		and self_heal_uses > 0
	):
		descriptions.append(
			get_display_name()
			+ ": Cura própria | "
			+ str(self_heal_uses)
			+ " uso(s)"
		)
	
	return descriptions

func update_status_effects(
	current_battle_turn: int
) -> void:
	var effects_to_remove: Array[String] = []
	
	for effect_name in status_effects.keys():
		var end_turn: int = int(
			status_effects[effect_name]
		)
		
		if current_battle_turn >= end_turn:
			effects_to_remove.append(
				effect_name
			)
	
	for effect_name in effects_to_remove:
		status_effects.erase(effect_name)
		
		print(
			get_display_name(),
			" perdeu condição: ",
			effect_name
		)
	
	if (
		control_effect_end_turn > 0
		and current_battle_turn
		>= control_effect_end_turn
	):
		clear_control_effects()
		
		print(
			get_display_name(),
			" perdeu os efeitos de controle."
		)
		
func create_health_display():
	# Evita criar outra barra caso ela já exista.
	if (
		is_instance_valid(health_name_label)
		and is_instance_valid(health_bar_background)
		and is_instance_valid(health_bar_fill)
	):
		update_health_display()
		return
	
	# =====================================================
	# NOME DO INIMIGO
	# =====================================================
	health_name_label = Label.new()
	health_name_label.name = "HealthNameLabel"
	health_name_label.position = Vector2(-60, -58)
	health_name_label.size = Vector2(120, 20)
	health_name_label.text = get_display_name()
	health_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	health_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_name_label.z_index = 22
	
	apply_name_style(
		health_name_label,
		Color(1.0, 0.25, 0.25, 1.0),
		Color.BLACK,
		6
	)
	
	add_child(health_name_label)
	
	# =====================================================
	# FUNDO DA BARRA
	# =====================================================
	health_bar_background = ColorRect.new()
	health_bar_background.name = "HealthBarBackground"
	health_bar_background.size = Vector2(54, 8)
	health_bar_background.position = Vector2(-27, -38)
	health_bar_background.color = Color(0.05, 0.05, 0.05, 0.9)
	health_bar_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_bar_background.z_index = 20
	
	add_child(health_bar_background)
	
	# =====================================================
	# PREENCHIMENTO
	# =====================================================
	health_bar_fill = ColorRect.new()
	health_bar_fill.name = "HealthBarFill"
	health_bar_fill.position = Vector2(2, 2)
	health_bar_fill.size = Vector2(50, 4)
	health_bar_fill.color = Color(0.15, 0.85, 0.2, 1.0)
	health_bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_bar_fill.z_index = 21
	
	health_bar_background.add_child(health_bar_fill)
	
	update_health_display()
	
func update_health_display():
	if is_instance_valid(health_name_label):
		health_name_label.text = get_display_name()
	
	if not is_instance_valid(health_bar_fill):
		return
	
	var hp_ratio: float = 0.0
	
	if max_hp > 0:
		hp_ratio = clamp(
			float(hp) / float(max_hp),
			0.0,
			1.0
		)
	
	health_bar_fill.size.x = 50.0 * hp_ratio
	
	if hp_ratio > 0.6:
		health_bar_fill.color = Color(0.15, 0.85, 0.2, 1.0)
	elif hp_ratio > 0.3:
		health_bar_fill.color = Color(0.95, 0.75, 0.15, 1.0)
	else:
		health_bar_fill.color = Color(0.9, 0.15, 0.15, 1.0)
	
func get_display_name() -> String:
	if display_name != "":
		return str(display_name)
	
	return str(name)

func apply_name_style(label: Label, font_color: Color, outline_color: Color, outline_size: int = 6) -> void:
	label.add_theme_color_override("font_color", font_color)
	label.add_theme_color_override("font_outline_color", outline_color)
	label.add_theme_constant_override("outline_size", outline_size)
