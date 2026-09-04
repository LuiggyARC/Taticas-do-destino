extends Node2D

const TILE_SIZE := 64
const GRID_WIDTH := 15
const GRID_HEIGHT := 15

const STRAIGHT_MOVE_COST := 1.5
const DIAGONAL_MOVE_COST := 3.0
const SETTINGS_PATH := "user://settings.json"
const SFX_BUS_NAME := "SFX"
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
var class_skill_button: Button
var enemy_label: Label
var hero: Node2D
var enemy: Node2D
var save_button: Button
var abandon_button: Button
var abandon_confirm_popup: ConfirmationDialog
var settings_popup: PopupPanel
var credits_popup: AcceptDialog

var master_volume_slider: HSlider
var sfx_volume_slider: HSlider
var language_option: OptionButton

var settings_data := {
	"master_volume": 100.0,
	"sfx_volume": 100.0,
	"language": "pt"
}


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
		"player_name": hero.character_name if is_instance_valid(hero) else GameState.player_name,
		"player_class": hero.character_class if is_instance_valid(hero) else GameState.player_class,
		"hero_level": hero.level if is_instance_valid(hero) else GameState.hero_level,
		"hero_total_xp": hero.total_xp if is_instance_valid(hero) else GameState.hero_total_xp,
		"hero_xp_to_next_level": hero.xp_to_next_level if is_instance_valid(hero) else GameState.hero_xp_to_next_level,
		"hero_max_hp": hero.max_hp if is_instance_valid(hero) else GameState.hero_max_hp,
		"hero_attack_power": hero.attack_power if is_instance_valid(hero) else GameState.hero_attack_power,
		"hero_max_movement_meters": hero.max_movement_meters if is_instance_valid(hero) else GameState.hero_max_movement_meters,
		"hero_strength": hero.strength if is_instance_valid(hero) else GameState.hero_strength,
		"hero_dexterity": hero.dexterity if is_instance_valid(hero) else GameState.hero_dexterity,
		"hero_constitution": hero.constitution if is_instance_valid(hero) else GameState.hero_constitution,
		"hero_wisdom": hero.wisdom if is_instance_valid(hero) else GameState.hero_wisdom,
		"hero_intelligence": hero.intelligence if is_instance_valid(hero) else GameState.hero_intelligence,
		"hero_charisma": hero.charisma if is_instance_valid(hero) else GameState.hero_charisma,
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
	"player_name": GameState.player_name,
	"player_class": GameState.player_class,
	"hero_max_hp": hero.max_hp if is_instance_valid(hero) else 100,
	"hero_attack_power": hero.attack_power if is_instance_valid(hero) else 20,
	"hero_max_movement_meters": hero.max_movement_meters if is_instance_valid(hero) else 9.0,
	"hero_strength": hero.strength if is_instance_valid(hero) else GameState.hero_strength,
	"hero_dexterity": hero.dexterity if is_instance_valid(hero) else GameState.hero_dexterity,
	"hero_constitution": hero.constitution if is_instance_valid(hero) else GameState.hero_constitution,
	"hero_wisdom": hero.wisdom if is_instance_valid(hero) else GameState.hero_wisdom,
	"hero_intelligence": hero.intelligence if is_instance_valid(hero) else GameState.hero_intelligence,
	"hero_charisma": hero.charisma if is_instance_valid(hero) else GameState.hero_charisma,
}
	}
	
	var file := FileAccess.open(AUTOSAVE_PATH, FileAccess.WRITE)
	
	if file == null:
		print("Erro ao criar autosave.")
		return
	
	file.store_string(JSON.stringify(save_data))
	file.close()
	
	print("Autosave criado. Stage atual: ", current_stage)
	GameState.hero_strength = int(loaded_player_presets.get("hero_strength", 10))
	GameState.hero_dexterity = int(loaded_player_presets.get("hero_dexterity", 10))
	GameState.hero_constitution = int(loaded_player_presets.get("hero_constitution", 10))
	GameState.hero_wisdom = int(loaded_player_presets.get("hero_wisdom", 10))
	GameState.hero_intelligence = int(loaded_player_presets.get("hero_intelligence", 10))
	GameState.hero_charisma = int(loaded_player_presets.get("hero_charisma", 10))
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
	GameState.player_name = str(loaded_player_presets.get("player_name", "Herói"))
	GameState.player_class = str(loaded_player_presets.get("player_class", "Guerreiro"))

	GameState.hero_level = int(loaded_player_presets.get("hero_level", 1))
	GameState.hero_total_xp = int(loaded_player_presets.get("hero_total_xp", 0))
	GameState.hero_xp_to_next_level = int(loaded_player_presets.get("hero_xp_to_next_level", 1000))

	GameState.hero_max_hp = int(loaded_player_presets.get("hero_max_hp", 100))
	GameState.hero_attack_power = int(loaded_player_presets.get("hero_attack_power", 20))
	GameState.hero_max_movement_meters = float(loaded_player_presets.get("hero_max_movement_meters", 9.0))
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
	panel.name = "BattleHUD"
	panel.position = Vector2(20, 700)
	panel.size = Vector2(850, 170)
	ui_layer.add_child(panel)
	
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.0, 0.0, 0.0, 0.55)
	panel_style.border_color = Color(1.0, 1.0, 1.0, 0.25)
	panel_style.border_width_left = 1
	panel_style.border_width_top = 1
	panel_style.border_width_right = 1
	panel_style.border_width_bottom = 1
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8
	panel.add_theme_stylebox_override("panel", panel_style)
	
	# DADOS DO HERÓI
	movement_label = Label.new()
	movement_label.name = "MovementLabel"
	movement_label.position = Vector2(20, 15)
	movement_label.size = Vector2(360, 70)
	movement_label.add_theme_color_override("font_color", Color.WHITE)
	panel.add_child(movement_label)
	
	# DADOS DO INIMIGO
	enemy_label = Label.new()
	enemy_label.name = "EnemyLabel"
	enemy_label.position = Vector2(430, 15)
	enemy_label.size = Vector2(360, 70)
	enemy_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.85))
	panel.add_child(enemy_label)
	
	# LINHA DE BOTÕES
	var button_row := HBoxContainer.new()
	button_row.name = "ButtonRow"
	button_row.position = Vector2(20, 105)
	button_row.size = Vector2(810, 45)
	button_row.add_theme_constant_override("separation", 10)
	panel.add_child(button_row)
	
	attack_button = Button.new()
	attack_button.name = "AttackButton"
	attack_button.text = "Ataque"
	attack_button.custom_minimum_size = Vector2(110, 38)
	attack_button.pressed.connect(hero_attack)
	button_row.add_child(attack_button)
	
	class_skill_button = Button.new()
	class_skill_button.name = "ClassSkillButton"
	class_skill_button.text = "Habilidade"
	class_skill_button.custom_minimum_size = Vector2(120, 38)
	class_skill_button.pressed.connect(use_class_skill)
	button_row.add_child(class_skill_button)

	var magic_button := Button.new()
	magic_button.name = "MagicButton"
	magic_button.text = "Magia"
	magic_button.custom_minimum_size = Vector2(110, 38)
	magic_button.disabled = true
	button_row.add_child(magic_button)
	
	var items_button := Button.new()
	items_button.name = "ItemsButton"
	items_button.text = "Itens"
	items_button.custom_minimum_size = Vector2(110, 38)
	items_button.disabled = true
	button_row.add_child(items_button)
	
	end_turn_button = Button.new()
	end_turn_button.name = "EndTurnButton"
	end_turn_button.text = "Terminar Turno"
	end_turn_button.custom_minimum_size = Vector2(150, 38)
	end_turn_button.pressed.connect(end_hero_turn)
	button_row.add_child(end_turn_button)
	
	save_button = Button.new()
	save_button.name = "SaveButton"
	save_button.text = "Salvar"
	save_button.custom_minimum_size = Vector2(110, 38)
	save_button.pressed.connect(save_manual_game)
	button_row.add_child(save_button)
	
	abandon_button = Button.new()
	abandon_button.name = "AbandonButton"
	abandon_button.text = "Sair"
	abandon_button.custom_minimum_size = Vector2(110, 38)
	abandon_button.pressed.connect(show_abandon_confirmation)
	button_row.add_child(abandon_button)
	
	abandon_confirm_popup = ConfirmationDialog.new()
	abandon_confirm_popup.name = "AbandonConfirmPopup"
	abandon_confirm_popup.title = "Abandonar partida"
	abandon_confirm_popup.dialog_text = "Deseja salvar o progresso e voltar para a tela inicial?"
	abandon_confirm_popup.ok_button_text = "Sim"
	abandon_confirm_popup.cancel_button_text = "Não"
	abandon_confirm_popup.size = Vector2(420, 160)
	abandon_confirm_popup.confirmed.connect(confirm_abandon_game)
	ui_layer.add_child(abandon_confirm_popup)
	
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
	
	if is_instance_valid(hero):
		hero.update_rage_turn()
	
	current_turn = TurnState.ENEMY_TURN
	print("Turno do herói encerrado.")
	update_movement_label()
	enemy_turn()
func hero_attack():
	if current_turn != TurnState.HERO_TURN:
		return
	
	if not is_instance_valid(enemy):
		print("Não há inimigo para atacar.")
		return
	
	if hero.has_attacked:
		print("O herói já atacou neste turno.")
		return
	
	if hero.weapon_requires_reload() and hero.weapon_needs_reload:
		print(hero.equipped_weapon, " precisa recarregar.")
		print("Recarregando. O personagem perde o movimento neste turno.")
		hero.weapon_needs_reload = false
		hero.current_movement_meters = 0
		hero.has_attacked = true
		show_movement_area()
		update_movement_label()
		return
	
	var distance_in_tiles = get_attack_distance(hero.grid_position, enemy.grid_position)
	var distance_in_meters = distance_in_tiles * STRAIGHT_MOVE_COST
	var weapon_range = hero.get_weapon_range_meters()
	
	if distance_in_meters > weapon_range:
		print("Inimigo fora de alcance.")
		print("Distância: ", distance_in_meters, "m")
		print("Alcance da arma: ", weapon_range, "m")
		return
	
	var dice_roll: int = randi_range(1, 20)
	var attack_bonus: int = int(hero.get_weapon_attack_bonus())
	var damage_bonus: int = 0
	
	var using_smite_evil := false
	
	if hero.can_use_smite_evil():
		using_smite_evil = true
		attack_bonus += hero.get_smite_evil_attack_bonus()
		damage_bonus += hero.get_smite_evil_damage_bonus()
		hero.use_smite_evil()
	
	var attack_total: int = dice_roll + attack_bonus
	var target_ac: int = int(enemy.get_armor_class())
	var critical_min: int = int(hero.get_weapon_critical_min())
	var critical_multiplier: int = int(hero.get_weapon_critical_multiplier())
	
	print("Arma usada: ", hero.get_weapon_description())
	print("Ataque do herói: d20=", dice_roll, " + bônus=", attack_bonus, " total=", attack_total, " contra CA ", target_ac)
	
	if dice_roll == 1:
		print("Falha crítica. O herói errou.")
	elif dice_roll == 20 or attack_total >= target_ac:
		var final_damage: int = int(hero.roll_total_weapon_damage()) + damage_bonus
		
		var target_is_vulnerable := false
		
		if can_hero_sneak_attack_enemy():
			target_is_vulnerable = true
		
		if hero.can_sneak_attack(target_is_vulnerable):
			var sneak_damage: int = int(hero.get_sneak_attack_damage())
			final_damage += sneak_damage
			print("Ataque Furtivo! Dano extra: ", sneak_damage)
		
		if dice_roll >= critical_min:
			final_damage *= critical_multiplier
			hero.damage = final_damage
			print("Acerto crítico! Dano multiplicado x", critical_multiplier)
		
		if using_smite_evil:
			print("Destruir o Mal aplicado! Bônus de dano: ", damage_bonus)
		
		print("O herói acertou e causou ", final_damage, " de dano.")
		enemy.take_damage(final_damage)
		
		if hero.weapon_requires_reload():
			hero.weapon_needs_reload = true
	else:
		print("O herói errou o ataque.")
	
	hero.has_attacked = true
	
	if not is_instance_valid(enemy) or enemy.hp <= 0:
		grant_hero_xp(1000)
	
	update_movement_label()
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
	
	var distance_in_tiles = get_attack_distance(enemy.grid_position, hero.grid_position)
	var distance_in_meters = distance_in_tiles * STRAIGHT_MOVE_COST
	var weapon_range = enemy.get_weapon_range_meters()
	
	return distance_in_meters <= weapon_range

func enemy_attack_hero():
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(enemy):
		return
	
	if enemy.weapon_requires_reload() and enemy.weapon_needs_reload:
		print(enemy.equipped_weapon, " do inimigo precisa recarregar.")
		print("Inimigo recarregou e perdeu o movimento.")
		enemy.weapon_needs_reload = false
		enemy.current_movement_meters = 0
		update_movement_label()
		return
	
	var distance_in_tiles = get_attack_distance(enemy.grid_position, hero.grid_position)
	var distance_in_meters = distance_in_tiles * STRAIGHT_MOVE_COST
	var weapon_range = enemy.get_weapon_range_meters()
	
	if distance_in_meters > weapon_range:
		print("Herói fora do alcance da arma do inimigo.")
		print("Distância: ", distance_in_meters, "m")
		print("Alcance inimigo: ", weapon_range, "m")
		return
	
	var dice_roll: int = randi_range(1, 20)
	var attack_total: int = dice_roll + int(enemy.get_weapon_attack_bonus())
	var target_ac: int = int(hero.get_armor_class())
	var critical_min: int = int(enemy.get_weapon_critical_min())
	var critical_multiplier: int = int(enemy.get_weapon_critical_multiplier())
	print("Arma do inimigo: ", enemy.get_weapon_description())
	print("Ataque do inimigo: d20=", dice_roll, " + bônus=", enemy.get_weapon_attack_bonus(), " total=", attack_total, " contra CA ", target_ac)
	
	if dice_roll == 1:
		print("Falha crítica. O inimigo errou.")
	elif dice_roll == 20 or attack_total >= target_ac:
		var final_damage: int = int(enemy.roll_total_weapon_damage())
		
		if dice_roll >= critical_min:
			final_damage *= critical_multiplier
			enemy.damage = final_damage
			print("Crítico do inimigo! Dano x", critical_multiplier)
		
		print("Inimigo acertou e causou ", final_damage, " de dano.")
		hero.take_damage(final_damage)
		
		if enemy.weapon_requires_reload():
			enemy.weapon_needs_reload = true
	else:
		print("Inimigo errou o ataque.")
	
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
	var distance_in_meters = distance_to_hero * STRAIGHT_MOVE_COST
	var weapon_range = enemy.get_weapon_range_meters()
	# 1. Prioridade máxima: ficar em alcance de ataque
	if distance_in_meters <= weapon_range:
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
	
	var player_name := GameState.player_name
	var player_class := GameState.player_class
	
	var loaded_level := GameState.hero_level
	var loaded_total_xp := GameState.hero_total_xp
	var loaded_xp_to_next_level := GameState.hero_xp_to_next_level
	
	var loaded_max_hp := GameState.hero_max_hp
	var loaded_attack_power := GameState.hero_attack_power
	var loaded_max_movement := GameState.hero_max_movement_meters
	
	var loaded_strength := GameState.hero_strength
	var loaded_dexterity := GameState.hero_dexterity
	var loaded_constitution := GameState.hero_constitution
	var loaded_wisdom := GameState.hero_wisdom
	var loaded_intelligence := GameState.hero_intelligence
	var loaded_charisma := GameState.hero_charisma
	
	if GameState.should_load_save and not loaded_player_presets.is_empty():
		player_name = str(loaded_player_presets.get("player_name", "Herói"))
		player_class = str(loaded_player_presets.get("player_class", "Guerreiro"))
		
		loaded_level = int(loaded_player_presets.get("hero_level", 1))
		loaded_total_xp = int(loaded_player_presets.get("hero_total_xp", 0))
		loaded_xp_to_next_level = int(loaded_player_presets.get("hero_xp_to_next_level", 1000))
		
		loaded_max_hp = int(loaded_player_presets.get("hero_max_hp", 100))
		loaded_attack_power = int(loaded_player_presets.get("hero_attack_power", 20))
		loaded_max_movement = float(loaded_player_presets.get("hero_max_movement_meters", 9.0))
		
		loaded_strength = int(loaded_player_presets.get("hero_strength", 10))
		loaded_dexterity = int(loaded_player_presets.get("hero_dexterity", 10))
		loaded_constitution = int(loaded_player_presets.get("hero_constitution", 10))
		loaded_wisdom = int(loaded_player_presets.get("hero_wisdom", 10))
		loaded_intelligence = int(loaded_player_presets.get("hero_intelligence", 10))
		loaded_charisma = int(loaded_player_presets.get("hero_charisma", 10))
	
	hero.apply_character_data(
		player_name,
		player_class,
		loaded_level,
		loaded_total_xp,
		loaded_xp_to_next_level,
		loaded_max_hp,
		loaded_attack_power,
		loaded_max_movement
	)
	
	hero.apply_attributes(
		loaded_strength,
		loaded_dexterity,
		loaded_constitution,
		loaded_wisdom,
		loaded_intelligence,
		loaded_charisma
	)
	hero.apply_race_data(
	GameState.player_race,
	GameState.hero_size,
	GameState.hero_size_modifier,
	GameState.hero_favored_class,
	GameState.hero_race_traits
) 
	hero.apply_class_data(
	GameState.hero_class_hit_die,
	GameState.hero_hp_fixed_per_level,
	GameState.hero_hp_progression_mode,
	GameState.hero_base_attack_bonus_type,
	GameState.hero_fortitude_base_bonus,
	GameState.hero_reflex_base_bonus,
	GameState.hero_will_base_bonus,
	GameState.hero_class_movement_bonus,
	GameState.hero_damage_reduction,
	GameState.hero_class_features
)
	GameState.player_name = hero.character_name
	GameState.player_class = hero.character_class
	
	GameState.hero_level = hero.level
	GameState.hero_total_xp = hero.total_xp
	GameState.hero_xp_to_next_level = hero.xp_to_next_level
	
	GameState.hero_max_hp = hero.max_hp
	GameState.hero_attack_power = hero.attack_power
	GameState.hero_max_movement_meters = hero.max_movement_meters
	
	GameState.hero_strength = hero.strength
	GameState.hero_dexterity = hero.dexterity
	GameState.hero_constitution = hero.constitution
	GameState.hero_wisdom = hero.wisdom
	GameState.hero_intelligence = hero.intelligence
	GameState.hero_charisma = hero.charisma

func show_abandon_confirmation():
	abandon_confirm_popup.popup_centered()

func confirm_abandon_game():
	save_auto_game()
	GameState.should_load_save = false
	GameState.selected_save_path = ""
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
func grant_hero_xp(amount: int):
	if not is_instance_valid(hero):
		return
	
	hero.gain_xp(amount)
	
	GameState.hero_level = hero.level
	GameState.hero_total_xp = hero.total_xp
	GameState.hero_xp_to_next_level = hero.xp_to_next_level
	GameState.hero_max_hp = hero.max_hp
	GameState.hero_attack_power = hero.attack_power
	GameState.hero_max_movement_meters = hero.max_movement_meters
	
	update_movement_label()

func update_movement_label():
	var turn_text := "Seu turno"
	
	if current_turn == TurnState.ENEMY_TURN:
		turn_text = "Turno do inimigo"
	
	if is_instance_valid(hero):
		movement_label.text = (
	hero.character_name + " - " + hero.character_race + " " + hero.character_class + "\n" +
	"Nv " + str(hero.level) + " | XP " + str(hero.get_xp_progress_in_current_level()) + "/" + str(hero.get_xp_needed_for_current_level()) + "\n" +
	"Vida " + str(hero.hp) + "/" + str(hero.max_hp) + " | Mov " + str(hero.current_movement_meters) + "/" + str(hero.max_movement_meters) + "\n" +
	"Arma: " + hero.equipped_weapon + " | RD " + str(hero.damage_reduction) + " | Fúria " + str(hero.rage_turns_remaining) + "\n" +
	"CA " + str(hero.get_armor_class()) + " | FORT " + str(hero.get_fortitude_save()) + " | REF " + str(hero.get_reflex_save()) + " | VON " + str(hero.get_will_save())
)
	else:
		movement_label.text = "Herói derrotado"
	
	if is_instance_valid(enemy):
		enemy_label.text = (
			turn_text + "\n" +
			"Inimigo " + str(enemy.hp) + "/" + str(enemy.max_hp)
		)
	else:
		enemy_label.text = (
			turn_text + "\n" +
			"Inimigo derrotado"
		)
func can_hero_sneak_attack_enemy() -> bool:
	if not is_instance_valid(hero):
		return false
	
	if not is_instance_valid(enemy):
		return false
	
	if hero.character_class != "Ladino":
		return false
	
	# Regra temporária:
	# O inimigo fica vulnerável se ainda não atacou neste combate/turno.
	# Depois vamos trocar isso por flanqueado, cego, desprevenido ou imobilizado.
	if enemy.has_opportunity_attacked == false:
		return true
	
	return false
func use_class_skill():
	if not is_instance_valid(hero):
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	
	if hero.character_class == "Bárbaro":
		hero.activate_rage()
		update_movement_label()
		return
	
	if hero.character_class == "Paladino":
		print("Destruir o Mal será aplicado automaticamente no próximo ataque disponível.")
		update_movement_label()
		return
	
	if hero.character_class == "Monge":
		print("Bônus de Sabedoria na CA já está ativo passivamente.")
		return
	
	if hero.character_class == "Ladino":
		print("Ataque Furtivo é aplicado automaticamente quando o inimigo está vulnerável.")
		return
	
	print("Esta classe ainda não possui habilidade ativa implementada.")
