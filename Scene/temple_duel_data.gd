extends RefCounted

const NpcDatabase = preload("res://Scene/npc_database.gd")

# Fichas exclusivas do confronto no templo. Não alteram o Hashagur da ponte.
const HASHAGUR_POWERS := [
	{"id": "monk_temple_guard", "name": "Golpe do Guardião", "frequency": "Por encontro", "description": "+2 para acertar e +5 de dano com os punhos. Usa um dos ataques do turno."},
	{"id": "monk_ki_breath", "name": "Fôlego de Ki", "frequency": "Diário", "utility": true, "description": "Recupera 20 PV imediatamente, sem gastar um ataque do turno."}
]

const EBRAMIR_FEATS := [
	{"name": "Previsão de Combate", "effect": "+4 na iniciativa."},
	{"name": "Geometria Arcana", "effect": "+1 na CD das magias."},
	{"name": "Véu da Dúvida", "effect": "+1 adicional na CD das ilusões."},
	{"name": "Condução Refinada", "effect": "+2 de dano mágico."},
	{"name": "Raio Calculado", "effect": "+3 m de alcance mágico."},
	{"name": "Mente Organizada", "effect": "+1 em Vontade."},
	{"name": "Eco Prolongado", "effect": "Ilusões de controle duram até o fim do próximo turno do alvo."}
]

const EBRAMIR_SPELLS := [
	{"name": "Lança Prismática", "level": 3, "kind": "damage", "dice": 3, "die": 6, "range": 15.0},
	{"name": "Névoa de Dúvida", "level": 4, "kind": "illusion", "dice": 0, "die": 0, "range": 15.0},
	{"name": "Estilhaço Arcano", "level": 2, "kind": "damage", "dice": 2, "die": 6, "range": 15.0},
	{"name": "Orbe da Ruptura", "level": 5, "kind": "damage", "dice": 4, "die": 6, "range": 15.0}
]

const GUARDIAN_FEATS := [
	{"name": "Guarda do Altar", "effect": "+1 na defesa com escudo."},
	{"name": "Maça Afinada", "effect": "+1 para acertar com maça."},
	{"name": "Golpe Pesado", "effect": "+2 de dano com maça."},
	{"name": "Quebra-Base", "effect": "Golpes podem derrubar o alvo."},
	{"name": "Postura de Ferro", "effect": "+1 de defesa contra ataques diretos."},
	{"name": "Pressão Implacável", "effect": "Dois ataques por turno no nível 8."},
	{"name": "Golpe Preciso", "effect": "Acertos decisivos também com 19 natural."},
	{"name": "Vontade Tenaz", "effect": "+2 contra efeitos mentais."}
]

const ARCHER_FEATS := [
	{"name": "Mira de Proximidade", "effect": "+1 para acertar e causar dano até 9 m."},
	{"name": "Linha Limpa", "effect": "Sem penalidade por atirar em combate próximo."},
	{"name": "Ritmo de Flechas", "effect": "Dois ataques por turno no nível 8."},
	{"name": "Arco Afinado", "effect": "+1 para acertar com arco."},
	{"name": "Flecha Pesada", "effect": "+2 de dano com arco."},
	{"name": "Disparo Duplo", "effect": "Sequência de disparos contra o mesmo alvo."},
	{"name": "Mira por Cobertura", "effect": "Ignora cobertura parcial."},
	{"name": "Reflexo de Caça", "effect": "Prioriza alvos expostos."}
]


static func get_hashagur_data() -> Dictionary:
	var data: Dictionary = NpcDatabase.get_hashagur().duplicate(true)
	data.merge({
		"level": 10,
		"scenario_only": 4,
		"max_hp": 150, "hp": 150,
		"strength": 18, "dexterity": 18, "constitution": 16,
		"intelligence": 10, "wisdom": 18, "charisma": 10,
		"initiative_bonus": 4, "max_movement_meters": 12.0,
		"armor_class": 23, "touch_armor_class": 23, "flat_footed_armor_class": 19,
		"base_attack_bonus": 7,
		"damage_dice": 8, "damage_dice_count": 2, "damage_bonus": 4,
		"fortitude_bonus": 10, "reflex_bonus": 11, "will_bonus": 11,
		"feats": ["Passo do Guardião", "Punhos Precisos", "Mente de Pedra", "Corpo Temperado"],
		"feat_attack_bonus": 1, "feat_damage_bonus": 2,
		"weapon_focus_name": "Punho", "weapon_focus_attack_bonus": 1,
		"features": ["Três ataques por turno", "Evasão", "Rajada de Golpes", "Golpe do Guardião", "Fôlego de Ki"],
		"portrait_path": "res://Assets/Characters/Hashagur.png"
	}, true)
	return data


static func get_enemy_data(enemy_id: String) -> Dictionary:
	match enemy_id:
		"Ebramir":
			return {
				"id": "Ebramir", "display_name": "Ebramir", "creature_type": "Humanoide",
				"subtype": "Gnomo", "size": "Pequeno", "level": 10,
				"alignment": "Neutro e Bom", "max_hp": 57, "hp": 57,
				"initiative_bonus": 6, "max_movement_meters": 6.0,
				"armor_class": 15, "touch_armor_class": 13, "flat_footed_armor_class": 13,
				"base_attack_bonus": 5, "equipped_weapon": "Adaga de Prata",
				"weapon_type": "melee", "damage_dice": 4, "damage_dice_count": 1,
				"damage_bonus": -1, "weapon_range_meters": 1.5,
				"equipped_armor": "Braçadeiras Arcanas", "equipped_shield": "",
				"strength": 8, "dexterity": 14, "constitution": 16,
				"intelligence": 22, "wisdom": 12, "charisma": 10,
				"fortitude_bonus": 6, "reflex_bonus": 5, "will_bonus": 8,
				"observe_bonus": 4, "hide_bonus": 4,
				"ai_behavior": "temple_boss", "intelligence_score": 22,
				"can_cast_spells": true, "known_spells": ["Lança Prismática", "Névoa de Dúvida", "Estilhaço Arcano", "Orbe da Ruptura"],
				"spellcasting_attribute": "intelligence", "spell_slots": {0: 4, 1: 6, 2: 5, 3: 4, 4: 4, 5: 3},
				"spell_save_dc_base": 17, "illusion_dc_bonus": 1, "spell_damage_bonus": 2,
				"spell_range_bonus": 3.0, "illusion_save_bonus": 2,
				"feats": EBRAMIR_FEATS.duplicate(true), "special_traits": ["gnome_small", "low_light_vision", "temple_mage"],
				"portrait_path": "res://Assets/Characters/Ebramir.png",
				"secondary_attacks": [], "xp_reward": 0, "gold_reward": 0
			}
		"Guardião do Culto":
			return {
				"id": "Guardião do Culto", "display_name": "Guardião do Culto", "creature_type": "Humanoide",
				"subtype": "Cultista", "size": "Médio", "level": 8,
				"max_hp": 72, "hp": 72, "initiative_bonus": 1,
				"max_movement_meters": 6.0, "armor_class": 22,
				"touch_armor_class": 12, "flat_footed_armor_class": 21,
				"base_attack_bonus": 8, "equipped_weapon": "Maça Pesada",
				"weapon_type": "melee", "damage_dice": 8, "damage_dice_count": 1,
				"damage_bonus": 6, "weapon_attack_bonus": 2, "iterative_attack_penalty": 5, "weapon_range_meters": 1.5,
				"critical_threshold": 19, "trip_bonus": 4,
				"equipped_armor": "Meia-Armadura Reforçada", "equipped_shield": "Escudo Pesado de Aço",
				"strength": 18, "dexterity": 12, "constitution": 16,
				"intelligence": 10, "wisdom": 12, "charisma": 8,
				"fortitude_bonus": 9, "reflex_bonus": 3, "will_bonus": 5,
				"ai_behavior": "temple_elite", "intelligence_score": 10,
				"feats": GUARDIAN_FEATS.duplicate(true), "portrait_path": "res://Assets/Characters/Cultista guerreiro.png",
				"special_traits": ["temple_elite", "guardian_trip"], "secondary_attacks": [],
				"xp_reward": 0, "gold_reward": 0
			}
		"Arqueiro do Culto":
			return {
				"id": "Arqueiro do Culto", "display_name": "Arqueiro do Culto", "creature_type": "Humanoide",
				"subtype": "Cultista", "size": "Médio", "level": 8,
				"max_hp": 64, "hp": 64, "initiative_bonus": 4,
				"max_movement_meters": 9.0, "armor_class": 19,
				"touch_armor_class": 15, "flat_footed_armor_class": 15,
				"base_attack_bonus": 8, "equipped_weapon": "Arco Longo Composto",
				"weapon_type": "ranged", "damage_dice": 8, "damage_dice_count": 1,
				"damage_bonus": 4, "weapon_attack_bonus": 2, "iterative_attack_penalty": 5, "weapon_range_meters": 18.0,
				"equipped_armor": "Camisão de Malha Reforçado", "equipped_shield": "",
				"strength": 14, "dexterity": 19, "constitution": 14,
				"intelligence": 10, "wisdom": 12, "charisma": 8,
				"fortitude_bonus": 8, "reflex_bonus": 6, "will_bonus": 3,
				"ai_behavior": "ranged", "intelligence_score": 10,
				"feats": ARCHER_FEATS.duplicate(true), "portrait_path": "res://Assets/Characters/Arqueiro cultista.png",
				"special_traits": ["temple_elite", "near_shot_bonus"], "secondary_attacks": [],
				"xp_reward": 0, "gold_reward": 0
			}
	return {}
