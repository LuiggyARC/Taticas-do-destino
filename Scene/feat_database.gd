extends Node

var feats := {
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
	"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago", "Paladino", "Ranger"],
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
	"allowed_classes": ["Bardo", "Clérigo", "Druida", "Feiticeiro", "Mago", "Paladino", "Ranger"],
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
		"allowed_classes": ["Clérigo", "Druida", "Bardo", "Paladino", "Ranger"],
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


func get_feat_data(feat_name: String) -> Dictionary:
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
	
	for feat_name in feats.keys():
		var feat_data: Dictionary = feats[feat_name]
		
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
