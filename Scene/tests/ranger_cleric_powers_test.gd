extends Node

const RangerPowers = preload("res://Scene/ranger_powers.gd")
const ClericPowers = preload("res://Scene/cleric_powers.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const MainScript = preload("res://Scene/main.gd")
const CharacterCreationScript = preload("res://Scene/character_creation.gd")


func _ready() -> void:
	for powers in [RangerPowers.get_powers(), ClericPowers.get_powers()]:
		assert(powers.size() == 3)
		assert(str(powers[0]["frequency"]) == "Sem limite")
		assert(str(powers[1]["frequency"]) == "Por encontro")
		assert(str(powers[2]["frequency"]) == "Diário")

	var creation: Control = CharacterCreationScript.new()
	assert(int(creation.class_presets["Ranger"]["hit_die"]) == 8)
	assert(int(creation.class_presets["Clérigo"]["hit_die"]) == 8)
	creation.free()

	var ranger_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Ranger", "Humano", 1, false, [], {"dexterity": 16}
	)
	assert(ranger_feats.size() == 8)
	assert(ranger_feats.has("Mira da Fronteira"))
	assert(not ranger_feats.has("Companheiro Tenaz"))
	assert(not ranger_feats.has("Inimigo Predileto"))
	assert(FeatDatabase.get_available_feats_for_character(
		"Ranger", "Humano", 4, false, [], {"dexterity": 16}
	).has("Companheiro Tenaz"))

	var cleric_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Clérigo", "Humano", 1, false, [], {"wisdom": 16}
	)
	assert(cleric_feats.size() == 10)
	assert(cleric_feats.has("Mãos Generosas"))
	assert(not cleric_feats.has("Expulsão Extra"))

	var ranger: Node2D = HeroScript.new()
	ranger.character_class = "Ranger"
	ranger.level = 4
	ranger.setup_feats(["Mira da Fronteira", "Passo Aberto", "Companheiro Tenaz"])
	assert(ranger.feat_ranged_attack_bonus == 1)
	assert(ranger.feat_movement_bonus == 1.5)
	assert(ranger.feat_animal_companion_hp_bonus == 4)
	var combat: Node2D = MainScript.new()
	combat.hero = ranger
	combat.current_active_unit = ranger
	assert(combat.can_select_ranger_power(ranger, "ranger_field_aim"))
	assert(combat.can_select_ranger_power(ranger, "ranger_trail_step"))
	combat.prepared_class_attack = "ranger_field_aim"
	combat.prepared_class_attacker = ranger
	assert(combat.get_prepared_ranger_attack_bonus(ranger) == 1)
	combat.prepared_class_attack = "ranger_relentless_hunt"
	assert(combat.get_prepared_ranger_damage_bonus(ranger) == 4)
	combat.free()
	ranger.free()

	var cleric: Node2D = HeroScript.new()
	cleric.character_class = "Clérigo"
	cleric.level = 2
	cleric.wisdom = 16
	cleric.setup_feats(["Mãos Generosas", "Voto de Amparo", "Selo Luminoso"])
	assert(cleric.feat_healing_bonus == 2)
	assert(cleric.feat_spell_damage_bonus == 2)
	var base_ac: int = cleric.get_armor_class()
	cleric.cleric_guard_active = true
	assert(cleric.get_armor_class() == base_ac + 1)
	cleric.reset_movement()
	assert(not cleric.cleric_guard_active)
	var cleric_combat: Node2D = MainScript.new()
	cleric_combat.hero = cleric
	cleric_combat.current_active_unit = cleric
	assert(cleric_combat.can_select_cleric_power(cleric, "cleric_guarding_light"))
	cleric.has_attacked = true
	assert(cleric_combat.can_select_cleric_power(cleric, "cleric_guarding_light"))
	cleric.has_attacked = false
	assert(cleric_combat.get_cleric_power_healing(cleric, "cleric_helping_prayer") == 12)
	cleric_combat.free()
	cleric.free()

	var npc: Node2D = NpcScript.new()
	npc.character_class = "Clérigo"
	npc.armor_class = 13
	npc.cleric_guard_active = true
	assert(npc.get_armor_class() == 14)
	npc.reset_movement()
	assert(npc.get_armor_class() == 13)
	npc.free()

	GameState.player_name = "Teste"
	GameState.player_class = "Ranger"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "ranger_relentless_hunt"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "ranger_relentless_hunt"))
	var saved: Dictionary = PartyManager.get_save_data()
	PartyManager.load_save_data(saved)
	assert(not PartyManager.is_daily_power_available("hero", "ranger_relentless_hunt"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "ranger_relentless_hunt"))

	GameState.player_class = "Clérigo"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "cleric_renewing_dawn"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "cleric_renewing_dawn"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "cleric_renewing_dawn"))

	print("Ranger and cleric migration tests passed")
	get_tree().quit(0)
