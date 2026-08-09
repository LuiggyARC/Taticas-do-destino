extends Control

const AUTOSAVE_PATH := "user://autosave.json"
const MANUAL_SAVE_DIR := "user://manual_saves/"
const SETTINGS_PATH := "user://settings.json"
const SFX_BUS_NAME := "SFX"

@onready var start_button: Button = $"PanelContainer/MenuContainer/Start BT"
@onready var continue_button: Button = $"PanelContainer/MenuContainer/Continue BT"
@onready var settings_button: Button = $"PanelContainer/MenuContainer/Config BT"
@onready var quit_button: Button = $"PanelContainer/MenuContainer/Sair BT"

var load_popup: PopupPanel
var save_list_container: VBoxContainer
var settings_popup: PopupPanel
var credits_popup: AcceptDialog

var master_volume_slider: HSlider
var sfx_volume_slider: HSlider
var language_option: OptionButton

var settings_data := {
	"master_volume": 100.0,
	"sfx_volume": 100.0,
	"language": "pt"
}

func _ready():
	start_button.pressed.connect(start_game)
	continue_button.pressed.connect(open_load_save_menu)
	settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit_game)
	
	create_load_popup()
	create_settings_popup()
	load_settings()
	apply_settings()
	update_continue_button()
	update_menu_language()

func start_game():
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	get_tree().change_scene_to_file("res://Scene/character_creation.tscn")

func update_continue_button():
	var save_exists := has_any_save()
	continue_button.disabled = not save_exists
	print("Existe save? ", save_exists)

func has_any_save() -> bool:
	if FileAccess.file_exists(AUTOSAVE_PATH):
		print("Autosave encontrado.")
		return true
	
	var dir := DirAccess.open(MANUAL_SAVE_DIR)
	
	if dir == null:
		print("Pasta de saves manuais não encontrada ou vazia.")
		return false
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			print("Save manual encontrado: ", file_name)
			dir.list_dir_end()
			return true
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	print("Nenhum save encontrado.")
	return false

func create_load_popup():
	load_popup = PopupPanel.new()
	load_popup.name = "LoadSavePopup"
	load_popup.size = Vector2(520, 500)
	add_child(load_popup)
	
	var main_container := VBoxContainer.new()
	main_container.name = "LoadSaveContainer"
	main_container.position = Vector2(20, 20)
	main_container.size = Vector2(480, 460)
	load_popup.add_child(main_container)
	
	var title := Label.new()
	title.text = "Escolha um save para carregar"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(480, 40)
	main_container.add_child(title)
	
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(480, 340)
	main_container.add_child(scroll)
	
	save_list_container = VBoxContainer.new()
	save_list_container.name = "SaveListContainer"
	save_list_container.custom_minimum_size = Vector2(460, 330)
	scroll.add_child(save_list_container)
	
	var close_button := Button.new()
	close_button.text = "Voltar"
	close_button.custom_minimum_size = Vector2(480, 45)
	close_button.pressed.connect(close_load_save_menu)
	main_container.add_child(close_button)

func open_load_save_menu():
	refresh_save_list()
	load_popup.popup_centered()

func close_load_save_menu():
	load_popup.hide()

func refresh_save_list():
	for child in save_list_container.get_children():
		child.queue_free()
	
	var found_save := false
	
	if FileAccess.file_exists(AUTOSAVE_PATH):
		found_save = true
		create_save_button(AUTOSAVE_PATH, "AutoSave")
	
	var dir := DirAccess.open(MANUAL_SAVE_DIR)
	
	if dir != null:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json"):
				found_save = true
				var save_path := MANUAL_SAVE_DIR + file_name
				create_save_button(save_path, "Save Manual")
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	if not found_save:
		create_no_save_label()

func create_no_save_label():
	var label := Label.new()
	label.text = "Nenhum save encontrado."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(460, 50)
	save_list_container.add_child(label)

func create_save_button(save_path: String, save_type: String):
	var button := Button.new()
	button.text = get_save_display_text(save_path, save_type)
	button.custom_minimum_size = Vector2(460, 55)
	button.pressed.connect(load_selected_save.bind(save_path))
	save_list_container.add_child(button)

func get_save_display_text(save_path: String, save_type: String) -> String:
	var save_data := read_save_data(save_path)
	
	if save_data.is_empty():
		return save_type + " - arquivo inválido"
	
	var stage := int(save_data.get("current_stage", 1))
	
	if save_type == "AutoSave":
		return "AutoSave - Stage " + str(stage)
	
	var file_name := save_path.get_file()
	return "Manual - Stage " + str(stage) + " - " + file_name

func read_save_data(save_path: String) -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {}
	
	var file := FileAccess.open(save_path, FileAccess.READ)
	
	if file == null:
		return {}
	
	var json_text := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_text)
	
	if error != OK:
		return {}
	
	if typeof(json.data) != TYPE_DICTIONARY:
		return {}
	
	return json.data

func load_selected_save(save_path: String):
	GameState.should_load_save = true
	GameState.selected_save_path = save_path
	get_tree().change_scene_to_file("res://Scene/main.tscn")

func open_settings():
	update_settings_ui()
	settings_popup.popup_centered()

func close_settings():
	save_settings()
	settings_popup.hide()
func quit_game():
	get_tree().quit()
func create_settings_popup():
	settings_popup = PopupPanel.new()
	settings_popup.name = "SettingsPopup"
	settings_popup.size = Vector2(520, 520)
	add_child(settings_popup)
	
	var main_container := VBoxContainer.new()
	main_container.name = "SettingsContainer"
	main_container.position = Vector2(20, 20)
	main_container.size = Vector2(480, 480)
	settings_popup.add_child(main_container)
	
	var title := Label.new()
	title.name = "SettingsTitle"
	title.text = "Configurações"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(480, 40)
	main_container.add_child(title)
	
	var master_label := Label.new()
	master_label.name = "MasterVolumeLabel"
	master_label.text = "Volume do jogo"
	master_label.custom_minimum_size = Vector2(480, 30)
	main_container.add_child(master_label)
	
	master_volume_slider = HSlider.new()
	master_volume_slider.name = "MasterVolumeSlider"
	master_volume_slider.min_value = 0
	master_volume_slider.max_value = 100
	master_volume_slider.step = 1
	master_volume_slider.value = settings_data["master_volume"]
	master_volume_slider.custom_minimum_size = Vector2(480, 40)
	master_volume_slider.value_changed.connect(on_master_volume_changed)
	main_container.add_child(master_volume_slider)
	
	var sfx_label := Label.new()
	sfx_label.name = "SFXVolumeLabel"
	sfx_label.text = "Volume dos efeitos"
	sfx_label.custom_minimum_size = Vector2(480, 30)
	main_container.add_child(sfx_label)
	
	sfx_volume_slider = HSlider.new()
	sfx_volume_slider.name = "SFXVolumeSlider"
	sfx_volume_slider.min_value = 0
	sfx_volume_slider.max_value = 100
	sfx_volume_slider.step = 1
	sfx_volume_slider.value = settings_data["sfx_volume"]
	sfx_volume_slider.custom_minimum_size = Vector2(480, 40)
	sfx_volume_slider.value_changed.connect(on_sfx_volume_changed)
	main_container.add_child(sfx_volume_slider)
	
	var language_label := Label.new()
	language_label.name = "LanguageLabel"
	language_label.text = "Idioma"
	language_label.custom_minimum_size = Vector2(480, 30)
	main_container.add_child(language_label)
	
	language_option = OptionButton.new()
	language_option.name = "LanguageOption"
	language_option.custom_minimum_size = Vector2(480, 40)
	language_option.add_item("Português", 0)
	language_option.add_item("English", 1)
	language_option.item_selected.connect(on_language_selected)
	main_container.add_child(language_option)
	
	var credits_button := Button.new()
	credits_button.name = "CreditsButton"
	credits_button.text = "Créditos"
	credits_button.custom_minimum_size = Vector2(480, 45)
	credits_button.pressed.connect(open_credits)
	main_container.add_child(credits_button)
	
	var save_button := Button.new()
	save_button.name = "SaveSettingsButton"
	save_button.text = "Salvar Configurações"
	save_button.custom_minimum_size = Vector2(480, 45)
	save_button.pressed.connect(save_settings)
	main_container.add_child(save_button)
	
	var close_button := Button.new()
	close_button.name = "CloseSettingsButton"
	close_button.text = "Voltar"
	close_button.custom_minimum_size = Vector2(480, 45)
	close_button.pressed.connect(close_settings)
	main_container.add_child(close_button)
	
	create_credits_popup()
func create_credits_popup():
	credits_popup = AcceptDialog.new()
	credits_popup.name = "CreditsPopup"
	credits_popup.title = "Créditos"
	credits_popup.dialog_text = (
		"Táticas do Destino\n\n" +
		"Desenvolvimento: Luiggy Alberto\n" +
		"Engine: Godot 4.6\n" +
		"Gênero: RPG tático por turnos\n\n" +
		"Projeto em desenvolvimento."
	)
	credits_popup.size = Vector2(480, 300)
	add_child(credits_popup)

func open_credits():
	credits_popup.popup_centered()
func on_master_volume_changed(value: float):
	settings_data["master_volume"] = value
	apply_master_volume(value)

func on_sfx_volume_changed(value: float):
	settings_data["sfx_volume"] = value
	apply_sfx_volume(value)

func apply_master_volume(value: float):
	var bus_index := AudioServer.get_bus_index("Master")
	
	if bus_index == -1:
		return
	
	AudioServer.set_bus_volume_db(bus_index, volume_percent_to_db(value))

func apply_sfx_volume(value: float):
	var bus_index := get_or_create_audio_bus(SFX_BUS_NAME)
	AudioServer.set_bus_volume_db(bus_index, volume_percent_to_db(value))

func volume_percent_to_db(value: float) -> float:
	if value <= 0:
		return -80.0
	
	return linear_to_db(value / 100.0)

func get_or_create_audio_bus(bus_name: String) -> int:
	var bus_index := AudioServer.get_bus_index(bus_name)
	
	if bus_index != -1:
		return bus_index
	
	AudioServer.add_bus(AudioServer.get_bus_count())
	bus_index = AudioServer.get_bus_count() - 1
	AudioServer.set_bus_name(bus_index, bus_name)
	
	return bus_index
func on_language_selected(index: int):
	if index == 0:
		settings_data["language"] = "pt"
	else:
		settings_data["language"] = "en"
	
	update_menu_language()

func update_menu_language():
	var language := str(settings_data.get("language", "pt"))
	
	if language == "pt":
		start_button.text = "Iniciar"
		continue_button.text = "Continuar"
		settings_button.text = "Configurações"
		quit_button.text = "Sair"
	else:
		start_button.text = "Start"
		continue_button.text = "Continue"
		settings_button.text = "Settings"
		quit_button.text = "Quit"
func save_settings():
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	
	if file == null:
		print("Erro ao salvar configurações.")
		return
	
	file.store_string(JSON.stringify(settings_data))
	file.close()
	
	print("Configurações salvas.")

func load_settings():
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	
	if file == null:
		return
	
	var json_text := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_text)
	
	if error != OK:
		print("Erro ao carregar configurações.")
		return
	
	if typeof(json.data) != TYPE_DICTIONARY:
		return
	
	settings_data["master_volume"] = float(json.data.get("master_volume", 100.0))
	settings_data["sfx_volume"] = float(json.data.get("sfx_volume", 100.0))
	settings_data["language"] = str(json.data.get("language", "pt"))

func apply_settings():
	apply_master_volume(float(settings_data.get("master_volume", 100.0)))
	apply_sfx_volume(float(settings_data.get("sfx_volume", 100.0)))

func update_settings_ui():
	if master_volume_slider:
		master_volume_slider.value = float(settings_data.get("master_volume", 100.0))
	
	if sfx_volume_slider:
		sfx_volume_slider.value = float(settings_data.get("sfx_volume", 100.0))
	
	if language_option:
		var language := str(settings_data.get("language", "pt"))
		
		if language == "pt":
			language_option.select(0)
		else:
			language_option.select(1)
