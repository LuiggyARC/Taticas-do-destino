extends Node

const DialogueDatabase = preload("res://Scene/village_dialogue_database.gd")


func _ready() -> void:
	var sequence: Array[Dictionary] = DialogueDatabase.get_tavern_history_sequence()
	var video_index: int = _find_step(sequence, "video")
	assert(video_index > 0)
	assert(sequence[video_index]["video_path"] == "res://Assets/UI/Intro/Historiamundo.ogv")
	var opening_line: int = _find_text(sequence, "você disse que explicaria onde estou.")
	assert(opening_line >= 0 and opening_line < video_index)
	assert(_find_text(sequence, "Então aquelas criaturas vieram por causa da Ruptura.") > video_index)
	assert(_find_text(sequence, "E agora, com vocês, os bardos Os Sem Destino!") > video_index)
	assert(sequence[-2]["speaker"] == "Diário atualizado")
	assert(sequence[-1]["speaker"] == "Novo objetivo")
	assert(sequence[-1]["text"] == "Explore a vila e descubra mais sobre Aviant — e sobre quem você era antes de chegar aqui.")
	var free_drink: Dictionary = DialogueDatabase.get_dialogue(
		DialogueDatabase.STARTING_VILLAGE_ID, "tavern", "story_interruption"
	)
	assert("rodada grátis" in str(free_drink.get("text", "")))
	print("Tavern history tests passed")
	get_tree().quit(0)


func _find_step(sequence: Array[Dictionary], step_type: String) -> int:
	for index in sequence.size():
		if str(sequence[index].get("type", "")) == step_type:
			return index
	return -1


func _find_text(sequence: Array[Dictionary], text: String) -> int:
	for index in sequence.size():
		if str(sequence[index].get("text", "")) == text:
			return index
	return -1
