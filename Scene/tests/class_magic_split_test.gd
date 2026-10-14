extends Node

const ClassPowers = preload("res://Scene/class_power_progression.gd")
const LevelManager = preload("res://Scene/level_up_manager.gd")
const HeroScript = preload("res://Scene/units/hero.gd")
const SpellData = preload("res://Scene/spell_database.gd")


func _ready() -> void:
	var manager := LevelManager.new()
	var database := SpellData.new()
	for character_class in ["Paladino", "Ranger"]:
		assert(ClassPowers.has_class(character_class))
		assert(not ClassPowers.get_power_options_for_level(character_class, 5).is_empty())
		assert(not manager.is_spellcasting_class(character_class))
		assert(manager.get_max_spell_level_for_class(character_class, 30) == -1)
		assert(manager.get_spell_choice_count(character_class, 7) == 0)
		assert(manager.get_spell_slot_limits(character_class, 30) == {0: 0, 1: 0, 2: 0})
		assert(database.get_spells_for_class(character_class).is_empty())
		var hero := HeroScript.new()
		hero.character_class = character_class
		hero.level = 7
		hero.known_spells = ["Curar Ferimentos Leves"]
		hero.setup_class_spells(hero.known_spells)
		assert(hero.known_spells.is_empty())
		assert(hero.spell_slots_level_1 == 0)
		assert(hero.max_spell_slots_level_1 == 0)
		hero.free()
	for character_class in ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"]:
		assert(manager.is_spellcasting_class(character_class))
		assert(not ClassPowers.has_class(character_class))
	assert(ClassPowers.has_class("Bruxo"))
	assert(not manager.is_spellcasting_class("Bruxo"))
	database.free()
	print("Class magic split tests passed")
	get_tree().quit(0)
