extends Node

const BarbarianPowers = preload("res://Scene/barbarian_powers.gd")
const NpcDatabase = preload("res://Scene/npc_database.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const MainScript = preload("res://Scene/main.gd")
const ActionPanelScript = preload("res://Scene/combat_action_panel.gd")


func _ready() -> void:
	run_tests()


func run_tests() -> void:
	var powers: Array = BarbarianPowers.get_powers()
	assert(powers.size() == 2)
	assert(str(powers[0]["frequency"]) == "Sem limite")
	assert(str(powers[1]["frequency"]) == "Diário")
	assert(not powers.any(func(power): return str(power.get("id", "")) == "barbarian_rage"))

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

	var ui_layer := CanvasLayer.new()
	add_child(ui_layer)
	var action_panel: Node = ActionPanelScript.new()
	add_child(action_panel)
	action_panel.setup(ui_layer, {})
	var combat: Node2D = MainScript.new()
	var barbarian: Node2D = HeroScript.new()
	barbarian.character_class = "Bárbaro"
	combat.hero = barbarian
	combat.current_active_unit = barbarian
	combat.initiative_started = true
	combat.combat_action_panel_controller = action_panel
	combat.update_class_skill_button()
	assert(action_panel.rage_button.visible)
	assert(not action_panel.rage_button.disabled)
	barbarian.rage_uses_this_battle = 1
	combat.update_class_skill_button()
	assert(action_panel.rage_button.disabled)
	combat.free()
	barbarian.free()
	action_panel.free()
	ui_layer.free()
	print("Barbarian migration tests passed")
	get_tree().quit(0)
