extends Node

const DruidPowers = preload("res://Scene/druid_powers.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const MainScript = preload("res://Scene/main.gd")


func _ready() -> void:
	var powers: Array = DruidPowers.get_powers()
	assert(powers.size() == 3)
	assert(str(powers[0]["frequency"]) == "Sem limite")
	assert(str(powers[1]["frequency"]) == "Por encontro")
	assert(str(powers[2]["frequency"]) == "Diário")

	var druid_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Druida", "Humano", 1, false, [], {"wisdom": 16}
	)
	assert(druid_feats.has("Casca Espessa"))
	assert(druid_feats.has("Companheiro Robusto"))
	assert(not druid_feats.has("Companheiro Animal Fortalecido"))
	assert(not FeatDatabase.get_feat_data("Companheiro Animal Fortalecido").is_empty())

	var hero: Node2D = HeroScript.new()
	hero.character_class = "Druida"
	hero.level = 2
	hero.wisdom = 16
	hero.setup_feats(["Casca Espessa", "Garras da Mata", "Seiva Generosa"])
	var normal_ac: int = hero.get_armor_class()
	hero.druid_guard_active = true
	assert(hero.get_armor_class() == normal_ac + 2)
	hero.reset_movement()
	assert(not hero.druid_guard_active)
	hero.activate_druid_form(1)
	assert(hero.get_armor_class() == normal_ac + 1)
	assert(hero.get_druid_form_damage_bonus() == 3)
	hero.update_druid_form_turn(4)
	assert(not hero.druid_form_active)
	assert(hero.get_armor_class() == normal_ac)

	var combat: Node2D = MainScript.new()
	combat.hero = hero
	combat.current_active_unit = hero
	assert(combat.can_select_druid_power(hero, "druid_barkguard"))
	hero.has_attacked = true
	assert(combat.can_select_druid_power(hero, "druid_barkguard"))
	hero.has_attacked = false
	assert(combat.get_druid_circle_healing(hero) == 10)
	combat.free()
	hero.free()

	var npc: Node2D = NpcScript.new()
	npc.character_class = "Druida"
	npc.feats = ["Casca Espessa", "Garras da Mata"]
	npc.armor_class = 12
	npc.druid_guard_active = true
	assert(npc.get_armor_class() == 14)
	npc.reset_movement()
	assert(npc.get_armor_class() == 12)
	npc.activate_druid_form(2)
	assert(npc.get_armor_class() == 13)
	assert(npc.get_druid_form_damage_bonus() == 3)
	npc.update_druid_form_turn(5)
	assert(npc.get_armor_class() == 12)
	npc.free()

	GameState.player_name = "Teste"
	GameState.player_class = "Druida"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "druid_life_circle"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "druid_life_circle"))
	var saved: Dictionary = PartyManager.get_save_data()
	PartyManager.load_save_data(saved)
	assert(not PartyManager.is_daily_power_available("hero", "druid_life_circle"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "druid_life_circle"))

	print("Druid migration tests passed")
	get_tree().quit(0)
