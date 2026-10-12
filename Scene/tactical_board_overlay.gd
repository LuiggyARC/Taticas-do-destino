extends Node2D

const BattleTileStyle = preload("res://Scene/battle_tile_style.gd")

var tile_size: int = 64

var movement_layer: Node2D
var attack_layer: Node2D


func setup(new_tile_size: int) -> void:
	tile_size = max(
		1,
		new_tile_size
	)
	
	name = "TacticalBoardOverlay"
	
	create_layers()


func create_layers() -> void:
	movement_layer = Node2D.new()
	movement_layer.name = "MovementLayer"
	movement_layer.z_index = 10
	
	add_child(movement_layer)
	
	attack_layer = Node2D.new()
	attack_layer.name = "AttackAreaLayer"
	attack_layer.z_index = 45
	
	add_child(attack_layer)


func clear_movement_tiles() -> void:
	if not is_instance_valid(movement_layer):
		return
	
	for child in movement_layer.get_children():
		child.queue_free()


func clear_attack_tiles() -> void:
	if not is_instance_valid(attack_layer):
		return
	
	for child in attack_layer.get_children():
		child.queue_free()


func create_movement_tile(
	grid_position: Vector2i,
	opportunity_risk: bool = false
) -> void:
	if not is_instance_valid(movement_layer):
		return
	
	var tile: Panel = BattleTileStyle.create_tile(
		"MovementTile",
		grid_position,
		tile_size,
		Color(0.98, 0.36, 0.08, 0.34) if opportunity_risk else Color(0.0, 0.65, 1.0, 0.20),
		Color(1.0, 0.58, 0.16, 0.94) if opportunity_risk else Color(0.23, 0.80, 1.0, 0.85),
		10
	)
	if opportunity_risk:
		tile.tooltip_text = "Perigo: um inimigo atacará antes de você se mover."
		var warning_marker := Label.new()
		warning_marker.name = "OpportunityWarning"
		warning_marker.text = "!"
		warning_marker.position = Vector2.ZERO
		warning_marker.size = tile.size
		warning_marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
		warning_marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		warning_marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		warning_marker.add_theme_font_size_override("font_size", maxi(20, roundi(float(tile_size) * 0.45)))
		warning_marker.add_theme_color_override("font_color", Color.WHITE)
		warning_marker.add_theme_color_override("font_outline_color", Color(0.35, 0.08, 0.0))
		warning_marker.add_theme_constant_override("outline_size", 4)
		tile.add_child(warning_marker)
	
	movement_layer.add_child(tile)


func show_path_preview(
	path: Array[Vector2i]
) -> void:
	if not is_instance_valid(movement_layer):
		return
	
	clear_path_preview()
	
	for cell in path:
		var tile: Panel = BattleTileStyle.create_tile(
			"PathPreviewTile",
			cell,
			tile_size,
			Color(1.0, 0.9, 0.15, 0.35),
			Color(1.0, 0.87, 0.18, 0.90),
			20
		)
		
		movement_layer.add_child(tile)


func clear_path_preview() -> void:
	if not is_instance_valid(movement_layer):
		return
	
	for child in movement_layer.get_children():
		if child.name == "PathPreviewTile":
			child.queue_free()


func create_attack_tile(
	grid_position: Vector2i
) -> void:
	if not is_instance_valid(attack_layer):
		return
	
	var tile: Panel = BattleTileStyle.create_tile(
		"AttackTargetTile",
		grid_position,
		tile_size,
		Color(1.0, 0.05, 0.05, 0.45),
		Color(1.0, 0.24, 0.19, 0.90),
		45
	)
	
	attack_layer.add_child(tile)
