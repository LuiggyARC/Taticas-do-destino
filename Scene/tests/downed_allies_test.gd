extends Node

const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const EnemyScript = preload("res://Scene/units/enemy.gd")
const CompanionScript = preload("res://Scene/units/animal_companion.gd")
const MainScript = preload("res://Scene/main.gd")

func _ready() -> void:
	var combat: Node2D = MainScript.new()
	var hero: Node2D = HeroScript.new()
	var ally: Node2D = NpcScript.new()
	var opponent: Node2D = EnemyScript.new()
	var companion: Node2D = CompanionScript.new()
	add_child(hero)
	add_child(ally)
	add_child(opponent)
	add_child(companion)
	hero.grid_position = Vector2i(2, 2)
	ally.grid_position = Vector2i(3, 2)
	ally.npc_id = "Aniri"
	ally.display_name = "Aniri"
	ally.control_type = "player"
	opponent.grid_position = Vector2i(4, 2)
	companion.grid_position = Vector2i(5, 2)
	combat.hero = hero
	combat.npcs.append(ally)
	combat.enemy = opponent
	combat.enemies.append(opponent)

	ally.take_damage(999)
	assert(ally.hp == 0 and ally.visible and not ally.is_queued_for_deletion())
	assert("0 PV" in ally.health_name_label.text)
	assert(combat.get_unit_at_grid_position(ally.grid_position) == null)
	assert(combat.get_enemy_target_unit() == hero)
	assert(combat.apply_damage_to_unit(ally, 10) == 0)
	await combat.check_battle_result()
	assert(not combat.battle_finished)
	assert(combat.get_defeated_critical_npc() == null)
	combat.current_scenario_data = {"defeat_conditions": [{"type": "npc_defeated", "npc_id": "Aniri"}]}
	assert(combat.get_defeated_critical_npc() == ally)

	combat.animal_companion = companion
	companion.take_damage(999)
	assert(companion.hp == 0 and companion.visible and not companion.is_queued_for_deletion())
	assert("0 PV" in companion.health_name_label.text)
	assert(combat.get_unit_at_grid_position(companion.grid_position) == null)
	combat.free()
	hero.free()
	ally.free()
	opponent.free()
	companion.free()
	print("Downed allies tests passed")
	get_tree().quit(0)
