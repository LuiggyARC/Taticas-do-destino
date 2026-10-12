extends RefCounted

static var _style_cache: Dictionary = {}


static func create_tile(
	tile_name: String,
	grid_position: Vector2i,
	tile_size: int,
	fill_color: Color,
	border_color: Color,
	z_order: int
) -> Panel:
	var tile := Panel.new()
	tile.name = tile_name
	var inset: float = clampf(float(tile_size) * 0.025, 1.0, 2.0)
	tile.position = Vector2(grid_position * tile_size) + Vector2.ONE * inset
	tile.size = Vector2.ONE * maxf(1.0, float(tile_size) - inset * 2.0)
	tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.z_index = z_order
	tile.add_theme_stylebox_override(
		"panel",
		_get_style(fill_color, border_color, tile_size)
	)
	return tile


static func _get_style(
	fill_color: Color,
	border_color: Color,
	tile_size: int
) -> StyleBoxFlat:
	var border_width: int = maxi(1, roundi(float(tile_size) / 32.0))
	var corner_radius: int = maxi(3, roundi(float(tile_size) * 0.10))
	var key: String = "%s:%s:%d:%d" % [
		fill_color.to_html(true),
		border_color.to_html(true),
		border_width,
		corner_radius
	]
	if _style_cache.has(key):
		return _style_cache[key] as StyleBoxFlat

	var style := StyleBoxFlat.new()
	style.bg_color = fill_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	style.anti_aliasing = true
	_style_cache[key] = style
	return style
