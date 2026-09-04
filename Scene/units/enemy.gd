extends Node2D

const TILE_SIZE := 64

var grid_position: Vector2i = Vector2i(10, 7)

var max_hp: int = 50
var hp: int = 50
var attack_power: int = 10
var has_opportunity_attacked: bool = false

var max_movement_meters: float = 6.0
var current_movement_meters: float = 6.0
var strength: int = 10
var dexterity: int = 10
var constitution: int = 10
var wisdom: int = 10
var intelligence: int = 10
var charisma: int = 10

var base_armor_class: int = 10

var armor_bonus: int = 0
var shield_bonus: int = 0
var size_modifier: int = 0
var dodge_bonus: int = 0
var deflection_bonus: int = 0
var natural_armor_bonus: int = 0
var other_ac_bonus: int = 0

var base_attack_bonus: int = 1
var damage: int = 0

var equipped_weapon: String = "Adaga"
var weapon_needs_reload: bool = false

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
	body.color = Color(1.0, 0.1, 0.1)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(body)

func update_world_position():
	position = Vector2(
		grid_position.x * TILE_SIZE + TILE_SIZE * 0.5,
		grid_position.y * TILE_SIZE + TILE_SIZE * 0.5
	)

func reset_movement():
	current_movement_meters = max_movement_meters
	has_opportunity_attacked = false
	
func take_damage(amount: int):
	hp -= amount
	print("Inimigo recebeu ", amount, " de dano. Vida atual: ", hp)
	
	if hp <= 0:
		die()

func die():
	print("Inimigo derrotado.")
	queue_free()
func get_attribute_modifier(attribute_value: int) -> int:
	return int(floor((attribute_value - 10) / 2.0))


func get_strength_modifier() -> int:
	return get_attribute_modifier(strength)


func get_dexterity_modifier() -> int:
	return get_attribute_modifier(dexterity)


func get_constitution_modifier() -> int:
	return get_attribute_modifier(constitution)


func get_wisdom_modifier() -> int:
	return get_attribute_modifier(wisdom)


func get_armor_class() -> int:
	return (
		base_armor_class +
		armor_bonus +
		shield_bonus +
		get_dexterity_modifier() +
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


func get_melee_attack_bonus() -> int:
	return base_attack_bonus + get_strength_modifier() + size_modifier


func get_melee_damage() -> int:
	var final_damage := attack_power + get_strength_modifier()
	
	if final_damage < 1:
		final_damage = 1
	
	return final_damage
func get_equipped_weapon_data() -> Dictionary:
	if not weapons.has(equipped_weapon):
		return weapons["Soco"]
	
	return weapons[equipped_weapon]


func equip_weapon(weapon_name: String):
	if not weapons.has(weapon_name):
		print("Arma de inimigo não encontrada: ", weapon_name)
		return
	
	equipped_weapon = weapon_name
	weapon_needs_reload = false
	print("Inimigo equipou: ", equipped_weapon)


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


func get_ranged_attack_bonus() -> int:
	return base_attack_bonus + get_dexterity_modifier() + size_modifier


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
