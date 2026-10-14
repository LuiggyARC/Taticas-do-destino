extends Node

const BarbarianPowers = preload("res://Scene/barbarian_powers.gd")
const NpcDatabase = preload("res://Scene/npc_database.gd")
const NpcScript = preload("res://Scene/units/npc.gd")


func _ready() -> void:
	run_tests()


func run_tests() -> void:
	var powers: Array = BarbarianPowers.get_powers()
	assert(powers.size() == 3)
	assert(str(powers[0]["frequency"]) == "Sem limite")
	assert(str(powers[1]["frequency"]) == "Por encontro")
	assert(str(powers[2]["frequency"]) == "Diário")

	var barbarian_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Bárbaro", "Humano", 1, false, [], {"strength": 18}
	)
	assert(barbarian_feats.has("Golpe Pesado"))
	assert(not barbarian_feats.has("Ataque Poderoso"))
	assert(not FeatDatabase.get_feat_data("Ataque Poderoso").is_empty())

	var kasum: Dictionary = NpcDatabase.get_kasum()
	assert(kasum["feats"].has("Golpe Pesado"))
	assert(not kasum["feats"].has("Ataque Poderoso"))

	GameState.player_name = "Teste"
	GameState.player_class = "Bárbaro"
	PartyManager.reset_party()
	assert(PartyManager.is_daily_power_available("hero", "barbarian_decisive"))
	assert(PartyManager.consume_daily_power("hero", "barbarian_decisive"))
	PartyManager.sync_hero_from_game_state()
	assert(not PartyManager.is_daily_power_available("hero", "barbarian_decisive"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "barbarian_decisive"))

	var npc: Node2D = NpcScript.new()
	npc.character_class = "Bárbaro"
	npc.level = 3
	npc.constitution = 14
	npc.max_hp = 34
	npc.hp = 34
	assert(npc.can_use_rage())
	npc.activate_rage(1)
	assert(npc.is_raging)
	assert(npc.max_hp == 40)
	npc.update_rage_turn(10)
	assert(not npc.is_raging)
	assert(npc.max_hp == 34)
	npc.free()
	print("Barbarian migration tests passed")
	get_tree().quit(0)
