extends RefCounted

const BEFORE_MAP := "res://Assets/Maps/Mapa 1.jpg"
const AFTER_MAP := "res://Assets/Maps/Mapa 2.jpg"
const ROAD_EVENT_ID := "temple_road_litz_arievilo"
const BRIDGE_MISSION_ID := "emerald_bridge"

# Posições normalizadas na arte original; novas paradas podem ser incluídas aqui.
const NODES := {
	"village": {"name": "Passos da Névoa", "position": Vector2(0.513, 0.811)},
	"bridge": {"name": "Ponte Esmeralda", "position": Vector2(0.532, 0.716)},
	"citadel": {"name": "Cidadela Abandonada", "position": Vector2(0.566, 0.635)}
}
const CONNECTIONS := [
	["village", "bridge"],
	["bridge", "citadel"]
]


static func map_path(road_story_completed: bool) -> String:
	return AFTER_MAP if road_story_completed else BEFORE_MAP


static func is_unlocked(node_id: String, bridge_completed: bool, road_story_completed: bool) -> bool:
	match node_id:
		"village":
			return true
		"bridge":
			return bridge_completed
		"citadel":
			return bridge_completed and road_story_completed
	return false


static func can_travel(from_id: String, to_id: String, bridge_completed: bool, road_story_completed: bool) -> bool:
	if from_id == to_id or not is_unlocked(to_id, bridge_completed, road_story_completed):
		return false
	for connection in CONNECTIONS:
		if (connection[0] == from_id and connection[1] == to_id) or (connection[1] == from_id and connection[0] == to_id):
			return true
	return false


static func get_node_name(node_id: String) -> String:
	return str(NODES.get(node_id, {}).get("name", "Local desconhecido"))
