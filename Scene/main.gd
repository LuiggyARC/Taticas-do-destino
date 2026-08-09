extends Node2D

const TILE_SIZE := 64
const GRID_WIDTH := 15
const GRID_HEIGHT := 15

const STRAIGHT_MOVE_COST := 1.5
const DIAGONAL_MOVE_COST := 3.0
const SAVE_PATH := "user://savegame.json"
const AUTOSAVE_PATH := "user://autosave.json"
const MANUAL_SAVE_DIR := "user://manual_saves/"
enum TurnState {
	HERO_TURN,
	ENEMY_TURN
}

var current_stage: int = 1
var loaded_player_presets := {}
var current_turn = TurnState.HERO_TURN
var grid_layer: Node2D
var movement_layer: Node2D
var ui_layer: CanvasLayer
var movement_label: Label
var end_turn_button: Button
var attack_button: Button
var enemy_label: Label
var hero: Node2D
var enemy: Node2D
var save_button: Button
var abandon_button: Button
var abandon_confirm_popup: ConfirmationDialog


func save_manual_game():
	var dir := DirAccess.open("user://")
	
	if dir == null:
		print("Erro ao acessar pasta user://")
		return
	
	if not dir.dir_exists("manual_saves"):
		dir.make_dir("manual_saves")
	
	var datetime := Time.get_datetime_dict_from_system()
	
	var file_name := "save_stage_" + str(current_stage) + "_"
	file_name += str(datetime.year) + "-"
	file_name += str(datetime.month).pad_zeros(2) + "-"
	file_name += str(datetime.day).pad_zeros(2) + "_"
	file_name += str(datetime.hour).pad_zeros(2) + "-"
	file_name += str(datetime.minute).pad_zeros(2) + "-"
	file_name += str(datetime.second).pad_zeros(2)
	file_name += ".json"
	
	var save_path := MANUAL_SAVE_DIR + file_name
	
	var save_data := {
		"current_stage": current_stage,
		"player_presets": {
			"hero_max_hp": hero.max_hp if is_instance_valid(hero) else 100,
			"hero_attack_power": hero.attack_power if is_instance_valid(hero) else 20,
			"hero_max_movement_meters": hero.max_movement_meters if is_instance_valid(hero) else 9.0
		}
	}
	
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	
	if file == null:
		print("Erro ao criar save manual.")
		return
	
	file.store_string(JSON.stringify(save_data))
	file.close()
	
	print("Save manual criado em: ", save_path)
	
func save_auto_game():
	var save_data := {
		"current_stage": current_stage,
		"player_presets": {
			"hero_max_hp": hero.max_hp if is_instance_valid(hero) else 100,
			"hero_attack_power": hero.attack_power if is_instance_valid(hero) else 20,
			"hero_max_movement_meters": hero.max_movement_meters if is_instance_valid(hero) else 9.0
		}
	}
	
	var file := FileAccess.open(AUTOSAVE_PATH, FileAccess.WRITE)
	
	if file == null:
		print("Erro ao criar autosave.")
		return
	
	file.store_string(JSON.stringify(save_data))
	file.close()
	
	print("Autosave criado. Stage atual: ", current_stage)
	
func load_progress():
	var save_path: String = GameState.selected_save_path
	
	if save_path == "":
		save_path = AUTOSAVE_PATH
	
	if not FileAccess.file_exists(save_path):
		print("Save não encontrado: ", save_path)
		current_stage = 1
		loaded_player_presets = {}
		return
	
	var file := FileAccess.open(save_path, FileAccess.READ)
	
	if file == null:
		print("Erro ao abrir save: ", save_path)
		current_stage = 1
		loaded_player_presets = {}
		return
	
	var json_text := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_text)
	
	if error != OK:
		print("Erro ao ler save: ", save_path)
		current_stage = 1
		loaded_player_presets = {}
		return
	
	var save_data = json.data
	
	current_stage = int(save_data.get("current_stage", 1))
	loaded_player_presets = save_data.get("player_presets", {})
	
	print("Save carregado: ", save_path)
	print("Stage salvo: ", current_stage)
	
func _ready():
	create_grid_layer()
	create_movement_layer()
	draw_grid()
	create_ui()
	
	
	hero = $Hero
	enemy = $Enemy
	
	if GameState.should_load_save:
		load_progress()
	else:
		current_stage = 1
	
	start_stage(current_stage)

func create_grid_layer():
	grid_layer = Node2D.new()
	grid_layer.name = "GridLayer"
	add_child(grid_layer)
	move_child(grid_layer, 0)

func create_movement_layer():
	movement_layer = Node2D.new()
	movement_layer.name = "MovementLayer"
	add_child(movement_layer)

func draw_grid():
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var tile := ColorRect.new()
			tile.size = Vector2(TILE_SIZE, TILE_SIZE)
			tile.position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			if (x + y) % 2 == 0:
				tile.color = Color(0.20, 0.45, 0.20)
			else:
				tile.color = Color(0.16, 0.38, 0.16)
			
			grid_layer.add_child(tile)

func create_ui():
	
	ui_layer = CanvasLayer.new()
	ui_layer.name = "UILayer"
	add_child(ui_layer)
	
	
	var panel := Panel.new()
	panel.name = "MovementPanel"
	panel.size = Vector2(320, 210)
	panel.position = Vector2(20, 20)
	ui_layer.add_child(panel)
	
	movement_label = Label.new()
	movement_label.name = "MovementLabel"
	movement_label.position = Vector2(12, 10)
	movement_label.size = Vector2(290, 70)
	panel.add_child(movement_label)
	
	enemy_label = Label.new()
	enemy_label.name = "EnemyLabel"
	enemy_label.position = Vector2(12, 80)
	enemy_label.size = Vector2(290, 40)
	panel.add_child(enemy_label)
	
	attack_button = Button.new()
	attack_button.name = "AttackButton"
	attack_button.text = "Atacar"
	attack_button.position = Vector2(12, 130)
	attack_button.size = Vector2(130, 35)
	attack_button.pressed.connect(hero_attack)
	panel.add_child(attack_button)
	
	end_turn_button = Button.new()
	end_turn_button.name = "EndTurnButton"
	end_turn_button.text = "Terminar Turno"
	
	end_turn_button.position = Vector2(155, 130)
	end_turn_button.size = Vector2(140, 35)
	end_turn_button.pressed.connect(end_hero_turn)
	panel.add_child(end_turn_button)
	save_button = Button.new()
	save_button.name = "SaveButton"
	save_button.text = "Salvar"
	save_button.position = Vector2(12, 180)
	save_button.size = Vector2(130, 35)
	save_button.pressed.connect(save_manual_game)
	panel.add_child(save_button)

	abandon_button = Button.new()
	abandon_button.name = "AbandonButton"
	abandon_button.text = "Abandonar"
	abandon_button.position = Vector2(155, 180)
	abandon_button.size = Vector2(140, 35)
	abandon_button.pressed.connect(show_abandon_confirmation)
	panel.add_child(abandon_button)
	abandon_confirm_popup = ConfirmationDialog.new()
	abandon_confirm_popup.name = "AbandonConfirmPopup"
	abandon_confirm_popup.title = "Abandonar partida"
	abandon_confirm_popup.dialog_text = "Deseja salvar o progresso e voltar para a tela inicial?"
	abandon_confirm_popup.ok_button_text = "Sim"
	abandon_confirm_popup.cancel_button_text = "Não"
	abandon_confirm_popup.size = Vector2(420, 160)
	abandon_confirm_popup.confirmed.connect(confirm_abandon_game)
	ui_layer.add_child(abandon_confirm_popup)

func update_movement_label():
	var turn_text = "Turno do Herói"
	
	if current_turn == TurnState.ENEMY_TURN:
		turn_text = "Turno do Inimigo"
	
	if is_instance_valid(hero):
		movement_label.text = (
			turn_text + "\n" +
			"Herói HP: " + str(hero.hp) + "/" + str(hero.max_hp) + "\n" +
			"Movimento: " + str(hero.current_movement_meters) + "/" + str(hero.max_movement_meters) + "m"
		)
	else:
		movement_label.text = "Herói derrotado"
	
	if is_instance_valid(enemy):
		enemy_label.text = "Inimigo HP: " + str(enemy.hp) + "/" + str(enemy.max_hp)
	else:
		enemy_label.text = "Inimigo derrotado"

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_position = get_global_mouse_position()
			var clicked_grid_position = world_to_grid(mouse_position)
			
			if is_inside_grid(clicked_grid_position):
				move_hero(clicked_grid_position)

func world_to_grid(world_position: Vector2) -> Vector2i:
	return Vector2i(
		int(world_position.x / TILE_SIZE),
		int(world_position.y / TILE_SIZE)
	)

func is_inside_grid(grid_position: Vector2i) -> bool:
	return (
		grid_position.x >= 0 and
		grid_position.x < GRID_WIDTH and
		grid_position.y >= 0 and
		grid_position.y < GRID_HEIGHT
	)

func move_hero(new_grid_position: Vector2i):
	if current_turn != TurnState.HERO_TURN:
		return
	
	var cost = get_movement_cost(hero.grid_position, new_grid_position)
	
	if cost <= 0:
		return
	
	if is_instance_valid(enemy):
		if new_grid_position == enemy.grid_position:
			print("Essa casa está ocupada pelo inimigo.")
			return 
	
	if cost <= hero.current_movement_meters:
		hero.grid_position = new_grid_position
		hero.current_movement_meters -= cost
		
		if hero.current_movement_meters < 0:
			hero.current_movement_meters = 0
		
		hero.update_world_position()
		show_movement_area()
		update_movement_label()
	else:
		print("Movimento inválido.")
		print("Custo: ", cost, "m")
		print("Restante: ", hero.current_movement_meters, "m")

func get_movement_cost(from_position: Vector2i, to_position: Vector2i) -> float:
	var dx = abs(to_position.x - from_position.x)
	var dy = abs(to_position.y - from_position.y)
	
	var diagonal_steps = min(dx, dy)
	var straight_steps = max(dx, dy) - diagonal_steps
	
	var total_cost = diagonal_steps * DIAGONAL_MOVE_COST + straight_steps * STRAIGHT_MOVE_COST
	
	return total_cost

func show_movement_area():
	clear_movement_area()
	
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var grid_position := Vector2i(x, y)
			var cost = get_movement_cost(hero.grid_position, grid_position)
			
			if cost > 0 and cost <= hero.current_movement_meters:
				create_movement_highlight(grid_position, cost)

func clear_movement_area():
	for child in movement_layer.get_children():
		child.queue_free()

func create_movement_highlight(grid_position: Vector2i, cost: float):
	var highlight := ColorRect.new()
	highlight.size = Vector2(TILE_SIZE, TILE_SIZE)
	highlight.position = Vector2(grid_position.x * TILE_SIZE, grid_position.y * TILE_SIZE)
	highlight.color = Color(0.2, 0.6, 1.0, 0.35)
	highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	movement_layer.add_child(highlight)

func end_hero_turn():
	if current_turn != TurnState.HERO_TURN:
		return
	
	print("Turno do herói encerrado.")
	current_turn = TurnState.ENEMY_TURN
	
	clear_movement_area()
	update_movement_label()
	
	await get_tree().create_timer(0.5).timeout
	
	await enemy_turn()

func hero_attack():
	if current_turn != TurnState.HERO_TURN:
		return
	
	if not is_instance_valid(enemy):
		print("Não há inimigo para atacar.")
		return
	
	if hero.has_attacked:
		print("O herói já atacou neste turno.")
		return
	
	var distance = get_attack_distance(hero.grid_position, enemy.grid_position)
	
	if distance <= 1:
		enemy.take_damage(hero.attack_power)
		hero.has_attacked = true
		update_movement_label()
	else:
		print("Inimigo fora de alcance.")
		print("Aproxime-se para atacar.")

func get_attack_distance(from_position: Vector2i, to_position: Vector2i) -> int:
	var dx = abs(to_position.x - from_position.x)
	var dy = abs(to_position.y - from_position.y)
	
	return max(dx, dy)

func enemy_turn():
	if not is_instance_valid(enemy):
		start_hero_turn()
		return
	
	if not is_instance_valid(hero):
		return
	
	print("Turno do inimigo.")
	
	enemy.reset_movement()
	
	if can_enemy_attack_hero():
		enemy_attack_hero()
		await get_tree().create_timer(0.5).timeout
		start_hero_turn()
		return
	
	var best_position = choose_best_enemy_position()
	
	if best_position != enemy.grid_position:
		move_enemy_to(best_position)
		await get_tree().create_timer(0.5).timeout
	
	if can_enemy_attack_hero():
		enemy_attack_hero()
	
	await get_tree().create_timer(0.5).timeout
	start_hero_turn()

func can_enemy_attack_hero() -> bool:
	if not is_instance_valid(enemy):
		return false
	
	if not is_instance_valid(hero):
		return false
	
	var distance = get_attack_distance(enemy.grid_position, hero.grid_position)
	return distance <= 1

func enemy_attack_hero():
	if not is_instance_valid(hero):
		return
	
	print("Inimigo atacou o herói.")
	hero.take_damage(enemy.attack_power)
	update_movement_label()

func move_enemy_to(new_grid_position: Vector2i):
	var cost = get_movement_cost(enemy.grid_position, new_grid_position)
	
	if cost <= enemy.current_movement_meters:
		enemy.grid_position = new_grid_position
		enemy.current_movement_meters -= cost
		enemy.update_world_position()
		
		print("Inimigo moveu para: ", new_grid_position)
		print("Custo do movimento inimigo: ", cost, "m")
		
func choose_best_enemy_position() -> Vector2i:
	var best_position = enemy.grid_position
	var best_score = -999999.0
	
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var test_position := Vector2i(x, y)
			
			if not is_valid_enemy_move_position(test_position):
				continue
			
			var score = evaluate_enemy_position(test_position)
			
			if score > best_score:
				best_score = score
				best_position = test_position
	
	print("Melhor posição escolhida pela IA: ", best_position, " | Pontuação: ", best_score)
	return best_position

func is_valid_enemy_move_position(test_position: Vector2i) -> bool:
	if not is_inside_grid(test_position):
		return false
	
	if test_position == hero.grid_position:
		return false
	
	var cost = get_movement_cost(enemy.grid_position, test_position)
	
	if cost > enemy.current_movement_meters:
		return false
	
	return true

func evaluate_enemy_position(test_position: Vector2i) -> float:
	var score = 0.0
	
	var distance_to_hero = get_attack_distance(test_position, hero.grid_position)
	var movement_cost = get_movement_cost(enemy.grid_position, test_position)
	
	# 1. Prioridade máxima: ficar em alcance de ataque
	if distance_to_hero <= 1:
		score += 1000.0
	
	# 2. Aproximar do herói
	score -= distance_to_hero * 20.0
	
	# 3. Gastar menos movimento é levemente melhor
	score -= movement_cost * 2.0
	
	# 4. Evitar ficar exatamente colado se não puder atacar bem futuramente
	if distance_to_hero == 0:
		score -= 500.0
	
	# 5. Pontos futuros para terreno
	score += get_terrain_score_for_enemy(test_position)
	
	return score
func get_terrain_score_for_enemy(test_position: Vector2i) -> float:
	var score = 0.0
	
	# Futuramente:
	# terreno alto: +80
	# cobertura: +60
	# terreno difícil: -40
	# lava/veneno: -200
	# posição exposta: -30
	
	return score
	
func start_hero_turn():
	if not is_instance_valid(hero):
		return
	
	print("Novo turno do herói.")
	current_turn = TurnState.HERO_TURN
	
	hero.reset_movement()
	show_movement_area()
	update_movement_label()

func check_opportunity_attack(mover: Node2D, defender: Node2D, new_position: Vector2i):
	if not is_instance_valid(mover):
		return
	
	if not is_instance_valid(defender):
		return
	
	var was_in_attack_area = get_attack_distance(mover.grid_position, defender.grid_position) <= 1
	var will_be_in_attack_area = get_attack_distance(new_position, defender.grid_position) <= 1
	
	if was_in_attack_area and not will_be_in_attack_area:
		opportunity_attack(defender, mover)

func opportunity_attack(attacker: Node2D, target: Node2D):
	if not is_instance_valid(attacker):
		return
	
	if not is_instance_valid(target):
		return
	
	if attacker.has_opportunity_attacked:
		print("Esse personagem já usou ataque de oportunidade.")
		return
	
	print("Ataque de oportunidade!")
	
	target.take_damage(attacker.attack_power)
	attacker.has_opportunity_attacked = true
	
	update_movement_label()
func start_stage(stage_number: int):
	current_stage = stage_number
	current_turn = TurnState.HERO_TURN
	
	reset_stage_units(stage_number)
	apply_player_presets()
	
	show_movement_area()
	update_movement_label()
	
	print("Iniciando Stage ", current_stage)
func reset_stage_units(stage_number: int):
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(enemy):
		return
	
	if stage_number == 1:
		hero.grid_position = Vector2i(7, 7)
		hero.hp = hero.max_hp
		hero.current_movement_meters = hero.max_movement_meters
		hero.has_attacked = false
		hero.has_opportunity_attacked = false
		hero.update_world_position()
		
		enemy.grid_position = Vector2i(10, 7)
		enemy.hp = enemy.max_hp
		enemy.current_movement_meters = enemy.max_movement_meters
		enemy.has_opportunity_attacked = false
		enemy.update_world_position()
	
	elif stage_number == 2:
		hero.grid_position = Vector2i(2, 7)
		hero.hp = hero.max_hp
		hero.current_movement_meters = hero.max_movement_meters
		hero.has_attacked = false
		hero.has_opportunity_attacked = false
		hero.update_world_position()
		
		enemy.grid_position = Vector2i(12, 7)
		enemy.hp = enemy.max_hp
		enemy.current_movement_meters = enemy.max_movement_meters
		enemy.has_opportunity_attacked = false
		enemy.update_world_position()
func apply_player_presets():
	if not is_instance_valid(hero):
		return
	
	if loaded_player_presets.is_empty():
		return
	
	hero.max_hp = int(loaded_player_presets.get("hero_max_hp", hero.max_hp))
	hero.attack_power = int(loaded_player_presets.get("hero_attack_power", hero.attack_power))
	hero.max_movement_meters = float(loaded_player_presets.get("hero_max_movement_meters", hero.max_movement_meters))
	
	hero.hp = hero.max_hp
	hero.current_movement_meters = hero.max_movement_meters
func show_abandon_confirmation():
	abandon_confirm_popup.popup_centered()

func confirm_abandon_game():
	save_auto_game()
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
