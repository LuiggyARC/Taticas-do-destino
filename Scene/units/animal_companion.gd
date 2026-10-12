extends Node2D


signal health_changed(
	current_hp: int,
	maximum_hp: int
)

signal companion_defeated


const TILE_SIZE := 64


var grid_position: Vector2i = Vector2i(
	6,
	7
)

var companion_name: String = "Lobo"
var companion_type: String = "Lobo"

var max_hp: int = 18
var hp: int = 18

var strength: int = 14
var dexterity: int = 15
var constitution: int = 15
var wisdom: int = 12
var intelligence: int = 3
var charisma: int = 6

var base_attack_bonus: int = 1

var fortitude_bonus: int = 3
var reflex_bonus: int = 3
var will_bonus: int = 1

var damage_dice_count: int = 1
var damage_dice: int = 6
var damage_bonus: int = 0

# Mantida para compatibilidade com o main.gd.
var attack_power: int = 6

var armor_class: int = 13

var status_effects: Dictionary = {}

var max_movement_meters: float = 12.0
var current_movement_meters: float = 12.0

var has_attacked: bool = false
var has_opportunity_attacked: bool = false

var owner_class: String = ""
var owner_level: int = 1
var temporary_attack_bonus: int = 0
var temporary_damage_bonus: int = 0
var temporary_armor_class_bonus: int = 0
var temporary_movement_bonus: float = 0.0
var temporary_effects_end_turn: int = 0

func _ready() -> void:
	add_to_group(
		"player_allies"
	)
	
	z_index = 20
	visible = true
	
	update_world_position()
	update_health_display()


func setup_companion(
	new_type: String,
	new_owner_class: String,
	new_owner_level: int
) -> void:
	companion_type = new_type
	companion_name = new_type
	owner_class = new_owner_class
	owner_level = max(
		1,
		new_owner_level
	)
	
	apply_companion_type_data()
	apply_level_bonus()
	
	hp = max_hp
	current_movement_meters = (
		max_movement_meters
	)
	
	update_world_position()
	update_health_display()


func apply_companion_type_data() -> void:
	match companion_type:
		"Lobo":
			max_hp = 18
			
			strength = 14
			dexterity = 15
			constitution = 15
			wisdom = 12
			intelligence = 3
			charisma = 6
			
			base_attack_bonus = 1
			
			fortitude_bonus = 3
			reflex_bonus = 3
			will_bonus = 1
			
			damage_dice_count = 1
			damage_dice = 6
			damage_bonus = 0
			
			attack_power = 6
			armor_class = 13
			max_movement_meters = 12.0
		
		"Urso":
			max_hp = 26
			
			strength = 18
			dexterity = 12
			constitution = 17
			wisdom = 12
			intelligence = 2
			charisma = 6
			
			base_attack_bonus = 1
			
			fortitude_bonus = 4
			reflex_bonus = 1
			will_bonus = 1
			
			damage_dice_count = 1
			damage_dice = 8
			damage_bonus = 0
			
			attack_power = 8
			armor_class = 12
			max_movement_meters = 9.0
		
		"Pantera":
			max_hp = 16
			
			strength = 14
			dexterity = 17
			constitution = 13
			wisdom = 12
			intelligence = 3
			charisma = 7
			
			base_attack_bonus = 1
			
			fortitude_bonus = 2
			reflex_bonus = 4
			will_bonus = 1
			
			damage_dice_count = 1
			damage_dice = 6
			damage_bonus = 0
			
			attack_power = 7
			armor_class = 14
			max_movement_meters = 13.5
		
		"Águia":
			max_hp = 12
			
			strength = 10
			dexterity = 17
			constitution = 12
			wisdom = 14
			intelligence = 3
			charisma = 7
			
			base_attack_bonus = 1
			
			fortitude_bonus = 1
			reflex_bonus = 4
			will_bonus = 2
			
			damage_dice_count = 1
			damage_dice = 4
			damage_bonus = 0
			
			attack_power = 5
			armor_class = 15
			max_movement_meters = 15.0
		
		_:
			companion_type = "Lobo"
			companion_name = "Lobo"
			apply_companion_type_data()


func apply_level_bonus() -> void:
	var bonus_levels: int = max(
		0,
		owner_level - 1
	)
	
	max_hp += bonus_levels * 4
	
	base_attack_bonus += int(
		floor(
			float(bonus_levels) * 0.75
		)
	)
	
	armor_class += int(
		floor(
			float(bonus_levels) / 3.0
		)
	)
	
	fortitude_bonus += int(
		floor(
			float(bonus_levels) / 2.0
		)
	)
	
	reflex_bonus += int(
		floor(
			float(bonus_levels) / 2.0
		)
	)
	
	will_bonus += int(
		floor(
			float(bonus_levels) / 3.0
		)
	)
	
	damage_bonus += int(
		floor(
			float(bonus_levels) / 2.0
		)
	)
	
	attack_power = (
		damage_dice
		+ damage_bonus
	)


func update_world_position() -> void:
	position = Vector2(
		grid_position.x * TILE_SIZE
			+ TILE_SIZE / 2.0,
		grid_position.y * TILE_SIZE
			+ TILE_SIZE / 2.0
	)


func reset_movement() -> void:
	current_movement_meters = (
		max_movement_meters
	)
	
	has_attacked = false
	has_opportunity_attacked = false


func take_damage(
	amount: int
) -> void:
	var safe_damage: int = max(
		0,
		amount
	)
	
	hp = max(
		0,
		hp - safe_damage
	)
	
	print(
		companion_name,
		" recebeu ",
		safe_damage,
		" de dano. Vida atual: ",
		hp,
		"/",
		max_hp
	)
	
	update_health_display()
	
	if hp <= 0:
		die()


func heal(
	amount: int
) -> int:
	if amount <= 0:
		return 0
	
	if hp <= 0:
		return 0
	
	var previous_hp: int = hp
	
	hp = min(
		max_hp,
		hp + amount
	)
	
	var restored_hp: int = (
		hp - previous_hp
	)
	
	update_health_display()
	
	return restored_hp


func update_health_display() -> void:
	health_changed.emit(
		hp,
		max_hp
	)


func die() -> void:
	if not visible:
		return
	
	visible = false
	
	print(
		companion_name,
		" foi derrotado."
	)
	
	companion_defeated.emit()
	
	# O main pode ter colocado o nó na fila de exclusão
	# ao receber companion_defeated.
	if not is_queued_for_deletion():
		queue_free()


func is_alive() -> bool:
	return (
		hp > 0
		and visible
	)


func get_armor_class() -> int:
	return max(
		1,
		armor_class
		+ temporary_armor_class_bonus
	)


func get_base_attack_bonus() -> int:
	return (
		base_attack_bonus
		+ temporary_attack_bonus
	)


func get_strength_modifier() -> int:
	return get_attribute_modifier(
		strength
	)


func get_dexterity_modifier() -> int:
	return get_attribute_modifier(
		dexterity
	)


func get_constitution_modifier() -> int:
	return get_attribute_modifier(
		constitution
	)


func get_wisdom_modifier() -> int:
	return get_attribute_modifier(
		wisdom
	)


func get_fortitude_save_bonus() -> int:
	return fortitude_bonus


func get_reflex_save_bonus() -> int:
	return reflex_bonus


func get_will_save_bonus() -> int:
	return will_bonus


func get_attribute_modifier(
	attribute_value: int
) -> int:
	return int(
		floor(
			(
				float(attribute_value)
				- 10.0
			) / 2.0
		)
	)


func get_weapon_range_meters() -> float:
	return 1.5


func get_attack_bonus() -> int:
	return (
		get_base_attack_bonus()
		+ get_strength_modifier()
	)


func get_damage_bonus() -> int:
	return (
		get_strength_modifier()
		+ damage_bonus
		+ temporary_damage_bonus
	)


func roll_attack_damage() -> int:
	var rolled_damage: int = 0
	
	for i in range(
		damage_dice_count
	):
		rolled_damage += randi_range(
			1,
			max(
				1,
				damage_dice
			)
		)
	
	rolled_damage += get_damage_bonus()
	
	return max(
		1,
		rolled_damage
	)


func get_companion_display_name() -> String:
	return companion_name


func apply_status_effect(
	effect_name: String,
	end_turn: int
) -> void:
	status_effects[effect_name] = end_turn
	
	print(
		companion_name,
		" recebeu condição: ",
		effect_name,
		" até a rodada ",
		end_turn
	)


func remove_status_effect(
	effect_name: String
) -> void:
	if status_effects.has(
		effect_name
	):
		status_effects.erase(
			effect_name
		)


func has_status_effect(
	effect_name: String,
	current_battle_turn: int
) -> bool:
	if not status_effects.has(
		effect_name
	):
		return false
	
	var end_turn: int = int(
		status_effects[effect_name]
	)
	
	if current_battle_turn >= end_turn:
		status_effects.erase(
			effect_name
		)
		return false
	
	return true


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
				str(effect_name)
			)
	
	for effect_name in effects_to_remove:
		status_effects.erase(
			effect_name
		)
		
		print(
			companion_name,
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
			companion_name,
			" perdeu os bônus mágicos."
		)

func apply_spell_buff(
	attack_bonus: int,
	new_damage_bonus: int,
	armor_bonus: int,
	movement_bonus: float,
	effect_end_turn: int
) -> void:
	clear_temporary_combat_bonuses()
	
	temporary_attack_bonus = (
		attack_bonus
	)
	temporary_damage_bonus = (
		new_damage_bonus
	)
	temporary_armor_class_bonus = (
		armor_bonus
	)
	temporary_movement_bonus = (
		movement_bonus
	)
	temporary_effects_end_turn = (
		effect_end_turn
	)
	
	if temporary_movement_bonus != 0.0:
		max_movement_meters += (
			temporary_movement_bonus
		)
		
		current_movement_meters += (
			temporary_movement_bonus
		)
		
		current_movement_meters = clamp(
			current_movement_meters,
			0.0,
			max_movement_meters
		)


func clear_temporary_combat_bonuses() -> void:
	if temporary_movement_bonus != 0.0:
		max_movement_meters -= (
			temporary_movement_bonus
		)
		
		max_movement_meters = max(
			1.5,
			max_movement_meters
		)
		
		current_movement_meters = min(
			current_movement_meters,
			max_movement_meters
		)
	
	temporary_attack_bonus = 0
	temporary_damage_bonus = 0
	temporary_armor_class_bonus = 0
	temporary_movement_bonus = 0.0
	temporary_effects_end_turn = 0
