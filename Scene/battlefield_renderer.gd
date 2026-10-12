extends Node2D

var tile_size: int = 64

var background_layer: Node2D
var grid_layer: Node2D


func setup(new_tile_size: int) -> void:
	tile_size = max(
		1,
		new_tile_size
	)
	
	name = "BattlefieldRenderer"
	
	create_layers()


func create_layers() -> void:
	background_layer = Node2D.new()
	background_layer.name = "MapBackgroundLayer"
	background_layer.z_index = -10
	
	add_child(background_layer)
	
	grid_layer = Node2D.new()
	grid_layer.name = "GridLayer"
	grid_layer.z_index = 0
	
	add_child(grid_layer)


func draw_background(
	image_path: String,
	grid_width: int,
	grid_height: int
) -> bool:
	clear_background()
	
	if image_path.strip_edges() == "":
		return false
	
	var texture: Texture2D = load(image_path)
	
	if not is_instance_valid(texture):
		print(
			"Imagem de fundo do cenário não encontrada: ",
			image_path
		)
		return false
	
	var texture_size: Vector2 = (
		texture.get_size()
	)
	
	if (
		texture_size.x <= 0.0
		or texture_size.y <= 0.0
	):
		return false
	
	var background_sprite := Sprite2D.new()
	background_sprite.name = "ScenarioBackground"
	background_sprite.texture = texture
	background_sprite.centered = false
	background_sprite.position = Vector2.ZERO
	background_sprite.z_index = -10
	
	var map_width_pixels: float = float(
		grid_width * tile_size
	)
	
	var map_height_pixels: float = float(
		grid_height * tile_size
	)
	
	background_sprite.scale = Vector2(
		map_width_pixels / texture_size.x,
		map_height_pixels / texture_size.y
	)
	
	background_layer.add_child(
		background_sprite
	)
	
	return true


func clear_background() -> void:
	if not is_instance_valid(background_layer):
		return
	
	for child in background_layer.get_children():
		child.queue_free()


func draw_grid(
	grid_width: int,
	grid_height: int,
	terrain_types: Dictionary
) -> void:
	clear_grid()
	
	if not is_instance_valid(grid_layer):
		return
	
	for grid_x in range(grid_width):
		for grid_y in range(grid_height):
			var grid_position := Vector2i(
				grid_x,
				grid_y
			)
			
			var terrain_type: String = str(
				terrain_types.get(
					grid_position,
					"normal"
				)
			)
			
			var tile := ColorRect.new()
			tile.name = "GridTile"
			tile.size = Vector2(
				tile_size,
				tile_size
			)
			tile.position = Vector2(
				grid_x * tile_size,
				grid_y * tile_size
			)
			tile.mouse_filter = (
				Control.MOUSE_FILTER_IGNORE
			)
			tile.z_index = 0
			tile.color = get_terrain_color(
				terrain_type
			)
			
			grid_layer.add_child(tile)


func clear_grid() -> void:
	if not is_instance_valid(grid_layer):
		return
	
	for child in grid_layer.get_children():
		child.queue_free()


func get_terrain_color(
	terrain_type: String
) -> Color:
	match terrain_type:
		"blocked":
			return Color(
				0.05,
				0.05,
				0.05,
				0.45
			)
		
		"difficult":
			return Color(
				0.55,
				0.35,
				0.08,
				0.30
			)
		
		"danger":
			return Color(
				0.80,
				0.05,
				0.02,
				0.35
			)
		
		_:
			return Color(
				1.0,
				1.0,
				1.0,
				0.03
			)
