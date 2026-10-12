extends AcceptDialog
class_name StoryDialogBox
const DialoguePortraitStageScript = preload("res://Scene/dialogue_portrait_stage.gd")
@export_range(0.01, 0.20, 0.005)
var typing_character_interval: float = 0.035

@export var story_dialog_size: Vector2i = Vector2i(
	760,
	280
)
@export var dialogue_bottom_margin: int = 18

var portrait_texture_rect: TextureRect
var dialogue_content_row: HBoxContainer
var speaker_name_label: Label
var cinematic_nameplate: PanelContainer
var cinematic_speaker_name_label: Label
var thought_font: FontVariation
var is_typing: bool = false
var reveal_requested: bool = false
var cinematic_mode: bool = false
var conversation_cast: Array[String] = []
var conversation_weights: Dictionary = {}
var player_portrait_on_right: bool = false
var hide_missing_cinematic_portraits: bool = false
var portrait_stage

func _ready() -> void:
	if OS.has_feature("mobile"):
		story_dialog_size = Vector2i(920, 390)
	name = "StoryDialogPopup"
	title = "História"
	dialog_text = ""
	ok_button_text = "Continuar"
	dialog_hide_on_ok = false
	confirmed.connect(on_continue_requested)
	exclusive = true
	unresizable = true
	
	process_mode = (
		Node.PROCESS_MODE_WHEN_PAUSED
	)
	
	dialog_close_on_escape = false
	
	var panel_style := StyleBoxFlat.new()
	
	panel_style.bg_color = Color(
		0.025,
		0.025,
		0.035,
		0.97
	)
	
	panel_style.border_color = Color(
		0.78,
		0.62,
		0.28,
		1.0
	)
	
	panel_style.set_border_width_all(3)
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12
	
	panel_style.content_margin_left = 24
	panel_style.content_margin_top = 20
	panel_style.content_margin_right = 24
	panel_style.content_margin_bottom = 20
	
	add_theme_stylebox_override(
		"panel",
		panel_style
	)
	
	var dialogue_label: Label = (
		get_label()
	)
	
	if is_instance_valid(
		dialogue_label
	):
		var label_parent: Node = (
			dialogue_label.get_parent()
		)
		
		var original_label_index: int = (
			dialogue_label.get_index(true)
		)
		
		label_parent.remove_child(
			dialogue_label
		)
		
		dialogue_content_row = (
			HBoxContainer.new()
		)
		
		dialogue_content_row.name = (
			"DialogueContentRow"
		)
		
		dialogue_content_row.custom_minimum_size = Vector2(
			0,
			150
		)
		
		dialogue_content_row.add_theme_constant_override(
			"separation",
			18
		)
		
		label_parent.add_child(
			dialogue_content_row
		)
		
		label_parent.move_child(
			dialogue_content_row,
			original_label_index
		)
		
		portrait_texture_rect = (
			TextureRect.new()
		)
		
		portrait_texture_rect.name = (
			"CharacterPortrait"
		)
		
		portrait_texture_rect.custom_minimum_size = Vector2(
			140,
			140
		)
		
		portrait_texture_rect.expand_mode = (
			TextureRect.EXPAND_IGNORE_SIZE
		)
		
		portrait_texture_rect.stretch_mode = (
			TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		)
		
		portrait_texture_rect.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)
		
		portrait_texture_rect.visible = false
		
		dialogue_content_row.add_child(
			portrait_texture_rect
		)
		
		dialogue_label.size_flags_horizontal = (
			Control.SIZE_EXPAND_FILL
		)
		
		dialogue_label.size_flags_vertical = (
			Control.SIZE_EXPAND_FILL
		)
		
		dialogue_label.autowrap_mode = (
			TextServer.AUTOWRAP_WORD_SMART
		)
		
		dialogue_label.horizontal_alignment = (
			HORIZONTAL_ALIGNMENT_LEFT
		)
		
		dialogue_label.vertical_alignment = (
			VERTICAL_ALIGNMENT_CENTER
		)
		
		dialogue_label.add_theme_font_size_override(
			"font_size",
			34 if OS.has_feature("mobile") else 20
		)
		
		dialogue_label.add_theme_color_override(
			"font_color",
			Color(
				1.0,
				0.96,
				0.84,
				1.0
			)
		)
		
		dialogue_label.add_theme_color_override(
			"font_outline_color",
			Color.BLACK
		)
		
		dialogue_label.add_theme_constant_override(
			"outline_size",
			3
		)
		
		dialogue_content_row.add_child(
			dialogue_label
		)
	
	var continue_button: Button = (
		get_ok_button()
	)
	
	if is_instance_valid(
		continue_button
	):
		continue_button.custom_minimum_size = Vector2(
			290 if OS.has_feature("mobile") else 140,
			88 if OS.has_feature("mobile") else 42
		)
		continue_button.add_theme_font_size_override(
			"font_size",
			30 if OS.has_feature("mobile") else 18
		)
	var skip_button: Button = add_cancel_button("✕ Pular fala")
	skip_button.custom_minimum_size = Vector2(
		230 if OS.has_feature("mobile") else 130,
		88 if OS.has_feature("mobile") else 42
	)
	skip_button.add_theme_font_size_override(
		"font_size", 28 if OS.has_feature("mobile") else 17
	)


func on_continue_requested() -> void:
	if is_typing:
		reveal_requested = true
	else:
		hide()


func set_cinematic_mode(enabled: bool) -> void:
	cinematic_mode = enabled
	if not enabled and is_instance_valid(portrait_stage):
		portrait_stage.hide_cast()


func set_conversation_cast(speakers: Array) -> void:
	conversation_cast.clear()
	var seen_names: Dictionary = {}
	for speaker in speakers:
		var person_name: String = resolve_cast_name(str(speaker))
		var person_key: String = person_name.to_lower()
		if person_name == "" or is_portraitless_speaker(person_name) or seen_names.has(person_key):
			continue
		seen_names[person_key] = true
		conversation_cast.append(person_name)


func set_conversation_weights(weights: Dictionary) -> void:
	conversation_weights.clear()
	for speaker in weights:
		var person_key: String = resolve_cast_name(str(speaker)).to_lower()
		conversation_weights[person_key] = int(conversation_weights.get(person_key, 0)) + int(weights[speaker])


func set_player_portrait_on_right(enabled: bool) -> void:
	player_portrait_on_right = enabled


func resolve_cast_name(raw_name: String) -> String:
	var person_name: String = raw_name.replace(
		"[NOME_DO_JOGADOR]", str(GameState.player_name)
	).replace("[PLAYER_NAME]", str(GameState.player_name)).strip_edges()
	var normalized_name: String = person_name.to_lower().replace(" (pensamento)", "")
	if normalized_name in ["aventureiro", "herói"]:
		var player_name: String = str(GameState.player_name).strip_edges()
		return player_name if player_name != "" else "Herói"
	return person_name.replace(" (pensamento)", "")


func is_narration_speaker(speaker_name: String) -> bool:
	return speaker_name.strip_edges().to_lower() in [
		"", "ação", "narrador", "história", "cena"
	]


func is_system_notice_speaker(speaker_name: String) -> bool:
	return speaker_name.strip_edges().to_lower() in [
		"missão iniciada", "missão concluída", "missão atualizada",
		"nova missão", "nova missão pessoal", "nova missão de companheiro",
		"novo objetivo", "próximo objetivo", "objetivo atualizado",
		"novo companheiro", "recompensa", "loja atualizada",
		"ouro do grupo", "missão pessoal atualizada"
	]


func is_portraitless_speaker(speaker_name: String) -> bool:
	return is_narration_speaker(speaker_name) or is_system_notice_speaker(speaker_name)


func show_cinematic_portraits(speaker_name: String) -> void:
	if not is_instance_valid(portrait_stage):
		portrait_stage = DialoguePortraitStageScript.new()
		get_parent().add_child(portrait_stage)
	var names: Array[String] = conversation_cast.duplicate()
	var current_speaker: String = resolve_cast_name(speaker_name)
	if names.is_empty():
		var speaker_path: String = get_speaker_portrait_path(speaker_name)
		if not is_portraitless_speaker(speaker_name):
			names.append(current_speaker)
		if str(GameState.player_portrait_path) != "" and speaker_path != str(GameState.player_portrait_path):
			names.append(str(GameState.player_name))
	elif not is_portraitless_speaker(speaker_name):
		var current_path: String = get_speaker_portrait_path(speaker_name)
		var already_present: bool = false
		for participant in names:
			if participant.to_lower() == current_speaker.to_lower() or (current_path != "" and get_speaker_portrait_path(participant) == current_path):
				already_present = true
				break
		if not already_present:
			names.append(current_speaker)
	var entries: Array[Dictionary] = []
	var seen_paths: Dictionary = {}
	for person_name in names:
		var cleaned_name: String = resolve_cast_name(person_name)
		if cleaned_name == "" or is_portraitless_speaker(cleaned_name):
			continue
		var portrait_path: String = get_speaker_portrait_path(cleaned_name)
		if hide_missing_cinematic_portraits and portrait_path == "":
			continue
		var identity: String = portrait_path if portrait_path != "" else cleaned_name.to_lower()
		if seen_paths.has(identity):
			continue
		seen_paths[identity] = true
		entries.append({
			"name": cleaned_name,
			"path": portrait_path,
			"texture": load_dialogue_portrait(portrait_path)
		})
	portrait_stage.show_cast(entries, get_speaker_portrait_path(speaker_name), current_speaker, conversation_weights, player_portrait_on_right)

func get_speaker_portrait_path(
	speaker_name: String
) -> String:
	var normalized_speaker: String = (
		speaker_name
		.strip_edges()
		.to_lower()
		.replace(" (pensamento)", "")
		.replace(".", "")
		.replace(":", "")
	)
	
	var normalized_player_name: String = (
		str(GameState.player_name)
		.strip_edges()
		.to_lower()
		.replace(".", "")
		.replace(":", "")
	)
	
	if (
		normalized_speaker in ["aventureiro", "herói"]
		or (
			normalized_player_name != ""
			and normalized_speaker == normalized_player_name
		)
	):
		return str(GameState.player_portrait_path)
	
	if normalized_speaker.contains("uiliam"):
		return "res://Assets/Characters/SrUiliam.png"
	
	if normalized_speaker.contains("aniri"):
		return "res://Assets/Characters/AniriLadina.png"
	
	if normalized_speaker.contains("hashagur"):
		return "res://Assets/Characters/Hashagur.png"
	
	if normalized_speaker.contains("kasum"):
		return "res://Assets/Characters/Kasum.png"
	
	if (
		normalized_speaker.contains("jhon")
		or normalized_speaker.contains("carpinteiro")
	):
		return "res://Assets/Characters/Jhon.png"
	
	if normalized_speaker.contains("curandeira"):
		return "res://Assets/Characters/Curandeira.png"
	
	if normalized_speaker.contains("vendedor") or normalized_speaker.contains("lojista"):
		return "res://Assets/Characters/Lojista.png"
	
	if normalized_speaker.contains("taverneiro"):
		return "res://Assets/Characters/Taverneiro.png"
	
	if normalized_speaker.contains("prefeito"):
		return "res://Assets/Characters/Prefeito.png"

	if normalized_speaker.begins_with("cultista"):
		return "res://Assets/Characters/Cultista1.png"
	
	if (
		normalized_speaker.contains("soldado ferido")
		or normalized_speaker.contains("guarda ferido")
		or normalized_speaker == "soldado"
	):
		return "res://Assets/Characters/Soldado ferido.png"
	
	return ""


func load_dialogue_portrait(
	portrait_path: String
) -> Texture2D:
	if portrait_path.strip_edges() == "":
		return null
	
	if portrait_path.begins_with(
		"res://"
	):
		if not ResourceLoader.exists(
			portrait_path
		):
			return null
		
		return load(
			portrait_path
		) as Texture2D
	
	var portrait_image := Image.new()
	
	var load_error: Error = (
		portrait_image.load(
			portrait_path
		)
	)
	
	if load_error != OK:
		return null
	
	return ImageTexture.create_from_image(
		portrait_image
	)


func update_dialogue_portrait(
	speaker_name: String
) -> void:
	setup_dialogue_nameplate()
	
	var normalized_name: String = (
		speaker_name.strip_edges().to_lower()
	)
	var is_narration: bool = is_narration_speaker(speaker_name)
	var is_system_notice: bool = is_system_notice_speaker(speaker_name)
	var no_portrait: bool = is_narration or is_system_notice
	var is_thought: bool = (
		normalized_name.contains("(pensamento)")
	)
	
	var visible_name: String = speaker_name.strip_edges()
	if is_narration:
		visible_name = "Narrador"
	elif normalized_name in ["aventureiro", "aventureiro (pensamento)", "herói", "herói (pensamento)"]:
		var player_name: String = str(GameState.player_name).strip_edges()
		if player_name != "":
			visible_name = player_name + (" (pensamento)" if is_thought else "")
	var name_color: Color = Color(0.80, 0.83, 0.88) if is_narration else (
		Color(0.76, 0.94, 0.73) if is_system_notice else (
			Color(0.67, 0.81, 1.0) if is_thought else Color(1.0, 0.89, 0.63)
		)
	)
	if is_instance_valid(speaker_name_label):
		speaker_name_label.text = visible_name
		speaker_name_label.add_theme_color_override("font_color", name_color)
	if is_instance_valid(cinematic_speaker_name_label):
		cinematic_speaker_name_label.text = visible_name
		cinematic_speaker_name_label.add_theme_color_override("font_color", name_color)
	
	if is_instance_valid(portrait_texture_rect):
		var portrait_column: Control = (
			portrait_texture_rect.get_parent() as Control
		)
		
		if is_instance_valid(portrait_column):
			portrait_column.visible = not no_portrait
	
	var dialogue_label: Label = get_label()
	
	if is_instance_valid(dialogue_label):
		if (is_narration or is_thought) and thought_font != null:
			dialogue_label.add_theme_font_override(
				"font",
				thought_font
			)
		else:
			dialogue_label.remove_theme_font_override(
				"font"
			)
		
		if is_narration:
			dialogue_label.horizontal_alignment = (
				HORIZONTAL_ALIGNMENT_CENTER
			)
			dialogue_label.add_theme_color_override(
				"font_color",
				Color(0.86, 0.81, 0.71)
			)
		else:
			dialogue_label.horizontal_alignment = (
				HORIZONTAL_ALIGNMENT_LEFT
			)
			dialogue_label.add_theme_color_override(
				"font_color",
				Color(1.0, 0.96, 0.84)
			)
	
	if is_narration:
		title = "Narração"
	elif is_system_notice:
		title = "Atualização"
	elif is_thought:
		title = "Pensamento"
	else:
		title = "Diálogo"
	
	if not is_instance_valid(portrait_texture_rect):
		return
	
	var portrait_path: String = (
		get_speaker_portrait_path(
			speaker_name
		)
	)
	
	var portrait_texture: Texture2D = (
		load_dialogue_portrait(
			portrait_path
		)
	)
	
	portrait_texture_rect.texture_filter = (
		CanvasItem.TEXTURE_FILTER_LINEAR
	)
	portrait_texture_rect.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_COVERED
	)
	portrait_texture_rect.clip_contents = true
	portrait_texture_rect.texture = portrait_texture
	portrait_texture_rect.visible = (
		portrait_texture != null
	)
	
func show_dialog(
	speaker_name: String,
	dialogue_text: String
) -> void:
	if dialogue_text.strip_edges() == "":
		return
	
	var scene_tree: SceneTree = get_tree()
	
	var tree_was_paused: bool = (
		scene_tree.paused
	)
	
	scene_tree.paused = true
	
	if speaker_name.strip_edges() == "":
		title = "História"
	else:
		title = speaker_name
	
	update_dialogue_portrait(
		speaker_name
	)
	var no_portrait: bool = is_portraitless_speaker(speaker_name)
	var portrait_column: Control = portrait_texture_rect.get_parent() as Control if is_instance_valid(portrait_texture_rect) else null
	if is_instance_valid(portrait_column):
		portrait_column.visible = not cinematic_mode and not no_portrait
		portrait_column.custom_minimum_size = Vector2(
			210 if OS.has_feature("mobile") else 170,
			180
		)
	if is_instance_valid(cinematic_nameplate):
		cinematic_nameplate.visible = cinematic_mode or no_portrait
	if is_instance_valid(portrait_texture_rect) and cinematic_mode:
		portrait_texture_rect.visible = false
	if is_instance_valid(dialogue_content_row):
		dialogue_content_row.custom_minimum_size.y = 115 if cinematic_mode else 180
	if cinematic_mode:
		show_cinematic_portraits(speaker_name)
	elif is_instance_valid(portrait_stage):
		portrait_stage.hide_cast()
	
	dialog_text = dialogue_text
	
	var dialogue_label: Label = (
		get_label()
	)
	
	var continue_button: Button = (
		get_ok_button()
	)
	
	if is_instance_valid(
		dialogue_label
	):
		dialogue_label.visible_characters = 0
	is_typing = true
	reveal_requested = false
	if is_instance_valid(continue_button):
		continue_button.disabled = false
	
	var available_size: Vector2i = Vector2i(scene_tree.root.get_visible_rect().size) - Vector2i(24, 24)
	var desired_size: Vector2i = story_dialog_size
	if cinematic_mode:
		desired_size = Vector2i(
			mini(900, int(float(available_size.x) * 0.63)),
			360 if OS.has_feature("mobile") else 290
		)
	popup_centered(
		Vector2i(
			mini(desired_size.x, available_size.x),
			mini(desired_size.y, available_size.y)
		)
	)
	
	await scene_tree.process_frame
	
	var main_viewport: Viewport = null
	
	if is_instance_valid(
		get_parent()
	):
		main_viewport = (
			get_parent().get_viewport()
		)
	
	if not is_instance_valid(
		main_viewport
	):
		main_viewport = scene_tree.root
	
	var viewport_size := Vector2i(
		main_viewport.get_visible_rect().size
	)
	
	position = Vector2i(
		max(
			0,
			int(
				(
					viewport_size.x
					- size.x
				) / 2
			)
		),
		max(
			0,
			viewport_size.y
			- size.y
			- dialogue_bottom_margin
		)
	)

	for character_index in range(
		1,
		dialogue_text.length() + 1
	):
		if not visible or reveal_requested:
			break
		
		if not is_instance_valid(
			dialogue_label
		):
			break
		
		dialogue_label.visible_characters = (
			character_index
		)
		
		var current_character: String = (
			dialogue_text.substr(
				character_index - 1,
				1
			)
		)
		
		var character_delay: float = (
			typing_character_interval
		)
		
		if current_character in [
			".",
			"!",
			"?"
		]:
			character_delay *= 6.0
		elif current_character in [
			",",
			";",
			":"
		]:
			character_delay *= 3.0
		
		await scene_tree.create_timer(
			character_delay,
			true
		).timeout

	if is_instance_valid(dialogue_label):
		dialogue_label.visible_characters = -1
	is_typing = false

	if is_instance_valid(continue_button):
		continue_button.disabled = false

	while visible:
		await visibility_changed
	if is_instance_valid(portrait_stage):
		portrait_stage.hide_cast()

	scene_tree.paused = tree_was_paused

func setup_dialogue_nameplate() -> void:
	if is_instance_valid(speaker_name_label):
		return
	
	if not is_instance_valid(dialogue_content_row):
		return
	
	if not is_instance_valid(portrait_texture_rect):
		return
	
	var left_column := VBoxContainer.new()
	left_column.name = "PortraitAndName"
	left_column.custom_minimum_size = Vector2(210 if OS.has_feature("mobile") else 170, 180)
	left_column.add_theme_constant_override(
		"separation",
		6
	)
	
	var name_panel := PanelContainer.new()
	name_panel.name = "SpeakerNameplate"
	name_panel.custom_minimum_size = Vector2(210 if OS.has_feature("mobile") else 170, 52 if OS.has_feature("mobile") else 34)
	
	var name_style := StyleBoxFlat.new()
	name_style.bg_color = Color(0.12, 0.09, 0.06, 1.0)
	name_style.border_color = Color(0.78, 0.62, 0.28, 1.0)
	name_style.set_border_width_all(2)
	name_style.set_corner_radius_all(7)
	name_style.set_content_margin_all(5)
	name_panel.add_theme_stylebox_override(
		"panel",
		name_style
	)
	
	speaker_name_label = Label.new()
	speaker_name_label.name = "SpeakerName"
	speaker_name_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	speaker_name_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	speaker_name_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	speaker_name_label.add_theme_font_size_override(
		"font_size",
		28 if OS.has_feature("mobile") else 18
	)
	speaker_name_label.add_theme_color_override(
		"font_color",
		Color(1.0, 0.89, 0.63)
	)
	
	name_panel.add_child(speaker_name_label)
	left_column.add_child(name_panel)
	
	cinematic_nameplate = PanelContainer.new()
	cinematic_nameplate.name = "CinematicSpeakerNameplate"
	cinematic_nameplate.custom_minimum_size = name_panel.custom_minimum_size
	cinematic_nameplate.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	cinematic_nameplate.add_theme_stylebox_override("panel", name_style.duplicate())
	cinematic_speaker_name_label = Label.new()
	cinematic_speaker_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cinematic_speaker_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cinematic_speaker_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	cinematic_speaker_name_label.add_theme_font_size_override(
		"font_size", 28 if OS.has_feature("mobile") else 18
	)
	cinematic_speaker_name_label.add_theme_color_override(
		"font_color", Color(1.0, 0.89, 0.63)
	)
	cinematic_nameplate.add_child(cinematic_speaker_name_label)
	var content_parent: Node = dialogue_content_row.get_parent()
	var row_index: int = dialogue_content_row.get_index()
	content_parent.remove_child(dialogue_content_row)
	var dialogue_layout := VBoxContainer.new()
	dialogue_layout.name = "DialogueLayout"
	dialogue_layout.add_theme_constant_override("separation", 8)
	content_parent.add_child(dialogue_layout)
	content_parent.move_child(dialogue_layout, row_index)
	dialogue_layout.add_child(cinematic_nameplate)
	dialogue_layout.add_child(dialogue_content_row)
	cinematic_nameplate.visible = false
	
	portrait_texture_rect.get_parent().remove_child(
		portrait_texture_rect
	)
	portrait_texture_rect.size_flags_horizontal = (
		Control.SIZE_SHRINK_CENTER
	)
	left_column.add_child(portrait_texture_rect)
	
	dialogue_content_row.add_child(left_column)
	dialogue_content_row.move_child(left_column, 0)
	dialogue_content_row.custom_minimum_size.y = 180
	
	var dialogue_label: Label = get_label()
	
	if is_instance_valid(dialogue_label):
		thought_font = FontVariation.new()
		thought_font.base_font = (
			dialogue_label.get_theme_font("font")
		)
		thought_font.variation_transform = Transform2D(
			Vector2(1.0, 0.22),
			Vector2(0.0, 1.0),
			Vector2.ZERO
		)
