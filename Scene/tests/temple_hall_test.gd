extends Node

const HallDatabase = preload("res://Scene/temple_hall_database.gd")
const HallScene = preload("res://Scene/temple_hall.tscn")
const HallScript = preload("res://Scene/temple_hall.gd")
const MissionManagerScript = preload("res://Scene/mission_manager.gd")


func _ready() -> void:
	assert(HallDatabase.ORDER.size() == 9)
	for scene_id in HallDatabase.ORDER:
		var scene: Array[Dictionary] = HallDatabase.get_scene(str(scene_id))
		assert(not scene.is_empty())
		var cast: Array = HallDatabase.CASTS.get(scene_id, [])
		assert(cast.size() <= 4)
		for step in scene:
			if str(step.get("type", "")) == "dialogue":
				assert(str(step.get("speaker", "")) in cast)
	assert(_has_line(HallDatabase.get_scene("citadel"), "Aniri", "Eu consigo."))
	assert(_has_line(HallDatabase.get_scene("plan_second"), "Kasum", "Estou começando a entender."))
	assert(HallScene != null)
	assert(ResourceLoader.exists(HallScript.HALL_MAP_PATH))
	assert(ResourceLoader.exists(HallScript.TEMPLE_MUSIC_PATH))
	var missions: Node = MissionManagerScript.new()
	assert(missions.start_mission({"id": "hashagur_temple", "title": "Ecos do Templo"}))
	assert(missions.complete_mission("hashagur_temple"))
	assert(missions.start_mission({"id": HallScript.CITADEL_MISSION_ID, "title": "Sombras da Cidadela"}))
	assert(missions.is_mission_completed("hashagur_temple"))
	assert(missions.is_mission_active(HallScript.CITADEL_MISSION_ID))
	missions.free()
	print("Temple hall test passed")
	get_tree().quit(0)


func _has_line(entries: Array[Dictionary], speaker: String, dialogue_text: String) -> bool:
	for entry in entries:
		if str(entry.get("speaker", "")) == speaker and str(entry.get("text", "")) == dialogue_text:
			return true
	return false
