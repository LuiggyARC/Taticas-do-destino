extends Node

const GateDatabase = preload("res://Scene/temple_gate_database.gd")
const GateScene = preload("res://Scene/temple_gate.tscn")
const HallScene = preload("res://Scene/temple_hall.tscn")
const GateScript = preload("res://Scene/temple_gate.gd")
const HallScript = preload("res://Scene/temple_hall.gd")


func _ready() -> void:
	var scene: Array[Dictionary] = GateDatabase.get_arrival()
	assert(scene.size() >= 50)
	assert(_has_line(scene, "Hashagur", "Sabia que viriam."))
	assert(_has_line(scene, "Aventureiro", "Não lembro se sou."))
	assert(_has_line(scene, "Kasum", "Já gostei menos do templo."))
	assert(scene[0].get("type") == "action")
	assert(scene[1].get("type") == "hashagur_enters")
	assert(GateScene != null and HallScene != null)
	assert(ResourceLoader.exists(GateScript.GATE_MAP_PATH))
	assert(ResourceLoader.exists(HallScript.HALL_MAP_PATH))
	assert(ResourceLoader.exists(GateScript.TEMPLE_MUSIC_PATH))
	print("Temple gate test passed")
	get_tree().quit(0)


func _has_line(entries: Array[Dictionary], speaker: String, dialogue_text: String) -> bool:
	for entry in entries:
		if str(entry.get("speaker", "")) == speaker and str(entry.get("text", "")) == dialogue_text:
			return true
	return false
