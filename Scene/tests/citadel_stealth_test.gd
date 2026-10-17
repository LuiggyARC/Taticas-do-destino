extends Node

const Rules = preload("res://Scene/citadel_stealth_rules.gd")
const CitadelScene = preload("res://Scene/citadel_stealth.tscn")


func _ready() -> void:
	assert(ResourceLoader.exists(Rules.MAP_PATH))
	assert(CitadelScene != null)
	assert(Rules.GUARDS.size() == 4)
	assert(Rules.ANIRI_VISION_METERS == 8.0)
	assert(Rules.CULTIST_VISION_METERS == 6.0)
	assert(Rules.observe_succeeds(12, 3, 10, 5))
	assert(not Rules.observe_succeeds(11, 3, 10, 5))
	assert(ResourceLoader.exists("res://Assets/Audio/Temafurtivo.mp3"))
	assert(Rules.validate_layout().is_empty())
	assert(Rules.path(Rules.START, Rules.CHEST).size() > 0)
	assert(Rules.path(Rules.START, Rules.BEDROOM_CLUE).size() > 0)
	assert(Rules.path(Rules.START, Rules.STRATEGY_CLUE).size() > 0)
	assert(Rules.has_line_of_sight(Vector2i(1, 2), Vector2i(1, 4)))
	assert(not Rules.has_line_of_sight(Vector2i(15, 10), Vector2i(18, 10)))
	for guard in Rules.GUARDS:
		for waypoint in guard["route"]:
			assert(not Rules.blocked(waypoint))
	print("Citadel stealth rules test passed")
	get_tree().quit(0)
