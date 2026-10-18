extends Node

const TempleHallDatabase = preload("res://Scene/temple_hall_database.gd")
const TempleHallScene = preload("res://Scene/temple_hall.tscn")


func _ready() -> void:
	assert(TempleHallScene != null)
	assert(TempleHallDatabase.RETURN_ORDER == ["return_to_temple", "second_document", "temple_bells"])
	var dialogue: String = ""
	var disciple_speaks: bool = false
	for scene_id in TempleHallDatabase.RETURN_ORDER:
		assert(scene_id not in TempleHallDatabase.ORDER)
		var sequence: Array[Dictionary] = TempleHallDatabase.get_scene(scene_id)
		assert(not sequence.is_empty())
		assert(TempleHallDatabase.CASTS.has(scene_id))
		for step in sequence:
			dialogue += str(step.get("text", "")) + "\n"
			if str(step.get("speaker", "")) == "Discípulo":
				disciple_speaks = true
	assert(dialogue.contains("Ebramir"))
	assert(dialogue.contains("Montirel"))
	assert(dialogue.contains("Retaliação"))
	assert(dialogue.contains("Ataque"))
	assert(disciple_speaks)
	print("Temple return story test passed")
	get_tree().quit(0)
