extends Node

const BattleScene = preload("res://Scene/main.tscn")
const TempleDuelData = preload("res://Scene/temple_duel_data.gd")
const ClassPowerProgressionData = preload("res://Scene/class_power_progression.gd")


func _ready() -> void:
	var test_save: String = "user://temple_battle_runtime_%d.json" % Time.get_ticks_usec()
	var file := FileAccess.open(test_save, FileAccess.WRITE)
	assert(file != null)
	file.store_string(JSON.stringify({
		"current_stage": 4,
		"current_location": "battle",
		"player_presets": {"player_name": "Teste", "player_class": "Guerreiro", "player_race": "Humano"},
		"party": {}, "inventory": {}, "missions": {}
	}))
	file.close()
	GameState.selected_save_path = test_save
	GameState.current_location = "battle"
	GameState.should_load_save = true
	var battle: Node2D = BattleScene.instantiate()
	add_child(battle)
	for frame in range(20):
		await get_tree().process_frame
	assert(battle.current_stage == 4)
	assert(battle.enemies.size() == 10)
	for cultist in battle.enemies.filter(func(unit): return unit.monster_id == "Cultista"):
		assert(cultist.get_node_or_null("BattleToken/BattlePortrait") != null)
	assert(battle.npcs.size() == 4)
	assert(is_instance_valid(battle.temple_fire_wall))
	var hashagur: Node2D = battle.find_scenario_npc_by_id("Hashagur")
	assert(is_instance_valid(hashagur))
	assert(hashagur.level == 10)
	assert(hashagur.max_hp == 150 and hashagur.hp == 150)
	assert(hashagur.get_max_attack_actions() == 3)
	hashagur.encounter_powers_used.append("monk_flurry")
	battle.current_active_unit = hashagur
	assert(battle.can_select_monk_power(hashagur, "monk_flurry"))
	hashagur.encounter_powers_used.erase("monk_flurry")
	battle.current_active_unit = battle.hero
	assert(hashagur.get_node_or_null("BattleToken/BattlePortrait") != null)
	assert(battle.hero.get_node_or_null("BattleToken") != null)
	var guardians: Array = battle.enemies.filter(func(unit): return unit.monster_id == "Guardião do Culto")
	var archers: Array = battle.enemies.filter(func(unit): return unit.monster_id == "Arqueiro do Culto")
	assert(guardians.size() == 2)
	assert(archers.size() == 2)
	for guardian in guardians:
		assert(guardian.level == 8 and guardian.max_hp == 72 and guardian.armor_class == 22)
		assert(guardian.get_max_attack_actions() == 2)
		assert(guardian.get_equipped_weapon_data()["attack_bonus"] == 2)
		assert(guardian.get_node_or_null("BattleToken/BattlePortrait") != null)
		battle.enemy = guardian
		assert(battle.get_enemy_target_unit() == hashagur)
	for archer in archers:
		assert(archer.level == 8 and archer.max_hp == 64 and archer.armor_class == 19)
		assert(archer.get_max_attack_actions() == 2)
		assert(archer.get_weapon_range_meters() == 18.0)
		assert(archer.get_node_or_null("BattleToken/BattlePortrait") != null)
		battle.enemy = archer
		assert(battle.get_enemy_target_unit() == hashagur)
	var ebramir: Node2D = battle.enemies.filter(func(unit): return unit.monster_id == "Ebramir")[0]
	assert(ebramir.level == 10 and ebramir.get_max_attack_actions() == 3)
	assert(ebramir.spell_slots_by_level[5] == 3)
	assert(ebramir.consume_spell_slot(5))
	assert(ebramir.spell_slots_by_level[5] == 2)
	assert(ebramir.get_node_or_null("BattleToken/BattlePortrait") != null)
	var hashagur_hp_before: int = hashagur.hp
	var spell_slots_before: int = int(ebramir.spell_slots_by_level[3])
	await battle._cast_ebramir_spell(ebramir, hashagur, TempleDuelData.EBRAMIR_SPELLS[0])
	assert(ebramir.spell_slots_by_level[3] == spell_slots_before - 1)
	assert(hashagur.hp < hashagur_hp_before)
	await battle._run_ebramir_turn(ebramir)
	assert(ebramir.attacks_used_this_turn == 3)
	assert(hashagur.hp > 0)
	hashagur.hp = hashagur.max_hp
	hashagur.update_health_bar()
	var guardian: Node2D = guardians[0]
	guardian.grid_position = Vector2i(23, 11)
	guardian.update_world_position()
	battle.enemy = guardian
	await battle.enemy_attack_target(hashagur)
	assert(guardian.attacks_used_this_turn == 1)
	assert(guardian.iterative_attack_penalty == 5)
	await battle.enemy_attack_target(hashagur)
	assert(guardian.attacks_used_this_turn == 2)
	hashagur.hp = hashagur.max_hp
	hashagur.update_health_bar()
	var archer: Node2D = archers[0]
	battle.enemy = archer
	await battle.enemy_attack_target(hashagur)
	assert(archer.attacks_used_this_turn == 1)
	assert(archer.iterative_attack_penalty == 5)
	await battle.enemy_attack_target(hashagur)
	assert(archer.attacks_used_this_turn == 2)
	hashagur.apply_status_effect("Derrubado", battle.battle_turn_count + 2)
	assert(battle.get_combat_advantage_attack_bonus(archer, hashagur) == 2)
	hashagur.remove_status_effect("Derrubado")
	assert(hashagur.get_remaining_attack_actions() == 3)
	hashagur.has_attacked = true
	assert(hashagur.get_remaining_attack_actions() == 2)
	hashagur.has_attacked = true
	assert(hashagur.get_remaining_attack_actions() == 1)
	hashagur.has_attacked = true
	assert(hashagur.has_attacked)
	hashagur.reset_movement()
	assert(hashagur.get_remaining_attack_actions() == 3)
	var kasum: Node2D = battle.find_scenario_npc_by_id("Kasum")
	assert(is_instance_valid(kasum))
	battle.current_active_unit = kasum
	var kasum_attacks: int = kasum.get_remaining_attack_actions()
	var rage_sound_slot: int = UIAudioManager.current_player_index
	battle.select_barbarian_power(kasum, "barbarian_rage")
	assert(kasum.is_raging)
	assert(kasum.get_remaining_attack_actions() == kasum_attacks)
	assert(UIAudioManager.players[rage_sound_slot].stream == UIAudioManager.rage_stream)
	battle.current_active_unit = hashagur
	hashagur.hp = 100
	hashagur.update_health_bar()
	for attack_index in range(3):
		hashagur.has_attacked = true
	assert(hashagur.get_remaining_attack_actions() == 0)
	assert(battle.can_select_monk_power(hashagur, "monk_ki_breath"))
	battle.select_monk_power(hashagur, "monk_ki_breath")
	assert(hashagur.hp == 120)
	assert(hashagur.get_remaining_attack_actions() == 0)
	var utility_power: Dictionary = ClassPowerProgressionData.get_power_options_for_level("Monge", 2)[0]
	assert(battle.can_select_progression_power(hashagur, str(utility_power["id"])))
	battle.select_progression_power(hashagur, str(utility_power["id"]))
	assert(hashagur.hp == 125)
	assert(hashagur.get_remaining_attack_actions() == 0)
	assert(battle.is_terrain_blocked(Vector2i(17, 11)))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(test_save))
	battle.queue_free()
	await get_tree().process_frame
	print("Temple battle runtime test passed")
	get_tree().quit(0)
