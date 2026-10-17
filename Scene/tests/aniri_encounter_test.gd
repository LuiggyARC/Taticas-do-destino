extends Node

const ScenarioDatabase = preload("res://Scene/scenario_database.gd")


func _ready() -> void:
	var intro: Dictionary = ScenarioDatabase.get_stage_2_victory_intro_data()
	var before: Array = intro.get("dialogues_before_approach", [])
	var after: Array = intro.get("dialogues_after_approach", [])
	var opening_count: int = int(intro.get("opening_dialogue_count", 0))
	assert(opening_count > 0 and opening_count < before.size())
	assert(str(before[opening_count - 1].get("text", "")) == "Os dois se viram.")
	assert(str(before[opening_count].get("text", "")).begins_with("Uma halfling"))
	assert(_contains_text(before, "Ratos costumam guardar martelos?"))
	assert(_contains_text(after, "Até perceber que “algum dia” estava ficando parecido demais com “nunca”."))
	assert(_contains_text(after, "Vou falar com ele."))
	assert(_contains_speaker(after, "[NOME_DO_JOGADOR]"))

	var choice: Dictionary = ScenarioDatabase.get_stage_2_victory_choice_data()
	var options: Array = choice.get("options", [])
	assert(options.size() == 2)
	assert(str(options[0].get("id", "")) == "give_aniri_a_chance")
	assert(str(options[1].get("id", "")) == "jhon_decides")
	assert(_contains_text(options[0].get("dialogues", []), "Primeiro Jhon."))
	assert(_contains_text(options[1].get("dialogues", []), "Então assumo o que fiz."))

	var conclusion: Dictionary = ScenarioDatabase.get_stage_2_victory_conclusion_data()
	assert(_contains_text(conclusion.get("dialogues", []), "Os três seguem para a escada."))
	var mission: Dictionary = conclusion.get("mission", {})
	assert(str(mission.get("id", "")) == "aniri_second_chance")
	assert(str(mission.get("description", "")).contains("Objetivo: leve Aniri até Jhon."))
	assert(str(conclusion.get("return_location", "")) == "carpenter")
	print("Aniri encounter test passed")
	get_tree().quit(0)


func _contains_text(entries: Array, text: String) -> bool:
	for entry in entries:
		if str(entry.get("text", "")) == text:
			return true
	return false


func _contains_speaker(entries: Array, speaker_name: String) -> bool:
	for entry in entries:
		if str(entry.get("speaker_name", "")) == speaker_name:
			return true
	return false
