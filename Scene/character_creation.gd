extends Control
const CHARACTER_CREATION_BACKGROUND_PATH := "res://Assets/UI/CharacterCreation/character_creation_background.jpg"
const ATTRIBUTE_KEYS: Array[String] = ["strength", "dexterity", "constitution", "wisdom", "intelligence", "charisma"]
const CLASS_PRIMARY_ATTRIBUTES := {
	"Bárbaro": "strength",
	"Bardo": "charisma",
	"Bruxo": "charisma",
	"Clérigo": "wisdom",
	"Druida": "wisdom",
	"Feiticeiro": "charisma",
	"Guerreiro": "constitution",
	"Ladino": "dexterity",
	"Mago": "intelligence",
	"Monge": "dexterity",
	"Paladino": "strength",
	"Ranger": "dexterity"
}

var main_creation_panel: PanelContainer
var stats_panel: PanelContainer

var feat_title_label: Label
var feat_selection_container: BoxContainer
var feat_description_container: GridContainer
var feat_options: Array[OptionButton] = []
var feat_description_labels: Array[Label] = []
var feat_choice_options: Array[OptionButton] = []
var feat_choice_labels: Array[Label] = []

var portrait_preview: TextureRect
var portrait_file_dialog: FileDialog
var portrait_status_label: Label
var selected_portrait_path: String = ""
var portrait_section_container: VBoxContainer
var portrait_placeholder_label: Label

var attribute_row_labels: Dictionary = {}
var attribute_help_label: Label
var attribute_rng: RandomNumberGenerator = RandomNumberGenerator.new()

var name_input: LineEdit
var race_option: OptionButton
var human_bonus_option: OptionButton
var class_option: OptionButton
var hp_progression_option: OptionButton
var hp_choice_panel: PanelContainer
var roll_hp_button: Button
var hp_info_label: Label
var stats_label: Label
var class_summary_label: Label
var race_summary_label: Label
var race_details_label: Label
var class_description_label: Label
var final_review_label: Label
var stats_scroll: ScrollContainer
var advanced_stats_scroll: ScrollContainer
var advanced_stats_label: Label
var advanced_stats_button: Button
var advanced_stat_values: Dictionary = {}
var class_strength_labels: Dictionary = {}
var showing_advanced_stats: bool = false
var human_bonus_label: Label
var class_skill_button: Button

var base_strength: int = 10
var base_dexterity: int = 10
var base_constitution: int = 10
var base_wisdom: int = 10
var base_intelligence: int = 8
var base_charisma: int = 8

var companion_label: Label
var companion_option: OptionButton

var rolled_hp_value: int = 0
var has_rolled_hp: bool = false

var selected_race: String = "Humano"
var selected_racial_bonus: String = "FOR"
var selected_class: String = "Bárbaro"
var selected_hp_progression_mode: String = "fixed"
var wide_character_layout: bool = false
var creation_step_one: Control
var creation_step_two: Control
var creation_step_three: Control
var creation_step_one_actions: HBoxContainer
var creation_step_two_actions: HBoxContainer
var creation_step_three_actions: HBoxContainer
var creation_step_subtitle: Label
var creation_title_label: Label

var race_presets := {
	"Humano": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["FOR", "DES", "CON", "SAB", "INT", "CAR"],
		"bonus_amount": 2,
		"traits": ["Rápida Aprendizagem: +2 em um atributo à escolha e 1 talento inicial extra."]
	},
	"Anão": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["CON", "FOR"],
		"bonus_amount": 2,
		"traits": ["Sangue de Ferro: +1 PV máximo permanente a cada nível após o 1º."]
	},
	"Elfo": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["INT", "SAB"],
		"bonus_amount": 2,
		"traits": ["Precisão: +1 na dificuldade de resistir às suas magias e +1 para acertar ataques à distância."]
	},
	"Gnomo": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Pequeno",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["INT", "CAR", "SAB"],
		"bonus_amount": 2,
		"traits": ["Implacável: +1 em Fortitude, Reflexos e Vontade."]
	},
	"Halfling": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Pequeno",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["DES", "SAB"],
		"bonus_amount": 2,
		"traits": ["Golpe Sujo: +1 de dano em ataques e magias contra inimigos flanqueados."]
	},
	"Meio-Elfo": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["FOR", "DES", "CON", "SAB", "INT", "CAR"],
		"bonus_amount": 1,
		"traits": ["Potencial Desperto: +1 em um atributo inicial à escolha; nos níveis 4, 8, 12... recebe 3 pontos em vez de 2."]
	},
	"Meio-Orc": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"bonus_options": ["FOR", "DES", "CON"],
		"bonus_amount": 2,
		"traits": ["Imparável: ao cair a 0 PV, permanece com 1 PV até o fim do próximo turno; recebe +1 nas resistências e +2 de dano nesse período, uma vez por combate."]
	}
}
var class_presets := {
	"Bruxo": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "ruim",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 16,
		"spell_attribute": "charisma",
		"description": "Conjurador de pactos que ataca à distância com poder mágico próprio. Suas habilidades são sem limite, por encontro e diárias; não gastam espaços de magia.",
		"features": [
			"Dado de Vida d8; vida fixa +5 por nível, mais Constituição",
			"Vontade forte; pactos baseados em Carisma",
			"Centelha do Pacto: ataque mágico a até 9 m (sem limite)",
			"Pulso Vinculante: ataque mágico reforçado (por encontro)",
			"Julgamento do Pacto: ataque mágico poderoso (diário)"
		]
	},
	"Bárbaro": {
		"hit_die": 12,
		"fixed_hp_per_level": 8,
		"base_attack_bonus_type": "alto",
		"fortitude_type": "bom",
		"reflex_type": "ruim",
		"will_type": "ruim",
		"reflex_extra_bonus": 2,
		"movement_bonus": 3.0,
		"attack": 20,
		"description": "Guerreiros implacáveis que alternam técnicas sem limite, por encontro e diárias. Excelentes em dano corpo a corpo e sobrevivência.",
		"features": [
			"Habilidades: Golpe Impetuoso (sem limite), Fúria (por encontro) e Golpe Decisivo (diário)",
			"Fúria: aumenta Força e Constituição, mas reduz a CA",
			"+3m de deslocamento",
			"+2 em Reflexos",
			"Redução de Dano 5 no nível 10",
			"Redução de Dano 10 no nível 15"
		]
	},
		"Bardo": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "ruim",
		"reflex_type": "bom",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 16,
		"spell_attribute": "charisma",
		"description": "Artista versátil que usa magias por círculo e usos diários para apoiar o grupo. Mantém Inspirar Coragem como característica de classe.",
		"features": [
			"Dado de Vida d8; vida fixa +5 por nível, mais Constituição",
			"Magias arcanas espontâneas baseadas em Carisma; Inspirar Coragem permanece disponível",
			"Magias conhecidas com usos diários por círculo",
			"Inspirar Coragem: apoio musical ao grupo"
		]
	},
	"Clérigo": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "bom",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 18,
		"spell_attribute": "wisdom",
		"description": "Conjurador divino resistente. Usa magias de cura e proteção por círculo e usos diários para proteger o grupo.",
		"features": [
			"Dado de Vida d8; vida fixa +5 por nível, mais Constituição",
			"Conjuração divina baseada em Sabedoria; magias existentes preservadas",
			"Magias de cura e proteção com usos diários por círculo",
			"Aprende automaticamente as magias disponíveis para seu nível"
		]
	},
		"Druida": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "bom",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 18,
		"spell_attribute": "wisdom",
		"description": "Guardião da natureza com magias por círculo e usos diários, além de um companheiro animal.",
		"features": [
			"Magia divina focada na natureza baseada em Sabedoria",
			"Companheiro Animal",
			"Magias de natureza com usos diários por círculo",
			"Controle de terreno e suporte natural"
		]
	},
	"Feiticeiro": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "baixo",
		"fortitude_type": "ruim",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 14,
		"spell_attribute": "charisma",
		"description": "Conjurador arcano espontâneo de vida moderada e Vontade forte. Suas magias de dano causam +1 por círculo: +1 no 1º, +2 no 2º e assim por diante.",
		"features": [
			"Dado de Vida d8; vida fixa +5 por nível, mais Constituição",
			"Vontade forte; ataque com armas baixo",
			"Conjuração arcana espontânea baseada em Carisma",
			"Poder da Linhagem: +1 de dano por círculo em magias ofensivas (magias de círculo 0 não recebem bônus)",
			"Conhece poucas magias, mas pode conjurá-las muitas vezes",
			"Não precisa preparar magias com antecedência"
		]
	},
		"Guerreiro": {
		"hit_die": 10,
		"fixed_hp_per_level": 6,
		"base_attack_bonus_type": "alto",
		"fortitude_type": "bom",
		"reflex_type": "ruim",
		"will_type": "ruim",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 20,
		"spell_attribute": "none",
		"description": "Combatente versátil de linha de frente. Usa técnicas sem limite, por encontro e diárias para alternar precisão, proteção e impacto.",
		"features": [
			"Dado de Vida d10; vida fixa +6 por nível, mais Constituição",
			"Ataque com armas alto; Fortitude forte",
			"Golpe Técnico: +1 para acertar com arma (sem limite)",
			"Postura Firme: +2 na defesa até o próximo turno (por encontro)",
			"Ruptura de Linha: +2 para acertar e +3 de dano (diário)",
			"Um talento adicional na criação e na progressão da classe"
		]
	},
	"Ladino": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "ruim",
		"reflex_type": "bom",
		"will_type": "ruim",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 16,
		"spell_attribute": "none",
		"description": "Combatente ágil que cria aberturas para golpes precisos. Usa técnicas sem limite, por encontro e diárias; mantém Esconder-se e Ataque Furtivo.",
		"features": [
			"Dado de Vida d8; vida fixa +5 por nível, mais Constituição",
			"Ataque com armas médio; Reflexos fortes",
			"Ataque Furtivo: dano extra contra inimigos flanqueados ou surpreendidos",
			"Passo Oculto: esconder-se uma vez por turno antes de atacar (sem limite)",
			"Brecha Calculada: +2 para acertar com arma (uma vez por encontro)",
			"Corte Decisivo: +4 de dano com arma (uma vez por dia)"
		]
	},
	"Mago": {
		"hit_die": 6,
		"fixed_hp_per_level": 4,
		"base_attack_bonus_type": "baixo",
		"fortitude_type": "ruim",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 12,
		"spell_attribute": "intelligence",
		"description": "Especialista em magia arcana baseada em Inteligência, controle e utilidade. Tem vida baixa, Vontade forte e +1 uso por dia em cada círculo de magia disponível do 1º ao 4º.",
		"features": [
			"Dado de Vida d6; vida fixa +4 por nível, mais Constituição",
			"BBA baixo",
			"Vontade boa",
			"Conjuração arcana baseada em Inteligência",
			"Estudo Arcano: +1 uso de magia por dia em cada círculo disponível do 1º ao 4º",
			"Seleciona as magias conhecidas na criação e ao subir de nível",
			"Pode aprender mais magias que o feiticeiro"
		]
	},
	"Monge": {
		"hit_die": 8,
		"fixed_hp_per_level": 6,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "bom",
		"reflex_type": "bom",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 3.0,
		"attack": 18,
		"spell_attribute": "none",
		"description": "Combatente desarmado móvel, com resistências fortes. Alterna técnicas sem limite, por encontro e diárias.",
		"features": [
			"Dado de Vida d8; vida fixa +6 por nível, mais Constituição",
			"Fortitude, Reflexos e Vontade fortes",
			"Dano desarmado progressivo",
			"Golpe Concentrado: +1 para acertar (sem limite)",
			"Rajada de Golpes: dois golpes (por encontro)",
			"Força Interior: +4 de dano (diário)",
			"Bônus de Sabedoria na CA",
			"Evasão",
			"Imunidades progressivas contra doenças e venenos",
			"Movimento extremamente rápido"
		]
	},
	"Paladino": {
		"hit_die": 10,
		"fixed_hp_per_level": 6,
		"base_attack_bonus_type": "alto",
		"fortitude_type": "bom",
		"reflex_type": "ruim",
		"will_type": "ruim",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 20,
		"spell_attribute": "none",
		"alignment_restriction": "Leal e Bom",
		"description": "Defensor juramentado que alterna técnicas sem limite, por encontro e diárias. Resiste na linha de frente e protege o grupo.",
		"features": [
			"Dado de Vida d10",
			"BBA alto",
			"Fortitude boa",
			"Restrito à tendência Leal e Bom",
			"Habilidades: Golpe Vigilante (sem limite), Investida Consagrada (por encontro) e Veredito Radiante (diário)",
			"Investida Consagrada: soma Carisma no ataque e nível no dano",
			"Cura pelas Mãos",
			"Graça Divina: soma bônus de Carisma em todos os testes de resistência",
			"Montaria Especial no nível 5",
			"Não usa magias; usa apenas poderes sem limite, por encontro e diários"
		]
	},
	"Ranger": {
		"hit_die": 8,
		"fixed_hp_per_level": 5,
		"base_attack_bonus_type": "alto",
		"fortitude_type": "bom",
		"reflex_type": "bom",
		"will_type": "ruim",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 18,
		"spell_attribute": "none",
		"description": "Rastreador ágil que luta à distância ou de perto. Usa poderes sem limite, por encontro e diários; recebe companheiro animal no nível 4, sem magias.",
		"features": [
			"Dado de Vida d8; vida fixa +5 por nível, mais Constituição",
			"Ataque com armas alto; Fortitude e Reflexos fortes",
			"Mira de Campo: +1 para acertar com arma (sem limite)",
			"Passo da Trilha: +3 m de movimento no turno (por encontro)",
			"Caçada Implacável: +4 de dano com arma (diário)",
			"Companheiro Animal a partir do nível 4",
			"Não usa magias; usa apenas poderes de classe"
		]
	},
}
func _ready():
	GameState.player_portrait_path = ""
	roll_initial_attributes_for_class(selected_class)
	
	create_ui()
	create_portrait_selection()
	apply_readable_creation_style()
	update_stats_preview()

func apply_readable_creation_style() -> void:
	var minimum_font_size: int = 27 if OS.has_feature("mobile") else 21
	var minimum_touch_height: float = 60.0 if OS.has_feature("mobile") else 48.0

	for node in find_children("*", "Control", true, false):
		var control := node as Control
		if control is OptionButton:
			var option := control as OptionButton
			option.add_theme_font_size_override(
				"font_size",
				maxi(option.get_theme_font_size("font_size"), minimum_font_size)
			)
			option.custom_minimum_size.y = maxf(
				option.custom_minimum_size.y,
				minimum_touch_height
			)
			option.get_popup().add_theme_font_size_override(
				"font_size",
				minimum_font_size
			)
		elif control is Button:
			var button := control as Button
			button.add_theme_font_size_override(
				"font_size",
				maxi(button.get_theme_font_size("font_size"), minimum_font_size)
			)
			button.custom_minimum_size.y = maxf(
				button.custom_minimum_size.y,
				minimum_touch_height
			)
		elif control is LineEdit:
			var line_edit := control as LineEdit
			line_edit.add_theme_font_size_override(
				"font_size",
				minimum_font_size
			)
			line_edit.custom_minimum_size.y = maxf(
				line_edit.custom_minimum_size.y,
				minimum_touch_height
			)
		elif control is Label:
			var label := control as Label
			label.add_theme_font_size_override(
				"font_size",
				maxi(label.get_theme_font_size("font_size"), minimum_font_size)
			)

func create_portrait_selection() -> void:
	if not is_instance_valid(portrait_section_container):
		return
	var portrait_section := portrait_section_container
	var portrait_title := Label.new()
	portrait_title.text = "Retrato do aventureiro"
	portrait_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_section.add_child(portrait_title)
	
	var preview_panel := PanelContainer.new()
	preview_panel.custom_minimum_size = Vector2(
		0,
		220 if OS.has_feature("mobile") else 250
	)
	preview_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_panel.add_theme_stylebox_override(
		"panel",
		create_fantasy_panel_style(0.90)
	)
	portrait_section.add_child(preview_panel)
	
	portrait_preview = TextureRect.new()
	portrait_preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	portrait_preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
	portrait_preview.expand_mode = (
		TextureRect.EXPAND_IGNORE_SIZE
	)
	portrait_preview.stretch_mode = (
		TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	)
	portrait_preview.tooltip_text = (
		"Prévia do retrato do aventureiro"
	)
	preview_panel.add_child(portrait_preview)
	portrait_placeholder_label = Label.new()
	portrait_placeholder_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	portrait_placeholder_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_placeholder_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	portrait_placeholder_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	portrait_placeholder_label.text = "Seu aventureiro\n\nEscolha um retrato para vê-lo aqui"
	portrait_placeholder_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_preview.add_child(portrait_placeholder_label)
	
	var portrait_controls := VBoxContainer.new()
	portrait_controls.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)
	portrait_controls.add_theme_constant_override(
		"separation",
		8
	)
	portrait_section.add_child(portrait_controls)
	
	var select_portrait_button := Button.new()
	select_portrait_button.text = "Selecionar retrato"
	select_portrait_button.custom_minimum_size = Vector2(
		0,
		48
	)
	select_portrait_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	apply_fantasy_button_style(
		select_portrait_button,
		true
	)
	select_portrait_button.pressed.connect(
		open_portrait_file_dialog
	)
	portrait_controls.add_child(
		select_portrait_button
	)
	
	portrait_status_label = Label.new()
	portrait_status_label.text = (
		"Toque no botão para escolher uma imagem."
	)
	portrait_status_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	portrait_status_label.modulate = Color(
		0.86,
		0.90,
		0.86,
		0.90
	)
	portrait_controls.add_child(
		portrait_status_label
	)
	
	var portrait_tip_label := Label.new()
	portrait_tip_label.text = (
		"Use uma imagem PNG sem fundo (transparente) "
		+ "para o retrato se encaixar nos diálogos."
	)
	portrait_tip_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	portrait_tip_label.modulate = Color(
		1.0,
		0.87,
		0.64,
		0.95
	)
	portrait_controls.add_child(portrait_tip_label)
	
	var privacy_label := Label.new()
	privacy_label.text = (
		"O aparelho solicitará acesso somente à "
		+ "imagem escolhida."
	)
	privacy_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)
	privacy_label.modulate = Color(
		0.72,
		0.78,
		0.72,
		0.85
	)
	portrait_controls.add_child(
		privacy_label
	)
	
	portrait_file_dialog = FileDialog.new()
	portrait_file_dialog.name = "PortraitFileDialog"
	portrait_file_dialog.title = "Escolher retrato"
	portrait_file_dialog.file_mode = (
		FileDialog.FILE_MODE_OPEN_FILE
	)
	portrait_file_dialog.access = (
		FileDialog.ACCESS_FILESYSTEM
	)
	portrait_file_dialog.use_native_dialog = true
	portrait_file_dialog.size = Vector2i(
		900,
		650
	)
	
	portrait_file_dialog.add_filter(
		"*.png",
		"Imagem PNG sem fundo"
	)
	
	portrait_file_dialog.file_selected.connect(
		on_portrait_file_selected
	)
	
	add_child(portrait_file_dialog)

func open_portrait_file_dialog() -> void:
	if not is_instance_valid(
		portrait_file_dialog
	):
		return
	
	portrait_file_dialog.popup_centered_ratio(
		0.85
	)

func on_portrait_file_selected(
	source_path: String
) -> void:
	if source_path.get_extension().to_lower() != "png":
		portrait_status_label.text = "Escolha um arquivo PNG sem fundo."
		return
	var portrait_image := Image.new()
	var load_error := portrait_image.load(
		source_path
	)
	
	if load_error != OK:
		portrait_status_label.text = (
			"Não foi possível abrir esta imagem."
		)
		return
	
	if portrait_image.is_empty():
		portrait_status_label.text = (
			"A imagem selecionada está vazia."
		)
		return
	
	resize_portrait_image_if_needed(
		portrait_image
	)
	
	var portrait_identifier := int(
		Time.get_unix_time_from_system()
	)
	
	var destination_path := (
		"user://player_portrait_%d.png"
		% portrait_identifier
	)
	
	var save_error := portrait_image.save_png(
		destination_path
	)
	
	if save_error != OK:
		portrait_status_label.text = (
			"Não foi possível salvar o retrato."
		)
		return
	
	selected_portrait_path = destination_path
	GameState.player_portrait_path = (
		selected_portrait_path
	)
	
	portrait_preview.texture = (
		ImageTexture.create_from_image(
			portrait_image
		)
	)
	
	portrait_status_label.text = (
		"Retrato selecionado com sucesso."
	)
	if is_instance_valid(portrait_placeholder_label):
		portrait_placeholder_label.hide()

func resize_portrait_image_if_needed(
	portrait_image: Image
) -> void:
	const MAX_PORTRAIT_SIZE: int = 1024
	
	var image_width: int = (
		portrait_image.get_width()
	)
	
	var image_height: int = (
		portrait_image.get_height()
	)
	
	if (
		image_width <= MAX_PORTRAIT_SIZE
		and image_height <= MAX_PORTRAIT_SIZE
	):
		return
	
	var width_scale: float = (
		float(MAX_PORTRAIT_SIZE)
		/ float(image_width)
	)
	
	var height_scale: float = (
		float(MAX_PORTRAIT_SIZE)
		/ float(image_height)
	)
	
	var resize_scale: float = minf(
		width_scale,
		height_scale
	)
	
	var resized_width: int = maxi(
		1,
		int(
			float(image_width)
			* resize_scale
		)
	)
	
	var resized_height: int = maxi(
		1,
		int(
			float(image_height)
			* resize_scale
		)
	)
	
	portrait_image.resize(
		resized_width,
		resized_height,
		Image.INTERPOLATE_LANCZOS
	)

func create_ui():
	create_background()
	wide_character_layout = get_viewport_rect().size.x >= 1200.0
	
	var root_margin := MarginContainer.new()
	root_margin.name = "UIRoot"
	root_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_margin.add_theme_constant_override("margin_left", 14)
	root_margin.add_theme_constant_override("margin_top", 12)
	root_margin.add_theme_constant_override("margin_right", 14)
	root_margin.add_theme_constant_override("margin_bottom", 12)
	add_child(root_margin)
	
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 10)
	root_margin.add_child(page)

	var header := PanelContainer.new()
	header.custom_minimum_size.y = 76
	header.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.88))
	page.add_child(header)

	var header_text := VBoxContainer.new()
	header_text.alignment = BoxContainer.ALIGNMENT_CENTER
	header.add_child(header_text)

	creation_title_label = Label.new()
	creation_title_label.text = "Criação de Personagem — Tela 1 de 3"
	creation_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	creation_title_label.add_theme_font_size_override("font_size", 36)
	header_text.add_child(creation_title_label)

	creation_step_subtitle = Label.new()
	creation_step_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	creation_step_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	header_text.add_child(creation_step_subtitle)

	if wide_character_layout:
		creation_step_one = HBoxContainer.new()
		creation_step_two = HBoxContainer.new()
		creation_step_three = VBoxContainer.new()
		creation_step_one.add_theme_constant_override("separation", 14)
		creation_step_two.add_theme_constant_override("separation", 14)
	else:
		creation_step_one = TabContainer.new()
		creation_step_two = TabContainer.new()
		creation_step_three = VBoxContainer.new()
		var tab_font_size: int = 38 if OS.has_feature("mobile") else 28
		creation_step_one.add_theme_font_size_override("font_size", tab_font_size)
		creation_step_two.add_theme_font_size_override("font_size", tab_font_size)
	for step in [creation_step_one, creation_step_two, creation_step_three]:
		step.size_flags_vertical = Control.SIZE_EXPAND_FILL
		step.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		page.add_child(step)
	var portrait_panel := PanelContainer.new()
	portrait_panel.name = "Retrato"
	portrait_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	portrait_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	portrait_panel.size_flags_stretch_ratio = 1.2
	portrait_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.86))
	creation_step_one.add_child(portrait_panel)
	var portrait_margin := MarginContainer.new()
	portrait_margin.add_theme_constant_override("margin_left", 12)
	portrait_margin.add_theme_constant_override("margin_right", 12)
	portrait_margin.add_theme_constant_override("margin_top", 12)
	portrait_margin.add_theme_constant_override("margin_bottom", 12)
	portrait_panel.add_child(portrait_margin)
	portrait_section_container = VBoxContainer.new()
	portrait_section_container.add_theme_constant_override("separation", 10)
	portrait_margin.add_child(portrait_section_container)

	var left_column := VBoxContainer.new()
	left_column.name = "Identidade"
	left_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_column.size_flags_stretch_ratio = 1.15
	left_column.add_theme_constant_override("separation", 14)
	creation_step_one.add_child(left_column)

	var middle_column := VBoxContainer.new()
	middle_column.name = "Atributos"
	middle_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	middle_column.size_flags_stretch_ratio = 1.8
	creation_step_two.add_child(middle_column)

	var right_column := VBoxContainer.new()
	right_column.name = "Talentos e revisão"
	right_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_column.add_theme_constant_override("separation", 14)
	creation_step_three.add_child(right_column)
	
	# =========================================================
	# IDENTIDADE E OPÇÕES INICIAIS
	# =========================================================
	main_creation_panel = PanelContainer.new()
	main_creation_panel.custom_minimum_size.x = 0
	main_creation_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_creation_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_creation_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.80))
	left_column.add_child(main_creation_panel)
	
	var creation_scroll := ScrollContainer.new()
	creation_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	creation_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	creation_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_creation_panel.add_child(creation_scroll)
	
	var content := VBoxContainer.new()
	content.custom_minimum_size.x = 0
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 14)
	var content_margin := MarginContainer.new()
	content_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_margin.add_theme_constant_override("margin_left", 18)
	content_margin.add_theme_constant_override("margin_right", 18)
	creation_scroll.add_child(content_margin)
	content_margin.add_child(content)
	
	# Nome
	var name_title := Label.new()
	name_title.text = "Nome do personagem"
	name_title.add_theme_font_size_override("font_size", 18)
	content.add_child(name_title)
	
	name_input = LineEdit.new()
	name_input.placeholder_text = "Digite o nome do herói"
	name_input.text = "Herói"
	name_input.custom_minimum_size = Vector2(0, 46)
	apply_fantasy_line_edit_style(name_input)
	content.add_child(name_input)
	
		# Raça
	var race_title := Label.new()
	race_title.text = "Raça"
	race_title.add_theme_font_size_override("font_size", 18)
	content.add_child(race_title)
	
	race_option = OptionButton.new()
	apply_fantasy_option_button_style(race_option)
	apply_fantasy_option_style(race_option)
	race_option.custom_minimum_size = Vector2(0, 46)
	
	
	var race_names: Array = race_presets.keys()
	race_names.sort()
	
	for race_item_name in race_names:
		race_option.add_item(str(race_item_name))
	
	var selected_race_index: int = 0
	
	for i in range(race_option.item_count):
		if race_option.get_item_text(i) == selected_race:
			selected_race_index = i
			break
	
	race_option.select(selected_race_index)
	race_option.item_selected.connect(on_race_selected)
	content.add_child(race_option)
	
	# O bônus racial é aplicado depois do sorteio dos atributos.
	human_bonus_label = Label.new()
	human_bonus_label.add_theme_font_size_override("font_size", 18)
	content.add_child(human_bonus_label)
	
	human_bonus_option = OptionButton.new()
	apply_fantasy_option_style(human_bonus_option)
	human_bonus_option.custom_minimum_size = Vector2(0, 46)
	human_bonus_option.item_selected.connect(on_human_bonus_selected)
	content.add_child(human_bonus_option)
	race_details_label = Label.new()
	race_details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	race_details_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	race_details_label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.70))
	content.add_child(race_details_label)
	
		# Classe
	var class_title := Label.new()
	class_title.text = "Classe"
	class_title.add_theme_font_size_override("font_size", 18)
	content.add_child(class_title)
	
	class_option = OptionButton.new()
	apply_fantasy_option_button_style(class_option)
	apply_fantasy_option_style(class_option)
	class_option.custom_minimum_size = Vector2(0, 46)
	
	var class_names: Array = class_presets.keys()
	class_names.sort()
	
	for class_item_name in class_names:
		class_option.add_item(str(class_item_name))
	
	var selected_class_index := 0
	
	for i in range(class_option.item_count):
		if class_option.get_item_text(i) == selected_class:
			selected_class_index = i
			break
	
	class_option.select(selected_class_index)
	class_option.item_selected.connect(on_class_selected)
	content.add_child(class_option)
	class_description_label = Label.new()
	class_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	class_description_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(class_description_label)
	create_companion_selection(content)
	
	# Progressão de vida
	var hp_title := Label.new()
	hp_title.text = "Vida ao subir de nível"
	hp_title.add_theme_font_size_override("font_size", 18)
	content.add_child(hp_title)
	
	hp_progression_option = OptionButton.new()
	apply_fantasy_option_style(hp_progression_option)
	hp_progression_option.add_item("Padrão da classe")
	hp_progression_option.add_item("Rolar dado")
	apply_fantasy_option_button_style(hp_progression_option)
	hp_progression_option.custom_minimum_size = Vector2(0, 46)
	
	if selected_hp_progression_mode == "roll":
		hp_progression_option.select(1)
	else:
		hp_progression_option.select(0)
	
	hp_progression_option.item_selected.connect(on_hp_progression_selected)
	content.add_child(hp_progression_option)
	
	
	var hp_row := VBoxContainer.new()
	hp_row.add_theme_constant_override("separation", 10)
	content.add_child(hp_row)
	
	roll_hp_button = Button.new()
	roll_hp_button.text = "Sortear Vida Inicial"
	roll_hp_button.custom_minimum_size = Vector2(260, 48)
	roll_hp_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	apply_fantasy_button_style(roll_hp_button, true)
	roll_hp_button.pressed.connect(roll_starting_hp)
	hp_row.add_child(roll_hp_button)
	
	hp_info_label = Label.new()
	hp_info_label.text = "Apenas para quem escolher o sorteio de vida."
	hp_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hp_info_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hp_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	hp_row.add_child(hp_info_label)
	
	# Cada etapa mantém suas ações visíveis no rodapé.
	creation_step_one_actions = HBoxContainer.new()
	creation_step_one_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	creation_step_one_actions.add_theme_constant_override("separation", 16)
	creation_step_one_actions.custom_minimum_size.y = 72
	page.add_child(creation_step_one_actions)
	
	var back_button := Button.new()
	back_button.text = "Menu principal"
	back_button.custom_minimum_size = Vector2(280, 80)
	apply_fantasy_button_style(back_button, false)
	back_button.pressed.connect(back_to_menu)
	creation_step_one_actions.add_child(back_button)

	var next_button := Button.new()
	next_button.text = "Próximo"
	next_button.custom_minimum_size = Vector2(280, 80)
	apply_fantasy_button_style(next_button, true)
	next_button.pressed.connect(show_second_creation_step)
	creation_step_one_actions.add_child(next_button)

	creation_step_two_actions = HBoxContainer.new()
	creation_step_two_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	creation_step_two_actions.add_theme_constant_override("separation", 16)
	creation_step_two_actions.custom_minimum_size.y = 72
	page.add_child(creation_step_two_actions)

	var previous_button := Button.new()
	previous_button.text = "Voltar"
	previous_button.custom_minimum_size = Vector2(280, 80)
	apply_fantasy_button_style(previous_button, false)
	previous_button.pressed.connect(show_first_creation_step)
	creation_step_two_actions.add_child(previous_button)
	
	var confirm_button := Button.new()
	confirm_button.text = "Próximo"
	confirm_button.custom_minimum_size = Vector2(340, 80)
	apply_fantasy_button_style(confirm_button, true)
	confirm_button.pressed.connect(show_third_creation_step)
	creation_step_two_actions.add_child(confirm_button)
	creation_step_three_actions = HBoxContainer.new()
	creation_step_three_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	creation_step_three_actions.add_theme_constant_override("separation", 16)
	creation_step_three_actions.custom_minimum_size.y = 72
	page.add_child(creation_step_three_actions)
	var feats_back_button := Button.new()
	feats_back_button.text = "Voltar"
	feats_back_button.custom_minimum_size = Vector2(280, 80)
	apply_fantasy_button_style(feats_back_button, false)
	feats_back_button.pressed.connect(show_second_creation_step)
	creation_step_three_actions.add_child(feats_back_button)
	var create_button := Button.new()
	create_button.text = "Criar Personagem"
	create_button.custom_minimum_size = Vector2(340, 80)
	apply_fantasy_button_style(create_button, true)
	create_button.pressed.connect(confirm_character)
	creation_step_three_actions.add_child(create_button)
	
	# =========================================================
	# DESCRIÇÃO RACIAL, DE CLASSE E RESUMO DA FICHA
	# =========================================================
	stats_panel = PanelContainer.new()
	stats_panel.name = "Resumo"
	stats_panel.custom_minimum_size.y = 280
	stats_panel.custom_minimum_size.x = 0
	stats_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stats_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats_panel.size_flags_stretch_ratio = 1.8
	stats_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.72))
	creation_step_one.add_child(stats_panel)
	
	var stats_margin := MarginContainer.new()
	stats_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	stats_margin.add_theme_constant_override("margin_left", 14)
	stats_margin.add_theme_constant_override("margin_top", 14)
	stats_margin.add_theme_constant_override("margin_right", 14)
	stats_margin.add_theme_constant_override("margin_bottom", 14)
	stats_panel.add_child(stats_margin)
	
	var stats_box := VBoxContainer.new()
	stats_box.add_theme_constant_override("separation", 10)
	stats_margin.add_child(stats_box)
	
	var stats_title := Label.new()
	stats_title.text = "Visão Geral do Estilo de Jogo"
	stats_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats_title.add_theme_font_size_override("font_size", 24)
	stats_box.add_child(stats_title)
	
	var separator_4 := HSeparator.new()
	stats_box.add_child(separator_4)
	var strengths := VBoxContainer.new()
	strengths.add_theme_constant_override("separation", 8)
	stats_box.add_child(strengths)
	add_class_strength_row(strengths, "damage", "⚔")
	add_class_strength_row(strengths, "survival", "♥")
	add_class_strength_row(strengths, "magic", "✦")
	
	stats_scroll = ScrollContainer.new()
	stats_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stats_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	stats_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	stats_box.add_child(stats_scroll)
	
	var summary := VBoxContainer.new()
	summary.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	summary.add_theme_constant_override("separation", 10)
	stats_scroll.add_child(summary)
	var summary_cards := HBoxContainer.new()
	summary_cards.add_theme_constant_override("separation", 10)
	summary.add_child(summary_cards)
	class_summary_label = create_summary_card(summary_cards)
	race_summary_label = create_summary_card(summary_cards)
	stats_label = Label.new()
	stats_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stats_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	stats_label.add_theme_font_size_override("font_size", 19)
	summary.add_child(stats_label)
	hp_choice_panel = PanelContainer.new()
	hp_choice_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.60))
	summary.add_child(hp_choice_panel)
	var hp_choice_box := VBoxContainer.new()
	hp_choice_box.add_theme_constant_override("separation", 8)
	hp_choice_panel.add_child(hp_choice_box)
	hp_title.reparent(hp_choice_box)
	hp_progression_option.reparent(hp_choice_box)
	hp_row.reparent(hp_choice_box)
	summary.move_child(stats_label, 0)
	summary.move_child(hp_choice_panel, 1)

	advanced_stats_scroll = ScrollContainer.new()
	advanced_stats_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	advanced_stats_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	advanced_stats_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	stats_box.add_child(advanced_stats_scroll)
	advanced_stats_scroll.hide()

	var advanced_box := VBoxContainer.new()
	advanced_box.custom_minimum_size.x = 0
	advanced_box.add_theme_constant_override("separation", 10)
	advanced_stats_scroll.add_child(advanced_box)
	add_advanced_stat_row(advanced_box, "DV", "Dado de Vida: define a vida que a classe pode ganhar por nível.")
	add_advanced_stat_row(advanced_box, "BBA", "Bônus Base de Ataque: aptidão da classe para acertar ataques.")
	add_advanced_stat_row(advanced_box, "FORT", "Fortitude: resistência contra venenos, doenças e outros efeitos físicos.")
	add_advanced_stat_row(advanced_box, "REF", "Reflexos: capacidade de evitar perigos rápidos, como armadilhas.")
	add_advanced_stat_row(advanced_box, "VON", "Vontade: resistência contra medo e efeitos mentais.")

	advanced_stats_label = Label.new()
	advanced_stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	advanced_stats_label.add_theme_font_size_override("font_size", 24)
	advanced_box.add_child(advanced_stats_label)

	advanced_stats_button = Button.new()
	advanced_stats_button.text = "Ver Ficha Técnica"
	advanced_stats_button.tooltip_text = "Mostra os números e as regras detalhadas do personagem."
	advanced_stats_button.custom_minimum_size.y = 56
	apply_fantasy_button_style(advanced_stats_button, false)
	advanced_stats_button.pressed.connect(toggle_advanced_stats)
	stats_box.add_child(advanced_stats_button)

	# =========================================================
	# ATRIBUTOS NO CENTRO
	# =========================================================
	var attributes_outer := PanelContainer.new()
	attributes_outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	attributes_outer.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.80))
	middle_column.add_child(attributes_outer)

	var attributes_scroll := ScrollContainer.new()
	attributes_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	attributes_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	attributes_outer.add_child(attributes_scroll)

	var attributes_margin := MarginContainer.new()
	attributes_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	attributes_margin.add_theme_constant_override("margin_left", 16)
	attributes_margin.add_theme_constant_override("margin_right", 16)
	attributes_scroll.add_child(attributes_margin)
	var attributes_content := VBoxContainer.new()
	attributes_content.custom_minimum_size.x = 0
	attributes_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	attributes_margin.add_child(attributes_content)
	create_attributes_section(attributes_content)

	# =========================================================
	# TALENTOS, DESCRIÇÕES E REVISÃO NA TERCEIRA ETAPA
	# =========================================================
	var feat_panel := PanelContainer.new()
	feat_panel.custom_minimum_size.y = 245
	feat_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	feat_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.80))
	right_column.add_child(feat_panel)

	var feat_scroll := ScrollContainer.new()
	feat_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	feat_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	feat_panel.add_child(feat_scroll)

	var feat_content := VBoxContainer.new()
	feat_content.custom_minimum_size.x = 0
	feat_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	feat_scroll.add_child(feat_content)

	var description_panel := PanelContainer.new()
	description_panel.custom_minimum_size.y = 205
	description_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	description_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.72))
	right_column.add_child(description_panel)

	var description_box := VBoxContainer.new()
	description_box.add_theme_constant_override("separation", 10)
	description_panel.add_child(description_box)

	var description_title := Label.new()
	description_title.text = "Descrição dos talentos"
	description_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description_box.add_child(description_title)

	var description_scroll := ScrollContainer.new()
	description_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	description_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	description_box.add_child(description_scroll)

	feat_description_container = GridContainer.new()
	feat_description_container.columns = 2 if wide_character_layout else 1
	feat_description_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	feat_description_container.add_theme_constant_override("h_separation", 10)
	feat_description_container.add_theme_constant_override("v_separation", 10)
	description_scroll.add_child(feat_description_container)
	create_feat_selection(feat_content)
	var review_panel := PanelContainer.new()
	review_panel.custom_minimum_size.y = 145
	review_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	review_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.78))
	right_column.add_child(review_panel)
	var review_scroll := ScrollContainer.new()
	review_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	review_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	review_panel.add_child(review_scroll)
	final_review_label = Label.new()
	final_review_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	final_review_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	review_scroll.add_child(final_review_label)
	
	# Estado inicial
	update_hp_progression_options()
	update_racial_bonus_options()
	update_attribute_labels()
	update_stats_preview()
	update_companion_visibility()
	show_first_creation_step()

func add_class_strength_row(parent: BoxContainer, key: String, symbol: String) -> void:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.55))
	parent.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	card.add_child(row)
	var icon := Label.new()
	icon.text = symbol
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon.custom_minimum_size.x = 48
	icon.add_theme_font_size_override("font_size", 30)
	row.add_child(icon)
	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(details)
	var value := Label.new()
	value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.add_child(value)
	var strength_bar := ProgressBar.new()
	strength_bar.min_value = 0
	strength_bar.max_value = 100
	strength_bar.show_percentage = false
	strength_bar.custom_minimum_size.y = 14
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = Color(0.18, 0.75, 0.38) if key == "damage" else Color(0.82, 0.24, 0.25) if key == "survival" else Color(0.40, 0.52, 0.85)
	bar_fill.set_corner_radius_all(6)
	strength_bar.add_theme_stylebox_override("fill", bar_fill)
	details.add_child(strength_bar)
	class_strength_labels[key] = {"marker": icon, "label": value, "bar": strength_bar}

func create_summary_card(parent: HBoxContainer) -> Label:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_stretch_ratio = 1.0
	card.custom_minimum_size.y = 150
	card.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.62))
	parent.add_child(card)
	var label := Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	card.add_child(label)
	return label

func add_advanced_stat_row(parent: VBoxContainer, term: String, explanation: String) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	parent.add_child(row)

	var term_label := Label.new()
	term_label.text = term
	term_label.custom_minimum_size.x = 130
	term_label.tooltip_text = explanation
	row.add_child(term_label)

	var value_label := Label.new()
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.tooltip_text = explanation
	row.add_child(value_label)
	advanced_stat_values[term] = value_label

func toggle_advanced_stats() -> void:
	showing_advanced_stats = not showing_advanced_stats
	stats_scroll.visible = not showing_advanced_stats
	advanced_stats_scroll.visible = showing_advanced_stats
	advanced_stats_button.text = (
		"Voltar ao Resumo" if showing_advanced_stats else "Ver Ficha Técnica"
	)

func update_class_strengths() -> void:
	var profiles := {
		"Bárbaro": ["Dano físico: muito alto", "Vida: muito alta", "Magia: não usa"],
		"Bruxo": ["Dano físico: baixo", "Vida: moderada", "Magia: pactos ofensivos"],
		"Bardo": ["Dano físico: moderado", "Vida: moderada", "Magia: versátil"],
		"Clérigo": ["Dano físico: moderado", "Vida: alta", "Magia: cura e proteção"],
		"Druida": ["Dano físico: moderado", "Vida: moderada", "Magia: natureza"],
		"Feiticeiro": ["Dano físico: baixo", "Vida: média", "Magia: muito forte"],
		"Guerreiro": ["Dano físico: muito alto", "Vida: alta", "Magia: não usa"],
		"Ladino": ["Dano físico: preciso", "Vida: moderada", "Magia: não usa"],
		"Mago": ["Dano físico: baixo", "Vida: baixa", "Magia: muito forte"],
		"Monge": ["Dano físico: alto", "Vida: moderada", "Magia: não usa"],
		"Paladino": ["Dano físico: alto", "Vida: alta", "Magia: não usa; poderes de proteção"],
		"Ranger": ["Dano físico: alto", "Vida: moderada", "Magia: não usa; poderes de combate"]
	}
	var profile: Array = profiles.get(selected_class, ["Dano físico: variável", "Vida: variável", "Magia: variável"])
	var keys := ["damage", "survival", "magic"]
	for index in range(keys.size()):
		var entry: Dictionary = class_strength_labels[keys[index]]
		var label: Label = entry["label"]
		var marker: Label = entry["marker"]
		var strength_bar: ProgressBar = entry["bar"]
		var rating: String = str(profile[index])
		label.text = rating
		strength_bar.value = (
			8 if rating.ends_with("não usa")
			else 28 if rating.ends_with("baixo") or rating.ends_with("baixa")
			else 58 if rating.ends_with("moderado") or rating.ends_with("moderada") or rating.ends_with("versátil")
			else 75 if rating.ends_with("alto") or rating.ends_with("alta")
			else 94
		)
		marker.modulate = (
			Color(0.82, 0.34, 0.32) if rating.ends_with("baixo")
			or rating.ends_with("baixa")
			or rating.ends_with("não usa")
			else Color(0.92, 0.70, 0.30) if rating.ends_with("moderado")
			or rating.ends_with("moderada")
			or rating.ends_with("versátil")
			else Color(0.38, 0.85, 0.45)
		)

func show_first_creation_step() -> void:
	if is_instance_valid(stats_panel) and stats_panel.get_parent() != creation_step_one:
		stats_panel.reparent(creation_step_one)
	creation_step_one.show()
	creation_step_two.hide()
	creation_step_three.hide()
	creation_step_one_actions.show()
	creation_step_two_actions.hide()
	creation_step_three_actions.hide()
	hp_choice_panel.hide()
	creation_title_label.text = "Criação de Personagem — Tela 1 de 3"
	creation_step_subtitle.text = "Passo 1: Nome, raça e classe"
	update_stats_preview()
	if creation_step_one is TabContainer:
		(creation_step_one as TabContainer).current_tab = 0

func show_second_creation_step() -> void:
	if is_instance_valid(stats_panel) and stats_panel.get_parent() != creation_step_two:
		stats_panel.reparent(creation_step_two)
	creation_step_one.hide()
	creation_step_two.show()
	creation_step_three.hide()
	creation_step_one_actions.hide()
	creation_step_two_actions.show()
	creation_step_three_actions.hide()
	hp_choice_panel.show()
	creation_title_label.text = "Criação de Personagem — Tela 2 de 3"
	creation_step_subtitle.text = "Passo 2: Atributos e progressão"
	update_stats_preview()
	if creation_step_two is TabContainer:
		(creation_step_two as TabContainer).current_tab = 0

func show_third_creation_step() -> void:
	creation_step_one.hide()
	creation_step_two.hide()
	creation_step_three.show()
	creation_step_one_actions.hide()
	creation_step_two_actions.hide()
	creation_step_three_actions.show()
	creation_title_label.text = "Criação de Personagem — Tela 3 de 3"
	creation_step_subtitle.text = "Passo 3: Talentos e finalização"
	update_final_review()
	
	
func on_race_selected(index: int):
	if race_option == null:
		return
	
	selected_race = race_option.get_item_text(index)
	selected_racial_bonus = ""
	
	update_racial_bonus_options()
	update_attribute_labels()
	update_companion_visibility()
	refresh_feat_selection()
	update_stats_preview()
	
func on_human_bonus_selected(index: int):
	UIAudioManager.play_select()
	if index < 0 or index >= human_bonus_option.item_count:
		return
	selected_racial_bonus = human_bonus_option.get_item_text(index)
	
	update_attribute_labels()
	update_stats_preview()
	


func get_final_race_attributes() -> Dictionary:
	var final_attributes := {
		"strength": base_strength + get_racial_bonus_for_attribute("strength"),
		"dexterity": base_dexterity + get_racial_bonus_for_attribute("dexterity"),
		"constitution": base_constitution + get_racial_bonus_for_attribute("constitution"),
		"wisdom": base_wisdom + get_racial_bonus_for_attribute("wisdom"),
		"intelligence": base_intelligence + get_racial_bonus_for_attribute("intelligence"),
		"charisma": base_charisma + get_racial_bonus_for_attribute("charisma")
	}
	
	return final_attributes

func update_stats_preview():
	var race_preset = race_presets[selected_race]
	var class_preset = class_presets[selected_class]
	var attributes := get_final_race_attributes()
	
	var level := 1
	
	var constitution_modifier: int = get_attribute_modifier(int(attributes["constitution"]))
	var starting_hp: int = 0
	
	if selected_hp_progression_mode == "roll":
		if has_rolled_hp:
			starting_hp = rolled_hp_value + constitution_modifier
		else:
			starting_hp = int(class_preset["hit_die"]) + constitution_modifier
	else:
		starting_hp = int(class_preset["hit_die"]) + constitution_modifier
	
	if starting_hp < 1:
		starting_hp = 1
	
	var final_movement: float = float(race_preset["movement"]) + float(class_preset["movement_bonus"])
	
	var base_attack_bonus: int = calculate_base_attack_bonus(str(class_preset["base_attack_bonus_type"]), level)
	var fortitude_bonus: int = (
		calculate_save_bonus(str(class_preset["fortitude_type"]), level)
		+ constitution_modifier
		+ (1 if selected_race == "Gnomo" else 0)
	)
	var reflex_bonus: int = (
		calculate_save_bonus(str(class_preset["reflex_type"]), level)
		+ int(class_preset["reflex_extra_bonus"])
		+ get_attribute_modifier(int(attributes["dexterity"]))
		+ (1 if selected_race == "Gnomo" else 0)
	)
	var will_bonus: int = (
		calculate_save_bonus(str(class_preset["will_type"]), level)
		+ get_attribute_modifier(int(attributes["wisdom"]))
		+ (1 if selected_race == "Gnomo" else 0)
	)
	
	var spell_attribute_text := "Nenhum"
	
	if class_preset.has("spell_attribute"):
		if str(class_preset["spell_attribute"]) == "wisdom":
			spell_attribute_text = "Sabedoria"
		elif str(class_preset["spell_attribute"]) == "charisma":
			spell_attribute_text = "Carisma"
		elif str(class_preset["spell_attribute"]) == "intelligence":
			spell_attribute_text = "Inteligência"
	
	var traits_text := ""
	var traits_array: Array = race_preset["traits"]
	var trait_index := 0
	
	while trait_index < traits_array.size():
		traits_text += "- " + str(traits_array[trait_index]) + "\n"
		trait_index += 1
	
	var features_text := ""
	var features_array: Array = class_preset["features"]
	var feature_index := 0
	
	while feature_index < features_array.size():
		features_text += "- " + str(features_array[feature_index]) + "\n"
		feature_index += 1
	
	var fixed_hp: int = int(class_preset["fixed_hp_per_level"])
	var hit_die: int = int(class_preset["hit_die"])
	
	var hp_mode_text := "Vida fixa: +" + str(fixed_hp) + " por nível, mais Constituição"
	
	if selected_hp_progression_mode == "roll":
		if has_rolled_hp:
			hp_mode_text = "Sorteio inicial: " + str(rolled_hp_value) + " mais Constituição"
		else:
			hp_mode_text = "Sorteio de vida: 1 a " + str(hit_die) + " pontos; toque em Sortear Vida Inicial"
	
	var companion_text := ""
	
	if selected_class == "Druida":
		var companion_name: String = "Lobo"
		
		if companion_option != null:
			companion_name = companion_option.get_item_text(companion_option.selected)
		
		companion_text = (
			"Companheiro Animal: " + companion_name + "\n" +
			"Disponível: Nível 1\n\n"
		)
	elif selected_class == "Ranger":
		var ranger_companion_name: String = "Lobo"
		
		if companion_option != null:
			ranger_companion_name = companion_option.get_item_text(companion_option.selected)
		
		companion_text = (
			"Companheiro Animal: " + ranger_companion_name + "\n" +
			"Disponível: Nível 4\n\n"
		)
	
	var feats_text := ""
	
	if has_method("get_selected_feats"):
		var selected_feats_list: Array = call("get_selected_feats")
		
		if not selected_feats_list.is_empty():
			feats_text += "Talentos escolhidos:\n"
			
			for feat_name in selected_feats_list:
				var feat_description: String = ""
				
				if FeatDatabase != null:
					feat_description = FeatDatabase.get_feat_description(str(feat_name))
				
				if feat_description != "":
					feats_text += "- " + str(feat_name) + ": " + feat_description + "\n"
				else:
					feats_text += "- " + str(feat_name) + "\n"
			
			feats_text += "\n"
	
	update_class_strengths()
	var race_highlight: String = str(traits_array[0]) if not traits_array.is_empty() else "Adaptável"
	class_summary_label.text = "Sua Classe: " + selected_class + "\n" + str(class_preset["description"])
	class_description_label.text = str(class_preset["description"])
	var racial_rules: String = (
		"Bônus racial: +%d em %s, aplicado após o sorteio dos atributos.\n" % [int(race_preset["bonus_amount"]), selected_racial_bonus]
		+ race_highlight + "\n" + get_race_progression_text(selected_race)
	)
	race_details_label.text = racial_rules
	race_summary_label.text = "Raça: " + selected_race + "\n" + racial_rules
	stats_label.text = "Vida inicial: " + str(starting_hp) + " pontos"
	if is_instance_valid(creation_step_two) and creation_step_two.visible:
		stats_label.text += "\nAo subir de nível: " + hp_mode_text
	(advanced_stat_values["DV"] as Label).text = "d" + str(hit_die)
	(advanced_stat_values["BBA"] as Label).text = "+" + str(base_attack_bonus)
	(advanced_stat_values["FORT"] as Label).text = "+" + str(fortitude_bonus)
	(advanced_stat_values["REF"] as Label).text = "+" + str(reflex_bonus)
	(advanced_stat_values["VON"] as Label).text = "+" + str(will_bonus)
	advanced_stats_label.text = (
		"DV indica o potencial de vida por nível. BBA ajuda a acertar ataques.\n" +
		"FORT resiste a ameaças físicas; REF evita perigos rápidos; VON protege a mente.\n\n" +
		"Vida inicial: " + str(starting_hp) + "\n" +
		"Progressão: " + hp_mode_text + "\n" +
		"Atributo mágico: " + spell_attribute_text + "\n" +
		"Tamanho: " + str(race_preset["size"]) + "\n" +
		"Deslocamento: " + str(final_movement) + " m\n\n" +
		"Vantagens raciais:\n" + traits_text + "\n" +
		"Habilidades de classe:\n" + features_text + "\n" +
		companion_text + feats_text +
		"Equipamento inicial:\n" +
		"- Arma: Espada Curta\n" +
		"- Armadura: Roupa Comum\n" +
		"- Escudo: Nenhum\n" +
		"- Ouro: 5 peças\n"
	)
	update_final_review()

func get_race_progression_text(race_name: String) -> String:
	if race_name == "Meio-Elfo":
		return "A cada 4 níveis (4, 8, 12...), distribui 3 pontos de atributo."
	return "A cada 4 níveis (4, 8, 12...), distribui 2 pontos de atributo."

func update_final_review() -> void:
	if not is_instance_valid(final_review_label):
		return
	var hero_name: String = name_input.text.strip_edges() if is_instance_valid(name_input) else "Herói"
	if hero_name.is_empty():
		hero_name = "Herói"
	var attributes: Dictionary = get_final_race_attributes()
	var selected_feats: Array = get_selected_feats()
	var feat_names := PackedStringArray()
	for feat_name in selected_feats:
		feat_names.append(str(feat_name))
	var feats_summary: String = "Nenhum selecionado" if feat_names.is_empty() else ", ".join(feat_names)
	final_review_label.text = (
		"REVISÃO FINAL — %s | %s | %s\n" % [hero_name, selected_race, selected_class]
		+ "FOR %d  •  DES %d  •  CON %d  •  SAB %d  •  INT %d  •  CAR %d\n" % [
			int(attributes["strength"]), int(attributes["dexterity"]), int(attributes["constitution"]),
			int(attributes["wisdom"]), int(attributes["intelligence"]), int(attributes["charisma"])
		]
		+ "Talentos: %s\n" % feats_summary
		+ "Raça: %s" % get_race_progression_text(selected_race)
	)
	if has_duplicate_feats():
		final_review_label.text += "\nEscolha talentos diferentes antes de criar o personagem."
	
func confirm_character():
	if has_method("has_duplicate_feats"):
		if bool(call("has_duplicate_feats")):
			print("Você não pode escolher o mesmo talento mais de uma vez.")
			return
	
	if has_method("has_invalid_feat_prerequisites"):
		if bool(call("has_invalid_feat_prerequisites")):
			print("Existe talento com pré-requisito inválido.")
			return
	
	var character_class_value: String = selected_class
	var character_race_value: String = selected_race
	
	if class_option != null:
		if class_option.selected >= 0:
			character_class_value = class_option.get_item_text(
				class_option.selected
			)
	
	if race_option != null:
		if race_option.selected >= 0:
			character_race_value = race_option.get_item_text(
				race_option.selected
			)
	
	selected_class = character_class_value
	selected_race = character_race_value
	
	var race_preset: Dictionary = race_presets[selected_race]
	var class_preset: Dictionary = class_presets[selected_class]
	var attributes: Dictionary = get_final_race_attributes()
	
	var character_name_value: String = "Herói"
	
	if name_input != null:
		character_name_value = name_input.text.strip_edges()
		
		if character_name_value == "":
			character_name_value = "Herói"
	
	var constitution_modifier: int = get_attribute_modifier(
		int(attributes["constitution"])
	)
	
	var starting_hp: int = 0
	
	if selected_hp_progression_mode == "roll":
		if has_rolled_hp:
			starting_hp = rolled_hp_value + constitution_modifier
		else:
			starting_hp = (
				int(class_preset["hit_die"])
				+ constitution_modifier
			)
	else:
		starting_hp = (
			int(class_preset["hit_die"])
			+ constitution_modifier
		)
	
	if starting_hp < 1:
		starting_hp = 1
	
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	GameState.selected_stage = 1
	
	GameState.player_name = character_name_value
	GameState.player_class = selected_class
	GameState.player_race = selected_race
	
	GameState.hero_strength = int(attributes["strength"])
	GameState.hero_dexterity = int(attributes["dexterity"])
	GameState.hero_constitution = int(attributes["constitution"])
	GameState.hero_wisdom = int(attributes["wisdom"])
	GameState.hero_intelligence = int(attributes["intelligence"])
	GameState.hero_charisma = int(attributes["charisma"])
	
	GameState.hero_size = str(race_preset["size"])
	GameState.hero_size_modifier = int(race_preset["size_modifier"])
	GameState.hero_favored_class = str(race_preset["favored_class"])
	GameState.hero_race_traits = race_preset["traits"]
	
	GameState.hero_class_hit_die = int(class_preset["hit_die"])
	GameState.hero_hp_fixed_per_level = int(
		class_preset["fixed_hp_per_level"]
	)
	GameState.hero_hp_progression_mode = selected_hp_progression_mode
	
	GameState.hero_base_attack_bonus_type = str(
		class_preset["base_attack_bonus_type"]
	)
	GameState.hero_fortitude_type = str(
		class_preset["fortitude_type"]
	)
	GameState.hero_reflex_type = str(
		class_preset["reflex_type"]
	)
	GameState.hero_will_type = str(
		class_preset["will_type"]
	)
	
	GameState.hero_fortitude_base_bonus = calculate_save_bonus(
		GameState.hero_fortitude_type,
		1
	)
	
	GameState.hero_reflex_base_bonus = (
		calculate_save_bonus(
			GameState.hero_reflex_type,
			1
		)
		+ int(class_preset["reflex_extra_bonus"])
	)
	
	GameState.hero_will_base_bonus = calculate_save_bonus(
		GameState.hero_will_type,
		1
	)
	
	GameState.hero_class_movement_bonus = float(
		class_preset["movement_bonus"]
	)
	
	GameState.hero_damage_reduction = calculate_damage_reduction(1)
	GameState.hero_class_features = class_preset["features"]
	
	GameState.hero_level = 1
	GameState.hero_total_xp = 0
	GameState.hero_xp_to_next_level = 1000
	GameState.hero_max_level = 30
	GameState.hero_class_power_choices = {}
	
	GameState.hero_max_hp = starting_hp
	GameState.hero_attack_power = int(class_preset["attack"])
	
	GameState.hero_max_movement_meters = (
		float(race_preset["movement"])
		+ float(class_preset["movement_bonus"])
	)
	
	# EQUIPAMENTO INICIAL FIXO
	GameState.hero_equipped_weapon = "Espada Curta"
	GameState.hero_equipped_armor = "Roupa Comum"
	GameState.hero_equipped_shield = "Nenhum"
	GameState.hero_gold = 5
	
	if companion_option != null:
		GameState.hero_animal_companion_type = (
			companion_option.get_item_text(
				companion_option.selected
			)
		)
	else:
		GameState.hero_animal_companion_type = "Lobo"
	
	if has_method("get_selected_feats"):
		GameState.hero_feats = call("get_selected_feats")
	else:
		GameState.hero_feats = []
	
	print("Personagem criado:")
	print("Nome: ", GameState.player_name)
	print("Raça: ", GameState.player_race)
	print("Classe: ", GameState.player_class)
	print("HP inicial: ", GameState.hero_max_hp)
	print("Movimento: ", GameState.hero_max_movement_meters)
	print("Arma inicial: ", GameState.hero_equipped_weapon)
	print("Armadura inicial: ", GameState.hero_equipped_armor)
	print("Ouro inicial: ", GameState.hero_gold)
	print("Talentos: ", GameState.hero_feats)
	
	if selected_class == "Druida":
		print(
			"Companheiro animal: ",
			GameState.hero_animal_companion_type
		)
	elif selected_class == "Ranger":
		print(
			"Companheiro animal escolhido para nível 4: ",
			GameState.hero_animal_companion_type
		)
	
	get_tree().change_scene_to_file("res://Scene/main.tscn")
	
func back_to_menu():
	UIAudioManager.play_back()
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
	
func on_class_selected(index: int):
	UIAudioManager.play_select()

	if class_option != null:
		var new_class: String = class_option.get_item_text(index)
		if new_class != selected_class:
			selected_class = new_class
			roll_initial_attributes_for_class(selected_class)

	has_rolled_hp = false
	rolled_hp_value = 0
	
	update_hp_progression_options()
	update_companion_visibility()
	refresh_feat_selection()
	update_attribute_labels()
	update_stats_preview()
	


func on_hp_progression_selected(index: int):
	if index == 0:
		selected_hp_progression_mode = "fixed"
		has_rolled_hp = false
		rolled_hp_value = 0
		
		if roll_hp_button != null:
			roll_hp_button.disabled = true
	
	elif index == 1:
		selected_hp_progression_mode = "roll"
		has_rolled_hp = false
		rolled_hp_value = 0
		
		if roll_hp_button != null:
			roll_hp_button.disabled = false
	
	update_hp_progression_options()
	update_stats_preview()
	
func get_attribute_modifier(attribute_value: int) -> int:
	return int(floor((attribute_value - 10) / 2.0))


func calculate_base_attack_bonus(class_type: String, level: int) -> int:
	if class_type == "alto":
		return level
	
	if class_type == "medio":
		return int(floor(level * 0.75))
	
	if class_type == "baixo":
		return int(floor(level * 0.5))
	
	return 0


func calculate_save_bonus(save_type: String, level: int) -> int:
	if save_type == "bom":
		return 2 + int(floor(level / 2.0))
	
	if save_type == "ruim":
		return int(floor(level / 3.0))
	
	return 0


func calculate_damage_reduction(character_level: int) -> int:
	if selected_class == "Bárbaro":
		if character_level >= 15:
			return 10
		
		if character_level >= 10:
			return 5
	
	return 0
func roll_starting_hp():
	var class_preset = class_presets[selected_class]
	var hit_die: int = int(class_preset["hit_die"])
	
	rolled_hp_value = randi_range(1, hit_die)
	has_rolled_hp = true
	
	print("Rolagem de vida: 1d", hit_die, " = ", rolled_hp_value)
	
	update_stats_preview()
func update_hp_progression_options():
	if hp_progression_option == null:
		return
	
	var class_preset = class_presets[selected_class]
	var hit_die: int = int(class_preset["hit_die"])
	var fixed_hp: int = int(class_preset["fixed_hp_per_level"])
	
	hp_progression_option.clear()
	hp_progression_option.add_item("Vida fixa: +" + str(fixed_hp) + " por nível", 0)
	hp_progression_option.add_item("Sorteio: 1 a " + str(hit_die) + " pontos por nível", 1)
	
	if selected_hp_progression_mode == "fixed":
		hp_progression_option.select(0)
		roll_hp_button.disabled = true
		roll_hp_button.hide()
		if hp_info_label != null:
			hp_info_label.hide()
	else:
		hp_progression_option.select(1)
		roll_hp_button.disabled = false
		roll_hp_button.show()
		if hp_info_label != null:
			hp_info_label.show()
	
func create_attributes_section(parent: VBoxContainer):
	var attributes_panel := PanelContainer.new()
	attributes_panel.custom_minimum_size = Vector2(0, 500)
	attributes_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(attributes_panel)
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.07, 0.07, 0.09, 0.85)
	panel_style.border_color = Color(0.35, 0.30, 0.18, 1.0)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)
	attributes_panel.add_theme_stylebox_override("panel", panel_style)
	
	var attributes_box := VBoxContainer.new()
	attributes_box.add_theme_constant_override("separation", 8)
	attributes_panel.add_child(attributes_box)
	
	var attributes_title := Label.new()
	attributes_title.text = "Atributos"
	attributes_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	attributes_title.add_theme_font_size_override("font_size", 20)
	attributes_box.add_child(attributes_title)
	
	attribute_help_label = Label.new()
	attribute_help_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	attribute_help_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	attribute_help_label.add_theme_font_size_override("font_size", 15)
	attributes_box.add_child(attribute_help_label)
	
	var grid := GridContainer.new()
	grid.columns = 1
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 8)
	attributes_box.add_child(grid)
	
	create_attribute_row(grid, "FOR", "strength")
	create_attribute_row(grid, "DES", "dexterity")
	create_attribute_row(grid, "CON", "constitution")
	create_attribute_row(grid, "SAB", "wisdom")
	create_attribute_row(grid, "INT", "intelligence")
	create_attribute_row(grid, "CAR", "charisma")
	
	update_attribute_labels()

func create_attribute_row(parent: GridContainer, attribute_name: String, attribute_key: String):
	var row_panel := PanelContainer.new()
	row_panel.custom_minimum_size = Vector2(0, 72)
	row_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(row_panel)
	
	var row_style := StyleBoxFlat.new()
	row_style.bg_color = Color(0.12, 0.12, 0.15, 0.80)
	row_style.border_color = Color(0.42, 0.37, 0.27, 0.90)
	row_style.set_border_width_all(1)
	row_style.set_corner_radius_all(6)
	row_style.content_margin_left = 8
	row_style.content_margin_right = 8
	row_panel.add_theme_stylebox_override("panel", row_style)
	
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	row_panel.add_child(row)
	var symbols := {
		"strength": "✊", "dexterity": "➤", "constitution": "♥",
		"wisdom": "◉", "intelligence": "✦", "charisma": "♛"
	}
	var icon := Label.new()
	icon.text = str(symbols.get(attribute_key, "◆"))
	icon.custom_minimum_size.x = 40
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(icon)
	
	var name_label := Label.new()
	name_label.text = attribute_name
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.custom_minimum_size.x = 50
	row.add_child(name_label)
	var base_label := Label.new()
	base_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	base_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	base_label.custom_minimum_size.x = 48
	base_label.tooltip_text = "Valor inicial sorteado para a classe."
	row.add_child(base_label)
	var divider := VSeparator.new()
	row.add_child(divider)
	var racial_label := Label.new()
	racial_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	racial_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	racial_label.custom_minimum_size.x = 90
	racial_label.tooltip_text = "Bônus escolhido para a raça, aplicado após o sorteio."
	racial_label.add_theme_color_override("font_color", Color(0.97, 0.78, 0.43))
	row.add_child(racial_label)
	var result_arrow := Label.new()
	result_arrow.text = "→"
	result_arrow.custom_minimum_size.x = 26
	result_arrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(result_arrow)
	var final_label := Label.new()
	final_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	final_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	final_label.custom_minimum_size.x = 116
	final_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	final_label.tooltip_text = "Valor final do atributo e modificador usado nos testes."
	row.add_child(final_label)
	attribute_row_labels[attribute_key] = {"base": base_label, "racial": racial_label, "final": final_label}
	
func roll_initial_attributes_for_class(character_class: String) -> void:
	var primary_attribute: String = str(CLASS_PRIMARY_ATTRIBUTES.get(character_class, "strength"))
	# Os cinco valores somam 60: todos começam com o mesmo total de atributos,
	# mas cada valor secundário pode variar livremente entre 8 e 16.
	var secondary_scores: Array[int] = [8, 10, 12, 14, 16]
	attribute_rng.randomize()
	for _roll in range(40):
		var source_index: int = attribute_rng.randi_range(0, secondary_scores.size() - 1)
		var target_index: int = attribute_rng.randi_range(0, secondary_scores.size() - 1)
		if source_index != target_index and secondary_scores[source_index] > 8 and secondary_scores[target_index] < 16:
			secondary_scores[source_index] -= 1
			secondary_scores[target_index] += 1
	for index in range(secondary_scores.size() - 1, 0, -1):
		var chosen_index: int = attribute_rng.randi_range(0, index)
		var previous_value: int = secondary_scores[index]
		secondary_scores[index] = secondary_scores[chosen_index]
		secondary_scores[chosen_index] = previous_value
	var secondary_index: int = 0
	for attribute_key in ATTRIBUTE_KEYS:
		var rolled_value: int = 18
		if attribute_key != primary_attribute:
			rolled_value = secondary_scores[secondary_index]
			secondary_index += 1
		set_base_attribute_value(attribute_key, rolled_value)
	update_attribute_labels()

func get_base_attribute_value(attribute_key: String) -> int:
	if attribute_key == "strength":
		return base_strength
	if attribute_key == "dexterity":
		return base_dexterity
	if attribute_key == "constitution":
		return base_constitution
	if attribute_key == "wisdom":
		return base_wisdom
	if attribute_key == "intelligence":
		return base_intelligence
	if attribute_key == "charisma":
		return base_charisma
	
	return 10


func set_base_attribute_value(attribute_key: String, value: int):
	if attribute_key == "strength":
		base_strength = value
	elif attribute_key == "dexterity":
		base_dexterity = value
	elif attribute_key == "constitution":
		base_constitution = value
	elif attribute_key == "wisdom":
		base_wisdom = value
	elif attribute_key == "intelligence":
		base_intelligence = value
	elif attribute_key == "charisma":
		base_charisma = value


func update_attribute_labels():
	if attribute_help_label != null:
		var primary_key: String = str(CLASS_PRIMARY_ATTRIBUTES.get(selected_class, "strength"))
		var primary_labels := {"strength": "FOR", "dexterity": "DES", "constitution": "CON", "wisdom": "SAB", "intelligence": "INT", "charisma": "CAR"}
		attribute_help_label.text = "%s começa com 18 · outros atributos sorteados entre 8 e 16 · bônus racial aplicado ao final" % str(primary_labels.get(primary_key, "FOR"))
	
	for attribute_key in attribute_row_labels:
		var labels: Dictionary = attribute_row_labels[attribute_key]
		var base_value: int = get_base_attribute_value(str(attribute_key))
		var racial_bonus: int = get_racial_bonus_for_attribute(str(attribute_key))
		var final_value: int = base_value + racial_bonus
		(labels["base"] as Label).text = str(base_value)
		(labels["racial"] as Label).text = "◆ +%d" % racial_bonus if racial_bonus > 0 else "◆ —"
		(labels["final"] as Label).text = "%d (%s)" % [final_value, format_modifier(get_attribute_modifier(final_value))]
		
func format_modifier(value: int) -> String:
	if value >= 0:
		return "+" + str(value)
	
	return str(value)

func update_single_attribute_label(label: Label, attribute_key: String, base_value: int):
	if label == null:
		return
	
	var racial_bonus: int = get_racial_bonus_for_attribute(attribute_key)
	var final_value: int = base_value + racial_bonus
	
	var bonus_text := ""
	
	if racial_bonus > 0:
		bonus_text = " + " + str(racial_bonus)
	elif racial_bonus < 0:
		bonus_text = " - " + str(abs(racial_bonus))
	else:
		bonus_text = " + 0"
	
	label.text = str(base_value) + bonus_text + " = " + str(final_value)


func get_racial_bonus_for_attribute(attribute_key: String) -> int:
	var attribute_names: Dictionary = {
		"FOR": "strength", "DES": "dexterity", "CON": "constitution",
		"SAB": "wisdom", "INT": "intelligence", "CAR": "charisma"
	}
	if str(attribute_names.get(selected_racial_bonus, "")) == attribute_key:
		return int(race_presets[selected_race]["bonus_amount"])
	return 0

func update_racial_bonus_options() -> void:
	if human_bonus_option == null:
		return
	var race_preset: Dictionary = race_presets[selected_race]
	var options: Array = race_preset["bonus_options"]
	human_bonus_label.text = "Bônus racial de %s (+%d)" % [selected_race, int(race_preset["bonus_amount"])]
	human_bonus_option.clear()
	for attribute_name in options:
		human_bonus_option.add_item(str(attribute_name))
	var selected_index: int = options.find(selected_racial_bonus)
	if selected_index < 0:
		selected_index = 0
	human_bonus_option.select(selected_index)
	selected_racial_bonus = str(options[selected_index])
func create_background():
	var background := TextureRect.new()
	background.name = "CharacterCreationBackground"
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.offset_left = 0
	background.offset_top = 0
	background.offset_right = 0
	background.offset_bottom = 0
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var bg_texture = load(CHARACTER_CREATION_BACKGROUND_PATH)
	
	if bg_texture != null:
		background.texture = bg_texture
	else:
		print("Fundo da criação de personagem não encontrado: ", CHARACTER_CREATION_BACKGROUND_PATH)
	
	add_child(background)
	move_child(background, 0)
	
	var dark_overlay := ColorRect.new()
	dark_overlay.name = "CharacterCreationDarkOverlay"
	dark_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	dark_overlay.color = Color(0, 0, 0, 0.18)
	dark_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dark_overlay)
	move_child(dark_overlay, 1)
func create_fantasy_panel_style(alpha: float = 0.82) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.055, 0.045, alpha)
	style.border_color = Color(0.48, 0.36, 0.16, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	style.shadow_color = Color(0, 0, 0, 0.70)
	style.shadow_size = 10
	return style


func create_fantasy_input_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.03, 0.045, 0.04, 0.88)
	style.border_color = Color(0.12, 0.65, 0.36, 0.95)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style


func create_fantasy_button_style(is_primary: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	
	if is_primary:
		style.bg_color = Color(0.04, 0.22, 0.13, 0.92)
		style.border_color = Color(0.15, 0.95, 0.45, 1.0)
		style.shadow_color = Color(0.10, 0.90, 0.40, 0.60)
		style.shadow_size = 14
	else:
		style.bg_color = Color(0.08, 0.11, 0.10, 0.90)
		style.border_color = Color(0.50, 0.38, 0.18, 1.0)
		style.shadow_color = Color(0, 0, 0, 0.75)
		style.shadow_size = 8
	
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	
	return style


func apply_fantasy_button_style(button: Button, is_primary: bool = false):
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 18)
	
	var normal_style := create_fantasy_button_style(is_primary)
	
	var hover_style := create_fantasy_button_style(is_primary)
	hover_style.bg_color = Color(0.08, 0.28, 0.16, 0.95)
	hover_style.border_color = Color(0.20, 1.00, 0.50, 1.0)
	hover_style.shadow_color = Color(0.10, 1.00, 0.45, 0.85)
	hover_style.shadow_size = 18
	
	var pressed_style := create_fantasy_button_style(is_primary)
	pressed_style.bg_color = Color(0.02, 0.10, 0.06, 1.0)
	pressed_style.border_color = Color(0.05, 0.70, 0.30, 1.0)
	pressed_style.shadow_size = 4
	
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	
	button.add_theme_color_override("font_color", Color(0.90, 0.82, 0.62, 1.0))
	button.add_theme_color_override("font_hover_color", Color(0.90, 1.00, 0.82, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(0.70, 1.00, 0.75, 1.0))


func apply_fantasy_line_edit_style(line_edit: LineEdit):
	line_edit.add_theme_stylebox_override("normal", create_fantasy_input_style())
	line_edit.add_theme_stylebox_override("focus", create_fantasy_input_style())
	line_edit.add_theme_color_override("font_color", Color(0.95, 0.95, 0.88, 1.0))
	line_edit.add_theme_color_override("font_placeholder_color", Color(0.65, 0.65, 0.58, 1.0))


func apply_fantasy_option_style(option_button: OptionButton):
	if option_button == null:
		return
	
	option_button.custom_minimum_size = Vector2(320, 44)
	option_button.focus_mode = Control.FOCUS_NONE
	
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(0.04, 0.06, 0.055, 0.96)
	normal_style.border_color = Color(0.62, 0.46, 0.18, 0.95)
	normal_style.set_border_width_all(2)
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8
	normal_style.content_margin_left = 12
	normal_style.content_margin_top = 8
	normal_style.content_margin_right = 12
	normal_style.content_margin_bottom = 8
	
	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = Color(0.08, 0.15, 0.10, 0.98)
	hover_style.border_color = Color(0.95, 0.72, 0.28, 1.0)
	hover_style.set_border_width_all(2)
	hover_style.corner_radius_top_left = 8
	hover_style.corner_radius_top_right = 8
	hover_style.corner_radius_bottom_left = 8
	hover_style.corner_radius_bottom_right = 8
	hover_style.content_margin_left = 12
	hover_style.content_margin_top = 8
	hover_style.content_margin_right = 12
	hover_style.content_margin_bottom = 8
	
	var pressed_style := StyleBoxFlat.new()
	pressed_style.bg_color = Color(0.02, 0.10, 0.055, 1.0)
	pressed_style.border_color = Color(1.0, 0.82, 0.34, 1.0)
	pressed_style.set_border_width_all(2)
	pressed_style.corner_radius_top_left = 8
	pressed_style.corner_radius_top_right = 8
	pressed_style.corner_radius_bottom_left = 8
	pressed_style.corner_radius_bottom_right = 8
	pressed_style.content_margin_left = 12
	pressed_style.content_margin_top = 8
	pressed_style.content_margin_right = 12
	pressed_style.content_margin_bottom = 8
	
	option_button.add_theme_stylebox_override("normal", normal_style)
	option_button.add_theme_stylebox_override("hover", hover_style)
	option_button.add_theme_stylebox_override("pressed", pressed_style)
	option_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	
	option_button.add_theme_color_override("font_color", Color(0.95, 0.92, 0.82))
	option_button.add_theme_color_override("font_hover_color", Color(1.0, 0.92, 0.55))
	option_button.add_theme_color_override("font_pressed_color", Color(1.0, 0.82, 0.32))
	option_button.add_theme_color_override("font_focus_color", Color(1.0, 0.92, 0.55))
	option_button.add_theme_font_size_override("font_size", 17)
	
	var popup := option_button.get_popup()
	
	if popup != null:
		var popup_style := StyleBoxFlat.new()
		popup_style.bg_color = Color(0.025, 0.035, 0.03, 0.98)
		popup_style.border_color = Color(0.82, 0.62, 0.22, 1.0)
		popup_style.set_border_width_all(2)
		popup_style.corner_radius_top_left = 8
		popup_style.corner_radius_top_right = 8
		popup_style.corner_radius_bottom_left = 8
		popup_style.corner_radius_bottom_right = 8
		popup_style.content_margin_left = 8
		popup_style.content_margin_top = 8
		popup_style.content_margin_right = 8
		popup_style.content_margin_bottom = 8
		
		popup.add_theme_stylebox_override("panel", popup_style)
		popup.add_theme_color_override("font_color", Color(0.92, 0.90, 0.82))
		popup.add_theme_color_override("font_hover_color", Color(1.0, 0.90, 0.45))
		popup.add_theme_font_size_override("font_size", 16)
	
func build_attribute_display(attribute_short_name: String, base_value: int, racial_bonus: int) -> String:
	var final_value: int = base_value + racial_bonus
	var modifier: int = get_attribute_modifier(final_value)
	
	return (
		attribute_short_name + " " +
		str(final_value) + " " +
		"(" + format_attribute_modifier(modifier) + ")"
	)
func format_attribute_modifier(modifier: int) -> String:
	if modifier >= 0:
		return "+" + str(modifier)
	
	return str(modifier)
func apply_button_sfx(button: BaseButton):
	button.mouse_entered.connect(UIAudioManager.play_hover)
	button.pressed.connect(UIAudioManager.play_click)
func apply_fantasy_option_button_style(option_button: OptionButton):
	if option_button == null:
		return
	
	option_button.custom_minimum_size = Vector2(320, 44)
	option_button.focus_mode = Control.FOCUS_NONE
	
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(0.04, 0.06, 0.055, 0.96)
	normal_style.border_color = Color(0.62, 0.46, 0.18, 0.95)
	normal_style.set_border_width_all(2)
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8
	normal_style.content_margin_left = 12
	normal_style.content_margin_top = 8
	normal_style.content_margin_right = 12
	normal_style.content_margin_bottom = 8
	
	var hover_style := StyleBoxFlat.new()
	hover_style.bg_color = Color(0.08, 0.15, 0.10, 0.98)
	hover_style.border_color = Color(0.95, 0.72, 0.28, 1.0)
	hover_style.set_border_width_all(2)
	hover_style.corner_radius_top_left = 8
	hover_style.corner_radius_top_right = 8
	hover_style.corner_radius_bottom_left = 8
	hover_style.corner_radius_bottom_right = 8
	hover_style.content_margin_left = 12
	hover_style.content_margin_top = 8
	hover_style.content_margin_right = 12
	hover_style.content_margin_bottom = 8
	
	var pressed_style := StyleBoxFlat.new()
	pressed_style.bg_color = Color(0.02, 0.10, 0.055, 1.0)
	pressed_style.border_color = Color(1.0, 0.82, 0.34, 1.0)
	pressed_style.set_border_width_all(2)
	pressed_style.corner_radius_top_left = 8
	pressed_style.corner_radius_top_right = 8
	pressed_style.corner_radius_bottom_left = 8
	pressed_style.corner_radius_bottom_right = 8
	pressed_style.content_margin_left = 12
	pressed_style.content_margin_top = 8
	pressed_style.content_margin_right = 12
	pressed_style.content_margin_bottom = 8
	
	option_button.add_theme_stylebox_override("normal", normal_style)
	option_button.add_theme_stylebox_override("hover", hover_style)
	option_button.add_theme_stylebox_override("pressed", pressed_style)
	option_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	
	option_button.add_theme_color_override("font_color", Color(0.95, 0.92, 0.82))
	option_button.add_theme_color_override("font_hover_color", Color(1.0, 0.92, 0.55))
	option_button.add_theme_color_override("font_pressed_color", Color(1.0, 0.82, 0.32))
	option_button.add_theme_color_override("font_focus_color", Color(1.0, 0.92, 0.55))
	option_button.add_theme_font_size_override("font_size", 17)
	
	style_option_popup(option_button)
func style_option_popup(option_button: OptionButton):
	if option_button == null:
		return
	
	var popup := option_button.get_popup()
	
	if popup == null:
		return
	
	var popup_style := StyleBoxFlat.new()
	popup_style.bg_color = Color(0.025, 0.035, 0.03, 0.98)
	popup_style.border_color = Color(0.82, 0.62, 0.22, 1.0)
	popup_style.set_border_width_all(2)
	popup_style.corner_radius_top_left = 8
	popup_style.corner_radius_top_right = 8
	popup_style.corner_radius_bottom_left = 8
	popup_style.corner_radius_bottom_right = 8
	popup_style.content_margin_left = 8
	popup_style.content_margin_top = 8
	popup_style.content_margin_right = 8
	popup_style.content_margin_bottom = 8
	
	popup.add_theme_stylebox_override("panel", popup_style)
	popup.add_theme_color_override("font_color", Color(0.92, 0.90, 0.82))
	popup.add_theme_color_override("font_hover_color", Color(1.0, 0.90, 0.45))
	popup.add_theme_color_override("font_accelerator_color", Color(0.82, 0.70, 0.48))
	popup.add_theme_font_size_override("font_size", 16)
	
func apply_fantasy_field_label_style(label: Label):
	if label == null:
		return
	
	label.add_theme_font_size_override("font_size", 17)
	label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.42))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	
func apply_style_to_all_option_buttons():
	var options := find_children("*", "OptionButton", true, false)
	
	for option in options:
		apply_fantasy_option_style(option)

func on_companion_selected(_index: int):
	update_companion_visibility()
	update_stats_preview()


func update_companion_visibility():
	if companion_label == null:
		return
	
	if companion_option == null:
		return
	
	var selected_class_value: String = get_selected_class()
	
	if selected_class_value == "Druida" or selected_class_value == "Ranger":
		companion_label.visible = true
		companion_option.visible = true
	else:
		companion_label.visible = false
		companion_option.visible = false


func apply_fantasy_label_style(label: Label, font_size: int = 16):
	if label == null:
		return
	
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.76))

func create_companion_selection(parent_container: Control):
	if parent_container == null:
		return
	
	companion_label = Label.new()
	companion_label.name = "CompanionLabel"
	companion_label.text = "Companheiro Animal"
	companion_label.custom_minimum_size = Vector2(360, 28)
	apply_fantasy_label_style(companion_label, 16)
	parent_container.add_child(companion_label)
	
	companion_option = OptionButton.new()
	companion_option.name = "CompanionOption"
	companion_option.custom_minimum_size = Vector2(360, 42)
	companion_option.add_item("Lobo")
	companion_option.add_item("Urso")
	companion_option.add_item("Pantera")
	companion_option.add_item("Águia")
	companion_option.item_selected.connect(on_companion_selected)
	apply_fantasy_option_style(companion_option)
	parent_container.add_child(companion_option)
	
	update_companion_visibility()
func get_selected_class() -> String:
	if class_option == null:
		return "Guerreiro"
	
	if class_option.selected < 0:
		return "Guerreiro"
	
	return class_option.get_item_text(class_option.selected)


func get_selected_race() -> String:
	if race_option == null:
		return "Humano"
	
	if race_option.selected < 0:
		return "Humano"
	
	return race_option.get_item_text(race_option.selected)
func get_current_class_text() -> String:
	if class_option == null:
		return "Guerreiro"
	
	if class_option.selected < 0:
		return "Guerreiro"
	
	return class_option.get_item_text(class_option.selected)
func get_current_race_text() -> String:
	if race_option == null:
		return "Humano"
	
	if race_option.selected < 0:
		return "Humano"
	
	return race_option.get_item_text(race_option.selected)
func get_feat_choice_count(character_class: String, character_race: String, _character_level: int) -> int:
	var count: int = 1
	
	if character_race == "Humano":
		count += 1
	
	if character_class == "Guerreiro":
		count += 1
	
	return count
func create_feat_selection(parent_container: Control):
	if parent_container == null:
		return
	
	var old_title := parent_container.get_node_or_null("FeatTitleLabel")
	if old_title != null:
		old_title.queue_free()
	
	var old_container := parent_container.get_node_or_null("FeatSelectionContainer")
	if old_container != null:
		old_container.queue_free()
	
	feat_options.clear()
	feat_choice_options.clear()
	feat_choice_labels.clear()
	feat_description_labels.clear()
	
	feat_title_label = Label.new()
	feat_title_label.name = "FeatTitleLabel"
	feat_title_label.text = "Talentos"
	feat_title_label.custom_minimum_size.y = 32
	feat_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	apply_fantasy_label_style(feat_title_label, 18)
	parent_container.add_child(feat_title_label)
	
	if wide_character_layout:
		feat_selection_container = HBoxContainer.new()
	else:
		feat_selection_container = VBoxContainer.new()
	feat_selection_container.name = "FeatSelectionContainer"
	feat_selection_container.custom_minimum_size.y = 120
	feat_selection_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	feat_selection_container.add_theme_constant_override("separation", 8)
	parent_container.add_child(feat_selection_container)
	
	refresh_feat_selection()
	
func refresh_feat_selection():
	if feat_selection_container == null:
		return
	
	for child in feat_selection_container.get_children():
		child.queue_free()
	if is_instance_valid(feat_description_container):
		for child in feat_description_container.get_children():
			child.queue_free()
	
	feat_options.clear()
	feat_choice_options.clear()
	feat_choice_labels.clear()
	feat_description_labels.clear()
	
	var current_class: String = selected_class
	var current_race: String = selected_race
	
	if class_option != null:
		if class_option.selected >= 0:
			current_class = class_option.get_item_text(class_option.selected)
	
	if race_option != null:
		if race_option.selected >= 0:
			current_race = race_option.get_item_text(race_option.selected)
	
	selected_class = current_class
	selected_race = current_race
	
	var feat_count: int = get_feat_choice_count(current_class, current_race, 1)
	
	if feat_title_label != null:
		feat_title_label.text = "Talentos disponíveis: " + str(feat_count)
	
	for i in range(feat_count):
		create_single_feat_selector(i, current_class, current_race)
	
	rebuild_feat_options_keep_selection()
	update_all_feat_descriptions()
	apply_readable_creation_style()

func create_single_feat_selector(index: int, character_class: String, character_race: String):
	var slot_panel := PanelContainer.new()
	slot_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slot_panel.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.65))
	feat_selection_container.add_child(slot_panel)
	var slot_content := VBoxContainer.new()
	slot_content.add_theme_constant_override("separation", 8)
	slot_panel.add_child(slot_content)
	var label := Label.new()
	label.text = "Talento " + str(index + 1)
	label.custom_minimum_size.y = 24
	apply_fantasy_label_style(label, 15)
	slot_content.add_child(label)
	
	var option := OptionButton.new()
	option.name = "FeatOption" + str(index + 1)
	option.custom_minimum_size.y = 42
	option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var current_attributes: Dictionary = get_final_race_attributes()
	var selected_feats_array: Array = get_selected_feats()
	
	var available_feats: Array = FeatDatabase.get_available_feats_for_character(
		character_class,
		character_race,
		1,
		false,
		selected_feats_array,
		current_attributes
	)
	
	for feat_name in available_feats:
		option.add_item(str(feat_name))
	
	option.item_selected.connect(on_feat_selected.bind(index))
	apply_fantasy_option_style(option)
	slot_content.add_child(option)
	
	var choice_label := Label.new()
	choice_label.name = "FeatChoiceLabel" + str(index + 1)
	choice_label.text = "Escolha"
	choice_label.custom_minimum_size.y = 22
	apply_fantasy_label_style(choice_label, 13)
	slot_content.add_child(choice_label)
	
	var choice_option := OptionButton.new()
	choice_option.name = "FeatChoiceOption" + str(index + 1)
	choice_option.custom_minimum_size.y = 42
	choice_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	choice_option.item_selected.connect(on_feat_extra_choice_selected.bind(index))
	apply_fantasy_option_style(choice_option)
	slot_content.add_child(choice_option)
	
	var description_card := PanelContainer.new()
	description_card.custom_minimum_size = Vector2(220, 130)
	description_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	description_card.add_theme_stylebox_override("panel", create_fantasy_panel_style(0.58))
	var description_label := Label.new()
	description_label.name = "FeatDescription" + str(index + 1)
	description_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	apply_fantasy_label_style(description_label, 20)
	description_card.add_child(description_label)
	if is_instance_valid(feat_description_container):
		feat_description_container.add_child(description_card)
	else:
		slot_content.add_child(description_card)
	
	feat_options.append(option)
	feat_choice_labels.append(choice_label)
	feat_choice_options.append(choice_option)
	feat_description_labels.append(description_label)
	
	update_feat_choice_visibility(index)
	update_feat_description(index)

func on_feat_selected(_selected_index: int, feat_slot_index: int):
	rebuild_feat_options_keep_selection()
	update_feat_choice_visibility(feat_slot_index)
	update_all_feat_choice_visibility()
	update_all_feat_descriptions()
	update_stats_preview()
	
func update_all_feat_choice_visibility():
	for i in range(feat_options.size()):
		update_feat_choice_visibility(i)

func update_feat_description(feat_slot_index: int):
	if feat_slot_index < 0:
		return
	
	if feat_slot_index >= feat_options.size():
		return
	
	if feat_slot_index >= feat_description_labels.size():
		return
	
	var option: OptionButton = feat_options[feat_slot_index]
	var description_label: Label = feat_description_labels[feat_slot_index]
	
	if option == null or description_label == null:
		return
	
	if option.selected < 0:
		description_label.text = "Talento " + str(feat_slot_index + 1) + "\nSelecione um talento para ver o benefício."
		return
	
	var feat_name: String = option.get_item_text(option.selected)
	var description: String = FeatDatabase.get_feat_description(feat_name)
	var final_feat_name: String = get_feat_name_with_choice(feat_slot_index)
	
	if final_feat_name == "":
		description_label.text = feat_name + "\nBenefício: pré-requisito ausente."
		return
	
	var display_final_name: String = get_feat_display_name(final_feat_name)
	
	description_label.text = (
		"Talento " + str(feat_slot_index + 1) + ": " + display_final_name
		+ "\nBenefício: " + description
	)

func update_all_feat_descriptions():
	for i in range(feat_options.size()):
		update_feat_description(i)

func get_selected_feats() -> Array:
	var selected_feats_array: Array = []
	
	for i in range(feat_options.size()):
		var feat_name: String = get_feat_name_with_choice(i)
		
		if feat_name == "":
			continue
		
		selected_feats_array.append(feat_name)
	
	return selected_feats_array

func has_duplicate_feats() -> bool:
	var selected_feats_array: Array = get_selected_feats()
	var unique_feats: Array = []
	
	for feat_name in selected_feats_array:
		if unique_feats.has(feat_name):
			return true
		
		unique_feats.append(feat_name)
	
	return false

func rebuild_feat_options_keep_selection():
	var previous_selected_feats: Array = get_selected_feats()
	
	var current_class: String = selected_class
	var current_race: String = selected_race
	
	if class_option != null:
		if class_option.selected >= 0:
			current_class = class_option.get_item_text(class_option.selected)
	
	if race_option != null:
		if race_option.selected >= 0:
			current_race = race_option.get_item_text(race_option.selected)
	
	var current_attributes: Dictionary = get_final_race_attributes()
	
	var available_feats: Array = FeatDatabase.get_available_feats_for_character(
		current_class,
		current_race,
		1,
		false,
		previous_selected_feats,
		current_attributes
	)
	
	for i in range(feat_options.size()):
		var option: OptionButton = feat_options[i]
		
		if option == null:
			continue
		
		var current_selected_full: String = ""
		var current_selected_base: String = ""
		
		if i < previous_selected_feats.size():
			current_selected_full = str(previous_selected_feats[i])
			current_selected_base = get_base_feat_name(current_selected_full)
		
		option.clear()
		
		for feat_name in available_feats:
			var feat_text: String = str(feat_name)
			var feat_data: Dictionary = FeatDatabase.get_feat_data(feat_text)
			var choice_type: String = str(feat_data.get("choice_type", ""))
			var has_extra_choice: bool = choice_type != ""
			
			var already_used: bool = false
			
			for j in range(previous_selected_feats.size()):
				if j == i:
					continue
				
				var other_full: String = str(previous_selected_feats[j])
				var other_base: String = get_base_feat_name(other_full)
				
				if feat_text == other_base:
					if has_extra_choice:
						if other_full == current_selected_full:
							already_used = true
							break
					else:
						already_used = true
						break
			
			if already_used:
				continue
			
			option.add_item(feat_text)
		
		var selected_index: int = 0
		
		for option_index in range(option.item_count):
			if option.get_item_text(option_index) == current_selected_base:
				selected_index = option_index
				break
		
		if option.item_count > 0:
			option.select(selected_index)
	
	update_all_feat_choice_visibility()
	restore_feat_choices_from_full_names(previous_selected_feats)

func get_base_feat_name(full_feat_name: String) -> String:
	if full_feat_name.contains(":"):
		return full_feat_name.split(":")[0].strip_edges()
	
	return full_feat_name

func restore_feat_choices_from_full_names(previous_selected_feats: Array):
	for i in range(feat_options.size()):
		if i >= previous_selected_feats.size():
			continue
		
		var full_feat_name: String = str(previous_selected_feats[i])
		
		if not full_feat_name.contains(":"):
			continue
		
		if i >= feat_choice_options.size():
			continue
		
		var selected_choice: String = full_feat_name.split(":")[1].strip_edges()
		var choice_option: OptionButton = feat_choice_options[i]
		
		if choice_option == null:
			continue
		
		for choice_index in range(choice_option.item_count):
			if choice_option.get_item_text(choice_index) == selected_choice:
				choice_option.select(choice_index)
				break

func on_feat_extra_choice_selected(_selected_index: int, feat_slot_index: int):
	update_feat_description(feat_slot_index)
	update_stats_preview()


func update_feat_choice_visibility(feat_slot_index: int):
	if feat_slot_index < 0:
		return
	
	if feat_slot_index >= feat_options.size():
		return
	
	if feat_slot_index >= feat_choice_options.size():
		return
	
	if feat_slot_index >= feat_choice_labels.size():
		return
	
	var feat_option: OptionButton = feat_options[feat_slot_index]
	var choice_option: OptionButton = feat_choice_options[feat_slot_index]
	var choice_label: Label = feat_choice_labels[feat_slot_index]
	
	if feat_option == null:
		return
	
	if choice_option == null:
		return
	
	if choice_label == null:
		return
	
	choice_option.clear()
	choice_option.visible = false
	choice_label.visible = false
	choice_option.disabled = false
	
	if feat_option.selected < 0:
		return
	
	var feat_name: String = feat_option.get_item_text(feat_option.selected)
	var feat_data: Dictionary = FeatDatabase.get_feat_data(feat_name)
	
	if feat_data.is_empty():
		return
	
	var choice_type: String = str(feat_data.get("choice_type", ""))
	
	if choice_type == "":
		return
	
	var choices: Array = []
	
	if choice_type == "weapon":
		choice_label.text = "Escolha a arma"
		choices = feat_data.get("choices", [])
	
	elif choice_type == "spell_type":
		choice_label.text = "Escolha o tipo de magia"
		choices = feat_data.get("choices", [])
	
	elif choice_type == "weapon_specialization":
		choice_label.text = "Especializar arma"
		choices = get_focus_choices_for_type("Foco em Arma")
	
	elif choice_type == "spell_specialization":
		choice_label.text = "Especializar magia"
		choices = get_focus_choices_for_type("Foco em Magia")
	
	else:
		choice_label.text = "Escolha"
		choices = feat_data.get("choices", [])
	
	if choices.is_empty():
		choice_option.add_item("Pré-requisito ausente")
		choice_option.disabled = true
		choice_option.visible = true
		choice_label.visible = true
		choice_option.select(0)
		return
	
	for choice in choices:
		var choice_text: String = str(choice)
		var display_text: String = get_spell_type_display_name(choice_text)
		
		if choice_type == "spell_type" or choice_type == "spell_specialization":
			choice_option.add_item(display_text)
			choice_option.set_item_metadata(choice_option.item_count - 1, choice_text)
		else:
			choice_option.add_item(choice_text)
			choice_option.set_item_metadata(choice_option.item_count - 1, choice_text)
	
	choice_option.visible = true
	choice_label.visible = true
	choice_option.select(0)

func get_feat_name_with_choice(feat_slot_index: int) -> String:
	if feat_slot_index < 0:
		return ""
	
	if feat_slot_index >= feat_options.size():
		return ""
	
	var option: OptionButton = feat_options[feat_slot_index]
	
	if option == null:
		return ""
	
	if option.selected < 0:
		return ""
	
	var feat_name: String = option.get_item_text(option.selected)
	var feat_data: Dictionary = FeatDatabase.get_feat_data(feat_name)
	
	if feat_data.is_empty():
		return feat_name
	
	var choice_type: String = str(feat_data.get("choice_type", ""))
	
	if choice_type == "":
		return feat_name
	
	if feat_slot_index >= feat_choice_options.size():
		return feat_name
	
	var choice_option: OptionButton = feat_choice_options[feat_slot_index]
	
	if choice_option == null:
		return feat_name
	
	if choice_option.selected < 0:
		return feat_name
	
	if choice_option.item_count <= 0:
		return feat_name
	
	var selected_choice: String = str(choice_option.get_item_metadata(choice_option.selected))
	
	if selected_choice == "":
		selected_choice = choice_option.get_item_text(choice_option.selected)
	
	if selected_choice == "Pré-requisito ausente":
		return ""
	
	return feat_name + ": " + selected_choice

func get_focus_choices_for_type(focus_base_name: String) -> Array:
	var choices: Array = []
	
	for i in range(feat_options.size()):
		var full_feat_name: String = get_feat_name_with_choice(i)
		
		if full_feat_name == "":
			continue
		
		if not full_feat_name.contains(":"):
			continue
		
		var parts: PackedStringArray = full_feat_name.split(":")
		
		if parts.size() < 2:
			continue
		
		var base_name: String = parts[0].strip_edges()
		var choice_name: String = parts[1].strip_edges()
		
		if base_name == focus_base_name:
			if not choices.has(choice_name):
				choices.append(choice_name)
	
	return choices

func has_invalid_feat_prerequisites() -> bool:
	var selected_feats_array: Array = get_selected_feats()
	
	for feat_name in selected_feats_array:
		if feat_name.begins_with("Especialização em Arma:"):
			var weapon_name: String = feat_name.replace("Especialização em Arma:", "").strip_edges()
			var required_feat: String = "Foco em Arma: " + weapon_name
			
			if not selected_feats_array.has(required_feat):
				print("Especialização em Arma exige: ", required_feat)
				return true
		
		if feat_name.begins_with("Especialização em Magia:"):
			var spell_type: String = feat_name.replace("Especialização em Magia:", "").strip_edges()
			var required_magic_feat: String = "Foco em Magia: " + spell_type
			
			if not selected_feats_array.has(required_magic_feat):
				print("Especialização em Magia exige: ", required_magic_feat)
				return true
	
	return false

func get_spell_type_display_name(spell_type: String) -> String:
	if spell_type == "damage":
		return "Dano"
	
	if spell_type == "heal":
		return "Cura"
	
	if spell_type == "utility":
		return "Utilidade"
	
	if spell_type == "buff":
		return "Buff"
	
	if spell_type == "control":
		return "Controle"
	
	return spell_type
func get_feat_display_name(full_feat_name: String) -> String:
	if not full_feat_name.contains(":"):
		return full_feat_name
	
	var parts: PackedStringArray = full_feat_name.split(":")
	
	if parts.size() < 2:
		return full_feat_name
	
	var base_name: String = parts[0].strip_edges()
	var choice_name: String = parts[1].strip_edges()
	
	if base_name == "Foco em Magia" or base_name == "Especialização em Magia":
		return base_name + ": " + get_spell_type_display_name(choice_name)
	
	return full_feat_name
