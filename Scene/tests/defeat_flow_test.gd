extends Node

const HeroScript = preload("res://Scene/units/hero.gd")
const MainScript = preload("res://Scene/main.gd")

func _ready() -> void:
	var hero: Node2D = HeroScript.new()
	add_child(hero)
	hero.hp = 3
	hero.take_damage(10)
	assert(hero.hp == 0)
	assert(not hero.is_queued_for_deletion())
	assert(hero.visible)
	assert(hero.current_movement_meters == 0.0)
	await get_tree().process_frame
	assert(is_instance_valid(hero))

	var combat: Node2D = MainScript.new()
	combat.hero = hero
	await combat.check_battle_result()
	assert(combat.battle_finished)
	assert(is_instance_valid(hero))
	combat.free()
	hero.free()
	print("Defeat flow tests passed")
	get_tree().quit(0)
