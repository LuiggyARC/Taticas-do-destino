extends Node


const AUTOSAVE_PATH: String = (
	"user://autosave.json"
)


func get_active_save_path() -> String:
	var selected_path: String = str(
		GameState.selected_save_path
	).strip_edges()
	
	if selected_path != "":
		return selected_path
	
	return AUTOSAVE_PATH


func read_save_data(
	save_path: String
) -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {}
	
	var file := FileAccess.open(
		save_path,
		FileAccess.READ
	)
	
	if file == null:
		return {}
	
	var json_text: String = file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var parse_error := json.parse(json_text)
	
	if parse_error != OK:
		return {}
	
	if typeof(json.data) != TYPE_DICTIONARY:
		return {}
	
	return json.data


func write_save_data(
	save_path: String,
	save_data: Dictionary
) -> bool:
	var file := FileAccess.open(
		save_path,
		FileAccess.WRITE
	)
	
	if file == null:
		push_warning(
			"Não foi possível escrever o save: "
			+ save_path
		)
		
		return false
	
	file.store_string(
		JSON.stringify(
			save_data,
			"\t"
		)
	)
	
	file.close()
	
	return true


func save_village_state() -> bool:
	var save_path: String = (
		get_active_save_path()
	)
	
	var save_data: Dictionary = (
		read_save_data(save_path)
	)
	
	if save_data.is_empty():
		push_warning(
			"Não existe save-base para atualizar a vila."
		)
		
		return false
	
	GameState.current_location = "village"
	
	save_data["current_location"] = "village"
	
	save_data["party"] = (
		PartyManager.get_save_data()
	)
	
	save_data["inventory"] = (
		InventoryManager.get_save_data()
	)
	
	save_data["missions"] = (
		MissionManager.get_save_data()
	)
	
	var player_presets: Dictionary = (
		save_data.get(
			"player_presets",
			{}
		)
	)
	
	# =====================================================
	# MAGIAS CONHECIDAS
	# =====================================================
	player_presets["hero_known_spells"] = (
		GameState.hero_known_spells.duplicate(true)
	)
	
	# =====================================================
	# ESPAÇOS RESTANTES
	# =====================================================
	player_presets["hero_spell_slots_level_0"] = (
		GameState.hero_spell_slots_level_0
	)
	
	player_presets["hero_spell_slots_level_1"] = (
		GameState.hero_spell_slots_level_1
	)
	
	player_presets["hero_spell_slots_level_2"] = (
		GameState.hero_spell_slots_level_2
	)
	
	# =====================================================
	# ESPAÇOS MÁXIMOS
	# =====================================================
	player_presets[
		"hero_max_spell_slots_level_0"
	] = GameState.hero_max_spell_slots_level_0
	
	player_presets[
		"hero_max_spell_slots_level_1"
	] = GameState.hero_max_spell_slots_level_1
	
	player_presets[
		"hero_max_spell_slots_level_2"
	] = GameState.hero_max_spell_slots_level_2
	
	save_data["player_presets"] = (
		player_presets
	)
	
	if not save_data.has("current_stage"):
		save_data["current_stage"] = max(
			1,
			GameState.selected_stage
		)
	
	var save_was_written: bool = (
		write_save_data(
			save_path,
			save_data
		)
	)
	
	if save_was_written:
		print(
			"Estado da vila, grupo, inventário, "
			+ "missões e magias salvo."
		)
	
	return save_was_written

func has_completed_story_event(
	event_id: String
) -> bool:
	var normalized_event_id: String = (
		event_id.strip_edges()
	)
	
	if normalized_event_id == "":
		return false
	
	var save_data: Dictionary = read_save_data(
		get_active_save_path()
	)
	
	if save_data.is_empty():
		return false
	
	var completed_events: Array = save_data.get(
		"completed_story_events",
		[]
	)
	
	return normalized_event_id in completed_events


func mark_story_event_completed(
	event_id: String
) -> bool:
	var normalized_event_id: String = (
		event_id.strip_edges()
	)
	
	if normalized_event_id == "":
		return false
	
	var save_path: String = (
		get_active_save_path()
	)
	
	var save_data: Dictionary = (
		read_save_data(save_path)
	)
	
	if save_data.is_empty():
		push_warning(
			"Não existe save-base para registrar "
			+ "o evento narrativo."
		)
		
		return false
	
	var completed_events: Array = save_data.get(
		"completed_story_events",
		[]
	)
	
	if normalized_event_id not in completed_events:
		completed_events.append(
			normalized_event_id
		)
	
	save_data["completed_story_events"] = (
		completed_events
	)
	
	return write_save_data(
		save_path,
		save_data
	)
func prepare_battle_stage(
	stage_number: int
) -> bool:
	var safe_stage_number: int = max(
		1,
		stage_number
	)
	
	var save_path: String = (
		get_active_save_path()
	)
	
	var save_data: Dictionary = (
		read_save_data(save_path)
	)
	
	if save_data.is_empty():
		push_warning(
			"Não existe save-base para iniciar "
			+ "o cenário de batalha."
		)
		
		return false
	
	save_data["current_stage"] = (
		safe_stage_number
	)
	
	save_data["current_location"] = "battle"
	
	save_data["party"] = (
		PartyManager.get_save_data()
	)
	
	save_data["inventory"] = (
		InventoryManager.get_save_data()
	)
	
	var save_was_written: bool = (
		write_save_data(
			save_path,
			save_data
		)
	)
	
	if not save_was_written:
		return false
	
	GameState.selected_stage = (
		safe_stage_number
	)
	
	GameState.current_location = "battle"
	GameState.should_load_save = true
	
	print(
		"Cenário preparado para batalha: ",
		safe_stage_number
	)
	
	return true
