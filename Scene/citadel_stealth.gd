extends Node2D

const Rules = preload("res://Scene/citadel_stealth_rules.gd")
const CitadelStory = preload("res://Scene/citadel_story_database.gd")
const FogScript = preload("res://Scene/citadel_fog.gd")
const MovementOverlayScript = preload("res://Scene/citadel_movement_overlay.gd")
const NpcDatabase = preload("res://Scene/npc_database.gd")
const WORLD_MAP_SCENE := "res://Scene/world_map.tscn"
const TEMPLE_HALL_SCENE := "res://Scene/temple_hall.tscn"
const STEALTH_MUSIC_PATH := "res://Assets/Audio/Temafurtivo.mp3"
const ANIRI_PORTRAIT := "res://Assets/Characters/AniriLadina.png"
const CULTIST_PORTRAIT := "res://Assets/Characters/Cultista1.png"
const GLASS_SOUND_PATH := "res://Assets/Audio/SFX/Caco de vidro.mp3"
const GLASS_WARNING := "Droga, lugar imundo! Tem cacos no chão. Devo tomar cuidado para não chamar atenção. Agora deve ter alguém vindo ver."

var player_cell: Vector2i = Rules.START
var movement_left: int = Rules.PLAYER_MOVE_TILES
var round_number: int = 1
var moving: bool = false
var failed: bool = false
var completed: bool = false
var is_stealthed: bool = false
var bedroom_clue_found: bool = false
var strategy_clue_found: bool = false
var escape_phase: bool = false
var chest_claimed: bool = false
var chest_reward_paid: bool = false
var pending_noise: Vector2i = Vector2i(-1, -1)
var guards: Array[Dictionary] = []
var visible_cells: Dictionary = {}
var explored_cells: Dictionary = {}
var danger_cells: Dictionary = {}
var observation_exposure: Dictionary = {}
var last_perception_feedback: String = ""

var camera: Camera2D
var fog: Node2D
var movement_overlay: Node2D
var glass_sound: AudioStreamPlayer
var player_token: Panel
var guard_tokens: Array[Panel] = []
var clue_markers: Dictionary = {}
var status_label: Label
var objective_label: Label
var turn_label: Label
var hide_button: Button
var end_turn_button: Button
var retry_button: Button
var leave_button: Button
var dialogue_box: StoryDialogBox
var capture_dialog: ConfirmationDialog


func _ready() -> void:
	GameState.current_location = "citadel"
	_start_stealth_music()
	for problem in Rules.validate_layout():
		push_error(problem)
	_build_world()
	_build_interface()
	dialogue_box = StoryDialogBox.new()
	dialogue_box.name = "CitadelStoryDialogue"
	add_child(dialogue_box)
	capture_dialog = ConfirmationDialog.new()
	capture_dialog.name = "AniriCapturada"
	capture_dialog.title = "Aniri foi capturada"
	capture_dialog.dialog_text = "Os cultistas viram Aniri. Ela foi capturada e morta.\nDeseja tentar novamente?"
	capture_dialog.ok_button_text = "Tentar novamente"
	capture_dialog.cancel_button_text = "Voltar ao mapa"
	capture_dialog.confirmed.connect(_on_retry_pressed)
	capture_dialog.canceled.connect(_on_leave_pressed)
	add_child(capture_dialog)
	_load_progress()
	_create_guards()
	_refresh_vision()
	_refresh_interface()
	_set_status("Aniri entrou pelo corredor superior. Investigue o quarto com cama e mesa e a sala da mesa com seis tocos. Toque numa casa visível para andar sem ser percebida.")
	if MissionManager.is_mission_completed(Rules.MISSION_ID):
		completed = true
		_set_status("A infiltração já foi concluída. Você pode voltar ao mapa.")
		_refresh_interface()
	else:
		moving = true
		_refresh_interface()
		call_deferred("_play_arrival")


func _play_arrival() -> void:
	await _play_story_sequence(CitadelStory.get_arrival())
	moving = false
	_set_status("Explore a cidadela sem ser vista. Encontre primeiro o relatório no quarto com cama e mesa.")
	_refresh_interface()


func _play_story_sequence(steps: Array[Dictionary]) -> void:
	for step in steps:
		await dialogue_box.show_dialog(str(step["speaker"]), str(step["text"]))


func _start_stealth_music() -> void:
	if MusicManage.music_player == null:
		return
	var player: AudioStreamPlayer = MusicManage.music_player
	if not player.playing or player.stream == null or player.stream.resource_path != STEALTH_MUSIC_PATH:
		MusicManage.play_music(STEALTH_MUSIC_PATH, 70.0)


func _build_world() -> void:
	var artwork := Sprite2D.new()
	artwork.name = "Cidadela"
	artwork.texture = load(Rules.MAP_PATH) as Texture2D
	artwork.centered = false
	add_child(artwork)
	fog = FogScript.new()
	fog.name = "NevoaDeGuerra"
	add_child(fog)
	movement_overlay = MovementOverlayScript.new()
	movement_overlay.name = "CasasDeMovimento"
	add_child(movement_overlay)
	for clue_id in ["bedroom", "strategy", "exit"]:
		var marker: Label = Label.new()
		marker.name = "Marker_" + clue_id
		marker.text = "↩" if clue_id == "exit" else "◆"
		marker.add_theme_font_size_override("font_size", 32)
		marker.add_theme_color_override("font_color", Color(0.45, 1.0, 0.67) if clue_id == "exit" else Color(1.0, 0.88, 0.32))
		marker.add_theme_color_override("font_shadow_color", Color.BLACK)
		marker.add_theme_constant_override("shadow_offset_x", 2)
		marker.add_theme_constant_override("shadow_offset_y", 2)
		marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var cell: Vector2i = _marker_cell(clue_id)
		marker.position = Rules.cell_center(cell) - Vector2(14, 23)
		add_child(marker)
		clue_markers[clue_id] = marker
	glass_sound = AudioStreamPlayer.new()
	glass_sound.name = "CacosDeVidro"
	glass_sound.stream = load(GLASS_SOUND_PATH) as AudioStream
	glass_sound.volume_db = -3.0
	add_child(glass_sound)
	player_token = _make_token("Aniri", Color(0.10, 0.52, 0.74), ANIRI_PORTRAIT)
	player_token.position = Rules.cell_center(player_cell) - Vector2(24, 24)
	add_child(player_token)
	camera = Camera2D.new()
	camera.name = "CameraAniri"
	camera.position = Rules.cell_center(player_cell)
	camera.enabled = true
	camera.zoom = Vector2(1.4, 1.4)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = Rules.MAP_SIZE.x
	camera.limit_bottom = Rules.MAP_SIZE.y
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	add_child(camera)


func _make_token(title: String, tint: Color, portrait_path: String) -> Panel:
	var token := Panel.new()
	token.custom_minimum_size = Vector2(48, 48)
	token.size = Vector2(48, 48)
	token.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = tint
	style.border_color = Color(1.0, 0.89, 0.61)
	style.set_border_width_all(3)
	style.set_corner_radius_all(24)
	token.add_theme_stylebox_override("panel", style)
	if ResourceLoader.exists(portrait_path):
		var image := TextureRect.new()
		image.texture = load(portrait_path) as Texture2D
		image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		token.add_child(image)
	var label := Label.new()
	label.text = title
	label.position = Vector2(-38, -26)
	label.custom_minimum_size = Vector2(124, 24)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	token.add_child(label)
	return token


func _create_guards() -> void:
	for definition in Rules.GUARDS:
		var route: Array = definition["route"]
		var direction: Vector2i = route[1] - route[0]
		var guard: Dictionary = {
			"name": definition["name"], "role": definition["role"],
			"cell": definition["start"], "route": route,
			"waypoint": 1, "facing": direction,
			"investigating": false, "noise_target": Vector2i(-1, -1)
		}
		guards.append(guard)
		var token: Panel = _make_token(definition["name"], Color(0.70, 0.10, 0.13), CULTIST_PORTRAIT)
		token.position = Rules.cell_center(guard["cell"]) - Vector2(24, 24)
		add_child(token)
		guard_tokens.append(token)


func _build_interface() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "Interface"
	add_child(canvas)
	var ui := Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(ui)
	var top := PanelContainer.new()
	top.anchor_left = 0.01
	top.anchor_right = 0.99
	top.offset_top = 8.0
	top.offset_bottom = 102.0
	top.add_theme_stylebox_override("panel", _panel_style())
	ui.add_child(top)
	var top_box := VBoxContainer.new()
	top_box.add_theme_constant_override("separation", 2)
	top.add_child(top_box)
	turn_label = Label.new()
	turn_label.add_theme_font_size_override("font_size", 20)
	turn_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.51))
	top_box.add_child(turn_label)
	objective_label = Label.new()
	objective_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective_label.add_theme_font_size_override("font_size", 17)
	top_box.add_child(objective_label)
	status_label = Label.new()
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 16)
	top_box.add_child(status_label)
	var bottom := PanelContainer.new()
	bottom.anchor_left = 0.01
	bottom.anchor_right = 0.99
	bottom.anchor_top = 1.0
	bottom.anchor_bottom = 1.0
	bottom.offset_top = -84.0
	bottom.offset_bottom = -8.0
	bottom.add_theme_stylebox_override("panel", _panel_style())
	ui.add_child(bottom)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	bottom.add_child(row)
	hide_button = _action_button("Esconder-se", row, _on_hide_pressed)
	end_turn_button = _action_button("Encerrar turno", row, _on_end_turn_pressed)
	retry_button = _action_button("Tentar novamente", row, _on_retry_pressed)
	leave_button = _action_button("Voltar ao mapa", row, _on_leave_pressed)


func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.035, 0.045, 0.95)
	style.border_color = Color(0.74, 0.57, 0.25)
	style.set_border_width_all(2)
	style.set_corner_radius_all(9)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style


func _action_button(title: String, container: HBoxContainer, callback: Callable) -> Button:
	var button := Button.new()
	button.text = title
	button.custom_minimum_size = Vector2(138, 55)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(callback)
	container.add_child(button)
	return button


func _unhandled_input(event: InputEvent) -> void:
	if moving or failed or completed:
		return
	var screen_position := Vector2.ZERO
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
			return
		screen_position = mouse_event.position
	elif event is InputEventScreenTouch:
		var touch_event: InputEventScreenTouch = event as InputEventScreenTouch
		if not touch_event.pressed:
			return
		screen_position = touch_event.position
	else:
		return
	var world_position: Vector2 = get_canvas_transform().affine_inverse() * screen_position
	var target := Vector2i(floori(world_position.x / Rules.TILE_SIZE), floori(world_position.y / Rules.TILE_SIZE))
	if not Rules.inside(target) or target == player_cell:
		return
	if not visible_cells.has(target):
		_set_status("Aniri ainda não consegue ver essa casa. Avance até a borda da área visível.")
		return
	_move_player_to(target)


func _move_player_to(target: Vector2i) -> void:
	if movement_left <= 0:
		_set_status("Aniri já se moveu neste turno. Toque em Encerrar turno.")
		return
	var occupied: Array[Vector2i] = []
	for guard in guards:
		occupied.append(guard["cell"])
	var route: Array[Vector2i] = Rules.path(player_cell, target, occupied)
	if route.is_empty():
		_set_status("Não há passagem até essa casa. Paredes, móveis e cultistas bloqueiam o caminho.")
		return
	if route.size() > movement_left:
		_set_status("Essa casa está longe demais para este turno. Restam %d casas de movimento." % movement_left)
		return
	moving = true
	_refresh_interface()
	for step in route:
		var previous: Vector2i = player_cell
		await _animate_token(player_token, step)
		player_cell = step
		movement_left -= 1
		camera.position = Rules.cell_center(player_cell)
		_refresh_vision()
		if step in Rules.GLASS and step != previous:
			await _queue_noise(step)
		if _check_detection():
			break
		if await _collect_nearby():
			break
	moving = false
	_refresh_interface()


func _animate_token(token: Panel, cell: Vector2i) -> void:
	var tween := create_tween()
	tween.tween_property(token, "position", Rules.cell_center(cell) - Vector2(24, 24), 0.17)
	await tween.finished


func _queue_noise(cell: Vector2i) -> void:
	if pending_noise.x < 0:
		pending_noise = cell
	if is_instance_valid(glass_sound) and glass_sound.stream != null:
		glass_sound.stop()
		glass_sound.play()
		var sound_length: float = glass_sound.stream.get_length()
		if sound_length > 0.0:
			await get_tree().create_timer(sound_length, false).timeout
	_set_status("Cacos de vidro! O cultista mais próximo investigará o barulho no próximo turno.")
	await dialogue_box.show_dialog("Aniri", GLASS_WARNING)


func _on_hide_pressed() -> void:
	if moving or failed or completed:
		return
	if not Rules.cover_near(player_cell):
		_set_status("Aproxime-se de caixas, barris, camas ou mesas para se esconder.")
		return
	is_stealthed = true
	movement_left = 0
	observation_exposure.clear()
	last_perception_feedback = ""
	_set_status("Aniri está escondida. Pode avançar em furtividade no próximo turno; cultistas em visão farão um teste de Observar.")
	_check_detection()
	_refresh_interface()


func _on_end_turn_pressed() -> void:
	if moving or failed or completed:
		return
	moving = true
	last_perception_feedback = ""
	_refresh_interface()
	if pending_noise.x >= 0:
		_assign_noise_investigation(pending_noise)
		pending_noise = Vector2i(-1, -1)
	for index in range(guards.size()):
		turn_label.text = "Rodada %d — %s" % [round_number, guards[index]["name"]]
		await _take_guard_turn(index)
		if failed:
			break
	if not failed:
		round_number += 1
		movement_left = Rules.PLAYER_MOVE_TILES
		moving = false
		_refresh_vision()
		var turn_hint: String = "Sua vez. Volte ao túnel de entrada sem ser vista." if escape_phase else "Sua vez. Observe os cultistas e avance até as informações."
		_set_status(last_perception_feedback if not last_perception_feedback.is_empty() else turn_hint)
	_refresh_interface()


func _assign_noise_investigation(cell: Vector2i) -> void:
	var nearest_index: int = -1
	var best_distance: int = 1000000
	var best_target: Vector2i = cell
	for index in range(guards.size()):
		var candidate: Dictionary = _noise_destination(index, cell)
		if candidate.is_empty():
			continue
		if int(candidate["steps"]) < best_distance:
			best_distance = int(candidate["steps"])
			nearest_index = index
			best_target = candidate["cell"]
	if nearest_index >= 0:
		guards[nearest_index]["investigating"] = true
		guards[nearest_index]["noise_target"] = best_target
		_set_status("%s ouviu o vidro e vai verificar o local." % guards[nearest_index]["name"])
	else:
		_set_status("O barulho ecoou, mas nenhum cultista alcança esse corredor.")


func _noise_destination(index: int, noise_cell: Vector2i) -> Dictionary:
	var occupied: Array[Vector2i] = [player_cell]
	for other_index in range(guards.size()):
		if other_index != index:
			occupied.append(guards[other_index]["cell"])
	var best: Dictionary = {}
	for offset in [Vector2i.ZERO, Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
		var candidate: Vector2i = noise_cell + offset
		if Rules.blocked(candidate) or candidate in occupied:
			continue
		var route: Array[Vector2i] = Rules.path(guards[index]["cell"], candidate, occupied)
		if route.is_empty() and guards[index]["cell"] != candidate:
			continue
		if best.is_empty() or route.size() < int(best["steps"]):
			best = {"cell": candidate, "steps": route.size()}
	return best


func _take_guard_turn(index: int) -> void:
	var guard: Dictionary = guards[index]
	var target: Vector2i
	if guard["investigating"]:
		target = guard["noise_target"]
	else:
		target = guard["route"][guard["waypoint"]]
	var occupied: Array[Vector2i] = [player_cell]
	for other_index in range(guards.size()):
		if other_index != index:
			occupied.append(guards[other_index]["cell"])
	var route: Array[Vector2i] = Rules.path(guard["cell"], target, occupied)
	if _check_guard_detection(index):
		return
	if guard["investigating"] and route.is_empty() and guard["cell"] != target:
		var alternate: Dictionary = _noise_destination(index, target)
		if not alternate.is_empty():
			target = alternate["cell"]
			guard["noise_target"] = target
			route = Rules.path(guard["cell"], target, occupied)
	for step_index in range(mini(route.size(), Rules.GUARD_MOVE_TILES + (1 if escape_phase else 0))):
		var step: Vector2i = route[step_index]
		guard["facing"] = step - guard["cell"]
		await _animate_token(guard_tokens[index], step)
		guard["cell"] = step
		guards[index] = guard
		_refresh_vision()
		if _check_guard_detection(index):
			return
	if guard["cell"] == target:
		if guard["investigating"]:
			guard["investigating"] = false
			guard["noise_target"] = Vector2i(-1, -1)
		else:
			guard["waypoint"] = (int(guard["waypoint"]) + 1) % guard["route"].size()
		guards[index] = guard
	_refresh_vision()


func _check_guard_detection(index: int) -> bool:
	var guard: Dictionary = guards[index]
	if not _guard_threatens_cell(guard, player_cell):
		observation_exposure.erase(index)
		return false
	if is_stealthed:
		if observation_exposure.has(index):
			return false
		observation_exposure[index] = true
		var aniri: Dictionary = NpcDatabase.get_aniri()
		var cultist: Dictionary = MonsterDatabase.get_monster_data("Cultista")
		var hide_bonus: int = floori((int(aniri.get("dexterity", 10)) - 10) / 2.0) + int(aniri.get("hide_bonus", 0))
		if "Passos de Veludo" in aniri.get("feats", []):
			hide_bonus += 2
		var observe_bonus: int = int(cultist.get("observe_bonus", 0)) + floori((int(cultist.get("wisdom", 10)) - 10) / 2.0)
		var observe_roll: int = randi_range(1, 20)
		var hide_roll: int = randi_range(1, 20)
		var observe_total: int = observe_roll + observe_bonus
		var hide_total: int = hide_roll + hide_bonus
		if not Rules.observe_succeeds(observe_roll, observe_bonus, hide_roll, hide_bonus):
			last_perception_feedback = "%s: Observar %d × Esconder-se %d — Aniri passou despercebida." % [guard["name"], observe_total, hide_total]
			_set_status(last_perception_feedback)
			return false
		is_stealthed = false
		_fail_mission("%s: Observar %d × Esconder-se %d — Aniri foi vista." % [guard["name"], observe_total, hide_total])
		return true
	_fail_mission("%s percebeu Aniri. A infiltração exige que ninguém a veja." % guard["name"])
	return true


func _check_detection() -> bool:
	for index in range(guards.size()):
		if _check_guard_detection(index):
			return true
	return false


func _fail_mission(message: String) -> void:
	failed = true
	moving = false
	_set_status(message + " Aniri foi capturada e morta.")
	_refresh_interface()
	if is_instance_valid(capture_dialog):
		capture_dialog.popup_centered(Vector2i(760, 260))


func _can_interact_with_chest() -> bool:
	return Rules.adjacent_or_same(player_cell, Rules.CHEST) and Rules.has_line_of_sight(player_cell, Rules.CHEST)


func _collect_nearby() -> bool:
	if not bedroom_clue_found and Rules.adjacent_or_same(player_cell, Rules.BEDROOM_CLUE) and Rules.has_line_of_sight(player_cell, Rules.BEDROOM_CLUE):
		bedroom_clue_found = true
		_refresh_interface()
		await _play_story_sequence(CitadelStory.get_bedroom_report())
		_set_status("Relatório de Ebramir encontrado. Procure a ordem do culto na mesa com seis tocos.")
		return true
	if bedroom_clue_found and not strategy_clue_found and Rules.adjacent_or_same(player_cell, Rules.STRATEGY_CLUE) and Rules.has_line_of_sight(player_cell, Rules.STRATEGY_CLUE):
		strategy_clue_found = true
		_refresh_interface()
		await _play_story_sequence(CitadelStory.get_strategy_report())
		escape_phase = true
		_set_status("O culto já marchou contra o templo! Fuja pelo túnel de entrada e avise o grupo. As patrulhas estão mais rápidas.")
		return true
	if not chest_claimed and _can_interact_with_chest():
		await _claim_chest()
		return true
	if escape_phase and player_cell == Rules.START:
		_complete_mission()
		return true
	_refresh_interface()
	return false


func _claim_chest() -> void:
	chest_claimed = true
	var reward_message: String = "Você encontrou um baú com 50 peças de ouro. Conclua a infiltração para receber a recompensa."
	_set_status(reward_message)
	await dialogue_box.show_dialog("Narrador", reward_message)
	_refresh_interface()


func _load_progress() -> void:
	var save_data: Dictionary = SaveManager.read_save_data(SaveManager.get_active_save_path())
	_restore_chest_state(save_data.get("citadel_stealth", {}))
	# As pistas só valem ao concluir uma infiltração sem ser visto.
	bedroom_clue_found = false
	strategy_clue_found = false
	escape_phase = false


func _restore_chest_state(progress: Dictionary) -> void:
	# O baú pertence à tentativa atual. Saves antigos já entregaram o ouro ao coletá-lo.
	chest_claimed = false
	chest_reward_paid = bool(progress.get("chest_reward_paid", progress.get("chest_claimed", false)))


func _chest_gold_due() -> bool:
	return chest_claimed and not chest_reward_paid


func _save_progress() -> bool:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return false
	save_data["citadel_stealth"] = {"chest_reward_paid": chest_reward_paid}
	save_data["inventory"] = InventoryManager.get_save_data()
	save_data["missions"] = MissionManager.get_save_data()
	save_data["world_map_node"] = "citadel"
	save_data["current_location"] = "citadel"
	var presets: Dictionary = save_data.get("player_presets", {})
	presets["hero_gold"] = InventoryManager.get_gold()
	save_data["player_presets"] = presets
	return SaveManager.write_save_data(save_path, save_data)


func _complete_mission() -> void:
	var old_missions: Dictionary = MissionManager.get_save_data()
	var previous_gold: int = InventoryManager.get_gold()
	var reward_was_paid: bool = chest_reward_paid
	if MissionManager.is_mission_active(Rules.MISSION_ID):
		MissionManager.update_mission_progress(Rules.MISSION_ID, "bedroom_information", true)
		MissionManager.update_mission_progress(Rules.MISSION_ID, "strategy_information", true)
		MissionManager.update_mission_description(Rules.MISSION_ID, "Aniri encontrou o relatório de Ebramir sobre a fenda próxima a Montirel e a ordem de atacar o templo antes do amanhecer. Ela escapou sem ser descoberta; avise o grupo.")
		MissionManager.complete_mission(Rules.MISSION_ID)
	var awarded_chest_gold: bool = _chest_gold_due()
	if awarded_chest_gold:
		InventoryManager.add_gold(50)
		chest_reward_paid = true
	if not _save_progress():
		MissionManager.load_save_data(old_missions)
		InventoryManager.set_gold(previous_gold)
		chest_reward_paid = reward_was_paid
		failed = true
		_set_status("As pistas foram encontradas, mas não foi possível salvar. Tente a infiltração novamente.")
		_refresh_interface()
		return
	completed = true
	moving = false
	_set_status("Missão concluída: Aniri voltou pelo túnel com as duas informações.%s Volte ao mapa para avisar o grupo." % (" Baú: +50 peças de ouro." if awarded_chest_gold else ""))
	_refresh_interface()


func _refresh_vision() -> void:
	visible_cells.clear()
	for y in range(Rules.GRID_SIZE.y):
		for x in range(Rules.GRID_SIZE.x):
			var cell := Vector2i(x, y)
			if Rules.can_see(player_cell, cell, Rules.ANIRI_VISION_METERS):
				visible_cells[cell] = true
				explored_cells[cell] = true
	danger_cells.clear()
	for guard in guards:
		if not visible_cells.has(guard["cell"]):
			continue
		for cell in visible_cells:
			if _guard_threatens_cell(guard, cell):
				danger_cells[cell] = true
	fog.set_visibility(visible_cells, explored_cells, danger_cells)
	for index in range(guards.size()):
		guard_tokens[index].visible = visible_cells.has(guards[index]["cell"])
		guard_tokens[index].modulate = Color(1.0, 0.75, 0.42) if guards[index]["investigating"] else Color.WHITE
	_refresh_markers()


func _guard_threatens_cell(guard: Dictionary, cell: Vector2i) -> bool:
	var location: Vector2i = guard["cell"]
	if not Rules.can_see(location, cell, Rules.CULTIST_VISION_METERS, true):
		return false
	if Rules.distance_meters(location, cell) <= Rules.METERS_PER_TILE:
		return true
	var facing: Vector2 = Vector2(guard["facing"]).normalized()
	var direction: Vector2 = Vector2(cell - location).normalized()
	return facing.dot(direction) >= Rules.VISION_CONE_DOT


func _marker_cell(clue_id: String) -> Vector2i:
	match clue_id:
		"exit":
			return Rules.START
		"bedroom":
			return Rules.BEDROOM_CLUE
		"strategy":
			return Rules.STRATEGY_CLUE
		_:
			return Rules.CHEST


func _refresh_markers() -> void:
	for clue_id in clue_markers:
		var marker: CanvasItem = clue_markers[clue_id]
		var cell: Vector2i = _marker_cell(clue_id)
		if completed:
			marker.visible = false
		elif clue_id == "exit":
			marker.visible = escape_phase and explored_cells.has(cell)
		elif clue_id == "strategy" and not bedroom_clue_found:
			marker.visible = false
		else:
			var done: bool = (clue_id == "bedroom" and bedroom_clue_found) or (clue_id == "strategy" and strategy_clue_found)
			marker.visible = visible_cells.has(cell) and not done


func _refresh_movement_overlay() -> void:
	if not is_instance_valid(movement_overlay):
		return
	var display_cells: Dictionary = {}
	if not moving and not failed and not completed and movement_left > 0:
		var occupied: Array[Vector2i] = []
		for guard in guards:
			occupied.append(guard["cell"])
		for cell in Rules.reachable_cells(player_cell, movement_left, occupied):
			if visible_cells.has(cell):
				display_cells[cell] = true
	movement_overlay.set_reachable(display_cells)


func _refresh_interface() -> void:
	if not is_instance_valid(turn_label):
		return
	if is_instance_valid(player_token):
		player_token.modulate = Color(0.62, 1.0, 0.78, 0.52) if is_stealthed else Color.WHITE
	if not moving or failed or completed:
		turn_label.text = "CIDADELA — Rodada %d | Aniri: %d casas de movimento" % [round_number, movement_left]
	var alert: String = ""
	for guard in guards:
		if guard["investigating"]:
			alert = "  |  %s investigando" % guard["name"]
			break
	var objective: String = "Infiltração concluída" if completed else ("FUJA: volte à seta verde no túnel" if escape_phase else ("Encontre a ordem de ataque" if bedroom_clue_found else "Encontre o relatório no quarto"))
	objective_label.text = "%s  |  Pistas %d/2  |  Baú %s  |  Vermelho: visão (6 m)%s%s" % [objective, int(bedroom_clue_found) + int(strategy_clue_found), "✓" if chest_claimed else "?", "  |  Escondida" if is_stealthed else "", alert]
	hide_button.disabled = moving or failed or completed or is_stealthed or not Rules.cover_near(player_cell)
	end_turn_button.disabled = moving or failed or completed
	retry_button.visible = failed
	leave_button.visible = not moving
	leave_button.text = "Voltar ao templo" if completed else "Voltar ao mapa"
	_refresh_markers()
	_refresh_movement_overlay()


func _set_status(message: String) -> void:
	if is_instance_valid(status_label):
		status_label.text = message


func _on_retry_pressed() -> void:
	SceneTransition.change_scene_to_file("res://Scene/citadel_stealth.tscn")


func _on_leave_pressed() -> void:
	if moving:
		return
	if MusicManage.music_player != null and MusicManage.music_player.stream != null and MusicManage.music_player.stream.resource_path == STEALTH_MUSIC_PATH:
		MusicManage.stop_music()
	GameState.current_location = "temple_hall" if completed else "citadel"
	SceneTransition.change_scene_to_file(TEMPLE_HALL_SCENE if completed else WORLD_MAP_SCENE)
