extends Node

const MonkPowers = preload("res://Scene/monk_powers.gd")
const WarlockPowers = preload("res://Scene/warlock_powers.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const MainScript = preload("res://Scene/main.gd")
const CharacterCreationScript = preload("res://Scene/character_creation.gd")


func _ready() -> void:
	for powers in [MonkPowers.get_powers(), WarlockPowers.get_powers()]:
		assert(powers.size() == 3)
		assert(str(powers[0]["frequency"]) == "Sem limite")
		assert(str(powers[1]["frequency"]) == "Por encontro")
		assert(str(powers[2]["frequency"]) == "Diário")
	var creation: Control = CharacterCreationScript.new()
	assert(creation.class_presets.has("Bruxo"))
	assert(int(creation.class_presets["Bruxo"]["hit_die"]) == 8)
	assert(int(creation.class_presets["Monge"]["hit_die"]) == 8)
	creation.free()
	var warlock_feats: Array = FeatDatabase.get_available_feats_for_character("Bruxo", "Humano", 1)
	var monk_feats: Array = FeatDatabase.get_available_feats_for_character("Monge", "Humano", 1)
	assert(warlock_feats.size() == 10)
	assert(monk_feats.size() == 10)
	assert(warlock_feats.has("Pacto Intenso"))
	assert(monk_feats.has("Punho Centrado"))
	assert(not monk_feats.has("Disciplina Monástica"))
	assert(not FeatDatabase.get_feat_data("Disciplina Monástica").is_empty())
	var monk: Node2D = HeroScript.new()
	monk.character_class = "Monge"
	monk.equipped_weapon = "Soco"
	var combat: Node2D = MainScript.new()
	combat.hero = monk
	combat.current_active_unit = monk
	assert(combat.can_select_monk_power(monk, "monk_focused_strike"))
	assert(combat.can_select_monk_power(monk, "monk_flurry"))
	monk.encounter_powers_used.append("monk_flurry")
	assert(not combat.can_select_monk_power(monk, "monk_flurry"))
	assert(str(MonkPowers.get_powers_for_level(9)[1]["frequency"]) == "Por encontro")
	monk.level = 10
	assert(str(MonkPowers.get_powers_for_level(10)[1]["frequency"]) == "Sem limite")
	assert(combat.can_select_monk_power(monk, "monk_flurry"))
	combat.free()
	monk.free()
	var warlock: Node2D = HeroScript.new()
	warlock.character_class = "Bruxo"
	warlock.setup_feats(["Pacto Intenso", "Vontade do Pacto"])
	assert(warlock.feat_spell_damage_bonus == 1)
	assert(not warlock.has_feat("Selo Preciso"))
	var warlock_combat: Node2D = MainScript.new()
	warlock_combat.hero = warlock
	warlock_combat.current_active_unit = warlock
	assert(warlock_combat.can_select_warlock_power(warlock, "warlock_eldritch_spark"))
	warlock_combat.prepared_class_attack = "warlock_eldritch_spark"
	warlock_combat.prepared_class_attacker = warlock
	assert(warlock_combat.get_prepared_power_range(warlock) == 9.0)
	warlock.encounter_powers_used.append("warlock_binding_burst")
	assert(not warlock_combat.can_select_warlock_power(warlock, "warlock_binding_burst"))
	warlock_combat.free()
	warlock.free()
	GameState.player_name = "Teste"
	GameState.player_class = "Bruxo"
	PartyManager.reset_party()
	assert(PartyManager.consume_daily_power("hero", "warlock_pact_judgment"))
	PartyManager.restore_active_party_after_rest()
	assert(PartyManager.is_daily_power_available("hero", "warlock_pact_judgment"))
	print("Monk and warlock powers tests passed")
	get_tree().quit(0)
