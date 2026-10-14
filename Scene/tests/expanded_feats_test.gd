extends Node

const HeroScript = preload("res://Scene/units/hero.gd")

const CLASS_FEATS := {
	"Bárbaro": ["Investida Voraz", "Têmpera Selvagem"],
	"Bardo": ["Voz de Comando", "Harmonia Persistente"],
	"Bruxo": ["Marca Profunda", "Pacto Duradouro"],
	"Clérigo": ["Prece Vigilante", "Fé Inabalável"],
	"Druida": ["Garras do Companheiro", "Raiz Protetora"],
	"Feiticeiro": ["Ímpeto da Linhagem", "Vigor Arcano"],
	"Guerreiro": ["Linha de Ferro", "Mestre de Batalha"],
	"Ladino": ["Ataque de Brecha", "Sombra Evasiva"],
	"Mago": ["Cálculo Defensivo", "Grimório de Reserva"],
	"Monge": ["Impulso do Vento", "Corpo de Pedra"],
	"Paladino": ["Voto de Guarda", "Luz Resoluta"],
	"Ranger": ["Mira Persistente", "Vínculo da Trilha"]
}

const GENERAL_FEATS := ["Olhos na Estrada", "Marcha Constante", "Disciplina Defensiva", "Pulso Resistente"]


func _ready() -> void:
	for character_class in CLASS_FEATS:
		var at_creation: Array = FeatDatabase.get_available_feats_for_character(character_class, "Humano", 1)
		var at_level_two: Array = FeatDatabase.get_available_feats_for_character(character_class, "Humano", 2)
		var at_level_eleven: Array = FeatDatabase.get_available_feats_for_character(character_class, "Humano", 11)
		for general_feat in GENERAL_FEATS:
			assert(at_creation.has(general_feat))
		var class_feats: Array = CLASS_FEATS[character_class]
		assert(not at_creation.has(class_feats[0]))
		assert(not at_level_two.has(class_feats[1]))
		assert(at_level_two.has(class_feats[0]))
		assert(at_level_eleven.has(class_feats[1]))
		for other_class in CLASS_FEATS:
			if other_class == character_class:
				continue
			assert(not at_level_eleven.has(CLASS_FEATS[other_class][0]))
			assert(not at_level_eleven.has(CLASS_FEATS[other_class][1]))

	var hero: Node2D = HeroScript.new()
	hero.character_class = "Guerreiro"
	hero.setup_feats(["Marcha Constante", "Linha de Ferro", "Mestre de Batalha"])
	assert(hero.feat_max_hp_bonus == 2)
	assert(hero.feat_movement_bonus == 1.5)
	assert(hero.feat_armor_class_bonus == 1)
	assert(hero.feat_attack_bonus == 1)
	assert(hero.feat_melee_damage_bonus == 3)
	hero.free()
	print("expanded_feats_test passed")
	get_tree().quit(0)
