extends Node

const CharacterCreationScript = preload("res://Scene/character_creation.gd")

const EXPECTED_PRIMARY_ATTRIBUTES := {
	"Bárbaro": "strength",
	"Bardo": "charisma",
	"Bruxo": "charisma",
	"Clérigo": "wisdom",
	"Druida": "wisdom",
	"Feiticeiro": "charisma",
	"Guerreiro": "constitution",
	"Ladino": "dexterity",
	"Mago": "intelligence",
	"Monge": "dexterity",
	"Paladino": "strength",
	"Ranger": "dexterity"
}


func _ready() -> void:
	var creation: Control = CharacterCreationScript.new()
	assert(creation.class_presets.size() == EXPECTED_PRIMARY_ATTRIBUTES.size())
	for character_class in EXPECTED_PRIMARY_ATTRIBUTES:
		assert(creation.class_presets.has(character_class))
		for _sample in range(20):
			creation.roll_initial_attributes_for_class(character_class)
			var primary: String = EXPECTED_PRIMARY_ATTRIBUTES[character_class]
			assert(creation.get_base_attribute_value(primary) == 18)
			var secondary_total: int = 0
			for attribute_key in creation.ATTRIBUTE_KEYS:
				if attribute_key == primary:
					continue
				var score: int = creation.get_base_attribute_value(attribute_key)
				assert(score >= 8 and score <= 16)
				secondary_total += score
			assert(secondary_total == 60)
	creation.selected_class = "Mago"
	creation.selected_race = "Humano"
	creation.selected_racial_bonus = "INT"
	creation.roll_initial_attributes_for_class("Mago")
	assert(int(creation.get_final_race_attributes()["intelligence"]) == 20)
	creation.free()

	var ui_creation: Control = CharacterCreationScript.new()
	add_child(ui_creation)
	assert(ui_creation.get_base_attribute_value("strength") == 18)
	assert(ui_creation.attribute_row_labels["strength"].keys().size() == 3)
	assert(ui_creation.attribute_help_label.text.contains("8 e 16"))
	var wizard_index: int = -1
	for index in ui_creation.class_option.item_count:
		if ui_creation.class_option.get_item_text(index) == "Mago":
			wizard_index = index
			break
	assert(wizard_index >= 0)
	ui_creation.class_option.select(wizard_index)
	ui_creation.on_class_selected(wizard_index)
	assert(ui_creation.get_base_attribute_value("intelligence") == 18)
	ui_creation.free()
	print("character_creation_attributes_test passed")
	get_tree().quit(0)
