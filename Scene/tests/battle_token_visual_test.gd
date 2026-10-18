extends Node2D

const TokenVisual = preload("res://Scene/battle_unit_token.gd")


func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color(0.12, 0.16, 0.18)
	background.size = get_viewport_rect().size
	add_child(background)
	var examples: Array[Dictionary] = [
		{"name": "Sir Uiliam", "path": "res://Assets/Characters/SrUiliam.png", "faction": "ally", "active": true},
		{"name": "Aniri", "path": "res://Assets/Characters/AniriLadina.png", "faction": "ally"},
		{"name": "Guarda", "path": "res://Assets/Characters/Soldado ferido.png", "faction": "ai_ally"},
		{"name": "Cultista", "path": "res://Assets/Characters/Cultista1.png", "faction": "enemy"},
		{"name": "Rato Atroz", "path": "", "faction": "enemy"},
		{"name": "Lobo", "path": "res://Assets/Characters/Lobo cultista.png", "faction": "companion"}
	]
	for index in range(examples.size()):
		var definition: Dictionary = examples[index]
		var token: Node2D = TokenVisual.new()
		token.position = Vector2(100 + index * 105, 115)
		add_child(token)
		token.configure(str(definition["path"]), str(definition["faction"]), str(definition["name"]))
		token.set_active(bool(definition.get("active", false)))
		if str(definition["path"]) != "":
			assert(token.get_node_or_null("BattlePortrait") != null)
			assert(token.get_node("BattlePortrait").material is ShaderMaterial)
			assert(token.get_node("BattlePortrait").size == Vector2(42, 42))
		var label := Label.new()
		label.text = str(definition["name"])
		label.position = token.position + Vector2(-45, 40)
		label.size = Vector2(90, 24)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(label)
	for frame in range(5):
		await get_tree().process_frame
	var preview_path: String = ProjectSettings.globalize_path("user://battle_token_preview.png")
	var preview_image: Image = get_viewport().get_texture().get_image()
	if preview_image != null:
		preview_image = preview_image.get_region(Rect2i(35, 55, 690, 145))
		assert(preview_image.save_png(preview_path) == OK)
		print("Battle token visual test passed: ", preview_path)
	else:
		print("Battle token visual structure passed; preview unavailable in headless mode")
	get_tree().quit(0)
