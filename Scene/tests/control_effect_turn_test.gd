extends Node

const EnemyScript = preload("res://Scene/units/enemy.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const MainScript = preload("res://Scene/main.gd")

func _ready() -> void:
	var combat: Node2D = MainScript.new()
	var caster: Node2D = HeroScript.new()
	caster.character_class = "Mago"
	caster.intelligence = 18
	caster.feat_spell_save_dc_bonus = 1
	combat.hero = caster
	assert(combat.get_spell_save_dc({"level": 1, "save_dc": 30}) == 15)

	var victim: Node2D = EnemyScript.new()
	victim.display_name = "Cultista"
	combat.enemy = victim
	combat.enemies.append(victim)
	victim.apply_control_effect(3, 0, 3.0, 2, "Sono", "will", 15)
	assert(victim.has_active_control_effect(1))
	assert(combat.has_combat_advantage_condition(victim))
	assert(combat.get_combat_advantage_attack_bonus(caster, victim) == 2)
	victim.update_status_effects(10)
	assert(victim.has_active_control_effect(10))
	var failed_save: Dictionary = victim.resolve_control_end_of_turn(0, 2)
	assert(not failed_save["resisted"])
	assert(victim.has_active_control_effect(11))
	assert(combat.has_combat_advantage_condition(victim))
	var successful_save: Dictionary = victim.resolve_control_end_of_turn(0, 20)
	assert(successful_save["resisted"])
	assert(not victim.has_active_control_effect(12))
	assert(not combat.has_combat_advantage_condition(victim))
	combat.free()
	caster.free()
	victim.free()
	print("Control effect turn tests passed")
	get_tree().quit(0)
