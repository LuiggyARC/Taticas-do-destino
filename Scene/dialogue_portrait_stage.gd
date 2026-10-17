extends CanvasLayer

# Portrait composition behind the compact dialogue window, used only outside combat.
var portrait_layer: Control
var cast_entries: Array[Dictionary] = []
var active_portrait_path: String = ""
var active_speaker_name: String = ""
var speaker_weights: Dictionary = {}
var player_on_right: bool = false


func _ready() -> void:
	layer = 90
	var root := Control.new()
	root.name = "CinematicDialogueCanvas"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	portrait_layer = Control.new()
	portrait_layer.name = "ConversationPortraits"
	portrait_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	portrait_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(portrait_layer)
	get_viewport().size_changed.connect(rebuild_portraits)
	visible = false


func show_cast(entries: Array[Dictionary], speaker_path: String, speaker_name: String, weights: Dictionary = {}, place_player_on_right: bool = false) -> void:
	cast_entries = entries.duplicate()
	active_portrait_path = speaker_path
	active_speaker_name = speaker_name.to_lower().replace(" (pensamento)", "").strip_edges()
	speaker_weights = weights.duplicate()
	player_on_right = place_player_on_right
	rebuild_portraits()
	visible = true


func hide_cast() -> void:
	visible = false


func rebuild_portraits() -> void:
	if not is_instance_valid(portrait_layer):
		return
	for child in portrait_layer.get_children():
		portrait_layer.remove_child(child)
		child.queue_free()
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return
	var count: int = cast_entries.size()
	if count == 0:
		return
	var dialogue_width: float = minf(900.0, (viewport_size.x - 24.0) * 0.63)
	if OS.has_feature("mobile"):
		dialogue_width = minf(1500.0, (viewport_size.x - 24.0) * 0.60)
	var side_width: float = maxf(120.0, (viewport_size.x - dialogue_width) * 0.5 - 12.0)
	var primary_size := Vector2(
		minf(470.0, side_width),
		minf(540.0, viewport_size.y * 0.60)
	)
	var dialogue_height: float = 390.0 if OS.has_feature("mobile") else 290.0
	var dialogue_top: float = viewport_size.y - dialogue_height - 18.0
	var main_entries: Array[Dictionary] = []
	var npc_entries: Array[Dictionary] = []
	for entry in cast_entries:
		if is_main_character(entry) and not (player_on_right and is_player_character(entry)):
			main_entries.append(entry)
		else:
			npc_entries.append(entry)
	main_entries.sort_custom(sort_entries_by_dialogue)
	npc_entries.sort_custom(sort_entries_by_dialogue)
	# Desenha os secundários primeiro para que o principal fique à frente.
	for index in range(main_entries.size() - 1, -1, -1):
		add_portrait(main_entries[index], index, false, viewport_size, primary_size, dialogue_top)
	for index in range(npc_entries.size() - 1, -1, -1):
		add_portrait(npc_entries[index], index, true, viewport_size, primary_size, dialogue_top)


func add_portrait(
	entry: Dictionary,
	index: int,
	is_npc: bool,
	viewport_size: Vector2,
	primary_size: Vector2,
	dialogue_top: float
) -> void:
	var portrait_path: String = str(entry.get("path", ""))
	var portrait_texture: Texture2D = entry.get("texture") as Texture2D
	var portrait_name: String = str(entry.get("name", ""))
	var slot: Control
	if portrait_texture != null:
		var image := TextureRect.new()
		image.texture = portrait_texture
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		image.clip_contents = true
		image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		slot = image
	else:
		var placeholder := PanelContainer.new()
		var placeholder_style := StyleBoxFlat.new()
		placeholder_style.bg_color = Color(0.06, 0.06, 0.08, 0.90)
		placeholder_style.border_color = Color(0.62, 0.48, 0.25, 0.8)
		placeholder_style.set_border_width_all(2)
		placeholder_style.set_corner_radius_all(10)
		placeholder.add_theme_stylebox_override("panel", placeholder_style)
		var label := Label.new()
		label.text = portrait_name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		placeholder.add_child(label)
		slot = placeholder
	slot.name = ("NpcPortrait_%d" if is_npc else "MainPortrait_%d") % index
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var is_secondary: bool = index > 0
	slot.size = primary_size * (0.8 if is_secondary else 1.0)
	var advance: float = primary_size.x * 0.84 + float(index - 1) * (primary_size.x * 0.8 + 16.0)
	var slot_x: float = 8.0 if not is_npc else viewport_size.x - slot.size.x - 8.0
	var slot_y: float = viewport_size.y - slot.size.y
	if is_secondary:
		slot_x = advance if not is_npc else viewport_size.x - slot.size.x - advance
		# O secundário fica mais alto e quase todo acima da caixa.
		slot_y = dialogue_top - slot.size.y * 0.95
	slot.position = Vector2(slot_x, maxf(0.0, slot_y))
	var is_speaker: bool = (
		(portrait_path != "" and portrait_path == active_portrait_path)
		or (portrait_path == "" and portrait_name.to_lower().strip_edges() == active_speaker_name)
	)
	slot.modulate = Color.WHITE if is_speaker else Color(0.30, 0.30, 0.33, 0.92)
	portrait_layer.add_child(slot)


func is_main_character(entry: Dictionary) -> bool:
	var name_lower: String = str(entry.get("name", "")).strip_edges().to_lower()
	if is_player_character(entry):
		return true
	for main_name in ["uiliam", "aniri", "kasum"]:
		if name_lower.contains(main_name):
			return true
	return false


func is_player_character(entry: Dictionary) -> bool:
	var name_lower: String = str(entry.get("name", "")).strip_edges().to_lower()
	var player_name: String = str(GameState.player_name).strip_edges().to_lower()
	return name_lower in ["aventureiro", "aventureiro (pensamento)", "herói"] or (player_name != "" and name_lower == player_name)


func get_main_priority(entry: Dictionary) -> int:
	var name_lower: String = str(entry.get("name", "")).strip_edges().to_lower()
	var player_name: String = str(GameState.player_name).strip_edges().to_lower()
	if name_lower in ["aventureiro", "aventureiro (pensamento)", "herói"] or (player_name != "" and name_lower == player_name):
		return 0
	if name_lower.contains("uiliam"):
		return 1
	if name_lower.contains("aniri"):
		return 2
	if name_lower.contains("kasum"):
		return 3
	return 4


func get_speaker_weight(entry: Dictionary) -> int:
	var name_lower: String = str(entry.get("name", "")).strip_edges().to_lower()
	if speaker_weights.has(name_lower):
		return int(speaker_weights[name_lower])
	var player_name: String = str(GameState.player_name).strip_edges().to_lower()
	if player_name != "" and name_lower == player_name:
		return int(speaker_weights.get("aventureiro", 0))
	return 0


func sort_entries_by_dialogue(a: Dictionary, b: Dictionary) -> bool:
	var a_weight: int = get_speaker_weight(a)
	var b_weight: int = get_speaker_weight(b)
	if a_weight != b_weight:
		return a_weight > b_weight
	return get_main_priority(a) < get_main_priority(b)
