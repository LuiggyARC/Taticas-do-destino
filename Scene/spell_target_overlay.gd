extends Node2D

const BattleTileStyle = preload("res://Scene/battle_tile_style.gd")

var tile_size: int = 64


func setup(new_tile_size: int) -> void:
	tile_size = max(
		1,
		new_tile_size
	)
	
	name = "SpellTargetLayer"
	z_index = 50


func clear_tiles() -> void:
	for child in get_children():
		child.queue_free()


func create_range_tile(grid_position: Vector2i, feedback_type: String) -> void:
	var color: Color = get_feedback_color(feedback_type, 0.32)
	var tile: Panel = BattleTileStyle.create_tile(
		"SpellRangeTile",
		grid_position,
		tile_size,
		color,
		Color(color.r, color.g, color.b, 0.55),
		55
	)
	add_child(tile)


func create_target_tile(
	grid_position: Vector2i,
	feedback_type: String
) -> void:
	var fill_color: Color = get_feedback_color(feedback_type, 0.55)
	var tile: Panel = BattleTileStyle.create_tile(
		"SpellTargetTile",
		grid_position,
		tile_size,
		fill_color,
		Color(fill_color.r, fill_color.g, fill_color.b, 0.90),
		60
	)
	
	add_child(tile)


func show_impact(
	cells: Array,
	feedback_type: String
) -> void:
	for cell_value in cells:
		var cell := Vector2i(cell_value)
		
		var fill_color: Color = get_feedback_color(feedback_type, 0.75)
		var tile: Panel = BattleTileStyle.create_tile(
			"SpellImpactTile",
			cell,
			tile_size,
			fill_color,
			Color(fill_color.r, fill_color.g, fill_color.b, 1.0),
			80
		)
		
		add_child(tile)
		
		var tween := create_tween()
		tween.tween_property(
			tile,
			"modulate:a",
			0.0,
			0.45
		)
		tween.tween_callback(
			tile.queue_free
		)


func get_feedback_color(
	feedback_type: String,
	alpha: float
) -> Color:
	match feedback_type:
		"heal":
			return Color(
				0.0,
				1.0,
				0.25,
				alpha
			)
		
		"damage":
			return Color(
				1.0,
				0.0,
				0.0,
				alpha
			)
		
		"buff":
			return Color(
				0.0,
				0.35,
				1.0,
				alpha
			)
		
		"control":
			return Color(
				0.60,
				0.20,
				1.0,
				alpha
			)
		
		"utility":
			return Color(
				1.0,
				1.0,
				1.0,
				max(
					0.0,
					alpha - 0.20
				)
			)
		
		_:
			return Color(
				1.0,
				1.0,
				1.0,
				max(
					0.0,
					alpha - 0.20
				)
			)
