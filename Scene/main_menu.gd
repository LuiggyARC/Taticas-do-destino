extends Control

const AUTOSAVE_PATH := "user://autosave.json"
const MANUAL_SAVE_DIR := "user://manual_saves/"

@onready var start_button: Button = $"PanelContainer/MenuContainer/Start BT"
@onready var continue_button: Button = $"PanelContainer/MenuContainer/Continue BT"
@onready var settings_button: Button = $"PanelContainer/MenuContainer/Config BT"
@onready var quit_button: Button = $"PanelContainer/MenuContainer/Sair BT"

var load_popup: PopupPanel
var save_list_container: VBoxContainer

func _ready():
	start_button.pressed.connect(start_game)
	continue_button.pressed.connect(open_load_save_menu)
	settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit_game)
	
	create_load_popup()
	update_continue_button()

func start_game():
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	get_tree().change_scene_to_file("res://Scene/main.tscn")

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
	print("Configurações ainda não implementado.")

func quit_game():
	get_tree().quit()
