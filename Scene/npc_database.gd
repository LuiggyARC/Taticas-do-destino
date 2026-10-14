extends Node


static func get_npc_data(
	npc_id: String
) -> Dictionary:
	match npc_id:
		"Guarda Aliado":
			return get_guard_ally()
		
		"Guarda da Ponte":
			return get_bridge_guard()
		
		"Jhon":
			return get_jhon()
		
		"Sr Uiliam":
			return get_sr_uiliam()
		
		"Aniri":
			return get_aniri()
		
		"Hashagur":
			return get_hashagur()

		"Kasum":
			return get_kasum()
		
		_:
			print(
				"NPC não encontrado no NpcDatabase: ",
				npc_id
			)
			
			return {}


static func get_guard_ally() -> Dictionary:
	return {
		"id": "Guarda Aliado",
		"display_name": "Soldado Ferido",
		"description": "Um soldado ferido tentando alcançar o grupo.",
		
		"faction": "ally",
		"control_type": "ai",
		
		"max_hp": 16,
		"hp": 2,
		
		"armor_class": 10,
		"touch_armor_class": 11,
		"flat_footed_armor_class": 11,
		
		"max_movement_meters": 3.0,
		"initiative_bonus": 1,
		
		"strength": 12,
		"dexterity": 11,
		"constitution": 12,
		"intelligence": 10,
		"wisdom": 10,
		"charisma": 9,
		
		"base_attack_bonus": 1,
		
		"equipped_weapon": "Lança Curta",
		"weapon_type": "melee",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"damage_bonus": 1,
		"weapon_range_meters": 1.5,
		
		"ai_behavior": "follow_hero",
		
		"dialogue_intro": "Preciso chegar até vocês!",
		"dialogue_low_hp": "Não vou aguentar muito tempo!",
		"dialogue_victory": "Conseguimos..."
	}
static func get_bridge_guard() -> Dictionary:
	return {
		"id": "Guarda da Ponte",
		"display_name": "Guarda da Vila",
		"description": (
			"Um guarda enviado para proteger Jhon "
			+ "durante o reparo da Ponte da Esmeralda."
		),
		
		"race": "Humano",
		"character_class": "Guerreiro",
		"level": 1,
		
		"faction": "ally",
		"control_type": "ai",
		
		"max_hp": 16,
		"hp": 16,
		
		"initiative_bonus": 1,
		"max_movement_meters": 6.0,
		
		"armor_class": 15,
		"touch_armor_class": 11,
		"flat_footed_armor_class": 14,
		
		"equipped_armor": "Cota de Escamas",
		"equipped_shield": "Escudo Leve",
		
		"base_attack_bonus": 2,
		
		"equipped_weapon": "Espada Longa",
		"weapon_type": "melee",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"damage_bonus": 0,
		"weapon_range_meters": 1.5,
		
		"strength": 14,
		"dexterity": 12,
		"constitution": 14,
		"intelligence": 10,
		"wisdom": 11,
		"charisma": 10,
		
		"fortitude_bonus": 4,
		"reflex_bonus": 1,
		"will_bonus": 1,
		"observe_bonus": 2,
		
		"ai_behavior": "protect_jhon",
		"protected_npc_id": "Jhon",
		"protection_radius_meters": 1.5,
		"can_leave_guard_position": false,
		
		"dialogue_intro": (
			"Protejam o carpinteiro!"
		),
		"dialogue_low_hp": (
			"Não deixem que alcancem Jhon!"
		),
		"dialogue_victory": (
			"A estrada está segura."
		)
	}


static func get_jhon() -> Dictionary:
	return {
		"id": "Jhon",
		"display_name": "Jhon",
		"description": (
			"O carpinteiro da vila, enviado para "
			+ "reconstruir a Ponte da Esmeralda."
		),
		
		"race": "Humano",
		"character_class": "Plebeu",
		"level": 1,
		
		"faction": "ally",
		"control_type": "passive",
		
		"max_hp": 12,
		"hp": 12,
		
		"initiative_bonus": 0,
		"max_movement_meters": 6.0,
		
		"armor_class": 12,
		"touch_armor_class": 10,
		"flat_footed_armor_class": 12,
		
		"equipped_armor": "Roupas de Trabalho",
		"equipped_shield": "Nenhum",
		
		"base_attack_bonus": 0,
		
		"equipped_weapon": "Ferramentas de Carpinteiro",
		"weapon_type": "melee",
		"damage_dice": 3,
		"damage_dice_count": 1,
		"damage_bonus": 0,
		"weapon_range_meters": 1.5,
		
		"strength": 12,
		"dexterity": 10,
		"constitution": 12,
		"intelligence": 13,
		"wisdom": 11,
		"charisma": 10,
		
		"fortitude_bonus": 1,
		"reflex_bonus": 0,
		"will_bonus": 0,
		"observe_bonus": 1,
		
		"ai_behavior": "protected_passive",
		
		"dialogue_intro": (
			"Os reparos terão de esperar!"
		),
		"dialogue_low_hp": (
			"Não deixem essas criaturas se aproximarem!"
		),
		"dialogue_victory": (
			"Agora talvez eu consiga trabalhar em paz."
		)
	}

static func get_sr_uiliam() -> Dictionary:
	return {
		"id": "Sr Uiliam",
		"display_name": "Sir Uiliam",
		"description": "Um paladino humano que chega ao campo de batalha para ajudar o grupo.",
		
		"race": "Humano",
		"character_class": "Paladino",
		"level": 2,
		
		"faction": "ally",
		"control_type": "player",
		
		"max_hp": 23,
		"hp": 23,
		
		"initiative_bonus": 1,
		"max_movement_meters": 6.0,
		
		"armor_class": 18,
		"touch_armor_class": 11,
		"flat_footed_armor_class": 17,
		
		"equipped_armor": "Peitoral de aço",
		"equipped_shield": "Escudo Pesado",
		
		"base_attack_bonus": 3,
		
		"equipped_weapon": "Espada Longa",
		"weapon_type": "melee",
		"damage_dice": 8,
		"damage_dice_count": 1,
		"damage_bonus": 2,
		"weapon_range_meters": 1.5,
		
		"strength": 14,
		"dexterity": 12,
		"constitution": 14,
		"intelligence": 10,
		"wisdom": 10,
		"charisma": 16,
		
		"fortitude_bonus": 2,
		"reflex_bonus": 2,
		"will_bonus": 2,
		"observe_bonus": 3,
		
		"feats": [
			"Lâmina da Ordem",
			"Defesa Juramentada"
		],
		
		"feat_attack_bonus": 0,
		"feat_damage_bonus": 0,
		"weapon_focus_name": "",
		"weapon_focus_attack_bonus": 0,
		
		"ai_behavior": "defensive",
		
	}

static func has_npc(npc_id: String) -> bool:
	return not get_npc_data(npc_id).is_empty()
static func get_aniri() -> Dictionary:
	return {
		"id": "Aniri",
		"display_name": "Aniri",
		"description": (
			"Uma halfling experiente que decidiu abandonar "
			+ "a segurança da vila para se tornar aventureira."
		),

		"race": "Halfling",
		"character_class": "Ladino",
		"level": 3,

		"faction": "ally",
		"control_type": "player",

		"size": "Pequeno",
		"size_modifier": 0,
		"favored_class": "Qualquer",

		# Nível 3 começa em 2.500 XP:
		# nível 2 = 1.000;
		# nível 3 = 2.500.
		"total_xp": 2500,
		"xp_to_next_level": 2250,
		"pending_level_ups": 0,

		"max_hp": 18,
		"hp": 18,

		# CA:
		# 10 base
		# +2 Gibão de Peles
		# +4 Destreza
		# +1 Broquel
		"armor_class": 17,

		# CA de toque:
		# 10 +4 Destreza
		"touch_armor_class": 14,

		# Surpresa:
		# 10 +2 armadura +1 Broquel
		"flat_footed_armor_class": 13,

		"initiative_bonus": 8,
		"max_movement_meters": 9.0,

		"strength": 14,
		"dexterity": 18,
		"constitution": 10,
		"intelligence": 10,
		"wisdom": 10,
		"charisma": 10,

		"base_attack_bonus": 3,

		"equipped_weapon": "Espada Curta",
		"equipped_armor": "Gibão de Peles",
		"equipped_shield": "Broquel",

		"weapon_type": "melee",
		"damage_dice": 6,
		"damage_dice_count": 1,
		"damage_bonus": 2,
		"weapon_range_meters": 1.5,

		# Valores básicos de Ladino no nível 3.
		"fortitude_base_bonus": 1,
		"reflex_base_bonus": 3,
		"will_base_bonus": 1,

		"racial_save_bonus": 0,

		# Valores finais usados durante o combate.
		"fortitude_bonus": 1,
		"reflex_bonus": 3,
		"will_bonus": 1,

		"observe_bonus": 4,
		"hide_bonus": 2,

		"skills": {
			"observe": 4,
			"hide": 4
		},

		"feats": [
			"Passos de Veludo",
			"Olho para Brechas"
		],

		"feat_attack_bonus": 0,
		"feat_damage_bonus": 0,

		"weapon_focus_name": "Espada Curta",
		"weapon_focus_attack_bonus": 0,

		"race_traits": [
			"+2 Destreza ou Sabedoria (Destreza escolhida)",
			"Golpe Sujo: +1 de dano contra inimigos flanqueados"
		],

		"class_features": [
			"Dado de Vida d8; vida fixa +5 por nível",
			"Ataque com armas médio; Reflexos fortes",
			"Ataque Furtivo +2d6",
			"Passo Oculto (sem limite)",
			"Brecha Calculada (por encontro)",
			"Corte Decisivo (diário)"
		],

		"features": [
			"Tamanho Pequeno",
			"Ataque Furtivo +2d6",
			"Passo Oculto (sem limite)",
			"Brecha Calculada (por encontro)",
			"Corte Decisivo (diário)"
		],

		"sneak_attack_dice": 2,
		"trapfinding": true,
		"evasion": true,
		"trap_sense_bonus": 1,

		"ai_behavior": "rogue",

		"dialogue_intro": "",
		"dialogue_low_hp": (
			"Estou começando a questionar minhas escolhas!"
		),
		"dialogue_victory": (
			"Viu? Eu disse que conseguiria."
		)
	}
static func get_kasum() -> Dictionary:
	return {
		"id": "Kasum",
		"display_name": "Kasum",
		"description": "Mercenário bárbaro que escolta comerciantes pela Ponte da Esmeralda.",
		"race": "Humano",
		"character_class": "Bárbaro",
		"level": 3,
		"faction": "ally",
		"control_type": "passive",
		"size": "Médio",
		"size_modifier": 0,
		"favored_class": "Qualquer",
		"hit_die": 12,
		"fixed_hp_per_level": 8,
		# d12 + CON no 1º nível; +8 + CON nos níveis 2 e 3.
		"max_hp": 34,
		"hp": 34,
		"initiative_bonus": 1,
		# Humano 9 m + movimento bárbaro 3 m + progressão do nível 3 (1,5 m).
		"max_movement_meters": 13.5,
		# CA 10 +1 armadura acolchoada +1 Destreza.
		"armor_class": 12,
		"touch_armor_class": 11,
		"flat_footed_armor_class": 11,
		"equipped_armor": "Armadura Acolchoada",
		"equipped_shield": "Nenhum",
		"base_attack_bonus": 3,
		"equipped_weapon": "Machado de Batalha",
		"weapon_type": "melee",
		"damage_dice": 12,
		"damage_dice_count": 1,
		"damage_bonus": 4,
		"weapon_range_meters": 1.5,
		"strength": 18,
		"dexterity": 12,
		"constitution": 14,
		"intelligence": 8,
		"wisdom": 8,
		"charisma": 8,
		# Valores finais: progressão da classe, bônus bárbaro e atributos.
		"fortitude_base_bonus": 3,
		"reflex_base_bonus": 3,
		"will_base_bonus": 1,
		"fortitude_bonus": 5,
		"reflex_bonus": 4,
		"will_bonus": 0,
		"observe_bonus": 0,
		"hide_bonus": 0,
		"skills": {
			"observe": 0,
			"hide": 0
		},
		"feats": [
			"Precisão Selvagem",
			"Força Implacável",
			"Golpe Pesado"
		],
		# Mantém o resultado anterior: +1 e -1 para acertar, +4 dano.
		"feat_attack_bonus": 0,
		"feat_damage_bonus": 4,
		"weapon_focus_name": "",
		"weapon_focus_attack_bonus": 0,
		"race_traits": [
			"Rápida Aprendizagem: +2 em um atributo à escolha (já incluído na ficha)",
			"1 talento inicial extra"
		],
		"class_features": [
			"Dado de Vida d12",
			"BBA alto",
			"Fortitude boa",
			"Fúria",
			"Movimento Rápido: +3 m",
			"Reflexos: +2"
		],
		"features": [
			"Fúria",
			"Movimento Rápido: +3 m",
			"Reflexos: +2"
		],
		"ai_behavior": "passive"
	}


static func get_hashagur() -> Dictionary:
	return {
		"id": "Hashagur",
		"display_name": "Hashagur",
		"description": (
			"Um monge meio-orc e protetor de um "
			+ "templo localizado nas montanhas."
		),
		
		"race": "Meio-Orc",
		"character_class": "Monge",
		"level": 5,
		
		# Hashagur participa somente do cenário 3.
		"faction": "ally",
		"control_type": "player",
		"temporary_party_member": true,
		"scenario_only": 3,
		
		"size": "Médio",
		"size_modifier": 0,
		"favored_class": "Monge",
		
		"max_hp": 32,
		"hp": 32,
		
		"initiative_bonus": 4,
		"max_movement_meters": 9.0,
		
		# Monge sem armadura.
		"armor_class": 18,
		"touch_armor_class": 18,
		"flat_footed_armor_class": 16,
		
		"equipped_armor": "Nenhuma",
		"equipped_shield": "Nenhum",
		
		"base_attack_bonus": 3,
		
		"equipped_weapon": "Punho",
		"weapon_type": "melee",
		
		# Ataque desarmado de Monge nível 5.
		"damage_dice": 8,
		"damage_dice_count": 1,
		
		# +2 de Força.
		"damage_bonus": 2,
		
		"weapon_range_meters": 1.5,
		
		"strength": 14,
		"dexterity": 14,
		"constitution": 10,
		"intelligence": 10,
		"wisdom": 16,
		"charisma": 10,
		
		"fortitude_bonus": 3,
		"reflex_bonus": 3,
		"will_bonus": 3,
		
		"observe_bonus": 4,
		"hide_bonus": 4,
		
		"skills": {
			"observe": 4,
			"hide": 4
		},
		
		"feats": [
			"Foco em Arma: Punho",
			"Especialização em Arma: Punho",
			"Esquiva Aprimorada"
		],
		
		# A Especialização acrescenta +2 ao dano.
		# O dano total será 1d8 +2 Força +2 Especialização.
		"feat_attack_bonus": 0,
		"feat_damage_bonus": 2,
		
		# Foco em Arma concede +1 no ataque.
		"weapon_focus_name": "Punho",
		"weapon_focus_attack_bonus": 1,
		
		"race_traits": [
			"+2 Força, Destreza ou Constituição (Força escolhida)",
			"Imparável: ao cair a 0 PV, age por mais um turno com +1 nas resistências e +2 de dano"
		],
		
		"class_features": [
			"Dado de Vida d8",
			"BBA médio",
			"Fortitude boa",
			"Reflexos bons",
			"Vontade boa",
			"Bônus de CA sem armadura",
			"Rajada de Golpes",
			"Ataque Desarmado Aprimorado",
			"Evasão",
			"Movimento Rápido",
			"Mente Tranquila",
			"Golpe Ki: Mágico",
			"Queda Suave",
			"Pureza Corporal"
		],
		
		"features": [
			"Ataque desarmado 1d8",
			"Rajada de Golpes",
			"Evasão",
			"Movimento Rápido",
			"Golpe Ki: Mágico",
			"Pureza Corporal"
		],
		
		"improved_evasion": true,
		"unarmed_strike": true,
		"flurry_of_blows": true,
		"ki_strike_magic": true,
		
		"ai_behavior": "monk_aggressive",
		
		# As falas serão controladas pelo evento da rodada 3.
		"dialogue_intro": "",
		"dialogue_low_hp": "",
		"dialogue_victory": ""
	}
