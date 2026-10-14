extends RefCounted
class_name LevelProgression

# Progressão de Aviant baseada nos marcos apresentados pelo jogador.
# Os atributos mantêm a regra própria do projeto: +2 livres, ou +3 para Meio-Elfo.
const MAX_LEVEL: int = 30
const XP_THRESHOLDS := [
	0, 0, 1000, 2250, 3750, 5500, 7500, 10000, 13000, 16500,
	20500, 26000, 32000, 39000, 47000, 57000, 69000, 83000,
	99000, 119000, 143000, 175000, 210000, 255000, 310000,
	375000, 450000, 550000, 675000, 825000, 1000000
]
const UTILITY_LEVELS := [2, 6, 10, 12, 16, 22, 26]
const ENCOUNTER_LEVELS := [3, 7, 11, 13, 17, 23, 27]
const DAILY_LEVELS := [5, 9, 15, 19, 20, 25, 29]
const REPLACEMENT_ENCOUNTER_LEVELS := [13, 17, 23, 27]
const REPLACEMENT_DAILY_LEVELS := [15, 19, 25, 29]
const PATH_FEATURE_LEVELS := [11, 16, 20]
const DESTINY_FEATURE_LEVELS := [21, 26, 30]


static func xp_for_level(target_level: int) -> int:
	return XP_THRESHOLDS[clampi(target_level, 1, MAX_LEVEL)]


static func general_feat_count(new_level: int) -> int:
	return 1 if new_level > 1 and (new_level % 2 == 0 or new_level in [11, 21]) else 0


static func attribute_points(new_level: int, race_name: String) -> int:
	return (2 + int(race_name == "Meio-Elfo")) if new_level > 1 and new_level % 4 == 0 else 0


static func power_totals_for_level(target_level: int) -> Dictionary:
	# TPC: sem limite / por encontro / diário / utilitário.
	var totals := {"at_will": 2, "encounter": 1, "daily": 1, "utility": 0}
	for level in range(2, clampi(target_level, 1, MAX_LEVEL) + 1):
		if level in UTILITY_LEVELS:
			totals["utility"] += 1
		if level in ENCOUNTER_LEVELS and level not in REPLACEMENT_ENCOUNTER_LEVELS:
			totals["encounter"] += 1
		if level in DAILY_LEVELS and level not in REPLACEMENT_DAILY_LEVELS:
			totals["daily"] += 1
	return totals


static func gains_for_level(new_level: int, race_name: String, uses_powers: bool = true) -> Array[String]:
	var gains: Array[String] = []
	var attributes: int = attribute_points(new_level, race_name)
	if attributes > 0:
		gains.append("%d pontos de atributo para distribuir" % attributes)
	if general_feat_count(new_level) > 0:
		gains.append("1 talento")
	if uses_powers and new_level in UTILITY_LEVELS:
		gains.append("1 poder utilitário")
	if uses_powers and new_level in ENCOUNTER_LEVELS:
		gains.append("1 poder de ataque por encontro" + (" (substitui um anterior)" if new_level in REPLACEMENT_ENCOUNTER_LEVELS else ""))
	if uses_powers and new_level in DAILY_LEVELS:
		gains.append("1 poder de ataque diário" + (" (substitui um anterior)" if new_level in REPLACEMENT_DAILY_LEVELS else ""))
	if new_level in PATH_FEATURE_LEVELS:
		gains.append("Marco de trilha exemplar reservado — sem bônus até a definição das trilhas")
	if new_level in DESTINY_FEATURE_LEVELS:
		gains.append("Marco de destino épico reservado — sem bônus até a definição dos destinos")
	return gains
