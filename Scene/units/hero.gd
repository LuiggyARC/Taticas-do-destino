extends Node2D

const TILE_SIZE := 64

var grid_position: Vector2i = Vector2i(7, 7)

var character_name: String = "Herói"
var character_class: String = "Guerreiro"

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
	hp -= amount
	print("Herói recebeu ", amount, " de dano. Vida atual: ", hp)
	
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
