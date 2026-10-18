extends Control

const MapRules = preload("res://Scene/world_map_rules.gd")

var map_background: TextureRect
var route_layer: Control
var avatar: PanelContainer
var avatar_image: TextureRect
var avatar_initial: Label
var status_label: Label
var enter_button: Button
var node_buttons: Dictionary = {}
var route_lines: Array[Line2D] = []
var current_node: String = "village"
var bridge_completed: bool = false
var road_story_completed: bool = false
var moving: bool = false


func _ready() -> void:
	bridge_completed = MissionManager.is_mission_completed(MapRules.BRIDGE_MISSION_ID)
	road_story_completed = SaveManager.has_completed_story_event(MapRules.ROAD_EVENT_ID)
	var save_data: Dictionary = SaveManager.read_save_data(SaveManager.get_active_save_path())
	var default_node: String = "citadel" if GameState.current_location in ["citadel", "temple_gate", "temple_hall"] else ("bridge" if GameState.current_location == "temple_road" else "village")
	current_node = str(save_data.get("world_map_node", default_node))
	if not MapRules.NODES.has(current_node) or not MapRules.is_unlocked(current_node, bridge_completed, road_story_completed):
		current_node = default_node if MapRules.is_unlocked(default_node, bridge_completed, road_story_completed) else "village"
	_build_background()
	_build_routes()
	_build_nodes()
	_build_avatar()
	_build_header()
	_build_footer()
	resized.connect(_update_positions)
	call_deferred("_update_positions")
	_refresh_state()


func _build_background() -> void:
	map_background = TextureRect.new()
	map_background.name = "WorldMapArtwork"
	map_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	map_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	map_background.texture = load(MapRules.map_path(road_story_completed)) as Texture2D
	map_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(map_background)


func _build_routes() -> void:
	route_layer = Control.new()
	route_layer.name = "Routes"
	route_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	route_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(route_layer)
	for _connection in MapRules.CONNECTIONS:
		var line := Line2D.new()
		line.width = 6.0
		line.default_color = Color(0.94, 0.75, 0.34, 0.92)
		line.antialiased = true
		route_layer.add_child(line)
		route_lines.append(line)


func _build_nodes() -> void:
	for node_id in MapRules.NODES:
		var point := Button.new()
		point.name = "Point_" + node_id
		point.text = "◆"
		point.tooltip_text = MapRules.get_node_name(node_id)
		point.custom_minimum_size = Vector2(54, 54)
		point.add_theme_font_size_override("font_size", 32)
		point.pressed.connect(_on_node_pressed.bind(node_id))
		add_child(point)
		node_buttons[node_id] = point


func _build_avatar() -> void:
	avatar = PanelContainer.new()
	avatar.name = "PlayerMapMarker"
	avatar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	avatar.custom_minimum_size = Vector2(68, 68)
	var marker_style := StyleBoxFlat.new()
	marker_style.bg_color = Color(0.07, 0.10, 0.12, 0.98)
	marker_style.border_color = Color(0.98, 0.80, 0.36)
	marker_style.set_border_width_all(3)
	marker_style.set_corner_radius_all(34)
	avatar.add_theme_stylebox_override("panel", marker_style)
	add_child(avatar)
	avatar_image = TextureRect.new()
	avatar_image.name = "PlayerPortrait"
	avatar_image.custom_minimum_size = Vector2(62, 62)
	avatar_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	avatar_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var portrait: Texture2D = _load_player_portrait()
	if portrait != null:
		avatar_image.texture = _face_crop(portrait)
		avatar.add_child(avatar_image)
	else:
		avatar_initial = Label.new()
		avatar_initial.text = GameState.player_name.substr(0, 1).to_upper()
		avatar_initial.custom_minimum_size = Vector2(62, 62)
		avatar_initial.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		avatar_initial.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		avatar_initial.add_theme_font_size_override("font_size", 32)
		avatar.add_child(avatar_initial)


func _load_player_portrait() -> Texture2D:
	var path: String = str(GameState.player_portrait_path).strip_edges()
	if path.is_empty():
		return null
	if path.begins_with("res://"):
		return load(path) as Texture2D if ResourceLoader.exists(path) else null
	var portrait_image := Image.new()
	if portrait_image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(portrait_image)


func _face_crop(portrait: Texture2D) -> Texture2D:
	var image_size: Vector2 = portrait.get_size()
	if image_size.x <= 0.0 or image_size.y <= 0.0 or absf(image_size.x - image_size.y) < image_size.y * 0.2:
		return portrait
	var crop_side: float = minf(image_size.x, image_size.y * 0.65)
	var crop := AtlasTexture.new()
	crop.atlas = portrait
	crop.region = Rect2((image_size.x - crop_side) * 0.5, image_size.y * 0.08, crop_side, crop_side)
	return crop


func _build_header() -> void:
	var header := PanelContainer.new()
	header.name = "MapHeader"
	header.anchor_left = 0.02
	header.anchor_right = 0.98
	header.offset_top = 12.0
	header.offset_bottom = 82.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.04, 0.05, 0.90)
	style.border_color = Color(0.77, 0.58, 0.27)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	header.add_theme_stylebox_override("panel", style)
	add_child(header)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	header.add_child(row)
	var back_button := Button.new()
	back_button.text = "Voltar"
	back_button.custom_minimum_size = Vector2(130, 52)
	back_button.pressed.connect(_on_back_pressed)
	row.add_child(back_button)
	var title := Label.new()
	title.text = "MAPA DE AVIANT"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 27)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.57))
	row.add_child(title)
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(130, 0)
	row.add_child(spacer)


func _build_footer() -> void:
	var footer := PanelContainer.new()
	footer.name = "MapFooter"
	footer.anchor_left = 0.12
	footer.anchor_right = 0.88
	footer.anchor_top = 1.0
	footer.anchor_bottom = 1.0
	footer.offset_top = -100.0
	footer.offset_bottom = -12.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.04, 0.05, 0.93)
	style.border_color = Color(0.77, 0.58, 0.27)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	footer.add_theme_stylebox_override("panel", style)
	add_child(footer)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	footer.add_child(row)
	status_label = Label.new()
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 19)
	row.add_child(status_label)
	enter_button = Button.new()
	enter_button.text = "Entrar na vila"
	enter_button.custom_minimum_size = Vector2(175, 52)
	enter_button.pressed.connect(_on_enter_pressed)
	row.add_child(enter_button)


func _map_position(node_id: String) -> Vector2:
	var texture_size: Vector2 = map_background.texture.get_size()
	var scale_factor: float = max(size.x / texture_size.x, size.y / texture_size.y)
	var visible_size: Vector2 = texture_size * scale_factor
	var offset: Vector2 = (size - visible_size) * 0.5
	return offset + MapRules.NODES[node_id]["position"] * visible_size


func _update_positions() -> void:
	if not is_instance_valid(map_background):
		return
	for node_id in node_buttons:
		var button: Button = node_buttons[node_id]
		button.position = _map_position(node_id) - Vector2(27, 27)
	for index in range(MapRules.CONNECTIONS.size()):
		var connection: Array = MapRules.CONNECTIONS[index]
		route_lines[index].points = PackedVector2Array([
			_map_position(connection[0]), _map_position(connection[1])
		])
	if is_instance_valid(avatar) and not moving:
		avatar.position = _map_position(current_node) - Vector2(34, 91)


func _refresh_state() -> void:
	for index in range(MapRules.CONNECTIONS.size()):
		var connection: Array = MapRules.CONNECTIONS[index]
		var unlocked: bool = MapRules.is_unlocked(connection[1], bridge_completed, road_story_completed)
		route_lines[index].default_color = Color(0.94, 0.75, 0.34, 0.92) if unlocked else Color(0.34, 0.35, 0.38, 0.62)
		route_lines[index].visible = road_story_completed or connection[1] != "citadel"
	for node_id in node_buttons:
		var point: Button = node_buttons[node_id]
		var unlocked: bool = MapRules.is_unlocked(node_id, bridge_completed, road_story_completed)
		point.visible = road_story_completed or node_id != "citadel"
		point.modulate = Color.WHITE if unlocked else Color(0.45, 0.45, 0.45)
		point.text = "●" if node_id == current_node else "◆"
	enter_button.visible = current_node == "village" or current_node == "citadel"
	enter_button.text = "Entrar na Cidadela" if current_node == "citadel" else "Entrar na vila"
	if MissionManager.is_mission_active("shadows_citadel") and current_node != "citadel":
		status_label.text = "Missão de Aniri disponível: siga até a Cidadela Abandonada para iniciar a infiltração."
	else:
		status_label.text = "Você está em %s. Toque num ponto ligado pela estrada para viajar." % MapRules.get_node_name(current_node)


func _on_node_pressed(node_id: String) -> void:
	if moving:
		return
	if node_id == current_node:
		status_label.text = "Você já está em %s." % MapRules.get_node_name(node_id)
		return
	if not MapRules.is_unlocked(node_id, bridge_completed, road_story_completed):
		status_label.text = "A Ponte Esmeralda precisa ser concluída." if node_id == "bridge" else "A Cidadela Abandonada será revelada após o encontro com Litz e Arievilo e a conclusão da ponte."
		return
	if not MapRules.can_travel(current_node, node_id, bridge_completed, road_story_completed):
		status_label.text = "Viaje primeiro pelo próximo ponto da estrada."
		return
	moving = true
	status_label.text = "Seguindo para %s..." % MapRules.get_node_name(node_id)
	var tween: Tween = create_tween()
	tween.tween_property(avatar, "position", _map_position(node_id) - Vector2(34, 91), 0.65)
	await tween.finished
	current_node = node_id
	moving = false
	_save_current_node()
	_refresh_state()
	if current_node == "citadel":
		status_label.text = "Cidadela Abandonada alcançada. Aniri pode iniciar a infiltração."


func _save_current_node() -> void:
	var save_path: String = SaveManager.get_active_save_path()
	var save_data: Dictionary = SaveManager.read_save_data(save_path)
	if save_data.is_empty():
		return
	save_data["world_map_node"] = current_node
	if not SaveManager.write_save_data(save_path, save_data):
		push_warning("Não foi possível salvar a posição no mapa do mundo.")


func _on_enter_pressed() -> void:
	if moving:
		return
	if current_node == "citadel":
		GameState.current_location = "citadel"
		SceneTransition.change_scene_to_file("res://Scene/citadel_stealth.tscn")
		return
	if current_node != "village":
		return
	if SaveManager.save_village_state():
		SceneTransition.change_scene_to_file("res://Scene/village.tscn")
	else:
		status_label.text = "Não foi possível salvar o retorno à vila."


func _on_back_pressed() -> void:
	if moving:
		return
	var scene_path: String = "res://Scene/village.tscn"
	match GameState.current_location:
		"temple_road":
			scene_path = "res://Scene/temple_road.tscn"
		"temple_gate":
			scene_path = "res://Scene/temple_gate.tscn"
		"temple_hall":
			scene_path = "res://Scene/temple_hall.tscn"
		"citadel":
			scene_path = "res://Scene/temple_hall.tscn"
	SceneTransition.change_scene_to_file(scene_path)
