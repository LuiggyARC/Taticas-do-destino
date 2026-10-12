extends Node2D

const TILE_SIZE := 64

var is_hidden: bool = false
var hide_used_this_turn: bool = false
var hide_checked_enemies: Dictionary = {}
var enemy_is_surprised: bool = false

var smite_evil_used: bool = false
var smite_evil_active: bool = false
var is_raging: bool = false
var rage_used: bool = false
var rage_uses_this_battle: int = 0
var feat_extra_rage_uses: int = 0
var rage_turns_remaining: int = 0


var rage_strength_bonus: int = 2
var rage_constitution_bonus: int = 2
var rage_will_bonus: int = 0
var rage_ac_penalty: int = 4
var rage_end_turn: int = 0

var health_name_label: Label
var health_bar_background: ColorRect
var health_bar_fill: ColorRect
var temporary_effects_end_turn: int = 0
var temporary_effects_active: bool = false
var status_effects: Dictionary = {}

var temporary_attack_bonus: int = 0
var temporary_damage_bonus: int = 0
var temporary_armor_class_bonus: int = 0
var temporary_movement_bonus: float = 0.0
var temporary_effects_turns_remaining: int = 0

var sneak_attack_dice_count: int = 1
var grid_position: Vector2i = Vector2i(7, 7)
var class_hit_die: int = 12
var hp_fixed_per_level: int = 8
var hp_progression_mode: String = "fixed"

var base_attack_bonus_type: String = "alto"
var class_movement_bonus: float = 0.0
var damage_reduction: int = 0
var class_features: Array = []
var character_name: String = "Herói"
var character_class: String = ""
var character_race: String = "Humano"
var character_size: String = "Médio"
var favored_class: String = "Qualquer"
var race_traits: Array = []
var unstoppable_active: bool = false
var unstoppable_turn_started: bool = false
var unstoppable_used_this_battle: bool = false

var max_hp: int = 100
var hp: int = 100
var attack_power: int = 20

var max_movement_meters: float = 9.0
var current_movement_meters: float = 9.0
var pending_level_ups: int = 0

var has_attacked: bool = false
var has_opportunity_attacked: bool = false
var opportunity_attacks_used: int = 0
var feat_extra_opportunity_attacks: int = 0

var level: int = 1
var total_xp: int = 0
var xp_to_next_level: int = 1000
var max_level: int = 20

var strength: int = 10      # FOR
var dexterity: int = 10     # DES
var constitution: int = 10  # CON
var wisdom: int = 10        # SAB
var intelligence: int = 10  # INT
var charisma: int = 10      # CAR
var base_armor_class: int = 10

var armor_bonus: int = 0
var shield_bonus: int = 0
var size_modifier: int = 0
var dodge_bonus: int = 0
var deflection_bonus: int = 0
var natural_armor_bonus: int = 0
var other_ac_bonus: int = 0

var fortitude_type: String = "ruim"
var reflex_type: String = "ruim"
var will_type: String = "ruim"

var fortitude_base_bonus: int = 0
var reflex_base_bonus: int = 0
var will_base_bonus: int = 0


var damage: int = 0
var equipped_shield: String = "Nenhum"

var known_spells: Array = []
var spell_slots_level_0: int = 0
var spell_slots_level_1: int = 0
var spell_slots_level_2: int = 0

var max_spell_slots_level_0: int = 0
var max_spell_slots_level_1: int = 0
var max_spell_slots_level_2: int = 0

var bardic_inspiration_active: bool = false
var bardic_inspiration_turns: int = 0

var selected_feats: Array = []

var feat_max_hp_bonus: int = 0
var feat_armor_class_bonus: int = 0
var feat_attack_bonus: int = 0
var feat_damage_bonus: int = 0
var feat_hide_bonus: int = 0
var feat_sneak_attack_extra_dice: int = 0
var feat_spell_power_bonus: int = 0
var feat_spell_damage_bonus: int = 0
var feat_healing_bonus: int = 0
var feat_divine_healing_bonus: int = 0
var feat_initiative_bonus: int = 0
var feat_spell_range_bonus: float = 0.0
var feat_extra_spell_slot_level_1: int = 0
var feat_surprise_attack_bonus: int = 0
var feat_hidden_damage_bonus: int = 0
var feat_flanking_attack_bonus: int = 0
var feat_flanking_damage_bonus: int = 0
var feat_monk_armor_class_bonus: int = 0
var feat_magic_armor_class_bonus: int = 0
var feat_divine_buff_duration_bonus: int = 0
var feat_animal_companion_hp_bonus: int = 0
var feat_melee_attack_bonus: int = 0
var feat_melee_damage_bonus: int = 0
var feat_ranged_attack_bonus: int = 0
var feat_ranged_damage_bonus: int = 0
var feat_unarmed_damage_bonus: int = 0
var feat_rage_damage_bonus: int = 0

var feat_fortitude_bonus: int = 0
var feat_reflex_bonus: int = 0
var feat_will_bonus: int = 0
var feat_observe_bonus: int = 0
var feat_movement_bonus: float = 0.0

var feat_animal_companion_attack_bonus: int = 0
var feat_animal_companion_damage_bonus: int = 0
var feat_animal_companion_armor_bonus: int = 0
var feat_animal_companion_movement_bonus: float = 0.0


var equipped_weapon: String = "Espada Curta"
var equipped_armor: String = "Roupa Comum"
var gold: int = 5

func _ready():
	create_visual()
	update_world_position()


func create_visual():
	var body := ColorRect.new()
	body.name = "Body"
	body.size = Vector2(48, 48)
	body.position = Vector2(-24, -24)
	body.color = Color(0.1, 0.3, 1.0)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(body)
	
	create_health_bar()
	update_hidden_visual()


func update_hidden_visual() -> void:
	var body_visual: CanvasItem = get_node_or_null("Body") as CanvasItem
	if not is_instance_valid(body_visual):
		return
	var tint: Color = body_visual.modulate
	tint.a = 0.45 if is_hidden else 1.0
	body_visual.modulate = tint


func set_hidden_state(hidden: bool) -> void:
	is_hidden = hidden
	if not hidden:
		enemy_is_surprised = false
	update_hidden_visual()


func update_world_position():
	position = Vector2(
		grid_position.x * TILE_SIZE + TILE_SIZE * 0.5,
		grid_position.y * TILE_SIZE + TILE_SIZE * 0.5
	)


func reset_movement():
	if unstoppable_active:
		unstoppable_turn_started = true
	current_movement_meters = max_movement_meters
	has_attacked = false
	has_opportunity_attacked = false
	opportunity_attacks_used = 0
	hide_used_this_turn = false


func take_damage(amount: int):
	var final_damage: int = amount
	
	if damage_reduction > 0:
		final_damage -= damage_reduction
		
		if final_damage < 0:
			final_damage = 0
		
		print("Redução de Dano aplicada. Dano original: ", amount, " | RD: ", damage_reduction, " | Dano final: ", final_damage)
	
	hp -= final_damage
	hp = max(hp, 0)
	if hp <= 0 and character_race == "Meio-Orc" and not unstoppable_used_this_battle:
		hp = 1
		unstoppable_active = true
		unstoppable_turn_started = false
		unstoppable_used_this_battle = true
	update_health_bar()
	print("Herói recebeu ", final_damage, " de dano. Vida atual: ", hp)
	
	if hp <= 0:
		die()

func finish_unstoppable_turn() -> void:
	if not unstoppable_active or not unstoppable_turn_started:
		return
	unstoppable_active = false
	unstoppable_turn_started = false
	if hp <= 1:
		hp = 0
		update_health_bar()
		die()

func get_racial_damage_bonus() -> int:
	return 2 if unstoppable_active and character_race == "Meio-Orc" else 0

func die():
	print("Herói derrotado.")
	queue_free()


func apply_character_data(
	new_name: String,
	new_class: String,
	new_level: int,
	new_total_xp: int,
	new_xp_to_next_level: int,
	new_max_hp: int,
	new_attack_power: int,
	new_max_movement: float
):
	character_name = new_name
	character_class = new_class
	
	level = new_level
	total_xp = new_total_xp
	xp_to_next_level = new_xp_to_next_level
	
	max_hp = new_max_hp
	hp = max_hp
	
	attack_power = new_attack_power
	max_movement_meters = new_max_movement
	current_movement_meters = max_movement_meters
	
	update_level_from_total_xp()


func gain_xp(
	amount: int
) -> void:
	if amount <= 0:
		return
	
	if level >= max_level:
		print(
			character_name,
			" já está no nível máximo."
		)
		
		return
	
	total_xp += amount
	
	var target_level: int = (
		calculate_level_from_xp(
			total_xp
		)
	)
	
	target_level = clamp(
		target_level,
		1,
		max_level
	)
	
	pending_level_ups = max(
		0,
		target_level - level
	)
	
	xp_to_next_level = (
		get_xp_needed_for_current_level()
	)
	
	print(
		character_name,
		" ganhou ",
		amount,
		" XP. XP total: ",
		total_xp
	)
	
	if pending_level_ups > 0:
		print(
			"Evoluções pendentes: ",
			pending_level_ups,
			". Serão resolvidas após a batalha."
		)

func update_level_from_total_xp() -> void:
	level = clamp(
		level,
		1,
		max_level
	)
	
	var target_level: int = (
		calculate_level_from_xp(
			total_xp
		)
	)
	
	target_level = clamp(
		target_level,
		level,
		max_level
	)
	
	pending_level_ups = max(
		0,
		target_level - level
	)
	
	xp_to_next_level = (
		get_xp_needed_for_current_level()
	)
	
	update_class_scaling()

func calculate_level_from_xp(xp: int) -> int:
	var calculated_level := 1
	
	for target_level in range(2, max_level + 1):
		var required_xp := get_total_xp_required_for_level(target_level)
		
		if xp >= required_xp:
			calculated_level = target_level
		else:
			break
	
	return calculated_level


func get_total_xp_required_for_level(target_level: int) -> int:
	if target_level <= 1:
		return 0
	
	var total_required := 0
	var xp_step := 1000.0
	
	for level_index in range(2, target_level + 1):
		total_required += int(round(xp_step))
		xp_step *= 1.5
	
	return total_required


func get_xp_progress_in_current_level() -> int:
	if level >= max_level:
		return 0
	
	var current_level_start_xp := get_total_xp_required_for_level(level)
	return total_xp - current_level_start_xp


func get_xp_needed_for_current_level() -> int:
	if level >= max_level:
		return 0
	
	var current_level_start_xp := get_total_xp_required_for_level(level)
	var next_level_required_xp := get_total_xp_required_for_level(level + 1)
	return next_level_required_xp - current_level_start_xp


func apply_level_up_result(
	level_up_data: Dictionary
) -> bool:
	if level_up_data.is_empty():
		print("Dados de evolução vazios.")
		return false
	
	var new_level: int = int(
		level_up_data.get(
			"new_level",
			level
		)
	)
	
	if new_level != level + 1:
		print(
			"Nível de evolução inválido. Atual: ",
			level,
			" | Recebido: ",
			new_level
		)
		return false
	
	if new_level > max_level:
		print(
			"O personagem já atingiu o nível máximo."
		)
		return false
	
	var hp_gain: int = int(
		level_up_data.get(
			"hp_gain",
			0
		)
	)
	
	if hp_gain < 1:
		print("Ganho de vida inválido.")
		return false
	var attribute_increases: Dictionary = level_up_data.get("attribute_increases", {})
	var expected_attribute_points: int = (2 + (1 if character_race == "Meio-Elfo" else 0)) if new_level % 4 == 0 else 0
	var allocated_points: int = 0
	for attribute_key in attribute_increases:
		if not str(attribute_key) in ["strength", "dexterity", "constitution", "wisdom", "intelligence", "charisma"]:
			return false
		var increase: int = int(attribute_increases[attribute_key])
		if increase < 0:
			return false
		allocated_points += increase
	if allocated_points != expected_attribute_points:
		return false
	
	var new_feats: Array = level_up_data.get(
		"selected_feats",
		[]
	)
	
	var new_spells: Array = level_up_data.get(
		"selected_spells",
		[]
	)
	
	var new_spell_slots: Dictionary = (
		level_up_data.get(
			"new_spell_slots",
			{}
		)
	)
	
	# =====================================================
	# NÍVEL
	# =====================================================
	var previous_constitution_modifier: int = get_constitution_modifier()
	level = new_level
	for attribute_key in attribute_increases:
		set(str(attribute_key), int(get(str(attribute_key))) + int(attribute_increases[attribute_key]))
	
	# =====================================================
	# PONTOS DE VIDA DO NÍVEL
	# =====================================================
	var racial_hp_gain: int = 1 if character_race == "Anão" else 0
	var constitution_hp_gain: int = (get_constitution_modifier() - previous_constitution_modifier) * level
	max_hp += hp_gain + racial_hp_gain + constitution_hp_gain
	hp += hp_gain + racial_hp_gain + constitution_hp_gain
	
	# attack_power não aumenta aqui.
	# O ataque evolui pelo Bônus Base de Ataque,
	# calculado conforme o nível e a classe.
	
	# Progressão natural já existente no projeto.
	if level % 3 == 0:
		max_movement_meters += 1.5
	
	# =====================================================
	# RESISTÊNCIAS BASE
	# =====================================================
	if fortitude_type == "bom":
		fortitude_base_bonus = (
			2
			+ int(
				floor(
					level / 2.0
				)
			)
		)
	else:
		fortitude_base_bonus = int(
			floor(
				level / 3.0
			)
		)
	
	if reflex_type == "bom":
		reflex_base_bonus = (
			2
			+ int(
				floor(
					level / 2.0
				)
			)
		)
	else:
		reflex_base_bonus = int(
			floor(
				level / 3.0
			)
		)
	if character_class == "Bárbaro":
		reflex_base_bonus += 2
	
	if will_type == "bom":
		will_base_bonus = (
			2
			+ int(
				floor(
					level / 2.0
				)
			)
		)
	else:
		will_base_bonus = int(
			floor(
				level / 3.0
			)
		)
	
	# =====================================================
	# TALENTOS
	# =====================================================
	var previous_feat_hp_bonus: int = (
		feat_max_hp_bonus
	)
	
	var previous_feat_movement_bonus: float = (
		feat_movement_bonus
	)
	var previous_feat_spell_slot_bonus: int = feat_extra_spell_slot_level_1
	
	var updated_feats: Array = (
		selected_feats.duplicate()
	)
	
	for feat_name_value in new_feats:
		var feat_name: String = str(
			feat_name_value
		)
		
		if feat_name == "":
			continue
		
		if updated_feats.has(feat_name):
			continue
		
		updated_feats.append(
			feat_name
		)
	
	setup_feats(updated_feats)
	
	# =====================================================
	# DIFERENÇA DE VIDA DOS TALENTOS
	# =====================================================
	var feat_hp_difference: int = (
		feat_max_hp_bonus
		- previous_feat_hp_bonus
	)
	
	if feat_hp_difference != 0:
		max_hp += feat_hp_difference
		hp += feat_hp_difference
	
	max_hp = max(
		1,
		max_hp
	)
	
	hp = clampi(
		hp,
		0,
		max_hp
	)
	
	# =====================================================
	# DIFERENÇA DE MOVIMENTO DOS TALENTOS
	# =====================================================
	var feat_movement_difference: float = (
		feat_movement_bonus
		- previous_feat_movement_bonus
	)
	
	if not is_zero_approx(
		feat_movement_difference
	):
		max_movement_meters += (
			feat_movement_difference
		)
	
	max_movement_meters = maxf(
		0.0,
		max_movement_meters
	)
	
	current_movement_meters = (
		max_movement_meters
	)
	
	# =====================================================
	# MAGIAS ESCOLHIDAS
	# =====================================================
	for spell_name_value in new_spells:
		var spell_name: String = str(
			spell_name_value
		)
		
		if spell_name == "":
			continue
		
		if known_spells.has(spell_name):
			continue
		
		known_spells.append(
			spell_name
		)
	
	# =====================================================
	# MAGIAS AUTOMÁTICAS
	# =====================================================
	if character_class in [
		"Clérigo",
		"Druida"
	]:
		setup_class_spells()
	
	# =====================================================
	# ESPAÇOS DE MAGIA
	# =====================================================
	if not new_spell_slots.is_empty():
		max_spell_slots_level_0 = int(
			new_spell_slots.get(
				0,
				new_spell_slots.get(
					"0",
					max_spell_slots_level_0
				)
			)
		)
		
		max_spell_slots_level_1 = int(
			new_spell_slots.get(
				1,
				new_spell_slots.get(
					"1",
					max_spell_slots_level_1
				)
			)
		)
		max_spell_slots_level_1 += feat_extra_spell_slot_level_1
		
		max_spell_slots_level_2 = int(
			new_spell_slots.get(
				2,
				new_spell_slots.get(
					"2",
					max_spell_slots_level_2
				)
			)
		)
		
		spell_slots_level_0 = (
			max_spell_slots_level_0
		)
		
		spell_slots_level_1 = (
			max_spell_slots_level_1
		)
		
		spell_slots_level_2 = (
			max_spell_slots_level_2
		)
	else:
		var extra_slots: int = feat_extra_spell_slot_level_1 - previous_feat_spell_slot_bonus
		max_spell_slots_level_1 += extra_slots
		spell_slots_level_1 += extra_slots
	
	# =====================================================
	# PROGRESSÕES DA CLASSE
	# =====================================================
	update_class_scaling()
	
	# =====================================================
	# EXPERIÊNCIA PENDENTE
	# =====================================================
	pending_level_ups = max(
		0,
		calculate_level_from_xp(total_xp)
		- level
	)
	
	xp_to_next_level = (
		get_xp_needed_for_current_level()
	)
	
	update_health_bar()
	
	print(
		character_name,
		" subiu para o nível ",
		level,
		"."
	)
	
	print(
		"Vida recebida pelo nível: ",
		hp_gain
	)
	
	if feat_hp_difference != 0:
		print(
			"Vida recebida por talentos: ",
			feat_hp_difference
		)
	
	if not is_zero_approx(
		feat_movement_difference
	):
		print(
			"Movimento recebido por talentos: ",
			feat_movement_difference,
			" metros"
		)
	
	print(
		"Vida atual: ",
		hp,
		"/",
		max_hp
	)
	
	print(
		"Movimento máximo: ",
		max_movement_meters,
		" metros"
	)
	
	if not new_feats.is_empty():
		print(
			"Novos talentos: ",
			new_feats
		)
	
	if not new_spells.is_empty():
		print(
			"Novas magias: ",
			new_spells
		)
	
	print(
		"Espaços de magia: círculo 0 = ",
		spell_slots_level_0,
		"/",
		max_spell_slots_level_0,
		", círculo 1 = ",
		spell_slots_level_1,
		"/",
		max_spell_slots_level_1,
		", círculo 2 = ",
		spell_slots_level_2,
		"/",
		max_spell_slots_level_2
	)
	
	return true

func apply_attributes(
	new_strength: int,
	new_dexterity: int,
	new_constitution: int,
	new_wisdom: int,
	new_intelligence: int,
	new_charisma: int
):
	strength = new_strength
	dexterity = new_dexterity
	constitution = new_constitution
	wisdom = new_wisdom
	intelligence = new_intelligence
	charisma = new_charisma


func get_attribute_modifier(attribute_value: int) -> int:
	return floor((attribute_value - 10) / 2.0)


func get_strength_modifier() -> int:
	return get_attribute_modifier(strength)


func get_dexterity_modifier() -> int:
	return get_attribute_modifier(dexterity)


func get_constitution_modifier() -> int:
	return get_attribute_modifier(constitution)


func get_wisdom_modifier() -> int:
	return get_attribute_modifier(wisdom)


func get_intelligence_modifier() -> int:
	return get_attribute_modifier(intelligence)


func get_charisma_modifier() -> int:
	return get_attribute_modifier(charisma)


func get_attributes_text() -> String:
	return (
		"FOR " + str(strength) + " (" + format_modifier(get_strength_modifier()) + ")  " +
		"DES " + str(dexterity) + " (" + format_modifier(get_dexterity_modifier()) + ")\n" +
		"CON " + str(constitution) + " (" + format_modifier(get_constitution_modifier()) + ")  " +
		"SAB " + str(wisdom) + " (" + format_modifier(get_wisdom_modifier()) + ")\n" +
		"INT " + str(intelligence) + " (" + format_modifier(get_intelligence_modifier()) + ")  " +
		"CAR " + str(charisma) + " (" + format_modifier(get_charisma_modifier()) + ")"
	)


func format_modifier(value: int) -> String:
	if value >= 0:
		return "+" + str(value)
	
	return str(value)
func get_armor_class() -> int:
	var base_armor_class_value: int = 10
	
	var dexterity_modifier: int = get_dexterity_modifier()
	var armor_bonus_value: int = 0
	var shield_bonus_value: int = 0
	
	if has_method("get_equipped_armor_data"):
		var armor_data: Dictionary = get_equipped_armor_data()
		armor_bonus_value = int(armor_data.get("armor_bonus", 0))
	
	if has_method("get_equipped_shield_data"):
		var shield_data: Dictionary = get_equipped_shield_data()
		shield_bonus_value = int(shield_data.get("shield_bonus", 0))
	
	var armor_class_value: int = (
	base_armor_class_value +
	dexterity_modifier +
	armor_bonus_value +
	shield_bonus_value +
	get_monk_wisdom_ac_bonus() +
	size_modifier +
	dodge_bonus +
	deflection_bonus +
	natural_armor_bonus +
	other_ac_bonus +
	feat_armor_class_bonus +
	(feat_monk_armor_class_bonus if character_class == "Monge" and armor_bonus_value == 0 else 0) +
	(feat_magic_armor_class_bonus if temporary_effects_active else 0) +
	temporary_armor_class_bonus
)
	
	if is_raging:
		armor_class_value -= rage_ac_penalty
	
	return armor_class_value

func get_touch_armor_class() -> int:
	return (
		base_armor_class +
		get_dexterity_modifier() +
		get_monk_wisdom_ac_bonus() +
		size_modifier +
		dodge_bonus +
		deflection_bonus +
		other_ac_bonus
	)


func get_flat_footed_armor_class() -> int:
	return (
		base_armor_class +
		armor_bonus +
		shield_bonus +
		size_modifier +
		deflection_bonus +
		natural_armor_bonus +
		other_ac_bonus
	)


func get_fortitude_save() -> int:
	return fortitude_base_bonus + get_constitution_modifier() + get_divine_grace_bonus() + feat_fortitude_bonus + get_racial_save_bonus()


func get_reflex_save() -> int:
	return reflex_base_bonus + get_dexterity_modifier() + get_divine_grace_bonus() + feat_reflex_bonus + get_racial_save_bonus()


func get_will_save() -> int:
	return will_base_bonus + get_wisdom_modifier() + get_divine_grace_bonus() + feat_will_bonus + get_racial_save_bonus()

func get_racial_save_bonus() -> int:
	return 1 if character_race == "Gnomo" or (character_race == "Meio-Orc" and unstoppable_active) else 0

func get_fortitude_save_bonus() -> int:
	return get_fortitude_save()

func get_reflex_save_bonus() -> int:
	return get_reflex_save()

func get_will_save_bonus() -> int:
	return get_will_save()

func get_base_attack_bonus() -> int:
	if base_attack_bonus_type == "alto":
		return level
	
	if base_attack_bonus_type == "medio":
		return int(floor(level * 0.75))
	
	if base_attack_bonus_type == "baixo":
		return int(floor(level * 0.5))
	
	return 0

func get_melee_attack_bonus() -> int:
	return get_base_attack_bonus() + get_strength_modifier() + size_modifier


func get_ranged_attack_bonus() -> int:
	return get_base_attack_bonus() + get_dexterity_modifier() + size_modifier + (1 if character_race == "Elfo" else 0)


func get_melee_damage() -> int:
	var final_damage := attack_power + get_strength_modifier()
	
	if final_damage < 1:
		final_damage = 1
	
	return final_damage


func get_two_handed_melee_damage() -> int:
	var strength_damage_bonus := int(floor(get_strength_modifier() * 1.5))
	var final_damage := attack_power + strength_damage_bonus
	
	if final_damage < 1:
		final_damage = 1
	
	return final_damage
func get_equipped_weapon_data() -> Dictionary:
	var equipped_weapon_id: String = (
		ItemDatabase.resolve_item_id(
			equipped_weapon,
			"weapon"
		)
	)
	
	var weapon_data: Dictionary = (
		ItemDatabase.get_item(
			equipped_weapon_id
		)
	)
	
	if weapon_data.is_empty():
		weapon_data = ItemDatabase.get_item(
			"unarmed"
		)
		
		equipped_weapon_id = "unarmed"
	
	# Compatibilidade com as funções antigas do herói,
	# que ainda procuram a chave "type".
	weapon_data["type"] = str(
		weapon_data.get(
			"weapon_type",
			"melee"
		)
	)
	
	if (
		character_class == "Monge"
		and equipped_weapon_id == "unarmed"
	):
		if level >= 20:
			weapon_data["damage_dice_count"] = 2
			weapon_data["damage_dice"] = 10
		
		elif level >= 16:
			weapon_data["damage_dice_count"] = 2
			weapon_data["damage_dice"] = 8
		
		elif level >= 12:
			weapon_data["damage_dice_count"] = 2
			weapon_data["damage_dice"] = 6
		
		elif level >= 8:
			weapon_data["damage_dice_count"] = 1
			weapon_data["damage_dice"] = 10
		
		elif level >= 4:
			weapon_data["damage_dice_count"] = 1
			weapon_data["damage_dice"] = 8
		
		else:
			weapon_data["damage_dice_count"] = 1
			weapon_data["damage_dice"] = 6
	
	return weapon_data

func equip_weapon(
	weapon_reference: String
) -> bool:
	var weapon_id: String = (
		ItemDatabase.resolve_item_id(
			weapon_reference,
			"weapon"
		)
	)
	
	if weapon_id == "":
		print(
			"Arma não encontrada: ",
			weapon_reference
		)
		
		return false
	
	var weapon_data: Dictionary = (
		ItemDatabase.get_item(
			weapon_id
		)
	)
	
	if weapon_data.is_empty():
		return false
	
	equipped_weapon = str(
		weapon_data.get(
			"display_name",
			"Soco"
		)
	)
	apply_feat_bonuses()
	
	print(
		"Arma equipada: ",
		equipped_weapon
	)
	
	return true


func get_weapon_type() -> String:
	var weapon = get_equipped_weapon_data()
	return str(weapon.get("type", "melee"))


func get_weapon_range_meters() -> float:
	var weapon = get_equipped_weapon_data()
	return float(weapon.get("range_meters", 1.5))


func get_weapon_critical_min() -> int:
	var weapon = get_equipped_weapon_data()
	return int(weapon.get("critical_min", 20))


func get_weapon_critical_multiplier() -> int:
	var weapon = get_equipped_weapon_data()
	return int(weapon.get("critical_multiplier", 2))


func roll_weapon_damage() -> int:
	var weapon = get_equipped_weapon_data()
	var dice_count := int(weapon.get("damage_dice_count", 1))
	var dice_size := int(weapon.get("damage_dice", 6))
	
	var total_damage := 0
	
	for i in range(dice_count):
		total_damage += randi_range(1, dice_size)
	
	return total_damage


func get_weapon_damage_bonus() -> int:
	var weapon = get_equipped_weapon_data()
	var weapon_type := str(weapon.get("type", "melee"))
	var is_two_handed := bool(weapon.get("two_handed", false))
	
	if weapon_type == "melee":
		if is_two_handed:
			return int(floor(get_strength_modifier() * 1.5))
		
		return get_strength_modifier()
	
	return 0


func roll_total_weapon_damage() -> int:
	damage = roll_weapon_damage() + get_weapon_damage_bonus() + get_racial_damage_bonus()
	
	if damage < 1:
		damage = 1
	
	return damage

func get_weapon_attack_bonus() -> int:
	var weapon_type := get_weapon_type()
	
	if weapon_type == "ranged":
		return get_ranged_attack_bonus()
	
	return get_melee_attack_bonus()


func get_weapon_description() -> String:
	var weapon = get_equipped_weapon_data()
	var dice_count := int(weapon.get("damage_dice_count", 1))
	var dice_size := int(weapon.get("damage_dice", 6))
	var range_meters := float(weapon.get("range_meters", 1.5))
	var critical_min := int(weapon.get("critical_min", 20))
	
	return (
		equipped_weapon +
		" | " + str(dice_count) + "d" + str(dice_size) +
		" | Alcance " + str(range_meters) + "m" +
		" | Crítico " + str(critical_min) + "-20"
	)
func apply_race_data(
	new_race: String,
	new_size: String,
	new_size_modifier: int,
	new_favored_class: String,
	new_race_traits: Array
):
	character_race = new_race
	character_size = new_size
	size_modifier = new_size_modifier
	favored_class = new_favored_class
	race_traits = new_race_traits
func apply_class_data(
	new_hit_die: int,
	new_fixed_hp_per_level: int,
	new_hp_progression_mode: String,
	new_base_attack_bonus_type: String,
	new_fortitude_base_bonus: int,
	new_reflex_base_bonus: int,
	new_will_base_bonus: int,
	new_class_movement_bonus: float,
	new_damage_reduction: int,
	new_class_features: Array
):
	class_hit_die = new_hit_die
	hp_fixed_per_level = new_fixed_hp_per_level
	hp_progression_mode = new_hp_progression_mode
	base_attack_bonus_type = new_base_attack_bonus_type
	
	fortitude_base_bonus = new_fortitude_base_bonus
	reflex_base_bonus = new_reflex_base_bonus
	will_base_bonus = new_will_base_bonus
	
	class_movement_bonus = new_class_movement_bonus
	damage_reduction = new_damage_reduction
	class_features = new_class_features
	update_class_scaling()
	
func can_use_rage() -> bool:
	return character_class == "Bárbaro" and not is_raging and rage_uses_this_battle < 1 + feat_extra_rage_uses


func activate_rage():
	if not can_use_rage():
		print("Fúria indisponível.")
		return
	
	is_raging = true
	rage_used = true
	rage_uses_this_battle += 1
	rage_turns_remaining = 3 + get_constitution_modifier()
	
	if rage_turns_remaining < 1:
		rage_turns_remaining = 1
	
	strength += rage_strength_bonus
	constitution += rage_constitution_bonus
	will_base_bonus += rage_will_bonus
	armor_bonus -= rage_ac_penalty
	
	var extra_hp: int = 2 * level
	max_hp += extra_hp
	hp += extra_hp
	
	print(character_name, " entrou em Fúria por ", rage_turns_remaining, " turnos!")

func can_use_smite_evil() -> bool:
	return character_class == "Paladino" and not smite_evil_used and not smite_evil_active

func can_use_hide_skill() -> bool:
	if character_class != "Ladino":
		return false
	
	if hide_used_this_turn:
		return false
	
	if has_attacked:
		return false
	
	return true


func use_hide_skill():
	if character_class != "Ladino":
		print("Apenas Ladinos podem usar Esconder-se.")
		return
	
	if hide_used_this_turn:
		print("Esconder-se já foi usado neste turno.")
		return
	
	if has_attacked:
		print("Não é possível esconder-se depois de atacar.")
		return
	
	set_hidden_state(true)
	enemy_is_surprised = true
	hide_used_this_turn = true
	hide_checked_enemies.clear()
	
	print("Ladino se escondeu.")


func reveal_after_attack():
	set_hidden_state(false)
	hide_checked_enemies.clear()

func activate_smite_evil():
	if not can_use_smite_evil():
		print("Destruir o Mal indisponível.")
		return
	
	smite_evil_active = true
	print(character_name, " preparou Destruir o Mal!")


func consume_smite_evil():
	if not smite_evil_active:
		return
	
	smite_evil_active = false
	smite_evil_used = true
	print("Destruir o Mal consumido.")


func get_smite_evil_attack_bonus() -> int:
	if character_class != "Paladino":
		return 0
	
	if not smite_evil_active:
		return 0
	
	return get_charisma_modifier()


func get_smite_evil_damage_bonus() -> int:
	if character_class != "Paladino":
		return 0
	
	if not smite_evil_active:
		return 0
	
	return level

func get_divine_grace_bonus() -> int:
	if character_class != "Paladino":
		return 0
	
	var charisma_modifier := get_charisma_modifier()
	
	if charisma_modifier < 0:
		return 0
	
	return charisma_modifier


func get_monk_wisdom_ac_bonus() -> int:
	if character_class != "Monge":
		return 0
	
	if equipped_armor != "Nenhuma":
		return 0
	
	if equipped_shield != "Nenhum":
		return 0
	
	var wisdom_modifier: int = get_wisdom_modifier()
	
	if wisdom_modifier < 0:
		return 0
	
	return wisdom_modifier


func get_sneak_attack_damage() -> int:
	if character_class != "Ladino":
		return 0
	
	var total := 0
	
	for i in range(sneak_attack_dice_count):
		total += randi_range(1, 6)
	
	return total


func can_sneak_attack(target_is_vulnerable: bool) -> bool:
	return character_class == "Ladino" and target_is_vulnerable
func update_class_scaling():
	if character_class == "Bárbaro":
		if level >= 15:
			damage_reduction = 10
		elif level >= 10:
			damage_reduction = 5
		else:
			damage_reduction = 0
	
	if character_class == "Ladino":
		sneak_attack_dice_count = 1 + int(floor((level - 1) / 2.0))
		sneak_attack_dice_count += feat_sneak_attack_extra_dice
func update_rage_turn(current_battle_turn: int = 0):
	if not is_raging:
		rage_turns_remaining = 0
		rage_end_turn = 0
		return
	
	# Se ainda não estiver usando contador de turno, mantém segurança.
	if current_battle_turn <= 0:
		return
	
	rage_turns_remaining = rage_end_turn - current_battle_turn
	
	if rage_turns_remaining <= 0:
		end_rage()
		return
	
	print("Fúria restante: ", rage_turns_remaining, " turnos")


func end_rage():
	if not is_raging:
		return
	
	strength -= rage_strength_bonus
	constitution -= rage_constitution_bonus
	will_base_bonus -= rage_will_bonus
	armor_bonus += rage_ac_penalty
	max_hp = maxi(1, max_hp - 2 * level)
	hp = clampi(hp, 0, max_hp)
	is_raging = false
	rage_turns_remaining = 0
	rage_end_turn = 0
	
	print("A fúria acabou.")

func equip_armor(
	armor_reference: String
) -> bool:
	var armor_id: String = (
		ItemDatabase.resolve_item_id(
			armor_reference,
			"armor"
		)
	)
	
	if armor_id == "":
		print(
			"Armadura não encontrada: ",
			armor_reference
		)
		
		return false
	
	var armor_data: Dictionary = (
		ItemDatabase.get_item(
			armor_id
		)
	)
	
	if armor_data.is_empty():
		return false
	
	equipped_armor = str(
		armor_data.get(
			"display_name",
			"Nenhuma"
		)
	)
	
	update_equipment_bonuses()
	
	print(
		"Armadura equipada: ",
		equipped_armor
	)
	
	return true


func equip_shield(
	shield_reference: String
) -> bool:
	var shield_id: String = (
		ItemDatabase.resolve_item_id(
			shield_reference,
			"shield"
		)
	)
	
	if shield_id == "":
		print(
			"Escudo não encontrado: ",
			shield_reference
		)
		
		return false
	
	var shield_data: Dictionary = (
		ItemDatabase.get_item(
			shield_id
		)
	)
	
	if shield_data.is_empty():
		return false
	
	equipped_shield = str(
		shield_data.get(
			"display_name",
			"Nenhum"
		)
	)
	
	update_equipment_bonuses()
	
	print(
		"Escudo equipado: ",
		equipped_shield
	)
	
	return true

func get_equipped_armor_data() -> Dictionary:
	var equipped_armor_id: String = (
		ItemDatabase.resolve_item_id(
			equipped_armor,
			"armor"
		)
	)
	
	var armor_data: Dictionary = (
		ItemDatabase.get_item(
			equipped_armor_id
		)
	)
	
	if armor_data.is_empty():
		return ItemDatabase.get_item(
			"no_armor"
		)
	
	return armor_data


func get_equipped_shield_data() -> Dictionary:
	var equipped_shield_id: String = (
		ItemDatabase.resolve_item_id(
			equipped_shield,
			"shield"
		)
	)
	
	var shield_data: Dictionary = (
		ItemDatabase.get_item(
			equipped_shield_id
		)
	)
	
	if shield_data.is_empty():
		return ItemDatabase.get_item(
			"no_shield"
		)
	
	return shield_data

func update_equipment_bonuses():
	var armor_data: Dictionary = get_equipped_armor_data()
	var shield_data: Dictionary = get_equipped_shield_data()
	
	armor_bonus = int(armor_data.get("armor_bonus", 0))
	shield_bonus = int(shield_data.get("shield_bonus", 0))
func get_equipment_movement_penalty() -> float:
	var armor_data: Dictionary = get_equipped_armor_data()
	var shield_data: Dictionary = get_equipped_shield_data()
	
	var armor_penalty: float = float(armor_data.get("movement_penalty", 0.0))
	var shield_penalty: float = float(shield_data.get("movement_penalty", 0.0))
	
	if character_class == "Bárbaro":
		var armor_type: String = str(armor_data.get("armor_type", "none"))
		
		if armor_type == "light" or armor_type == "medium":
			armor_penalty = 0.0
	
	return armor_penalty + shield_penalty
func get_final_movement_meters() -> float:
	var final_movement: float = max_movement_meters - get_equipment_movement_penalty()
	
	if final_movement < 1.5:
		final_movement = 1.5
	
	return final_movement

func get_class_spell_damage_bonus(spell_level: int) -> int:
	if character_class == "Feiticeiro":
		return maxi(0, spell_level)
	return 0

func setup_class_spells(
	saved_known_spells: Array = []
) -> void:
	spell_slots_level_0 = 0
	spell_slots_level_1 = 0
	spell_slots_level_2 = 0
	
	max_spell_slots_level_0 = 0
	max_spell_slots_level_1 = 0
	max_spell_slots_level_2 = 0
	
	if SpellDatabase == null:
		known_spells.clear()
		return
	
	var spellcasting_classes: Array[String] = [
		"Bardo",
		"Clérigo",
		"Druida",
		"Feiticeiro",
		"Mago",
		"Paladino",
		"Ranger"
	]
	
	if not spellcasting_classes.has(
		character_class
	):
		known_spells.clear()
		return
	
	var level_manager := LevelUpManager.new()
	
	var maximum_spell_level: int = (
		level_manager.get_max_spell_level_for_class(
			character_class,
			level
		)
	)
	
	var class_spells: Array = (
		SpellDatabase.get_spells_for_class(
			character_class
		)
	)
	
	var source_spells: Array = []
	
	# Clérigos e Druidas conhecem automaticamente
	# todas as magias disponíveis para seu nível.
	if character_class in [
		"Clérigo",
		"Druida"
	]:
		source_spells = class_spells.duplicate()
	
	# Tenta restaurar as magias persistidas.
	elif not saved_known_spells.is_empty():
		source_spells = (
			saved_known_spells.duplicate()
		)
	
	# Preserva as magias que já estejam no herói.
	elif not known_spells.is_empty():
		source_spells = known_spells.duplicate()
	
	# Compatibilidade com personagens e saves antigos.
	else:
		source_spells = class_spells.duplicate()
	
	var validated_spells: Array = []
	
	for spell_name_value in source_spells:
		var spell_name: String = str(
			spell_name_value
		)
		
		if spell_name == "":
			continue
		
		if validated_spells.has(spell_name):
			continue
		
		if not class_spells.has(spell_name):
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
		
		if maximum_spell_level < 0:
			continue
		
		if spell_level > maximum_spell_level:
			continue
		
		validated_spells.append(
			spell_name
		)
	
	known_spells = validated_spells
	
	var spell_slots: Dictionary = (
		level_manager.get_spell_slot_limits(
			character_class,
			level
		)
	)
	
	max_spell_slots_level_0 = int(
		spell_slots.get(
			0,
			0
		)
	)
	
	max_spell_slots_level_1 = int(
		spell_slots.get(
			1,
			0
		)
	)
	
	max_spell_slots_level_2 = int(
		spell_slots.get(
			2,
			0
		)
	)
	
	# Ao configurar a classe, os espaços começam cheios.
	# Posteriormente o carregamento poderá restaurar
	# os valores restantes que estiverem no GameState.
	spell_slots_level_0 = (
		max_spell_slots_level_0
	)
	
	spell_slots_level_1 = (
		max_spell_slots_level_1
	)
	
	spell_slots_level_2 = (
		max_spell_slots_level_2
	)
	
	print(
		"Magias configuradas para ",
		character_name,
		": ",
		known_spells
	)
	
	print(
		"Espaços de magia: círculo 0 = ",
		spell_slots_level_0,
		"/",
		max_spell_slots_level_0,
		", círculo 1 = ",
		spell_slots_level_1,
		"/",
		max_spell_slots_level_1,
		", círculo 2 = ",
		spell_slots_level_2,
		"/",
		max_spell_slots_level_2
	)
	
func update_temporary_effects_turn(current_battle_turn: int = 0):
	if not temporary_effects_active:
		temporary_attack_bonus = 0
		temporary_damage_bonus = 0
		temporary_armor_class_bonus = 0
		temporary_movement_bonus = 0.0
		temporary_effects_turns_remaining = 0
		temporary_effects_end_turn = 0
		return
	
	if current_battle_turn <= 0:
		return
	
	if current_battle_turn >= temporary_effects_end_turn:
		temporary_attack_bonus = 0
		temporary_damage_bonus = 0
		temporary_armor_class_bonus = 0
		temporary_movement_bonus = 0.0
		temporary_effects_turns_remaining = 0
		temporary_effects_end_turn = 0
		temporary_effects_active = false
		
		print("Efeitos temporários do herói acabaram.")
		return
	
	temporary_effects_turns_remaining = temporary_effects_end_turn - current_battle_turn
	
func setup_feats(new_feats: Array):
	selected_feats = new_feats.duplicate()
	apply_feat_bonuses()
	if character_class == "Ladino":
		update_class_scaling()


func has_feat(feat_name: String) -> bool:
	return selected_feats.has(feat_name)


func apply_feat_bonuses():
	feat_max_hp_bonus = 0
	feat_armor_class_bonus = 0
	feat_attack_bonus = 0
	feat_damage_bonus = 0
	feat_hide_bonus = 0
	feat_sneak_attack_extra_dice = 0
	feat_spell_power_bonus = 0
	feat_spell_damage_bonus = 0
	feat_healing_bonus = 0
	feat_divine_healing_bonus = 0
	feat_initiative_bonus = 0
	feat_spell_range_bonus = 0.0
	feat_extra_spell_slot_level_1 = 0
	feat_extra_rage_uses = 0
	feat_extra_opportunity_attacks = 0
	feat_surprise_attack_bonus = 0
	feat_hidden_damage_bonus = 0
	feat_flanking_attack_bonus = 0
	feat_flanking_damage_bonus = 0
	feat_monk_armor_class_bonus = 0
	feat_magic_armor_class_bonus = 0
	feat_divine_buff_duration_bonus = 0
	feat_animal_companion_hp_bonus = 0
	
	feat_melee_attack_bonus = 0
	feat_melee_damage_bonus = 0
	feat_ranged_attack_bonus = 0
	feat_ranged_damage_bonus = 0
	feat_unarmed_damage_bonus = 0
	feat_rage_damage_bonus = 0
	
	feat_fortitude_bonus = 0
	feat_reflex_bonus = 0
	feat_will_bonus = 0
	feat_observe_bonus = 0
	feat_movement_bonus = 0.0
	
	feat_animal_companion_attack_bonus = 0
	feat_animal_companion_damage_bonus = 0
	feat_animal_companion_armor_bonus = 0
	feat_animal_companion_movement_bonus = 0.0
	
	for feat_name in selected_feats:
		var full_feat_name: String = str(feat_name)
		var base_feat_name: String = full_feat_name
		
		if full_feat_name.contains(":"):
			base_feat_name = full_feat_name.split(":")[0].strip_edges()
		
		var feat_data: Dictionary = FeatDatabase.get_feat_data(base_feat_name)
		
		if feat_data.is_empty():
			continue
		
		var effects: Dictionary = feat_data.get("effects", {})
		
		# =====================================================
		# HP / DEFESA
		# =====================================================
		if effects.has("max_hp_bonus"):
			feat_max_hp_bonus += int(effects["max_hp_bonus"])
		
		if effects.has("armor_class_bonus"):
			feat_armor_class_bonus += int(effects["armor_class_bonus"])
		
		if effects.has("movement_bonus"):
			feat_movement_bonus += float(effects["movement_bonus"])
		if effects.has("initiative_bonus"):
			feat_initiative_bonus += int(effects["initiative_bonus"])
		if effects.has("spell_range_bonus"):
			feat_spell_range_bonus += float(effects["spell_range_bonus"])
		if effects.has("extra_spell_slot_level_1"):
			feat_extra_spell_slot_level_1 += int(effects["extra_spell_slot_level_1"])
		if effects.has("extra_rage_use"):
			feat_extra_rage_uses += int(effects["extra_rage_use"])
		if effects.has("combat_reflexes") and bool(effects["combat_reflexes"]):
			feat_extra_opportunity_attacks += 1
		if effects.has("extra_opportunity_attack"):
			feat_extra_opportunity_attacks += int(effects["extra_opportunity_attack"])
		if effects.has("surprise_attack_bonus"):
			feat_surprise_attack_bonus += int(effects["surprise_attack_bonus"])
		if effects.has("hidden_damage_bonus"):
			feat_hidden_damage_bonus += int(effects["hidden_damage_bonus"])
		if effects.has("flanking_attack_bonus"):
			feat_flanking_attack_bonus += int(effects["flanking_attack_bonus"])
		if effects.has("flanking_damage_bonus"):
			feat_flanking_damage_bonus += int(effects["flanking_damage_bonus"])
		if effects.has("monk_armor_class_bonus"):
			feat_monk_armor_class_bonus += int(effects["monk_armor_class_bonus"])
		if effects.has("magic_armor_class_bonus"):
			feat_magic_armor_class_bonus += int(effects["magic_armor_class_bonus"])
		if effects.has("divine_buff_duration_bonus"):
			feat_divine_buff_duration_bonus += int(effects["divine_buff_duration_bonus"])
		if effects.has("holy_damage_bonus"):
			feat_damage_bonus += int(effects["holy_damage_bonus"])
		
		# =====================================================
		# RESISTÊNCIAS / PERCEPÇÃO
		# =====================================================
		if effects.has("fortitude_bonus"):
			feat_fortitude_bonus += int(effects["fortitude_bonus"])
		
		if effects.has("reflex_bonus"):
			feat_reflex_bonus += int(effects["reflex_bonus"])
		
		if effects.has("will_bonus"):
			feat_will_bonus += int(effects["will_bonus"])
		
		if effects.has("observe_bonus"):
			feat_observe_bonus += int(effects["observe_bonus"])
		
		# =====================================================
		# ATAQUE / DANO GERAL
		# =====================================================
		if effects.has("attack_bonus"):
			feat_attack_bonus += int(effects["attack_bonus"])
		
		if effects.has("damage_bonus"):
			if base_feat_name == "Golpe Brutal":
				feat_melee_damage_bonus += int(effects["damage_bonus"])
			else:
				feat_damage_bonus += int(effects["damage_bonus"])
		
		if effects.has("power_attack_damage_bonus"):
			feat_melee_damage_bonus += int(effects["power_attack_damage_bonus"])
		
		if effects.has("power_attack_attack_penalty"):
			feat_melee_attack_bonus += int(effects["power_attack_attack_penalty"])
		
		# =====================================================
		# CORPO A CORPO
		# =====================================================
		if effects.has("melee_attack_bonus"):
			feat_melee_attack_bonus += int(effects["melee_attack_bonus"])
		
		if effects.has("melee_damage_bonus"):
			feat_melee_damage_bonus += int(effects["melee_damage_bonus"])
		
		# =====================================================
		# DISTÂNCIA
		# =====================================================
		if effects.has("ranged_attack_bonus"):
			feat_ranged_attack_bonus += int(effects["ranged_attack_bonus"])
		
		if effects.has("ranged_damage_bonus"):
			feat_ranged_damage_bonus += int(effects["ranged_damage_bonus"])
		
		# =====================================================
		# DESARMADO / MONGE
		# =====================================================
		if effects.has("unarmed_damage_bonus"):
			feat_unarmed_damage_bonus += int(effects["unarmed_damage_bonus"])
		
		# =====================================================
		# FÚRIA / BÁRBARO
		# =====================================================
		if effects.has("rage_damage_bonus"):
			feat_rage_damage_bonus += int(effects["rage_damage_bonus"])
		
		# =====================================================
		# LADINO / FURTIVO
		# =====================================================
		if effects.has("hide_bonus"):
			feat_hide_bonus += int(effects["hide_bonus"])
		
		if effects.has("sneak_attack_extra_dice"):
			feat_sneak_attack_extra_dice += int(effects["sneak_attack_extra_dice"])
		
		# =====================================================
		# MAGIA
		# Por enquanto fica geral.
		# Depois vamos separar por Dano, Cura, Buff e Controle.
		# =====================================================
		if effects.has("spell_power_bonus"):
			feat_spell_power_bonus += int(effects["spell_power_bonus"])
		
		if effects.has("spell_damage_bonus"):
			feat_spell_damage_bonus += int(effects["spell_damage_bonus"])
		
		if effects.has("healing_bonus"):
			feat_healing_bonus += int(effects["healing_bonus"])
		
		if effects.has("divine_healing_bonus"):
			feat_divine_healing_bonus += int(effects["divine_healing_bonus"])
		
		# =====================================================
		# FOCO EM ARMA
		# Exemplo: Foco em Arma: Espada Curta
		# =====================================================
		if base_feat_name == "Foco em Arma":
			if full_feat_name.contains(":"):
				var chosen_weapon: String = full_feat_name.split(":")[1].strip_edges()
				
				if chosen_weapon == equipped_weapon:
					feat_attack_bonus += 1
		
		# =====================================================
		# ESPECIALIZAÇÃO EM ARMA
		# Exemplo: Especialização em Arma: Espada Curta
		# =====================================================
		if base_feat_name == "Especialização em Arma":
			if full_feat_name.contains(":"):
				var chosen_specialized_weapon: String = full_feat_name.split(":")[1].strip_edges()
				
				if chosen_specialized_weapon == equipped_weapon:
					feat_damage_bonus += 2
		
		# =====================================================
		# FOCO EM MAGIA
		# Exemplo: Foco em Magia: Dano
		# Por enquanto aplica +1 geral em magia.
		# =====================================================
		
		# =====================================================
		# ESPECIALIZAÇÃO EM MAGIA
		# Exemplo: Especialização em Magia: Dano
		# Por enquanto aplica +2 geral em magia.
		# =====================================================
		
		# =====================================================
		# COMPANHEIRO ANIMAL
		# =====================================================
		if effects.has("animal_companion_hp_bonus"):
			feat_animal_companion_hp_bonus += int(effects["animal_companion_hp_bonus"])
		
		if effects.has("animal_companion_attack_bonus"):
			feat_animal_companion_attack_bonus += int(effects["animal_companion_attack_bonus"])
		
		if effects.has("animal_companion_damage_bonus"):
			feat_animal_companion_damage_bonus += int(effects["animal_companion_damage_bonus"])
		
		if effects.has("animal_companion_armor_bonus"):
			feat_animal_companion_armor_bonus += int(effects["animal_companion_armor_bonus"])
		
		if effects.has("animal_companion_movement_bonus"):
			feat_animal_companion_movement_bonus += float(effects["animal_companion_movement_bonus"])
func get_spell_feat_bonus_for_type(spell_type: String) -> int:
	var bonus: int = 0
	
	for feat_name in selected_feats:
		var full_feat_name: String = str(feat_name)
		
		if not full_feat_name.contains(":"):
			continue
		
		var parts: PackedStringArray = full_feat_name.split(":")
		
		if parts.size() < 2:
			continue
		
		var base_feat_name: String = parts[0].strip_edges()
		var chosen_spell_type: String = parts[1].strip_edges()
		
		if chosen_spell_type != spell_type:
			continue
		
		if base_feat_name == "Foco em Magia":
			bonus += 1
		
		elif base_feat_name == "Especialização em Magia":
			bonus += 2
	
	return bonus
func set_rage_end_turn(current_battle_turn: int):
	if not is_raging:
		return
	
	var duration: int = rage_turns_remaining
	
	if duration <= 0:
		duration = 3
	
	rage_end_turn = current_battle_turn + duration
	rage_turns_remaining = rage_end_turn - current_battle_turn
	
	print("Fúria ativa até o turno: ", rage_end_turn)
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


func update_status_effects(current_battle_turn: int):
	var effects_to_remove: Array[String] = []
	
	for effect_name in status_effects.keys():
		var end_turn: int = int(status_effects[effect_name])
		
		if current_battle_turn >= end_turn:
			effects_to_remove.append(effect_name)
	
	for effect_name in effects_to_remove:
		status_effects.erase(effect_name)
		print(name, " perdeu condição: ", effect_name)
func create_health_bar():
	# =====================================================
	# NOME DO HERÓI
	# =====================================================
	health_name_label = Label.new()
	health_name_label.name = "HealthNameLabel"
	health_name_label.position = Vector2(-60, -58)
	health_name_label.size = Vector2(120, 20)
	health_name_label.text = character_name
	health_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	health_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	health_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_name_label.z_index = 22
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
	# PREENCHIMENTO DA VIDA
	# =====================================================
	health_bar_fill = ColorRect.new()
	health_bar_fill.name = "HealthBarFill"
	health_bar_fill.position = Vector2(2, 2)
	health_bar_fill.size = Vector2(50, 4)
	health_bar_fill.color = Color(0.15, 0.85, 0.2, 1.0)
	health_bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_bar_fill.z_index = 21
	
	health_bar_background.add_child(health_bar_fill)
	
	# =====================================================
	# ATUALIZA VALORES
	# =====================================================
	update_health_bar()


func update_health_bar():
	# =====================================================
	# NOME
	# =====================================================
	if is_instance_valid(health_name_label):
		health_name_label.text = character_name
	
	# =====================================================
	# VIDA
	# =====================================================
	if not is_instance_valid(health_bar_fill):
		return
	
	if max_hp <= 0:
		health_bar_fill.size.x = 0.0
		return
	
	var hp_ratio: float = clamp(
		float(hp) / float(max_hp),
		0.0,
		1.0
	)
	
	health_bar_fill.size.x = 50.0 * hp_ratio
func get_pending_level_up_count() -> int:
	if level >= max_level:
		return 0
	
	var target_level: int = (
		calculate_level_from_xp(
			total_xp
		)
	)
	
	target_level = clamp(
		target_level,
		level,
		max_level
	)
	
	pending_level_ups = max(
		0,
		target_level - level
	)
	
	return pending_level_ups
