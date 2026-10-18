extends Control

const TempleHallDatabase = preload("res://Scene/temple_hall_database.gd")
const VillageStoryEventScript = preload("res://Scene/village_story_event.gd")
const HALL_MAP_PATH := "res://Assets/Maps/Templo.jpg"
const TEMPLE_MUSIC_PATH := "res://Assets/Audio/Moonlight_on_Empty_Wood.mp3"
const FEEDBACK_URL := "https://docs.google.com/forms/d/e/1FAIpQLSdVqP7LyWeAEgfNX19Q9HgOJkb5CmsrIM9nA867sEn6D13Aiw/viewform?usp=publish-editor"
const HALL_STORY_EVENT_ID := "temple_hashagur_briefing"
const CITADEL_RETURN_EVENT_ID := "citadel_aniri_return_warning"
const CITADEL_MISSION_ID := "shadows_citadel"
const TEMPLE_BATTLE_INTRO_EVENT_ID := "temple_battle_intro_seen"
const TEMPLE_ESCAPE_MISSION_ID := "temple_escape_route"
const TEMPLE_BATTLE_INTRO_SCENE := "res://Scene/temple_battle_intro.tscn"

var status_label: Label
var map_button: Button
var story_event_controller: VillageStoryEvent


func _ready() -> void:
	GameState.current_location = "temple_hall"
	_build_background()
	_build_header()
	_build_objective()
	if MusicManage != null and MusicManage.music_player != null:
		var player: AudioStreamPlayer = MusicManage.music_player
		if not player.playing or player.stream == null or player.stream.resource_path != TEMPLE_MUSIC_PATH:
			MusicManage.play_music(TEMPLE_MUSIC_PATH, 70.0)
	# Saves antigos terminavam a primeira luta neste salão. Retome-os no
	# exterior, sem conceder recompensas novamente nem reiniciar a batalha.
	if MissionManager.is_mission_completed(TEMPLE_ESCAPE_MISSION_ID) and not MissionManager.is_mission_completed("temple_courtyard_defense"):
		call_deferred("_resume_legacy_temple_escape")
		return
	if SaveManager.has_completed_story_event(HALL_STORY_EVENT_ID):
		if MissionManager.is_mission_completed(CITADEL_MISSION_ID):
			if SaveManager.has_completed_story_event(CITADEL_RETURN_EVENT_ID):
				if MissionManager.is_mission_completed(TEMPLE_ESCAPE_MISSION_ID):
					_show_after_battle_objective()
				elif SaveManager.has_completed_story_event(TEMPLE_BATTLE_INTRO_EVENT_ID):
					_show_after_return_objective()
				else:
					call_deferred("_go_to_battle_intro")
			else:
				call_deferred("_play_return_story")
		else:
			_show_citadel_objective()
	else:
		call_deferred("_play_hall_story")


func _resume_legacy_temple_escape() -> void:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		status_label.text = "Não foi possível recuperar a saída do templo."
		return
	var previous_missions: Dictionary = MissionManager.get_save_data()
	if not MissionManager.is_mission_active("temple_courtyard_defense"):
		MissionManager.start_mission({
			"id": "temple_courtyard_defense",
			"title": "Sobreviva ao ataque",
			"description": "As portas estão seladas. Elimine os cultistas restantes no pátio externo."
		})
	save_data["missions"] = MissionManager.get_save_data()
	save_data["current_stage"] = 5
	save_data["current_location"] = "temple_gate"
	if not SaveManager.write_save_data(save_path, save_data):
		MissionManager.load_save_data(previous_missions)
		status_label.text = "Não foi possível salvar a continuação do ataque."
		return
	GameState.selected_stage = 5
	GameState.current_location = "temple_gate"
	SceneTransition.change_scene_to_file("res://Scene/temple_gate.tscn")


func _play_hall_story() -> void:
	story_event_controller = VillageStoryEventScript.new()
	add_child(story_event_controller)
	for scene_id_variant in TempleHallDatabase.ORDER:
		var scene_id: String = str(scene_id_variant)
		var scene: Array[Dictionary] = TempleHallDatabase.get_scene(scene_id)
		if scene.is_empty():
			push_warning("Trecho do templo não encontrado: " + scene_id)
			return
		var cast: Array[String] = []
		for speaker in TempleHallDatabase.CASTS.get(scene_id, []):
			cast.append(str(speaker))
		await story_event_controller.start_event(
			"temple_hall_" + scene_id, scene, cast, "Hashagur"
		)
	if not _save_hall_story():
		push_warning("Não foi possível salvar a conversa com Hashagur.")
		status_label.text = "Conversa concluída, mas não foi possível salvar. Abra o mapa para tentar novamente."
		map_button.visible = true
		return
	_show_citadel_objective()


func _play_return_story() -> void:
	map_button.visible = false
	story_event_controller = VillageStoryEventScript.new()
	add_child(story_event_controller)
	story_event_controller.story_dialog.hide_missing_cinematic_portraits = true
	for scene_id_variant in TempleHallDatabase.RETURN_ORDER:
		var scene_id: String = str(scene_id_variant)
		var scene: Array[Dictionary] = TempleHallDatabase.get_scene(scene_id)
		if scene.is_empty():
			push_error("Trecho do retorno ao templo não encontrado: " + scene_id)
			return
		var cast: Array[String] = []
		for speaker in TempleHallDatabase.CASTS.get(scene_id, []):
			cast.append(str(speaker))
		await story_event_controller.start_event(
			"temple_hall_" + scene_id, scene, cast, "Aniri"
		)
	if not _save_return_story():
		push_warning("Não foi possível salvar o aviso de Aniri no templo.")
		status_label.text = "O templo está sob ataque, mas não foi possível salvar a conversa. Abra o mapa para tentar novamente."
		map_button.visible = true
		return
	_go_to_battle_intro()


func _go_to_battle_intro() -> void:
	SceneTransition.change_scene_to_file(TEMPLE_BATTLE_INTRO_SCENE)


func _save_return_story() -> bool:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	var completed_events: Array = save_data.get("completed_story_events", [])
	if CITADEL_RETURN_EVENT_ID not in completed_events:
		completed_events.append(CITADEL_RETURN_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	save_data["current_location"] = "temple_hall"
	return SaveManager.write_save_data(save_path, save_data)


func _save_hall_story() -> bool:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	var previous_missions: Dictionary = MissionManager.get_save_data()
	if MissionManager.is_mission_active("hashagur_temple"):
		MissionManager.complete_mission("hashagur_temple")
	if not MissionManager.is_mission_active(CITADEL_MISSION_ID) and not MissionManager.is_mission_completed(CITADEL_MISSION_ID):
		MissionManager.start_mission({
			"id": CITADEL_MISSION_ID,
			"title": "Sombras da Cidadela",
			"description": "Infiltre Aniri na Cidadela Abandonada sem ser percebida e recolha as informações no quarto e na mesa de planos."
		})
	save_data["missions"] = MissionManager.get_save_data()
	var completed_events: Array = save_data.get("completed_story_events", [])
	if HALL_STORY_EVENT_ID not in completed_events:
		completed_events.append(HALL_STORY_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	save_data["current_location"] = "temple_hall"
	if not SaveManager.write_save_data(save_path, save_data):
		MissionManager.load_save_data(previous_missions)
		return false
	return true


func _show_citadel_objective() -> void:
	status_label.text = "Missão disponível: Sombras da Cidadela. No mapa, siga até a Cidadela Abandonada para iniciar a infiltração com Aniri."
	map_button.visible = true


func _show_after_return_objective() -> void:
	status_label.text = "O templo está sob ataque. Hashagur ordenou a defesa dos portões."
	map_button.visible = true


func _show_after_battle_objective() -> void:
	status_label.text = "A rota de fuga foi aberta. O grupo ainda precisa decidir como ajudar Hashagur."
	map_button.visible = true


func _build_background() -> void:
	var background := TextureRect.new()
	background.name = "TempleInterior"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.texture = load(HALL_MAP_PATH) as Texture2D
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)


func _build_header() -> void:
	var header := PanelContainer.new()
	header.name = "TempleHallHeader"
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
	var title := Label.new()
	title.text = "TEMPLO DE HASHAGUR"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 25)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.63))
	row.add_child(title)
	map_button = Button.new()
	map_button.text = "Mapa do mundo"
	map_button.custom_minimum_size = Vector2(175, 52)
	map_button.visible = false
	map_button.pressed.connect(_on_map_pressed)
	row.add_child(map_button)
	var feedback_button := Button.new()
	feedback_button.text = "Enviar feedback"
	feedback_button.custom_minimum_size = Vector2(190, 52)
	feedback_button.pressed.connect(func() -> void:
		if OS.shell_open(FEEDBACK_URL) != OK:
			status_label.text = "Não foi possível abrir o formulário neste dispositivo."
	)
	row.add_child(feedback_button)


func _build_objective() -> void:
	var panel := PanelContainer.new()
	panel.name = "TempleObjective"
	panel.anchor_left = 0.20
	panel.anchor_right = 0.80
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	panel.offset_top = -94.0
	panel.offset_bottom = -16.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.04, 0.05, 0.91)
	style.border_color = Color(0.72, 0.55, 0.24)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	status_label = Label.new()
	status_label.text = "Ecos do Templo — descubra o que Hashagur sabe sobre o culto e a queda dos Selos."
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 19)
	panel.add_child(status_label)


func _on_menu_pressed() -> void:
	if MusicManage != null:
		MusicManage.stop_music()
	SceneTransition.change_scene_to_file("res://Scene/main_menu.tscn")


func _on_map_pressed() -> void:
	if not SaveManager.has_completed_story_event(HALL_STORY_EVENT_ID) and not _save_hall_story():
		status_label.text = "Não foi possível salvar a nova missão. Tente novamente."
		return
	if MissionManager.is_mission_completed(CITADEL_MISSION_ID) and not SaveManager.has_completed_story_event(CITADEL_RETURN_EVENT_ID) and not _save_return_story():
		status_label.text = "Não foi possível salvar o retorno de Aniri. Tente novamente."
		return
	SceneTransition.change_scene_to_file("res://Scene/world_map.tscn")
