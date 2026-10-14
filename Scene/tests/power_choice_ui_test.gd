extends Node

const HeroScript = preload("res://Scene/units/hero.gd")
const LevelUpPanelScript = preload("res://Scene/level_up_panel.gd")


func _ready() -> void:
	var hero: Node2D = HeroScript.new()
	hero.character_class = "Guerreiro"
	hero.character_name = "Teste"
	add_child(hero)
	var panel: CanvasLayer = LevelUpPanelScript.new()
	add_child(panel)
	panel.open_for_hero(hero, 2)
	assert(panel.power_options.size() == 2)
	assert(panel.power_choice_cards.size() == 2)
	var alternate_id: String = str(panel.power_options[1]["id"])
	panel.select_new_power(alternate_id)
	assert(panel.selected_power_id == alternate_id)
	assert(panel.power_choice_buttons[alternate_id].text.contains("escolhido"))
	print("Power choice UI test passed")
	get_tree().quit(0)
