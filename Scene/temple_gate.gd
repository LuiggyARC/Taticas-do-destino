extends Control

const TempleGateDatabase = preload("res://Scene/temple_gate_database.gd")
const GATE_MAP_PATH := "res://Assets/Maps/Chegada ao templo.jpg"
const TEMPLE_MUSIC_PATH := "res://Assets/Audio/Moonlight_on_Empty_Wood.mp3"
const ARRIVAL_EVENT_ID := "temple_hashagur_arrival"
const MISSION_ID := "hashagur_temple"
const ESCAPE_MISSION_ID := "temple_escape_route"
const COURTYARD_MISSION_ID := "temple_courtyard_defense"

var objective_label: Label
var enter_button: Button
var dialogue_box: StoryDialogBox
var character_stage: Control
var party_portraits: Array[Control] = []
var portrait_nodes: Dictionary = {}
var hashagur_portrait: Control


func _ready() -> void:
	GameState.current_location = "temple_gate"
	if MissionManager.is_mission_active(COURTYARD_MISSION_ID):
		call_deferred("_start_courtyard_battle")
		return
	_build_background()
	_build_character_stage()
	_build_header()
	_play_temple_music()
	if MissionManager.is_mission_completed(ESCAPE_MISSION_ID):
		_show_after_battle()
		return
	if SaveManager.has_completed_story_event(ARRIVAL_EVENT_ID):
		_show_arrived_cast()
		_show_entrance()
	else:
		call_deferred("_play_arrival")


func _build_background() -> void:
	var background := TextureRect.new()
	background.name = "TempleApproach"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.texture = load(GATE_MAP_PATH) as Texture2D
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)


func _build_character_stage() -> void:
	character_stage = Control.new()
	character_stage.name = "TempleGateCharacters"
	character_stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(character_stage)
	character_stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var party_data: Array[Dictionary] = [
		{"id": "Kasum", "path": "res://Assets/Characters/Kasum.png"},
		{"id": "Aniri", "path": "res://Assets/Characters/AniriLadina.png"},
		{"id": "Uiliam", "path": "res://Assets/Characters/SrUiliam.png"},
		{"id": "Heroi", "path": str(GameState.player_portrait_path)}
	]
	for entry in party_data:
		var portrait: Control = _create_character_portrait(str(entry["id"]), str(entry["path"]))
		party_portraits.append(portrait)
		portrait_nodes[str(entry["id"])] = portrait
	hashagur_portrait = _create_character_portrait("Hashagur", "res://Assets/Characters/Hashagur.png")
	portrait_nodes["Hashagur"] = hashagur_portrait
	get_viewport().size_changed.connect(_layout_character_stage)
	_layout_character_stage()
	for portrait in party_portraits:
		portrait.visible = false
	hashagur_portrait.visible = false


func _create_character_portrait(character_id: String, image_path: String) -> Control:
	var texture: Texture2D = null
	if image_path.begins_with("res://") and ResourceLoader.exists(image_path):
		texture = load(image_path) as Texture2D
	elif image_path != "":
		var custom_image := Image.new()
		if custom_image.load(image_path) == OK:
			texture = ImageTexture.create_from_image(custom_image)
	var portrait: Control
	if texture != null:
		var image := TextureRect.new()
		image.texture = texture
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait = image
	else:
		var fallback := Label.new()
		fallback.text = str(GameState.player_name) if character_id == "Heroi" else character_id
		fallback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		fallback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		fallback.add_theme_font_size_override("font_size", 24)
		fallback.add_theme_color_override("font_color", Color(1.0, 0.88, 0.63))
		portrait = fallback
	portrait.name = "TempleParty_" + character_id
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	character_stage.add_child(portrait)
	return portrait


func _layout_character_stage() -> void:
	if not is_instance_valid(character_stage):
		return
	var viewport_size: Vector2 = get_viewport_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return
	var layouts: Dictionary = {
		"Kasum": Rect2(0.34, 0.44, 0.17, 0.27),
		"Aniri": Rect2(0.26, 0.38, 0.19, 0.33),
		"Uiliam": Rect2(0.11, 0.34, 0.25, 0.38),
		"Heroi": Rect2(0.02, 0.46, 0.20, 0.25),
		"Hashagur": Rect2(0.63, 0.34, 0.30, 0.38)
	}
	for character_id in layouts:
		var portrait: Control = portrait_nodes.get(character_id) as Control
		if not is_instance_valid(portrait):
			continue
		var layout: Rect2 = layouts[character_id]
		portrait.position = Vector2(layout.position.x * viewport_size.x, layout.position.y * viewport_size.y)
		portrait.size = Vector2(layout.size.x * viewport_size.x, layout.size.y * viewport_size.y)


func _show_arrived_cast() -> void:
	for portrait in party_portraits:
		portrait.visible = true
		portrait.modulate = Color.WHITE
	hashagur_portrait.visible = true
	hashagur_portrait.modulate = Color.WHITE


func _animate_party_arrival() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	for index in range(party_portraits.size()):
		var portrait: Control = party_portraits[index]
		var destination: Vector2 = portrait.position
		portrait.position.x -= 90.0
		portrait.modulate.a = 0.0
		portrait.visible = true
		tween.tween_property(portrait, "position", destination, 0.55).set_delay(float(index) * 0.12)
		tween.tween_property(portrait, "modulate:a", 1.0, 0.48).set_delay(float(index) * 0.12)
	await tween.finished
	await get_tree().create_timer(0.35).timeout


func _animate_hashagur_arrival() -> void:
	var destination: Vector2 = hashagur_portrait.position
	hashagur_portrait.position.x += 90.0
	hashagur_portrait.modulate.a = 0.0
	hashagur_portrait.visible = true
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(hashagur_portrait, "position", destination, 0.6)
	tween.tween_property(hashagur_portrait, "modulate:a", 1.0, 0.52)
	await tween.finished


func _highlight_speaker(speaker: String) -> void:
	var speaker_id: String = ""
	var normalized: String = speaker.to_lower()
	if normalized.contains("uiliam"):
		speaker_id = "Uiliam"
	elif normalized.contains("aniri"):
		speaker_id = "Aniri"
	elif normalized.contains("kasum"):
		speaker_id = "Kasum"
	elif normalized.contains("hashagur"):
		speaker_id = "Hashagur"
	elif normalized == "aventureiro" or normalized == str(GameState.player_name).to_lower():
		speaker_id = "Heroi"
	for character_id in portrait_nodes:
		var portrait: Control = portrait_nodes[character_id] as Control
		if not portrait.visible:
			continue
		portrait.modulate = Color.WHITE if speaker_id == "" or character_id == speaker_id else Color(0.50, 0.50, 0.53, 1.0)


func _build_header() -> void:
	var header := PanelContainer.new()
	header.name = "TempleGateHeader"
	header.anchor_left = 0.02
	header.anchor_right = 0.98
	header.offset_top = 16.0
	header.offset_bottom = 84.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.04, 0.05, 0.90)
	style.border_color = Color(0.72, 0.55, 0.24)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	header.add_theme_stylebox_override("panel", style)
	add_child(header)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	header.add_child(row)
	var menu_button := Button.new()
	menu_button.text = "Menu principal"
	menu_button.custom_minimum_size = Vector2(180, 52)
	menu_button.pressed.connect(_on_menu_pressed)
	row.add_child(menu_button)
	objective_label = Label.new()
	objective_label.text = "Às portas do templo de Hashagur"
	objective_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	objective_label.add_theme_font_size_override("font_size", 23)
	objective_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.63))
	row.add_child(objective_label)
	enter_button = Button.new()
	enter_button.text = "Entrar no templo"
	enter_button.custom_minimum_size = Vector2(190, 52)
	enter_button.pressed.connect(_on_enter_pressed)
	enter_button.visible = false
	row.add_child(enter_button)


func _play_temple_music() -> void:
	if MusicManage == null or MusicManage.music_player == null:
		return
	var player: AudioStreamPlayer = MusicManage.music_player
	if player.playing and player.stream != null and player.stream.resource_path == TEMPLE_MUSIC_PATH:
		return
	MusicManage.play_music(TEMPLE_MUSIC_PATH, 70.0)


func _play_arrival() -> void:
	await _animate_party_arrival()
	dialogue_box = StoryDialogBox.new()
	dialogue_box.name = "TempleBattleStyleDialogue"
	dialogue_box.set_cinematic_mode(false)
	add_child(dialogue_box)
	for step in TempleGateDatabase.get_arrival():
		match str(step.get("type", "")):
			"pause":
				await get_tree().create_timer(float(step.get("duration", 0.6)), true).timeout
			"hashagur_enters":
				await _animate_hashagur_arrival()
			"action":
				_highlight_speaker("")
				await dialogue_box.show_dialog("Narrador", str(step.get("text", "")))
			"dialogue":
				var speaker: String = str(step.get("speaker", ""))
				_highlight_speaker(speaker)
				if speaker == "Aventureiro":
					speaker = GameState.player_name
				await dialogue_box.show_dialog(speaker, str(step.get("text", "")))
	if not _save_arrival():
		push_warning("Não foi possível salvar a chegada ao templo.")
	_show_entrance()


func _save_arrival() -> bool:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	var previous_missions: Dictionary = MissionManager.get_save_data()
	MissionManager.update_mission_title(MISSION_ID, "Ecos do Templo")
	MissionManager.update_mission_description(MISSION_ID, "Entre no templo e descubra o que Hashagur sabe sobre o culto e a queda dos Selos.")
	MissionManager.update_mission_progress(MISSION_ID, "hashagur_invited_party_inside", true)
	save_data["missions"] = MissionManager.get_save_data()
	var completed_events: Array = save_data.get("completed_story_events", [])
	if ARRIVAL_EVENT_ID not in completed_events:
		completed_events.append(ARRIVAL_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	save_data["current_location"] = "temple_gate"
	if not SaveManager.write_save_data(save_path, save_data):
		MissionManager.load_save_data(previous_missions)
		return false
	return true


func _show_entrance() -> void:
	objective_label.text = "Ecos do Templo — entre e converse com Hashagur"
	enter_button.visible = true


func _show_after_battle() -> void:
	_show_arrived_cast()
	hashagur_portrait.visible = false
	objective_label.text = "Ecos do Templo — retorne à vila e descanse"
	enter_button.text = "Mapa do mundo"
	enter_button.visible = true


func _on_enter_pressed() -> void:
	if MissionManager.is_mission_active(COURTYARD_MISSION_ID):
		_start_courtyard_battle()
		return
	if MissionManager.is_mission_completed(ESCAPE_MISSION_ID):
		SceneTransition.change_scene_to_file("res://Scene/world_map.tscn")
		return
	if not SaveManager.has_completed_story_event(ARRIVAL_EVENT_ID) and not _save_arrival():
		objective_label.text = "Não foi possível salvar. Tente entrar novamente."
		return
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		objective_label.text = "Não foi possível abrir o save para entrar no templo."
		return
	save_data["current_location"] = "temple_hall"
	if not SaveManager.write_save_data(save_path, save_data):
		objective_label.text = "Não foi possível salvar a entrada no templo."
		return
	GameState.current_location = "temple_hall"
	SceneTransition.change_scene_to_file("res://Scene/temple_hall.tscn")


func _start_courtyard_battle() -> void:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		push_warning("Não foi possível abrir o save para continuar o ataque.")
		_show_courtyard_retry("Não foi possível abrir o save. Tente novamente.")
		return
	save_data["current_stage"] = 5
	save_data["current_location"] = "battle"
	if not SaveManager.write_save_data(save_path, save_data):
		push_warning("Não foi possível salvar o início do combate. Tente novamente.")
		_show_courtyard_retry("Não foi possível salvar o combate. Tente novamente.")
		return
	GameState.selected_stage = 5
	GameState.current_location = "battle"
	GameState.should_load_save = true
	SceneTransition.change_scene_to_file("res://Scene/main.tscn")


func _show_courtyard_retry(message: String) -> void:
	if not is_instance_valid(objective_label):
		_build_background()
		_build_header()
	objective_label.text = message
	enter_button.text = "Tentar novamente"
	enter_button.visible = true


func _on_menu_pressed() -> void:
	if MusicManage != null:
		MusicManage.stop_music()
	SceneTransition.change_scene_to_file("res://Scene/main_menu.tscn")
