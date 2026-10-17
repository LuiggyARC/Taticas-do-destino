extends Node

const HeroScript = preload("res://Scene/units/hero.gd")
const NpcScript = preload("res://Scene/units/npc.gd")
const MainScript = preload("res://Scene/main.gd")

func _ready() -> void:
	GameState.player_name = "Teste"
	GameState.player_class = "Mago"
	GameState.hero_max_hp = 12
	GameState.hero_spell_slots_level_1 = 1
	GameState.hero_max_spell_slots_level_1 = 3
	PartyManager.reset_party()
	assert(PartyManager.recruit_member({"id": "Aniri", "display_name": "Aniri", "current_hp": 10, "max_hp": 10}))

	var combat: Node2D = MainScript.new()
	var hero: Node2D = HeroScript.new()
	hero.character_class = "Mago"
	hero.max_hp = 12
	hero.hp = 5
	hero.spell_slots_level_1 = 1
	hero.max_spell_slots_level_1 = 3
	combat.hero = hero
	var aniri: Node2D = NpcScript.new()
	aniri.npc_id = "Aniri"
	aniri.max_hp = 10
	aniri.hp = 4
	aniri.daily_powers_used = ["rogue_final_cut"]
	combat.npcs.append(aniri)
	combat.sync_battle_party_resources()

	var saved_hero: Dictionary = PartyManager.get_member(PartyManager.HERO_MEMBER_ID)
	var saved_aniri: Dictionary = PartyManager.get_member("Aniri")
	assert(int(saved_hero["current_hp"]) == 5)
	assert(int(saved_hero["spell_slots_level_1"]) == 1)
	assert(int(saved_aniri["current_hp"]) == 4)
	assert(saved_aniri["daily_powers_used"].has("rogue_final_cut"))
	GameState.hero_known_spells = ["Mísseis Mágicos"]
	hero.hp = hero.max_hp
	hero.spell_slots_level_1 = hero.max_spell_slots_level_1
	combat.configure_hero_from_game_state()
	assert(hero.hp == 5)
	assert(hero.spell_slots_level_1 == 1)
	assert(hero.apply_level_up_result({
		"new_level": 2,
		"hp_gain": 4,
		"attribute_increases": {},
		"new_spell_slots": {0: 3, 1: 4}
	}))
	assert(hero.hp == 5)
	assert(hero.spell_slots_level_1 == 1)
	combat.sync_battle_party_resources()

	PartyManager.restore_active_party_after_rest()
	assert(int(PartyManager.get_member(PartyManager.HERO_MEMBER_ID)["current_hp"]) == hero.max_hp)
	assert(int(PartyManager.get_member(PartyManager.HERO_MEMBER_ID)["spell_slots_level_1"]) == hero.max_spell_slots_level_1)
	assert(int(PartyManager.get_member("Aniri")["current_hp"]) == 10)
	assert(PartyManager.get_member("Aniri")["daily_powers_used"].is_empty())
	combat.free()
	hero.free()
	aniri.free()
	print("Battle resource persistence tests passed")
	get_tree().quit(0)
