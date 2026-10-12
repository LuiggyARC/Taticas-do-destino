extends Node2D

const BattleTileStyle = preload("res://Scene/battle_tile_style.gd")

var tile_size: int = 64


func setup(new_tile_size: int) -> void:
	tile_size = max(
		1,
		new_tile_size
	)
	
	name = "ActiveSpellAreaLayer"
	z_index = 25


func create_area_visual(
	cells: Array,
	center_position: Vector2i,
	effect: String,
	duration: int
) -> Dictionary:
	var visual_nodes: Array = []
	
	for cell_value in cells:
		var cell := Vector2i(cell_value)
		
		var fill_color: Color = get_area_color(effect)
		var tile: Panel = BattleTileStyle.create_tile(
			"ActiveSpellAreaTile",
			cell,
			tile_size,
			fill_color,
			Color(fill_color.r, fill_color.g, fill_color.b, 0.52),
			25
		)
		
		add_child(tile)
		visual_nodes.append(tile)
	
	var duration_label := Label.new()
	duration_label.name = (
		"ActiveSpellAreaDurationLabel"
	)
	duration_label.text = str(duration)
	duration_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)
	duration_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)
	duration_label.custom_minimum_size = Vector2(
		tile_size,
		tile_size
	)
	duration_label.size = Vector2(
		tile_size,
		tile_size
	)
	duration_label.position = Vector2(
		center_position.x * tile_size,
		center_position.y * tile_size
	)
	duration_label.z_index = 35
	duration_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	duration_label.add_theme_font_size_override(
		"font_size",
		22
	)
	duration_label.add_theme_color_override(
		"font_color",
		Color.WHITE
	)
	duration_label.add_theme_color_override(
		"font_outline_color",
		Color.BLACK
	)
	duration_label.add_theme_constant_override(
		"outline_size",
		4
	)
	
	add_child(duration_label)
	visual_nodes.append(duration_label)
	
	return {
		"visual_nodes": visual_nodes,
		"duration_label": duration_label
	}

func update_area_duration(
	area_data: Dictionary,
	turns_remaining: int
) -> void:
	var duration_label: Variant = area_data.get(
		"duration_label",
		null
	)
	
	if not is_instance_valid(duration_label):
		return
	
	duration_label.text = str(
		max(
			0,
			turns_remaining
		)
	)


func remove_area_visual(
	area_data: Dictionary
) -> void:
	var visual_nodes: Array = area_data.get(
		"visual_nodes",
		[]
	)
	
	for visual_node in visual_nodes:
		if is_instance_valid(visual_node):
			visual_node.queue_free()

func get_area_color(effect: String) -> Color:
	match effect:
		"control":
			return Color(
				0.45,
				0.15,
				1.0,
				0.28
			)
		
		"damage":
			return Color(
				1.0,
				0.15,
				0.05,
				0.25
			)
		
		"utility":
			return Color(
				1.0,
				1.0,
				1.0,
				0.20
			)
		
		"heal":
			return Color(
				0.0,
				1.0,
				0.25,
				0.20
			)
		
		"buff":
			return Color(
				0.0,
				0.35,
				1.0,
				0.22
			)
		
		_:
			return Color(
				1.0,
				1.0,
				1.0,
				0.20
			)
