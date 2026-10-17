extends Node

const DialogueDatabase = preload("res://Scene/village_dialogue_database.gd")
const FlankingRules = preload("res://Scene/flanking_rules.gd")
const MainScript = preload("res://Scene/main.gd")


class MockUnit extends Node2D:
	var grid_position: Vector2i
	var hp: int = 10
	var faction: String = "ally"
	var weapon_type: String = "melee"

	func get_weapon_type() -> String:
		return weapon_type


func _ready() -> void:
	var request: Array[Dictionary] = DialogueDatabase.get_location_event_sequence("starting_village", "carpenter_basement_request")
	var accept: Array[Dictionary] = DialogueDatabase.get_location_event_sequence("starting_village", "carpenter_basement_accept")
	var caution: Array[Dictionary] = DialogueDatabase.get_location_event_sequence("starting_village", "carpenter_basement_question")
	var warning: Array[Dictionary] = DialogueDatabase.get_location_event_sequence("starting_village", "carpenter_basement_warning")
	assert(_contains_text(request, "Minhas ferramentas desapareceram."))
	assert(_contains_text(accept, "Vamos ajudar."))
	assert(_contains_text(caution, "Primeiro quero saber com o que estamos lidando."))
	assert(warning[-1]["speaker"] == "Novo objetivo")
	assert(_contains_text(warning, "O Porão de Jhon: elimine os ratos e encontre as ferramentas desaparecidas."))

	assert(FlankingRules.are_opposite_adjacent(Vector2i(4, 5), Vector2i(6, 5), Vector2i(5, 5)))
	assert(FlankingRules.are_opposite_adjacent(Vector2i(4, 4), Vector2i(6, 6), Vector2i(5, 5)))
	assert(not FlankingRules.are_opposite_adjacent(Vector2i(4, 5), Vector2i(5, 4), Vector2i(5, 5)))
	assert(not FlankingRules.are_opposite_adjacent(Vector2i(3, 5), Vector2i(6, 5), Vector2i(5, 5)))

	var battle: Node2D = MainScript.new()
	var hero_unit := MockUnit.new()
	var ally_unit := MockUnit.new()
	var ranged_ally := MockUnit.new()
	var rat_unit := MockUnit.new()
	hero_unit.grid_position = Vector2i(4, 5)
	ally_unit.grid_position = Vector2i(6, 5)
	ranged_ally.grid_position = Vector2i(2, 5)
	ranged_ally.weapon_type = "ranged"
	rat_unit.grid_position = Vector2i(5, 5)
	battle.hero = hero_unit
	battle.npcs.append(ally_unit)
	battle.npcs.append(ranged_ally)
	battle.enemies.append(rat_unit)
	assert(battle.has_combat_advantage_condition(rat_unit))
	assert(battle.get_combat_advantage_attack_bonus(hero_unit, rat_unit) == 2)
	assert(battle.get_combat_advantage_attack_bonus(ranged_ally, rat_unit) == 2)
	assert(battle.is_target_flanked_by_ally(rat_unit, ranged_ally))
	assert(battle.get_combat_advantage_attack_bonus(rat_unit, hero_unit) == 0)
	ally_unit.grid_position = Vector2i(5, 4)
	assert(not battle.has_combat_advantage_condition(rat_unit))
	assert(battle.get_combat_advantage_attack_bonus(ranged_ally, rat_unit) == 0)
	ally_unit.grid_position = Vector2i(6, 5)
	hero_unit.weapon_type = "ranged"
	assert(battle.get_combat_advantage_attack_bonus(hero_unit, rat_unit) == 2)
	hero_unit.weapon_type = "melee"
	ally_unit.hp = 0
	assert(not battle.has_combat_advantage_condition(rat_unit))
	assert(battle.get_combat_advantage_attack_bonus(ranged_ally, rat_unit) == 0)
	var opposite_enemy := MockUnit.new()
	var ranged_enemy := MockUnit.new()
	opposite_enemy.faction = "enemy"
	ranged_enemy.faction = "enemy"
	opposite_enemy.grid_position = Vector2i(3, 5)
	ranged_enemy.grid_position = Vector2i(7, 5)
	battle.enemies.append(opposite_enemy)
	battle.enemies.append(ranged_enemy)
	assert(battle.has_combat_advantage_condition(hero_unit))
	assert(battle.get_combat_advantage_attack_bonus(ranged_enemy, hero_unit) == 2)
	assert(battle.get_combat_advantage_attack_bonus(ranged_ally, hero_unit) == 0)
	opposite_enemy.hp = 0
	assert(not battle.has_combat_advantage_condition(hero_unit))
	battle.free()
	hero_unit.free()
	ally_unit.free()
	ranged_ally.free()
	rat_unit.free()
	opposite_enemy.free()
	ranged_enemy.free()
	print("Carpenter dialogue and flanking tests passed")
	get_tree().quit(0)


func _contains_text(sequence: Array[Dictionary], text: String) -> bool:
	for step in sequence:
		if str(step.get("text", "")) == text:
			return true
	return false
