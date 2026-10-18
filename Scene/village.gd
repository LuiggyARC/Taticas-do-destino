extends Control


const VILLAGE_BACKGROUND: Texture2D = preload(
	"res://Assets/Maps/Vilarejo1.jpg"
)
const VillageLocationViewScript := preload(
	"res://Scene/village_location_view.gd"
)
const VillageDialogueDatabaseScript := preload(
	"res://Scene/village_dialogue_database.gd"
)
const VillageReturnDatabaseScript := preload(
	"res://Scene/village_return_database.gd"
)
const KasumTavernDatabaseScript := preload(
	"res://Scene/kasum_tavern_database.gd"
)
const VillageDrinkingDiceScript := preload(
	"res://Scene/village_drinking_dice.gd"
)
const BattleTutorialScript := preload(
	"res://Scene/battle_tutorial.gd"
)
const HealerNightDatabaseScript := preload(
	"res://Scene/healer_night_database.gd"
)
const BRIDGE_RETURN_EVENT_ID := "emerald_bridge_village_return"
const KASUM_RECRUITMENT_MISSION_ID := "kasum_recruitment"
const KASUM_TAVERN_EVENT_ID := "kasum_tavern_recruited"
const HEALER_NIGHT_EVENT_ID := "healer_night_after_kasum"
const TEMPLE_DEPARTURE_EVENT_ID := "temple_departure_started"
const HEALER_NIGHT_CONVERSATION_CAST: Array[String] = [
	"Sir Uiliam", "Aniri", "Aventureiro"
]
const MORNING_OPEN_LOCATIONS := ["central_square", "shop"]
const MAYOR_CONVERSATION_CAST: Array[String] = [
	"Sir Uiliam", "Aniri", "Aventureiro", "Prefeito"
]
const BRIDGE_RETURN_CONVERSATION_CAST: Array[String] = [
	"Sir Uiliam", "Aniri", "Aventureiro", "Jhon", "Prefeito"
]
const BACKGROUND_REFERENCE_SIZE := Vector2(
	2760.0,
	1504.0
)
const INITIAL_STORY_EVENT_ID := (
	"tavern_uiliam_history"
)
const CENTRAL_SQUARE_TUTORIAL_EVENT_ID := "central_square_tutorial_seen"
const VILLAGE_MUSIC_PATH := (
	"res://Assets/Audio/Trilhavila.mp3"
)
const TAVERN_MUSIC_PATH := (
	"res://Assets/Audio/Musictaverna1.mp3"
)
const KASUM_TAVERN_MUSIC_PATH := (
	"res://Assets/Audio/Taverna2.mp3"
)
const NIGHT_MUSIC_PATH := (
	"res://Assets/Audio/At night.mp3"
)
const TAVERN_FREE_DRINK_EVENT_ID := (
	"tavern_free_drink_claimed"
)
const StoryChoicePanelScript := preload(
	"res://Scene/story_choice_panel.gd"
)
const LOCATION_AREAS := {
	"tavern": Rect2(
		0.10,
		0.39,
		0.27,
		0.38
	),
	"shop": Rect2(
		0.26,
		0.18,
		0.22,
		0.29
	),
	"town_hall": Rect2(
		0.50,
		0.07,
		0.25,
		0.43
	),
	"carpenter": Rect2(
		0.72,
		0.34,
		0.18,
		0.34
	),
	"healer": Rect2(
		0.55,
		0.58,
		0.21,
		0.26
	),
	"central_square": Rect2(
		0.38,
		0.41,
		0.17,
		0.25
	)
}

const LOCATION_NAMES := {
	"tavern": "Taverna — O Poço Sem Fundo",
	"shop": "Loja — O Fole & Fardo",
	"town_hall": "Prefeitura — Solar do Administrador",
	"carpenter": "Casa do Carpinteiro",
	"healer": "Casa da Curandeira",
	"central_square": "Praça Central"
}
const LOCATION_BACKGROUNDS := {
	"tavern": preload(
		"res://Assets/Maps/Tavernavila1.jpg"
	),
	"shop": preload(
		"res://Assets/Maps/Lojadeequipamentovila1.jpg"
	),
	"town_hall": preload(
		"res://Assets/Maps/Prefeituravila1.jpg"
	),
	"carpenter": preload(
		"res://Assets/Maps/Carpitariavila1.jpg"
	),
	"healer": preload(
		"res://Assets/Maps/LojadecuraVila1.jpg"
	)
}

var village_background: TextureRect
var hotspot_layer: Control
var location_buttons: Dictionary = {}
var status_label: Label
var party_formation_panel: PartyFormationPanel
var shop_panel: VillageShopPanel
var location_view: Control
var shop_dialog_popup: StoryDialogBox
var healer_panel: VillageHealerPanel
var healer_dialog_popup: StoryDialogBox
var story_event_controller: VillageStoryEvent
var tavern_panel: VillageTavernPanel
var tavern_dialog_popup: StoryDialogBox
var story_choice_panel: Node
var bridge_return_running: bool = false
var kasum_event_running: bool = false
var healer_night_running: bool = false
var temple_button: Button
var world_map_button: Button
var temple_departure_running: bool = false
var central_square_tutorial: Control


func consume_pending_village_return_location() -> String:
	var save_path: String = (
		SaveManager.get_active_save_path()
	)

	var save_data: Dictionary = (
		SaveManager.read_save_data(
			save_path
		)
	)

	if save_data.is_empty():
		return ""

	var return_location: String = str(
		save_data.get(
			"village_return_location",
			""
		)
	).strip_edges()

	if return_location == "":
		return ""

	# O destino é consumido para não abrir novamente
	# toda vez que a vila for carregada.
	save_data.erase(
		"village_return_location"
	)

	var save_was_updated: bool = (
		SaveManager.write_save_data(
			save_path,
			save_data
		)
	)

	if not save_was_updated:
		push_warning(
			"Não foi possível consumir o local "
			+ "de retorno da vila."
		)

	return return_location


func handle_pending_village_return() -> bool:
	var return_location: String = (
		consume_pending_village_return_location()
	)
	
	if return_location == "":
		return false
	
	if not LOCATION_NAMES.has(
		return_location
	):
		push_warning(
			"Local de retorno desconhecido: "
			+ return_location
		)
		
		return false
	
	await get_tree().process_frame
	
	if LOCATION_BACKGROUNDS.has(
		return_location
	):
		open_location_background(
			return_location
		)
	
	if is_instance_valid(status_label):
		status_label.text = (
			"Retorno: "
			+ str(
				LOCATION_NAMES.get(
					return_location,
					return_location
				)
			)
		)
	if return_location == "town_hall" and MissionManager.is_mission_completed("emerald_bridge") and not SaveManager.has_completed_story_event(BRIDGE_RETURN_EVENT_ID):
		bridge_return_running = true
		var bridge_return_finished: bool = await run_bridge_return_mayor_event()
		bridge_return_running = false
		if not bridge_return_finished and is_instance_valid(status_label):
			status_label.text = "O encontro com o prefeito não pôde ser concluído. Toque na prefeitura para tentar novamente."
		return true
	
	var must_run_second_chance_return: bool = (
		return_location == "carpenter"
		and MissionManager.is_mission_active(
			"aniri_second_chance"
		)
		and not SaveManager.has_completed_story_event(
			"second_chance_carpenter_return"
		)
	)
	
	if must_run_second_chance_return:
		var event_finished: bool = (
			await run_second_chance_carpenter_return()
		)
		
		if not event_finished:
			push_warning(
				"Não foi possível executar o retorno "
				+ "da missão Uma Segunda Chance."
			)
			
			return true
		
		MissionManager.update_mission_progress(
			"aniri_second_chance",
			"objects_returned",
			true
		)
		
		MissionManager.update_mission_progress(
			"aniri_second_chance",
			"apology_made",
			true
		)
		
		var event_was_saved: bool = (
			SaveManager.mark_story_event_completed(
				"second_chance_carpenter_return"
			)
		)
		
		var progress_was_saved: bool = (
			SaveManager.save_village_state()
		)
		
		if is_instance_valid(status_label):
			if (
				event_was_saved
				and progress_was_saved
			):
				status_label.text = (
					"Os objetos foram devolvidos. "
					+ "Agora o grupo deve visitar "
					+ "a curandeira."
				)
			else:
				status_label.text = (
					"O diálogo terminou, mas não foi "
					+ "possível salvar todo o progresso."
				)
	
	return true

func _ready() -> void:
	set_process_input(
		true
	)
	if MissionManager.is_mission_active("temple_return_to_village"):
		var previous_missions: Dictionary = MissionManager.get_save_data()
		MissionManager.complete_mission("temple_return_to_village")
		if not SaveManager.save_village_state():
			MissionManager.load_save_data(previous_missions)
	
	sync_available_party_members()
	
	create_village_background()
	create_hotspot_layer()
	create_location_buttons()
	create_village_interface()
	create_world_map_button()
	create_temple_button()
	create_location_view()
	create_village_story_event()
	refresh_village_access()
	
	resized.connect(
		update_location_button_positions
	)
	
	call_deferred(
		"update_location_button_positions"
	)
	
	if should_start_healer_night():
		if MusicManage != null:
			MusicManage.stop_music()
	else:
		play_village_music()
	
	var return_was_handled: bool = await (
		handle_pending_village_return()
	)
	
	# Só executa a introdução da taverna quando
	# não existe um retorno narrativo específico.
	if not return_was_handled:
		if should_start_healer_night():
			await begin_healer_night()
		elif not is_next_morning():
			start_initial_village_story_event()
			if SaveManager.has_completed_story_event(INITIAL_STORY_EVENT_ID):
				call_deferred("show_central_square_tutorial")

func sync_available_party_members() -> void:
	PartyManager.sync_hero_from_game_state()
	
	PartyManager.recruit_npc(
		"Sr Uiliam",
		false
	)
	# Repara saves criados antes do cadastro da Aniri na equipe.
	if GameState.selected_stage >= 3 or MissionManager.is_mission_active("aniri_second_chance") or MissionManager.is_mission_completed("aniri_second_chance"):
		PartyManager.recruit_npc("Aniri", false)
	if MissionManager.is_mission_completed(KASUM_RECRUITMENT_MISSION_ID):
		PartyManager.recruit_npc("Kasum", false)

func create_village_background() -> void:
	var black_background := ColorRect.new()
	black_background.name = "BlackBackground"
	black_background.color = Color.BLACK
	black_background.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	black_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(
		black_background
	)
	
	village_background = TextureRect.new()
	village_background.name = "VillageBackground"
	village_background.texture = VILLAGE_BACKGROUND
	
	village_background.expand_mode = (
		TextureRect.EXPAND_IGNORE_SIZE
	)
	
	village_background.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	)
	
	village_background.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	village_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(
		village_background
	)


func create_hotspot_layer() -> void:
	hotspot_layer = Control.new()
	hotspot_layer.name = "HotspotLayer"
	
	hotspot_layer.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	hotspot_layer.mouse_filter = (
		Control.MOUSE_FILTER_PASS
	)
	
	add_child(
		hotspot_layer
	)


func create_location_buttons() -> void:
	for location_id in LOCATION_AREAS.keys():
		var location_button := Button.new()
		
		location_button.name = (
			"Location_"
			+ str(location_id)
		)
		
		location_button.text = ""
		location_button.focus_mode = (
			Control.FOCUS_NONE
		)
		
		location_button.tooltip_text = str(
			LOCATION_NAMES.get(
				location_id,
				location_id
			)
		)
		
		location_button.add_theme_stylebox_override(
			"normal",
			create_hotspot_style(
				Color.TRANSPARENT,
				Color.TRANSPARENT
			)
		)
		
		location_button.add_theme_stylebox_override(
			"hover",
			create_hotspot_style(
				Color(
					0.78,
					0.62,
					0.20,
					0.18
				),
				Color(
					1.0,
					0.82,
					0.30,
					0.90
				)
			)
		)
		
		location_button.add_theme_stylebox_override(
			"pressed",
			create_hotspot_style(
				Color(
					0.95,
					0.70,
					0.15,
					0.30
				),
				Color(
					1.0,
					0.88,
					0.45,
					1.0
				)
			)
		)
		
		location_button.pressed.connect(
			on_location_pressed.bind(
				str(location_id)
			)
		)
		
		hotspot_layer.add_child(
			location_button
		)
		
		location_buttons[location_id] = (
			location_button
		)

func is_next_morning() -> bool:
	return SaveManager.has_completed_story_event(HEALER_NIGHT_EVENT_ID)

func has_started_temple_journey() -> bool:
	return (
		SaveManager.has_completed_story_event(TEMPLE_DEPARTURE_EVENT_ID)
		or SaveManager.has_completed_story_event("temple_road_litz_arievilo")
		or SaveManager.has_completed_story_event("temple_hashagur_arrival")
		or SaveManager.has_completed_story_event("temple_hashagur_briefing")
	)

func should_start_healer_night() -> bool:
	return MissionManager.is_mission_completed(KASUM_RECRUITMENT_MISSION_ID) and not is_next_morning()

static func is_location_open_in_morning(location_id: String) -> bool:
	return location_id in MORNING_OPEN_LOCATIONS

func refresh_village_access() -> void:
	var morning: bool = is_next_morning()
	var departed: bool = has_started_temple_journey()
	for location_id in location_buttons.keys():
		var button: Button = location_buttons.get(location_id) as Button
		if not is_instance_valid(button):
			continue
		var closed_for_morning: bool = morning and not is_location_open_in_morning(str(location_id))
		button.disabled = closed_for_morning or (location_id == "carpenter" and SaveManager.has_completed_story_event(BRIDGE_RETURN_EVENT_ID))
		button.tooltip_text = "Indisponível nesta manhã" if closed_for_morning else ("Carpintaria fechada" if button.disabled else str(LOCATION_NAMES.get(location_id, location_id)))
	if is_instance_valid(temple_button):
		temple_button.visible = morning and not departed
	if is_instance_valid(world_map_button):
		world_map_button.anchor_top = 1.0 if departed else 0.0
		world_map_button.anchor_bottom = 1.0 if departed else 0.0
		world_map_button.offset_left = -306.0 if departed else -216.0
		world_map_button.offset_right = -18.0
		world_map_button.offset_top = -82.0 if departed else 14.0
		world_map_button.offset_bottom = -18.0 if departed else 62.0
		world_map_button.add_theme_font_size_override("font_size", 23 if departed else 19)


func create_hotspot_style(
	background_color: Color,
	border_color: Color
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	
	style.bg_color = background_color
	style.border_color = border_color
	style.set_border_width_all(3)
	
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	
	return style


func create_village_interface() -> void:
	var title_background := ColorRect.new()
	title_background.name = "TitleBackground"
	title_background.color = Color(
		0.02,
		0.02,
		0.03,
		0.78
	)
	
	title_background.anchor_left = 0.5
	title_background.anchor_right = 0.5
	title_background.offset_left = -230.0
	title_background.offset_top = 14.0
	title_background.offset_right = 230.0
	title_background.offset_bottom = 62.0
	
	title_background.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	add_child(
		title_background
	)
	
	var title_label := Label.new()
	title_label.name = "VillageTitle"
	title_label.text = "Vila de Passos da Névoa"
	
	title_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	title_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	title_label.add_theme_font_size_override(
		"font_size",
		25
	)
	
	title_label.add_theme_color_override(
		"font_color",
		Color(
			1.0,
			0.88,
			0.58,
			1.0
		)
	)
	
	title_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	title_label.add_theme_constant_override(
		"outline_size",
		5
	)
	
	title_label.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	title_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	title_background.add_child(
		title_label
	)
	
	var status_background := PanelContainer.new()
	status_background.name = "StatusBackground"
	
	status_background.anchor_left = 0.5
	status_background.anchor_right = 0.5
	status_background.anchor_top = 1.0
	status_background.anchor_bottom = 1.0
	
	status_background.offset_left = -310.0
	status_background.offset_top = -72.0
	status_background.offset_right = 310.0
	status_background.offset_bottom = -16.0
	
	var status_style := StyleBoxFlat.new()
	status_style.bg_color = Color(
		0.02,
		0.02,
		0.03,
		0.90
	)
	
	status_style.border_color = Color(
		0.78,
		0.62,
		0.28,
		1.0
	)
	
	status_style.set_border_width_all(2)
	status_style.corner_radius_top_left = 10
	status_style.corner_radius_top_right = 10
	status_style.corner_radius_bottom_left = 10
	status_style.corner_radius_bottom_right = 10
	
	status_background.add_theme_stylebox_override(
		"panel",
		status_style
	)
	
	add_child(
		status_background
	)
	
	status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = (
		"Selecione um local da vila."
	)
	
	status_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	status_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	status_label.add_theme_font_size_override(
		"font_size",
		18
	)
	
	status_label.add_theme_color_override(
		"font_color",
		Color.WHITE
	)
	
	status_background.add_child(
		status_label
	)

func create_world_map_button() -> void:
	world_map_button = Button.new()
	var map_button: Button = world_map_button
	map_button.name = "WorldMapButton"
	map_button.text = "Mapa do mundo"
	map_button.tooltip_text = "Ver estradas e destinos de Aviant"
	map_button.anchor_left = 1.0
	map_button.anchor_right = 1.0
	map_button.offset_left = -216.0
	map_button.offset_right = -18.0
	map_button.offset_top = 14.0
	map_button.offset_bottom = 62.0
	map_button.add_theme_font_size_override("font_size", 19)
	map_button.pressed.connect(func() -> void:
		if healer_night_running or temple_departure_running:
			return
		SceneTransition.change_scene_to_file("res://Scene/world_map.tscn")
	)
	add_child(map_button)


func create_temple_button() -> void:
	if is_instance_valid(temple_button):
		return
	temple_button = Button.new()
	temple_button.name = "TempleDepartureButton"
	temple_button.text = "Seguir para o templo"
	temple_button.tooltip_text = "Seguir até o templo de Hashagur"
	temple_button.anchor_left = 1.0
	temple_button.anchor_right = 1.0
	temple_button.anchor_top = 1.0
	temple_button.anchor_bottom = 1.0
	temple_button.offset_left = -306.0
	temple_button.offset_right = -18.0
	temple_button.offset_top = -82.0
	temple_button.offset_bottom = -18.0
	temple_button.add_theme_font_size_override("font_size", 23)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.22, 0.14, 0.96)
	style.border_color = Color(0.30, 0.88, 0.60)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	temple_button.add_theme_stylebox_override("normal", style)
	var hover_style: StyleBoxFlat = style.duplicate()
	hover_style.bg_color = Color(0.08, 0.38, 0.23, 0.98)
	temple_button.add_theme_stylebox_override("hover", hover_style)
	temple_button.pressed.connect(on_temple_pressed)
	add_child(temple_button)
	temple_button.visible = false

func on_temple_pressed() -> void:
	if not is_next_morning() or has_started_temple_journey() or healer_night_running or temple_departure_running:
		return
	temple_departure_running = true
	temple_button.disabled = true
	if not is_instance_valid(story_event_controller):
		create_village_story_event()
	if not is_instance_valid(story_event_controller):
		temple_departure_running = false
		temple_button.disabled = false
		return
	story_event_controller.move_to_front()
	await story_event_controller.start_event("temple_departure_intro", [
		{"type": "action", "text": "Ao amanhecer, o grupo se reúne na praça. Kasum chega da taverna com sua arma às costas."},
		{"type": "dialogue", "speaker": "Sir Uiliam", "text": "O templo de Hashagur fica além da floresta. É hora de descobrir o que ele sabe sobre o culto."}
	])
	if not SaveManager.save_village_state():
		push_warning("Não foi possível salvar o progresso antes da viagem ao templo.")
		temple_departure_running = false
		temple_button.disabled = false
		return
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	save_data["current_location"] = "temple_road"
	save_data["world_map_node"] = "bridge"
	var completed_events: Array = save_data.get("completed_story_events", [])
	if TEMPLE_DEPARTURE_EVENT_ID not in completed_events:
		completed_events.append(TEMPLE_DEPARTURE_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	if not SaveManager.write_save_data(save_path, save_data):
		push_warning("Não foi possível registrar a viagem ao templo.")
		temple_departure_running = false
		temple_button.disabled = false
		return
	GameState.current_location = "temple_road"
	SceneTransition.change_scene_to_file("res://Scene/temple_road.tscn")

func create_location_view() -> void:
	if is_instance_valid(location_view):
		return
	
	location_view = (
		VillageLocationViewScript.new()
	)
	
	add_child(
		location_view
	)
	
	location_view.connect(
		"return_to_village_requested",
		Callable(
			self,
			"on_return_to_village_requested"
		)
	)

func get_background_display_rect() -> Rect2:
	var available_size: Vector2 = size
	
	if (
		available_size.x <= 0.0
		or available_size.y <= 0.0
	):
		return Rect2()
	
	var image_aspect: float = (
		BACKGROUND_REFERENCE_SIZE.x
		/ BACKGROUND_REFERENCE_SIZE.y
	)
	
	var viewport_aspect: float = (
		available_size.x
		/ available_size.y
	)
	
	var displayed_size := Vector2.ZERO
	
	if viewport_aspect > image_aspect:
		displayed_size.y = available_size.y
		displayed_size.x = (
			displayed_size.y
			* image_aspect
		)
	else:
		displayed_size.x = available_size.x
		displayed_size.y = (
			displayed_size.x
			/ image_aspect
		)
	
	var displayed_position: Vector2 = (
		available_size - displayed_size
	) / 2.0
	
	return Rect2(
		displayed_position,
		displayed_size
	)


func update_location_button_positions() -> void:
	if not is_instance_valid(hotspot_layer):
		return
	
	var display_rect: Rect2 = (
		get_background_display_rect()
	)
	
	if display_rect.size == Vector2.ZERO:
		return
	
	for location_id in LOCATION_AREAS.keys():
		var location_button: Button = (
			location_buttons.get(
				location_id
			) as Button
		)
		
		if not is_instance_valid(location_button):
			continue
		
		var normalized_area: Rect2 = (
			LOCATION_AREAS[location_id]
		)
		
		location_button.position = (
			display_rect.position
			+ Vector2(
				normalized_area.position.x
				* display_rect.size.x,
				normalized_area.position.y
				* display_rect.size.y
			)
		)
		
		location_button.size = Vector2(
			normalized_area.size.x
				* display_rect.size.x,
			normalized_area.size.y
				* display_rect.size.y
		)

func run_second_chance_carpenter_return() -> bool:
	var carpenter_cast: Array[String] = ["Sir Uiliam", "Aventureiro", "Aniri", "Jhon"]
	if not await run_location_story_event("second_chance_carpenter_return", carpenter_cast):
		return false

	return await run_location_story_event("second_chance_carpenter_conclusion", carpenter_cast)


func run_second_chance_healer_return() -> bool:
	const MISSION_ID: String = "aniri_second_chance"
	const EVENT_ID: String = "second_chance_healer_return"
	const POTION_ID: String = "minor_healing_potion"
	const POTION_QUANTITY: int = 3
	var healer_cast: Array[String] = ["Sir Uiliam", "Aventureiro", "Aniri", "Curandeira"]
	
	if not MissionManager.is_mission_active(
		MISSION_ID
	):
		return false
	
	if not SaveManager.has_completed_story_event(
		"second_chance_carpenter_return"
	):
		if is_instance_valid(status_label):
			status_label.text = (
				"O grupo ainda precisa terminar "
				+ "a conversa na carpintaria."
			)
		
		return false
	
	if SaveManager.has_completed_story_event(
		EVENT_ID
	):
		return false
	
	if not SaveManager.has_completed_story_event("second_chance_village_decision"):
		if not await run_location_story_event(EVENT_ID, healer_cast):
			push_warning("Não foi possível executar a devolução na loja de cura.")
			return false
		if not await run_second_chance_village_decision():
			return false

	if not await run_location_story_event("second_chance_healer_morning", healer_cast):
		push_warning("Não foi possível concluir a manhã na Casa de Cura.")
		return false
	
	PartyManager.restore_active_party_after_rest()
	
	var mission_data: Dictionary = (
		MissionManager.get_active_mission(
			MISSION_ID
		)
	)
	
	var mission_progress: Dictionary = (
		mission_data.get(
			"progress",
			{}
		)
	)
	
	var reward_already_received: bool = bool(
		mission_progress.get(
			"healer_reward_received",
			false
		)
	)
	
	var potions_were_added: bool = true
	
	if not reward_already_received:
		potions_were_added = (
			InventoryManager.add_item(
				POTION_ID,
				POTION_QUANTITY
			)
		)
	
	if not potions_were_added:
		push_warning(
			"Não foi possível entregar as três "
			+ "poções de cura."
		)
		
		return false
	
	MissionManager.update_mission_progress(
		MISSION_ID,
		"healer_items_returned",
		true
	)
	
	MissionManager.update_mission_progress(
		MISSION_ID,
		"free_rest_received",
		true
	)
	
	MissionManager.update_mission_progress(
		MISSION_ID,
		"healer_reward_received",
		true
	)
	MissionManager.update_mission_description(
		MISSION_ID,
		"Aniri devolveu os itens roubados e assumiu sua dívida com Jhon. "
		+ "Ela decidiu acompanhar o grupo e provar que pode seguir um caminho diferente.\n"
		+ "Pendência: Aniri ainda deve a Jhon.\n"
		+ "Nova companheira: Aniri — ladina halfling.\n"
		+ "Recompensa: +3 Poções de Cura."
	)
	
	var progress_was_saved: bool = (
		SaveManager.save_village_state()
	)
	
	var event_was_saved: bool = (
		SaveManager.mark_story_event_completed(
			EVENT_ID
		)
	)
	
	if is_instance_valid(status_label):
		if (
			progress_was_saved
			and event_was_saved
		):
			status_label.text = (
				"O grupo descansou e recebeu "
				+ "três Poções de Cura Menor. "
				+ "Retorne à área principal."
			)
		else:
			status_label.text = (
				"A etapa terminou, mas não foi possível "
				+ "salvar todo o progresso."
			)
	
	return true

func on_location_pressed(
	location_id: String
) -> void:
	if bridge_return_running or kasum_event_running or healer_night_running or temple_departure_running:
		return
	if is_next_morning() and not is_location_open_in_morning(location_id):
		return
	if location_id == "carpenter" and SaveManager.has_completed_story_event(BRIDGE_RETURN_EVENT_ID):
		return
	var location_name: String = str(
		LOCATION_NAMES.get(
			location_id,
			"Local desconhecido"
		)
	)
	
	if is_instance_valid(
		status_label
	):
		status_label.text = (
			location_name
			+ " selecionado."
		)
	
	if LOCATION_BACKGROUNDS.has(
		location_id
	):
		open_location_background(
			location_id
		)
	
	match location_id:
		"tavern":
			var kasum_scene_pending: bool = MissionManager.is_mission_active(KASUM_RECRUITMENT_MISSION_ID) and not SaveManager.has_completed_story_event(KASUM_TAVERN_EVENT_ID)
			if kasum_scene_pending:
				play_kasum_tavern_music()
			else:
				play_tavern_music()
			if kasum_scene_pending:
				kasum_event_running = true
				var recruitment_finished: bool = await run_kasum_tavern_event()
				kasum_event_running = false
				if not recruitment_finished:
					stop_tavern_music()
					if is_instance_valid(location_view):
						location_view.call("close_location")
					if is_instance_valid(status_label):
						status_label.text = "A conversa com Kasum não foi concluída."
					return
				open_tavern_panel()
				return
			
			await show_tavern_dialogue(
				"welcome"
			)
			
			open_tavern_panel()
		
		"shop":
			await show_shop_dialogue(
				"welcome"
			)
			
			open_village_shop(
				ShopDatabase.STARTING_VILLAGE_SHOP_ID
			)
		
		"town_hall":
			if MissionManager.is_mission_completed("emerald_bridge"):
				if not SaveManager.has_completed_story_event(BRIDGE_RETURN_EVENT_ID):
					bridge_return_running = true
					var return_finished: bool = await run_bridge_return_mayor_event()
					bridge_return_running = false
					if not return_finished and is_instance_valid(status_label):
						status_label.text = "O encontro com o prefeito não pôde ser concluído."
					return
				if is_instance_valid(status_label):
					status_label.text = "A ponte foi reparada. Kasum pode estar na taverna."
				return

			var aniri_decision_finished: bool = (
				SaveManager.has_completed_story_event(
					"second_chance_village_decision"
				)
			)
			
			if not aniri_decision_finished:
				var closed_event_finished: bool = (
					await run_location_story_event(
						"town_hall_closed"
					)
				)
				
				if (
					closed_event_finished
					and is_instance_valid(
						status_label
					)
				):
					status_label.text = (
						"A prefeitura está fechada."
					)
				
				return

			var mayor_event_finished: bool = (
				await run_emerald_bridge_mayor_event()
			)
			
			if not mayor_event_finished:
				if is_instance_valid(
					status_label
				):
					status_label.text = (
						"O encontro com o prefeito "
						+ "não pôde ser concluído."
					)
				
				return
			
			await start_emerald_bridge_battle()
		
		"carpenter":
			if MissionManager.is_mission_active(
				"aniri_second_chance"
			):
				if SaveManager.has_completed_story_event(
					"second_chance_carpenter_return"
				):
					if is_instance_valid(
						status_label
					):
						status_label.text = (
							"Os objetos já foram devolvidos. "
							+ "Agora o grupo deve visitar "
							+ "a curandeira."
						)
					
					return
				
				var return_event_finished: bool = (
					await run_second_chance_carpenter_return()
				)
				
				if return_event_finished:
					MissionManager.update_mission_progress(
						"aniri_second_chance",
						"objects_returned",
						true
					)
					
					MissionManager.update_mission_progress(
						"aniri_second_chance",
						"apology_made",
						true
					)
					
					SaveManager.save_village_state()
					
					SaveManager.mark_story_event_completed(
						"second_chance_carpenter_return"
					)
				
				return
			
			var carpenter_cast: Array[String] = [
				"Sir Uiliam", "Aventureiro", "Jhon"
			]
			var carpenter_event_finished: bool = (
				await run_location_story_event(
					"carpenter_basement_request",
					carpenter_cast
				)
			)
			if not carpenter_event_finished:
				return
			var carpenter_choice: String = await show_village_story_choice(
				"Você acompanhará Uiliam ao porão?",
				[
					{"id": "accept", "button_text": "Vamos ajudar."},
					{"id": "question", "button_text": "Primeiro quero saber com o que estamos lidando."}
				]
			)
			if carpenter_choice == "":
				return
			var carpenter_branch: String = "carpenter_basement_accept"
			if carpenter_choice == "question":
				carpenter_branch = "carpenter_basement_question"
			elif carpenter_choice != "accept":
				return
			MissionManager.set_story_choice("carpenter_basement_decision", carpenter_choice)
			if not await run_location_story_event(carpenter_branch, carpenter_cast):
				return
			if not await run_location_story_event("carpenter_basement_warning", carpenter_cast):
				return
			await start_basement_battle()
		
		"healer":
			var healer_mission_event_started: bool = (
				await run_second_chance_healer_return()
			)
			
			if healer_mission_event_started:
				return
			if MissionManager.is_mission_active("aniri_second_chance") and not SaveManager.has_completed_story_event("second_chance_healer_return"):
				return
			
			if (
				MissionManager.is_mission_active(
					"aniri_second_chance"
				)
				and not SaveManager.has_completed_story_event(
					"second_chance_carpenter_return"
				)
			):
				return
			
			await show_healer_dialogue(
				"welcome"
			)
			
			open_healer_panel()
		
		"central_square":
			open_party_formation_panel()

func open_village_shop(
	shop_id: String = (
		ShopDatabase.STARTING_VILLAGE_SHOP_ID
	)
) -> void:
	if not is_instance_valid(
		shop_panel
	):
		shop_panel = VillageShopPanel.new()
		
		shop_panel.panel_closed.connect(
			save_village_progress
		)
		
		shop_panel.item_purchased.connect(
			on_shop_item_purchased
		)
		
		shop_panel.item_sold.connect(
			on_shop_item_sold
		)
		
		add_child(
			shop_panel
		)
	
	shop_panel.move_to_front()
	
	shop_panel.open_shop(
		shop_id
	)

func save_village_progress() -> void:
	var save_successful: bool = (
		SaveManager.save_village_state()
	)
	
	if is_instance_valid(status_label):
		if save_successful:
			status_label.text = (
				"Progresso da vila salvo."
			)
		else:
			status_label.text = (
				"Não foi possível salvar "
				+ "o progresso da vila."
			)

func open_party_formation_panel() -> void:
	if not is_instance_valid(
		party_formation_panel
	):
		party_formation_panel = (
			PartyFormationPanel.new()
		)
		
		party_formation_panel.panel_closed.connect(
			save_village_progress
		)
		
		add_child(
			party_formation_panel
		)
	
	party_formation_panel.open_panel()
func open_location_background(
	location_id: String
) -> void:
	if not is_instance_valid(location_view):
		create_location_view()
	
	if not is_instance_valid(location_view):
		return
	
	if not LOCATION_BACKGROUNDS.has(
		location_id
	):
		return
	
	var location_texture: Texture2D = (
		LOCATION_BACKGROUNDS.get(
			location_id
		)
	)
	
	var location_name: String = str(
		LOCATION_NAMES.get(
			location_id,
			location_id
		)
	)
	
	location_view.call(
		"open_location",
		location_texture,
		location_name
	)
func run_second_chance_village_decision() -> bool:
	const MISSION_ID: String = "aniri_second_chance"
	const DECISION_EVENT_ID: String = (
		"second_chance_village_decision"
	)
	var healer_cast: Array[String] = ["Sir Uiliam", "Aventureiro", "Aniri", "Curandeira"]
	
	if not MissionManager.is_mission_active(
		MISSION_ID
	):
		return false
	
	if not SaveManager.has_completed_story_event(
		"second_chance_carpenter_return"
	):
		return false
	
	if SaveManager.has_completed_story_event(
		DECISION_EVENT_ID
	):
		return false
	
	var choice_options: Array = [
		{
			"id": "acceptance",
			"button_text": "Você errou, mas está tentando consertar."
		},
		{
			"id": "distrust",
			"button_text": "Ainda quero ver se posso confiar em você."
		}
	]
	
	var selected_choice: String = await (
		show_village_story_choice(
			"Como você responderá a Aniri?",
			choice_options
		)
	)
	
	if selected_choice == "":
		push_warning(
			"Nenhuma resposta foi selecionada "
			+ "para Aniri."
		)
		
		return false
	
	MissionManager.set_story_choice(
		"aniri_second_chance_decision",
		selected_choice
	)
	
	var branch_event_id: String = ""
	
	match selected_choice:
		"acceptance":
			branch_event_id = (
				"second_chance_choice_acceptance"
			)
			
			var mission_data: Dictionary = (
				MissionManager.get_active_mission(
					MISSION_ID
				)
			)
			
			var mission_progress: Dictionary = (
				mission_data.get(
					"progress",
					{}
				)
			)
			
			var current_affinity: int = int(
				mission_progress.get(
					"aniri_affinity",
					0
				)
			)
			
			MissionManager.update_mission_progress(
				MISSION_ID,
				"aniri_affinity",
				current_affinity + 1
			)
		
		"distrust":
			branch_event_id = (
				"second_chance_choice_distrust"
			)
		
		_:
			push_warning(
				"Resposta desconhecida para Aniri: "
				+ selected_choice
			)
			
			return false
	
	var branch_finished: bool = (
		await run_location_story_event(
			branch_event_id,
			healer_cast
		)
	)
	
	if not branch_finished:
		return false
	
	var conclusion_finished: bool = (
		await run_location_story_event(
			"second_chance_new_adventurer",
			healer_cast
		)
	)
	
	if not conclusion_finished:
		return false
	if not PartyManager.recruit_npc("Aniri", false):
		push_warning("Não foi possível registrar Aniri como companheira.")
		return false
	if not PartyManager.add_member_to_active_party("Aniri"):
		push_warning("Não foi possível incluir Aniri na equipe ativa.")
		return false
	
	MissionManager.update_mission_progress(
		MISSION_ID,
		"healer_return_completed",
		true
	)
	
	MissionManager.update_mission_progress(
		MISSION_ID,
		"decision_made",
		true
	)
	
	MissionManager.update_mission_progress(
		MISSION_ID,
		"carpenter_debt_pending",
		true
	)
	
	var progress_was_saved: bool = (
		SaveManager.save_village_state()
	)
	
	var event_was_saved: bool = (
		SaveManager.mark_story_event_completed(
			DECISION_EVENT_ID
		)
	)
	
	if is_instance_valid(status_label):
		if (
			progress_was_saved
			and event_was_saved
		):
			status_label.text = (
				"Missão atualizada: Uma Segunda Chance. "
				+ "Ajude Aniri a resolver sua dívida "
				+ "com o carpinteiro."
			)
		else:
			status_label.text = (
				"A decisão foi concluída, mas não foi "
				+ "possível salvar todo o progresso."
			)
	
	return true
func on_return_to_village_requested() -> void:
	if is_instance_valid(status_label):
		if is_next_morning() and has_started_temple_journey():
			status_label.text = "A praça e a loja estão abertas. Escolha o próximo destino no mapa do mundo."
		elif is_next_morning():
			status_label.text = "Amanheceu. A praça, a loja e o caminho para o templo estão disponíveis."
		else:
			status_label.text = "Você retornou à praça da vila."
	refresh_village_access()
	
	var must_start_aniri_decision: bool = (
		MissionManager.is_mission_active(
			"aniri_second_chance"
		)
		and SaveManager.has_completed_story_event(
			"second_chance_healer_return"
		)
		and not SaveManager.has_completed_story_event(
			"second_chance_village_decision"
		)
	)
	
	if not must_start_aniri_decision:
		return
	
	await get_tree().process_frame
	
	open_location_background("healer")
	await run_second_chance_village_decision()
func get_shop_dialog_popup() -> StoryDialogBox:
	if is_instance_valid(shop_dialog_popup):
		return shop_dialog_popup
	
	shop_dialog_popup = StoryDialogBox.new()
	shop_dialog_popup.name = "VillageShopDialogPopup"
	shop_dialog_popup.set_cinematic_mode(true)
	
	add_child(
		shop_dialog_popup
	)
	
	return shop_dialog_popup
func show_shop_dialogue(
	dialogue_id: String
) -> void:
	var dialogue_data: Dictionary = (
		ShopDatabase.get_shop_dialogue(
			ShopDatabase.STARTING_VILLAGE_SHOP_ID,
			dialogue_id
		)
	)
	
	if dialogue_data.is_empty():
		return
	
	var speaker_name: String = str(
		dialogue_data.get(
			"speaker",
			"Vendedor"
		)
	)
	
	var dialogue_text: String = str(
		dialogue_data.get(
			"text",
			""
		)
	)
	
	if dialogue_text.strip_edges() == "":
		return
	
	var dialogue_popup: StoryDialogBox = (
		get_shop_dialog_popup()
	)
	if not is_instance_valid(dialogue_popup):
		return
	dialogue_popup.set_conversation_cast([speaker_name, str(GameState.player_name)])
	dialogue_popup.set_conversation_weights({speaker_name.strip_edges().to_lower(): 1})
	
	await dialogue_popup.show_dialog(
		speaker_name,
		dialogue_text
	)
func on_shop_item_purchased(
	_item_id: String
) -> void:
	await show_shop_dialogue(
		"purchase"
	)


func on_shop_item_sold(
	_item_id: String
) -> void:
	await show_shop_dialogue(
		"sale"
	)
func get_healer_dialog_popup() -> StoryDialogBox:
	if is_instance_valid(healer_dialog_popup):
		return healer_dialog_popup
	
	healer_dialog_popup = StoryDialogBox.new()
	healer_dialog_popup.name = "VillageHealerDialogPopup"
	healer_dialog_popup.set_cinematic_mode(true)
	
	add_child(
		healer_dialog_popup
	)
	
	return healer_dialog_popup
func show_healer_dialogue(
	dialogue_id: String
) -> void:
	var dialogue_data: Dictionary = (
		VillageDialogueDatabaseScript.get_dialogue(
			VillageDialogueDatabaseScript.STARTING_VILLAGE_ID,
			"healer",
			dialogue_id
		)
	)
	
	if dialogue_data.is_empty():
		return
	
	var speaker_name: String = str(
		dialogue_data.get(
			"speaker",
			"Curandeira"
		)
	)
	
	var dialogue_text: String = str(
		dialogue_data.get(
			"text",
			""
		)
	)
	
	if dialogue_text.strip_edges() == "":
		return
	
	var dialogue_popup: StoryDialogBox = (
		get_healer_dialog_popup()
	)
	if not is_instance_valid(dialogue_popup):
		return
	dialogue_popup.set_conversation_cast([speaker_name, str(GameState.player_name)])
	dialogue_popup.set_conversation_weights({speaker_name.strip_edges().to_lower(): 1})
	
	await dialogue_popup.show_dialog(
		speaker_name,
		dialogue_text
	)
func open_healer_panel() -> void:
	if not is_instance_valid(healer_panel):
		healer_panel = VillageHealerPanel.new()
		
		healer_panel.rest_requested.connect(
			on_healer_rest_requested
		)
		
		healer_panel.potions_requested.connect(
			on_healer_potions_requested
		)
		
		healer_panel.panel_closed.connect(
			on_healer_panel_closed
		)
		
		add_child(
			healer_panel
		)
	
	healer_panel.move_to_front()
	healer_panel.open_panel()
func on_healer_rest_requested() -> void:
	const REST_PRICE: int = 2
	
	var payment_successful: bool = (
		InventoryManager.spend_gold(
			REST_PRICE
		)
	)
	
	if not payment_successful:
		await show_healer_dialogue(
			"rest_no_gold"
		)
		
		if is_instance_valid(status_label):
			status_label.text = (
				"Ouro insuficiente para descansar."
			)
		
		return
	
	PartyManager.restore_active_party_after_rest()
	
	var save_successful: bool = (
		SaveManager.save_village_state()
	)
	
	await show_healer_dialogue(
		"rest_success"
	)
	
	if is_instance_valid(status_label):
		if save_successful:
			status_label.text = (
				"O grupo descansou e recuperou "
				+ "seus recursos."
			)
		else:
			status_label.text = (
				"O grupo descansou, mas não foi "
				+ "possível salvar o progresso."
			)
func on_healer_potions_requested() -> void:
	const HEALER_SHOP_ID: String = (
		ShopDatabase.STARTING_VILLAGE_HEALER_SHOP_ID
	)
	
	if not SaveManager.has_completed_story_event(
		"second_chance_healer_return"
	):
		await show_healer_dialogue(
			"potion_no_stock"
		)
		
		open_village_shop(
			HEALER_SHOP_ID
		)
		return
	
	var available_stock: Array[Dictionary] = (
		ShopDatabase.get_shop_stock(
			HEALER_SHOP_ID
		)
	)
	
	if available_stock.is_empty():
		await show_healer_dialogue(
			"potion_sold_out"
		)
		return
	
	await show_healer_dialogue(
		"potion_in_stock"
	)
	
	open_village_shop(
		HEALER_SHOP_ID
	)

func on_healer_panel_closed() -> void:
	if is_instance_valid(status_label):
		status_label.text = (
			"Atendimento da curandeira encerrado."
		)
func create_village_story_event() -> void:
	if is_instance_valid(
		story_event_controller
	):
		return
	
	story_event_controller = (
		VillageStoryEvent.new()
	)
	
	add_child(
		story_event_controller
	)
	
	story_event_controller.move_to_front()
func start_initial_village_story_event() -> void:
	if SaveManager.has_completed_story_event(
		INITIAL_STORY_EVENT_ID
	):
		return
	
	var event_sequence: Array[Dictionary] = (
		VillageDialogueDatabaseScript.get_event_sequence(
			VillageDialogueDatabaseScript.STARTING_VILLAGE_ID,
			INITIAL_STORY_EVENT_ID
		)
	)
	
	if event_sequence.is_empty():
		push_warning(
			"Sequência inicial da vila não encontrada."
		)
		
		return
	
	open_location_background(
		"tavern"
	)
	
	if not is_instance_valid(
		story_event_controller
	):
		create_village_story_event()
	
	if not is_instance_valid(
		story_event_controller
	):
		return
	
	story_event_controller.move_to_front()
	
	await story_event_controller.start_event(
		INITIAL_STORY_EVENT_ID,
		event_sequence
	)
	
	if not MissionManager.is_mission_active("world_of_aviant") and not MissionManager.is_mission_completed("world_of_aviant"):
		MissionManager.start_mission({
			"id": "world_of_aviant",
			"title": "O Mundo de Aviant",
			"description": "Você conheceu a história da Grande Ruptura, dos Cinco Guerreiros e dos Selos de Vanir. Segundo Uiliam, os Selos mantêm as cidades de Aviant protegidas, enquanto as regiões além delas continuam perigosas. O número de criaturas parece estar aumentando.",
			"objective": "Explore a vila e descubra mais sobre Aviant — e sobre quem você era antes de chegar aqui."
		})
	SaveManager.save_village_state()
	
	var event_was_saved: bool = (
		SaveManager.mark_story_event_completed(
			INITIAL_STORY_EVENT_ID
		)
	)
	
	await show_tavern_dialogue(
		"story_interruption"
	)
	
	open_tavern_panel()
	
	if is_instance_valid(status_label):
		if event_was_saved:
			status_label.text = (
				"A conversa terminou. O taverneiro "
				+ "ofereceu uma rodada grátis."
			)
		else:
			status_label.text = (
				"A conversa terminou, mas não foi "
				+ "possível registrar sua conclusão."
			)

func get_tavern_dialog_popup() -> StoryDialogBox:
	if is_instance_valid(
		tavern_dialog_popup
	):
		return tavern_dialog_popup
	
	tavern_dialog_popup = StoryDialogBox.new()
	tavern_dialog_popup.name = (
		"VillageTavernDialogPopup"
	)
	tavern_dialog_popup.set_cinematic_mode(true)
	
	add_child(
		tavern_dialog_popup
	)
	
	return tavern_dialog_popup
func show_tavern_dialogue(
	dialogue_id: String
) -> void:
	var dialogue_data: Dictionary = (
		VillageDialogueDatabaseScript.get_dialogue(
			VillageDialogueDatabaseScript.STARTING_VILLAGE_ID,
			"tavern",
			dialogue_id
		)
	)
	
	if dialogue_data.is_empty():
		return
	
	var speaker_name: String = str(
		dialogue_data.get(
			"speaker",
			"Taverneiro"
		)
	)
	
	var dialogue_text: String = str(
		dialogue_data.get(
			"text",
			""
		)
	)
	
	if dialogue_text.strip_edges() == "":
		return
	
	var dialogue_popup: StoryDialogBox = (
		get_tavern_dialog_popup()
	)
	if not is_instance_valid(
		dialogue_popup
	):
		return
	dialogue_popup.set_conversation_cast([speaker_name, str(GameState.player_name)])
	dialogue_popup.set_conversation_weights({speaker_name.strip_edges().to_lower(): 1})
	
	await dialogue_popup.show_dialog(
		speaker_name,
		dialogue_text
	)
func open_tavern_panel() -> void:
	if not is_instance_valid(
		tavern_panel
	):
		tavern_panel = VillageTavernPanel.new()
		
		tavern_panel.drink_requested.connect(
			on_tavern_drink_requested
		)
		
		tavern_panel.rumor_requested.connect(
			on_tavern_rumor_requested
		)
		
		tavern_panel.panel_closed.connect(
			on_tavern_panel_closed
		)
		
		add_child(
			tavern_panel
		)
	
	var free_drink_available: bool = (
		SaveManager.has_completed_story_event(
			INITIAL_STORY_EVENT_ID
		)
		and not SaveManager.has_completed_story_event(
			TAVERN_FREE_DRINK_EVENT_ID
		)
	)
	
	tavern_panel.move_to_front()
	
	tavern_panel.open_panel(
		free_drink_available
	)

func on_tavern_drink_requested() -> void:
	const DRINK_PRICE: int = 1
	
	var free_drink_available: bool = (
		SaveManager.has_completed_story_event(
			INITIAL_STORY_EVENT_ID
		)
		and not SaveManager.has_completed_story_event(
			TAVERN_FREE_DRINK_EVENT_ID
		)
	)
	
	if free_drink_available:
		var free_drink_saved: bool = (
			SaveManager.mark_story_event_completed(
				TAVERN_FREE_DRINK_EVENT_ID
			)
		)
		
		await show_tavern_dialogue(
			"drink_success"
		)
		
		if is_instance_valid(tavern_panel):
			tavern_panel.open_panel(
				false
			)
		
		if is_instance_valid(status_label):
			if free_drink_saved:
				status_label.text = (
					"Você recebeu a rodada gratuita."
				)
			else:
				status_label.text = (
					"Você recebeu a bebida, mas não foi "
						+ "possível registrar a rodada."
				)
		
		return
	
	var payment_successful: bool = (
		InventoryManager.spend_gold(
			DRINK_PRICE
		)
	)
	
	if not payment_successful:
		await show_tavern_dialogue(
			"drink_no_gold"
		)
		
		if is_instance_valid(status_label):
			status_label.text = (
				"Ouro insuficiente para comprar "
					+ "a bebida."
			)
		
		return
	
	var save_successful: bool = (
		SaveManager.save_village_state()
	)
	
	await show_tavern_dialogue(
		"drink_success"
	)
	
	if is_instance_valid(status_label):
		if save_successful:
			status_label.text = (
				"Bebida comprada por 1 peça de ouro."
			)
		else:
			status_label.text = (
				"A bebida foi comprada, mas não foi "
					+ "possível salvar o progresso."
			)

func on_tavern_rumor_requested() -> void:
	await show_tavern_dialogue(
		"rumor_first"
	)
	
	await show_tavern_dialogue(
		"rumor_second"
	)
	
	if is_instance_valid(status_label):
		status_label.text = (
			"Você ouviu um boato sobre o roubo "
				+ "da loja de cura."
		)
func on_tavern_panel_closed() -> void:
	var start_night: bool = should_start_healer_night()
	if not start_night:
		stop_tavern_music()
	
	if is_instance_valid(location_view):
		location_view.call(
			"close_location"
		)
	
	if is_instance_valid(status_label):
		status_label.text = (
			"Você saiu da taverna."
		)
	if start_night:
		await begin_healer_night()
	elif SaveManager.has_completed_story_event(INITIAL_STORY_EVENT_ID):
		call_deferred("show_central_square_tutorial")


func show_central_square_tutorial() -> void:
	if SaveManager.has_completed_story_event(CENTRAL_SQUARE_TUTORIAL_EVENT_ID):
		return
	if is_instance_valid(central_square_tutorial) and central_square_tutorial.visible:
		return
	if not is_instance_valid(central_square_tutorial):
		central_square_tutorial = BattleTutorialScript.new()
		central_square_tutorial.name = "CentralSquareTutorial"
		central_square_tutorial.closed.connect(complete_central_square_tutorial)
		central_square_tutorial.visibility_changed.connect(update_central_square_tutorial_highlight)
		add_child(central_square_tutorial)
	central_square_tutorial.move_to_front()
	var steps: Array[Dictionary] = [{
		"title": "Prepare sua equipe na Praça Central",
		"text": "A área destacada abre a formação do grupo. Escolha quem acompanhará o herói antes de partir; você pode voltar à praça para trocar companheiros depois.",
		"target": "central_square",
		"progress_text": "EXPLORAÇÃO · PRAÇA CENTRAL",
		"button_text": "Abrir formação",
		"allow_skip": false
	}]
	central_square_tutorial.start_tutorial(steps, Callable(self, "get_central_square_tutorial_target_rect"))
	update_central_square_tutorial_highlight()


func get_central_square_tutorial_target_rect(_target_name: String) -> Rect2:
	var square_button: Button = location_buttons.get("central_square") as Button
	if is_instance_valid(square_button):
		return square_button.get_global_rect()
	return Rect2()


func update_central_square_tutorial_highlight() -> void:
	var square_button: Button = location_buttons.get("central_square") as Button
	if not is_instance_valid(square_button):
		return
	var highlight: bool = is_instance_valid(central_square_tutorial) and central_square_tutorial.visible
	square_button.add_theme_stylebox_override(
		"normal",
		create_hotspot_style(
			Color(0.18, 0.72, 0.47, 0.28) if highlight else Color.TRANSPARENT,
			Color(0.50, 1.0, 0.68, 1.0) if highlight else Color.TRANSPARENT
		)
	)


func complete_central_square_tutorial(completed: bool) -> void:
	if not completed:
		return
	SaveManager.mark_story_event_completed(CENTRAL_SQUARE_TUTORIAL_EVENT_ID)
	call_deferred("open_party_formation_panel")
func play_village_music() -> void:
	if MusicManage == null:
		return
	
	MusicManage.play_music(
		VILLAGE_MUSIC_PATH,
		65.0
	)
func play_tavern_music() -> void:
	if MusicManage == null:
		return
	
	MusicManage.play_music(
		TAVERN_MUSIC_PATH,
		75.0
	)
func play_kasum_tavern_music() -> void:
	if MusicManage == null:
		return
	if not ResourceLoader.exists(KASUM_TAVERN_MUSIC_PATH):
		push_warning("Trilha 'taverna 2' não encontrada em Assets/Audio; usando a trilha normal da taverna.")
		play_tavern_music()
		return
	MusicManage.play_music(KASUM_TAVERN_MUSIC_PATH, 75.0)
func play_night_music() -> void:
	if MusicManage == null:
		return
	if not ResourceLoader.exists(NIGHT_MUSIC_PATH):
		push_warning("Trilha noturna não encontrada: " + NIGHT_MUSIC_PATH)
		return
	MusicManage.play_music(NIGHT_MUSIC_PATH, 70.0)
func stop_tavern_music() -> void:
	play_village_music()
	
func create_story_choice_panel() -> void:
	if is_instance_valid(
		story_choice_panel
	):
		return
	
	story_choice_panel = (
		StoryChoicePanelScript.new()
	)
	
	add_child(
		story_choice_panel
	)

func show_village_story_choice(
	prompt_text: String,
	options: Array
) -> String:
	if options.is_empty():
		return ""
	
	if not is_instance_valid(
		story_choice_panel
	):
		create_story_choice_panel()
	
	if not is_instance_valid(
		story_choice_panel
	):
		return ""
	
	var selected_choice_id: String = await (
		story_choice_panel.show_choices(
			prompt_text,
			options
		)
	)
	
	return selected_choice_id

func run_location_story_event(
	event_id: String,
	portrait_cast: Array[String] = [],
	lead_speaker: String = ""
) -> bool:
	var event_sequence: Array[Dictionary] = (
		VillageDialogueDatabaseScript
		.get_location_event_sequence(
			VillageDialogueDatabaseScript.STARTING_VILLAGE_ID,
			event_id
		)
	)
	
	if event_sequence.is_empty():
		push_warning(
			"Evento do local não encontrado: "
			+ event_id
		)
		
		return false
	
	if not is_instance_valid(
		story_event_controller
	):
		create_village_story_event()
	
	if not is_instance_valid(
		story_event_controller
	):
		return false
	
	story_event_controller.move_to_front()
	
	await story_event_controller.start_event(
		event_id,
		event_sequence,
		portrait_cast,
		lead_speaker
	)
	
	return true

func run_bridge_return_mayor_event() -> bool:
	if SaveManager.has_completed_story_event(BRIDGE_RETURN_EVENT_ID):
		return true
	if not MissionManager.is_mission_completed("emerald_bridge"):
		return false
	if not is_instance_valid(story_event_controller):
		create_village_story_event()
	if not is_instance_valid(story_event_controller):
		return false

	for scene_id in ["mission", "reward", "cult", "aurora", "memory", "next"]:
		var scene: Array[Dictionary] = VillageReturnDatabaseScript.get_scene(scene_id)
		if scene.is_empty():
			push_warning("Cena de retorno não encontrada: " + scene_id)
			return false
		story_event_controller.move_to_front()
		if scene_id == "mission":
			await story_event_controller.start_event(
				scene_id, scene, BRIDGE_RETURN_CONVERSATION_CAST, "Sir Uiliam"
			)
		else:
			await story_event_controller.start_event(
				scene_id, scene, MAYOR_CONVERSATION_CAST, "Sir Uiliam"
			)

	# Recompensa, missões e marcador narrativo são gravados juntos para
	# impedir que recarregar a vila conceda o ouro uma segunda vez.
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	var old_gold: int = InventoryManager.get_gold()
	var old_missions: Dictionary = MissionManager.get_save_data()
	if MissionManager.is_mission_active("aniri_second_chance"):
		MissionManager.update_mission_progress("aniri_second_chance", "carpenter_debt_pending", false)
		MissionManager.update_mission_progress("aniri_second_chance", "debt_forgiven", true)
		MissionManager.update_mission_description(
			"aniri_second_chance", "Aniri não possui mais dívidas com Jhon."
		)
		MissionManager.complete_mission("aniri_second_chance")
	if not MissionManager.is_mission_active(KASUM_RECRUITMENT_MISSION_ID) and not MissionManager.is_mission_completed(KASUM_RECRUITMENT_MISSION_ID):
		MissionManager.start_mission({
			"id": KASUM_RECRUITMENT_MISSION_ID,
			"title": "Ouro Compra uma Boa Espada",
			"description": "Encontre Kasum na taverna e descubra quanto custará convencê-lo a acompanhar o grupo.",
			"progress": {"kasum_found": false}
		})
	InventoryManager.add_gold(300)
	save_data["missions"] = MissionManager.get_save_data()
	save_data["inventory"] = InventoryManager.get_save_data()
	var player_presets: Dictionary = save_data.get("player_presets", {})
	player_presets["hero_gold"] = InventoryManager.get_gold()
	save_data["player_presets"] = player_presets
	var completed_events: Array = save_data.get("completed_story_events", [])
	if BRIDGE_RETURN_EVENT_ID not in completed_events:
		completed_events.append(BRIDGE_RETURN_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	var saved: bool = SaveManager.write_save_data(save_path, save_data)
	if not saved:
		InventoryManager.set_gold(old_gold)
		MissionManager.load_save_data(old_missions)
		return false
	if is_instance_valid(location_view):
		location_view.call("close_location")
	refresh_village_access()
	if is_instance_valid(status_label):
		status_label.text = "Recompensa: +300 ouro. Loja atualizada. Próximo objetivo: encontrar Kasum na taverna."
	return true

func play_kasum_tavern_scene(scene_id: String) -> bool:
	var scene: Array[Dictionary] = KasumTavernDatabaseScript.get_scene(scene_id)
	if scene.is_empty():
		push_warning("Cena de Kasum não encontrada: " + scene_id)
		return false
	if not is_instance_valid(story_event_controller):
		create_village_story_event()
	if not is_instance_valid(story_event_controller):
		return false
	story_event_controller.move_to_front()
	await story_event_controller.start_event(scene_id, scene)
	return true

func roll_kasum_drinking_duel(first_name: String) -> Dictionary:
	var dice: Control = VillageDrinkingDiceScript.new()
	add_child(dice)
	dice.move_to_front()
	var result: Dictionary = await dice.call("roll_duel", first_name, "Kasum")
	dice.queue_free()
	return result

func show_kasum_bet_change(delta: int) -> void:
	var label: String = "+5 peças de ouro" if delta > 0 else "-5 peças de ouro"
	await story_event_controller.start_event("kasum_bet_result", [{
		"type": "dialogue",
		"speaker": "Ouro do grupo",
		"text": label
	}])

func run_kasum_tavern_event() -> bool:
	if SaveManager.has_completed_story_event(KASUM_TAVERN_EVENT_ID):
		return true
	if not MissionManager.is_mission_active(KASUM_RECRUITMENT_MISSION_ID):
		return false
	# No caminho mais custoso, o aventureiro e Aniri perdem uma aposta cada.
	if InventoryManager.get_gold() < 10:
		await story_event_controller.start_event("kasum_no_stake", [{
			"type": "dialogue",
			"speaker": "Ação",
			"text": "O grupo precisa ter ao menos 10 peças de ouro para cobrir as possíveis apostas com Kasum."
		}])
		return false
	if not await play_kasum_tavern_scene("intro"):
		return false
	var chosen_option: String = await show_village_story_choice(
		"Como responde ao desafio de Kasum?",
		[
			{"id": "hero_accept", "button_text": "Sirva a bebida."},
			{"id": "hero_refuses", "button_text": "Nem pensar. Você inventou isso, Aniri. Você bebe."}
		]
	)
	if chosen_option == "":
		return false
	var gold_delta: int = 0
	var hero_was_unconscious: bool = false
	var result_key: String = ""
	if chosen_option == "hero_accept":
		if not await play_kasum_tavern_scene("hero_accept"):
			return false
		var hero_roll: Dictionary = await roll_kasum_drinking_duel(str(GameState.player_name))
		if bool(hero_roll.get("first_won", false)):
			gold_delta += 5
			result_key = "hero_wins"
			await play_kasum_tavern_scene("hero_wins")
			await show_kasum_bet_change(5)
		else:
			gold_delta -= 5
			hero_was_unconscious = true
			await play_kasum_tavern_scene("hero_loses")
			await show_kasum_bet_change(-5)
			var aniri_rematch: Dictionary = await roll_kasum_drinking_duel("Aniri")
			if bool(aniri_rematch.get("first_won", false)):
				gold_delta += 5
				result_key = "aniri_wins_after_hero_loss"
			else:
				gold_delta -= 5
				result_key = "aniri_loses_after_hero_loss"
			await play_kasum_tavern_scene(result_key)
			await show_kasum_bet_change(5 if bool(aniri_rematch.get("first_won", false)) else -5)
	elif chosen_option == "hero_refuses":
		if not await play_kasum_tavern_scene("hero_refuses"):
			return false
		var aniri_roll: Dictionary = await roll_kasum_drinking_duel("Aniri")
		if bool(aniri_roll.get("first_won", false)):
			gold_delta += 5
			result_key = "aniri_wins"
		else:
			gold_delta -= 5
			result_key = "aniri_loses"
		await play_kasum_tavern_scene(result_key)
		await show_kasum_bet_change(5 if bool(aniri_roll.get("first_won", false)) else -5)
	else:
		return false
	if hero_was_unconscious and not await play_kasum_tavern_scene("recover_hero"):
		return false
	if not await play_kasum_tavern_scene("convergence"):
		return false

	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	var old_gold: int = InventoryManager.get_gold()
	var old_missions: Dictionary = MissionManager.get_save_data()
	var old_party: Dictionary = PartyManager.get_save_data()
	if gold_delta > 0:
		InventoryManager.add_gold(gold_delta)
	elif gold_delta < 0 and not InventoryManager.spend_gold(-gold_delta):
		return false
	if not PartyManager.recruit_npc("Kasum", true):
		InventoryManager.set_gold(old_gold)
		return false
	MissionManager.set_story_choice("kasum_tavern_choice", chosen_option)
	MissionManager.set_story_choice("kasum_drinking_result", result_key)
	MissionManager.update_mission_progress(KASUM_RECRUITMENT_MISSION_ID, "kasum_found", true)
	MissionManager.complete_mission(KASUM_RECRUITMENT_MISSION_ID)
	if not MissionManager.is_mission_active("hashagur_temple") and not MissionManager.is_mission_completed("hashagur_temple"):
		MissionManager.start_mission({
			"id": "hashagur_temple",
			"title": "O Templo de Hashagur",
			"description": "Descanse e, ao amanhecer, siga para o templo próximo à floresta para investigar o antigo culto."
		})
	save_data["missions"] = MissionManager.get_save_data()
	save_data["inventory"] = InventoryManager.get_save_data()
	save_data["party"] = PartyManager.get_save_data()
	var player_presets: Dictionary = save_data.get("player_presets", {})
	player_presets["hero_gold"] = InventoryManager.get_gold()
	save_data["player_presets"] = player_presets
	var completed_events: Array = save_data.get("completed_story_events", [])
	if KASUM_TAVERN_EVENT_ID not in completed_events:
		completed_events.append(KASUM_TAVERN_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	if not SaveManager.write_save_data(save_path, save_data):
		InventoryManager.set_gold(old_gold)
		MissionManager.load_save_data(old_missions)
		PartyManager.load_save_data(old_party)
		return false
	if is_instance_valid(status_label):
		status_label.text = "Kasum entrou para o grupo. Descanse antes de partir para o templo."
	return true

func play_healer_night_scene(scene_id: String) -> bool:
	var scene: Array[Dictionary] = HealerNightDatabaseScript.get_scene(scene_id)
	if scene.is_empty():
		push_warning("Cena da Casa de Cura não encontrada: " + scene_id)
		return false
	if not is_instance_valid(story_event_controller):
		create_village_story_event()
	if not is_instance_valid(story_event_controller):
		return false
	story_event_controller.move_to_front()
	await story_event_controller.start_event(
		scene_id, scene, HEALER_NIGHT_CONVERSATION_CAST, "Sir Uiliam"
	)
	return true

func begin_healer_night() -> void:
	if healer_night_running or not should_start_healer_night():
		return
	healer_night_running = true
	var curtain := ColorRect.new()
	curtain.name = "HealerNightTransition"
	curtain.color = Color(0.0, 0.0, 0.0, 0.0)
	curtain.z_index = 700
	curtain.mouse_filter = Control.MOUSE_FILTER_STOP
	curtain.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(curtain)
	var fade_in := create_tween()
	fade_in.tween_property(curtain, "color:a", 1.0, 0.35)
	await fade_in.finished
	open_location_background("healer")
	play_night_music()
	var fade_out := create_tween()
	fade_out.tween_property(curtain, "color:a", 0.0, 0.35)
	await fade_out.finished
	curtain.queue_free()
	var finished: bool = await run_healer_night_event()
	healer_night_running = false
	play_village_music()
	if not finished and is_instance_valid(status_label):
		status_label.text = "A noite na Casa de Cura não pôde ser concluída."

func run_healer_night_event() -> bool:
	if is_next_morning():
		return true
	if not MissionManager.is_mission_completed(KASUM_RECRUITMENT_MISSION_ID):
		return false
	for scene_id in ["long_day", "uiliam", "memory", "aniri_idea", "second_chance", "solitude", "goodnight"]:
		if not await play_healer_night_scene(scene_id):
			return false
	await story_event_controller.start_event("healer_night_fade", [
		{"type": "start_fade_to_black", "duration": 0.8},
		{"type": "wait_for_fade"},
		{"type": "pause", "duration": 0.5}
	])
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	var old_missions: Dictionary = MissionManager.get_save_data()
	var old_party: Dictionary = PartyManager.get_save_data()
	if not MissionManager.is_mission_active("hero_origin") and not MissionManager.is_mission_completed("hero_origin"):
		MissionManager.start_mission({
			"id": "hero_origin",
			"title": "Quem Sou Eu?",
			"category": "personal",
			"description": "Há apenas dois dias de lembranças em sua mente. Descubra sua origem e como chegou a Aviant."
		})
	if not MissionManager.is_mission_active("aniri_solitude") and not MissionManager.is_mission_completed("aniri_solitude"):
		MissionManager.start_mission({
			"id": "aniri_solitude",
			"title": "Solidão",
			"category": "companion",
			"description": "Conheça melhor Aniri, seu passado e por que teme voltar a ficar sozinha."
		})
	MissionManager.update_mission_progress("hashagur_temple", "rested", true)
	PartyManager.restore_active_party_after_rest()
	save_data["missions"] = MissionManager.get_save_data()
	save_data["party"] = PartyManager.get_save_data()
	var completed_events: Array = save_data.get("completed_story_events", [])
	if HEALER_NIGHT_EVENT_ID not in completed_events:
		completed_events.append(HEALER_NIGHT_EVENT_ID)
	save_data["completed_story_events"] = completed_events
	if not SaveManager.write_save_data(save_path, save_data):
		MissionManager.load_save_data(old_missions)
		PartyManager.load_save_data(old_party)
		return false
	refresh_village_access()
	if is_instance_valid(status_label):
		status_label.text = "Amanheceu. Volte à praça ou siga para o templo."
	return true
func start_basement_battle() -> void:
	const BASEMENT_STAGE_NUMBER: int = 2
	if not MissionManager.is_mission_active("jhon_basement") and not MissionManager.is_mission_completed("jhon_basement"):
		MissionManager.start_mission({
			"id": "jhon_basement",
			"title": "O Porão de Jhon",
			"description": "Jhon perdeu ferramentas e moedas pouco antes de ratos ocuparem seu porão.",
			"objective": "Elimine os ratos e encontre as ferramentas desaparecidas."
		})
	
	var battle_was_prepared: bool = (
		SaveManager.prepare_battle_stage(
			BASEMENT_STAGE_NUMBER
		)
	)
	
	if not battle_was_prepared:
		if is_instance_valid(status_label):
			status_label.text = (
				"Não foi possível preparar a entrada "
				+ "no porão."
			)
		
		return
	
	if is_instance_valid(status_label):
		status_label.text = (
			"O grupo está entrando no porão."
		)
	
	if MusicManage != null:
		MusicManage.fade_out_music(
			0.8
		)
	
	await get_tree().create_timer(
		0.85,
		true
	).timeout
	
	SceneTransition.change_scene_to_file(
		"res://Scene/main.tscn"
	)
func run_emerald_bridge_mayor_event() -> bool:
	const EVENT_ID := (
		"emerald_bridge_mayor_briefing"
	)
	
	const MISSION_ID := (
		"emerald_bridge"
	)
	
	if SaveManager.has_completed_story_event(
		EVENT_ID
	):
		return true
	
	if not await run_location_story_event(
		"emerald_bridge_mayor_intro",
		MAYOR_CONVERSATION_CAST,
		"Sir Uiliam"
	):
		return false

	var selected_choice: String = await show_village_story_choice(
		"Como você responderá ao convite para ir à ponte?",
		[
			{"id": "help", "button_text": "Eu vou com vocês."},
			{"id": "payment", "button_text": "Esse serviço é remunerado?"}
		]
	)
	if selected_choice != "help" and selected_choice != "payment":
		return false

	MissionManager.set_story_choice("emerald_bridge_mayor_choice", selected_choice)
	var branch_event_id: String = "emerald_bridge_choice_help"
	if selected_choice == "payment":
		branch_event_id = "emerald_bridge_choice_payment"
	if not await run_location_story_event(
		branch_event_id,
		MAYOR_CONVERSATION_CAST,
		"Sir Uiliam"
	):
		return false
	if not await run_location_story_event(
		"emerald_bridge_mayor_conclusion",
		MAYOR_CONVERSATION_CAST,
		"Sir Uiliam"
	):
		return false
	
	if not MissionManager.is_mission_active(
		MISSION_ID
	):
		MissionManager.start_mission(
			{
				"id": MISSION_ID,
				"title": "A Ponte da Esmeralda",
				"description": (
					"Jhon foi enviado para reparar a ponte acompanhado por apenas "
					+ "um guarda. A vila não possui um Selo e os ataques estão "
					+ "aumentando. Encontre Jhon e proteja-o durante os reparos."
				),
				"progress": {
					"mayor_briefing_completed": true,
					"jhon_found": false,
					"jhon_protected": false,
					"bridge_repaired": false
				}
			}
		)
	else:
		MissionManager.update_mission_progress(
			MISSION_ID,
			"mayor_briefing_completed",
			true
		)
	
	var progress_saved: bool = (
		SaveManager.save_village_state()
	)
	
	var event_saved: bool = (
		SaveManager.mark_story_event_completed(
			EVENT_ID
		)
	)
	
	return (
		progress_saved
		and event_saved
	)


func start_emerald_bridge_battle() -> void:
	const EMERALD_BRIDGE_STAGE: int = 3
	
	var battle_was_prepared: bool = (
		SaveManager.prepare_battle_stage(
			EMERALD_BRIDGE_STAGE
		)
	)
	
	if not battle_was_prepared:
		if is_instance_valid(
			status_label
		):
			status_label.text = (
				"Não foi possível preparar a viagem "
				+ "para a Ponte da Esmeralda."
			)
		
		return
	
	if is_instance_valid(
		status_label
	):
		status_label.text = (
			"O grupo está seguindo para "
			+ "a Ponte da Esmeralda."
		)
	
	if MusicManage != null:
		MusicManage.fade_out_music(
			0.8
		)
	
	await get_tree().create_timer(
		0.85,
		true
	).timeout
	
	SceneTransition.change_scene_to_file(
		"res://Scene/main.tscn"
	)
