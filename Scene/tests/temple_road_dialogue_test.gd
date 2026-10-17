extends Node

const RoadDatabase = preload("res://Scene/temple_road_database.gd")
const RoadSceneScript = preload("res://Scene/temple_road.gd")
const MissionManagerScript = preload("res://Scene/mission_manager.gd")


func _ready() -> void:
	assert(RoadDatabase.ORDER.size() == 10)
	var scenes: Dictionary = {}
	for scene_id in RoadDatabase.ORDER:
		var scene: Array[Dictionary] = RoadDatabase.get_scene(str(scene_id))
		assert(not scene.is_empty())
		scenes[str(scene_id)] = scene
	assert(_has_line(scenes["road"], "Kasum", "Quanto falta?"))
	assert(_has_line(scenes["meeting"], "Arievilo", "Da Cidade de Montirel."))
	assert(_has_line(scenes["capital"], "Arievilo", "Possuía."))
	assert(_has_line(scenes["forest"], "Litz", "Uma fenda."))
	assert(_has_line(scenes["book"], "Litz", "Elas já estavam mortas."))
	assert(_has_line(scenes["together"], "Arievilo", "Mas ele ficou."))
	assert(_has_line(scenes["rift"], "Aniri", "[PLAYER_NAME]?"))
	assert(_has_line(scenes["directions"], "Sir Uiliam", "Comprem comida."))
	assert(_has_line(scenes["farewell"], "Arievilo", "Espero que nos encontremos novamente."))
	assert(_has_line(scenes["after"], "Sir Uiliam", "Primeiro Hashagur."))
	assert(RoadSceneScript.ROAD_CASTS.size() == RoadDatabase.ORDER.size())
	var missions: Node = MissionManagerScript.new()
	assert(missions.start_mission({"id": "hashagur_temple", "title": "O Templo de Hashagur"}))
	assert(missions.update_mission_title("hashagur_temple", "Ecos do Templo"))
	assert(str(missions.get_active_mission("hashagur_temple").get("title", "")) == "Ecos do Templo")
	missions.free()
	print("Temple road dialogue test passed")
	get_tree().quit(0)


func _has_line(entries: Array[Dictionary], speaker: String, line_text: String) -> bool:
	for entry in entries:
		if str(entry.get("speaker", "")) == speaker and str(entry.get("text", "")) == line_text:
			return true
	return false
