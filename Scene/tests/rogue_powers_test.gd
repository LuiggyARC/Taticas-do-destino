extends Node

const RoguePowers = preload("res://Scene/rogue_powers.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const MainScript = preload("res://Scene/main.gd")
const NpcDatabase = preload("res://Scene/npc_database.gd")


func _ready() -> void:
	var powers: Array = RoguePowers.get_powers()
	assert(powers.size() == 3)
	assert(str(powers[0]["frequency"]) == "Sem limite")
	assert(str(powers[1]["frequency"]) == "Por encontro")
	assert(str(powers[2]["frequency"]) == "Diário")

	var rogue_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Ladino", "Humano", 1, false, [], {"dexterity": 14}
	)
	assert(rogue_feats.has("Olho para Brechas"))
	assert(rogue_feats.has("Passos de Veludo"))
	assert(not rogue_feats.has("Flanqueador"))
	assert(not FeatDatabase.get_feat_data("Flanqueador").is_empty())
	var aniri_data: Dictionary = NpcDatabase.get_aniri()
	assert(aniri_data["feats"].has("Passos de Veludo"))
	assert(aniri_data["feats"].has("Olho para Brechas"))
	assert(not aniri_data["feats"].has("Foco em Arma: Espada Curta"))

	var hero: Node2D = HeroScript.new()
	hero.character_class = "Ladino"
	hero.setup_feats(["Olho para Brechas", "Lâmina Discreta", "Passos de Veludo"])
	assert(hero.feat_flanking_attack_bonus == 1)
	assert(hero.feat_hidden_damage_bonus == 2)
	assert(hero.feat_hide_bonus == 2)
	assert(hero.can_use_hide_skill())
	hero.use_hide_skill()
	assert(hero.is_hidden)
	assert(not hero.can_use_hide_skill())
	hero.free()

	var npc: Node2D = NpcScript.new()
	npc.character_class = "Ladino"
	var combat: Node2D = MainScript.new()
	combat.npcs.append(npc)
	combat.current_active_unit = npc
	npc.feats = ["Guarda Esquiva", "Ritmo de Emboscada"]
	npc.armor_class = 13
	assert(npc.get_armor_class() == 14)
	assert(combat.get_unit_initiative_bonus(npc) == 1)
	assert(combat.can_select_rogue_power(npc, "rogue_hide"))
	assert(combat.can_select_rogue_power(npc, "rogue_precise_strike"))
	assert(combat.can_select_rogue_power(npc, "rogue_final_cut"))
	combat.prepared_class_attack = "rogue_precise_strike"
	combat.prepared_class_attacker = npc
	assert(combat.get_prepared_rogue_attack_bonus(npc) == 2)
	assert(combat.consume_prepared_rogue_power(npc))
	assert(not combat.can_select_rogue_power(npc, "rogue_precise_strike"))
	combat.prepared_class_attack = "rogue_final_cut"
	assert(combat.get_prepared_rogue_damage_bonus(npc) == 4)
	assert(combat.consume_prepared_rogue_power(npc))
	assert(not combat.can_select_rogue_power(npc, "rogue_final_cut"))
	combat.free()
	npc.free()

	GameState.player_name = "Teste"
	GameState.player_class = "Ladino"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "rogue_final_cut"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "rogue_final_cut"))
	var saved: Dictionary = PartyManager.get_save_data()
	PartyManager.load_save_data(saved)
	assert(not PartyManager.is_daily_power_available("hero", "rogue_final_cut"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "rogue_final_cut"))

	print("Rogue migration tests passed")
	get_tree().quit(0)
