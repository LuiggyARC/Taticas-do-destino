extends Control
const MENU_BACKGROUND_PATH := "res://Assets/UI/Menu/menu_background.jpeg"

const BTN_NEW_GAME := "res://Assets/UI/Menu/btn_novo_jogo.png"
const BTN_NEW_GAME_HOVER := "res://Assets/UI/Menu/btn_novo_jogo_hover.png"
const BTN_NEW_GAME_PRESSED := "res://Assets/UI/Menu/btn_novo_jogo_pressed.png"
const BTN_CONTINUE := "res://Assets/UI/Menu/btn_continuar.png"
const BTN_CONTINUE_HOVER := "res://Assets/UI/Menu/btn_continuar_hover.png"
const BTN_CONTINUE_PRESSED := "res://Assets/UI/Menu/btn_continuar_pressed.png"

const BTN_OPTIONS := "res://Assets/UI/Menu/btn_opcoes.png"
const BTN_OPTIONS_HOVER := "res://Assets/UI/Menu/btn_opcoes_hover.png"
const BTN_OPTIONS_PRESSED := "res://Assets/UI/Menu/btn_opcoes_pressed.png"

const BTN_EXIT := "res://Assets/UI/Menu/btn_sair.png"
const BTN_EXIT_HOVER := "res://Assets/UI/Menu/btn_sair_hover.png"
const BTN_EXIT_PRESSED := "res://Assets/UI/Menu/btn_sair_pressed.png"

const AUTOSAVE_PATH := "user://autosave.json"
const MANUAL_SAVE_DIR := "user://manual_saves/"
const MANUAL_SAVE_SLOT_COUNT: int = 4
const SETTINGS_PATH := "user://settings.json"
const SFX_BUS_NAME := "Sfx"

var start_button: Button
var continue_button: Button
var settings_button: Button
var quit_button: Button

var attack_roll_box_check: CheckButton
var menu_fade_overlay: ColorRect
var load_popup: PopupPanel
var save_list_container: VBoxContainer
var settings_popup: PopupPanel
var credits_popup: AcceptDialog

var master_volume_slider: HSlider
var music_volume_slider: HSlider
var sfx_volume_slider: HSlider
var music_volume_label: Label
var sfx_volume_label: Label
var language_option: OptionButton
var language: String = "pt"

var delete_save_confirmation: ConfirmationDialog
var pending_delete_save_path: String = ""

var settings_data := {
	"master_volume": 100.0,
	"music_volume": 70.0,
	"sfx_volume": 110.0,
	"language": "pt",
	"show_attack_roll_box": true
}

func _ready():
	clear_old_menu_ui()
	create_background()
	create_menu_buttons()
	create_menu_fade_in()
	
	create_load_popup()
	create_settings_popup()
	create_attack_roll_box_option()
	
	load_settings()
	apply_settings()
	update_continue_button()
	update_menu_language()
	
func start_game():
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	SceneTransition.change_scene_to_file("res://Scene/Character_Creation.tscn")

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
	load_popup.size = Vector2(560, 560)
	load_popup.add_theme_stylebox_override("panel", create_popup_panel_style())
	add_child(load_popup)
	
	var main_container := VBoxContainer.new()
	main_container.name = "LoadSaveContainer"
	main_container.position = Vector2(24, 24)
	main_container.size = Vector2(512, 512)
	main_container.add_theme_constant_override("separation", 12)
	load_popup.add_child(main_container)
	
	var title := Label.new()
	title.text = "Continuar Jornada"
	title.custom_minimum_size = Vector2(512, 42)
	apply_popup_label_title_style(title, 28)
	main_container.add_child(title)
	
	var subtitle := Label.new()
	subtitle.text = "Escolha um save para retornar à aventura."
	subtitle.custom_minimum_size = Vector2(512, 28)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	apply_popup_normal_label_style(subtitle, 16)
	main_container.add_child(subtitle)
	
	var separator := HSeparator.new()
	main_container.add_child(separator)
	
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(512, 350)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_container.add_child(scroll)
	
	save_list_container = VBoxContainer.new()
	save_list_container.name = "SaveListContainer"
	save_list_container.custom_minimum_size = Vector2(490, 340)
	save_list_container.add_theme_constant_override("separation", 8)
	scroll.add_child(save_list_container)
	
	var separator_2 := HSeparator.new()
	main_container.add_child(separator_2)
	
	var close_button := Button.new()
	close_button.text = "Voltar"
	close_button.custom_minimum_size = Vector2(512, 48)
	close_button.pressed.connect(close_load_save_menu)
	apply_popup_button_style(close_button, false)
	main_container.add_child(close_button)
	
	if has_method("apply_button_sfx"):
		apply_button_sfx(close_button)

func open_load_save_menu():
	refresh_save_list()
	load_popup.popup_centered()


func close_load_save_menu():
	if load_popup != null:
		load_popup.hide()


func open_settings():
	update_settings_ui()
	settings_popup.popup_centered()


func close_settings():
	save_settings()
	settings_popup.hide()

func refresh_save_list():
	for child in save_list_container.get_children():
		child.queue_free()
	
	var found_save := false
	
	if FileAccess.file_exists(AUTOSAVE_PATH):
		found_save = true
		create_save_button(AUTOSAVE_PATH, "AutoSave")
	var fixed_slot_files: Array[String] = []
	for slot_number in range(1, MANUAL_SAVE_SLOT_COUNT + 1):
		var file_name: String = "slot_%d.json" % slot_number
		fixed_slot_files.append(file_name)
		var save_path: String = MANUAL_SAVE_DIR + file_name
		if FileAccess.file_exists(save_path):
			found_save = true
			create_save_button(save_path, "Slot %d" % slot_number)
	
	var dir := DirAccess.open(MANUAL_SAVE_DIR)
	
	if dir != null:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json") and not fixed_slot_files.has(file_name):
				found_save = true
				var save_path := MANUAL_SAVE_DIR + file_name
				create_save_button(save_path, "Save antigo")
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	if not found_save:
		create_no_save_label()

func create_no_save_label():
	var label := Label.new()
	label.text = "Nenhum save encontrado."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(490, 80)
	apply_popup_normal_label_style(label, 18)
	save_list_container.add_child(label)

func get_save_display_text(save_path: String, save_type: String) -> String:
	var save_data := read_save_data(save_path)
	
	if save_data.is_empty():
		return save_type + "\nArquivo inválido"
	
	var stage: int = int(save_data.get("current_stage", 1))
	var player_presets: Dictionary = save_data.get("player_presets", {})
	
	var player_name: String = str(player_presets.get("player_name", "Herói"))
	var player_class: String = str(player_presets.get("player_class", "Classe desconhecida"))
	var player_race: String = str(player_presets.get("player_race", "Raça desconhecida"))
	
	if save_type == "AutoSave":
		return "AutoSave\n" + player_name + " — " + player_race + " " + player_class + " | Cenário " + str(stage)
	if save_type.begins_with("Slot "):
		return save_type + "\n" + player_name + " — " + player_race + " " + player_class + " | Cenário " + str(stage) + "\n" + str(save_data.get("saved_at", ""))
	
	var file_name: String = save_path.get_file()
	return save_type + "\n" + player_name + " — " + player_race + " " + player_class + " | Cenário " + str(stage) + "\n" + file_name

func read_save_data(save_path: String) -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {}
	
	var file := FileAccess.open(save_path, FileAccess.READ)
	
	if file == null:
		return {}
	
	var json_text: String = file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var result := json.parse(json_text)
	
	if result != OK:
		return {}
	
	if typeof(json.data) != TYPE_DICTIONARY:
		return {}
	
	return json.data

func load_selected_save(
	save_path: String
):
	var save_data: Dictionary = (
		read_save_data(save_path)
	)
	
	if save_data.is_empty():
		push_warning(
			"Não foi possível carregar o save selecionado."
		)
		
		return
	var active_path: String = save_path
	if save_path != AUTOSAVE_PATH:
		# Carregar um slot cria uma cópia de trabalho no autosave.
		# O slot original só muda com confirmação no menu Salvar.
		var autosave_data: Dictionary = save_data.duplicate(true)
		autosave_data["save_type"] = "autosave"
		if not SaveManager.write_save_data(AUTOSAVE_PATH, autosave_data):
			push_warning("Não foi possível preparar o autosave para continuar.")
			return
		active_path = AUTOSAVE_PATH
	
	GameState.should_load_save = true
	GameState.selected_save_path = active_path
	
	GameState.current_location = str(
		save_data.get(
			"current_location",
			"battle"
		)
	)
	
	SceneTransition.change_scene_to_file(
		"res://Scene/main.tscn"
	)


func quit_game():
	get_tree().quit()
func create_settings_popup():
	settings_popup = PopupPanel.new()
	settings_popup.name = "SettingsPopup"
	settings_popup.size = Vector2(560, 680)
	settings_popup.add_theme_stylebox_override("panel", create_popup_panel_style())
	add_child(settings_popup)
	
	var main_container := VBoxContainer.new()
	main_container.name = "SettingsContainer"
	main_container.position = Vector2(24, 24)
	main_container.size = Vector2(512, 632)
	main_container.add_theme_constant_override("separation", 14)
	settings_popup.add_child(main_container)
	
	var title := Label.new()
	title.name = "SettingsTitle"
	title.text = "Opções"
	title.custom_minimum_size = Vector2(512, 42)
	apply_popup_label_title_style(title, 28)
	main_container.add_child(title)
	
	var subtitle := Label.new()
	subtitle.text = "Ajuste áudio, idioma e preferências do jogo."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.custom_minimum_size = Vector2(512, 32)
	apply_popup_normal_label_style(subtitle, 16)
	main_container.add_child(subtitle)
	
	var separator := HSeparator.new()
	main_container.add_child(separator)
	
	var master_label := Label.new()
	master_label.name = "MasterVolumeLabel"
	master_label.text = "Volume do jogo"
	master_label.custom_minimum_size = Vector2(512, 28)
	apply_popup_normal_label_style(master_label, 18)
	main_container.add_child(master_label)
	
	master_volume_slider = HSlider.new()
	master_volume_slider.name = "MasterVolumeSlider"
	master_volume_slider.min_value = 0
	master_volume_slider.max_value = 100
	master_volume_slider.step = 1
	master_volume_slider.value = settings_data["master_volume"]
	apply_popup_slider_style(master_volume_slider)
	master_volume_slider.value_changed.connect(on_master_volume_changed)
	main_container.add_child(master_volume_slider)

	music_volume_label = Label.new()
	music_volume_label.name = "MusicVolumeLabel"
	music_volume_label.text = "Volume da música: 70%"
	music_volume_label.custom_minimum_size = Vector2(512, 28)
	apply_popup_normal_label_style(music_volume_label, 18)
	main_container.add_child(music_volume_label)

	music_volume_slider = HSlider.new()
	music_volume_slider.name = "MusicVolumeSlider"
	music_volume_slider.min_value = 0
	music_volume_slider.max_value = 100
	music_volume_slider.step = 1
	music_volume_slider.value = settings_data["music_volume"]
	apply_popup_slider_style(music_volume_slider)
	music_volume_slider.value_changed.connect(on_music_volume_changed)
	main_container.add_child(music_volume_slider)
	
	sfx_volume_label = Label.new()
	sfx_volume_label.name = "SfxVolumeLabel"
	sfx_volume_label.text = "Volume dos efeitos: 110%"
	sfx_volume_label.custom_minimum_size = Vector2(512, 28)
	apply_popup_normal_label_style(sfx_volume_label, 18)
	main_container.add_child(sfx_volume_label)
	
	sfx_volume_slider = HSlider.new()
	sfx_volume_slider.name = "SfxVolumeSlider"
	sfx_volume_slider.min_value = 0
	sfx_volume_slider.max_value = 110
	sfx_volume_slider.step = 1
	sfx_volume_slider.value = settings_data["sfx_volume"]
	apply_popup_slider_style(sfx_volume_slider)
	sfx_volume_slider.value_changed.connect(on_sfx_volume_changed)
	main_container.add_child(sfx_volume_slider)
	
	var language_label := Label.new()
	language_label.name = "LanguageLabel"
	language_label.text = "Idioma"
	language_label.custom_minimum_size = Vector2(512, 28)
	apply_popup_normal_label_style(language_label, 18)
	main_container.add_child(language_label)
	
	language_option = OptionButton.new()
	language_option.name = "LanguageOption"
	language_option.custom_minimum_size = Vector2(512, 46)
	language_option.add_item("Português")
	language_option.add_item("English")
	
	if language == "en":
		language_option.select(1)
	else:
		language_option.select(0)
	
	language_option.item_selected.connect(on_language_selected)
	main_container.add_child(language_option)
	
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(512, 20)
	main_container.add_child(spacer)
	
	var buttons_row := HBoxContainer.new()
	buttons_row.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons_row.add_theme_constant_override("separation", 14)
	main_container.add_child(buttons_row)
	
	var close_button := Button.new()
	close_button.text = "Salvar e Voltar"
	close_button.custom_minimum_size = Vector2(240, 50)
	close_button.pressed.connect(close_settings)
	apply_popup_button_style(close_button, true)
	buttons_row.add_child(close_button)
	
	var cancel_button := Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.custom_minimum_size = Vector2(180, 50)
	cancel_button.pressed.connect(settings_popup.hide)
	apply_popup_button_style(cancel_button, false)
	buttons_row.add_child(cancel_button)
	
	if has_method("apply_button_sfx"):
		apply_button_sfx(close_button)
		apply_button_sfx(cancel_button)
	
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

func on_music_volume_changed(value: float):
	settings_data["music_volume"] = value
	if is_instance_valid(music_volume_label):
		music_volume_label.text = "Volume da música: %d%%" % int(value)
	apply_music_volume(value)

func on_sfx_volume_changed(value: float):
	settings_data["sfx_volume"] = value
	if is_instance_valid(sfx_volume_label):
		sfx_volume_label.text = "Volume dos efeitos: %d%%" % int(value)
	apply_sfx_volume(value)

func apply_master_volume(value: float):
	var bus_index := AudioServer.get_bus_index("Master")
	
	if bus_index == -1:
		return
	
	AudioServer.set_bus_volume_db(bus_index, volume_percent_to_db(value))

func apply_sfx_volume(value: float):
	var bus_index := get_or_create_audio_bus(SFX_BUS_NAME)
	AudioServer.set_bus_volume_db(bus_index, volume_percent_to_db(value))

func apply_music_volume(value: float):
	MusicManage.set_music_volume_percent(value)

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
	AudioServer.set_bus_send(bus_index, "Master")
	
	return bus_index
func on_language_selected(index: int):
	if index == 0:
		settings_data["language"] = "pt"
	else:
		settings_data["language"] = "en"
	
	update_menu_language()

func update_menu_language():
	if start_button == null:
		return
	
	if continue_button == null:
		return
	
	if settings_button == null:
		return
	
	if quit_button == null:
		return
	
	if language == "pt":
		start_button.text = "NOVO JOGO"
		continue_button.text = "CONTINUAR"
		settings_button.text = "OPÇÕES"
		quit_button.text = "SAIR"
	else:
		start_button.text = "NEW GAME"
		continue_button.text = "CONTINUE"
		settings_button.text = "OPTIONS"
		quit_button.text = "EXIT"
	
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
		GameState.show_attack_roll_box = true
		return
	
	var file := FileAccess.open(
		SETTINGS_PATH,
		FileAccess.READ
	)
	
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
	
	settings_data["master_volume"] = float(
		json.data.get(
			"master_volume",
			100.0
		)
	)
	settings_data["music_volume"] = float(json.data.get("music_volume", 70.0))
	
	var old_sfx_volume: float = float(json.data.get("sfx_volume", 110.0))
	if not json.data.has("music_volume") and is_equal_approx(old_sfx_volume, 100.0):
		old_sfx_volume = 110.0
	settings_data["sfx_volume"] = old_sfx_volume
	
	settings_data["language"] = str(
		json.data.get(
			"language",
			"pt"
		)
	)
	
	settings_data["show_attack_roll_box"] = bool(
		json.data.get(
			"show_attack_roll_box",
			true
		)
	)
	
	GameState.show_attack_roll_box = bool(
		settings_data["show_attack_roll_box"]
	)

func apply_settings():
	apply_master_volume(
		float(
			settings_data.get(
				"master_volume",
				100.0
			)
		)
	)
	apply_music_volume(float(settings_data.get("music_volume", 70.0)))
	
	apply_sfx_volume(
		float(
			settings_data.get(
				"sfx_volume",
				110.0
			)
		)
	)
	
	GameState.show_attack_roll_box = bool(
		settings_data.get(
			"show_attack_roll_box",
			true
		)
	)

func update_settings_ui():
	if master_volume_slider != null:
		master_volume_slider.value = (
			settings_data["master_volume"]
		)
	if music_volume_slider != null:
		music_volume_slider.value = settings_data["music_volume"]
	if is_instance_valid(music_volume_label):
		music_volume_label.text = "Volume da música: %d%%" % int(settings_data["music_volume"])
	
	if sfx_volume_slider != null:
		sfx_volume_slider.value = (
			settings_data["sfx_volume"]
		)
	if is_instance_valid(sfx_volume_label):
		sfx_volume_label.text = "Volume dos efeitos: %d%%" % int(settings_data["sfx_volume"])
	
	if language_option != null:
		if language == "en":
			language_option.select(1)
		else:
			language_option.select(0)
	
	if is_instance_valid(attack_roll_box_check):
		attack_roll_box_check.button_pressed = bool(
			settings_data.get(
				"show_attack_roll_box",
				true
			)
		)
		
		if language == "en":
			attack_roll_box_check.text = (
				"Show attack calculations"
			)
		else:
			attack_roll_box_check.text = (
				"Mostrar cálculo dos ataques"
			)

func setup_menu_button(button: Button, text: String):
	button.text = text
	button.custom_minimum_size = Vector2(280, 56)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
func create_background():
	var background := TextureRect.new()
	background.name = "MenuBackground"
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.offset_left = 0
	background.offset_top = 0
	background.offset_right = 0
	background.offset_bottom = 10
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var bg_texture = load(MENU_BACKGROUND_PATH)
	
	if bg_texture != null:
		background.texture = bg_texture
	else:
		print("Imagem de fundo do menu não encontrada: ", MENU_BACKGROUND_PATH)
	
	add_child(background)
	move_child(background, 0)

func create_texture_menu_button(
	normal_path: String,
	hover_path: String,
	pressed_path: String,
	button_size: Vector2
) -> TextureButton:
	var button := TextureButton.new()
	button.custom_minimum_size = button_size
	button.size = button_size
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.focus_mode = Control.FOCUS_NONE
	
	var normal_texture = load(normal_path)
	var hover_texture = load(hover_path)
	var pressed_texture = load(pressed_path)
	
	if normal_texture != null:
		button.texture_normal = normal_texture
	else:
		print("Imagem normal do botão não encontrada: ", normal_path)
	
	if hover_texture != null:
		button.texture_hover = hover_texture
	
	if pressed_texture != null:
		button.texture_pressed = pressed_texture
	
	return button

func create_menu_buttons():
	var buttons_layer := Control.new()
	buttons_layer.name = "MenuButtonsLayer"
	buttons_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	buttons_layer.offset_left = 0
	buttons_layer.offset_top = 0
	buttons_layer.offset_right = 0
	buttons_layer.offset_bottom = 0
	add_child(buttons_layer)
	
	var center := CenterContainer.new()
	center.name = "MenuButtonsCenter"
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.offset_left = 0
	center.offset_top = 0
	center.offset_right = 0
	center.offset_bottom = 0
	buttons_layer.add_child(center)
	
	var menu_box := VBoxContainer.new()
	menu_box.name = "MenuButtonsBox"
	menu_box.custom_minimum_size = Vector2(360, 310)
	menu_box.alignment = BoxContainer.ALIGNMENT_CENTER
	menu_box.add_theme_constant_override("separation", 4)
	center.add_child(menu_box)
	
	var top_spacer := Control.new()
	top_spacer.custom_minimum_size = Vector2(0, 170)
	menu_box.add_child(top_spacer)
	
	var button_size := Vector2(360, 72)
	
	start_button = create_styled_menu_button("NOVO JOGO", button_size)
	continue_button = create_styled_menu_button("CONTINUAR", button_size)
	settings_button = create_styled_menu_button("OPÇÕES", button_size)
	quit_button = create_styled_menu_button("SAIR", button_size)
	
	menu_box.add_child(start_button)
	menu_box.add_child(continue_button)
	menu_box.add_child(settings_button)
	menu_box.add_child(quit_button)
	
	start_button.pressed.connect(start_game)
	continue_button.pressed.connect(open_load_save_menu)
	settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit_game)
	
	apply_button_sfx(start_button)
	apply_button_sfx(continue_button)
	apply_button_sfx(settings_button)
	apply_button_sfx(quit_button)

func clear_old_menu_ui():
	for child in get_children():
		child.queue_free()
func create_menu_fade_in():
	menu_fade_overlay = ColorRect.new()
	menu_fade_overlay.name = "MenuFadeOverlay"
	menu_fade_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_fade_overlay.offset_left = 0
	menu_fade_overlay.offset_top = 0
	menu_fade_overlay.offset_right = 0
	menu_fade_overlay.offset_bottom = 0
	menu_fade_overlay.color = Color(1, 1, 1, 1)
	menu_fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(menu_fade_overlay)
	
	var tween := create_tween()
	tween.tween_property(menu_fade_overlay, "color:a", 0.0, 0.75)
	tween.finished.connect(remove_menu_fade_overlay)
	
func remove_menu_fade_overlay():
	if menu_fade_overlay != null:
		menu_fade_overlay.queue_free()
func create_styled_menu_button(button_text: String, button_size: Vector2) -> Button:
	var button := Button.new()
	button.text = button_text
	button.custom_minimum_size = button_size
	button.size = button_size
	button.focus_mode = Control.FOCUS_NONE
	
	button.add_theme_font_size_override("font_size", 30)
	
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(0.10, 0.12, 0.12, 0.82)
	normal_style.border_color = Color(0.55, 0.42, 0.22, 1.0)
	normal_style.set_border_width_all(3)
	normal_style.set_corner_radius_all(18)
	normal_style.shadow_color = Color(0, 0, 0, 0.75)
	normal_style.shadow_size = 8
	
	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = Color(0.10, 0.22, 0.15, 0.92)
	hover_style.border_color = Color(0.20, 0.95, 0.45, 1.0)
	hover_style.set_border_width_all(3)
	hover_style.set_corner_radius_all(18)
	hover_style.shadow_color = Color(0.10, 0.95, 0.45, 0.75)
	hover_style.shadow_size = 16
	
	var pressed_style := StyleBoxFlat.new()
	pressed_style.bg_color = Color(0.05, 0.08, 0.06, 0.98)
	pressed_style.border_color = Color(0.05, 0.65, 0.30, 1.0)
	pressed_style.set_border_width_all(3)
	pressed_style.set_corner_radius_all(18)
	pressed_style.shadow_color = Color(0, 0, 0, 0.95)
	pressed_style.shadow_size = 4
	
	var disabled_style := StyleBoxFlat.new()
	disabled_style.bg_color = Color(0.08, 0.08, 0.08, 0.45)
	disabled_style.border_color = Color(0.25, 0.25, 0.25, 0.65)
	disabled_style.set_border_width_all(3)
	disabled_style.set_corner_radius_all(18)
	
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_stylebox_override("disabled", disabled_style)
	
	button.add_theme_color_override("font_color", Color(0.88, 0.78, 0.58, 1.0))
	button.add_theme_color_override("font_hover_color", Color(0.92, 1.0, 0.82, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(0.65, 1.0, 0.72, 1.0))
	button.add_theme_color_override("font_disabled_color", Color(0.45, 0.45, 0.45, 1.0))
	
	return button
	
func apply_button_sfx(button: BaseButton):
	button.mouse_entered.connect(UIAudioManager.play_hover)
	button.pressed.connect(UIAudioManager.play_click)
func create_popup_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.035, 0.03, 0.92)
	style.border_color = Color(0.76, 0.58, 0.24, 0.95)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	style.content_margin_left = 18
	style.content_margin_top = 18
	style.content_margin_right = 18
	style.content_margin_bottom = 18
	return style


func create_menu_popup_button_style(is_primary: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	
	if is_primary:
		style.bg_color = Color(0.12, 0.32, 0.18, 0.95)
		style.border_color = Color(0.82, 0.66, 0.28, 1.0)
	else:
		style.bg_color = Color(0.055, 0.085, 0.07, 0.95)
		style.border_color = Color(0.48, 0.38, 0.18, 0.95)
	
	style.set_border_width_all(2)
	style.corner_radius_top_left = 9
	style.corner_radius_top_right = 9
	style.corner_radius_bottom_left = 9
	style.corner_radius_bottom_right = 9
	style.content_margin_left = 12
	style.content_margin_top = 8
	style.content_margin_right = 12
	style.content_margin_bottom = 8
	return style


func create_menu_popup_button_hover_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.18, 0.42, 0.23, 0.98)
	style.border_color = Color(1.0, 0.78, 0.30, 1.0)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 9
	style.corner_radius_top_right = 9
	style.corner_radius_bottom_left = 9
	style.corner_radius_bottom_right = 9
	style.content_margin_left = 12
	style.content_margin_top = 8
	style.content_margin_right = 12
	style.content_margin_bottom = 8
	return style


func create_menu_popup_button_pressed_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.18, 0.09, 1.0)
	style.border_color = Color(0.95, 0.70, 0.20, 1.0)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 9
	style.corner_radius_top_right = 9
	style.corner_radius_bottom_left = 9
	style.corner_radius_bottom_right = 9
	style.content_margin_left = 12
	style.content_margin_top = 8
	style.content_margin_right = 12
	style.content_margin_bottom = 8
	return style


func apply_popup_button_style(button: Button, is_primary: bool = false):
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_stylebox_override("normal", create_menu_popup_button_style(is_primary))
	button.add_theme_stylebox_override("hover", create_menu_popup_button_hover_style())
	button.add_theme_stylebox_override("pressed", create_menu_popup_button_pressed_style())
	button.add_theme_color_override("font_color", Color(0.95, 0.92, 0.82))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.95, 0.70))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.84, 0.35))
	button.add_theme_font_size_override("font_size", 18)


func apply_popup_label_title_style(label: Label, font_size: int = 26):
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.48))


func apply_popup_normal_label_style(label: Label, font_size: int = 16):
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.90, 0.92, 0.86))


func apply_popup_slider_style(slider: HSlider):
	slider.custom_minimum_size = Vector2(430, 32)
func create_save_button(
	save_path: String,
	save_type: String
) -> void:
	if not is_instance_valid(save_list_container):
		return
	
	var row := HBoxContainer.new()
	row.add_theme_constant_override(
		"separation",
		8
	)
	
	var load_button := Button.new()
	load_button.text = get_save_display_text(
		save_path,
		save_type
	)
	load_button.custom_minimum_size = Vector2(
		390,
		72
	)
	load_button.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	load_button.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	load_button.pressed.connect(
		load_selected_save.bind(save_path)
	)
	apply_popup_button_style(
		load_button,
		true
	)
	row.add_child(load_button)
	
	var delete_button := Button.new()
	delete_button.text = "Apagar"
	delete_button.custom_minimum_size = Vector2(
		90,
		72
	)
	delete_button.pressed.connect(
		confirm_delete_save.bind(
			save_path,
			save_type
		)
	)
	apply_popup_button_style(
		delete_button,
		false
	)
	delete_button.add_theme_color_override(
		"font_color",
		Color(1.0, 0.55, 0.50)
	)
	row.add_child(delete_button)
	
	if has_method("apply_button_sfx"):
		apply_button_sfx(load_button)
		apply_button_sfx(delete_button)
	
	save_list_container.add_child(row)
func create_attack_roll_box_option():
	if not is_instance_valid(settings_popup):
		return
	
	var main_container := (
		settings_popup.get_node_or_null(
			"SettingsContainer"
		) as VBoxContainer
	)
	
	if not is_instance_valid(main_container):
		return
	
	attack_roll_box_check = CheckButton.new()
	attack_roll_box_check.name = "AttackRollBoxCheck"
	attack_roll_box_check.text = (
		"Mostrar cálculo dos ataques"
	)
	
	attack_roll_box_check.custom_minimum_size = Vector2(
		512,
		42
	)
	
	attack_roll_box_check.button_pressed = bool(
		settings_data.get(
			"show_attack_roll_box",
			true
		)
	)
	
	attack_roll_box_check.add_theme_font_size_override(
		"font_size",
		18
	)
	
	attack_roll_box_check.toggled.connect(
		on_attack_roll_box_toggled
	)
	
	main_container.add_child(
		attack_roll_box_check
	)
	
	if is_instance_valid(language_option):
		main_container.move_child(
			attack_roll_box_check,
			language_option.get_index() + 1
		)
	
	if has_method("apply_button_sfx"):
		apply_button_sfx(
			attack_roll_box_check
		)


func on_attack_roll_box_toggled(
	is_enabled: bool
):
	settings_data["show_attack_roll_box"] = (
		is_enabled
	)
	
	GameState.show_attack_roll_box = is_enabled
func is_allowed_save_path(
	save_path: String
) -> bool:
	var clean_path: String = (
		save_path.strip_edges()
	)
	
	if clean_path == AUTOSAVE_PATH:
		return true
	
	if not clean_path.begins_with(
		MANUAL_SAVE_DIR
	):
		return false
	
	var file_name: String = (
		clean_path.get_file()
	)
	
	return (
		file_name != ""
		and file_name.ends_with(".json")
		and clean_path
		== MANUAL_SAVE_DIR + file_name
	)


func confirm_delete_save(
	save_path: String,
	save_type: String
) -> void:
	if not is_allowed_save_path(save_path):
		push_warning(
			"Caminho de save não permitido."
		)
		return
	
	if not FileAccess.file_exists(save_path):
		refresh_save_list()
		update_continue_button()
		return
	
	pending_delete_save_path = save_path
	
	if not is_instance_valid(
		delete_save_confirmation
	):
		delete_save_confirmation = (
			ConfirmationDialog.new()
		)
		delete_save_confirmation.name = (
			"DeleteSaveConfirmation"
		)
		delete_save_confirmation.title = (
			"Apagar save"
		)
		delete_save_confirmation.ok_button_text = (
			"Apagar"
		)
		delete_save_confirmation.confirmed.connect(
			delete_selected_save
		)
		add_child(
			delete_save_confirmation
		)
	
	delete_save_confirmation.dialog_text = (
		"Apagar este save?\n\n"
		+ get_save_display_text(
			save_path,
			save_type
		)
		+ "\n\nEsta ação não pode ser desfeita."
	)
	delete_save_confirmation.popup_centered()


func delete_selected_save() -> void:
	var save_path: String = (
		pending_delete_save_path
	)
	pending_delete_save_path = ""
	
	if not is_allowed_save_path(save_path):
		push_warning(
			"Caminho de save não permitido."
		)
		return
	
	if not FileAccess.file_exists(save_path):
		refresh_save_list()
		update_continue_button()
		return
	
	var absolute_path: String = (
		ProjectSettings.globalize_path(
			save_path
		)
	)
	
	var delete_error: Error = (
		DirAccess.remove_absolute(
			absolute_path
		)
	)
	
	if delete_error != OK:
		push_warning(
			"Não foi possível apagar o save: "
			+ save_path
		)
		return
	
	if (
		GameState.selected_save_path
		== save_path
	):
		GameState.selected_save_path = ""
		GameState.should_load_save = false
	
	refresh_save_list()
	update_continue_button()
