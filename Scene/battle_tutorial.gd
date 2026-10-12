extends Control

signal closed(completed: bool)
signal step_changed(target_name: String)

var steps: Array[Dictionary] = []
var target_resolver: Callable
var step_index: int = 0
var target_rect: Rect2 = Rect2()
var area_rects: Array[Rect2] = []

var card: PanelContainer
var title_label: Label
var body_label: Label
var progress_label: Label
var back_button: Button
var next_button: Button
var arrow_label: Label

func _ready() -> void:
	name = "BattleTutorial"
	set_anchors_preset(Control.PRESET_FULL_RECT)
	z_index = 100
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	build_card()

func build_card() -> void:
	card = PanelContainer.new()
	card.name = "TutorialCard"
	card.custom_minimum_size.x = 820 if OS.has_feature("mobile") else 650
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.035, 0.045, 0.98)
	style.border_color = Color(0.95, 0.76, 0.34)
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	style.set_content_margin_all(18)
	card.add_theme_stylebox_override("panel", style)
	add_child(card)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	card.add_child(content)

	progress_label = Label.new()
	progress_label.add_theme_font_size_override("font_size", 17 if not OS.has_feature("mobile") else 23)
	progress_label.modulate = Color(0.92, 0.72, 0.35)
	content.add_child(progress_label)

	title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 25 if not OS.has_feature("mobile") else 34)
	content.add_child(title_label)

	body_label = Label.new()
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_label.custom_minimum_size.y = 70 if not OS.has_feature("mobile") else 100
	body_label.add_theme_font_size_override("font_size", 19 if not OS.has_feature("mobile") else 27)
	content.add_child(body_label)

	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_END
	actions.add_theme_constant_override("separation", 12)
	content.add_child(actions)

	back_button = Button.new()
	back_button.text = "Voltar"
	back_button.custom_minimum_size = Vector2(110, 48)
	back_button.pressed.connect(previous_step)
	actions.add_child(back_button)

	var skip_button := Button.new()
	skip_button.text = "Pular tutorial"
	skip_button.custom_minimum_size = Vector2(160, 48)
	skip_button.pressed.connect(skip_tutorial)
	actions.add_child(skip_button)

	next_button = Button.new()
	next_button.text = "Próximo"
	next_button.custom_minimum_size = Vector2(135, 48)
	next_button.pressed.connect(next_step)
	actions.add_child(next_button)

	arrow_label = Label.new()
	arrow_label.text = "▼"
	arrow_label.add_theme_font_size_override("font_size", 38 if not OS.has_feature("mobile") else 52)
	arrow_label.add_theme_color_override("font_color", Color(1.0, 0.80, 0.30))
	arrow_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(arrow_label)

func start_tutorial(new_steps: Array[Dictionary], resolver: Callable) -> void:
	if new_steps.is_empty():
		return
	steps = new_steps.duplicate(true)
	target_resolver = resolver
	step_index = 0
	visible = true
	show_step()

func show_step() -> void:
	if steps.is_empty():
		return
	var step: Dictionary = steps[step_index]
	progress_label.text = str(step.get("progress_text", "TUTORIAL  %d / %d" % [step_index + 1, steps.size()]))
	title_label.text = str(step.get("title", "Dica de combate"))
	body_label.text = str(step.get("text", ""))
	back_button.disabled = step_index == 0
	next_button.text = str(step.get(
		"button_text",
		"Entendi" if step_index == steps.size() - 1 else "Próximo"
	))
	card.reset_size()
	step_changed.emit(str(step.get("target", "")))
	update_target()

func previous_step() -> void:
	if step_index <= 0:
		return
	step_index -= 1
	show_step()

func next_step() -> void:
	if step_index + 1 >= steps.size():
		finish_tutorial(true)
		return
	step_index += 1
	show_step()

func skip_tutorial() -> void:
	finish_tutorial(false)

func finish_tutorial(completed: bool) -> void:
	visible = false
	steps.clear()
	target_rect = Rect2()
	area_rects.clear()
	closed.emit(completed)

func _process(_delta: float) -> void:
	if visible:
		update_target()

func update_target() -> void:
	if not visible or steps.is_empty():
		return
	target_rect = Rect2()
	area_rects.clear()
	if target_resolver.is_valid():
		var result: Variant = target_resolver.call(str(steps[step_index].get("target", "")))
		if result is Rect2:
			target_rect = result
		elif result is Array:
			for rect in result:
				if rect is Rect2 and rect.has_area():
					area_rects.append(rect)
	var screen_size: Vector2 = get_viewport_rect().size
	var card_width: float = minf(card.custom_minimum_size.x, screen_size.x - 24.0)
	card.custom_minimum_size.x = card_width
	card.reset_size()
	card.position.x = (screen_size.x - card.size.x) * 0.5
	if not area_rects.is_empty():
		card.position.y = 14.0
	elif target_rect.has_area() and target_rect.get_center().y > screen_size.y * 0.54:
		card.position.y = 14.0
	else:
		card.position.y = screen_size.y - card.size.y - 14.0
	card.position.y = maxf(14.0, card.position.y)
	arrow_label.visible = target_rect.has_area()
	if arrow_label.visible:
		arrow_label.position = Vector2(
			clampf(target_rect.get_center().x - 16.0, 0.0, screen_size.x - 40.0),
			maxf(0.0, target_rect.position.y - 48.0)
		)
	queue_redraw()

func _draw() -> void:
	if not visible:
		return
	var screen_size: Vector2 = get_viewport_rect().size
	var shade := Color(0.0, 0.0, 0.0, 0.72)
	if not area_rects.is_empty():
		draw_rect(Rect2(Vector2.ZERO, screen_size), shade)
		var area_target: String = str(steps[step_index].get("target", ""))
		for rect in area_rects:
			if area_target == "movement_area":
				draw_rect(rect, Color(0.0, 0.66, 1.0, 0.58))
				draw_rect(rect.grow(-2.0), Color(0.35, 0.82, 1.0, 0.86), false, 2.0)
			elif area_target == "spell_target_area":
				draw_rect(rect, Color(0.33, 0.20, 0.72, 0.42))
				draw_rect(rect.grow(-2.0), Color(0.77, 0.56, 1.0, 0.95), false, 3.0)
			else:
				draw_rect(rect.grow(-2.0), Color(1.0, 0.32, 0.24, 0.95), false, 4.0)
		return
	if not target_rect.has_area():
		draw_rect(Rect2(Vector2.ZERO, screen_size), shade)
		return
	var focus := target_rect.grow(8.0)
	focus.position.x = clampf(focus.position.x, 0.0, screen_size.x)
	focus.position.y = clampf(focus.position.y, 0.0, screen_size.y)
	focus.size.x = minf(focus.size.x, screen_size.x - focus.position.x)
	focus.size.y = minf(focus.size.y, screen_size.y - focus.position.y)
	draw_rect(Rect2(0, 0, screen_size.x, focus.position.y), shade)
	draw_rect(Rect2(0, focus.end.y, screen_size.x, screen_size.y - focus.end.y), shade)
	draw_rect(Rect2(0, focus.position.y, focus.position.x, focus.size.y), shade)
	draw_rect(Rect2(focus.end.x, focus.position.y, screen_size.x - focus.end.x, focus.size.y), shade)
	draw_rect(focus, Color(1.0, 0.78, 0.28), false, 5.0)
