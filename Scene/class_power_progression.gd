extends RefCounted
class_name ClassPowerProgression

const LevelProgressionData = preload("res://Scene/level_progression.gd")

# Poderes originais de Aviant. Os nomes e o efeito-base variam por classe;
# a revisão fina de equilíbrio e trilhas pode ser feita sem alterar os marcos.
const CLASS_STYLE := {
	"Bárbaro": {"key": "barbarian", "attack": "Ímpeto Selvagem", "alternate_attack": "Fúria Certeira", "utility": "Passo Indomável", "alternate_utility": "Salto Brutal", "mode": "weapon"},
	"Bruxo": {"key": "warlock", "attack": "Selo Crepuscular", "alternate_attack": "Olhar da Ruína", "utility": "Passagem Sombria", "alternate_utility": "Fenda Breve", "mode": "magic", "ability": "charisma"},
	"Guerreiro": {"key": "fighter", "attack": "Linha de Ferro", "alternate_attack": "Golpe Calculado", "utility": "Passo de Guarda", "alternate_utility": "Avanço Firme", "mode": "weapon"},
	"Ladino": {"key": "rogue", "attack": "Brecha Veloz", "alternate_attack": "Lâmina Oculta", "utility": "Passo de Sombra", "alternate_utility": "Esquiva Veloz", "mode": "weapon"},
	"Monge": {"key": "monk", "attack": "Punho Fluente", "alternate_attack": "Golpe Sereno", "utility": "Passo Sereno", "alternate_utility": "Voo Breve", "mode": "weapon"},
	"Paladino": {"key": "paladin", "attack": "Lâmina Radiante", "alternate_attack": "Juramento Certeiro", "utility": "Luz Renovadora", "alternate_utility": "Marcha Sagrada", "mode": "weapon"},
	"Ranger": {"key": "ranger", "attack": "Disparo Errante", "alternate_attack": "Flecha Guiada", "utility": "Passo da Trilha", "alternate_utility": "Marcha Silvestre", "mode": "weapon"}
}


static func has_class(character_class: String) -> bool:
	return CLASS_STYLE.has(character_class)


static func is_progression_power(power_id: String) -> bool:
	return power_id.begins_with("progression_")


static func get_new_power_for_level(character_class: String, level: int) -> Dictionary:
	if not has_class(character_class):
		return {}
	var frequency: String = ""
	var utility: bool = false
	if level == 1:
		frequency = "Sem limite"
	elif level in LevelProgressionData.UTILITY_LEVELS:
		frequency = "Por encontro" if level < 12 else "Diário"
		utility = true
	elif level in LevelProgressionData.ENCOUNTER_LEVELS:
		frequency = "Por encontro"
	elif level in LevelProgressionData.DAILY_LEVELS:
		frequency = "Diário"
	else:
		return {}
	var style: Dictionary = CLASS_STYLE[character_class]
	var mode: String = str(style["mode"])
	var name: String = str(style["utility"] if utility else style["attack"])
	name += " %d" % level
	var bonus_damage: int = 0 if utility else maxi(1, ceili(float(level) / 3.0))
	var description: String = ""
	if utility:
		description = "Recupera %d PV e ganha +3 m de movimento neste turno ao selecionar. Não gasta ataque." % (3 + level)
	elif mode == "magic":
		description = "Ataque mágico a até 9 m: 1d6 + atributo mágico +%d de dano. Usa a ação de ataque." % bonus_damage
	else:
		description = "Ataque com arma com +%d de dano se acertar. Usa a ação de ataque." % bonus_damage
	return {
		"id": "progression_%s_%d" % [style["key"], level],
		"name": name,
		"frequency": frequency,
		"description": description,
		"level": level,
		"utility": utility,
		"mode": mode,
		"ability": str(style.get("ability", "")),
		"bonus_damage": bonus_damage,
		"class_name": character_class
	}


static func get_power_options_for_level(character_class: String, level: int) -> Array[Dictionary]:
	var primary: Dictionary = get_new_power_for_level(character_class, level)
	if primary.is_empty():
		return []
	var style: Dictionary = CLASS_STYLE[character_class]
	var alternate: Dictionary = primary.duplicate(true)
	var utility: bool = bool(primary["utility"])
	alternate["id"] = str(primary["id"]) + "_alternate"
	alternate["name"] = "%s %d" % [style["alternate_utility"] if utility else style["alternate_attack"], level]
	if utility:
		alternate["utility_effect"] = "movement"
		alternate["description"] = "Ganha +6 m de movimento neste turno ao selecionar. Não gasta ataque."
		primary["utility_effect"] = "recovery"
	else:
		alternate["attack_bonus"] = 2
		alternate["bonus_damage"] = maxi(0, int(primary["bonus_damage"]) - 1)
		var magic: bool = str(primary["mode"]) == "magic"
		var damage_text: String = "1d6 + atributo mágico" if magic else "dano da arma"
		var attack_text: String = "Ataque mágico a até 9 m" if magic else "Ataque com arma"
		alternate["description"] = "%s: +2 para acertar e %s +%d de dano. Usa a ação de ataque." % [attack_text, damage_text, int(alternate["bonus_damage"])]
	return [primary, alternate]


static func get_power_by_id(power_id: String) -> Dictionary:
	for character_class in CLASS_STYLE:
		for level in range(1, LevelProgressionData.MAX_LEVEL + 1):
			for power in get_power_options_for_level(character_class, level):
				if str(power.get("id", "")) == power_id:
					return power
	return {}


static func get_available_powers(character_class: String, character_level: int, selected_powers: Dictionary = {}) -> Array:
	var result: Array = []
	if not has_class(character_class):
		return result
	for level in range(1, mini(character_level, LevelProgressionData.MAX_LEVEL) + 1):
		var options: Array[Dictionary] = get_power_options_for_level(character_class, level)
		if options.is_empty():
			continue
		if level == 3 and character_level >= 17:
			continue
		if level == 7 and character_level >= 23:
			continue
		if level == 11 and character_level >= 27:
			continue
		if level == 5 and character_level >= 19:
			continue
		if level == 9 and character_level >= 25:
			continue
		if level == 15 and character_level >= 29:
			continue
		var power: Dictionary = options[0]
		var selected_id: String = str(selected_powers.get(str(level), ""))
		if selected_id == str(options[1]["id"]):
			power = options[1]
		result.append(power)
	return result
