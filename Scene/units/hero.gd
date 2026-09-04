extends Node2D

const TILE_SIZE := 64
var is_raging: bool = false
var rage_used: bool = false
var rage_turns_remaining: int = 0

var rage_strength_bonus: int = 4
var rage_constitution_bonus: int = 4
var rage_will_bonus: int = 2
var rage_ac_penalty: int = 2
var sneak_attack_dice_count: int = 1
var smite_evil_used: bool = false
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

var max_hp: int = 100
var hp: int = 100
var attack_power: int = 20

var max_movement_meters: float = 9.0
var current_movement_meters: float = 9.0

var has_attacked: bool = false
var has_opportunity_attacked: bool = false

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

var fortitude_base_bonus: int = 0
var reflex_base_bonus: int = 0
var will_base_bonus: int = 0
var equipped_weapon: String = "Soco"
var weapon_needs_reload: bool = false
var damage: int = 0
var weapons := {
	"Soco": {
		"type": "melee",
		"category": "desarmado",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	},
	"Adaga": {
		"type": "melee",
		"category": "adaga",
		"damage_dice": 4,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	},
	"Espada Curta": {
		"type": "melee",
		"category": "espada",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	},
	"Espada Longa": {
		"type": "melee",
		"category": "espada",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	},
	"Espada Bastarda": {
		"type": "melee",
		"category": "espada",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": false
	},
	"Cimitarra": {
		"type": "melee",
		"category": "espada",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 18,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	},
	"Martelo de Combate": {
		"type": "melee",
		"category": "martelo",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	},
	"Martelo de Guerra": {
		"type": "melee",
		"category": "martelo",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 1.5,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": false
	},
	"Lança Longa": {
		"type": "melee",
		"category": "lanca",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 3.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": false
	},
	"Arco Curto": {
		"type": "ranged",
		"category": "arco",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 12.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": false
	},
	"Arco Longo": {
		"type": "ranged",
		"category": "arco",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 18.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": false
	},
	"Arco Composto": {
		"type": "ranged",
		"category": "arco",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 24.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": false
	},
	"Besta Pequena": {
		"type": "ranged",
		"category": "besta",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"range_meters": 9.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": true
	},
	"Besta Grande": {
		"type": "ranged",
		"category": "besta",
		"damage_dice": 10,
		"damage_dice_count": 1,
		"range_meters": 12.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": true,
		"needs_reload": true
	},
	"Funda": {
		"type": "ranged",
		"category": "funda",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"range_meters": 12.0,
		"critical_min": 20,
		"critical_multiplier": 2,
		"two_handed": false,
		"needs_reload": false
	}
}
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


func update_world_position():
	position = Vector2(
		grid_position.x * TILE_SIZE + TILE_SIZE * 0.5,
		grid_position.y * TILE_SIZE + TILE_SIZE * 0.5
	)


func reset_movement():
	current_movement_meters = max_movement_meters
	has_attacked = false
	has_opportunity_attacked = false


func take_damage(amount: int):
	var final_damage: int = amount
	
	if damage_reduction > 0:
		final_damage -= damage_reduction
		
		if final_damage < 0:
			final_damage = 0
		
		print("Redução de Dano aplicada. Dano original: ", amount, " | RD: ", damage_reduction, " | Dano final: ", final_damage)
	
	hp -= final_damage
	
	print("Herói recebeu ", final_damage, " de dano. Vida atual: ", hp)
	
	if hp <= 0:
		die()

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


func gain_xp(amount: int):
	if level >= max_level:
		print(character_name, " já está no nível máximo.")
		return
	
	total_xp += amount
	print(character_name, " recebeu ", amount, " XP. XP total: ", total_xp)
	
	update_level_from_total_xp()


func update_level_from_total_xp():
	var new_level := calculate_level_from_xp(total_xp)
	
	while level < new_level:
		level_up()
	
	if level >= max_level:
		xp_to_next_level = 0
	else:
		xp_to_next_level = get_total_xp_required_for_level(level + 1)


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


func level_up():
	if level >= max_level:
		level = max_level
		return
	
	level += 1
	
	var hp_gain := 10
	var attack_gain := 2
	
	max_hp += hp_gain
	hp = max_hp
	
	attack_power += attack_gain
	
	if level % 3 == 0:
		max_movement_meters += 1.5
	
	current_movement_meters = max_movement_meters
	
	print(character_name, " subiu para o nível ", level)
	print("HP máximo: ", max_hp)
	print("Ataque: ", attack_power)
	print("Movimento: ", max_movement_meters)
	
	update_class_scaling()

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
	return (
		base_armor_class +
		armor_bonus +
		shield_bonus +
		get_dexterity_modifier() +
		get_monk_wisdom_ac_bonus() +
		size_modifier +
		dodge_bonus +
		deflection_bonus +
		natural_armor_bonus +
		other_ac_bonus
	)


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
	return fortitude_base_bonus + get_constitution_modifier() + get_divine_grace_bonus()


func get_reflex_save() -> int:
	return reflex_base_bonus + get_dexterity_modifier() + get_divine_grace_bonus()


func get_will_save() -> int:
	return will_base_bonus + get_wisdom_modifier() + get_divine_grace_bonus()

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
	return get_base_attack_bonus() + get_dexterity_modifier() + size_modifier


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
	if not weapons.has(equipped_weapon):
		return weapons["Soco"]
	
	return weapons[equipped_weapon]


func equip_weapon(weapon_name: String):
	if not weapons.has(weapon_name):
		print("Arma não encontrada: ", weapon_name)
		return
	
	equipped_weapon = weapon_name
	weapon_needs_reload = false
	print("Arma equipada: ", equipped_weapon)


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


func weapon_requires_reload() -> bool:
	var weapon = get_equipped_weapon_data()
	return bool(weapon.get("needs_reload", false))


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
	damage = roll_weapon_damage() + get_weapon_damage_bonus()
	
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
	return character_class == "Bárbaro" and not rage_used


func activate_rage():
	if not can_use_rage():
		print("Fúria indisponível.")
		return
	
	is_raging = true
	rage_used = true
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
	return character_class == "Paladino" and not smite_evil_used


func get_smite_evil_attack_bonus() -> int:
	if character_class != "Paladino":
		return 0
	
	return get_charisma_modifier()


func get_smite_evil_damage_bonus() -> int:
	if character_class != "Paladino":
		return 0
	
	return level


func use_smite_evil():
	if not can_use_smite_evil():
		print("Destruir o Mal indisponível.")
		return
	
	smite_evil_used = true
	print(character_name, " usou Destruir o Mal!")


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
	
	var wisdom_modifier := get_wisdom_modifier()
	
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
func update_rage_turn():
	if not is_raging:
		return
	
	rage_turns_remaining -= 1
	
	print("Fúria restante: ", rage_turns_remaining, " turnos.")
	
	if rage_turns_remaining <= 0:
		end_rage()


func end_rage():
	if not is_raging:
		return
	
	is_raging = false
	
	strength -= rage_strength_bonus
	constitution -= rage_constitution_bonus
	will_base_bonus -= rage_will_bonus
	armor_bonus += rage_ac_penalty
	
	var extra_hp: int = 2 * level
	max_hp -= extra_hp
	
	if hp > max_hp:
		hp = max_hp
	
	print(character_name, " saiu da Fúria.")
	print("HP após fim da Fúria: ", hp, "/", max_hp)
	
	if hp <= 0:
		print(character_name, " caiu após o fim da Fúria.")
		die()
