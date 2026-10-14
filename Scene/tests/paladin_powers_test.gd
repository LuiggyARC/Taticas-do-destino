extends Node

const PaladinPowers = preload("res://Scene/paladin_powers.gd")
const NpcDatabase = preload("res://Scene/npc_database.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const MainScript = preload("res://Scene/main.gd")


func _ready() -> void:
	var powers: Array = PaladinPowers.get_powers()
	assert(powers.size() == 3)
	assert(str(powers[0]["frequency"]) == "Sem limite")
	assert(str(powers[1]["frequency"]) == "Por encontro")
	assert(str(powers[2]["frequency"]) == "Diário")

	var paladin_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Paladino", "Humano", 1, false, [], {"strength": 14}
	)
	assert(paladin_feats.has("Lâmina da Ordem"))
	assert(paladin_feats.has("Justiça Ardente"))
	assert(not paladin_feats.has("Graça Divina Aprimorada"))
	assert(not FeatDatabase.get_feat_data("Graça Divina Aprimorada").is_empty())

	var hero: Node2D = HeroScript.new()
	hero.character_class = "Paladino"
	hero.level = 2
	hero.charisma = 16
	hero.setup_feats(["Lâmina da Ordem", "Justiça Ardente"])
	assert(hero.feat_melee_attack_bonus == 1)
	assert(hero.can_use_smite_evil())
	hero.activate_smite_evil()
	assert(hero.get_smite_evil_attack_bonus() == 3)
	assert(hero.get_smite_evil_damage_bonus() == 4)
	hero.consume_smite_evil()
	assert(not hero.can_use_smite_evil())
	hero.free()

	var uiliam_data: Dictionary = NpcDatabase.get_sr_uiliam()
	assert(uiliam_data["feats"].has("Lâmina da Ordem"))
	assert(not uiliam_data["feats"].has("Foco em Arma - Espada Longa"))
	var npc: Node2D = NpcScript.new()
	npc.character_class = "Paladino"
	npc.feats = ["Lâmina da Ordem", "Defesa Juramentada"]
	npc.armor_class = 18
	npc.base_attack_bonus = 3
	npc.strength = 14
	assert(npc.get_armor_class() == 19)
	assert(npc.get_total_attack_bonus() == 6)
	assert(npc.can_use_smite_evil())
	npc.activate_smite_evil()
	npc.consume_smite_evil()
	assert(not npc.can_use_smite_evil())
	var combat: Node2D = MainScript.new()
	combat.npcs.append(npc)
	combat.current_active_unit = npc
	assert(combat.can_select_paladin_power(npc, "paladin_verdict"))
	assert(combat.consume_class_daily_power(npc, "paladin_verdict"))
	assert(npc.daily_powers_used.has("paladin_verdict"))
	assert(not combat.can_select_paladin_power(npc, "paladin_verdict"))
	combat.free()
	npc.free()

	GameState.player_name = "Teste"
	GameState.player_class = "Paladino"
	PartyManager.reset_party()
	assert(PartyManager.recruit_npc("Sr Uiliam", true))
	assert(PartyManager.consume_daily_power("hero", "paladin_verdict"))
	assert(PartyManager.consume_daily_power("Sr Uiliam", "paladin_verdict"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "paladin_verdict"))
	var saved: Dictionary = PartyManager.get_save_data()
	PartyManager.load_save_data(saved)
	assert(not PartyManager.is_daily_power_available("Sr Uiliam", "paladin_verdict"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "paladin_verdict"))
	assert(PartyManager.is_daily_power_available("Sr Uiliam", "paladin_verdict"))

	print("Paladin migration tests passed")
	get_tree().quit(0)
