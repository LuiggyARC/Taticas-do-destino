extends Node

const ReturnDatabase = preload("res://Scene/village_return_database.gd")


func _ready() -> void:
	var scenes: Dictionary = {}
	for scene_id in ["mission", "reward", "cult", "aurora", "memory", "next"]:
		var scene: Array[Dictionary] = ReturnDatabase.get_scene(scene_id)
		assert(not scene.is_empty())
		scenes[scene_id] = scene
	assert(_has_line(scenes["mission"], "Jhon", "Considere sua dívida paga."))
	assert(_has_line(scenes["mission"], "Aniri", "Financeiras, pelo menos."))
	assert(_has_line(scenes["reward"], "Ação", "A recompensa pelo serviço é de 300 peças de ouro."))
	assert(_has_line(scenes["reward"], "Prefeito", "As lojas estão abastecidas novamente."))
	assert(_has_line(scenes["cult"], "Prefeito", "Antes de eu assumir este cargo, existia um grupo numa construção abandonada próxima à floresta."))
	assert(_has_line(scenes["cult"], "Sir Uiliam", "Hashagur."))
	assert(_has_line(scenes["aurora"], "Aniri", "Que Aurora não fez tudo sozinha."))
	assert(_has_line(scenes["memory"], "Aventureiro (pensamento)", "Como eu cheguei aqui?"))
	assert(_has_line(scenes["next"], "Sir Uiliam", "Antes disso, quero falar com Kasum."))
	assert(_has_line(scenes["next"], "Aniri", "Então vamos à taverna."))
	print("Emerald Bridge return dialogue test passed")
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
