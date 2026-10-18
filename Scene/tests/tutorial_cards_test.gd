extends Control

const TutorialScript = preload("res://Scene/battle_tutorial.gd")


func _ready() -> void:
	get_window().size = Vector2i(1280, 720)
	var tutorial: Control = TutorialScript.new()
	add_child(tutorial)
	var plaza_steps: Array[Dictionary] = [{
		"title": "Prepare sua equipe na Praça Central",
		"text": "A área destacada abre a formação do grupo. Escolha quem acompanhará o herói antes de partir; você pode voltar à praça para trocar companheiros depois.",
		"target": "central_square",
		"hint": "Toque na praça.",
		"button_text": "Abrir formação",
		"allow_skip": false
	}]
	tutorial.start_tutorial(plaza_steps, func(_target: String) -> Rect2:
		return Rect2(400, 300, 100, 100)
	)
	assert(tutorial.title_label.text == "Prepare sua equipe na Praça Central")
	assert(tutorial.next_button.text == "Abrir formação")
	assert(not tutorial.skip_button.visible)
	assert(not tutorial.back_button.visible)
	assert(tutorial.target_rect.has_area())
	get_window().size = Vector2i(360, 640)
	await get_tree().process_frame
	tutorial.update_target()
	assert(tutorial.card.position.x >= 0)
	assert(tutorial.card.position.x + tutorial.card.size.x <= get_viewport_rect().size.x)
	assert(tutorial.card.position.y + tutorial.card.size.y <= get_viewport_rect().size.y)
	tutorial.next_step()
	assert(not tutorial.visible)
	get_window().size = Vector2i(1280, 720)

	var basement_steps: Array[Dictionary] = [
		{"title": "Linha de frente", "text": "Proteja os aliados.", "target": "frontliner", "hint": "Sir Uiliam"},
		{"title": "Flanqueio", "text": "O Rato Atroz tem CA 16. Posicione dois aliados em lados opostos, junto dele. Assim, ele concede Vantagem de Combate: todos recebem +2 para acertá-lo, inclusive à distância. Um ladino também pode fazer Ataque Furtivo.", "target": "dire_rat", "hint": "Lados opostos"}
	]
	tutorial.start_tutorial(basement_steps, func(_target: String) -> Rect2:
		return Rect2(500, 350, 80, 80)
	)
	assert(tutorial.skip_button.visible)
	assert(tutorial.back_button.visible)
	assert(tutorial.back_button.disabled)
	tutorial.next_step()
	await get_tree().process_frame
	tutorial.update_target()
	assert(tutorial.title_label.text == "Flanqueio")
	assert(not tutorial.back_button.disabled)
	assert(tutorial.target_hint_label.text == "Lados opostos")
	assert(tutorial.card.position.x >= 0)
	assert(tutorial.card.position.x + tutorial.card.size.x <= get_viewport_rect().size.x)
	assert(tutorial.card.position.y + tutorial.card.size.y <= get_viewport_rect().size.y)
	get_window().size = Vector2i(360, 640)
	tutorial.title_label.add_theme_font_size_override("font_size", 31)
	tutorial.body_label.add_theme_font_size_override("font_size", 24)
	tutorial.target_hint_label.add_theme_font_size_override("font_size", 19)
	tutorial.back_button.custom_minimum_size.y = 62
	tutorial.skip_button.custom_minimum_size.y = 62
	tutorial.next_button.custom_minimum_size.y = 62
	await get_tree().process_frame
	tutorial.update_target()
	assert(tutorial.card.position.x >= 0)
	assert(tutorial.card.position.x + tutorial.card.size.x <= get_viewport_rect().size.x)
	assert(tutorial.card.position.y + tutorial.card.size.y <= get_viewport_rect().size.y)
	print("Tutorial cards tests passed")
	get_tree().quit(0)
