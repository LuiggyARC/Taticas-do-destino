extends Node2D

const TILE_SIZE := 64

var grid_position: Vector2i = Vector2i(10, 7)

var max_hp: int = 50
var hp: int = 50
var attack_power: int = 10
var has_opportunity_attacked: bool = false

var max_movement_meters: float = 6.0
var current_movement_meters: float = 6.0

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
