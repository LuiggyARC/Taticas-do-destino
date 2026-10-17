extends Node

const DialogueDatabase = preload("res://Scene/village_dialogue_database.gd")
const SecondChanceDatabase = preload("res://Scene/second_chance_database.gd")
const MissionManagerScript = preload("res://Scene/mission_manager.gd")


func _ready() -> void:
	var village_id: String = DialogueDatabase.STARTING_VILLAGE_ID
	var return_scene: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_carpenter_return"
	)
	var conclusion: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_carpenter_conclusion"
	)
	var healer: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_healer_return"
	)
	var acceptance: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_choice_acceptance"
	)
	var distrust: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_choice_distrust"
	)
	var invitation: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_new_adventurer"
	)
	var morning: Array[Dictionary] = DialogueDatabase.get_location_event_sequence(
		village_id, "second_chance_healer_morning"
	)
	assert(not return_scene.is_empty())
	assert(not conclusion.is_empty())
	assert(not healer.is_empty())
	assert(_has_line(return_scene, "Jhon", "E então?"))
	assert(_has_line(return_scene, "Aniri", "A outra parte do problema."))
	assert(_has_line(return_scene, "Aniri", "Gastei uma parte."))
	assert(_has_line(return_scene, "Jhon", "Vai trabalhar até pagar o restante."))
	assert(_has_line(conclusion, "Ação", "Ela abre a bolsa. Dentro há uma poção e algumas bandagens."))
	assert(_has_line(conclusion, "Aventureiro", "Não comprados."))
	assert(_has_line(conclusion, "Sir Uiliam", "Vamos."))
	assert(_has_line(healer, "Aniri", "Eu os roubei."))
	assert(_has_line(healer, "Aniri", "Sinto muito."))
	assert(_has_line(healer, "Curandeira", "Podem ficar aqui hoje."))
	assert(_has_line(acceptance, "Ação", "Afinidade com Aniri aumentou."))
	assert(_has_line(distrust, "Ação", "Afinidade com Aniri não se altera."))
	assert(_has_line(invitation, "Sir Uiliam", "pode viajar conosco enquanto cumpre sua palavra."))
	assert(_has_line(invitation, "Aniri", "Então eu vou."))
	assert(morning[0].get("type", "") == "start_fade_to_black")
	assert(_has_line(morning, "Ação", "Uma noite se passa."))
	assert(_has_line(morning, "Ação", "Item recebido: +3 Poções de Cura."))
	assert(not SecondChanceDatabase.has_event("second_chance_carpenter_choice_chance"))
	assert(not SecondChanceDatabase.has_event("second_chance_carpenter_choice_jhon"))
	assert(not SecondChanceDatabase.has_event("second_chance_village_choice_intro"))
	var mission_manager: Node = MissionManagerScript.new()
	assert(mission_manager.start_mission({"id": "aniri_second_chance", "description": "Leve Aniri até Jhon."}))
	assert(mission_manager.update_mission_description("aniri_second_chance", "Aniri ainda deve a Jhon."))
	assert(str(mission_manager.get_active_mission("aniri_second_chance").get("description", "")) == "Aniri ainda deve a Jhon.")
	mission_manager.free()
	print("Second Chance carpenter dialogue test passed")
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
