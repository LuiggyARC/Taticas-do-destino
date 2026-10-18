extends Node

var spells := {
	"Curar Ferimentos Leves": {
		"level": 1,
		"classes": ["Clérigo", "Druida", "Bardo"],
		"description": "Recupera vida dos aliados em uma pequena área.",
		"effect": "heal",
		"spell_type": "heal",
		"type": "heal",
		"target": "ally",
		"range_meters": 6.0,
		"area_radius": 1,
		"value_dice": 8,
		"value_dice_count": 1,
		"flat_bonus": 1
	},

	"Mísseis Mágicos": {
		"level": 1,
		"classes": ["Mago", "Feiticeiro"],
		"description": "Causa dano mágico aos inimigos em uma pequena área.",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 12.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 1,
		"flat_bonus": 1
	},

	"Pulso Sonoro": {
		"level": 0,
		"classes": ["Bardo", "Feiticeiro"],
		"description": "Uma onda sonora causa 1d4 de dano aos inimigos próximos ao alvo.",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"is_area": true,
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 1,
		"flat_bonus": 0
	},

	"Selo de Lentidão": {
		"level": 0,
		"classes": ["Mago"],
		"description": "Reduz em 3 m o movimento de um inimigo por 2 turnos.",
		"effect": "control",
		"spell_type": "control",
		"type": "control",
		"target": "enemy",
		"range_meters": 9.0,
		"area_radius": 0,
		"attack_penalty": 0,
		"armor_penalty": 0,
		"movement_penalty": 3.0,
		"duration": 2
	},

	"Prisão Arcana": {
		"level": 1,
		"classes": ["Mago"],
		"description": "Limita o movimento de um inimigo em 4,5 m e reduz sua CA em 1 por 2 turnos.",
		"effect": "control",
		"spell_type": "control",
		"type": "control",
		"target": "enemy",
		"range_meters": 12.0,
		"area_radius": 0,
		"attack_penalty": 0,
		"armor_penalty": 1,
		"movement_penalty": 4.5,
		"duration": 2
	},

	"Explosão de Brasas": {
		"level": 1,
		"classes": ["Feiticeiro"],
		"description": "Explode em uma pequena área e causa 2d4 de dano de fogo. Recebe o bônus de dano do Feiticeiro.",
		"visual_kind": "fire",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"is_area": true,
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 2,
		"flat_bonus": 0
	},

	"Inspirar Coragem": {
		"level": 0,
		"classes": ["Bardo"],
		"description": "Aumenta ataque e dano do conjurador por alguns turnos.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 1,
		"damage_bonus": 1,
		"armor_bonus": 0,
		"movement_bonus": 0.0,
		"duration": 3
	},

	"Raio de Gelo": {
		"level": 0,
		"classes": ["Mago", "Feiticeiro"],
		"description": "Causa dano frio leve aos inimigos em uma pequena área.",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 3,
		"value_dice_count": 1,
		"flat_bonus": 0
	},

	"Benção": {
		"level": 1,
		"classes": ["Clérigo"],
		"description": "Concede bônus de ataque ao conjurador temporariamente.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 1,
		"damage_bonus": 0,
		"armor_bonus": 0,
		"movement_bonus": 0.0,
		"duration": 3
	},

	"Chama Sagrada": {
		"level": 1,
		"classes": ["Clérigo"],
		"description": "Causa dano sagrado aos inimigos em uma pequena área.",
		"visual_kind": "light",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 12.0,
		"area_radius": 1,
		"value_dice": 6,
		"value_dice_count": 1,
		"flat_bonus": 0
	},

	"Enredar": {
	"level": 1,
	"classes": ["Druida"],
	"description": "Reduz o movimento dos inimigos em uma área.",
	"effect": "control",
	"spell_type": "control",
	"type": "control",
	"target": "enemy",
	"is_area": true,
	"range_meters": 12.0,
	"area_radius": 1,
	"value_dice": 0,
	"value_dice_count": 0,
	"flat_bonus": 0,
	"attack_penalty": 0,
	"armor_penalty": 0,
	"movement_penalty": 3.0,
	"duration": 2,
	"save_dc": 12
},

	"Toque Chocante": {
		"level": 1,
		"classes": ["Mago", "Feiticeiro"],
		"description": "Causa dano elétrico em inimigos próximos.",
		"visual_kind": "energy",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 1.5,
		"area_radius": 1,
		"value_dice": 6,
		"value_dice_count": 1,
		"flat_bonus": 0
	},

	"Mãos Flamejantes": {
		"level": 1,
		"classes": ["Mago", "Feiticeiro"],
		"description": "Causa dano de fogo em curta distância.",
		"visual_kind": "fire",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"is_area": true,
		"range_meters": 4.5,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 2,
		"flat_bonus": 0
	},

	"Armadura Arcana": {
		"level": 1,
		"classes": ["Mago", "Feiticeiro"],
		"description": "Cria uma proteção mágica que aumenta a CA temporariamente.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 4,
		"movement_bonus": 0.0,
		"duration": 5
	},

	"Escudo Arcano": {
		"level": 1,
		"classes": ["Mago", "Feiticeiro"],
		"description": "Cria um escudo mágico temporário.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 4,
		"movement_bonus": 0.0,
		"duration": 2
	},

	"Sono": {
	"level": 1,
	"classes": ["Bardo", "Mago", "Feiticeiro"],
	"description": "Tenta colocar inimigos em sono mágico dentro de uma pequena área.",
	"effect": "control",
	"spell_type": "control",
	"type": "control",
	"target": "enemy",
	"is_area": true,
	"range_meters": 12.0,
	"area_radius": 1,
	"value_dice": 0,
	"value_dice_count": 0,
	"flat_bonus": 0,
	"attack_penalty": 3,
	"armor_penalty": 0,
	"movement_penalty": 3.0,
	"duration": 2,
	"save_dc": 13
},

	"Riso Horrível": {
		"level": 1,
		"classes": ["Bardo", "Mago"],
		"description": "Faz inimigos próximos perderem o controle por um turno.",
		"effect": "control",
		"spell_type": "control",
		"type": "control",
		"target": "enemy",
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 0,
		"value_dice_count": 0,
		"flat_bonus": 0,
		"attack_penalty": 2,
		"armor_penalty": 1,
		"movement_penalty": 0.0,
		"duration": 1
	},

	"Estilhaços Arcanos": {
		"level": 2,
		"classes": ["Mago"],
		"description": "Fragmentos de energia atingem inimigos em uma pequena área, causando 3d6 de dano mágico.",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"is_area": true,
		"range_meters": 12.0,
		"area_radius": 1,
		"value_dice": 6,
		"value_dice_count": 3,
		"flat_bonus": 0
	},

	"Barreira de Runas": {
		"level": 2,
		"classes": ["Mago"],
		"description": "Runas defensivas concedem +3 de CA ao conjurador por 4 turnos.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 3,
		"movement_bonus": 0.0,
		"duration": 4
	},

	"Curar Ferimentos Moderados": {
		"level": 2,
		"classes": ["Bardo", "Clérigo", "Druida"],
		"description": "Cura uma quantidade moderada de HP dos aliados em uma pequena área.",
		"effect": "heal",
		"spell_type": "heal",
		"type": "heal",
		"target": "ally",
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 8,
		"value_dice_count": 2,
		"flat_bonus": 2
	},

	"Chuva de Brasas": {
		"level": 2,
		"classes": ["Feiticeiro"],
		"description": "Fagulhas caem sobre uma pequena área e causam 3d4 de dano de fogo.",
		"visual_kind": "fire",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"is_area": true,
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 3,
		"flat_bonus": 0
	},

	"Manto de Fagulhas": {
		"level": 2,
		"classes": ["Feiticeiro"],
		"description": "Uma barreira de fagulhas protege o conjurador e concede +3 de CA por 4 turnos.",
		"visual_kind": "fire",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 3,
		"movement_bonus": 0.0,
		"duration": 4
	},

	"Eco Desconcertante": {
		"level": 2,
		"classes": ["Bardo"],
		"description": "Um acorde dissonante reduz em 2 o ataque e a CA e em 3 m o movimento de inimigos em uma pequena área por 2 turnos.",
		"effect": "control",
		"spell_type": "control",
		"type": "control",
		"target": "enemy",
		"is_area": true,
		"range_meters": 9.0,
		"area_radius": 1,
		"attack_penalty": 2,
		"armor_penalty": 2,
		"movement_penalty": 3.0,
		"duration": 2
	},

	"Benção Maior": {
		"level": 1,
		"classes": ["Clérigo"],
		"description": "Aumenta a chance de acerto do conjurador temporariamente.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 2,
		"damage_bonus": 0,
		"armor_bonus": 0,
		"movement_bonus": 0.0,
		"duration": 3
	},

	"Escudo da Fé": {
		"level": 1,
		"classes": ["Clérigo"],
		"description": "Concede proteção divina temporária ao conjurador.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 2,
		"movement_bonus": 0.0,
		"duration": 4
	},

	"Infligir Ferimentos Leves": {
		"level": 1,
		"classes": ["Clérigo"],
		"description": "Causa dano sombrio em inimigos próximos.",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 1.5,
		"area_radius": 1,
		"value_dice": 8,
		"value_dice_count": 1,
		"flat_bonus": 1
	},

	"Luz Sagrada": {
		"level": 0,
		"classes": ["Clérigo"],
		"description": "Causa pequeno dano sagrado aos inimigos em uma pequena área.",
		"visual_kind": "light",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 1,
		"flat_bonus": 0
	},

	"Orientação": {
		"level": 0,
		"classes": ["Clérigo", "Druida"],
		"description": "Concede um pequeno bônus temporário ao conjurador.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 1,
		"damage_bonus": 0,
		"armor_bonus": 0,
		"movement_bonus": 0.0,
		"duration": 1
	},

	"Cura Menor": {
		"level": 0,
		"classes": ["Clérigo", "Druida", "Bardo"],
		"description": "Recupera uma pequena quantidade de vida dos aliados em uma pequena área.",
		"effect": "heal",
		"spell_type": "heal",
		"type": "heal",
		"target": "ally",
		"range_meters": 6.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 1,
		"flat_bonus": 1
	},

	"Pele de Carvalho": {
		"level": 2,
		"classes": ["Druida"],
		"description": "Endurece a pele do conjurador, aumentando sua defesa.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 2,
		"movement_bonus": 0.0,
		"duration": 4
	},

	"Chama Produzida": {
		"level": 1,
		"classes": ["Druida"],
		"description": "Causa dano de fogo natural aos inimigos em uma pequena área.",
		"visual_kind": "fire",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 6,
		"value_dice_count": 1,
		"flat_bonus": 0
	},

	"Espinhos": {
		"level": 1,
		"classes": ["Druida"],
		"description": "Cria espinhos no terreno e reduz o movimento dos inimigos na área.",
		"effect": "control",
		"spell_type": "control",
		"type": "control",
		"target": "enemy",
		"is_area": true,
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 0,
		"value_dice_count": 0,
		"flat_bonus": 0,
		"attack_penalty": 0,
		"armor_penalty": 0,
		"movement_penalty": 3.0,
		"duration": 2
	},

	"Palavra Curativa": {
		"level": 1,
		"classes": ["Bardo", "Clérigo"],
		"description": "Cura rapidamente uma pequena quantidade de HP dos aliados em uma pequena área.",
		"effect": "heal",
		"spell_type": "heal",
		"type": "heal",
		"target": "ally",
		"range_meters": 12.0,
		"area_radius": 1,
		"value_dice": 6,
		"value_dice_count": 1,
		"flat_bonus": 1
	},

	"Canção de Proteção": {
		"level": 0,
		"classes": ["Bardo"],
		"description": "Uma canção defensiva que aumenta levemente a CA do Bardo.",
		"effect": "buff",
		"spell_type": "buff",
		"type": "buff",
		"target": "self",
		"range_meters": 0.0,
		"area_radius": 0,
		"attack_bonus": 0,
		"damage_bonus": 0,
		"armor_bonus": 1,
		"movement_bonus": 0.0,
		"duration": 3
	},

	"Canção Cortante": {
		"level": 0,
		"classes": ["Bardo"],
		"description": "Uma nota mágica que causa dano sonoro leve aos inimigos em uma pequena área.",
		"effect": "damage",
		"spell_type": "damage",
		"type": "damage",
		"target": "enemy",
		"range_meters": 9.0,
		"area_radius": 1,
		"value_dice": 4,
		"value_dice_count": 1,
		"flat_bonus": 0
	}
}


func get_spells_for_class(class_name_value: String) -> Array:
	var result: Array = []
	
	for spell_name in spells.keys():
		var spell_data: Dictionary = spells[spell_name]
		var allowed_classes: Array = spell_data.get("classes", [])
		
		if allowed_classes.has(class_name_value):
			result.append(spell_name)
	
	return result


func get_spell_data(spell_name: String) -> Dictionary:
	if not spells.has(spell_name):
		return {}
	
	var spell_data: Dictionary = spells[spell_name].duplicate(true)
	
	if not spell_data.has("effect"):
		if spell_data.has("spell_type"):
			spell_data["effect"] = spell_data["spell_type"]
		elif spell_data.has("type"):
			spell_data["effect"] = spell_data["type"]
	
	if not spell_data.has("spell_type"):
		if spell_data.has("effect"):
			spell_data["spell_type"] = spell_data["effect"]
		elif spell_data.has("type"):
			spell_data["spell_type"] = spell_data["type"]
	
	if not spell_data.has("type"):
		if spell_data.has("effect"):
			spell_data["type"] = spell_data["effect"]
		elif spell_data.has("spell_type"):
			spell_data["type"] = spell_data["spell_type"]
	
	return spell_data
	
func validate_spells():
	print("====================================")
	print("VALIDANDO MAGIAS")
	print("====================================")
	
	for spell_name in spells.keys():
		var spell_data: Dictionary = spells[spell_name]
		var has_error: bool = false
		
		if not spell_data.has("level"):
			print("ERRO: ", spell_name, " não possui level.")
			has_error = true
		
		if not spell_data.has("classes"):
			print("ERRO: ", spell_name, " não possui classes.")
			has_error = true
		
		if not spell_data.has("description"):
			print("ERRO: ", spell_name, " não possui description.")
			has_error = true
		
		if not spell_data.has("effect"):
			print("ERRO: ", spell_name, " não possui effect.")
			has_error = true
		
		if not spell_data.has("spell_type"):
			print("ERRO: ", spell_name, " não possui spell_type.")
			has_error = true
		
		if not spell_data.has("type"):
			print("ERRO: ", spell_name, " não possui type.")
			has_error = true
		if not spell_data.has("range_meters"):
			print("AVISO: ", spell_name, " não possui range_meters. Será usado alcance padrão.")
	
		var effect: String = str(spell_data.get("effect", ""))
		var spell_type: String = str(spell_data.get("spell_type", ""))
		var type_value: String = str(spell_data.get("type", ""))
		
		var valid_types: Array = ["heal", "damage", "utility", "buff", "control"]
		
		if not valid_types.has(effect):
			print("ERRO: ", spell_name, " possui effect inválido: ", effect)
			has_error = true
		
		if not valid_types.has(spell_type):
			print("ERRO: ", spell_name, " possui spell_type inválido: ", spell_type)
			has_error = true
		
		if not valid_types.has(type_value):
			print("ERRO: ", spell_name, " possui type inválido: ", type_value)
			has_error = true
		
		if effect != spell_type:
			print("AVISO: ", spell_name, " tem effect diferente de spell_type.")
			print("effect: ", effect, " | spell_type: ", spell_type)
		
		if effect != type_value:
			print("AVISO: ", spell_name, " tem effect diferente de type.")
			print("effect: ", effect, " | type: ", type_value)
		
		if not has_error:
			print("OK: ", spell_name)
	
	print("====================================")
	print("VALIDAÇÃO DE MAGIAS FINALIZADA")
	print("====================================")
