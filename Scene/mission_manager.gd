extends Node


signal mission_started(mission_data: Dictionary)
signal mission_updated(mission_data: Dictionary)
signal mission_completed(mission_data: Dictionary)


var active_missions: Dictionary = {}
var completed_missions: Dictionary = {}
var story_choices: Dictionary = {}


func start_mission(
	mission_data: Dictionary
) -> bool:
	var mission_id: String = str(
		mission_data.get(
			"id",
			""
		)
	).strip_edges()

	if mission_id == "":
		push_warning(
			"Não é possível iniciar uma missão sem ID."
		)
		return false

	if completed_missions.has(
		mission_id
	):
		return false

	var normalized_mission: Dictionary = (
		mission_data.duplicate(true)
	)

	normalized_mission["id"] = mission_id
	normalized_mission["status"] = "active"

	if not normalized_mission.has(
		"progress"
	):
		normalized_mission["progress"] = {}

	active_missions[mission_id] = (
		normalized_mission
	)

	mission_started.emit(
		normalized_mission.duplicate(true)
	)

	print(
		"Missão iniciada: ",
		str(
			normalized_mission.get(
				"title",
				mission_id
			)
		)
	)

	return true


func update_mission_progress(
	mission_id: String,
	progress_key: String,
	progress_value: Variant
) -> bool:
	if not active_missions.has(
		mission_id
	):
		return false

	var mission_data: Dictionary = (
		active_missions[
			mission_id
		].duplicate(true)
	)

	var progress_data: Dictionary = (
		mission_data.get(
			"progress",
			{}
		).duplicate(true)
	)

	progress_data[progress_key] = (
		progress_value
	)

	mission_data["progress"] = progress_data

	active_missions[mission_id] = (
		mission_data
	)

	mission_updated.emit(
		mission_data.duplicate(true)
	)

	return true


func update_mission_description(mission_id: String, description: String) -> bool:
	if not active_missions.has(mission_id):
		return false
	var mission_data: Dictionary = active_missions[mission_id].duplicate(true)
	mission_data["description"] = description
	active_missions[mission_id] = mission_data
	mission_updated.emit(mission_data.duplicate(true))
	return true


func update_mission_title(mission_id: String, title: String) -> bool:
	if not active_missions.has(mission_id):
		return false
	var mission_data: Dictionary = active_missions[mission_id].duplicate(true)
	mission_data["title"] = title
	active_missions[mission_id] = mission_data
	mission_updated.emit(mission_data.duplicate(true))
	return true


func complete_mission(
	mission_id: String
) -> bool:
	if not active_missions.has(
		mission_id
	):
		return false

	var mission_data: Dictionary = (
		active_missions[
			mission_id
		].duplicate(true)
	)

	active_missions.erase(
		mission_id
	)

	mission_data["status"] = "completed"

	completed_missions[mission_id] = (
		mission_data
	)

	mission_completed.emit(
		mission_data.duplicate(true)
	)

	print(
		"Missão concluída: ",
		str(
			mission_data.get(
				"title",
				mission_id
			)
		)
	)

	return true


func is_mission_active(
	mission_id: String
) -> bool:
	return active_missions.has(
		mission_id
	)


func is_mission_completed(
	mission_id: String
) -> bool:
	return completed_missions.has(
		mission_id
	)


func get_active_mission(
	mission_id: String
) -> Dictionary:
	if not active_missions.has(
		mission_id
	):
		return {}

	return active_missions[
		mission_id
	].duplicate(true)


func get_completed_mission(
	mission_id: String
) -> Dictionary:
	if not completed_missions.has(
		mission_id
	):
		return {}

	return completed_missions[
		mission_id
	].duplicate(true)


func set_story_choice(
	choice_id: String,
	selected_option_id: String
) -> void:
	if choice_id.strip_edges() == "":
		return

	story_choices[choice_id] = (
		selected_option_id
	)


func get_story_choice(
	choice_id: String
) -> String:
	return str(
		story_choices.get(
			choice_id,
			""
		)
	)


func get_save_data() -> Dictionary:
	return {
		"active_missions": (
			active_missions.duplicate(true)
		),
		"completed_missions": (
			completed_missions.duplicate(true)
		),
		"story_choices": (
			story_choices.duplicate(true)
		)
	}


func load_save_data(
	save_data: Dictionary
) -> void:
	active_missions = (
		save_data.get(
			"active_missions",
			{}
		).duplicate(true)
	)

	completed_missions = (
		save_data.get(
			"completed_missions",
			{}
		).duplicate(true)
	)

	story_choices = (
		save_data.get(
			"story_choices",
			{}
		).duplicate(true)
	)


func reset_missions() -> void:
	active_missions.clear()
	completed_missions.clear()
	story_choices.clear()
