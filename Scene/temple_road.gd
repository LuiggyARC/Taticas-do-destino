extends Control

const ROAD_MAP_PATH := "res://Assets/Maps/Caminho do templo.jpg"
const FEEDBACK_URL := "https://docs.google.com/forms/d/e/1FAIpQLSdVqP7LyWeAEgfNX19Q9HgOJkb5CmsrIM9nA867sEn6D13Aiw/viewform?usp=publish-editor"

var objective_label: Label
var menu_button: Button
var test_end_overlay: ColorRect
var feedback_status_label: Label


func _ready() -> void:
	GameState.current_location = "temple_road"
	_build_background()
	_build_header()
	objective_label.text = "Versão de teste concluída"
	call_deferred("_show_test_end")


func _build_background() -> void:
	var map_texture: Texture2D = load(ROAD_MAP_PATH) as Texture2D
	var background := TextureRect.new()
	background.name = "CaminhoDoTemplo"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.texture = map_texture
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)


func _build_header() -> void:
	var header := PanelContainer.new()
	header.name = "RoadHeader"
	header.anchor_left = 0.02
	header.anchor_right = 0.98
	header.offset_top = 16.0
	header.offset_bottom = 84.0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.04, 0.05, 0.89)
	style.border_color = Color(0.72, 0.55, 0.24)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	header.add_theme_stylebox_override("panel", style)
	add_child(header)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	header.add_child(row)
	menu_button = Button.new()
	menu_button.text = "Menu principal"
	menu_button.custom_minimum_size = Vector2(180, 52)
	menu_button.add_theme_font_size_override("font_size", 20)
	menu_button.pressed.connect(_on_menu_pressed)
	row.add_child(menu_button)
	objective_label = Label.new()
	objective_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	objective_label.add_theme_font_size_override("font_size", 23)
	objective_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.63))
	row.add_child(objective_label)
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(180, 0)
	row.add_child(spacer)


func _show_test_end() -> void:
	if is_instance_valid(test_end_overlay):
		return
	test_end_overlay = ColorRect.new()
	test_end_overlay.name = "TestEndOverlay"
	test_end_overlay.color = Color(0.01, 0.02, 0.03, 0.82)
	test_end_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	test_end_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(test_end_overlay)

	var card := PanelContainer.new()
	card.anchor_left = 0.16
	card.anchor_top = 0.18
	card.anchor_right = 0.84
	card.anchor_bottom = 0.82
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.025, 0.04, 0.045, 0.97)
	card_style.border_color = Color(0.72, 0.55, 0.24)
	card_style.set_border_width_all(2)
	card_style.set_corner_radius_all(12)
	card.add_theme_stylebox_override("panel", card_style)
	test_end_overlay.add_child(card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	card.add_child(margin)
	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 16)
	margin.add_child(content)

	var title := Label.new()
	title.text = "VERSÃO DE TESTE CONCLUÍDA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.52))
	content.add_child(title)

	var message := Label.new()
	message.text = "Obrigado por jogar Táticas do Destino! Sua opinião pode ajudar a melhorar a próxima versão."
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_font_size_override("font_size", 20)
	content.add_child(message)

	var feedback_button := Button.new()
	feedback_button.text = "Contar minha experiência"
	feedback_button.custom_minimum_size = Vector2(0, 60)
	feedback_button.add_theme_font_size_override("font_size", 22)
	feedback_button.pressed.connect(_on_feedback_pressed)
	content.add_child(feedback_button)

	var main_menu_button := Button.new()
	main_menu_button.text = "Voltar ao menu principal"
	main_menu_button.custom_minimum_size = Vector2(0, 56)
	main_menu_button.add_theme_font_size_override("font_size", 20)
	main_menu_button.pressed.connect(_on_menu_pressed)
	content.add_child(main_menu_button)

	feedback_status_label = Label.new()
	feedback_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	feedback_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feedback_status_label.add_theme_font_size_override("font_size", 16)
	content.add_child(feedback_status_label)


func _on_feedback_pressed() -> void:
	if OS.shell_open(FEEDBACK_URL) != OK:
		feedback_status_label.text = "Não foi possível abrir o formulário neste dispositivo."


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
