extends Node

const HealerNightDatabase = preload("res://Scene/healer_night_database.gd")
const VillageScript = preload("res://Scene/village.gd")


func _ready() -> void:
	var scenes: Dictionary = {}
	for scene_id in ["long_day", "uiliam", "memory", "aniri_idea", "second_chance", "solitude", "goodnight"]:
		var scene: Array[Dictionary] = HealerNightDatabase.get_scene(scene_id)
		assert(not scene.is_empty())
		scenes[scene_id] = scene
	assert(_has_line(scenes["long_day"], "Aniri", "Faz dois dias que tudo isso começou."))
	assert(_has_line(scenes["uiliam"], "Sir Uiliam", "O passado não muda."))
	assert(_has_line(scenes["memory"], "Aventureiro", "Porque são todas as lembranças que eu tenho."))
	assert(_has_line(scenes["aniri_idea"], "Aniri", "Veneno."))
	assert(_has_line(scenes["second_chance"], "Aniri", "Hoje Jhon disse que minha dívida estava paga."))
	assert(_has_line(scenes["solitude"], "Aniri", "Tenho medo de perder isso."))
	assert(_has_line(scenes["goodnight"], "Aventureiro (pensamento)", "Então onde estava antes?"))
	assert(VillageScript.is_location_open_in_morning("central_square"))
	assert(VillageScript.is_location_open_in_morning("shop"))
	for closed_location in ["tavern", "town_hall", "carpenter", "healer"]:
		assert(not VillageScript.is_location_open_in_morning(closed_location))
	print("Healer night and morning access tests passed")
	get_tree().quit(0)


func _has_line(entries: Array[Dictionary], speaker: String, line_text: String) -> bool:
	for entry in entries:
		if str(entry.get("text", "")) != line_text:
			continue
		if str(entry.get("speaker", "")) == speaker:
			return true
	return false
