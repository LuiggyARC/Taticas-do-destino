extends Node2D
const BattleTokenVisual = preload("res://Scene/battle_unit_token.gd")
signal died(npc_unit: Node2D)

var npc_visual_body: CanvasItem
var npc_visual_border: CanvasItem
var battle_portrait_path: String = ""
var death_emitted: bool = false
var race: String = ""
var unstoppable_active: bool = false
var unstoppable_turn_started: bool = false
var unstoppable_used_this_battle: bool = false
var character_class: String = ""
var level: int = 1
var total_xp: int = 0
var xp_to_next_level: int = 1000
var pending_level_ups: int = 0

var touch_armor_class: int = 10
var flat_footed_armor_class: int = 10
var health_name_label: Label
var equipped_armor: String = "Nenhuma"
var equipped_shield: String = "Nenhum"

var fortitude_bonus: int = 0
var reflex_bonus: int = 0
var will_bonus: int = 0
var observe_bonus: int = 0

var feats: Array = []

var feat_attack_bonus: int = 0
var feat_damage_bonus: int = 0

var weapon_focus_name: String = ""
var weapon_focus_attack_bonus: int = 0


var npc_id: String = ""
var display_name: String = "NPC"

var faction: String = "ally"
var control_type: String = "player" # player ou ai

var grid_position: Vector2i = Vector2i.ZERO

var max_hp: int = 10
var hp: int = 10
var armor_class: int = 10

var max_movement_meters: float = 7.5
var current_movement_meters: float = 7.5

var initiative_bonus: int = 0
var base_attack_bonus: int = 0

var strength: int = 10
var dexterity: int = 10
var constitution: int = 10
var intelligence: int = 10
var wisdom: int = 10
var charisma: int = 10

var equipped_weapon: String = "Soco"
var weapon_type: String = "melee"
var damage_dice: int = 3
var damage_dice_count: int = 1
var damage_bonus: int = 0
var weapon_range_meters: float = 1.5

var ai_behavior: String = "defensive"

var attacks_used_this_turn: int = 0
var has_attacked: bool:
	get:
		return attacks_used_this_turn >= get_max_attack_actions()
	set(value):
		attacks_used_this_turn = mini(attacks_used_this_turn + 1, get_max_attack_actions()) if value else 0
var has_opportunity_attacked: bool = false
var is_hidden: bool = false
var hide_used_this_turn: bool = false
var hide_checked_enemies: Dictionary = {}
var hide_bonus: int = 0
var sneak_attack_dice_count: int = 0
var smite_evil_used: bool = false
var smite_evil_active: bool = false
var daily_powers_used: Array = []
var encounter_powers_used: Array = []
var druid_guard_active: bool = false
var cleric_guard_active: bool = false
var fighter_guard_active: bool = false
var druid_form_active: bool = false
var druid_form_end_turn: int = 0
var is_raging: bool = false
var rage_uses_this_battle: int = 0
var rage_end_turn: int = 0

var health_bar_background: ColorRect
var health_bar_fill: ColorRect

var dialogue_intro: String = ""
var dialogue_low_hp: String = ""
var dialogue_victory: String = ""
var temporary_attack_bonus: int = 0
var temporary_damage_bonus: int = 0
var temporary_armor_class_bonus: int = 0
var temporary_movement_bonus: float = 0.0
var temporary_effects_end_turn: int = 0

var status_effects: Dictionary = {}


func _ready():
	create_visual()
	update_world_position()


func play_attack_animation(_target_position: Vector2) -> void:
	pass

func create_visual() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	npc_visual_body = null
	npc_visual_border = null
	var token: Node2D = BattleTokenVisual.new()
	token.name = "BattleToken"
	add_child(token)
	var portrait_path: String = battle_portrait_path
	if portrait_path.is_empty():
		portrait_path = BattleTokenVisual.npc_portrait_path(npc_id)
	token.configure(portrait_path, "ally" if control_type == "player" else "ai_ally", npc_id)
	npc_visual_body = token

	create_health_bar()
	update_hidden_visual()


func update_hidden_visual() -> void:
	if is_instance_valid(npc_visual_body):
		var tint: Color = npc_visual_body.modulate
		tint.a = 0.45 if is_hidden else 1.0
		npc_visual_body.modulate = tint
	if is_instance_valid(npc_visual_border):
		var border_tint: Color = npc_visual_border.modulate
		border_tint.a = 0.45 if is_hidden else 1.0
		npc_visual_border.modulate = border_tint


func set_hidden_state(hidden: bool) -> void:
	is_hidden = hidden
	update_hidden_visual()


func setup_from_npc_data(
	npc_data: Dictionary
) -> void:
	battle_portrait_path = str(npc_data.get("portrait_path", ""))
	npc_id = str(
		npc_data.get(
			"id",
			""
		)
	)

	display_name = str(
		npc_data.get(
			"display_name",
			"NPC"
		)
	)

	race = str(
		npc_data.get(
			"race",
			""
		)
	)

	character_class = str(
		npc_data.get(
			"character_class",
			""
		)
	)
	daily_powers_used = npc_data.get("daily_powers_used", []).duplicate()

	hide_bonus = int(npc_data.get("skills", {}).get("hide", npc_data.get("hide_bonus", 0)))

	level = int(
		npc_data.get(
			"level",
			1
		)
	)

	# A progressão pertence à classe; o dado da ficha só permite
	# ajustar personagens especiais sem alterar a regra geral.
	if character_class == "Ladino":
		sneak_attack_dice_count = int(npc_data.get(
			"sneak_attack_dice",
			1 + floori(float(level - 1) / 2.0)
		))
	else:
		sneak_attack_dice_count = 0

	var minimum_level_xp: int = (
		PartyManager
		.get_total_xp_required_for_member_level(
			level
		)
	)

	total_xp = maxi(
		int(
			npc_data.get(
				"total_xp",
				minimum_level_xp
			)
		),
		minimum_level_xp
	)

	xp_to_next_level = int(
		npc_data.get(
			"xp_to_next_level",
			PartyManager.get_member_xp_step_for_level(
				level
			)
		)
	)

	pending_level_ups = int(
		npc_data.get(
			"pending_level_ups",
			0
		)
	)

	faction = str(
		npc_data.get(
			"faction",
			"ally"
		)
	)

	control_type = str(
		npc_data.get(
			"control_type",
			"player"
		)
	)

	max_hp = int(
		npc_data.get(
			"max_hp",
			10
		)
	)

	hp = int(
		npc_data.get(
			"hp",
			max_hp
		)
	)

	armor_class = int(
		npc_data.get(
			"armor_class",
			10
		)
	)

	touch_armor_class = int(
		npc_data.get(
			"touch_armor_class",
			armor_class
		)
	)

	flat_footed_armor_class = int(
		npc_data.get(
			"flat_footed_armor_class",
			armor_class
		)
	)

	equipped_armor = str(
		npc_data.get(
			"equipped_armor",
			"Nenhuma"
		)
	)

	equipped_shield = str(
		npc_data.get(
			"equipped_shield",
			"Nenhum"
		)
	)

	max_movement_meters = float(
		npc_data.get(
			"max_movement_meters",
			7.5
		)
	)

	current_movement_meters = (
		max_movement_meters
	)

	initiative_bonus = int(
		npc_data.get(
			"initiative_bonus",
			0
		)
	)

	base_attack_bonus = int(
		npc_data.get(
			"base_attack_bonus",
			0
		)
	)

	strength = int(
		npc_data.get(
			"strength",
			10
		)
	)

	dexterity = int(
		npc_data.get(
			"dexterity",
			10
		)
	)

	constitution = int(
		npc_data.get(
			"constitution",
			10
		)
	)

	intelligence = int(
		npc_data.get(
			"intelligence",
			10
		)
	)

	wisdom = int(
		npc_data.get(
			"wisdom",
			10
		)
	)

	charisma = int(
		npc_data.get(
			"charisma",
			10
		)
	)

	fortitude_bonus = int(
		npc_data.get(
			"fortitude_bonus",
			0
		)
	)

	reflex_bonus = int(
		npc_data.get(
			"reflex_bonus",
			0
		)
	)

	will_bonus = int(
		npc_data.get(
			"will_bonus",
			0
		)
	)

	observe_bonus = int(
		npc_data.get(
			"observe_bonus",
			0
		)
	)

	feats = npc_data.get(
		"feats",
		[]
	).duplicate()

	feat_attack_bonus = int(
		npc_data.get(
			"feat_attack_bonus",
			0
		)
	)

	feat_damage_bonus = int(
		npc_data.get(
			"feat_damage_bonus",
			0
		)
	)

	weapon_focus_name = str(
		npc_data.get(
			"weapon_focus_name",
			""
		)
	)

	weapon_focus_attack_bonus = int(
		npc_data.get(
			"weapon_focus_attack_bonus",
			0
		)
	)

	equipped_weapon = str(
		npc_data.get(
			"equipped_weapon",
			"Soco"
		)
	)

	weapon_type = str(
		npc_data.get(
			"weapon_type",
			"melee"
		)
	)

	damage_dice = int(
		npc_data.get(
			"damage_dice",
			3
		)
	)

	damage_dice_count = int(
		npc_data.get(
			"damage_dice_count",
			1
		)
	)

	damage_bonus = int(
		npc_data.get(
			"damage_bonus",
			0
		)
	)

	weapon_range_meters = float(
		npc_data.get(
			"weapon_range_meters",
			1.5
		)
	)

	ai_behavior = str(
		npc_data.get(
			"ai_behavior",
			"defensive"
		)
	)

	dialogue_intro = str(
		npc_data.get(
			"dialogue_intro",
			""
		)
	)

	dialogue_low_hp = str(
		npc_data.get(
			"dialogue_low_hp",
			""
		)
	)

	dialogue_victory = str(
		npc_data.get(
			"dialogue_victory",
			""
		)
	)

	create_visual()
	update_world_position()

	print(
		"NPC carregado: ",
		display_name,
		" | Nível: ",
		level,
		" | XP total: ",
		total_xp
	)


func apply_party_member_progression(member_data: Dictionary) -> void:
	if member_data.is_empty():
		return
	level = int(member_data.get("level", level))
	total_xp = int(member_data.get("total_xp", total_xp))
	xp_to_next_level = int(member_data.get("xp_to_next_level", xp_to_next_level))
	pending_level_ups = int(member_data.get("pending_level_ups", pending_level_ups))


func get_xp_progress_in_current_level() -> int:
	if level >= PartyManager.MAX_MEMBER_LEVEL:
		return 0
	return maxi(0, total_xp - PartyManager.get_total_xp_required_for_member_level(level))


func get_xp_needed_for_current_level() -> int:
	return PartyManager.get_member_xp_step_for_level(level)


func update_world_position():
	position = Vector2(
		grid_position.x * 64 + 32,
		grid_position.y * 64 + 32
	)


func reset_movement():
	if unstoppable_active:
		unstoppable_turn_started = true
	druid_guard_active = false
	cleric_guard_active = false
	fighter_guard_active = false
	current_movement_meters = max_movement_meters
	has_attacked = false
	has_opportunity_attacked = false
	hide_used_this_turn = false
	smite_evil_active = false


func get_max_attack_actions() -> int:
	return 1 + int(level >= 5) + int(level >= 10)


func get_remaining_attack_actions() -> int:
	return maxi(0, get_max_attack_actions() - attacks_used_this_turn)


func can_use_hide_skill() -> bool:
	return character_class == "Ladino" and not hide_used_this_turn and not has_attacked


func use_hide_skill() -> void:
	if not can_use_hide_skill():
		return
	set_hidden_state(true)
	hide_used_this_turn = true
	hide_checked_enemies.clear()


func reveal_after_attack() -> void:
	set_hidden_state(false)
	hide_checked_enemies.clear()


func get_sneak_attack_damage() -> int:
	if character_class != "Ladino":
		return 0
	var total: int = 0
	var class_dice: int = 1 + floori(float(level - 1) / 2.0)
	for index in range(maxi(sneak_attack_dice_count, class_dice)):
		total += randi_range(1, 6)
	return total


func can_use_smite_evil() -> bool:
	return character_class == "Paladino" and not smite_evil_used and not smite_evil_active


func activate_smite_evil() -> void:
	if can_use_smite_evil():
		smite_evil_active = true


func consume_smite_evil() -> void:
	if smite_evil_active:
		smite_evil_active = false
		smite_evil_used = true


func take_damage(amount: int):
	if hp <= 0:
		return
	
	hp -= amount
	if hp <= 0 and race == "Meio-Orc" and not unstoppable_used_this_battle:
		hp = 1
		unstoppable_active = true
		unstoppable_turn_started = false
		unstoppable_used_this_battle = true
	
	if hp < 0:
		hp = 0
	hp = max(hp, 0)
	update_health_bar()
	print(display_name, " recebeu ", amount, " de dano. HP: ", hp, "/", max_hp)
	
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



func die():
	if death_emitted:
		return
	
	death_emitted = true
	
	print(display_name, " foi derrotado.")
	
	set_hidden_state(false)
	has_attacked = true
	current_movement_meters = 0.0
	modulate = Color(0.55, 0.55, 0.55, 1.0)
	update_health_bar()
	set_process(false)
	
	died.emit(self)


func get_npc_display_name() -> String:
	return display_name


func get_armor_class() -> int:
	return (
		armor_class
		+ temporary_armor_class_bonus
		+ (1 if character_class == "Paladino" and feats.has("Defesa Juramentada") else 0)
		+ (1 if character_class == "Ladino" and feats.has("Guarda Esquiva") else 0)
		+ (1 + (1 if feats.has("Casca Espessa") else 0) if character_class == "Druida" and druid_guard_active else 0)
		+ (1 if character_class == "Clérigo" and cleric_guard_active else 0)
		+ (2 if character_class == "Guerreiro" and fighter_guard_active else 0)
		+ (1 if character_class == "Guerreiro" and feats.has("Armadura de Campanha") else 0)
		+ (1 if character_class == "Bruxo" and feats.has("Escudo Oculto") else 0)
		+ (1 if character_class == "Monge" and equipped_armor in ["Nenhuma", "none", ""] and feats.has("Corpo Disciplinado") else 0)
		+ (1 if character_class == "Druida" and druid_form_active else 0)
	)


func get_base_attack_bonus() -> int:
	return (
		base_attack_bonus
		+ temporary_attack_bonus
	)


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
		total_damage += randi_range(
			1,
			damage_dice
		)
	
	total_damage += damage_bonus
	total_damage += feat_damage_bonus
	total_damage += temporary_damage_bonus
	if character_class == "Druida" and weapon_type == "melee":
		total_damage += get_druid_form_damage_bonus()
	if character_class == "Bárbaro" and is_raging:
		total_damage += 2
		if feats.has("Sangue Ardente") or feats.has("Fúria Poderosa"):
			total_damage += 2
	if character_class == "Guerreiro" and weapon_type == "melee" and feats.has("Pancada de Ferro"):
		total_damage += 2
	if character_class == "Monge" and equipped_weapon in ["Soco", "unarmed"] and feats.has("Punhos Duros"):
		total_damage += 2
	if race == "Meio-Orc" and unstoppable_active:
		total_damage += 2
	
	if total_damage < 1:
		total_damage = 1
	
	return total_damage


func get_strength_modifier() -> int:
	return int(floor((float(strength) - 10.0) / 2.0))


func get_dexterity_modifier() -> int:
	return int(floor((float(dexterity) - 10.0) / 2.0))


func get_constitution_modifier() -> int:
	return int(floor((float(constitution) - 10.0) / 2.0))


func apply_status_effect(effect_name: String, end_turn: int):
	status_effects[effect_name] = end_turn
	print(display_name, " recebeu condição: ", effect_name, " até a rodada ", end_turn)


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

func apply_spell_buff(
	attack_bonus: int,
	new_damage_bonus: int,
	armor_bonus: int,
	movement_bonus: float,
	effect_end_turn: int
) -> void:
	clear_temporary_combat_bonuses()
	
	temporary_attack_bonus = attack_bonus
	temporary_damage_bonus = new_damage_bonus
	temporary_armor_class_bonus = armor_bonus
	temporary_movement_bonus = movement_bonus
	temporary_effects_end_turn = effect_end_turn
	
	max_movement_meters += temporary_movement_bonus
	current_movement_meters += temporary_movement_bonus
	
	print(
		display_name,
		" recebeu bônus mágico até a rodada ",
		temporary_effects_end_turn
	)


func clear_temporary_combat_bonuses() -> void:
	if temporary_movement_bonus != 0.0:
		max_movement_meters = max(
			0.0,
			max_movement_meters
			- temporary_movement_bonus
		)
		
		current_movement_meters = clamp(
			current_movement_meters
			- temporary_movement_bonus,
			0.0,
			max_movement_meters
		)
	
	temporary_attack_bonus = 0
	temporary_damage_bonus = 0
	temporary_armor_class_bonus = 0
	temporary_movement_bonus = 0.0
	temporary_effects_end_turn = 0

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
			display_name,
			" perdeu condição: ",
			effect_name
		)
	
	if (
		temporary_effects_end_turn > 0
		and current_battle_turn
		>= temporary_effects_end_turn
	):
		clear_temporary_combat_bonuses()
		
		print(
			display_name,
			" perdeu os bônus mágicos temporários."
		)
		
func get_touch_armor_class() -> int:
	return touch_armor_class


func get_flat_footed_armor_class() -> int:
	return flat_footed_armor_class


func get_fortitude_save_bonus() -> int:
	return fortitude_bonus + (1 if race == "Gnomo" or (race == "Meio-Orc" and unstoppable_active) else 0) + (1 if character_class == "Guerreiro" and feats.has("Reflexo de Guarda") else 0)


func get_reflex_save_bonus() -> int:
	return reflex_bonus + (1 if race == "Gnomo" or (race == "Meio-Orc" and unstoppable_active) else 0) + (1 if character_class == "Guerreiro" and feats.has("Reflexo de Guarda") else 0)


func get_will_save_bonus() -> int:
	return will_bonus + (1 if race == "Gnomo" or (race == "Meio-Orc" and unstoppable_active) else 0) + (1 if character_class == "Bruxo" and feats.has("Vontade do Pacto") else 0) + (1 if character_class == "Monge" and feats.has("Mente Serena") else 0)


func get_weapon_focus_attack_bonus() -> int:
	if equipped_weapon == weapon_focus_name:
		return weapon_focus_attack_bonus
	
	return 0


func get_total_attack_bonus() -> int:
	var total: int = get_base_attack_bonus()
	
	if weapon_type == "ranged":
		total += get_dexterity_modifier()
		if race == "Elfo":
			total += 1
	else:
		total += get_strength_modifier()
	
	total += feat_attack_bonus
	total += get_weapon_focus_attack_bonus()
	if character_class == "Paladino" and weapon_type == "melee" and feats.has("Lâmina da Ordem"):
		total += 1
	if character_class == "Guerreiro":
		if weapon_type == "melee" and feats.has("Lâmina Disciplinada"):
			total += 1
		if weapon_type == "ranged" and feats.has("Tiro Disciplinado"):
			total += 1
	if character_class == "Bardo" and feats.has("Dueto Preciso"):
		total += 1
	if character_class == "Monge" and weapon_type == "melee" and feats.has("Punho Centrado"):
		total += 1
	if character_class == "Bárbaro" and is_raging:
		total += 1
	
	return total


func can_use_rage() -> bool:
	var extra_uses: int = 1 if feats.has("Fôlego da Fúria") or feats.has("Fúria Extra") else 0
	return character_class == "Bárbaro" and not is_raging and rage_uses_this_battle < 1 + extra_uses


func activate_druid_form(current_battle_turn: int) -> void:
	if character_class != "Druida" or druid_form_active:
		return
	druid_form_active = true
	druid_form_end_turn = current_battle_turn + 3


func update_druid_form_turn(current_battle_turn: int) -> void:
	if druid_form_active and current_battle_turn >= druid_form_end_turn:
		end_druid_form()


func end_druid_form() -> void:
	druid_form_active = false
	druid_form_end_turn = 0


func get_druid_form_damage_bonus() -> int:
	if character_class != "Druida" or not druid_form_active:
		return 0
	return 2 + (1 if feats.has("Garras da Mata") else 0)


func activate_rage(current_battle_turn: int) -> void:
	if not can_use_rage():
		return
	is_raging = true
	rage_uses_this_battle += 1
	rage_end_turn = current_battle_turn + maxi(1, 3 + get_constitution_modifier())
	armor_class -= 2
	var extra_hp: int = 2 * level
	max_hp += extra_hp
	hp += extra_hp


func update_rage_turn(current_battle_turn: int) -> void:
	if is_raging and current_battle_turn >= rage_end_turn:
		end_rage()


func end_rage() -> void:
	if not is_raging:
		return
	is_raging = false
	rage_end_turn = 0
	armor_class += 2
	max_hp = maxi(1, max_hp - 2 * level)
	hp = clampi(hp, 0, max_hp)

func create_health_bar():
	# =====================================================
	# NOME DO NPC
	# =====================================================
	health_name_label = Label.new()
	health_name_label.name = "HealthNameLabel"
	health_name_label.position = Vector2(-60, -56)
	health_name_label.size = Vector2(120, 20)
	health_name_label.text = display_name
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
	health_bar_background.size = Vector2(50, 8)
	health_bar_background.position = Vector2(-25, -36)
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
	health_bar_fill.size = Vector2(46, 4)
	health_bar_fill.color = Color(0.15, 0.85, 0.2, 1.0)
	health_bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	health_bar_fill.z_index = 21
	
	health_bar_background.add_child(health_bar_fill)
	
	# =====================================================
	# ATUALIZA
	# =====================================================
	update_health_bar()


func update_health_bar():
	# =====================================================
	# NOME
	# =====================================================
	if is_instance_valid(health_name_label):
		health_name_label.text = display_name + (" (0 PV)" if hp <= 0 else "")
	
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
	
	health_bar_fill.size.x = 46.0 * hp_ratio
