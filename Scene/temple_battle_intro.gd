extends Control

const IntroDatabase = preload("res://Scene/temple_battle_intro_database.gd")
const ScenarioDatabase = preload("res://Scene/scenario_database.gd")
const BattleTokenVisual = preload("res://Scene/battle_unit_token.gd")
const MAP_PATH := "res://Assets/Maps/Templobatalha.jpg"
const BATTLE_MUSIC_PATH := "res://Assets/Audio/Batalha dentro templo.mp3"
const INTRO_EVENT_ID := "temple_battle_intro_seen"
const ESCAPE_MISSION_ID := "temple_escape_route"

var dialogue_box: StoryDialogBox
var background_map: TextureRect
var actor_layer: Control
var portraits: Dictionary = {}
var elite_portraits: Array[Node2D] = []
var rear_cultists: Array[Node2D] = []
var fire_wall: ColorRect
var breach_flash: ColorRect
var objective_label: Label
var start_button: Button
var story_running: bool = false


func _ready() -> void:
	GameState.current_location = "temple_hall"
	_build_background()
	_build_characters()
	_build_effects()
	_build_header()
	dialogue_box = StoryDialogBox.new()
	dialogue_box.name = "TempleBattleDialogue"
	dialogue_box.set_cinematic_mode(false)
	dialogue_box.dialogue_bottom_margin = 64
	add_child(dialogue_box)
	if MusicManage != null and MusicManage.music_player != null and ResourceLoader.exists(BATTLE_MUSIC_PATH):
		var player: AudioStreamPlayer = MusicManage.music_player
		if not player.playing or player.stream == null or player.stream.resource_path != BATTLE_MUSIC_PATH:
			MusicManage.play_music(BATTLE_MUSIC_PATH, 76.0)
	if SaveManager.has_completed_story_event(INTRO_EVENT_ID):
		_show_final_state()
	else:
		call_deferred("_play_intro")


func _build_background() -> void:
	background_map = TextureRect.new()
	background_map.name = "TempleBattleMap"
	background_map.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background_map.texture = load(MAP_PATH) as Texture2D
	background_map.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_map.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background_map.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background_map)
	var shade := ColorRect.new()
	shade.name = "BattleShade"
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.03, 0.02, 0.02, 0.25)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)


func _build_characters() -> void:
	actor_layer = Control.new()
	actor_layer.name = "TempleBattleActors"
	actor_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	actor_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(actor_layer)
	var scenario: Dictionary = ScenarioDatabase.get_scenario_data(4)
	portraits["Aventureiro"] = _make_actor(
		"Aventureiro", str(GameState.player_portrait_path), scenario["player_start"], "ally"
	)
	for npc_data in scenario["npcs"]:
		var npc_name: String = str(npc_data["display_name"])
		portraits[npc_name] = _make_actor(
			npc_name,
			BattleTokenVisual.npc_portrait_path(str(npc_data["npc_id"])),
			npc_data["position"],
			"ally"
		)
	for enemy_data in scenario["enemies"]:
		var enemy_id: String = str(enemy_data["monster_id"])
		var enemy_name: String = str(enemy_data["display_name"])
		var image_path: String = BattleTokenVisual.enemy_portrait_path(enemy_id)
		match enemy_id:
			"Guardião do Culto": image_path = "res://Assets/Characters/Cultista guerreiro.png"
			"Arqueiro do Culto": image_path = "res://Assets/Characters/Arqueiro cultista.png"
			"Ebramir": image_path = "res://Assets/Characters/Ebramir.png"
		var enemy: Node2D = _make_actor(enemy_name, image_path, enemy_data["position"], "enemy")
		enemy.visible = false
		match enemy_id:
			"Cultista": rear_cultists.append(enemy)
			"Ebramir": portraits["Ebramir"] = enemy
			_: elite_portraits.append(enemy)
	get_viewport().size_changed.connect(_layout_actors)
	_layout_actors()


func _make_actor(actor_name: String, image_path: String, grid_cell: Vector2i, faction: String) -> Node2D:
	var actor := BattleTokenVisual.new()
	actor.configure(image_path, faction, actor_name)
	actor.name = actor_name.replace(" ", "_")
	actor.set_meta("grid_cell", grid_cell)
	var name_label := Label.new()
	name_label.text = str(GameState.player_name) if actor_name == "Aventureiro" else actor_name
	name_label.position = Vector2(-72, -56)
	name_label.size = Vector2(144, 22)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 15)
	name_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	name_label.add_theme_constant_override("shadow_offset_x", 1)
	name_label.add_theme_constant_override("shadow_offset_y", 1)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	actor.add_child(name_label)
	actor_layer.add_child(actor)
	return actor


func _layout_actors() -> void:
	if not is_instance_valid(actor_layer) or not is_instance_valid(background_map) or background_map.texture == null:
		return
	var viewport_size: Vector2 = get_viewport_rect().size
	var map_size: Vector2 = background_map.texture.get_size()
	var map_scale: float = maxf(viewport_size.x / map_size.x, viewport_size.y / map_size.y)
	var map_origin: Vector2 = (viewport_size - map_size * map_scale) * 0.5
	var tile_size: int = int(ScenarioDatabase.get_scenario_data(4)["tile_size"])
	for actor_value in actor_layer.get_children():
		var actor: Node2D = actor_value as Node2D
		if actor == null or not actor.has_meta("grid_cell"):
			continue
		var grid_cell: Vector2i = actor.get_meta("grid_cell")
		actor.position = map_origin + (Vector2(grid_cell) + Vector2(0.5, 0.5)) * tile_size * map_scale
		actor.scale = Vector2.ONE * map_scale


func _build_effects() -> void:
	fire_wall = ColorRect.new()
	fire_wall.name = "FireWall"
	fire_wall.anchor_left = 0.535
	fire_wall.anchor_right = 0.575
	fire_wall.anchor_top = 0.01
	fire_wall.anchor_bottom = 0.99
	fire_wall.color = Color(1.0, 0.32, 0.04, 0.82)
	fire_wall.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fire_wall.visible = false
	add_child(fire_wall)
	breach_flash = ColorRect.new()
	breach_flash.name = "BreachFlash"
	breach_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	breach_flash.color = Color(1.0, 0.86, 0.68, 0.0)
	breach_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(breach_flash)


func _build_header() -> void:
	var header := PanelContainer.new()
	header.anchor_left = 0.02
	header.anchor_right = 0.98
	header.offset_top = 12.0
	header.offset_bottom = 80.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.02, 0.03, 0.94)
	style.border_color = Color(0.78, 0.42, 0.20)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	header.add_theme_stylebox_override("panel", style)
	add_child(header)
	var row := HBoxContainer.new()
	header.add_child(row)
	objective_label = Label.new()
	objective_label.text = "TEMPLO DE HASHAGUR — SOB ATAQUE"
	objective_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	objective_label.add_theme_font_size_override("font_size", 23)
	row.add_child(objective_label)
	start_button = Button.new()
	start_button.text = "Ir para o combate"
	start_button.custom_minimum_size = Vector2(190, 52)
	start_button.visible = false
	start_button.pressed.connect(_on_start_battle_pressed)
	row.add_child(start_button)


func _play_intro() -> void:
	if story_running:
		return
	story_running = true
	for scene_number in [8, 9]:
		for step in IntroDatabase.get_scene(scene_number):
			match str(step.get("type", "")):
				"breach":
					await _breach_wall()
				"reveal_elites":
					_reveal_actors(elite_portraits + [portraits["Ebramir"]])
				"fire_wall":
					await _raise_fire_wall()
				"reveal_cultists":
					_reveal_actors(rear_cultists)
				"dialogue":
					var speaker: String = str(step["speaker"])
					_highlight_speaker(speaker)
					await dialogue_box.show_dialog("Narrador" if speaker == "Narrador" else speaker, str(step["text"]))
	story_running = false
	objective_label.text = "ABRA UMA ROTA DE FUGA — ELIMINE 5 CULTISTAS"
	start_button.visible = true


func _breach_wall() -> void:
	breach_flash.color.a = 0.82
	var flash: Tween = create_tween()
	flash.tween_property(breach_flash, "color:a", 0.0, 0.55)
	await flash.finished


func _raise_fire_wall() -> void:
	fire_wall.visible = true
	fire_wall.modulate.a = 0.0
	var flame: Tween = create_tween()
	flame.tween_property(fire_wall, "modulate:a", 1.0, 0.45)
	await flame.finished


func _reveal_actors(actors: Array) -> void:
	for actor_value in actors:
		var actor: Node2D = actor_value as Node2D
		actor.visible = true
		actor.modulate.a = 1.0


func _highlight_speaker(speaker: String) -> void:
	var normalized: String = speaker.to_lower()
	var active_name: String = ""
	for actor_name in portraits:
		if normalized.contains(str(actor_name).to_lower()) or (actor_name == "Aventureiro" and normalized == "aventureiro"):
			active_name = actor_name
	for actor_name in portraits:
		var actor: Node2D = portraits[actor_name]
		if actor.visible:
			actor.modulate = Color.WHITE if active_name == "" or actor_name == active_name else Color(0.48, 0.48, 0.51)


func _show_final_state() -> void:
	_reveal_actors(elite_portraits + rear_cultists + [portraits["Ebramir"]])
	fire_wall.visible = true
	objective_label.text = "ABRA UMA ROTA DE FUGA — ELIMINE 5 CULTISTAS"
	start_button.visible = true


func _on_start_battle_pressed() -> void:
	if story_running:
		return
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		objective_label.text = "Não foi possível encontrar o save para iniciar a batalha."
		return
	var previous_missions: Dictionary = MissionManager.get_save_data()
	if not MissionManager.is_mission_active(ESCAPE_MISSION_ID) and not MissionManager.is_mission_completed(ESCAPE_MISSION_ID):
		MissionManager.start_mission({
			"id": ESCAPE_MISSION_ID,
			"title": "Abra uma rota de fuga",
			"description": "A muralha de fogo separou o grupo de Hashagur. Elimine os cinco cultistas que bloqueiam a saída do templo."
		})
	var events: Array = save_data.get("completed_story_events", [])
	if INTRO_EVENT_ID not in events:
		events.append(INTRO_EVENT_ID)
	save_data["completed_story_events"] = events
	save_data["missions"] = MissionManager.get_save_data()
	save_data["current_stage"] = 4
	save_data["current_location"] = "battle"
	if not SaveManager.write_save_data(save_path, save_data):
		MissionManager.load_save_data(previous_missions)
		objective_label.text = "Não foi possível salvar o início da batalha. Tente novamente."
		return
	GameState.selected_stage = 4
	GameState.current_location = "battle"
	GameState.should_load_save = true
	SceneTransition.change_scene_to_file("res://Scene/main.tscn")
