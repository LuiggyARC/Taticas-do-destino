extends Control

var name_input: LineEdit
var race_option: OptionButton
var human_bonus_option: OptionButton
var class_option: OptionButton
var hp_progression_option: OptionButton
var roll_hp_button: Button
var stats_label: Label

var rolled_hp_value: int = 0
var has_rolled_hp: bool = false

var selected_race: String = "Humano"
var selected_human_bonus: String = "FOR"
var selected_class: String = "Bárbaro"
var selected_hp_progression_mode: String = "fixed"

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
		"traits": [
			"+2 em um atributo à escolha",
			"1 talento extra no 1º nível",
			"4 pontos de perícia adicionais no 1º nível",
			"1 ponto de perícia extra por nível subsequente"
		]
	},
	"Anão": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 12,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 6.0,
		"favored_class": "Guerreiro",
		"traits": [
			"+2 Constituição",
			"Visão no escuro 18m",
			"Armaduras pesadas não reduzem deslocamento",
			"+2 em Procurar relacionado a pedras",
			"Bônus contra venenos e magias",
			"Bônus de ataque contra orcs e goblinoides",
			"+4 CA contra gigantes"
		]
	},
	"Elfo": {
		"strength": 10,
		"dexterity": 12,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Mago ou Ranger",
		"traits": [
			"+2 Destreza",
			"Imunidade a magias de sono",
			"Visão no escuro 18m",
			"Proficiência com espada longa, rapieira, arco longo e arco curto",
			"+2 em Ouvir, Procurar e Observar"
		]
	},
	"Gnomo": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 12,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Pequeno",
		"size_modifier": 1,
		"movement": 6.0,
		"favored_class": "Bardo",
		"traits": [
			"+2 Constituição",
			"Tamanho Pequeno: +1 CA e +1 ataque",
			"Visão na penumbra",
			"Bônus de ataque contra kobolds e goblinoides",
			"+4 CA contra gigantes",
			"+2 em Ouvir",
			"Habilidades mágicas inatas se CAR 10+"
		]
	},
	"Halfling": {
		"strength": 10,
		"dexterity": 12,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Pequeno",
		"size_modifier": 1,
		"movement": 6.0,
		"favored_class": "Ladino",
		"traits": [
			"+2 Destreza",
			"Tamanho Pequeno: +1 CA e +1 ataque",
			"+2 em Escalar, Saltar e Mover-se Silenciosamente",
			"+1 em todos os testes de resistência",
			"+2 adicional contra medo",
			"+1 de bônus de ataque com armas à distância"
		]
	},
	"Meio-Elfo": {
		"strength": 10,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 12,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Qualquer",
		"traits": [
			"+2 Inteligência",
			"Imunidade a magias de sono",
			"Visão na penumbra",
			"+1 em Ouvir, Procurar e Observar",
			"+2 em Diplomacia e Obter Informação",
			"Sangue élfico"
		]
	},
	"Meio-Orc": {
		"strength": 12,
		"dexterity": 10,
		"constitution": 10,
		"wisdom": 10,
		"intelligence": 10,
		"charisma": 10,
		"size": "Médio",
		"size_modifier": 0,
		"movement": 9.0,
		"favored_class": "Bárbaro",
		"traits": [
			"+2 Força",
			"Visão no escuro 18m",
			"Sangue orc"
		]
	}
}
var class_presets := {
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
		"description": "Combatente feroz de linha de frente, focado em força bruta, resistência e mobilidade.",
		"features": [
			"Fúria: aumenta Força, Constituição e Vontade, mas reduz a CA",
			"+3m de deslocamento",
			"+2 em Reflexos",
			"Redução de Dano 5 no nível 10",
			"Redução de Dano 10 no nível 15"
		]
	},
		"Bardo": {
		"hit_die": 6,
		"fixed_hp_per_level": 4,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "ruim",
		"reflex_type": "bom",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 16,
		"spell_attribute": "charisma",
		"description": "Suporte versátil, usuário de magia arcana espontânea e especialista em perícias variadas.",
		"features": [
			"Música Bárdica: +2 para acerto de magias contra testes de resistência",
			"Conhecimento Bárdico: sabe um pouco sobre quase tudo",
			"Conjuração arcana espontânea baseada em Carisma",
			"Boa quantidade de perícias"
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
		"description": "Conjurador divino resistente, focado em cura, suporte e combate durável.",
		"features": [
			"Conjuração divina baseada em Sabedoria",
			"Cura e suporte divino",
			"Expulsar ou Fascinar Mortos-Vivos",
			"Magias adicionais baseadas na divindade"
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
		"description": "Conjurador divino ligado à natureza, especializado em controle de terreno, suporte natural e transformação.",
		"features": [
			"Magia divina focada na natureza baseada em Sabedoria",
			"Companheiro Animal",
			"Forma Selvagem: transformação em animais ou elementais",
			"Controle de terreno e suporte natural"
		]
	},
	"Feiticeiro": {
		"hit_die": 4,
		"fixed_hp_per_level": 3,
		"base_attack_bonus_type": "baixo",
		"fortitude_type": "ruim",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 14,
		"spell_attribute": "charisma",
		"description": "Conjurador arcano espontâneo, focado em poder mágico bruto e instintivo.",
		"features": [
			"Conjuração arcana espontânea baseada em Carisma",
			"Conhece poucas magias, mas pode conjurá-las muitas vezes",
			"Não precisa preparar magias com antecedência",
			"Familiar: pet mágico"
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
		"description": "Combatente versátil, treinado em armas, armaduras e táticas militares.",
		"features": [
			"Dado de Vida d10",
			"BBA alto",
			"Fortitude boa",
			"Usa todas as armas e táticas militares",
			"Talento adicional no 1º nível",
			"Talento adicional no 2º nível",
			"Talento adicional a cada dois níveis subsequentes: 4º, 6º, 8º..."
		]
	},
	"Ladino": {
		"hit_die": 6,
		"fixed_hp_per_level": 4,
		"base_attack_bonus_type": "medio",
		"fortitude_type": "ruim",
		"reflex_type": "bom",
		"will_type": "ruim",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 16,
		"spell_attribute": "none",
		"description": "Especialista em furtividade, perícias e dano preciso contra pontos fracos.",
		"features": [
			"Dado de Vida d6",
			"BBA médio",
			"Reflexos bons",
			"Ataque Furtivo: dano extra contra inimigos flanqueados ou em desvantagem",
			"Encontrar Armadilhas",
			"Evasão: não sofre dano se passar em testes de Reflexos contra certos efeitos",
			"Esquiva Sobrenatural",
			"Maior quantidade de pontos de perícia do jogo"
		]
	},
	"Mago": {
		"hit_die": 4,
		"fixed_hp_per_level": 3,
		"base_attack_bonus_type": "baixo",
		"fortitude_type": "ruim",
		"reflex_type": "ruim",
		"will_type": "bom",
		"reflex_extra_bonus": 0,
		"movement_bonus": 0.0,
		"attack": 12,
		"spell_attribute": "intelligence",
		"description": "Especialista em magia arcana preparada, estudo mágico, controle e utilidade extrema.",
		"features": [
			"Dado de Vida d4",
			"BBA baixo",
			"Vontade boa",
			"Conjuração arcana preparatória baseada em Inteligência",
			"Precisa estudar grimórios e preparar magias diariamente",
			"Pode aprender uma quantidade muito grande de magias",
			"Talento de metamágica +1 no início",
			"Familiar: pet mágico"
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
		"description": "Combatente desarmado móvel, com defesas místicas e ótimo desempenho em resistências.",
		"features": [
			"Dado de Vida d8",
			"BBA médio",
			"Fortitude boa",
			"Reflexos bons",
			"Vontade boa",
			"Dano desarmado progressivo",
			"Rajada de Golpes: ataques extras com penalidade",
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
		"spell_attribute": "wisdom",
		"alignment_restriction": "Leal e Bom",
		"description": "Cavaleiro sagrado, focado em liderança, defesa contra o mal, cura e combate resistente.",
		"features": [
			"Dado de Vida d10",
			"BBA alto",
			"Fortitude boa",
			"Restrito à tendência Leal e Bom",
			"Destruir o Mal: soma Carisma no ataque e nível no dano",
			"Cura pelas Mãos",
			"Graça Divina: soma bônus de Carisma em todos os testes de resistência",
			"Montaria Especial no nível 5",
			"Pequeno número de magias divinas nos níveis mais altos"
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
		"spell_attribute": "wisdom",
		"description": "Sobrevivente, rastreador e combatente especializado em arquearia ou combate com duas armas.",
		"features": [
			"Dado de Vida d8",
			"BBA alto",
			"Fortitude boa",
			"Reflexos bons",
			"Inimigo Predileto: bônus contra tipos específicos de criaturas",
			"Estilos de Combate gratuitos nos níveis 2, 6 e 11",
			"Companheiro Animal",
			"Conjuração de magias divinas limitadas em níveis mais altos"
		]
	},
}
func _ready():
	create_ui()
	update_stats_preview()


func create_ui():
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var panel := Panel.new()
	panel.name = "CharacterCreationPanel"
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(panel)
	
	var scroll := ScrollContainer.new()
	scroll.name = "CreationScroll"
	scroll.position = Vector2(230, 40)
	scroll.size = Vector2(600, 880)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	panel.add_child(scroll)

	var container := VBoxContainer.new()
	container.name = "CreationContainer"
	container.custom_minimum_size = Vector2(560, 1050)
	scroll.add_child(container)
	
	var title := Label.new()
	title.text = "Criação de Personagem"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(520, 50)
	container.add_child(title)
	
	var name_label := Label.new()
	name_label.text = "Nome do personagem"
	name_label.custom_minimum_size = Vector2(520, 30)
	container.add_child(name_label)
	
	name_input = LineEdit.new()
	name_input.placeholder_text = "Digite o nome do herói"
	name_input.text = GameState.player_name
	name_input.custom_minimum_size = Vector2(520, 45)
	container.add_child(name_input)
	
	var race_label := Label.new()
	race_label.text = "Raça"
	race_label.custom_minimum_size = Vector2(520, 30)
	container.add_child(race_label)
	
	race_option = OptionButton.new()
	race_option.custom_minimum_size = Vector2(520, 45)
	race_option.add_item("Humano", 0)
	race_option.add_item("Anão", 1)
	race_option.add_item("Elfo", 2)
	race_option.add_item("Gnomo", 3)
	race_option.add_item("Halfling", 4)
	race_option.add_item("Meio-Elfo", 5)
	race_option.add_item("Meio-Orc", 6)
	race_option.item_selected.connect(on_race_selected)
	container.add_child(race_option)
	
	var human_bonus_label := Label.new()
	human_bonus_label.text = "Bônus humano (+2)"
	human_bonus_label.custom_minimum_size = Vector2(520, 30)
	container.add_child(human_bonus_label)
	
	human_bonus_option = OptionButton.new()
	human_bonus_option.custom_minimum_size = Vector2(520, 45)
	human_bonus_option.add_item("FOR", 0)
	human_bonus_option.add_item("DES", 1)
	human_bonus_option.add_item("CON", 2)
	human_bonus_option.add_item("SAB", 3)
	human_bonus_option.add_item("INT", 4)
	human_bonus_option.add_item("CAR", 5)
	human_bonus_option.item_selected.connect(on_human_bonus_selected)
	container.add_child(human_bonus_option)
	var class_label := Label.new()
	class_label.text = "Classe"
	class_label.custom_minimum_size = Vector2(520, 30)
	container.add_child(class_label)

	class_option = OptionButton.new()
	class_option.custom_minimum_size = Vector2(520, 45)
	class_option.add_item("Bárbaro", 0)
	class_option.add_item("Bardo", 1)
	class_option.add_item("Clérigo", 2)
	class_option.add_item("Druida", 3)
	class_option.add_item("Feiticeiro", 4)
	class_option.add_item("Guerreiro", 5)
	class_option.add_item("Ladino", 6)
	class_option.add_item("Mago", 7)
	class_option.add_item("Monge", 8)
	class_option.add_item("Paladino", 9)
	class_option.add_item("Ranger", 10)
	class_option.item_selected.connect(on_class_selected)
	container.add_child(class_option)
	var hp_progression_label := Label.new()
	hp_progression_label.text = "Vida ao subir de nível"
	hp_progression_label.custom_minimum_size = Vector2(520, 30)
	container.add_child(hp_progression_label)

	var hp_row := HBoxContainer.new()
	hp_row.custom_minimum_size = Vector2(560, 45)
	container.add_child(hp_row)

	hp_progression_option = OptionButton.new()
	hp_progression_option.custom_minimum_size = Vector2(380, 45)
	hp_progression_option.add_item("Padrão: +8 por nível", 0)
	hp_progression_option.add_item("Rolagem: 1d12 por nível", 1)
	hp_progression_option.item_selected.connect(on_hp_progression_selected)
	hp_row.add_child(hp_progression_option)

	roll_hp_button = Button.new()
	roll_hp_button.text = "Rolar Vida"
	roll_hp_button.custom_minimum_size = Vector2(160, 45)
	roll_hp_button.disabled = true
	roll_hp_button.pressed.connect(roll_starting_hp)
	hp_row.add_child(roll_hp_button)
	stats_label = Label.new()
	stats_label.custom_minimum_size = Vector2(520, 260)
	stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	container.add_child(stats_label)
	
	var confirm_button := Button.new()
	confirm_button.text = "Confirmar e iniciar"
	confirm_button.custom_minimum_size = Vector2(520, 45)
	confirm_button.pressed.connect(confirm_character)
	container.add_child(confirm_button)
	
	var back_button := Button.new()
	back_button.text = "Voltar"
	back_button.custom_minimum_size = Vector2(520, 45)
	back_button.pressed.connect(back_to_menu)
	container.add_child(back_button)


func on_race_selected(index: int):
	if index == 0:
		selected_race = "Humano"
		human_bonus_option.disabled = false
	elif index == 1:
		selected_race = "Anão"
		human_bonus_option.disabled = true
	elif index == 2:
		selected_race = "Elfo"
		human_bonus_option.disabled = true
	elif index == 3:
		selected_race = "Gnomo"
		human_bonus_option.disabled = true
	elif index == 4:
		selected_race = "Halfling"
		human_bonus_option.disabled = true
	elif index == 5:
		selected_race = "Meio-Elfo"
		human_bonus_option.disabled = true
	elif index == 6:
		selected_race = "Meio-Orc"
		human_bonus_option.disabled = true
	
	update_stats_preview()
	
func on_human_bonus_selected(index: int):
	if index == 0:
		selected_human_bonus = "FOR"
	elif index == 1:
		selected_human_bonus = "DES"
	elif index == 2:
		selected_human_bonus = "CON"
	elif index == 3:
		selected_human_bonus = "SAB"
	elif index == 4:
		selected_human_bonus = "INT"
	elif index == 5:
		selected_human_bonus = "CAR"
	
	update_stats_preview()


func get_final_race_attributes() -> Dictionary:
	var race_preset = race_presets[selected_race]
	
	var final_attributes := {
		"strength": int(race_preset["strength"]),
		"dexterity": int(race_preset["dexterity"]),
		"constitution": int(race_preset["constitution"]),
		"wisdom": int(race_preset["wisdom"]),
		"intelligence": int(race_preset["intelligence"]),
		"charisma": int(race_preset["charisma"])
	}
	
	if selected_race == "Humano":
		if selected_human_bonus == "FOR":
			final_attributes["strength"] += 2
		elif selected_human_bonus == "DES":
			final_attributes["dexterity"] += 2
		elif selected_human_bonus == "CON":
			final_attributes["constitution"] += 2
		elif selected_human_bonus == "SAB":
			final_attributes["wisdom"] += 2
		elif selected_human_bonus == "INT":
			final_attributes["intelligence"] += 2
		elif selected_human_bonus == "CAR":
			final_attributes["charisma"] += 2
	
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
	var fortitude_bonus: int = calculate_save_bonus(str(class_preset["fortitude_type"]), level)
	var reflex_bonus: int = calculate_save_bonus(str(class_preset["reflex_type"]), level) + int(class_preset["reflex_extra_bonus"])
	var will_bonus: int = calculate_save_bonus(str(class_preset["will_type"]), level)
	
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
	
	var hp_mode_text := "Padrão ao subir: +" + str(fixed_hp) + " + CON por nível"
	
	if selected_hp_progression_mode == "roll":
		if has_rolled_hp:
			hp_mode_text = "Rolagem inicial: " + str(rolled_hp_value) + " + CON"
		else:
			hp_mode_text = "Rolagem inicial: clique em Rolar Vida 1d" + str(hit_die)
	
	stats_label.text = (
		"Raça: " + selected_race + "\n" +
		"Classe: " + selected_class + "\n\n" +
		"Tamanho: " + str(race_preset["size"]) + "\n" +
		"Deslocamento final: " + str(final_movement) + "m\n" +
		"Progressão de vida: " + hp_mode_text + "\n\n" +
		"FOR " + str(attributes["strength"]) + " | DES " + str(attributes["dexterity"]) + " | CON " + str(attributes["constitution"]) + "\n" +
		"SAB " + str(attributes["wisdom"]) + " | INT " + str(attributes["intelligence"]) + " | CAR " + str(attributes["charisma"]) + "\n\n" +
		"DV: d" + str(class_preset["hit_die"]) + "\n" +
		"HP inicial: " + str(starting_hp) + "\n" +
		"BBA: +" + str(base_attack_bonus) + "\n" +
		"FORT +" + str(fortitude_bonus) + " | REF +" + str(reflex_bonus) + " | VON +" + str(will_bonus) + "\n" +
		"Atributo mágico: " + spell_attribute_text + "\n\n" +
		"Vantagens raciais:\n" +
		traits_text + "\n" +
		"Habilidades de classe:\n" +
		features_text
	)
func confirm_character():
	var chosen_name := name_input.text.strip_edges()
	
	if chosen_name == "":
		chosen_name = "Herói"
	
	var race_preset = race_presets[selected_race]
	var class_preset = class_presets[selected_class]
	var attributes := get_final_race_attributes()
	
	var level := 1
	
	var constitution_modifier: int = get_attribute_modifier(int(attributes["constitution"]))
	var starting_hp: int = 0
	
	if selected_hp_progression_mode == "roll":
		if not has_rolled_hp:
			print("Você escolheu rolagem de vida. Clique em Rolar Vida antes de iniciar.")
			return
		
		starting_hp = rolled_hp_value + constitution_modifier
	else:
		starting_hp = int(class_preset["hit_die"]) + constitution_modifier
	
	if starting_hp < 1:
		starting_hp = 1
	
	var final_movement: float = float(race_preset["movement"]) + float(class_preset["movement_bonus"])
	
	var fortitude_bonus: int = calculate_save_bonus(str(class_preset["fortitude_type"]), level)
	var reflex_bonus: int = calculate_save_bonus(str(class_preset["reflex_type"]), level) + int(class_preset["reflex_extra_bonus"])
	var will_bonus: int = calculate_save_bonus(str(class_preset["will_type"]), level)
	
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	GameState.selected_stage = 1
	
	GameState.player_name = chosen_name
	GameState.player_class = selected_class
	GameState.player_race = selected_race
	
	GameState.hero_level = 1
	GameState.hero_total_xp = 0
	GameState.hero_xp_to_next_level = 1000
	GameState.hero_max_level = 20
	
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
	GameState.hero_hp_fixed_per_level = int(class_preset["fixed_hp_per_level"])
	GameState.hero_hp_progression_mode = selected_hp_progression_mode
	
	GameState.hero_base_attack_bonus_type = str(class_preset["base_attack_bonus_type"])
	GameState.hero_fortitude_type = str(class_preset["fortitude_type"])
	GameState.hero_reflex_type = str(class_preset["reflex_type"])
	GameState.hero_will_type = str(class_preset["will_type"])
	
	GameState.hero_fortitude_base_bonus = fortitude_bonus
	GameState.hero_reflex_base_bonus = reflex_bonus
	GameState.hero_will_base_bonus = will_bonus
	
	GameState.hero_class_movement_bonus = float(class_preset["movement_bonus"])
	GameState.hero_damage_reduction = calculate_damage_reduction(level)
	GameState.hero_class_features = class_preset["features"]
	
	GameState.hero_max_hp = starting_hp
	GameState.hero_attack_power = int(class_preset["attack"])
	GameState.hero_max_movement_meters = final_movement
	
	get_tree().change_scene_to_file("res://Scene/main.tscn")
func back_to_menu():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
func on_class_selected(index: int):
	if index == 0:
		selected_class = "Bárbaro"
	elif index == 1:
		selected_class = "Bardo"
	elif index == 2:
		selected_class = "Clérigo"
	elif index == 3:
		selected_class = "Druida"
	elif index == 4:
		selected_class = "Feiticeiro"
	elif index == 5:
		selected_class = "Guerreiro"
	elif index == 6:
		selected_class = "Ladino"
	elif index == 7:
		selected_class = "Mago"
	elif index == 8:
		selected_class = "Monge"
	elif index == 9:
		selected_class = "Paladino"
	elif index == 10:
		selected_class = "Ranger"
	
	has_rolled_hp = false
	rolled_hp_value = 0
	
	update_hp_progression_options()
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
	hp_progression_option.add_item("Padrão: +" + str(fixed_hp) + " por nível", 0)
	hp_progression_option.add_item("Rolagem: 1d" + str(hit_die) + " por nível", 1)
	
	if selected_hp_progression_mode == "fixed":
		hp_progression_option.select(0)
		roll_hp_button.disabled = true
	else:
		hp_progression_option.select(1)
		roll_hp_button.disabled = false
