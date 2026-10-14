extends Node

const Progression = preload("res://Scene/level_progression.gd")
const Powers = preload("res://Scene/class_power_progression.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const MainScript = preload("res://Scene/main.gd")


func _ready() -> void:
	assert(Progression.MAX_LEVEL == 30)
	assert(Progression.xp_for_level(2) == 1000)
	assert(Progression.xp_for_level(11) == 26000)
	assert(Progression.xp_for_level(20) == 143000)
	assert(Progression.xp_for_level(30) == 1000000)
	for level in range(2, 31):
		assert(Progression.xp_for_level(level) > Progression.xp_for_level(level - 1))
	assert(Progression.attribute_points(4, "Humano") == 2)
	assert(Progression.attribute_points(4, "Meio-Elfo") == 3)
	assert(Progression.attribute_points(12, "Meio-Elfo") == 3)
	assert(Progression.attribute_points(11, "Meio-Elfo") == 0)
	assert(Progression.general_feat_count(2) == 1)
	assert(Progression.general_feat_count(11) == 1)
	assert(Progression.general_feat_count(21) == 1)
	assert(Progression.general_feat_count(13) == 0)
	assert("reservado" in " ".join(Progression.gains_for_level(11, "Humano")))
	assert(Progression.power_totals_for_level(1) == {"at_will": 2, "encounter": 1, "daily": 1, "utility": 0})
	assert(Progression.power_totals_for_level(13)["encounter"] == 4)
	assert(Progression.power_totals_for_level(30) == {"at_will": 2, "encounter": 4, "daily": 4, "utility": 7})

	var power_levels: Array = [1]
	power_levels.append_array(Progression.UTILITY_LEVELS)
	power_levels.append_array(Progression.ENCOUNTER_LEVELS)
	power_levels.append_array(Progression.DAILY_LEVELS)
	for playable_class in Powers.CLASS_STYLE:
		for level in power_levels:
			var power: Dictionary = Powers.get_new_power_for_level(playable_class, level)
			var options: Array[Dictionary] = Powers.get_power_options_for_level(playable_class, level)
			assert(not power.is_empty())
			assert(options.size() == 2)
			assert(options[0]["id"] != options[1]["id"])
			assert(options[0]["description"] != options[1]["description"])
			assert(Powers.get_power_by_id(str(power["id"]))["name"] == power["name"])
			assert(Powers.get_power_by_id(str(options[1]["id"]))["name"] == options[1]["name"])
			assert(str(power["description"]) != "")
		var selected_options: Dictionary = {"2": str(Powers.get_power_options_for_level(playable_class, 2)[1]["id"])}
		assert(_contains_power(Powers.get_available_powers(playable_class, 2, selected_options), selected_options["2"]))
		assert(not _contains_power(Powers.get_available_powers(playable_class, 2, selected_options), str(Powers.get_new_power_for_level(playable_class, 2)["id"])))
		var level_12: Array = Powers.get_available_powers(playable_class, 12)
		var level_17: Array = Powers.get_available_powers(playable_class, 17)
		assert(_contains_power(level_12, "progression_%s_3" % Powers.CLASS_STYLE[playable_class]["key"]))
		assert(not _contains_power(level_17, "progression_%s_3" % Powers.CLASS_STYLE[playable_class]["key"]))

	var hero: Node2D = HeroScript.new()
	hero.character_class = "Guerreiro"
	hero.character_race = "Meio-Elfo"
	hero.level = 3
	hero.max_level = 30
	var level_manager := LevelUpManager.new()
	var preview: Dictionary = level_manager.get_level_up_preview(hero, 4)
	assert(int(preview["attribute_point_count"]) == 3)
	assert(int(preview["new_xp_threshold"]) == 3750)
	assert(int(preview["feat_choice_count"]) >= 1)
	hero.free()

	var choice_hero: Node2D = HeroScript.new()
	choice_hero.character_class = "Guerreiro"
	var chosen_power: String = str(Powers.get_power_options_for_level("Guerreiro", 2)[1]["id"])
	assert(choice_hero.apply_level_up_result({
		"new_level": 2,
		"hp_gain": 8,
		"attribute_increases": {},
		"selected_class_power": chosen_power
	}))
	assert(choice_hero.selected_class_powers["2"] == chosen_power)
	assert(_contains_power(Powers.get_available_powers("Guerreiro", 2, choice_hero.selected_class_powers), chosen_power))
	var combat: Node2D = MainScript.new()
	combat.hero = choice_hero
	assert(combat.get_player_save_data()["hero_class_power_choices"]["2"] == chosen_power)
	combat.free()
	choice_hero.free()
	print("Level progression tests passed")
	get_tree().quit(0)


func _contains_power(powers: Array, power_id: String) -> bool:
	for power in powers:
		if str(power.get("id", "")) == power_id:
			return true
	return false
