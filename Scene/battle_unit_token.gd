extends Node2D

const PORTRAIT_MASK := preload("res://Scene/battle_token_mask.gdshader")

var faction: String = "ally"
var kind: String = ""
var active: bool = false
var portrait: TextureRect


func configure(portrait_path: String, new_faction: String, new_kind: String = "") -> void:
	faction = new_faction
	kind = new_kind.to_lower()
	if is_instance_valid(portrait):
		remove_child(portrait)
		portrait.queue_free()
		portrait = null
	var texture: Texture2D = _load_portrait(portrait_path)
	if texture != null:
		portrait = TextureRect.new()
		portrait.name = "BattlePortrait"
		portrait.texture = texture
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_SCALE
		portrait.position = Vector2(-21, -21)
		portrait.size = Vector2(42, 42)
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		portrait.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		var mask := ShaderMaterial.new()
		mask.shader = PORTRAIT_MASK
		mask.set_shader_parameter("focus_rect", _portrait_focus(texture, portrait_path))
		portrait.material = mask
		add_child(portrait)
	queue_redraw()


func set_active(value: bool) -> void:
	if active == value:
		return
	active = value
	queue_redraw()


func _draw() -> void:
	var team_color: Color = _team_color()
	draw_circle(Vector2(2, 5), 27, Color(0.0, 0.0, 0.0, 0.44))
	draw_circle(Vector2.ZERO, 26, Color(0.06, 0.07, 0.10))
	draw_circle(Vector2.ZERO, 24, team_color)
	draw_circle(Vector2.ZERO, 21.5, Color(0.10, 0.12, 0.17))
	if not is_instance_valid(portrait):
		_draw_fallback(team_color)
	draw_arc(Vector2.ZERO, 23.8, 0.0, TAU, 64, Color(1.0, 0.91, 0.71, 0.88), 1.6, true)
	draw_circle(Vector2(18, 18), 7.3, Color(0.06, 0.07, 0.10))
	draw_circle(Vector2(18, 18), 5.4, team_color.lightened(0.26))
	if active:
		draw_arc(Vector2.ZERO, 29.0, 0.0, TAU, 64, Color(1.0, 0.81, 0.25, 0.95), 3.0, true)
		draw_colored_polygon(PackedVector2Array([
			Vector2(0, -36), Vector2(5, -30), Vector2(0, -26), Vector2(-5, -30)
		]), Color(1.0, 0.89, 0.38))


func _draw_fallback(team_color: Color) -> void:
	var silhouette: Color = team_color.lightened(0.50)
	if "rato" in kind or "lobo" in kind or "cão" in kind or "pantera" in kind:
		draw_circle(Vector2(-10, -11), 5.5, silhouette)
		draw_circle(Vector2(10, -11), 5.5, silhouette)
		draw_circle(Vector2(0, -3), 12.0, silhouette)
		draw_circle(Vector2(-5, -5), 2.0, Color(0.12, 0.13, 0.17))
		draw_circle(Vector2(5, -5), 2.0, Color(0.12, 0.13, 0.17))
		draw_circle(Vector2(0, 3), 2.3, Color(0.12, 0.13, 0.17))
	else:
		draw_circle(Vector2(0, -8), 8.2, silhouette)
		draw_colored_polygon(PackedVector2Array([
			Vector2(-16, 17), Vector2(-13, 7), Vector2(-7, 2),
			Vector2(7, 2), Vector2(13, 7), Vector2(16, 17)
		]), silhouette.darkened(0.12))


func _team_color() -> Color:
	match faction:
		"enemy":
			return Color(0.83, 0.24, 0.24)
		"companion":
			return Color(0.24, 0.77, 0.47)
		"ai_ally":
			return Color(0.33, 0.73, 0.44)
		_:
			return Color(0.22, 0.54, 0.93)


func _load_portrait(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if path.begins_with("res://"):
		if ResourceLoader.exists(path):
			return load(path) as Texture2D
		return null
	if not FileAccess.file_exists(path):
		return null
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)


func _portrait_focus(texture: Texture2D, path: String) -> Vector4:
	var dimensions: Vector2 = texture.get_size()
	var zoom: float = 0.78 if path.begins_with("res://Assets/Characters/") else 1.0
	var side: float = minf(dimensions.x, dimensions.y) * zoom
	var left: float = (dimensions.x - side) * 0.5
	var top: float = minf(dimensions.y - side, dimensions.y * 0.04)
	return Vector4(left / dimensions.x, top / dimensions.y, side / dimensions.x, side / dimensions.y)


static func npc_portrait_path(npc_id: String) -> String:
	match npc_id:
		"Sr Uiliam": return "res://Assets/Characters/SrUiliam.png"
		"Aniri": return "res://Assets/Characters/AniriLadina.png"
		"Kasum": return "res://Assets/Characters/Kasum.png"
		"Hashagur": return "res://Assets/Characters/Hashagur.png"
		"Guarda Aliado", "Guarda da Ponte": return "res://Assets/Characters/Soldado ferido.png"
		"Jhon": return "res://Assets/Characters/Jhon.png"
	return ""


static func enemy_portrait_path(enemy_id: String) -> String:
	match enemy_id:
		"Goblin Guerreiro": return "res://Assets/Characters/Goblinguerreiro.png"
		"Goblin Dardeiro": return "res://Assets/Characters/Goblindardeiro.png"
		"Cultista": return "res://Assets/Characters/Cultista1.png"
		"Guardião do Culto": return "res://Assets/Characters/Cultista guerreiro.png"
		"Arqueiro do Culto": return "res://Assets/Characters/Arqueiro cultista.png"
		"Ebramir": return "res://Assets/Characters/Ebramir.png"
		"Lobo", "Lobo da Ordem", "Lobo Cultista", "Cão de Caça": return "res://Assets/Characters/Lobo cultista.png"
	return ""


static func companion_portrait_path(companion_type: String) -> String:
	if companion_type == "Lobo":
		return "res://Assets/Characters/Lobo cultista.png"
	return ""
