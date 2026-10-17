extends Node

const ScenarioDatabase = preload("res://Scene/scenario_database.gd")


func _ready() -> void:
	var sequence: Dictionary = ScenarioDatabase.get_scenario_victory_sequence(1)
	assert(sequence["guard_survival_bonus_gold"] == 10)
	assert(sequence["next_scene"] == "res://Scene/village.tscn")
	var survivor: Array = ScenarioDatabase.assemble_stage_1_victory_dialogues(sequence, true)
	var fallen: Array = ScenarioDatabase.assemble_stage_1_victory_dialogues(sequence, false)
	assert(survivor.size() > 25)
	assert(fallen.size() > 20)
	assert(survivor[0]["text"] == "A última criatura cai. O aventureiro observa a própria arma.")
	assert(_find_line(survivor, "Você salvou minha vida.") > _find_line(survivor, "Talvez."))
	assert(_find_line(survivor, "+10 peças de ouro.") >= 0)
	assert(_find_line(survivor, "Mostro o caminho.") >= 0)
	assert(_find_line(survivor, "Não consegui protegê-lo.") == -1)
	assert(_find_line(fallen, "Não consegui protegê-lo.") >= 0)
	assert(_find_line(fallen, "+10 peças de ouro.") == -1)
	assert(_find_line(fallen, "Mostro o caminho.") == -1)
	assert(survivor[-1]["speaker_name"] == "Novo objetivo")
	assert(fallen[-1]["speaker_name"] == "Novo objetivo")
	assert(_find_line(survivor, "Mas alguma coisa em mim sabia que eu precisava ajudar.") >= 0)
	print("Stage one victory tests passed")
	get_tree().quit(0)


func _find_line(dialogues: Array, text: String) -> int:
	for index in dialogues.size():
		if str(dialogues[index].get("text", "")) == text:
			return index
	return -1
