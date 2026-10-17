extends RefCounted

# A arte continua sendo uma imagem; estas formas são a camada jogável por cima dela.
const MAP_PATH := "res://Assets/Maps/Cidadela.jpg"
const MAP_SIZE := Vector2i(2048, 1536)
const TILE_SIZE := 64
const GRID_SIZE := Vector2i(32, 24)
const METERS_PER_TILE := 1.5
const ANIRI_VISION_METERS := 8.0
const CULTIST_VISION_METERS := 6.0
const VISION_CONE_DOT := 0.35
const PLAYER_MOVE_TILES := 6
const GUARD_MOVE_TILES := 3
const MISSION_ID := "shadows_citadel"

# Entrada no corredor superior esquerdo, ao lado da sala do baú.
const START := Vector2i(1, 2)
const BEDROOM_CLUE := Vector2i(5, 13)
const STRATEGY_CLUE := Vector2i(25, 17)
const CHEST := Vector2i(9, 3)
const GLASS := [Vector2i(8, 3), Vector2i(1, 7), Vector2i(1, 17), Vector2i(20, 21)]

const GUARDS := [
	{"name": "Cultista 1", "role": "Corredor oeste", "start": Vector2i(13, 5), "route": [Vector2i(13, 5), Vector2i(15, 5), Vector2i(15, 9), Vector2i(13, 9)]},
	{"name": "Cultista 2", "role": "Corredor central", "start": Vector2i(18, 16), "route": [Vector2i(18, 16), Vector2i(19, 19), Vector2i(17, 19), Vector2i(17, 13)]},
	{"name": "Cultista 3", "role": "Cozinha", "start": Vector2i(2, 20), "route": [Vector2i(2, 20), Vector2i(2, 22), Vector2i(9, 22), Vector2i(11, 22)]},
	{"name": "Cultista 4", "role": "Corredor dos dormitórios", "start": Vector2i(19, 8), "route": [Vector2i(19, 8), Vector2i(19, 12), Vector2i(20, 12), Vector2i(20, 8)]}
]

const WALLS := [
	Rect2(0, 0, 2048, 45), Rect2(0, 0, 45, 1536),
	Rect2(2000, 0, 48, 1536), Rect2(0, 1490, 2048, 46),
	# Depósito dos barris.
	Rect2(110, 0, 44, 405), Rect2(720, 0, 54, 395), Rect2(115, 358, 500, 50),
	# Quarto com cama e mesa; a abertura está ao sul.
	Rect2(118, 480, 705, 52), Rect2(118, 485, 54, 510),
	Rect2(765, 490, 54, 520), Rect2(120, 968, 385, 52),
	# Parede longa que separa os dois corredores principais.
	Rect2(1040, 240, 58, 950),
	# Ala dos dormitórios: abertura ao norte da curva.
	Rect2(1375, 240, 55, 710), Rect2(1400, 934, 600, 58),
	# Sala da mesa e seis tocos: entrada a leste da parede curva.
	Rect2(1375, 947, 55, 310),
	Rect2(1400, 1260, 170, 60), Rect2(1550, 1235, 110, 58),
	# Divisória superior do refeitório, com acesso pela direita.
	Rect2(45, 1168, 995, 55)
]

const FURNITURE := [
	# Barris e caixotes do depósito.
	Rect2(180, 85, 120, 235), Rect2(320, 85, 165, 225), Rect2(570, 80, 110, 100),
	# Mantém a passagem junto à extremidade norte da parede central.
	Rect2(830, 55, 120, 190),
	# Cama, mesa e caixas do quarto da primeira pista.
	Rect2(175, 535, 205, 175), Rect2(175, 745, 110, 205),
	Rect2(625, 555, 118, 145),
	# Camas dos dormitórios.
	Rect2(1430, 270, 210, 185), Rect2(1430, 465, 185, 195),
	Rect2(1460, 665, 185, 185), Rect2(1770, 260, 185, 205),
	Rect2(1760, 430, 185, 205), Rect2(1785, 610, 170, 205),
	# Refeitório/cozinha.
	Rect2(285, 1300, 530, 105),
	# Mesa de planos e tocos de madeira.
	Rect2(1450, 1020, 145, 260), Rect2(1810, 1035, 145, 245)
]


static func cell_center(cell: Vector2i) -> Vector2:
	return Vector2(cell) * TILE_SIZE + Vector2.ONE * (TILE_SIZE * 0.5)


static func inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < GRID_SIZE.x and cell.y < GRID_SIZE.y


static func blocked(cell: Vector2i) -> bool:
	if not inside(cell):
		return true
	var point: Vector2 = cell_center(cell)
	for wall in WALLS:
		if wall.has_point(point):
			return true
	for furniture in FURNITURE:
		if furniture.has_point(point):
			return true
	return false


static func distance_meters(a: Vector2i, b: Vector2i) -> float:
	return Vector2(a).distance_to(Vector2(b)) * METERS_PER_TILE


static func observe_succeeds(observe_roll: int, observe_bonus: int, hide_roll: int, hide_bonus: int) -> bool:
	# Em empate, o observador percebe a personagem escondida.
	return observe_roll + observe_bonus >= hide_roll + hide_bonus


static func has_line_of_sight(a: Vector2i, b: Vector2i) -> bool:
	if not inside(a) or not inside(b):
		return false
	if a == b:
		return true
	var from_point: Vector2 = cell_center(a)
	var to_point: Vector2 = cell_center(b)
	var bounds := Rect2(
		Vector2(minf(from_point.x, to_point.x), minf(from_point.y, to_point.y)),
		Vector2(absf(to_point.x - from_point.x) + 1.0, absf(to_point.y - from_point.y) + 1.0)
	)
	var occluders: Array[Rect2] = []
	for wall in WALLS:
		if wall.intersects(bounds):
			occluders.append(wall)
	for furniture in FURNITURE:
		if furniture.intersects(bounds):
			occluders.append(furniture)
	var steps: int = maxi(1, ceili(from_point.distance_to(to_point) / 8.0))
	for index in range(1, steps):
		var sample: Vector2 = from_point.lerp(to_point, float(index) / float(steps))
		for obstacle in occluders:
			if obstacle.has_point(sample):
				return false
	return true


static func can_see(viewer: Vector2i, target: Vector2i, range_meters: float) -> bool:
	return distance_meters(viewer, target) <= range_meters and has_line_of_sight(viewer, target)


static func cover_near(cell: Vector2i) -> bool:
	for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
		var neighbor: Vector2i = cell + offset
		if not inside(neighbor):
			continue
		var point: Vector2 = cell_center(neighbor)
		for furniture in FURNITURE:
			if furniture.has_point(point):
				return true
	return false


static func nearest_walkable(target: Vector2i) -> Vector2i:
	if not blocked(target):
		return target
	for radius in range(1, 8):
		for y in range(-radius, radius + 1):
			for x in range(-radius, radius + 1):
				var option := target + Vector2i(x, y)
				if not blocked(option):
					return option
	return START


static func path(from_cell: Vector2i, to_cell: Vector2i, occupied: Array[Vector2i] = []) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if blocked(from_cell) or blocked(to_cell) or to_cell in occupied:
		return result
	if from_cell == to_cell:
		return result
	var frontier: Array[Vector2i] = [from_cell]
	var parents: Dictionary = {from_cell: from_cell}
	var head: int = 0
	while head < frontier.size():
		var current: Vector2i = frontier[head]
		head += 1
		if current == to_cell:
			break
		for direction in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
			var neighbor: Vector2i = current + direction
			if blocked(neighbor) or neighbor in occupied or parents.has(neighbor):
				continue
			parents[neighbor] = current
			frontier.append(neighbor)
	if not parents.has(to_cell):
		return result
	var step: Vector2i = to_cell
	while step != from_cell:
		result.push_front(step)
		step = parents[step]
	return result


static func adjacent_or_same(a: Vector2i, b: Vector2i) -> bool:
	return absi(a.x - b.x) + absi(a.y - b.y) <= 1


static func validate_layout() -> Array[String]:
	var errors: Array[String] = []
	for key_cell in [START, BEDROOM_CLUE, STRATEGY_CLUE, CHEST]:
		if blocked(key_cell):
			errors.append("Ponto essencial bloqueado: %s" % str(key_cell))
	for objective in [BEDROOM_CLUE, STRATEGY_CLUE, CHEST]:
		if path(START, objective).is_empty():
			errors.append("Objetivo inacessível desde a entrada: %s" % str(objective))
	for guard in GUARDS:
		if blocked(guard["start"]):
			errors.append("Cultista bloqueado: %s" % str(guard["name"]))
		for waypoint in guard["route"]:
			if blocked(waypoint):
				errors.append("Rota bloqueada: %s %s" % [guard["name"], str(waypoint)])
	return errors
