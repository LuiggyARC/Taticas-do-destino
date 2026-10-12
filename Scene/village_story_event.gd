extends Control
class_name VillageStoryEvent

const STORY_VIDEO_ASPECT_RATIO: float = 16.0 / 9.0


signal event_finished(event_id: String)
signal story_video_ended


var story_dialog: StoryDialogBox
var black_overlay: ColorRect
var video_player: VideoStreamPlayer
var skip_video_button: Button
var waiting_for_video: bool = false

var active_fade_tween: Tween
var event_running: bool = false
var current_event_id: String = ""
var fixed_cast_active: bool = false


func _ready() -> void:
	name = "VillageStoryEvent"
	z_index = 500
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	create_interface()
	resized.connect(update_video_layout)
	update_video_layout()
	
	visible = false


func create_interface() -> void:
	black_overlay = ColorRect.new()
	black_overlay.name = "StoryBlackOverlay"
	
	black_overlay.color = Color(
		0.0,
		0.0,
		0.0,
		0.0
	)
	
	black_overlay.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	black_overlay.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	
	add_child(
		black_overlay
	)
	
	video_player = VideoStreamPlayer.new()
	video_player.name = "StoryVideoPlayer"
	
	video_player.process_mode = (
		Node.PROCESS_MODE_ALWAYS
	)
	
	video_player.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	video_player.expand = true
	video_player.autoplay = false
	
	video_player.set_anchors_preset(Control.PRESET_TOP_LEFT)
	
	add_child(
		video_player
	)
	
	video_player.visible = false
	video_player.finished.connect(_on_story_video_finished)
	
	skip_video_button = Button.new()
	skip_video_button.name = "SkipStoryVideoButton"
	skip_video_button.text = "Pular introdução"
	skip_video_button.process_mode = Node.PROCESS_MODE_ALWAYS
	skip_video_button.mouse_filter = Control.MOUSE_FILTER_STOP
	skip_video_button.add_theme_font_size_override("font_size", 22)
	skip_video_button.anchor_left = 1.0
	skip_video_button.anchor_right = 1.0
	skip_video_button.offset_left = -220.0
	skip_video_button.offset_right = -24.0
	skip_video_button.offset_top = 24.0
	skip_video_button.offset_bottom = 84.0
	var skip_style := StyleBoxFlat.new()
	skip_style.bg_color = Color(0.05, 0.05, 0.07, 0.92)
	skip_style.border_color = Color(0.82, 0.62, 0.26)
	skip_style.set_border_width_all(2)
	skip_style.set_corner_radius_all(8)
	skip_video_button.add_theme_stylebox_override("normal", skip_style)
	skip_video_button.add_theme_stylebox_override("hover", skip_style)
	skip_video_button.add_theme_stylebox_override("pressed", skip_style)
	skip_video_button.pressed.connect(_on_skip_story_video_pressed)
	add_child(skip_video_button)
	skip_video_button.visible = false
	
	story_dialog = StoryDialogBox.new()
	story_dialog.name = "VillageStoryDialog"
	story_dialog.set_cinematic_mode(true)
	
	add_child(
		story_dialog
	)

func update_video_layout() -> void:
	if not is_instance_valid(video_player):
		return
	if size.x <= 0.0 or size.y <= 0.0:
		return
	var video_width: float = minf(size.x, size.y * STORY_VIDEO_ASPECT_RATIO)
	var video_size := Vector2(video_width, video_width / STORY_VIDEO_ASPECT_RATIO)
	video_player.size = video_size
	video_player.position = (size - video_size) / 2.0


func start_event(
	event_id: String,
	event_sequence: Array[Dictionary],
	portrait_cast: Array[String] = [],
	lead_speaker: String = ""
) -> void:
	if event_running:
		return
	
	if event_sequence.is_empty():
		return
	
	event_running = true
	current_event_id = event_id
	fixed_cast_active = not portrait_cast.is_empty()
	story_dialog.set_player_portrait_on_right(event_id == "tavern_uiliam_history")
	
	visible = true
	move_to_front()
	var participants: Array[String] = []
	var speaker_counts: Dictionary = {}
	for step in event_sequence:
		if str(step.get("type", "")) != "dialogue":
			continue
		var participant: String = str(step.get("speaker", "")).strip_edges()
		if participant == "":
			continue
		if not participants.has(participant):
			participants.append(participant)
		var speaker_key: String = participant.to_lower()
		speaker_counts[speaker_key] = int(speaker_counts.get(speaker_key, 0)) + 1
	story_dialog.set_conversation_cast(portrait_cast if fixed_cast_active else participants)
	if fixed_cast_active:
		# A ordem do elenco fixa as posições mesmo entre trechos da mesma conversa.
		speaker_counts.clear()
		for cast_index in range(portrait_cast.size()):
			speaker_counts[portrait_cast[cast_index].strip_edges().to_lower()] = 1000 - cast_index
	elif lead_speaker.strip_edges() != "":
		speaker_counts[lead_speaker.strip_edges().to_lower()] = 1000
	story_dialog.set_conversation_weights(speaker_counts)
	
	reset_visual_state()
	
	for event_step in event_sequence:
		await execute_event_step(
			event_step
		)
	
	var finished_event_id: String = (
		current_event_id
	)
	
	event_running = false
	current_event_id = ""
	fixed_cast_active = false
	story_dialog.set_conversation_cast([])
	story_dialog.set_conversation_weights({})
	story_dialog.set_player_portrait_on_right(false)
	
	reset_visual_state()
	visible = false
	
	event_finished.emit(
		finished_event_id
	)


func execute_event_step(
	event_step: Dictionary
) -> void:
	var step_type: String = str(
		event_step.get("type", "")
	)
	
	match step_type:
		"dialogue":
			if event_step.has("cast") and not fixed_cast_active:
				var cast: Array = event_step.get("cast", [])
				story_dialog.set_conversation_cast(cast)
			var speaker_name: String = str(
				event_step.get(
					"speaker",
					"História"
				)
			)
			var dialogue_text: String = str(
				event_step.get(
					"text",
					""
				)
			)
			
			await show_story_dialogue(
				speaker_name,
				dialogue_text
			)
		
		"action":
			var action_text: String = str(
				event_step.get(
					"text",
					""
				)
			)
			
			await show_story_dialogue(
				"Ação",
				action_text
			)
		
		"start_fade_to_black":
			var fade_duration: float = float(
				event_step.get(
					"duration",
					1.5
				)
			)
			start_fade_to_black(fade_duration)
		
		"wait_for_fade":
			await wait_for_active_fade()
		
		"fade_from_black":
			var fade_duration: float = float(
				event_step.get(
					"duration",
					1.5
				)
			)
			await fade_from_black(fade_duration)
		
		"video":
			var video_path: String = str(
				event_step.get(
					"video_path",
					""
				)
			)
			await play_story_video(video_path)
		
		"start_music":
			var music_path: String = str(
				event_step.get(
					"music_path",
					""
				)
			)
			var volume_percent: float = float(
				event_step.get(
					"volume_percent",
					75.0
				)
			)
			start_story_music(
				music_path,
				volume_percent
			)
		
		"pause":
			var pause_duration: float = float(
				event_step.get(
					"duration",
					0.5
				)
			)
			await wait_story_time(
				pause_duration
			)
			
func start_story_music(
	music_path: String,
	volume_percent: float
) -> void:
	if music_path.strip_edges() == "":
		return
	
	if MusicManage == null:
		return
	
	MusicManage.play_music(
		music_path,
		volume_percent
	)

func show_story_dialogue(
	speaker_name: String,
	dialogue_text: String
) -> void:
	if dialogue_text.strip_edges() == "":
		return
	
	if not is_instance_valid(story_dialog):
		return
	
	var player_name: String = str(
		GameState.player_name
	).strip_edges()
	
	if player_name == "":
		player_name = "Herói"
	
	var normalized_speaker_name: String = (
		speaker_name.strip_edges().to_lower()
	)
	
	var resolved_speaker_name: String = (
		speaker_name.replace(
			"[PLAYER_NAME]",
			player_name
		)
	)
	
	match normalized_speaker_name:
		"aventureiro":
			resolved_speaker_name = player_name
		
		"aventureiro (pensamento)":
			resolved_speaker_name = (
				player_name
				+ " (pensamento)"
			)
	
	var resolved_dialogue_text: String = (
		dialogue_text.replace(
			"[PLAYER_NAME]",
			player_name
		)
	)
	
	await story_dialog.show_dialog(
		resolved_speaker_name,
		resolved_dialogue_text
	)


func start_fade_to_black(
	duration: float
) -> void:
	stop_active_fade()
	
	if not is_instance_valid(black_overlay):
		return
	
	black_overlay.visible = true
	
	var current_color: Color = (
		black_overlay.color
	)
	
	current_color.a = clamp(
		current_color.a,
		0.0,
		1.0
	)
	
	black_overlay.color = current_color
	
	active_fade_tween = create_tween()
	
	active_fade_tween.set_pause_mode(
		Tween.TWEEN_PAUSE_PROCESS
	)
	
	active_fade_tween.tween_property(
		black_overlay,
		"color",
		Color.BLACK,
		max(
			0.01,
			duration
		)
	)


func wait_for_active_fade() -> void:
	if not is_instance_valid(
		active_fade_tween
	):
		return
	
	if not active_fade_tween.is_running():
		return
	
	await active_fade_tween.finished


func fade_from_black(
	duration: float
) -> void:
	stop_active_fade()
	
	if not is_instance_valid(black_overlay):
		return
	
	black_overlay.visible = true
	black_overlay.color = Color.BLACK
	
	active_fade_tween = create_tween()
	
	active_fade_tween.set_pause_mode(
		Tween.TWEEN_PAUSE_PROCESS
	)
	
	active_fade_tween.tween_property(
		black_overlay,
		"color",
		Color(
			0.0,
			0.0,
			0.0,
			0.0
		),
		max(
			0.01,
			duration
		)
	)
	
	await active_fade_tween.finished
	
	black_overlay.visible = false


func stop_active_fade() -> void:
	if not is_instance_valid(
		active_fade_tween
	):
		active_fade_tween = null
		return
	
	if active_fade_tween.is_running():
		active_fade_tween.kill()
	
	active_fade_tween = null


func play_story_video(
	video_path: String
) -> void:
	if not is_instance_valid(video_player):
		return
	
	if video_path.strip_edges() == "":
		print(
			"Evento sem vídeo definido. "
			+ "Continuando a sequência."
		)
		
		return
	
	if not ResourceLoader.exists(
		video_path
	):
		push_warning(
			"Vídeo da história não encontrado: "
			+ video_path
		)
		
		return
	
	var loaded_resource: Resource = load(
		video_path
	)
	
	if not loaded_resource is VideoStream:
		push_warning(
			"O arquivo informado não é um "
			+ "VideoStream válido: "
			+ video_path
		)
		
		return

	if MusicManage != null:
		MusicManage.fade_out_music(0.5)
		await wait_story_time(0.5)
	
	video_player.stream = loaded_resource
	video_player.visible = true
	video_player.move_to_front()
	skip_video_button.visible = true
	skip_video_button.move_to_front()
	waiting_for_video = true
	
	video_player.play()
	
	await story_video_ended
	
	video_player.stop()
	video_player.visible = false
	video_player.stream = null
	skip_video_button.visible = false


func _on_story_video_finished() -> void:
	_finish_story_video()


func _on_skip_story_video_pressed() -> void:
	_finish_story_video()


func _finish_story_video() -> void:
	if not waiting_for_video:
		return
	waiting_for_video = false
	story_video_ended.emit()


func wait_story_time(
	duration: float
) -> void:
	if duration <= 0.0:
		return
	
	await get_tree().create_timer(
		duration,
		true
	).timeout


func reset_visual_state() -> void:
	stop_active_fade()
	
	if is_instance_valid(video_player):
		video_player.stop()
		video_player.visible = false
		video_player.stream = null
	waiting_for_video = false
	if is_instance_valid(skip_video_button):
		skip_video_button.visible = false
	
	if is_instance_valid(black_overlay):
		black_overlay.color = Color(
			0.0,
			0.0,
			0.0,
			0.0
		)
		
		black_overlay.visible = false


func is_event_running() -> bool:
	return event_running
