extends Node

const CharacterCreationScript = preload("res://Scene/character_creation.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const MainScript = preload("res://Scene/main.gd")


func _ready() -> void:
	var creation: Control = CharacterCreationScript.new()
	var wizard: Dictionary = creation.class_presets["Mago"]
	var sorcerer: Dictionary = creation.class_presets["Feiticeiro"]
	assert(int(wizard["hit_die"]) == 6)
	assert(int(wizard["fixed_hp_per_level"]) == 4)
	assert(int(sorcerer["hit_die"]) == 8)
	assert(int(sorcerer["fixed_hp_per_level"]) == 5)
	assert(wizard["will_type"] == "bom")
	assert(sorcerer["will_type"] == "bom")
	creation.free()

	var wizard_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Mago", "Humano", 1, false, [], {"intelligence": 16}
	)
	var sorcerer_feats: Array = FeatDatabase.get_available_feats_for_character(
		"Feiticeiro", "Humano", 1, false, [], {"charisma": 16}
	)
	assert(wizard_feats.size() == 10)
	assert(sorcerer_feats.size() == 10)
	assert(wizard_feats.has("Geometria Arcana"))
	assert(sorcerer_feats.has("Sangue Fulminante"))
	assert(not wizard_feats.has("Conjuração Defensiva"))
	assert(not sorcerer_feats.has("Magia Aumentada"))
	assert(not FeatDatabase.get_feat_data("Conjuração Defensiva").is_empty())

	var hero: Node2D = HeroScript.new()
	hero.character_class = "Mago"
	hero.setup_feats(["Geometria Arcana", "Reserva de Tinta"])
	assert(hero.feat_spell_save_dc_bonus == 1)
	assert(hero.feat_extra_spell_slot_level_1 == 1)
	var combat: Node2D = MainScript.new()
	combat.hero = hero
	assert(combat.get_spell_save_dc({"level": 1, "save_dc": 25}) == 10 + hero.get_intelligence_modifier() + 1)
	combat.free()
	hero.free()

	var sorcerer_hero: Node2D = HeroScript.new()
	sorcerer_hero.character_class = "Feiticeiro"
	sorcerer_hero.setup_feats(["Sangue Fulminante"])
	assert(sorcerer_hero.get_class_spell_damage_bonus(1) == 1)
	assert(sorcerer_hero.get_class_spell_damage_bonus(2) == 2)
	assert(sorcerer_hero.feat_spell_damage_bonus == 2)
	sorcerer_hero.free()

	var level_manager := LevelUpManager.new()
	assert(int(level_manager.get_spell_slot_limits("Mago", 1).get(1, 0)) == 3)
	assert(int(level_manager.get_spell_slot_limits("Feiticeiro", 1).get(1, 0)) == 2)
	var wizard_spells: Array = SpellDatabase.get_spells_for_class("Mago")
	var sorcerer_spells: Array = SpellDatabase.get_spells_for_class("Feiticeiro")
	var bard_spells: Array = SpellDatabase.get_spells_for_class("Bardo")
	assert(SpellDatabase.get_spell_data("Som Fantasma").is_empty())
	assert(wizard_spells.has("Selo de Lentidão") and wizard_spells.has("Prisão Arcana"))
	assert(not sorcerer_spells.has("Selo de Lentidão"))
	assert(sorcerer_spells.has("Pulso Sonoro") and sorcerer_spells.has("Explosão de Brasas"))
	assert(not wizard_spells.has("Pulso Sonoro") and not wizard_spells.has("Explosão de Brasas"))
	assert(bard_spells.has("Pulso Sonoro"))
	var old_wizard: Node2D = HeroScript.new()
	old_wizard.character_class = "Mago"
	old_wizard.setup_class_spells(["Som Fantasma"])
	assert(old_wizard.known_spells.has("Selo de Lentidão"))
	old_wizard.free()
	var old_sorcerer: Node2D = HeroScript.new()
	old_sorcerer.character_class = "Feiticeiro"
	old_sorcerer.setup_class_spells(["Som Fantasma"])
	assert(old_sorcerer.known_spells.has("Pulso Sonoro"))
	old_sorcerer.free()

	GameState.player_class = "Mago"
	GameState.hero_level = 3
	GameState.hero_class_hit_die = 4
	GameState.hero_hp_fixed_per_level = 3
	GameState.hero_hp_progression_mode = "fixed"
	GameState.hero_max_hp = 10
	var legacy_combat: Node2D = MainScript.new()
	legacy_combat.migrate_arcane_class_progression()
	assert(GameState.hero_class_hit_die == 6)
	assert(GameState.hero_hp_fixed_per_level == 4)
	assert(GameState.hero_max_hp == 14)
	legacy_combat.migrate_arcane_class_progression()
	assert(GameState.hero_max_hp == 14)
	legacy_combat.free()

	GameState.player_class = "Feiticeiro"
	GameState.hero_class_hit_die = 4
	GameState.hero_hp_fixed_per_level = 3
	GameState.hero_hp_progression_mode = "roll"
	GameState.hero_max_hp = 9
	var rolled_combat: Node2D = MainScript.new()
	rolled_combat.migrate_arcane_class_progression()
	assert(GameState.hero_class_hit_die == 8)
	assert(GameState.hero_hp_fixed_per_level == 5)
	assert(GameState.hero_max_hp == 9)
	rolled_combat.free()
	print("Arcane class traits tests passed")
	get_tree().quit(0)
