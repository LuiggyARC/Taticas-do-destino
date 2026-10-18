extends Node

const BardPowers = preload("res://Scene/bard_powers.gd")
const FighterPowers = preload("res://Scene/fighter_powers.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const MainScript = preload("res://Scene/main.gd")
const CharacterCreationScript = preload("res://Scene/character_creation.gd")


func _ready() -> void:
	for powers in [BardPowers.get_powers(), FighterPowers.get_powers()]:
		assert(powers.size() == 3)
		assert(str(powers[0]["frequency"]) == "Sem limite")
		assert(str(powers[1]["frequency"]) == "Por encontro")
		assert(str(powers[2]["frequency"]) == "Diário")

	var creation: Control = CharacterCreationScript.new()
	assert(int(creation.class_presets["Bardo"]["hit_die"]) == 8)
	assert(int(creation.class_presets["Bardo"]["fixed_hp_per_level"]) == 5)
	assert(int(creation.class_presets["Guerreiro"]["hit_die"]) == 10)
	assert(creation.get_feat_choice_count("Guerreiro", "Humano", 1) == 3)
	creation.free()

	var bard_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Bardo", "Humano", 1, false, [], {"charisma": 16}
	)
	var fighter_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Guerreiro", "Humano", 1, false, [], {"strength": 16}
	)
	assert(bard_feats.size() == 10)
	assert(fighter_feats.size() == 10)
	assert(bard_feats.has("Refrão Duradouro"))
	assert(fighter_feats.has("Armadura de Campanha"))
	assert(not bard_feats.has("Canção Inspiradora"))
	assert(not fighter_feats.has("Foco em Arma"))
	assert(not FeatDatabase.get_feat_data("Canção Inspiradora").is_empty())

	var bard: Node2D = HeroScript.new()
	bard.character_class = "Bardo"
	bard.level = 2
	bard.charisma = 16
	bard.setup_feats(["Acordes Fortes", "Refrão Duradouro", "Dueto Preciso"])
	assert(bard.feat_healing_bonus == 2)
	assert(bard.feat_attack_bonus == 1)
	var combat: Node2D = MainScript.new()
	combat.hero = bard
	combat.current_active_unit = bard
	assert(combat.can_select_bard_power(bard, "bard_precise_rhythm"))
	assert(combat.can_select_bard_power(bard, "bard_courage_refrain"))
	bard.has_attacked = true
	assert(combat.can_select_bard_power(bard, "bard_courage_refrain"))
	assert(not combat.can_select_bard_power(bard, "bard_precise_rhythm"))
	bard.has_attacked = false
	assert(combat.get_bard_renewal_healing(bard) == 10)
	assert(combat.get_bard_refrain_duration(bard) == 3)
	combat.prepared_class_attack = "bard_precise_rhythm"
	combat.prepared_class_attacker = bard
	assert(combat.get_prepared_bard_attack_bonus(bard) == 1)
	combat.battle_turn_count = 2
	combat.bard_song_end_round = 4
	assert(combat.get_bard_song_attack_bonus(bard) == 1)
	var allied_guard: Node2D = NpcScript.new()
	allied_guard.faction = "ally"
	combat.npcs.append(allied_guard)
	assert(combat.get_bard_song_attack_bonus(allied_guard) == 1)
	allied_guard.faction = "enemy"
	assert(combat.get_bard_song_attack_bonus(allied_guard) == 0)
	allied_guard.free()
	combat.battle_turn_count = 5
	assert(combat.get_bard_song_attack_bonus(bard) == 0)
	combat.free()
	bard.free()

	var fighter: Node2D = HeroScript.new()
	fighter.character_class = "Guerreiro"
	fighter.setup_feats(["Armadura de Campanha", "Lâmina Disciplinada", "Pancada de Ferro"])
	assert(fighter.feat_armor_class_bonus == 1)
	assert(fighter.feat_melee_attack_bonus == 1)
	assert(fighter.feat_melee_damage_bonus == 2)
	var base_ac: int = fighter.get_armor_class()
	fighter.fighter_guard_active = true
	assert(fighter.get_armor_class() == base_ac + 2)
	fighter.reset_movement()
	assert(not fighter.fighter_guard_active)
	var fighter_combat: Node2D = MainScript.new()
	fighter_combat.hero = fighter
	fighter_combat.current_active_unit = fighter
	assert(fighter_combat.can_select_fighter_power(fighter, "fighter_technical_strike"))
	assert(fighter_combat.can_select_fighter_power(fighter, "fighter_steady_stance"))
	fighter.has_attacked = true
	assert(fighter_combat.can_select_fighter_power(fighter, "fighter_steady_stance"))
	assert(not fighter_combat.can_select_fighter_power(fighter, "fighter_technical_strike"))
	fighter.has_attacked = false
	fighter_combat.prepared_class_attack = "fighter_breaking_strike"
	fighter_combat.prepared_class_attacker = fighter
	assert(fighter_combat.get_prepared_fighter_attack_bonus(fighter) == 2)
	assert(fighter_combat.get_prepared_fighter_damage_bonus(fighter) == 3)
	fighter_combat.free()
	fighter.free()

	var npc: Node2D = NpcScript.new()
	npc.character_class = "Guerreiro"
	npc.armor_class = 13
	npc.feats = ["Armadura de Campanha", "Lâmina Disciplinada", "Reflexo de Guarda"]
	npc.weapon_type = "melee"
	assert(npc.get_armor_class() == 14)
	npc.fighter_guard_active = true
	assert(npc.get_armor_class() == 16)
	assert(npc.get_total_attack_bonus() == 1)
	assert(npc.get_fortitude_save_bonus() == 1)
	assert(npc.get_reflex_save_bonus() == 1)
	npc.free()

	GameState.player_name = "Teste"
	GameState.player_class = "Bardo"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "bard_renewal_song"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "bard_renewal_song"))
	var saved: Dictionary = PartyManager.get_save_data()
	PartyManager.load_save_data(saved)
	assert(not PartyManager.is_daily_power_available("hero", "bard_renewal_song"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "bard_renewal_song"))

	GameState.player_class = "Guerreiro"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "fighter_breaking_strike"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "fighter_breaking_strike"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "fighter_breaking_strike"))

	print("Bard and fighter migration tests passed")
	get_tree().quit(0)
