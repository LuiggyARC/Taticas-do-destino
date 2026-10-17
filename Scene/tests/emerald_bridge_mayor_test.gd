extends Node

const DialogueDatabase = preload("res://Scene/village_dialogue_database.gd")


func _ready() -> void:
	var village_id: String = DialogueDatabase.STARTING_VILLAGE_ID
	var intro: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "emerald_bridge_mayor_intro"
	)
	var help: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "emerald_bridge_choice_help"
	)
	var payment: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "emerald_bridge_choice_payment"
	)
	var conclusion: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "emerald_bridge_mayor_conclusion"
	)
	assert(not intro.is_empty())
	assert(not help.is_empty())
	assert(not payment.is_empty())
	assert(not conclusion.is_empty())
	assert(_has_line(intro, "Prefeito", "A Ponte da Esmeralda foi danificada."))
	assert(_has_line(intro, "Aniri", "Mas eu vou atrás dele."))
	assert(_has_line(intro, "Sir Uiliam", "Eu irei até a ponte."))
	assert(_has_line(help, "Aventureiro", "Eu vou com vocês."))
	assert(_has_line(payment, "Aventureiro", "Esse tipo de serviço é remunerado?"))
	assert(_has_line(conclusion, "Prefeito", "Porque não temos um Selo."))
	assert(_has_line(conclusion, "Prefeito", "Sigam por aqui."))
	assert(_has_line(conclusion, "Ação", "O grupo deixa a prefeitura. Uiliam é o último a sair."))
	print("Emerald Bridge mayor dialogue test passed")
	get_tree().quit(0)


func _has_line(entries: Array[Dictionary], speaker: String, line_text: String) -> bool:
	for entry in entries:
		if str(entry.get("text", "")) != line_text:
			continue
		if speaker == "Ação" and str(entry.get("type", "")) == "action":
			return true
		if str(entry.get("speaker", "")) == speaker:
			return true
	return false
