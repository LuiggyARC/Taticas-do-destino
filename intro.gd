extends Control


const COMPANY_LOGO_PATH := (
	"res://Assets/UI/company_logo.png"
)

const COMPANY_NAME := "LarcStudio"

const MENU_SCENE_PATH := (
	"res://Scene/main_menu.tscn"
)

const DEVELOPMENT_MESSAGE := (
	"Este jogo ainda está em fase de desenvolvimento.\n"
	+ "A versão final poderá ser bastante diferente desta versão de teste.\n"
	+ "O design visual e a trilha sonora ainda não foram definidos.\n"
	+ "A dificuldade avançada do jogo ainda não está implementada.\n"
	+ "Mesmo assim, a sorte nos dados pode tornar cada batalha mais fácil ou mais difícil.\n"
	+ "Afinal, tudo depende do destino que os dados lhe reservam.\n"
	+ "O jogo será totalmente dublado mas por enquanto apenas o inicio\n"
	+ "Bem vindo a Taticas do Destino, Esta é a versão 10.2 de teste."
)


var company_screen: Control
var development_screen: Control

var company_box: VBoxContainer
var development_box: VBoxContainer

var logo_rect: TextureRect
var company_label: Label
var development_label: Label
var continue_label: Label

var fade_overlay: ColorRect

var can_advance: bool = false
var intro_finished: bool = false


func _ready():
	set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	create_intro_ui()
	play_intro_sequence()


func create_intro_ui():
	create_company_screen()
	create_development_screen()
	create_fade_overlay()
	center_intro_elements()


func create_company_screen():
	company_screen = Control.new()
	company_screen.name = "CompanyScreen"
	
	company_screen.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	company_screen.modulate.a = 0.0
	add_child(company_screen)
	
	var company_background := ColorRect.new()
	company_background.name = "CompanyBackground"
	
	company_background.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	company_background.color = Color.BLACK
	company_background.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	company_screen.add_child(company_background)
	
	company_box = VBoxContainer.new()
	company_box.name = "CompanyBox"
	
	company_box.custom_minimum_size = Vector2(
		700,
		390
	)
	
	company_box.size = Vector2(
		700,
		390
	)
	
	company_box.alignment = (
		BoxContainer.ALIGNMENT_CENTER
	)
	
	company_box.add_theme_constant_override(
		"separation",
		20
	)
	
	company_screen.add_child(company_box)
	
	logo_rect = TextureRect.new()
	logo_rect.name = "CompanyLogo"
	
	logo_rect.custom_minimum_size = Vector2(
		560,
		260
	)
	
	logo_rect.expand_mode = (
		TextureRect.EXPAND_IGNORE_SIZE
	)
	
	logo_rect.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	)
	
	logo_rect.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	var logo_texture = load(
		COMPANY_LOGO_PATH
	)
	
	if logo_texture != null:
		logo_rect.texture = logo_texture
	else:
		print(
			"Logo da empresa não encontrada: ",
			COMPANY_LOGO_PATH
		)
	
	company_box.add_child(logo_rect)
	
	company_label = Label.new()
	company_label.name = "CompanyName"
	company_label.text = COMPANY_NAME
	
	company_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	company_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	company_label.custom_minimum_size = Vector2(
		700,
		60
	)
	
	company_label.add_theme_font_size_override(
		"font_size",
		34
	)
	
	company_label.add_theme_color_override(
		"font_color",
		Color.WHITE
	)
	
	company_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	company_label.add_theme_constant_override(
		"outline_size",
		4
	)
	
	company_box.add_child(company_label)


func create_development_screen():
	development_screen = Control.new()
	development_screen.name = "DevelopmentScreen"
	
	development_screen.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	development_screen.modulate.a = 0.0
	add_child(development_screen)
	
	var black_background := ColorRect.new()
	black_background.name = "DevelopmentBackground"
	
	black_background.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	black_background.color = Color.BLACK
	black_background.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	development_screen.add_child(
		black_background
	)
	
	development_box = VBoxContainer.new()
	development_box.name = "DevelopmentBox"
	
	development_box.custom_minimum_size = Vector2(
		960,
		360
	)
	
	development_box.size = Vector2(
		960,
		360
	)
	
	development_box.alignment = (
		BoxContainer.ALIGNMENT_CENTER
	)
	
	development_box.add_theme_constant_override(
		"separation",
		45
	)
	
	development_screen.add_child(
		development_box
	)
	
	development_label = Label.new()
	development_label.name = "DevelopmentMessage"
	development_label.text = DEVELOPMENT_MESSAGE
	
	development_label.custom_minimum_size = Vector2(
		960,
		230
	)
	
	development_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	development_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	development_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	
	development_label.add_theme_font_size_override(
		"font_size",
		30
	)
	
	development_label.add_theme_color_override(
		"font_color",
		Color(
			0.92,
			0.92,
			0.92,
			1.0
		)
	)
	
	development_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	development_label.add_theme_constant_override(
		"outline_size",
		3
	)
	
	development_box.add_child(
		development_label
	)
	
	continue_label = Label.new()
	continue_label.name = "ContinueLabel"
	continue_label.text = "Toque para avançar"
	
	continue_label.custom_minimum_size = Vector2(
		960,
		60
	)
	
	continue_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	
	continue_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	
	continue_label.add_theme_font_size_override(
		"font_size",
		25
	)
	
	continue_label.add_theme_color_override(
		"font_color",
		Color(
			0.82,
			0.68,
			0.30,
			1.0
		)
	)
	
	continue_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	
	continue_label.add_theme_constant_override(
		"outline_size",
		3
	)
	
	development_box.add_child(
		continue_label
	)


func create_fade_overlay():
	fade_overlay = ColorRect.new()
	fade_overlay.name = "FadeOverlay"
	
	fade_overlay.set_anchors_preset(
		Control.PRESET_FULL_RECT
	)
	
	fade_overlay.offset_left = 0
	fade_overlay.offset_top = 0
	fade_overlay.offset_right = 0
	fade_overlay.offset_bottom = 0
	
	fade_overlay.color = Color(
		0,
		0,
		0,
		0
	)
	
	fade_overlay.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	add_child(fade_overlay)


func play_intro_sequence():
	var tween := create_tween()
	
	tween.tween_property(
		company_screen,
		"modulate:a",
		1.0,
		1.0
	)
	
	tween.tween_interval(1.8)
	
	tween.tween_property(
		company_screen,
		"modulate:a",
		0.0,
		0.8
	)
	
	tween.tween_interval(0.25)
	
	tween.tween_property(
		development_screen,
		"modulate:a",
		1.0,
		0.8
	)
	
	tween.tween_interval(0.25)
	tween.finished.connect(enable_advance)


func enable_advance():
	can_advance = true
	start_continue_blink()


func start_continue_blink():
	if intro_finished:
		return
	
	if not is_instance_valid(continue_label):
		return
	
	var blink_tween := create_tween()
	blink_tween.set_loops()
	
	blink_tween.tween_property(
		continue_label,
		"modulate:a",
		0.35,
		0.65
	)
	
	blink_tween.tween_property(
		continue_label,
		"modulate:a",
		1.0,
		0.65
	)


func center_intro_elements():
	var screen_size: Vector2 = (
		get_viewport_rect().size
	)
	
	if is_instance_valid(company_box):
		company_box.position = Vector2(
			(
				screen_size.x
				- company_box.size.x
			) / 2.0,
			(
				screen_size.y
				- company_box.size.y
			) / 2.0
		)
	
	if is_instance_valid(development_box):
		development_box.position = Vector2(
			(
				screen_size.x
				- development_box.size.x
			) / 2.0,
			(
				screen_size.y
				- development_box.size.y
			) / 2.0
		)


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		center_intro_elements()


func _input(event):
	if not can_advance:
		return
	
	if intro_finished:
		return
	
	if (
		event is InputEventMouseButton
		and event.pressed
	):
		go_to_menu()
		return
	
	if (
		event is InputEventScreenTouch
		and event.pressed
	):
		go_to_menu()
		return
	
	if (
		event is InputEventKey
		and event.pressed
	):
		go_to_menu()


func go_to_menu():
	if intro_finished:
		return
	
	intro_finished = true
	can_advance = false
	
	if UIAudioManager != null:
		if UIAudioManager.has_method("play_confirm"):
			UIAudioManager.play_confirm()
	
	if MusicManage != null:
		if MusicManage.has_method("play_intro_music"):
			MusicManage.play_intro_music()
	
	var tween := create_tween()
	
	tween.tween_property(
		fade_overlay,
		"color:a",
		1.0,
		0.45
	)
	
	tween.tween_interval(0.15)
	tween.finished.connect(change_to_menu_scene)


func change_to_menu_scene():
	get_tree().change_scene_to_file(
		MENU_SCENE_PATH
	)
