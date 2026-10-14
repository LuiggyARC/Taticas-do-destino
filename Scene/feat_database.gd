extends Node

# Opções originais de Aviant inspiradas nos papéis táticos e marcos de
# progressão dos dois Livros do Jogador da 4ª edição.
const EXPANDED_GENERAL_FEATS := [
	{"name": "Olhos na Estrada", "description": "+2 em iniciativa e +1 em Reflexos.", "effects": {"initiative_bonus": 2, "reflex_bonus": 1}},
	{"name": "Marcha Constante", "description": "+1,5 m de deslocamento e +2 pontos de vida máximos.", "effects": {"movement_bonus": 1.5, "max_hp_bonus": 2}},
	{"name": "Disciplina Defensiva", "description": "+1 na Classe de Armadura e +1 em Vontade.", "effects": {"armor_class_bonus": 1, "will_bonus": 1}},
	{"name": "Pulso Resistente", "description": "+1 em Fortitude e +1 em Reflexos.", "effects": {"fortitude_bonus": 1, "reflex_bonus": 1}}
]

const EXPANDED_CLASS_FEATS := {
	"Bárbaro": [
		{"name": "Investida Voraz", "description": "+1 para acertar corpo a corpo e +1 de dano durante a Fúria.", "effects": {"melee_attack_bonus": 1, "rage_damage_bonus": 1}, "min_level": 2},
		{"name": "Têmpera Selvagem", "description": "+5 pontos de vida máximos e +1 em Fortitude.", "effects": {"max_hp_bonus": 5, "fortitude_bonus": 1}, "min_level": 11}
	],
	"Bardo": [
		{"name": "Voz de Comando", "description": "+1 na dificuldade para resistir às magias e +1 nas curas.", "effects": {"spell_save_dc_bonus": 1, "healing_bonus": 1}, "min_level": 2},
		{"name": "Harmonia Persistente", "description": "+2 nas curas e +1 em Vontade.", "effects": {"healing_bonus": 2, "will_bonus": 1}, "min_level": 11}
	],
	"Bruxo": [
		{"name": "Marca Profunda", "description": "+1 de dano com poderes do pacto e +1 em iniciativa.", "effects": {"spell_damage_bonus": 1, "initiative_bonus": 1}, "min_level": 2},
		{"name": "Pacto Duradouro", "description": "+5 pontos de vida máximos e +1 em Vontade.", "effects": {"max_hp_bonus": 5, "will_bonus": 1}, "min_level": 11}
	],
	"Clérigo": [
		{"name": "Prece Vigilante", "description": "+1 nas curas e +1 em Vontade.", "effects": {"healing_bonus": 1, "will_bonus": 1}, "min_level": 2},
		{"name": "Fé Inabalável", "description": "+2 nas curas e +1 em Fortitude.", "effects": {"healing_bonus": 2, "fortitude_bonus": 1}, "min_level": 11}
	],
	"Druida": [
		{"name": "Garras do Companheiro", "description": "+1 para acertar e +1 de dano com o companheiro animal.", "effects": {"animal_companion_attack_bonus": 1, "animal_companion_damage_bonus": 1}, "min_level": 2},
		{"name": "Raiz Protetora", "description": "+1 na Classe de Armadura e +1 em Fortitude.", "effects": {"armor_class_bonus": 1, "fortitude_bonus": 1}, "min_level": 11}
	],
	"Feiticeiro": [
		{"name": "Ímpeto da Linhagem", "description": "+1 de dano mágico e +1 em iniciativa.", "effects": {"spell_damage_bonus": 1, "initiative_bonus": 1}, "min_level": 2},
		{"name": "Vigor Arcano", "description": "+5 pontos de vida máximos e +1 em Fortitude.", "effects": {"max_hp_bonus": 5, "fortitude_bonus": 1}, "min_level": 11}
	],
	"Guerreiro": [
		{"name": "Linha de Ferro", "description": "+1 na Classe de Armadura e +1 de dano corpo a corpo.", "effects": {"armor_class_bonus": 1, "melee_damage_bonus": 1}, "min_level": 2},
		{"name": "Mestre de Batalha", "description": "+1 para acertar com armas e +2 de dano corpo a corpo.", "effects": {"attack_bonus": 1, "melee_damage_bonus": 2}, "min_level": 11}
	],
	"Ladino": [
		{"name": "Ataque de Brecha", "description": "+1 de dano contra inimigos flanqueados e +1 em iniciativa.", "effects": {"flanking_damage_bonus": 1, "initiative_bonus": 1}, "min_level": 2},
		{"name": "Sombra Evasiva", "description": "+1 em Reflexos e +1 na Classe de Armadura.", "effects": {"reflex_bonus": 1, "armor_class_bonus": 1}, "min_level": 11}
	],
	"Mago": [
		{"name": "Cálculo Defensivo", "description": "+1 na dificuldade para resistir às magias e +1 em Reflexos.", "effects": {"spell_save_dc_bonus": 1, "reflex_bonus": 1}, "min_level": 2},
		{"name": "Grimório de Reserva", "description": "+1 uso de magia de 1º círculo por dia e +2 de dano mágico.", "effects": {"extra_spell_slot_level_1": 1, "spell_damage_bonus": 2}, "min_level": 11}
	],
	"Monge": [
		{"name": "Impulso do Vento", "description": "+1,5 m de deslocamento e +1 em iniciativa.", "effects": {"movement_bonus": 1.5, "initiative_bonus": 1}, "min_level": 2},
		{"name": "Corpo de Pedra", "description": "+1 em Fortitude e +1 na Classe de Armadura.", "effects": {"fortitude_bonus": 1, "armor_class_bonus": 1}, "min_level": 11}
	],
	"Paladino": [
		{"name": "Voto de Guarda", "description": "+1 na Classe de Armadura e +1 de dano com Investida Consagrada.", "effects": {"armor_class_bonus": 1, "smite_damage_bonus": 1}, "min_level": 2},
		{"name": "Luz Resoluta", "description": "+1 em Vontade e +2 nas curas.", "effects": {"will_bonus": 1, "healing_bonus": 2}, "min_level": 11}
	],
	"Ranger": [
		{"name": "Mira Persistente", "description": "+1 de dano à distância e +1 em iniciativa.", "effects": {"ranged_damage_bonus": 1, "initiative_bonus": 1}, "min_level": 2},
		{"name": "Vínculo da Trilha", "description": "+1 de dano e +1 na armadura do companheiro animal.", "effects": {"animal_companion_damage_bonus": 1, "animal_companion_armor_bonus": 1}, "min_level": 11}
	]
}

const EXPANDED_CLASS_FLAGS := {
	"Bárbaro": "aviant_barbarian", "Bardo": "aviant_bard", "Bruxo": "aviant_warlock",
	"Clérigo": "aviant_cleric", "Druida": "aviant_druid", "Feiticeiro": "aviant_sorcerer",
	"Guerreiro": "aviant_fighter", "Ladino": "aviant_rogue", "Mago": "aviant_wizard",
	"Monge": "aviant_monk", "Paladino": "aviant_paladin", "Ranger": "aviant_ranger"
}

var feats := {
	"Pacto Intenso": {
		"category": "Bruxo",
		"description": "+1 de dano com poderes do pacto.",
		"effects": {"spell_damage_bonus": 1},
		"allowed_classes": ["Bruxo"],
		"combat_feat": true,
		"aviant_warlock": true
	},
	"Vontade do Pacto": {
		"category": "Bruxo",
		"description": "+1 em Vontade.",
		"effects": {"will_bonus": 1},
		"allowed_classes": ["Bruxo"],
		"combat_feat": false,
		"aviant_warlock": true
	},
	"Fôlego Sombrio": {
		"category": "Bruxo",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Bruxo"],
		"combat_feat": false,
		"aviant_warlock": true
	},
	"Selo Preciso": {
		"category": "Bruxo",
		"description": "+1 para acertar com poderes do pacto.",
		"effects": {},
		"allowed_classes": ["Bruxo"],
		"combat_feat": true,
		"aviant_warlock": true
	},
	"Escudo Oculto": {
		"category": "Bruxo",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Bruxo"],
		"combat_feat": false,
		"aviant_warlock": true
	},
	"Passo Crepuscular": {
		"category": "Bruxo",
		"description": "+1,5 m de deslocamento.",
		"effects": {"movement_bonus": 1.5},
		"allowed_classes": ["Bruxo"],
		"combat_feat": false,
		"aviant_warlock": true
	},
	"Punho Centrado": {
		"category": "Monge",
		"description": "+1 para acertar em ataques corpo a corpo.",
		"effects": {"melee_attack_bonus": 1},
		"allowed_classes": ["Monge"],
		"combat_feat": true,
		"aviant_monk": true
	},
	"Corpo Disciplinado": {
		"category": "Monge",
		"description": "+1 na Classe de Armadura sem armadura.",
		"effects": {"monk_armor_class_bonus": 1},
		"allowed_classes": ["Monge"],
		"combat_feat": false,
		"aviant_monk": true
	},
	"Passos Leves": {
		"category": "Monge",
		"description": "+1,5 m de deslocamento.",
		"effects": {"movement_bonus": 1.5},
		"allowed_classes": ["Monge"],
		"combat_feat": false,
		"aviant_monk": true
	},
	"Punhos Duros": {
		"category": "Monge",
		"description": "+2 de dano desarmado.",
		"effects": {"unarmed_damage_bonus": 2},
		"allowed_classes": ["Monge"],
		"combat_feat": true,
		"aviant_monk": true
	},
	"Mente Serena": {
		"category": "Monge",
		"description": "+1 em Vontade.",
		"effects": {"will_bonus": 1},
		"allowed_classes": ["Monge"],
		"combat_feat": false,
		"aviant_monk": true
	},
	"Fôlego Resistente": {
		"category": "Monge",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Monge"],
		"combat_feat": false,
		"aviant_monk": true
	},
	# Talentos originais de Aviant para o Bardo.
	"Voz Projetada": {
		"category": "Bardo",
		"description": "+1 na dificuldade para inimigos resistirem às suas magias.",
		"effects": {"spell_save_dc_bonus": 1},
		"allowed_classes": ["Bardo"],
		"combat_feat": true,
		"aviant_bard": true
	},
	"Acordes Fortes": {
		"category": "Bardo",
		"description": "+2 de cura em magias e na Canção de Recomeço.",
		"effects": {"healing_bonus": 2},
		"allowed_classes": ["Bardo"],
		"combat_feat": false,
		"aviant_bard": true
	},
	"Fôlego do Palco": {
		"category": "Bardo",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Bardo"],
		"combat_feat": false,
		"aviant_bard": true
	},
	"Passo de Dança": {
		"category": "Bardo",
		"description": "+1,5 m de deslocamento.",
		"effects": {"movement_bonus": 1.5},
		"allowed_classes": ["Bardo"],
		"combat_feat": false,
		"aviant_bard": true
	},
	"Dueto Preciso": {
		"category": "Bardo",
		"description": "+1 para acertar com armas.",
		"effects": {"attack_bonus": 1},
		"allowed_classes": ["Bardo"],
		"combat_feat": true,
		"aviant_bard": true
	},
	"Refrão Duradouro": {
		"category": "Bardo",
		"description": "Refrão de Coragem dura uma rodada adicional.",
		"effects": {"bard_song_extra_round": 1},
		"allowed_classes": ["Bardo"],
		"combat_feat": false,
		"aviant_bard": true
	},
	# Talentos originais de Aviant para o Guerreiro.
	"Lâmina Disciplinada": {
		"category": "Guerreiro",
		"description": "+1 para acertar com armas corpo a corpo.",
		"effects": {"melee_attack_bonus": 1},
		"allowed_classes": ["Guerreiro"],
		"combat_feat": true,
		"aviant_fighter": true
	},
	"Tiro Disciplinado": {
		"category": "Guerreiro",
		"description": "+1 para acertar com armas à distância.",
		"effects": {"ranged_attack_bonus": 1},
		"allowed_classes": ["Guerreiro"],
		"combat_feat": true,
		"aviant_fighter": true
	},
	"Armadura de Campanha": {
		"category": "Guerreiro",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Guerreiro"],
		"combat_feat": false,
		"aviant_fighter": true
	},
	"Vigor Marcial": {
		"category": "Guerreiro",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Guerreiro"],
		"combat_feat": false,
		"aviant_fighter": true
	},
	"Pancada de Ferro": {
		"category": "Guerreiro",
		"description": "+2 de dano com armas corpo a corpo.",
		"effects": {"melee_damage_bonus": 2},
		"allowed_classes": ["Guerreiro"],
		"combat_feat": true,
		"aviant_fighter": true
	},
	"Reflexo de Guarda": {
		"category": "Guerreiro",
		"description": "+1 em Fortitude e Reflexos.",
		"effects": {"fortitude_bonus": 1, "reflex_bonus": 1},
		"allowed_classes": ["Guerreiro"],
		"combat_feat": false,
		"aviant_fighter": true
	},
	# Talentos originais de Aviant para o Ranger.
	"Mira da Fronteira": {
		"category": "Ranger",
		"description": "+1 para acertar com armas à distância.",
		"effects": {"ranged_attack_bonus": 1},
		"allowed_classes": ["Ranger"],
		"combat_feat": true,
		"aviant_ranger": true
	},
	"Lâmina da Trilha": {
		"category": "Ranger",
		"description": "+1 para acertar com armas corpo a corpo.",
		"effects": {"melee_attack_bonus": 1},
		"allowed_classes": ["Ranger"],
		"combat_feat": true,
		"aviant_ranger": true
	},
	"Passo Aberto": {
		"category": "Ranger",
		"description": "+1,5 m de deslocamento.",
		"effects": {"movement_bonus": 1.5},
		"allowed_classes": ["Ranger"],
		"combat_feat": false,
		"aviant_ranger": true
	},
	"Fôlego da Caçada": {
		"category": "Ranger",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Ranger"],
		"combat_feat": false,
		"aviant_ranger": true
	},
	"Companheiro Tenaz": {
		"category": "Ranger",
		"description": "+4 pontos de vida máximos para o companheiro animal, disponível a partir do nível 4.",
		"effects": {"animal_companion_hp_bonus": 4},
		"requirements": {"min_level": 4},
		"allowed_classes": ["Ranger"],
		"combat_feat": false,
		"aviant_ranger": true
	},
	"Instinto da Caçada": {
		"category": "Ranger",
		"description": "+1 para acertar ataques do companheiro animal, disponível a partir do nível 4.",
		"effects": {"animal_companion_attack_bonus": 1},
		"requirements": {"min_level": 4},
		"allowed_classes": ["Ranger"],
		"combat_feat": true,
		"aviant_ranger": true
	},
	# Talentos originais de Aviant para o Clérigo.
	"Voto de Amparo": {
		"category": "Clérigo",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Clérigo"],
		"combat_feat": false,
		"aviant_cleric": true
	},
	"Mãos Generosas": {
		"category": "Clérigo",
		"description": "+2 de cura em magias e preces.",
		"effects": {"healing_bonus": 2},
		"allowed_classes": ["Clérigo"],
		"combat_feat": false,
		"aviant_cleric": true
	},
	"Convicção Serena": {
		"category": "Clérigo",
		"description": "+1 em Fortitude e Vontade.",
		"effects": {"fortitude_bonus": 1, "will_bonus": 1},
		"allowed_classes": ["Clérigo"],
		"combat_feat": false,
		"aviant_cleric": true
	},
	"Fôlego Devoto": {
		"category": "Clérigo",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Clérigo"],
		"combat_feat": false,
		"aviant_cleric": true
	},
	"Alcance da Fé": {
		"category": "Clérigo",
		"description": "+3 m no alcance das magias.",
		"effects": {"spell_range_bonus": 3.0},
		"allowed_classes": ["Clérigo"],
		"combat_feat": true,
		"aviant_cleric": true
	},
	"Selo Luminoso": {
		"category": "Clérigo",
		"description": "+2 de dano com magias ofensivas.",
		"effects": {"spell_damage_bonus": 2},
		"allowed_classes": ["Clérigo"],
		"combat_feat": true,
		"aviant_cleric": true
	},
	# Talentos originais de Aviant para o Ladino; os antigos seguem legíveis em saves.
	"Olho para Brechas": {
		"category": "Ladino",
		"description": "+1 para acertar inimigos flanqueados.",
		"effects": {"flanking_attack_bonus": 1},
		"allowed_classes": ["Ladino"],
		"combat_feat": true,
		"aviant_rogue": true
	},
	"Lâmina Discreta": {
		"category": "Ladino",
		"description": "+2 de dano ao atacar escondido.",
		"effects": {"hidden_damage_bonus": 2},
		"allowed_classes": ["Ladino"],
		"combat_feat": true,
		"aviant_rogue": true
	},
	"Passos de Veludo": {
		"category": "Ladino",
		"description": "+2 no teste para permanecer escondido.",
		"effects": {"hide_bonus": 2},
		"allowed_classes": ["Ladino"],
		"combat_feat": false,
		"aviant_rogue": true
	},
	"Ritmo de Emboscada": {
		"category": "Ladino",
		"description": "+1 em iniciativa.",
		"effects": {"initiative_bonus": 1},
		"allowed_classes": ["Ladino"],
		"combat_feat": false,
		"aviant_rogue": true
	},
	"Guarda Esquiva": {
		"category": "Ladino",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Ladino"],
		"combat_feat": false,
		"aviant_rogue": true
	},
	"Finta Persistente": {
		"category": "Ladino",
		"description": "+2 de dano contra inimigos flanqueados.",
		"effects": {"flanking_damage_bonus": 2},
		"allowed_classes": ["Ladino"],
		"combat_feat": true,
		"aviant_rogue": true
	},
	# Talentos próprios dos conjuradores; opções antigas continuam legíveis em saves.
	"Geometria Arcana": {
		"category": "Mago",
		"description": "+1 na dificuldade para inimigos resistirem às suas magias.",
		"effects": {"spell_save_dc_bonus": 1},
		"allowed_classes": ["Mago"],
		"combat_feat": true,
		"aviant_wizard": true
	},
	"Reserva de Tinta": {
		"category": "Mago",
		"description": "+1 uso de magia de 1º círculo por dia.",
		"effects": {"extra_spell_slot_level_1": 1},
		"allowed_classes": ["Mago"],
		"combat_feat": false,
		"aviant_wizard": true
	},
	"Raio Calculado": {
		"category": "Mago",
		"description": "+3 m no alcance das magias.",
		"effects": {"spell_range_bonus": 3.0},
		"allowed_classes": ["Mago"],
		"combat_feat": true,
		"aviant_wizard": true
	},
	"Círculo de Defesa": {
		"category": "Mago",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Mago"],
		"combat_feat": false,
		"aviant_wizard": true
	},
	"Mente Organizada": {
		"category": "Mago",
		"description": "+1 em Vontade.",
		"effects": {"will_bonus": 1},
		"allowed_classes": ["Mago"],
		"combat_feat": false,
		"aviant_wizard": true
	},
	"Condução Refinada": {
		"category": "Mago",
		"description": "+2 de dano com magias ofensivas.",
		"effects": {"spell_damage_bonus": 2},
		"allowed_classes": ["Mago"],
		"combat_feat": true,
		"aviant_wizard": true
	},
	"Sangue Fulminante": {
		"category": "Feiticeiro",
		"description": "+2 de dano com magias ofensivas.",
		"effects": {"spell_damage_bonus": 2},
		"allowed_classes": ["Feiticeiro"],
		"combat_feat": true,
		"aviant_sorcerer": true
	},
	"Reservatório Inato": {
		"category": "Feiticeiro",
		"description": "+1 uso de magia de 1º círculo por dia.",
		"effects": {"extra_spell_slot_level_1": 1},
		"allowed_classes": ["Feiticeiro"],
		"combat_feat": false,
		"aviant_sorcerer": true
	},
	"Ímpeto Instintivo": {
		"category": "Feiticeiro",
		"description": "+1 na iniciativa.",
		"effects": {"initiative_bonus": 1},
		"allowed_classes": ["Feiticeiro"],
		"combat_feat": false,
		"aviant_sorcerer": true
	},
	"Pele Etérea": {
		"category": "Feiticeiro",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Feiticeiro"],
		"combat_feat": false,
		"aviant_sorcerer": true
	},
	"Eco Longínquo": {
		"category": "Feiticeiro",
		"description": "+3 m no alcance das magias.",
		"effects": {"spell_range_bonus": 3.0},
		"allowed_classes": ["Feiticeiro"],
		"combat_feat": true,
		"aviant_sorcerer": true
	},
	"Fôlego da Linhagem": {
		"category": "Feiticeiro",
		"description": "+1 em Fortitude.",
		"effects": {"fortitude_bonus": 1},
		"allowed_classes": ["Feiticeiro"],
		"combat_feat": false,
		"aviant_sorcerer": true
	},
	# Talentos originais da nova seleção do Druida.
	"Casca Espessa": {
		"category": "Druida",
		"description": "Casca Viva concede +1 adicional na defesa.",
		"effects": {"druid_guard_bonus": 1},
		"allowed_classes": ["Druida"],
		"combat_feat": false,
		"aviant_druid": true
	},
	"Garras da Mata": {
		"category": "Druida",
		"description": "+1 de dano corpo a corpo enquanto Aspecto Selvagem estiver ativo.",
		"effects": {"druid_form_damage_bonus": 1},
		"allowed_classes": ["Druida"],
		"combat_feat": true,
		"aviant_druid": true
	},
	"Passo da Floresta": {
		"category": "Druida",
		"description": "+1,5 m de deslocamento.",
		"effects": {"movement_bonus": 1.5},
		"allowed_classes": ["Druida"],
		"combat_feat": false,
		"aviant_druid": true
	},
	"Companheiro Robusto": {
		"category": "Druida",
		"description": "+4 pontos de vida máximos para o companheiro animal.",
		"effects": {"animal_companion_hp_bonus": 4},
		"allowed_classes": ["Druida"],
		"combat_feat": false,
		"aviant_druid": true
	},
	"Instinto da Matilha": {
		"category": "Druida",
		"description": "+1 para acertar ataques do companheiro animal.",
		"effects": {"animal_companion_attack_bonus": 1},
		"allowed_classes": ["Druida"],
		"combat_feat": true,
		"aviant_druid": true
	},
	"Seiva Generosa": {
		"category": "Druida",
		"description": "+2 na cura de Círculo Vital.",
		"effects": {"druid_circle_healing_bonus": 2},
		"allowed_classes": ["Druida"],
		"combat_feat": false,
		"aviant_druid": true
	},
	# Nova seleção do Paladino; os talentos antigos continuam disponíveis para saves.
	"Defesa Juramentada": {
		"category": "Paladino",
		"description": "+1 na Classe de Armadura.",
		"effects": {"armor_class_bonus": 1},
		"allowed_classes": ["Paladino"],
		"combat_feat": false,
		"aviant_paladin": true
	},
	"Lâmina da Ordem": {
		"category": "Paladino",
		"description": "+1 para acertar ataques corpo a corpo.",
		"effects": {"melee_attack_bonus": 1},
		"allowed_classes": ["Paladino"],
		"combat_feat": true,
		"aviant_paladin": true
	},
	"Fôlego Sagrado": {
		"category": "Paladino",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Paladino"],
		"combat_feat": false,
		"aviant_paladin": true
	},
	"Resolução Devota": {
		"category": "Paladino",
		"description": "+1 em Fortitude, Reflexos e Vontade.",
		"effects": {"fortitude_bonus": 1, "reflex_bonus": 1, "will_bonus": 1},
		"allowed_classes": ["Paladino"],
		"combat_feat": false,
		"aviant_paladin": true
	},
	"Cura Compassiva": {
		"category": "Paladino",
		"description": "+2 pontos de cura com poderes de classe.",
		"effects": {"healing_bonus": 2},
		"allowed_classes": ["Paladino"],
		"combat_feat": false,
		"aviant_paladin": true
	},
	"Justiça Ardente": {
		"category": "Paladino",
		"description": "+2 de dano com Investida Consagrada.",
		"effects": {"smite_damage_bonus": 2},
		"allowed_classes": ["Paladino"],
		"combat_feat": true,
		"aviant_paladin": true
	},
	# Nova seleção do Bárbaro: talentos próprios de Aviant.
	# Os nomes antigos permanecem no catálogo para carregar saves anteriores.
	"Precisão Selvagem": {
		"category": "Bárbaro",
		"description": "+1 para acertar ataques com armas.",
		"effects": {"attack_bonus": 1},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": true,
		"aviant_barbarian": true
	},
	"Golpe Pesado": {
		"category": "Bárbaro",
		"description": "Ataques corpo a corpo: -1 para acertar, +2 de dano.",
		"effects": {
			"power_attack_attack_penalty": -1,
			"power_attack_damage_bonus": 2
		},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": true,
		"aviant_barbarian": true
	},
	"Força Implacável": {
		"category": "Bárbaro",
		"description": "+2 de dano com armas corpo a corpo.",
		"effects": {"damage_bonus": 2},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": true,
		"aviant_barbarian": true
	},
	"Sangue Ardente": {
		"category": "Bárbaro",
		"description": "+2 de dano enquanto a Fúria estiver ativa.",
		"effects": {"rage_damage_bonus": 2},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": true,
		"aviant_barbarian": true
	},
	"Fôlego da Fúria": {
		"category": "Bárbaro",
		"description": "+1 uso de Fúria por combate.",
		"effects": {"extra_rage_use": 1},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": true,
		"aviant_barbarian": true
	},
	"Pele de Ferro": {
		"category": "Bárbaro",
		"description": "+3 pontos de vida máximos.",
		"effects": {"max_hp_bonus": 3},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": false,
		"aviant_barbarian": true
	},
	"Vitalidade": {
		"category": "Geral",
		"description": "+3 HP máximo.",
		"effects": {
			"max_hp_bonus": 3
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Iniciativa Aprimorada": {
		"category": "Geral",
		"description": "+4 em iniciativa quando o sistema de iniciativa for criado.",
		"effects": {
			"initiative_bonus": 4
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Reflexos Rápidos": {
		"category": "Geral",
		"description": "+2 em Reflexos.",
		"effects": {
			"reflex_bonus": 2
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Vontade de Ferro": {
		"category": "Geral",
		"description": "+2 em Vontade.",
		"effects": {
			"will_bonus": 2
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Fortitude Maior": {
		"category": "Geral",
		"description": "+2 em Fortitude.",
		"effects": {
			"fortitude_bonus": 2
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Esquiva": {
		"category": "Combate",
		"description": "+1 na Classe de Armadura.",
		"effects": {
			"armor_class_bonus": 1
		},
		"allowed_classes": [],
		"combat_feat": true
	},

	"Ataque Poderoso": {
	"category": "Combate",
	"description": "-1 ataque, +2 dano corpo a corpo.",
	"effects": {
		"power_attack_attack_penalty": -1,
		"power_attack_damage_bonus": 2
	},
	"requirements": {
		"min_strength": 13
	},
	"allowed_classes": ["Guerreiro", "Bárbaro", "Paladino", "Monge"],
	"combat_feat": true
},

	"Tiro Certeiro": {
	"category": "Combate",
	"description": "+1 ataque e +1 dano com armas à distância.",
	"effects": {
		"ranged_attack_bonus": 1,
		"ranged_damage_bonus": 1
	},
	"requirements": {
		"min_dexterity": 12
	},
	"allowed_classes": ["Guerreiro", "Ladino", "Ranger"],
	"combat_feat": true
},

	"Combate com Duas Armas": {
	"category": "Combate",
	"description": "Permite estilo de luta com duas armas futuramente.",
	"effects": {
		"two_weapon_fighting": true
	},
	"requirements": {
		"min_dexterity": 13
	},
	"allowed_classes": ["Guerreiro", "Ladino", "Ranger"],
	"combat_feat": true
},

	"Magia Penetrante": {
		"category": "Magia",
		"description": "Ajuda contra resistência mágica futuramente.",
		"effects": {
			"spell_penetration_bonus": 2
		},
		"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"],
		"combat_feat": false
	},

	"Conjuração Defensiva": {
		"category": "Magia",
		"description": "Ajuda a conjurar perto de inimigos futuramente.",
		"effects": {
			"defensive_casting_bonus": 4
		},
		"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"],
		"combat_feat": false
	},

	"Magia Aumentada": {
		"category": "Magia",
		"description": "Aumenta efeitos de magia futuramente.",
		"effects": {
			"empowered_spell": true
		},
		"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"],
		"combat_feat": false
	},
	
	"Foco em Arma": {
	"category": "Combate",
	"description": "+1 nas jogadas de ataque com a arma escolhida.",
	"effects": {
		"weapon_focus_bonus": 1
	},
	"choice_type": "weapon",
	"choices": [
		"Soco",
		"Adaga",
		"Clava",
		"Maça Leve",
		"Maça Pesada",
		"Lança",
		"Espada Curta",
		"Espada Longa",
		"Machado de Batalha",
		"Machado Grande",
		"Martelo de Guerra",
		"Foice",
		"Bastão",
		"Arco Curto",
		"Arco Longo",
		"Besta Leve",
		"Besta Pesada",
		"Funda",
		"Dardo",
		"Azagaia"
	],
	"requirements": {},
	"allowed_classes": [],
	"combat_feat": true
},

	"Foco em Magia": {
	"category": "Magia",
	"description": "+1 no efeito de magias do tipo escolhido.",
	"effects": {
		"spell_focus_bonus": 1
	},
	"choice_type": "spell_type",
	"choices": ["damage", "heal", "utility", "buff", "control"],
	"requirements": {},
	"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"],
	"combat_feat": false
},
	
	"Furtividade Aprimorada": {
	"category": "Furtivo",
	"description": "+2 em Esconder-se.",
	"effects": {
		"hide_bonus": 2
	},
	"requirements": {
		"required_classes": ["Ladino", "Ranger"]
	},
	"allowed_classes": ["Ladino", "Ranger"],
	"combat_feat": false
},

	"Ataque Furtivo Aprimorado": {
	"category": "Furtivo",
	"description": "+1d6 no ataque furtivo.",
	"effects": {
		"sneak_attack_extra_dice": 1
	},
	"requirements": {
		"required_classes": ["Ladino"]
	},
	"allowed_classes": ["Ladino"],
	"combat_feat": false
},

	"Reflexos de Combate": {
		"category": "Furtivo",
		"description": "Melhora ataques de oportunidade futuramente.",
		"effects": {
			"combat_reflexes": true
		},
		"allowed_classes": ["Ladino", "Guerreiro", "Monge"],
		"combat_feat": true
	},

	"Canalizar Energia Extra": {
		"category": "Divino",
		"description": "Aumenta usos de canalizar energia futuramente.",
		"effects": {
			"extra_channel_energy": 1
		},
		"allowed_classes": ["Clérigo", "Paladino"],
		"combat_feat": false
	},

	"Golpe Sagrado": {
		"category": "Divino",
		"description": "+2 dano sagrado contra inimigos.",
		"effects": {
			"holy_damage_bonus": 2
		},
		"allowed_classes": ["Clérigo", "Paladino"],
		"combat_feat": true
	},

	"Companheiro Animal Fortalecido": {
	"category": "Natureza",
	"description": "+4 HP para o companheiro animal.",
	"effects": {
		"animal_companion_hp_bonus": 4
	},
	"requirements": {
		"required_classes": ["Druida", "Ranger"]
	},
	"allowed_classes": ["Druida", "Ranger"],
	"combat_feat": false
},

	"Afinidade Selvagem": {
		"category": "Natureza",
		"description": "Melhora interações com criaturas naturais futuramente.",
		"effects": {
			"wild_affinity_bonus": 2
		},
		"allowed_classes": ["Druida", "Ranger"],
		"combat_feat": false
	},
		"Treinamento Marcial": {
		"category": "Geral",
		"description": "+1 nas jogadas de ataque corpo a corpo.",
		"effects": {
			"melee_attack_bonus": 1
		},
		"allowed_classes": [],
		"combat_feat": true
	},

	"Resistência": {
		"category": "Geral",
		"description": "+1 em todos os testes de resistência.",
		"effects": {
			"fortitude_bonus": 1,
			"reflex_bonus": 1,
			"will_bonus": 1
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Robustez Maior": {
		"category": "Geral",
		"description": "+5 HP máximo.",
		"effects": {
			"max_hp_bonus": 5
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Percepção Aguçada": {
		"category": "Geral",
		"description": "+2 em testes de Observar.",
		"effects": {
			"observe_bonus": 2
		},
		"allowed_classes": [],
		"combat_feat": false
	},

	"Movimento Ágil": {
		"category": "Geral",
		"description": "+1.5m de movimento.",
		"effects": {
			"movement_bonus": 1.5
		},
		"allowed_classes": [],
		"combat_feat": false
	},
		"Especialização em Arma": {
	"category": "Combate",
	"description": "+2 no dano com a arma escolhida. Exige Foco em Arma na mesma arma.",
	"effects": {
		"weapon_specialization_bonus": 2
	},
	"choice_type": "weapon_specialization",
	"choices": [],
	"requirements": {
		"required_feat_base": "Foco em Arma"
	},
	"allowed_classes": ["Guerreiro", "Monge"],
	"combat_feat": true
},

	"Ataque Preciso": {
		"category": "Combate",
		"description": "+1 nas jogadas de ataque.",
		"effects": {
			"attack_bonus": 1
		},
		"allowed_classes": ["Guerreiro", "Ladino", "Ranger", "Monge", "Paladino"],
		"combat_feat": true
	},
	"Especialização em Magia": {
	"category": "Magia",
	"description": "+2 no efeito de magias do tipo escolhido. Exige Foco em Magia no mesmo tipo.",
	"effects": {
		"spell_specialization_bonus": 2
	},
	"choice_type": "spell_specialization",
	"choices": [],
	"requirements": {
		"required_feat_base": "Foco em Magia"
	},
	"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"],
	"combat_feat": false
},

	"Golpe Brutal": {
		"category": "Combate",
		"description": "+2 no dano corpo a corpo.",
		"effects": {
			"damage_bonus": 2
		},
		"allowed_classes": ["Guerreiro", "Bárbaro", "Paladino", "Monge"],
		"combat_feat": true
	},

	"Defesa Aprimorada": {
		"category": "Combate",
		"description": "+2 na Classe de Armadura.",
		"effects": {
			"armor_class_bonus": 2
		},
		"allowed_classes": ["Guerreiro", "Paladino", "Monge"],
		"combat_feat": true
	},

	"Arqueiro Treinado": {
		"category": "Combate",
		"description": "+1 ataque e +1 dano com armas à distância.",
		"effects": {
			"ranged_attack_bonus": 1,
			"ranged_damage_bonus": 1
		},
		"allowed_classes": ["Guerreiro", "Ranger", "Ladino"],
		"combat_feat": true
	},

	"Reação Rápida": {
		"category": "Combate",
		"description": "+1 ataque de oportunidade adicional futuramente.",
		"effects": {
			"extra_opportunity_attack": 1
		},
		"allowed_classes": ["Guerreiro", "Ladino", "Monge"],
		"combat_feat": true
	},
		"Passos Silenciosos": {
		"category": "Furtivo",
		"description": "+2 em Esconder-se e movimentação furtiva.",
		"effects": {
			"hide_bonus": 2,
			"stealth_movement_bonus": 2
		},
		"allowed_classes": ["Ladino", "Ranger"],
		"combat_feat": false
	},

	"Emboscador": {
		"category": "Furtivo",
		"description": "+1 ataque quando o inimigo estiver surpreso.",
		"effects": {
			"surprise_attack_bonus": 1
		},
		"allowed_classes": ["Ladino"],
		"combat_feat": false
	},

	"Golpe nas Sombras": {
		"category": "Furtivo",
		"description": "+2 dano quando atacar escondido.",
		"effects": {
			"hidden_damage_bonus": 2
		},
		"allowed_classes": ["Ladino"],
		"combat_feat": false
	},

	"Flanqueador": {
		"category": "Furtivo",
		"description": "+1 ataque quando o inimigo estiver flanqueado.",
		"effects": {
			"flanking_attack_bonus": 1
		},
		"allowed_classes": ["Ladino", "Guerreiro", "Ranger"],
		"combat_feat": true
	},

	"Oportunista": {
		"category": "Furtivo",
		"description": "+2 dano contra inimigos flanqueados.",
		"effects": {
			"flanking_damage_bonus": 2
		},
		"allowed_classes": ["Ladino"],
		"combat_feat": false
	},
		"Conjurador Experiente": {
		"category": "Magia",
		"description": "+1 espaço de magia de nível 1.",
		"effects": {
			"extra_spell_slot_level_1": 1
		},
		"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago"],
		"combat_feat": false
	},

	"Magia Potente": {
		"category": "Magia",
		"description": "+2 no dano de magias ofensivas.",
		"effects": {
			"spell_damage_bonus": 2
		},
		"allowed_classes": ["Mago", "Feiticeiro", "Clérigo", "Druida", "Bardo"],
		"combat_feat": false
	},

	"Cura Aprimorada": {
		"category": "Magia",
		"description": "+2 em magias de cura.",
		"effects": {
			"healing_bonus": 2
		},
		"allowed_classes": ["Clérigo", "Druida", "Bardo"],
		"combat_feat": false
	},

	"Alcance Mágico": {
		"category": "Magia",
		"description": "+3m no alcance das magias.",
		"effects": {
			"spell_range_bonus": 3.0
		},
		"allowed_classes": ["Mago", "Feiticeiro", "Bardo", "Clérigo", "Druida"],
		"combat_feat": false
	},

	"Escudo Místico": {
		"category": "Magia",
		"description": "+1 CA enquanto possuir magia ativa futuramente.",
		"effects": {
			"magic_armor_class_bonus": 1
		},
		"allowed_classes": ["Mago", "Feiticeiro", "Bardo"],
		"combat_feat": false
	},

	"Concentração Arcana": {
		"category": "Magia",
		"description": "+2 em testes de concentração futuramente.",
		"effects": {
			"concentration_bonus": 2
		},
		"allowed_classes": ["Mago", "Feiticeiro", "Bardo", "Clérigo", "Druida"],
		"combat_feat": false
	},
	
		"Graça Divina Aprimorada": {
		"category": "Divino",
		"description": "+1 em todos os testes de resistência para Paladino.",
		"effects": {
			"fortitude_bonus": 1,
			"reflex_bonus": 1,
			"will_bonus": 1
		},
		"allowed_classes": ["Paladino"],
		"combat_feat": false
	},

	"Benção Duradoura": {
		"category": "Divino",
		"description": "+1 turno na duração de magias de buff divinas.",
		"effects": {
			"divine_buff_duration_bonus": 1
		},
		"allowed_classes": ["Clérigo", "Paladino"],
		"combat_feat": false
	},

	"Curandeiro Divino": {
		"category": "Divino",
		"description": "+3 em curas divinas.",
		"effects": {
			"divine_healing_bonus": 3
		},
		"allowed_classes": ["Clérigo", "Paladino"],
		"combat_feat": false
	},

	"Julgamento Sagrado": {
		"category": "Divino",
		"description": "+2 ataque contra criaturas malignas futuramente.",
		"effects": {
			"holy_attack_bonus": 2
		},
		"allowed_classes": ["Paladino", "Clérigo"],
		"combat_feat": true
	},
		"Fúria Extra": {
		"category": "Classe",
		"description": "+1 uso de Fúria futuramente.",
		"effects": {
			"extra_rage_use": 1
		},
		"allowed_classes": ["Bárbaro"],
		"combat_feat": false
	},

	"Fúria Poderosa": {
	"category": "Classe",
	"description": "+2 dano enquanto estiver em Fúria.",
	"effects": {
		"rage_damage_bonus": 2
	},
	"requirements": {
		"required_classes": ["Bárbaro"]
	},
	"allowed_classes": ["Bárbaro"],
	"combat_feat": false
},

	"Canção Inspiradora": {
		"category": "Classe",
		"description": "+1 ataque adicional ao usar Inspirar Coragem.",
		"effects": {
			"bardic_attack_bonus": 1
		},
		"allowed_classes": ["Bardo"],
		"combat_feat": false
	},

	"Disciplina Monástica": {
		"category": "Classe",
		"description": "+1 CA para Monge sem armadura.",
		"effects": {
			"monk_armor_class_bonus": 1
		},
		"allowed_classes": ["Monge"],
		"combat_feat": false
	},

	"Punhos Poderosos": {
	"category": "Classe",
	"description": "+2 dano desarmado para Monge.",
	"effects": {
		"unarmed_damage_bonus": 2
	},
	"requirements": {
		"required_classes": ["Monge"]
	},
	"allowed_classes": ["Monge"],
	"combat_feat": true
},

	"Inimigo Predileto": {
		"category": "Classe",
		"description": "+1 ataque e +2 dano contra um tipo de inimigo futuramente.",
		"effects": {
			"favored_enemy_attack_bonus": 1,
			"favored_enemy_damage_bonus": 2
		},
		"allowed_classes": ["Ranger"],
		"combat_feat": true
	}
}


func ensure_expanded_feats() -> void:
	for feat_spec in EXPANDED_GENERAL_FEATS:
		var feat_name: String = str(feat_spec["name"])
		if feats.has(feat_name):
			continue
		feats[feat_name] = {
			"category": "Geral",
			"description": str(feat_spec["description"]),
			"effects": (feat_spec["effects"] as Dictionary).duplicate(true),
			"allowed_classes": [],
			"combat_feat": false,
			"aviant_general": true
		}
	for character_class in EXPANDED_CLASS_FEATS:
		var class_flag: String = str(EXPANDED_CLASS_FLAGS[character_class])
		for feat_spec in EXPANDED_CLASS_FEATS[character_class]:
			var feat_name: String = str(feat_spec["name"])
			if feats.has(feat_name):
				continue
			var effects: Dictionary = (feat_spec["effects"] as Dictionary).duplicate(true)
			var combat_feat: bool = false
			for effect_key in ["attack_bonus", "melee_attack_bonus", "melee_damage_bonus", "ranged_damage_bonus", "rage_damage_bonus", "smite_damage_bonus", "flanking_damage_bonus", "spell_damage_bonus", "spell_save_dc_bonus", "animal_companion_attack_bonus", "animal_companion_damage_bonus"]:
				if effects.has(effect_key):
					combat_feat = true
					break
			var feat_data: Dictionary = {
				"category": character_class,
				"description": str(feat_spec["description"]),
				"effects": effects,
				"requirements": {"min_level": int(feat_spec["min_level"])},
				"allowed_classes": [character_class],
				"combat_feat": combat_feat
			}
			feat_data[class_flag] = true
			feats[feat_name] = feat_data


func ensure_progression_feats() -> void:
	ensure_expanded_feats()
	if feats.has("Fôlego Progressivo 01"):
		return
	for rank in range(1, 31):
		var rank_label: String = "%02d" % rank
		feats["Fôlego Progressivo " + rank_label] = {
			"category": "Progressão",
			"description": "+2 pontos de vida máximos.",
			"effects": {"max_hp_bonus": 2},
			"requirements": {"min_level": maxi(2, rank)},
			"combat_feat": false,
			"aviant_general": true
		}
		feats["Resistência Progressiva " + rank_label] = {
			"category": "Progressão",
			"description": "+1 ponto de vida máximo.",
			"effects": {"max_hp_bonus": 1},
			"requirements": {"min_level": maxi(2, rank)},
			"combat_feat": true,
			"aviant_general": true
		}


func get_feat_data(feat_name: String) -> Dictionary:
	ensure_progression_feats()
	if feats.has(feat_name):
		return feats[feat_name]
	
	return {}


func get_available_feats_for_character(
	character_class: String,
	character_race: String,
	level: int,
	only_combat_feats: bool = false,
	selected_feats: Array = [],
	attributes: Dictionary = {}
) -> Array:
	var result: Array = []
	ensure_progression_feats()
	
	for feat_name in feats.keys():
		var feat_data: Dictionary = feats[feat_name]
		if bool(feat_data.get("aviant_general", false)):
			if only_combat_feats and not bool(feat_data.get("combat_feat", false)):
				continue
			if character_meets_feat_requirements(str(feat_name), character_class, character_race, level, selected_feats, attributes):
				result.append(str(feat_name))
			continue
		if character_class == "Bárbaro" and not bool(feat_data.get("aviant_barbarian", false)):
			continue
		if character_class == "Paladino" and not bool(feat_data.get("aviant_paladin", false)):
			continue
		if character_class == "Druida" and not bool(feat_data.get("aviant_druid", false)):
			continue
		if character_class == "Mago" and not bool(feat_data.get("aviant_wizard", false)):
			continue
		if character_class == "Feiticeiro" and not bool(feat_data.get("aviant_sorcerer", false)):
			continue
		if character_class == "Ladino" and not bool(feat_data.get("aviant_rogue", false)):
			continue
		if character_class == "Ranger" and not bool(feat_data.get("aviant_ranger", false)):
			continue
		if character_class == "Clérigo" and not bool(feat_data.get("aviant_cleric", false)):
			continue
		if character_class == "Bardo" and not bool(feat_data.get("aviant_bard", false)):
			continue
		if character_class == "Guerreiro" and not bool(feat_data.get("aviant_fighter", false)):
			continue
		if character_class == "Bruxo" and not bool(feat_data.get("aviant_warlock", false)):
			continue
		if character_class == "Monge" and not bool(feat_data.get("aviant_monk", false)):
			continue
		
		var is_combat_feat: bool = bool(feat_data.get("combat_feat", false))
		
		if only_combat_feats and not is_combat_feat:
			continue
		
		if not character_meets_feat_requirements(
			str(feat_name),
			character_class,
			character_race,
			level,
			selected_feats,
			attributes
		):
			continue
		
		result.append(str(feat_name))
	
	return result


func get_feat_description(feat_name: String) -> String:
	var feat_data: Dictionary = get_feat_data(feat_name)
	
	if feat_data.is_empty():
		return ""
	
	return str(feat_data.get("description", ""))
func character_meets_feat_requirements(
	feat_name: String,
	character_class: String,
	character_race: String,
	level: int,
	selected_feats: Array = [],
	attributes: Dictionary = {}
) -> bool:
	var feat_data: Dictionary = get_feat_data(feat_name)
	
	if feat_data.is_empty():
		return false
	
	var allowed_classes: Array = feat_data.get("allowed_classes", [])
	
	if not allowed_classes.is_empty():
		if not allowed_classes.has(character_class):
			return false
	
	var requirements: Dictionary = feat_data.get("requirements", {})
	
	if requirements.is_empty():
		return true
	
	if requirements.has("min_level"):
		var min_level: int = int(requirements["min_level"])
		
		if level < min_level:
			return false
	
	if requirements.has("required_race"):
		var required_race: String = str(requirements["required_race"])
		
		if character_race != required_race:
			return false
	
	if requirements.has("required_classes"):
		var required_classes: Array = requirements["required_classes"]
		
		if not required_classes.has(character_class):
			return false
	
	if requirements.has("forbidden_classes"):
		var forbidden_classes: Array = requirements["forbidden_classes"]
		
		if forbidden_classes.has(character_class):
			return false
	
	if requirements.has("min_strength"):
		if int(attributes.get("strength", 10)) < int(requirements["min_strength"]):
			return false
	
	if requirements.has("min_dexterity"):
		if int(attributes.get("dexterity", 10)) < int(requirements["min_dexterity"]):
			return false
	
	if requirements.has("min_constitution"):
		if int(attributes.get("constitution", 10)) < int(requirements["min_constitution"]):
			return false
	
	if requirements.has("min_wisdom"):
		if int(attributes.get("wisdom", 10)) < int(requirements["min_wisdom"]):
			return false
	
	if requirements.has("min_intelligence"):
		if int(attributes.get("intelligence", 10)) < int(requirements["min_intelligence"]):
			return false
	
	if requirements.has("min_charisma"):
		if int(attributes.get("charisma", 10)) < int(requirements["min_charisma"]):
			return false
	
	if requirements.has("required_feat"):
		var required_feat: String = str(requirements["required_feat"])
		
		if not selected_feats.has(required_feat):
			return false
	
	if requirements.has("required_feat_base"):
		var required_feat_base: String = str(requirements["required_feat_base"])
		
		if not has_feat_with_base_name(selected_feats, required_feat_base):
			return false
	
	return true


func has_feat_with_base_name(selected_feats: Array, base_name: String) -> bool:
	for selected_feat in selected_feats:
		var full_feat_name: String = str(selected_feat)
		var selected_base_name: String = full_feat_name
		
		if full_feat_name.contains(":"):
			selected_base_name = full_feat_name.split(":")[0].strip_edges()
		
		if selected_base_name == base_name:
			return true
	
	return false
