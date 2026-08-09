extends Control

var name_input: LineEdit
var class_option: OptionButton
var stats_label: Label

var selected_class: String = "Guerreiro"

var class_presets := {
	"Guerreiro": {
		"hp": 120,
		"attack": 22,
		"movement": 9.0
	},
	"Arqueiro": {
		"hp": 90,
		"attack": 18,
		"movement": 10.5
	},
	"Mago": {
		"hp": 70,
		"attack": 30,
		"movement": 6.0
	}
}

func _ready():
	create_ui()
	update_stats_preview()

func create_ui():
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var panel := Panel.new()
	panel.name = "CharacterCreationPanel"
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(panel)
	
	var container := VBoxContainer.new()
	container.name = "CreationContainer"
	container.size = Vector2(420, 520)
	container.position = Vector2(302, 230)
	panel.add_child(container)
	
	var title := Label.new()
	title.text = "Criação de Personagem"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(420, 50)
	container.add_child(title)
	
	var name_label := Label.new()
	name_label.text = "Nome do personagem"
	name_label.custom_minimum_size = Vector2(420, 30)
	container.add_child(name_label)
	
	name_input = LineEdit.new()
	name_input.placeholder_text = "Digite o nome do herói"
	name_input.text = GameState.player_name
	name_input.custom_minimum_size = Vector2(420, 45)
	container.add_child(name_input)
	
	var class_label := Label.new()
	class_label.text = "Classe"
	class_label.custom_minimum_size = Vector2(420, 30)
	container.add_child(class_label)
	
	class_option = OptionButton.new()
	class_option.custom_minimum_size = Vector2(420, 45)
	class_option.add_item("Guerreiro", 0)
	class_option.add_item("Arqueiro", 1)
	class_option.add_item("Mago", 2)
	class_option.item_selected.connect(on_class_selected)
	container.add_child(class_option)
	
	stats_label = Label.new()
	stats_label.custom_minimum_size = Vector2(420, 130)
	container.add_child(stats_label)
	
	var confirm_button := Button.new()
	confirm_button.text = "Confirmar e iniciar"
	confirm_button.custom_minimum_size = Vector2(420, 45)
	confirm_button.pressed.connect(confirm_character)
	container.add_child(confirm_button)
	
	var back_button := Button.new()
	back_button.text = "Voltar"
	back_button.custom_minimum_size = Vector2(420, 45)
	back_button.pressed.connect(back_to_menu)
	container.add_child(back_button)

func on_class_selected(index: int):
	if index == 0:
		selected_class = "Guerreiro"
	elif index == 1:
		selected_class = "Arqueiro"
	elif index == 2:
		selected_class = "Mago"
	
	update_stats_preview()

func update_stats_preview():
	var preset = class_presets[selected_class]
	
	stats_label.text = (
		"Prévia da classe: " + selected_class + "\n\n" +
		"HP: " + str(preset["hp"]) + "\n" +
		"Ataque: " + str(preset["attack"]) + "\n" +
		"Movimento: " + str(preset["movement"]) + "m"
	)

func confirm_character():
	var chosen_name := name_input.text.strip_edges()
	
	if chosen_name == "":
		chosen_name = "Herói"
	GameState.hero_level = 1
	GameState.hero_total_xp = 0
	GameState.hero_xp_to_next_level = 1000
	GameState.hero_max_level = 20
	var preset = class_presets[selected_class]
	
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	GameState.selected_stage = 1
	
	GameState.player_name = chosen_name
	GameState.player_class = selected_class
	GameState.hero_max_hp = int(preset["hp"])
	GameState.hero_attack_power = int(preset["attack"])
	GameState.hero_max_movement_meters = float(preset["movement"])
	
	get_tree().change_scene_to_file("res://Scene/main.tscn")

func back_to_menu():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
