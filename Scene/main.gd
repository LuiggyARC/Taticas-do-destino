extends Node2D
const ENEMY_SCENE := preload("res://Scene/units/Enemy.tscn")
const ScenarioDatabase := preload("res://Scene/scenario_database.gd")
const Stage3VictoryData := preload("res://Scene/stage_3_victory_database.gd")
const CampfireVisualScript := preload("res://Scene/campfire_visual.gd")
const BridgeConvoyVisualScript := preload("res://Scene/bridge_convoy_visual.gd")
const NPC_SCENE := preload("res://Scene/units/NPC.tscn")
const NpcDatabase := preload("res://Scene/npc_database.gd")
const AttackRollBoxScript := preload(
	"res://Scene/attack_roll_box.gd"
)
const GameCameraControllerScript := preload(
	"res://Scene/game_camera_controller.gd"
)
const ActiveEffectsPanelScript := preload(
	"res://Scene/active_effects_panel.gd"
)
const TurnBannerScript := preload(
	"res://Scene/turn_banner.gd"
)
const TurnStatusDisplayScript := preload(
	"res://Scene/turn_status_display.gd"
)
const InitiativePanelScript := preload(
	"res://Scene/initiative_panel.gd"
)
const BattleResultDialogsScript := preload(
	"res://Scene/battle_result_dialogs.gd"
)
const CombatCharacterSheetScript := preload(
	"res://Scene/combat_character_sheet.gd"
)
const BattleUnitHudScript := preload("res://Scene/battle_unit_hud.gd")
const CombatActionPanelScript := preload(
	"res://Scene/combat_action_panel.gd"
)
const BattleTutorialScript := preload(
	"res://Scene/battle_tutorial.gd"
)
const SpellMenuScript := preload(
	"res://Scene/spell_grimoire.gd"
)
const SpellVisualEffectScript := preload(
	"res://Scene/spell_visual_effect.gd"
)
const SpellTargetOverlayScript := preload(
	"res://Scene/spell_target_overlay.gd"
)
const TouchScrollSupport = preload("res://Scene/touch_scroll_support.gd")
const ActiveSpellAreaOverlayScript := preload(
	"res://Scene/active_spell_area_overlay.gd"
)
const TacticalBoardOverlayScript := preload(
	"res://Scene/tactical_board_overlay.gd"
)
const BattlefieldRendererScript := preload(
	"res://Scene/battlefield_renderer.gd"
)
const CombatAttackResolverScript := preload(
	"res://Scene/combat_attack_resolver.gd"
)
const ScenarioWeatherScript := preload(
	"res://Scene/scenario_weather.gd"
)
const LevelUpPanelScript := preload(
	"res://Scene/level_up_panel.gd"
)
const StoryChoicePanelScript := preload(
	"res://Scene/story_choice_panel.gd"
)
const ANIRI_THEME_PATH := (
	"res://Assets/Audio/Aniritema.mp3"
)
const STAGE_3_VICTORY_MUSIC_PATH := (
	"res://Assets/Audio/The_Long_Watch.mp3"
)
const TILE_SIZE := 64
const GRID_WIDTH := 32
const GRID_HEIGHT := 32
const ACTION_DELAY_WITH_ROLL_BOX := 1.5
const ACTION_DELAY_WITHOUT_ROLL_BOX := 1.0
const ANIMAL_COMPANION_SCENE := preload("res://Scene/units/AnimalCompanion.tscn")
const STRAIGHT_MOVE_COST := 1.5
const DIAGONAL_MOVE_COST := 3.0
const SETTINGS_PATH := "user://settings.json"
const SFX_BUS_NAME := "SFX"
const SAVE_PATH := "user://savegame.json"
const AUTOSAVE_PATH := "user://autosave.json"
const MANUAL_SAVE_DIR := "user://manual_saves/"
const MANUAL_SAVE_SLOT_COUNT: int = 4
const EnemyAI := preload("res://Scene/enemy_ai.gd")
const NpcAI := preload("res://Scene/npc_ai.gd")
const CombatFeedbackScript := preload(
	"res://Scene/combat_feedback.gd"
)
var animal_companion: Node2D
var selected_companion_type: String = "Lobo"
var npcs: Array[Node2D] = []

enum TurnState {
	HERO_TURN,
	ENEMY_TURN
}
var triggered_scenario_events: Dictionary = {}
var turn_banner_controller: Node

var story_dialog_popup: StoryDialogBox
var active_cinematic_cast: Array[String] = []
var story_choice_panel: Node
var scenario_intro_running: bool = false
var scenario_intro_focus_time: float = 1.0

var game_camera: Camera2D
var camera_follow_unit: Node2D
var camera_zoom_value: float = 1.2
var camera_drag_block_player_click: bool = false
var scenario_weather_controller: Node

var collected_scenario_interactions: Dictionary = {}
var current_scenario_data: Dictionary = {}
var terrain_map: Dictionary = {}

var battle_result_controller: Node
var level_up_panel: Node

var initiative_order: Array[Node2D] = []
var current_initiative_index: int = 0
var current_active_unit: Node2D

var attack_roll_box: Control
var battle_finished: bool = false
var stage_3_jhon_working: bool = false
var stage_3_hammer_player: AudioStreamPlayer
var stage_3_night_tint: CanvasModulate
var stage_3_work_tween: Tween
var stage_3_convoy: Node2D
var stage_3_reinforcements: Array[Node2D] = []
var combat_feedback: Node

var current_grid_width: int = GRID_WIDTH
var current_grid_height: int = GRID_HEIGHT
var tactical_board_overlay: Node
var battlefield_renderer: Node

var rogue_was_spotted: bool = false
var rogue_hide_check_done: bool = false
var prepared_class_attack: String = ""
var prepared_class_attacker: Node2D
var turn_status_controller: Node

var current_stage: int = 1
var loaded_player_presets := {}
var current_turn = TurnState.HERO_TURN
var hero: Node2D
var enemies: Array[Node2D] = []

var initiative_panel_controller: Node
var initiative_started: bool = false

var battle_turn_count: int = 1
var enemy: Node2D

var board_root: Node2D
var board_scale: float = 1.0
var board_pixel_size: float = GRID_WIDTH * TILE_SIZE
var is_movement_animating: bool = false
var opportunity_warning_open: bool = false
var movement_step_duration: float = 0.12

var battle_xp_gained: int = 0
var battle_gold_gained: int = 0
var battle_enemies_defeated: int = 0

var spell_menu_controller: Node
var spell_target_overlay: Node2D
var active_spell_areas: Array = []
var active_spell_area_overlay: Node2D
var active_effects_controller: Node
var aniri_theme_started: bool = false

var ui_layer: CanvasLayer

var selected_player_unit: Node2D
var combat_character_sheet_controller: Node
var battle_unit_hud_controller: Node
var sheet_requested_open: bool = false
var hud_portrait_cache: Dictionary = {}

var abandon_confirm_popup: ConfirmationDialog
var save_slot_popup: PopupPanel
var save_slot_buttons: Array[Button] = []
var replace_save_confirmation: ConfirmationDialog
var pending_manual_save_slot: int = 0
var settings_popup: PopupPanel
var credits_popup: AcceptDialog

var combat_action_panel_controller: Node
var battle_tutorial_controller: Control
var battle_items_popup: PopupPanel
var stage_one_tutorial_enabled: bool = false
var stage_one_tutorial_pending: bool = false
var stage_one_tutorial_shown: bool = false
var stage_one_tutorial_skipped: bool = false
var tutorial_movement_target: Vector2i = Vector2i(-1, -1)
var stage_one_tutorial_phase: String = ""
var stage_one_ai_tutorial_shown: bool = false
var stage_one_ally_tutorial_shown: bool = false

var waiting_spell_target: bool = false
var pending_spell_name: String = ""
var pending_spell_data: Dictionary = {}

var master_volume_slider: HSlider
var sfx_volume_slider: HSlider
var language_option: OptionButton

var settings_data := {
	"master_volume": 100.0,
	"sfx_volume": 100.0,
	"language": "pt"
}


func get_manual_save_slot_path(slot_number: int) -> String:
	return MANUAL_SAVE_DIR + "slot_" + str(slot_number) + ".json"


func save_manual_game() -> void:
	if not is_instance_valid(save_slot_popup):
		return
	refresh_manual_save_slot_buttons()
	save_slot_popup.popup_centered(Vector2i(760, 650) if OS.has_feature("mobile") else Vector2i(560, 440))


func refresh_manual_save_slot_buttons() -> void:
	for slot_index in range(save_slot_buttons.size()):
		var slot_number: int = slot_index + 1
		var save_path: String = get_manual_save_slot_path(slot_number)
		var button: Button = save_slot_buttons[slot_index]
		if not FileAccess.file_exists(save_path):
			button.text = "Slot %d — Vazio" % slot_number
			continue
		var save_data: Dictionary = SaveManager.read_save_data(save_path)
		if save_data.is_empty():
			button.text = "Slot %d — Arquivo inválido" % slot_number
			continue
		var player_data: Dictionary = save_data.get("player_presets", {})
		button.text = "Slot %d — %s | Cenário %d\n%s" % [
			slot_number,
			str(player_data.get("player_name", "Herói")),
			int(save_data.get("current_stage", 1)),
			str(save_data.get("saved_at", "Save existente"))
		]


func on_manual_save_slot_selected(slot_number: int) -> void:
	if slot_number < 1 or slot_number > MANUAL_SAVE_SLOT_COUNT:
		return
	var save_path: String = get_manual_save_slot_path(slot_number)
	if FileAccess.file_exists(save_path):
		pending_manual_save_slot = slot_number
		replace_save_confirmation.dialog_text = (
			"Deseja substituir o save do slot %d?\n\nO progresso anterior desse slot será perdido." % slot_number
		)
		replace_save_confirmation.popup_centered()
		return
	write_manual_save_slot(slot_number)


func confirm_manual_save_replacement() -> void:
	var slot_number: int = pending_manual_save_slot
	pending_manual_save_slot = 0
	if slot_number >= 1 and slot_number <= MANUAL_SAVE_SLOT_COUNT:
		write_manual_save_slot(slot_number)


func write_manual_save_slot(slot_number: int) -> void:
	if slot_number < 1 or slot_number > MANUAL_SAVE_SLOT_COUNT:
		return
	if not DirAccess.dir_exists_absolute(MANUAL_SAVE_DIR):
		var mkdir_error: Error = DirAccess.make_dir_recursive_absolute(MANUAL_SAVE_DIR)
		if mkdir_error != OK:
			push_warning("Não foi possível criar a pasta de saves manuais.")
			return
	sync_hero_to_game_state()
	InventoryManager.set_gold(GameState.hero_gold)
	PartyManager.sync_hero_from_game_state()
	if is_instance_valid(hero):
		PartyManager.update_member(PartyManager.HERO_MEMBER_ID, {
			"current_hp": hero.hp,
			"max_hp": hero.max_hp,
			"level": hero.level,
			"total_xp": hero.total_xp
		})
	var source_path: String = GameState.selected_save_path.strip_edges()
	var save_data: Dictionary = {}
	if source_path != "":
		save_data = SaveManager.read_save_data(source_path)
	save_data["save_type"] = "manual"
	save_data["current_stage"] = current_stage
	save_data["current_location"] = "battle"
	save_data["player_presets"] = get_player_save_data()
	save_data["party"] = PartyManager.get_save_data()
	save_data["inventory"] = InventoryManager.get_save_data()
	save_data["missions"] = MissionManager.get_save_data()
	save_data["saved_at"] = Time.get_datetime_string_from_system()
	save_data.erase("village_return_location")
	var save_path: String = get_manual_save_slot_path(slot_number)
	if not SaveManager.write_save_data(save_path, save_data):
		push_warning("Não foi possível gravar o slot %d." % slot_number)
		return
	# O slot manual é uma cópia fixa; o progresso automático
	# continua no autosave e não sobrescreve o slot sem confirmação.
	var autosave_data: Dictionary = save_data.duplicate(true)
	autosave_data["save_type"] = "autosave"
	if SaveManager.write_save_data(AUTOSAVE_PATH, autosave_data):
		GameState.selected_save_path = AUTOSAVE_PATH
	else:
		push_warning("Slot gravado, mas não foi possível atualizar o autosave.")
	refresh_manual_save_slot_buttons()
	if is_instance_valid(save_slot_popup):
		save_slot_popup.hide()
	print("Save manual gravado no slot %d: %s" % [slot_number, save_path])
	
func save_auto_game(
	save_location: String = "battle",
	village_return_location: String = ""
) -> bool:
	sync_hero_to_game_state()

	GameState.current_location = save_location

	InventoryManager.set_gold(
		GameState.hero_gold
	)

	PartyManager.sync_hero_from_game_state()

	if is_instance_valid(hero):
		PartyManager.update_member(
			PartyManager.HERO_MEMBER_ID,
			{
				"current_hp": hero.hp,
				"max_hp": hero.max_hp,
				"level": hero.level,
				"total_xp": hero.total_xp,
				"known_spells":
					hero.known_spells.duplicate(true),
				"spell_slots_level_0":
					hero.spell_slots_level_0,
				"spell_slots_level_1":
					hero.spell_slots_level_1,
				"spell_slots_level_2":
					hero.spell_slots_level_2,
				"max_spell_slots_level_0":
					hero.max_spell_slots_level_0,
				"max_spell_slots_level_1":
					hero.max_spell_slots_level_1,
				"max_spell_slots_level_2":
					hero.max_spell_slots_level_2
			}
		)

	var source_save_path: String = (
		GameState.selected_save_path.strip_edges()
	)

	var save_data: Dictionary = {}

	if source_save_path != "":
		save_data = SaveManager.read_save_data(
			source_save_path
		)

	save_data["save_type"] = "autosave"
	save_data["current_stage"] = current_stage
	save_data["current_location"] = save_location
	save_data["player_presets"] = (
		get_player_save_data()
	)
	save_data["party"] = (
		PartyManager.get_save_data()
	)
	save_data["inventory"] = (
		InventoryManager.get_save_data()
	)
	save_data["missions"] = (
		MissionManager.get_save_data()
	)

	if village_return_location.strip_edges() != "":
		save_data["village_return_location"] = (
			village_return_location
		)
	else:
		save_data.erase(
			"village_return_location"
		)

	var file := FileAccess.open(
		AUTOSAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:
		print("Erro ao criar autosave.")
		return false

	file.store_string(
		JSON.stringify(
			save_data,
			"\t"
		)
	)
	file.close()

	GameState.selected_save_path = AUTOSAVE_PATH

	print(
		"Autosave criado. Stage atual: ",
		current_stage,
		" | Local: ",
		save_location,
		" | Retorno na vila: ",
		village_return_location
	)

	return true
	
func load_progress():
	var save_path: String = (
		GameState.selected_save_path
	)
	
	if save_path == "":
		save_path = AUTOSAVE_PATH
	
	if not FileAccess.file_exists(save_path):
		print(
			"Save não encontrado: ",
			save_path
		)
		
		current_stage = 1
		loaded_player_presets = {}
		
		PartyManager.reset_party()
		return
	
	var file := FileAccess.open(
		save_path,
		FileAccess.READ
	)
	
	if file == null:
		print(
			"Erro ao abrir save: ",
			save_path
		)
		
		current_stage = 1
		loaded_player_presets = {}
		
		PartyManager.reset_party()
		return
	
	var json_text := file.get_as_text()
	file.close()
	
	var json := JSON.new()
	var error := json.parse(json_text)
	
	if error != OK:
		print(
			"Erro ao ler save: ",
			save_path
		)
		
		current_stage = 1
		loaded_player_presets = {}
		
		PartyManager.reset_party()
		return
	
	var save_data = json.data
	
	current_stage = int(
		save_data.get(
			"current_stage",
			1
		)
	)
	
	loaded_player_presets = save_data.get(
		"player_presets",
		{}
	)
	
	GameState.player_name = str(
		loaded_player_presets.get(
			"player_name",
			"Herói"
		)
	)
	
	GameState.player_class = str(
		loaded_player_presets.get(
			"player_class",
			"Sem Classe"
		)
	)
	
	GameState.player_race = str(
		loaded_player_presets.get(
			"player_race",
			"Humano"
		)
	)
	
	GameState.hero_level = int(
		loaded_player_presets.get(
			"hero_level",
			1
		)
	)
	
	GameState.hero_total_xp = int(
		loaded_player_presets.get(
			"hero_total_xp",
			0
		)
	)
	
	GameState.hero_xp_to_next_level = int(
		loaded_player_presets.get(
			"hero_xp_to_next_level",
			1000
		)
	)
	
	GameState.hero_max_level = int(
		loaded_player_presets.get(
			"hero_max_level",
			20
		)
	)
	
	GameState.hero_max_hp = int(
		loaded_player_presets.get(
			"hero_max_hp",
			100
		)
	)
	
	GameState.hero_attack_power = int(
		loaded_player_presets.get(
			"hero_attack_power",
			20
		)
	)
	
	GameState.hero_max_movement_meters = float(
		loaded_player_presets.get(
			"hero_max_movement_meters",
			9.0
		)
	)
	
	GameState.hero_strength = int(
		loaded_player_presets.get(
			"hero_strength",
			10
		)
	)
	
	GameState.hero_dexterity = int(
		loaded_player_presets.get(
			"hero_dexterity",
			10
		)
	)
	
	GameState.hero_constitution = int(
		loaded_player_presets.get(
			"hero_constitution",
			10
		)
	)
	
	GameState.hero_wisdom = int(
		loaded_player_presets.get(
			"hero_wisdom",
			10
		)
	)
	
	GameState.hero_intelligence = int(
		loaded_player_presets.get(
			"hero_intelligence",
			10
		)
	)
	
	GameState.hero_charisma = int(
		loaded_player_presets.get(
			"hero_charisma",
			10
		)
	)
	
	GameState.hero_size = str(
		loaded_player_presets.get(
			"hero_size",
			"Médio"
		)
	)
	
	GameState.hero_size_modifier = int(
		loaded_player_presets.get(
			"hero_size_modifier",
			0
		)
	)
	
	GameState.hero_favored_class = str(
		loaded_player_presets.get(
			"hero_favored_class",
			"Qualquer"
		)
	)
	
	GameState.hero_race_traits = (
		loaded_player_presets.get(
			"hero_race_traits",
			[]
		)
	)
	
	GameState.hero_class_hit_die = int(
		loaded_player_presets.get(
			"hero_class_hit_die",
			10
		)
	)
	
	GameState.hero_hp_fixed_per_level = int(
		loaded_player_presets.get(
			"hero_hp_fixed_per_level",
			6
		)
	)
	
	GameState.hero_hp_progression_mode = str(
		loaded_player_presets.get(
			"hero_hp_progression_mode",
			"fixed"
		)
	)
	
	GameState.hero_base_attack_bonus_type = str(
		loaded_player_presets.get(
			"hero_base_attack_bonus_type",
			"medio"
		)
	)
	
	GameState.hero_fortitude_base_bonus = int(
		loaded_player_presets.get(
			"hero_fortitude_base_bonus",
			0
		)
	)
	
	GameState.hero_reflex_base_bonus = int(
		loaded_player_presets.get(
			"hero_reflex_base_bonus",
			0
		)
	)
	
	GameState.hero_will_base_bonus = int(
		loaded_player_presets.get(
			"hero_will_base_bonus",
			0
		)
	)
	
	GameState.hero_class_movement_bonus = float(
		loaded_player_presets.get(
			"hero_class_movement_bonus",
			0.0
		)
	)
	
	GameState.hero_damage_reduction = int(
		loaded_player_presets.get(
			"hero_damage_reduction",
			0
		)
	)
	
	GameState.hero_class_features = (
		loaded_player_presets.get(
			"hero_class_features",
			[]
		)
	)
	
	PartyManager.load_save_data(
		save_data.get(
			"party",
			{}
		)
	)

func restore_saved_mission_state() -> void:
	var save_path: String = str(
		GameState.selected_save_path
	).strip_edges()

	if save_path == "":
		save_path = AUTOSAVE_PATH

	var save_data: Dictionary = (
		SaveManager.read_save_data(
			save_path
		)
	)

	if save_data.is_empty():
		MissionManager.reset_missions()
		return

	var mission_data_value = (
		save_data.get(
			"missions",
			{}
		)
	)

	if mission_data_value is Dictionary:
		MissionManager.load_save_data(
			mission_data_value
		)
	else:
		MissionManager.reset_missions()

func _ready():
	if (
		GameState.should_load_save
		and GameState.current_location in ["village", "temple_road"]
	):
		load_progress()
		restore_saved_inventory_and_party_state()
		restore_saved_mission_state()

		GameState.should_load_save = false

		if MusicManage != null:
			MusicManage.fade_out_music(
				1.0
			)

		var destination_scene: String = (
			"res://Scene/temple_road.tscn"
			if GameState.current_location == "temple_road"
			else "res://Scene/village.tscn"
		)
		get_tree().change_scene_to_file(destination_scene)

		return

	if SpellDatabase != null:
		if SpellDatabase.has_method(
			"validate_spells"
		):
			SpellDatabase.validate_spells()

	if MusicManage != null:
		MusicManage.fade_out_music(
			1.0
		)

	# =====================================================
	# CRIA CAMADAS DO TABULEIRO
	# =====================================================
	create_board_root()
	create_map_background_layer()
	create_game_camera()
	create_grid_layer()
	create_movement_layer()
	create_spell_target_layer()
	create_active_spell_area_layer()
	create_attack_area_layer()
	draw_grid()

	# =====================================================
	# PEGA HERÓI E INIMIGO DA CENA ANTES DE CRIAR/ATUALIZAR UI
	# =====================================================
	hero = $Hero
	enemy = $Enemy

	move_units_to_board_root()

	# =====================================================
	# CRIA UI DEPOIS QUE HERO E ENEMY JÁ EXISTEM
	# =====================================================
	await create_ui()
	create_floating_text_layer()

	get_viewport().size_changed.connect(
		update_board_transform
	)

	var loading_saved_game: bool = (
		GameState.should_load_save
	)
	stage_one_tutorial_enabled = not loading_saved_game

	if loading_saved_game:
		load_progress()
		restore_saved_inventory_and_party_state()
		restore_saved_mission_state()
	else:
		current_stage = 1
		GameState.current_location = "battle"

		PartyManager.reset_party()
		InventoryManager.reset_inventory()
		MissionManager.reset_missions()

	start_stage(
		current_stage
	)

	# start_stage executa apply_player_presets antes
	# de chegar ao primeiro await.
	if loading_saved_game:
		GameState.should_load_save = false

	selected_player_unit = hero

	update_board_transform()
	show_movement_area()
	update_movement_label()
	update_enemy_hp_bar()
	update_class_skill_button()
	
func get_battlefield_renderer() -> Node:
	if is_instance_valid(
		battlefield_renderer
	):
		return battlefield_renderer
	
	battlefield_renderer = (
		BattlefieldRendererScript.new()
	)
	
	battlefield_renderer.setup(
		TILE_SIZE
	)
	
	if is_instance_valid(board_root):
		board_root.add_child(
			battlefield_renderer
		)
	else:
		add_child(
			battlefield_renderer
		)
	
	return battlefield_renderer
	
func create_grid_layer() -> void:
	get_battlefield_renderer()

func create_map_background_layer() -> void:
	get_battlefield_renderer()

func draw_scenario_background() -> void:
	if current_scenario_data.is_empty():
		return
	
	var image_path: String = str(
		current_scenario_data.get(
			"background_image",
			""
		)
	)
	
	if image_path == "":
		return
	
	var renderer: Node = (
		get_battlefield_renderer()
	)
	
	if not is_instance_valid(renderer):
		return
	
	renderer.draw_background(
		image_path,
		current_grid_width,
		current_grid_height
	)

func get_tactical_board_overlay() -> Node:
	if is_instance_valid(
		tactical_board_overlay
	):
		return tactical_board_overlay
	
	tactical_board_overlay = (
		TacticalBoardOverlayScript.new()
	)
	
	tactical_board_overlay.setup(
		TILE_SIZE
	)
	
	if is_instance_valid(board_root):
		board_root.add_child(
			tactical_board_overlay
		)
	else:
		add_child(
			tactical_board_overlay
		)
	
	return tactical_board_overlay

func create_movement_layer() -> void:
	get_tactical_board_overlay()

func draw_grid() -> void:
	var renderer: Node = (
		get_battlefield_renderer()
	)
	
	if not is_instance_valid(renderer):
		return
	
	renderer.draw_grid(
		current_grid_width,
		current_grid_height,
		terrain_map
	)

func create_ui() -> void:
	await clear_old_ui()

	ui_layer = CanvasLayer.new()
	ui_layer.name = "UILayer"
	add_child(ui_layer)

	create_story_dialog_popup()
	create_story_choice_panel()
	create_attack_roll_box()
	create_turn_counter_label()
	create_active_effects_panel()
	create_battle_zoom_controls()
	create_character_sheet_panel()
	create_battle_unit_hud()
	create_action_panel()
	create_battle_tutorial()
	create_abandon_popup()
	create_manual_save_popups()
	create_battle_result_dialogs()
	create_cancel_spell_button()
	create_turn_banner_layer()

	update_movement_label()
	update_battle_unit_hud()
	update_enemy_hp_bar()
	update_turn_counter_label()
	update_active_effects_panel()

func create_battle_tutorial() -> void:
	if is_instance_valid(battle_tutorial_controller):
		battle_tutorial_controller.queue_free()
	battle_tutorial_controller = BattleTutorialScript.new()
	ui_layer.add_child(battle_tutorial_controller)
	battle_tutorial_controller.step_changed.connect(on_tutorial_step_changed)

func on_tutorial_step_changed(target_name: String) -> void:
	if is_instance_valid(attack_roll_box) and is_instance_valid(attack_roll_box.panel):
		if target_name == "results":
			attack_roll_box.panel.visible = true
			if stage_one_tutorial_phase != "results":
				attack_roll_box.result_label.text = "d20 14 + 5 = 19  vs  CA 13\nACERTOU\nDano: 8"
				attack_roll_box.result_label.add_theme_color_override("font_color", Color(0.35, 1.0, 0.45))
		else:
			attack_roll_box.panel.visible = false
	var focus_unit: Node2D = null
	match target_name:
		"movement_area":
			focus_unit = hero
		"attack_area":
			focus_unit = hero
		"enemy":
			for candidate in enemies:
				if is_instance_valid(candidate) and candidate.hp > 0 and candidate.visible:
					focus_unit = candidate
					break
		"ai_ally":
			for candidate in npcs:
				if is_instance_valid(candidate) and str(candidate.control_type) == "ai":
					focus_unit = candidate
					break
		"player_ally":
			focus_unit = current_active_unit if is_instance_valid(current_active_unit) and current_active_unit != hero else animal_companion
		"hero":
			focus_unit = hero
	if is_instance_valid(focus_unit):
		center_camera_on_unit(focus_unit)

func show_stage_one_initiative_tutorial() -> void:
	if not is_instance_valid(battle_tutorial_controller):
		return
	var steps: Array[Dictionary] = [{
		"title": "Comece pela iniciativa",
		"text": "A iniciativa decide quem age primeiro. Toque em Rolar Iniciativa; depois cada unidade terá seu turno na ordem mostrada no topo da tela.",
		"target": "roll_initiative"
	}]
	battle_tutorial_controller.start_tutorial(
		steps,
		Callable(self, "get_tutorial_target_rect")
	)
	var completed: bool = await battle_tutorial_controller.closed
	stage_one_tutorial_pending = completed
	stage_one_tutorial_skipped = not completed

func show_stage_one_guided_tip(title: String, body: String, target: String, button_text: String = "Entendi, vou fazer") -> bool:
	if not stage_one_tutorial_enabled or stage_one_tutorial_skipped or not is_instance_valid(battle_tutorial_controller):
		return false
	if battle_tutorial_controller.visible:
		return false
	battle_tutorial_controller.start_tutorial(
		[{"title": title, "text": body, "target": target, "button_text": button_text, "progress_text": "TUTORIAL PRÁTICO"}],
		Callable(self, "get_tutorial_target_rect")
	)
	var completed: bool = await battle_tutorial_controller.closed
	if not completed:
		stage_one_tutorial_skipped = true
		stage_one_tutorial_phase = ""
	return completed

func show_stage_one_guided_step(phase: String, title: String, body: String, target: String, next_phase: String = "") -> void:
	if stage_one_tutorial_skipped or battle_finished:
		return
	stage_one_tutorial_phase = phase
	var completed: bool = await show_stage_one_guided_tip(title, body, target)
	if completed and stage_one_tutorial_phase == phase and next_phase != "":
		stage_one_tutorial_phase = next_phase

func begin_stage_one_guided_tutorial() -> void:
	if stage_one_tutorial_shown or stage_one_tutorial_skipped:
		return
	stage_one_tutorial_shown = true
	show_stage_one_guided_step(
		"movement",
		"Passo 1 — Mova seu herói",
		"As casas azuis mostram até onde você pode andar neste turno. Toque em uma casa azul para mover seu herói na direção de um goblin. O número de metros restantes aparece no painel de ações.",
		"movement_area"
	)

func maybe_show_stage_one_attack_tutorial() -> void:
	if current_stage != 1 or stage_one_tutorial_skipped or not is_instance_valid(hero):
		return
	if stage_one_tutorial_phase not in ["movement", "approach"]:
		return
	if not has_enemy_within_weapon_range(hero, float(hero.get_weapon_range_meters())):
		return
	show_stage_one_guided_step(
		"attack",
		"Passo 2 — Ataque o inimigo",
		"Agora há um inimigo ao alcance da sua arma. Toque nele para atacar. A área vermelha só aparece quando uma arma pode alcançá-lo; ela não representa o alcance das magias.",
		"attack_area"
	)

func on_stage_one_player_moved(unit: Node2D) -> void:
	if current_stage != 1 or unit != hero or stage_one_tutorial_skipped:
		return
	if stage_one_tutorial_phase not in ["movement", "approach"]:
		return
	if has_enemy_within_weapon_range(hero, float(hero.get_weapon_range_meters())):
		maybe_show_stage_one_attack_tutorial()
	elif stage_one_tutorial_phase == "movement":
		show_stage_one_guided_step(
			"approach",
			"Continue se aproximando",
			"Bom movimento! O inimigo ainda está fora do alcance da sua arma. Use outra casa azul se ainda houver movimento; se acabar, toque em Terminar Turno e avance no próximo turno. Casas com ! avisam sobre ataque de oportunidade.",
			"movement_area"
		)

func on_stage_one_attack_completed(attacker: Node2D) -> void:
	if current_stage != 1 or attacker != hero or stage_one_tutorial_skipped or battle_finished:
		return
	if stage_one_tutorial_phase not in ["movement", "approach", "attack"]:
		return
	show_stage_one_post_attack_tutorial()

func show_stage_one_post_attack_tutorial() -> void:
	stage_one_tutorial_phase = "results"
	var completed: bool = await show_stage_one_guided_tip(
		"Veja o resultado do ataque",
		"A caixa no canto inferior direito mostra o dado, os bônus, a defesa do inimigo e o dano. Você usou sua ação principal; no próximo turno poderá atacar novamente.",
		"results"
	)
	if not completed:
		return
	stage_one_tutorial_phase = "actions"
	var actions_text: String = "No painel inferior, Itens permite usar poções e outros objetos. A habilidade da classe aparece ao lado quando estiver disponível. Cada uso pode consumir sua ação principal. Quando terminar, toque em Terminar Turno."
	completed = await show_stage_one_guided_tip(
		"Outras ações e fim do turno", actions_text, "action_panel"
	)
	if completed:
		stage_one_tutorial_phase = "magic_wait" if not hero.known_spells.is_empty() else "ally_wait"

func show_stage_one_magic_tutorial() -> void:
	if stage_one_tutorial_phase not in ["magic_wait", "magic_menu"] or stage_one_tutorial_skipped:
		return
	show_stage_one_guided_step(
		"magic_menu",
		"Passo 3 — Use uma magia",
		"Sua classe conhece magias. Toque em Magias, escolha uma opção disponível e leia o efeito. Depois, o mapa mostrará o alcance; toque no alvo ou na área indicada. Uma magia pode gastar sua ação e um uso do nível correspondente.",
		"magic"
	)

func on_stage_one_spell_selected() -> void:
	if current_stage != 1 or stage_one_tutorial_phase != "magic_menu" or stage_one_tutorial_skipped:
		return
	show_stage_one_guided_step(
		"magic_target",
		"Escolha o alvo da magia",
		"As casas destacadas mostram o alcance desta magia. Toque em um alvo válido ou no centro da área. Você pode cancelar a magia sem gastá-la se quiser escolher outra.",
		"spell_target_area"
	)

func on_stage_one_spell_cast() -> void:
	if current_stage == 1 and stage_one_tutorial_phase == "magic_target":
		stage_one_tutorial_phase = "ally_wait" if not stage_one_ally_tutorial_shown else "done"

func show_stage_one_ally_tutorial(unit: Node2D) -> void:
	if current_stage != 1 or stage_one_tutorial_skipped or stage_one_ally_tutorial_shown or not stage_one_tutorial_shown:
		return
	if unit == hero or not is_instance_valid(unit):
		return
	if not is_instance_valid(battle_tutorial_controller) or battle_tutorial_controller.visible:
		return
	stage_one_ally_tutorial_shown = true
	show_stage_one_guided_tip(
		"Seu outro personagem jogável",
		"Agora é o turno de %s. Você controla este aliado: use as casas azuis para movê-lo e toque em um inimigo ao alcance para atacar. Cada personagem tem sua própria vida, movimento e ação; veja quem está ativo na faixa de turnos." % get_unit_display_name(unit),
		"player_ally"
	)

func show_stage_one_battle_tutorial() -> void:
	if not is_instance_valid(battle_tutorial_controller):
		return
	if is_instance_valid(combat_action_panel_controller) and combat_action_panel_controller.actions_collapsed:
		toggle_actions_bar()
	stage_one_tutorial_shown = true
	var attack_tutorial_target: String = "enemy"
	if is_instance_valid(hero):
		var tutorial_weapon_range: float = 1.5
		if hero.has_method("get_weapon_range_meters"):
			tutorial_weapon_range = float(hero.get_weapon_range_meters())
		if has_enemy_within_weapon_range(hero, tutorial_weapon_range):
			attack_tutorial_target = "attack_area"
	var steps: Array[Dictionary] = [
		{"title": "Ordem dos turnos", "text": "Esta faixa mostra quem vai agir em seguida. O nome destacado é a unidade do turno atual.", "target": "turn_order"},
		{"title": "Seu personagem", "text": "O quadro no alto à esquerda mostra o retrato, os pontos de vida e a defesa do personagem. Toque em Ver ficha para abrir os detalhes.", "target": "unit_hud"},
		{"title": "Mover", "text": "Toque numa casa azul para andar com segurança. Uma casa laranja com ! é perigosa: ao tentar ir até ela, você sai do alcance de um inimigo próximo. Ele pode atacar antes de você andar.", "target": "movement_area"},
		{"title": "Atacar", "text": "A área vermelha da arma aparece somente quando há um inimigo ao alcance. Aproxime-se ou espere que ele se aproxime; então toque nele para atacar. Magias mostram um alcance separado.", "target": attack_tutorial_target},
		{"title": "Aliado da IA", "text": "O Guarda Aliado é amigo, mas age sozinho quando chegar sua vez. Você não pode decidir para onde ele anda ou quem ataca.", "target": "ai_ally"},
		{"title": "Aliado controlável", "text": "Quando um aliado controlável entrar no grupo, como um companheiro animal ou um personagem de outra missão, você decidirá as ações dele no turno próprio. Verde indica aliado; a faixa de iniciativa mostra de quem é a vez.", "target": "player_ally"},
		{"title": "Painel de ações", "text": "Na faixa inferior ficam a habilidade da classe, Itens e Magias. Acima dela, veja se a ação principal ainda está livre e quanto movimento resta.", "target": "action_panel"}
	]
	if is_instance_valid(combat_action_panel_controller.class_skill_button) and combat_action_panel_controller.class_skill_button.visible:
		steps.append({"title": "Habilidade da classe", "text": "Este botão usa a habilidade especial da sua classe. Algumas habilidades pedem que você escolha um inimigo depois; outras são ativadas imediatamente.", "target": "class_skill"})
	if is_instance_valid(hero) and not hero.known_spells.is_empty():
		steps.append({"title": "Magias", "text": "Abra o grimório para ver as magias conhecidas. Escolha uma magia e, quando solicitado, toque no alvo ou na área do mapa. Magias de nível maior gastam usos.", "target": "magic"})
	steps.append({"title": "Itens", "text": "Toque em Itens para usar uma poção de cura que você tenha encontrado ou comprado. Usar uma poção gasta a ação de ataque da unidade neste turno.", "target": "items"})
	steps.append({"title": "Ataque de oportunidade", "text": "Exemplo: se um goblin está ao seu lado e você tenta se afastar, ele ganha um golpe gratuito ANTES do seu movimento. A casa laranja com ! avisa esse risco. Toque nela para ver quem atacará; você pode cancelar. Arcos não fazem esse ataque.", "target": "enemy"})
	steps.append({"title": "Efeitos ativos", "text": "Aqui aparecem fúria, venenos, magias em andamento e outros efeitos com duração. 'Nenhum' significa que não há efeitos ativos agora.", "target": "effects"})
	steps.append({"title": "Resultados das ações", "text": "Esta caixa mostra a rolagem do dado, os bônus, a defesa do alvo, se o golpe acertou e quanto dano causou. Também informa os resultados de magias. Ela aparece brevemente no canto inferior direito.", "target": "results"})
	steps.append({"title": "Opções da batalha", "text": "A engrenagem abre Salvar e Abandonar. Neste primeiro cenário, a opção Ajuda permite rever este tutorial.", "target": "battle_menu"})
	steps.append({"title": "Encerrar turno", "text": "Quando terminar suas ações, toque em Terminar Turno no canto inferior direito.", "target": "end_turn"})
	if is_instance_valid(active_effects_controller.panel):
		active_effects_controller.panel.visible = true
	battle_tutorial_controller.start_tutorial(
		steps,
		Callable(self, "get_tutorial_target_rect")
	)
	await battle_tutorial_controller.closed
	if is_instance_valid(attack_roll_box) and is_instance_valid(attack_roll_box.panel):
		attack_roll_box.panel.visible = false
	update_active_effects_panel()
	if is_instance_valid(current_active_unit):
		center_camera_on_unit(current_active_unit)

func replay_battle_tutorial() -> void:
	if current_stage != 1 or not is_instance_valid(battle_tutorial_controller):
		return
	if not initiative_started:
		show_stage_one_initiative_tutorial()
	else:
		show_stage_one_battle_tutorial()

func get_tutorial_target_rect(target_name: String) -> Variant:
	if target_name in ["movement_area", "attack_area", "spell_target_area"]:
		var layer: Node2D = null
		if target_name == "spell_target_area":
			layer = spell_target_overlay
		else:
			var overlay: Node = get_tactical_board_overlay()
			if is_instance_valid(overlay):
				layer = overlay.movement_layer if target_name == "movement_area" else overlay.attack_layer
		if not is_instance_valid(layer):
			return []
		var rects: Array[Rect2] = []
		var screen_rect := Rect2(Vector2.ZERO, get_viewport_rect().size)
		for tile in layer.get_children():
			if not tile is Panel:
				continue
			if target_name == "movement_area" and tile.name != "MovementTile":
				continue
			var transform: Transform2D = tile.get_global_transform_with_canvas()
			var tile_rect := Rect2(transform.origin, Vector2(transform.x.length() * tile.size.x, transform.y.length() * tile.size.y))
			if tile_rect.intersects(screen_rect):
				rects.append(tile_rect)
		return rects
	var control: Control = null
	match target_name:
		"roll_initiative":
			if is_instance_valid(initiative_panel_controller):
				control = initiative_panel_controller.roll_button
		"turn_order":
			if is_instance_valid(turn_status_controller):
				control = turn_status_controller.order_panel
		"action_panel":
			if is_instance_valid(combat_action_panel_controller):
				control = combat_action_panel_controller.panel
		"unit_hud":
			if is_instance_valid(battle_unit_hud_controller):
				control = battle_unit_hud_controller.panel
		"battle_menu":
			if is_instance_valid(combat_action_panel_controller):
				control = combat_action_panel_controller.gear_button
		"class_skill":
			if is_instance_valid(combat_action_panel_controller):
				control = combat_action_panel_controller.class_skill_button
		"magic":
			if is_instance_valid(combat_action_panel_controller):
				control = combat_action_panel_controller.magic_button
		"items":
			if is_instance_valid(combat_action_panel_controller):
				control = combat_action_panel_controller.items_button
		"effects":
			if is_instance_valid(active_effects_controller):
				control = active_effects_controller.panel
		"results":
			if is_instance_valid(attack_roll_box):
				control = attack_roll_box.panel
		"end_turn":
			if is_instance_valid(combat_action_panel_controller):
				control = combat_action_panel_controller.end_turn_button
	if is_instance_valid(control) and (control.visible or target_name == "results"):
		return control.get_global_rect()
	var unit: Node2D = null
	match target_name:
		"hero":
			unit = hero
		"enemy":
			for candidate in enemies:
				if is_instance_valid(candidate) and candidate.hp > 0 and candidate.visible:
					unit = candidate
					break
		"ai_ally":
			for candidate in npcs:
				if is_instance_valid(candidate) and str(candidate.control_type) == "ai":
					unit = candidate
					break
		"player_ally":
			unit = current_active_unit if is_instance_valid(current_active_unit) and current_active_unit != hero else animal_companion
	if is_instance_valid(unit):
		var point: Vector2 = unit.get_global_transform_with_canvas().origin
		var screen_size: Vector2 = get_viewport_rect().size
		if point.x >= 0.0 and point.y >= 0.0 and point.x <= screen_size.x and point.y <= screen_size.y:
			return Rect2(point - Vector2(42, 54), Vector2(84, 84))
	return Rect2()

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if event.pressed:
		return
	
	if camera_drag_block_player_click:
		camera_drag_block_player_click = false
		
		get_viewport().set_input_as_handled()
		return
	
	var mouse_position: Vector2 = (
		get_global_mouse_position()
	)
	
	var clicked_grid_position: Vector2i = (
		world_to_grid(mouse_position)
	)
	
	if is_inside_grid(clicked_grid_position):
		handle_player_grid_click(
			clicked_grid_position
		)

func world_to_grid(world_position: Vector2) -> Vector2i:
	var local_position: Vector2 = world_position
	
	if board_root != null:
		local_position = board_root.to_local(world_position)
	
	return Vector2i(
		int(local_position.x / TILE_SIZE),
		int(local_position.y / TILE_SIZE)
	)

func is_inside_grid(grid_position: Vector2i) -> bool:
	return (
		grid_position.x >= 0 and
		grid_position.x < current_grid_width and
		grid_position.y >= 0 and
		grid_position.y < current_grid_height
	)

func create_cancel_spell_button() -> void:
	if not is_instance_valid(ui_layer):
		return
	
	if not is_instance_valid(
		combat_action_panel_controller
	):
		return
	
	combat_action_panel_controller.create_cancel_spell_control(
		ui_layer,
		Callable(
			self,
			"cancel_pending_spell"
		),
		Callable(
			self,
			"apply_button_sfx"
		)
	)

func move_hero(new_grid_position: Vector2i):
	if not is_instance_valid(hero):
		return
	
	await move_player_unit(
		hero,
		new_grid_position
	)
		
func get_movement_cost(from_position: Vector2i, to_position: Vector2i) -> float:
	var dx = abs(to_position.x - from_position.x)
	var dy = abs(to_position.y - from_position.y)
	
	var diagonal_steps = min(dx, dy)
	var straight_steps = max(dx, dy) - diagonal_steps
	
	var base_cost: float = diagonal_steps * DIAGONAL_MOVE_COST + straight_steps * STRAIGHT_MOVE_COST
	var terrain_multiplier: float = get_terrain_movement_multiplier(to_position)
	
	return base_cost * terrain_multiplier

func show_movement_area():
	clear_movement_area()
	
	if not initiative_started:
		return
	
	if battle_finished:
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	
	var unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(unit):
		return
	
	if unit.hp <= 0:
		return
	
	if not unit.visible:
		return
	
	if is_npc_unit(unit):
		if str(unit.control_type) != "player":
			return
	
	if not "current_movement_meters" in unit:
		return
	
	var available_movement: float = float(
		unit.current_movement_meters
	)
	
	if available_movement <= 0.0:
		return
	
	var reachable_positions: Dictionary = (
		get_reachable_positions_for_unit(
			unit,
			available_movement
		)
	)
	
	for position_key in reachable_positions.keys():
		var grid_position: Vector2i = position_key
		
		if grid_position == unit.grid_position:
			continue
		
		var unit_at_position: Node2D = (
			get_unit_at_grid_position(grid_position)
		)
		
		if is_instance_valid(unit_at_position):
			continue
		
		create_movement_tile(
			grid_position,
			not get_opportunity_attackers_for_move(unit, grid_position).is_empty()
		)

func clear_movement_area() -> void:
	var overlay: Node = (
		get_tactical_board_overlay()
	)
	
	if not is_instance_valid(overlay):
		return
	
	overlay.clear_movement_tiles()

func end_hero_turn():
	await end_active_unit_turn()
	
func hero_attack() -> void:
	enemy = prepare_player_attack_target(
		hero,
		enemy
	)
	
	if not is_instance_valid(enemy):
		return

	if hero.character_class == "Ladino" and hero.is_hidden:
		check_hidden_rogue_perception(hero)

	var using_smite: bool = (
		prepared_class_attack == "smite"
		and prepared_class_attacker == hero
		and hero.character_class == "Paladino"
	)
	
	var distance_meters: float = (
		get_distance_in_meters(
			hero.grid_position,
			enemy.grid_position
		)
	)
	
	var weapon_range: float = 1.5
	
	if hero.has_method(
		"get_weapon_range_meters"
	):
		weapon_range = float(
			hero.get_weapon_range_meters()
		)
	
	var attack_bonus: int = 0
	var damage_bonus: int = 0
	
	var weapon_type: String = "melee"
	var weapon_name: String = str(
		hero.equipped_weapon
	)
	
	if hero.has_method(
		"get_base_attack_bonus"
	):
		attack_bonus += int(
			hero.get_base_attack_bonus()
		)
	
	if hero.has_method(
		"get_equipped_weapon_data"
	):
		var weapon_data: Dictionary = (
			hero.get_equipped_weapon_data()
		)
		
		weapon_type = str(
			weapon_data.get(
				"type",
				"melee"
			)
		)
		
		if weapon_data.has(
			"attack_bonus"
		):
			attack_bonus += int(
				weapon_data["attack_bonus"]
			)
		
		if weapon_data.has(
			"damage_bonus"
		):
			damage_bonus += int(
				weapon_data["damage_bonus"]
			)
	
	if weapon_type == "ranged":
		if hero.has_method(
			"get_dexterity_modifier"
		):
			attack_bonus += int(
				hero.get_dexterity_modifier()
			)
		if hero.character_race == "Elfo":
			attack_bonus += 1
	else:
		if hero.has_method(
			"get_strength_modifier"
		):
			attack_bonus += int(
				hero.get_strength_modifier()
			)
	
	attack_bonus += int(
		hero.feat_attack_bonus
	)
	
	damage_bonus += int(
		hero.feat_damage_bonus
	)
	
	if weapon_type == "melee":
		attack_bonus += int(
			hero.feat_melee_attack_bonus
		)
		
		damage_bonus += int(
			hero.feat_melee_damage_bonus
		)
	
	if weapon_type == "ranged":
		attack_bonus += int(
			hero.feat_ranged_attack_bonus
		)
		
		damage_bonus += int(
			hero.feat_ranged_damage_bonus
		)
	
	if weapon_name == "Soco":
		damage_bonus += int(
			hero.feat_unarmed_damage_bonus
		)
	
	if hero.character_class == "Bárbaro":
		if hero.is_raging:
			damage_bonus += int(
				hero.feat_rage_damage_bonus
			)
	
	attack_bonus += int(
		hero.temporary_attack_bonus
	)
	
	damage_bonus += int(
		hero.temporary_damage_bonus
	)
	if is_enemy_flanked():
		attack_bonus += int(hero.feat_flanking_attack_bonus)
		damage_bonus += int(hero.feat_flanking_damage_bonus)
		if hero.character_race == "Halfling":
			damage_bonus += 1
	if hero.is_hidden:
		damage_bonus += int(hero.feat_hidden_damage_bonus)
		if hero.enemy_is_surprised and not rogue_was_spotted:
			attack_bonus += int(hero.feat_surprise_attack_bonus)
	
	var high_ground_bonus: int = (
		get_high_ground_attack_bonus_for_unit(
			hero
		)
	)
	
	attack_bonus += high_ground_bonus

	if using_smite:
		attack_bonus += hero.get_smite_evil_attack_bonus()
		damage_bonus += hero.get_smite_evil_damage_bonus()
	
	if high_ground_bonus > 0:
		print(
			"Bônus de terreno alto do herói: +",
			high_ground_bonus
		)
		
		show_floating_text_on_unit(
			hero,
			"TERRENO ALTO +%d"
			% high_ground_bonus,
			18,
			"utility"
		)
	
	var target_ac: int = 10
	
	if enemy.has_method(
		"get_armor_class"
	):
		target_ac = int(
			enemy.get_armor_class()
		)
	
	target_ac = max(
		target_ac,
		1
	)
	
	var control_armor_penalty: int = 0
	
	if "control_armor_penalty" in enemy:
		control_armor_penalty = int(
			enemy.control_armor_penalty
		)
	
	var attack_result: Dictionary = (
		roll_attack_result(
			attack_bonus,
			target_ac,
			hero,
			enemy
		)
	)
	
	var dice_roll: int = int(
		attack_result["dice_roll"]
	)
	
	var attack_total: int = int(
		attack_result["attack_total"]
	)
	
	var attack_hit: bool = bool(
		attack_result["hit"]
	)
	
	var critical_hit: bool = bool(
		attack_result["critical_hit"]
	)
	
	print("====================================")
	print("ATAQUE DO HERÓI")
	print(
		"Alvo: ",
		get_unit_display_name(enemy)
	)
	print("Arma: ", weapon_name)
	print("Tipo da arma: ", weapon_type)
	print(
		"Distância: ",
		distance_meters,
		"m"
	)
	print(
		"Alcance: ",
		weapon_range,
		"m"
	)
	print(
		"Rolagem: d20 ",
		dice_roll
	)
	print(
		"Bônus de terreno alto: ",
		high_ground_bonus
	)
	print(
		"Bônus de ataque: ",
		attack_bonus
	)
	print(
		"Total do ataque: ",
		attack_total
	)
	print(
		"Penalidade de CA no inimigo: ",
		control_armor_penalty
	)
	print(
		"CA final do inimigo: ",
		target_ac
	)
	print("====================================")
	
	if dice_roll == 20:
		print("Acerto crítico natural!")
		
		show_floating_text_on_unit(
			enemy,
			"CRÍTICO!",
			30,
			"critical"
		)
	elif dice_roll == 1:
		print("Erro crítico natural!")
		
		show_floating_text_on_unit(
			enemy,
			"ERROU",
			26,
			"miss"
		)
	
	if attack_hit:
		var damage: int = 1
		
		if hero.has_method(
			"roll_total_weapon_damage"
		):
			damage = int(
				hero.roll_total_weapon_damage()
			)
		else:
			damage = int(
				hero.attack_power
			)
		
		damage += damage_bonus
		
		if critical_hit:
			damage *= 2
		
		if hero.character_class == "Ladino":
			if hero.has_method(
				"get_sneak_attack_damage"
			):
				if can_hero_sneak_attack_enemy():
					var sneak_damage: int = int(
						hero.get_sneak_attack_damage()
					)
					
					damage += sneak_damage
					
					print(
						"Ataque furtivo aplicado!"
					)
					print(
						"Dano furtivo extra: ",
						sneak_damage
					)
					
					show_floating_text_on_unit(
						enemy,
						"FURTIVO!",
						24,
						"critical"
					)
		
		damage = apply_attack_damage_to_unit(
			enemy,
			damage,
			critical_hit
		)
		
		print("Herói acertou.")
		print(
			"Dano final: ",
			damage
		)
	else:
		print("Herói errou o ataque.")
		
		if dice_roll != 1:
			show_floating_text_on_unit(
				enemy,
				"ERROU",
				26,
				"miss"
			)
	
	if hero.character_class == "Ladino":
		if hero.has_method(
			"reveal_after_attack"
		):
			hero.reveal_after_attack()
		
		rogue_was_spotted = false
		rogue_hide_check_done = false

	if using_smite:
		hero.consume_smite_evil()
		clear_prepared_class_attack()
	
	await finish_player_attack(hero)

func get_attack_distance(from_position: Vector2i, to_position: Vector2i) -> int:
	var dx = abs(to_position.x - from_position.x)
	var dy = abs(to_position.y - from_position.y)
	
	return max(dx, dy)

func enemy_turn():
	if not initiative_started:
		print(
			"Inimigo não pode agir antes da iniciativa."
		)
		return
	
	if current_turn != TurnState.ENEMY_TURN:
		return
	
	if is_current_enemy_unable_to_act():
		return
	
	if not is_instance_valid(hero):
		return
	
	var enemy_target: Node2D = (
		get_enemy_target_unit()
	)
	
	if not is_instance_valid(enemy_target):
		print(
			"Inimigo não encontrou alvo válido."
		)
		return
	
	print("====================================")
	print("TURNO DO INIMIGO")
	print(
		"Inimigo: ",
		get_unit_display_name(enemy)
	)
	print(
		"Alvo escolhido: ",
		get_unit_display_name(
			enemy_target
		)
	)
	print("====================================")
	
	center_camera_on_unit(enemy)
	await wait_before_action()
	
	var has_control_effect: bool = false
	
	if enemy.has_method(
		"has_active_control_effect"
	):
		has_control_effect = bool(
			enemy.has_active_control_effect(
				battle_turn_count
			)
		)
	
	if has_control_effect:
		print(
			"Inimigo está sob efeito de controle."
		)
		print(
			"Controle ativo até o turno: ",
			enemy.control_effect_end_turn
		)
		print(
			"Penalidade de ataque: ",
			enemy.control_attack_penalty
		)
		print(
			"Penalidade de CA: ",
			enemy.control_armor_penalty
		)
		print(
			"Penalidade de movimento: ",
			enemy.control_movement_penalty
		)
	
	if enemy.has_method(
		"reset_movement"
	):
		enemy.reset_movement()
	else:
		var movement_penalty: float = 0.0
		
		if "control_movement_penalty" in enemy:
			movement_penalty = float(
				enemy.control_movement_penalty
			)
		
		enemy.current_movement_meters = max(
			0.0,
			enemy.max_movement_meters
			- movement_penalty
		)
		
		enemy.has_attacked = false
		enemy.has_opportunity_attacked = false
	
	apply_active_spell_area_to_unit(
		enemy
	)
	
	if is_current_enemy_unable_to_act():
		return
	
	var advanced_action: Dictionary = (
		get_enemy_advanced_ai_action(
			enemy_target
		)
	)
	
	if await execute_enemy_advanced_action(
		advanced_action,
		enemy_target
	):
		await get_tree().create_timer(
			0.35
		).timeout
		
		update_enemy_control_effects_turn()
		update_active_effects_panel()
		return
	
	if is_current_enemy_unable_to_act():
		return
	
	enemy_target = get_enemy_target_unit()
	
	if not is_instance_valid(enemy_target):
		print(
			"Inimigo não encontrou alvo válido ",
			"após decisão de IA."
		)
		
		update_enemy_control_effects_turn()
		update_active_effects_panel()
		return
	
	var ai_action: Dictionary = (
		get_enemy_basic_ai_action(
			enemy_target
		)
	)
	
	if await execute_enemy_basic_action(
		ai_action,
		enemy_target
	):
		return
	
	await get_tree().create_timer(
		0.45
	).timeout
	
	update_enemy_control_effects_turn()
	update_active_effects_panel()

func move_enemy_to(new_grid_position: Vector2i) -> bool:
	if is_movement_animating:
		return false
	
	if battle_finished:
		return false
	
	if not is_instance_valid(enemy):
		return false
	
	if not is_inside_grid(new_grid_position):
		return false
	
	if new_grid_position == enemy.grid_position:
		return false
	
	var unit_at_position: Node2D = get_unit_at_grid_position(new_grid_position)
	
	if is_instance_valid(unit_at_position):
		if unit_at_position != enemy:
			print("Inimigo tentou mover para posição ocupada: ", new_grid_position)
			return false
	
	var old_position: Vector2i = enemy.grid_position
	
	var path: Array[Vector2i] = get_grid_path_avoiding_units(
		old_position,
		new_grid_position,
		enemy,
		enemy.current_movement_meters,
		true
	)
	
	if path.is_empty():
		print("Inimigo não encontrou caminho válido até: ", new_grid_position)
		return false
	
	var movement_cost: float = get_path_total_cost(old_position, path)
	
	if movement_cost > enemy.current_movement_meters:
		print("Inimigo tentou andar mais do que podia.")
		print("Custo: ", movement_cost, "m | Movimento disponível: ", enemy.current_movement_meters, "m")
		return false
	
	if is_instance_valid(hero):
		check_opportunity_attack(enemy, hero, new_grid_position)
	
	if is_instance_valid(animal_companion):
		check_opportunity_attack(enemy, animal_companion, new_grid_position)
	
	if battle_finished:
		is_movement_animating = false
		clear_path_preview_tiles()
		return false
	
	if enemy.hp <= 0 or not enemy.visible:
		is_movement_animating = false
		clear_path_preview_tiles()
		return false
	
	enemy.current_movement_meters -= movement_cost
	
	if enemy.current_movement_meters < 0.0:
		enemy.current_movement_meters = 0.0
	
	clear_movement_area()
	clear_attack_area()
	show_path_preview(path)
	
	await get_tree().create_timer(0.12).timeout
	await animate_unit_movement(enemy, path)
	
	if not is_instance_valid(enemy):
		is_movement_animating = false
		clear_path_preview_tiles()
		return false
	
	if enemy.hp <= 0 or not enemy.visible:
		is_movement_animating = false
		clear_path_preview_tiles()
		clear_movement_area()
		clear_attack_area()
		return false
	
	enemy.grid_position = new_grid_position
	enemy.position = grid_to_world_position(new_grid_position)
	
	apply_active_spell_area_to_unit(enemy)
	
	update_enemy_hp_bar()
	update_movement_label()
	update_active_effects_panel()
	
	return true
	
func opportunity_attack(
	attacker: Node2D,
	target: Node2D
) -> void:
	if not is_instance_valid(attacker):
		return
	
	if not is_instance_valid(target):
		return
	
	if battle_finished:
		return
	
	if not unit_can_make_opportunity_attack(
		attacker
	):
		print(
			get_unit_display_name(attacker),
			" não pode executar ataque de oportunidade ",
			"com arma à distância."
		)
		return
	
	if attacker.has_opportunity_attacked:
		print(
			"Ataque de oportunidade já usado."
		)
		return
	
	var distance_meters: float = (
		get_distance_in_meters(
			attacker.grid_position,
			target.grid_position
		)
	)
	
	var attacker_range: float = 1.5
	
	if attacker.has_method(
		"get_weapon_range_meters"
	):
		attacker_range = float(
			attacker.get_weapon_range_meters()
		)
	
	if distance_meters > attacker_range:
		print(
			"Alvo fora do alcance do ataque de oportunidade."
		)
		return
	
	var attack_bonus: int = 0
	var damage_bonus: int = 0
	
	if attacker.has_method(
		"get_base_attack_bonus"
	):
		attack_bonus += int(
			attacker.get_base_attack_bonus()
		)
	
	var weapon_type: String = "melee"
	
	if attacker.has_method(
		"get_equipped_weapon_data"
	):
		var weapon_data: Dictionary = (
			attacker.get_equipped_weapon_data()
		)
		
		weapon_type = str(
			weapon_data.get(
				"type",
				"melee"
			)
		)
		
		if weapon_data.has(
			"attack_bonus"
		):
			attack_bonus += int(
				weapon_data["attack_bonus"]
			)
		
		if weapon_data.has(
			"damage_bonus"
		):
			damage_bonus += int(
				weapon_data["damage_bonus"]
			)
	
	if weapon_type == "ranged":
		if attacker.has_method(
			"get_dexterity_modifier"
		):
			attack_bonus += int(
				attacker.get_dexterity_modifier()
			)
	else:
		if attacker.has_method(
			"get_strength_modifier"
		):
			attack_bonus += int(
				attacker.get_strength_modifier()
			)
	
	if attacker == hero:
		attack_bonus += int(
			hero.feat_attack_bonus
		)
		
		damage_bonus += int(
			hero.feat_damage_bonus
		)
		
		if weapon_type == "melee":
			attack_bonus += int(
				hero.feat_melee_attack_bonus
			)
			
			damage_bonus += int(
				hero.feat_melee_damage_bonus
			)
		
		if weapon_type == "ranged":
			attack_bonus += int(
				hero.feat_ranged_attack_bonus
			)
			
			damage_bonus += int(
				hero.feat_ranged_damage_bonus
			)
	
	var target_ac: int = 10
	
	if target.has_method(
		"get_armor_class"
	):
		target_ac = int(
			target.get_armor_class()
		)
	
	var attack_result: Dictionary = (
		roll_attack_result(
			attack_bonus,
			target_ac,
			attacker,
			target
		)
	)
	
	var dice_roll: int = int(
		attack_result["dice_roll"]
	)
	
	var attack_total: int = int(
		attack_result["attack_total"]
	)
	
	var attack_hit: bool = bool(
		attack_result["hit"]
	)
	
	var critical_hit: bool = bool(
		attack_result["critical_hit"]
	)
	
	print("====================================")
	print("ATAQUE DE OPORTUNIDADE")
	show_floating_text_on_unit(attacker, "ATAQUE DE OPORTUNIDADE!", 18, "critical")
	print(
		"Atacante: ",
		get_unit_display_name(attacker)
	)
	print(
		"Alvo: ",
		get_unit_display_name(target)
	)
	print(
		"Distância: ",
		distance_meters,
		"m"
	)
	print(
		"Alcance: ",
		attacker_range,
		"m"
	)
	print(
		"Rolagem: d20 ",
		dice_roll
	)
	print(
		"Bônus de ataque: ",
		attack_bonus
	)
	print(
		"Total: ",
		attack_total
	)
	print(
		"CA do alvo: ",
		target_ac
	)
	print("====================================")
	
	if dice_roll == 20:
		print(
			"Crítico natural no ataque de oportunidade."
		)
		
		show_floating_text_on_unit(
			target,
			"CRÍTICO!",
			30,
			"critical"
		)
	elif dice_roll == 1:
		print(
			"Erro crítico no ataque de oportunidade."
		)
		
		show_floating_text_on_unit(
			target,
			"ERROU",
			26,
			"miss"
		)
	
	if attack_hit:
		var damage: int = 1
		
		if attacker.has_method(
			"roll_total_weapon_damage"
		):
			damage = int(
				attacker.roll_total_weapon_damage()
			)
		elif attacker.has_method(
			"roll_attack_damage"
		):
			damage = int(
				attacker.roll_attack_damage()
			)
		else:
			damage = int(
				attacker.attack_power
			)
		
		damage += damage_bonus
		
		if critical_hit:
			damage *= 2
		
		damage = apply_attack_damage_to_unit(
			target,
			damage,
			critical_hit
		)
		
		print(
			"Ataque de oportunidade acertou."
		)
		print(
			"Dano: ",
			damage
		)
	else:
		print(
			"Ataque de oportunidade errou."
		)
		
		if dice_roll != 1:
			show_floating_text_on_unit(
				target,
				"ERROU",
				26,
				"miss"
			)
	
	if attacker == hero:
		hero.opportunity_attacks_used += 1
		hero.has_opportunity_attacked = hero.opportunity_attacks_used >= 1 + hero.feat_extra_opportunity_attacks
	else:
		attacker.has_opportunity_attacked = true
	
	refresh_combat_ui_after_attack(
		true,
		true
	)
	
	is_movement_animating = false
	clear_path_preview_tiles()
	
	if current_turn == TurnState.HERO_TURN:
		show_movement_area()
	
	if is_instance_valid(
		selected_player_unit
	):
		show_attack_area_for_unit(
			selected_player_unit
		)


func check_opportunity_attack(mover: Node2D, defender: Node2D, new_position: Vector2i):
	if would_provoke_opportunity_attack(mover, defender, new_position):
		opportunity_attack(defender, mover)

func would_provoke_opportunity_attack(mover: Node2D, defender: Node2D, new_position: Vector2i) -> bool:
	if not is_instance_valid(mover):
		return false
	
	if not is_instance_valid(defender):
		return false
	if defender.hp <= 0 or not defender.visible:
		return false
	
	if not defender.has_method("get_weapon_range_meters"):
		return false
	
	if not unit_can_make_opportunity_attack(defender):
		return false
	if "has_opportunity_attacked" in defender and defender.has_opportunity_attacked:
		return false
	
	var old_distance_meters: float = get_distance_in_meters(mover.grid_position, defender.grid_position)
	var new_distance_meters: float = get_distance_in_meters(new_position, defender.grid_position)
	var defender_range: float = float(defender.get_weapon_range_meters())
	
	var was_in_attack_area: bool = old_distance_meters <= defender_range
	var will_be_in_attack_area: bool = new_distance_meters <= defender_range
	
	return was_in_attack_area and not will_be_in_attack_area

func get_opportunity_attackers_for_move(mover: Node2D, destination: Vector2i) -> Array[Node2D]:
	var attackers: Array[Node2D] = []
	for enemy_unit in enemies:
		if would_provoke_opportunity_attack(mover, enemy_unit, destination):
			attackers.append(enemy_unit)
	if enemies.is_empty() and would_provoke_opportunity_attack(mover, enemy, destination):
		attackers.append(enemy)
	return attackers

func start_stage(
	stage_number: int
):
	clear_prepared_class_attack()
	battle_turn_count = 1
	battle_finished = false
	initiative_started = false
	scenario_intro_running = false
	is_movement_animating = false
	
	var banner_controller: Node = (
		get_turn_banner_controller()
	)
	
	if is_instance_valid(banner_controller):
		banner_controller.reset()
	
	load_scenario_data(stage_number)
	setup_scenario_weather()
	
	battle_xp_gained = 0
	battle_gold_gained = 0
	battle_enemies_defeated = 0
	
	current_stage = stage_number
	current_turn = TurnState.HERO_TURN
	if is_instance_valid(combat_action_panel_controller):
		combat_action_panel_controller.set_tutorial_button_visible(current_stage == 1)
	
	current_active_unit = null
	current_initiative_index = 0
	initiative_order.clear()
	
	if is_instance_valid(hero) and hero.is_raging:
		hero.end_rage()
	reset_stage_units(stage_number)
	apply_player_presets()
	if is_instance_valid(hero):
		hero.rage_uses_this_battle = 0
		hero.rage_used = false
		hero.opportunity_attacks_used = 0
		hero.has_opportunity_attacked = false
		hero.unstoppable_active = false
		hero.unstoppable_turn_started = false
		hero.unstoppable_used_this_battle = false
	setup_animal_companion()
	apply_scenario_start_positions()
	
	setup_scenario_npcs()
	setup_scenario_monsters()
	
	selected_player_unit = hero
	
	set_gameplay_panels_visible(false)
	
	clear_movement_area()
	clear_attack_area()
	draw_scenario_background()
	draw_grid()
	update_movement_label()
	update_enemy_hp_bar()
	update_class_skill_button()
	update_turn_counter_label()
	update_active_effects_panel()
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.configure_class_skill_button(
			false,
			true,
			""
		)
		
		combat_action_panel_controller.configure_control_buttons(
			true,
			false,
			false
		)
		
		combat_action_panel_controller.set_cancel_spell_visible(
			false
		)
	
	waiting_spell_target = false
	pending_spell_name = ""
	pending_spell_data = {}
	clear_spell_target_area()
	
	await play_scenario_intro_sequence()
	
	create_scenario_start_panel()
	
	print("====================================")
	print("CENÁRIO PREPARADO")
	print("Cenário: ", current_stage)
	print(
		"Mapa: ",
		current_grid_width,
		"x",
		current_grid_height
	)
	print(
		"Posição do herói: ",
		hero.grid_position
	)
	print(
		"Herói dentro do grid: ",
		is_inside_grid(
			hero.grid_position
		)
	)
	print(
		"Inimigos vivos: ",
		get_alive_enemy_count()
	)
	print(
		"Aguardando jogador rolar iniciativa."
	)
	print("====================================")


func cancel_pending_spell() -> void:
	if not waiting_spell_target:
		return
	if current_stage == 1 and stage_one_tutorial_phase == "magic_target":
		stage_one_tutorial_phase = "magic_menu"
	
	print("Conjuração cancelada.")
	
	waiting_spell_target = false
	pending_spell_name = ""
	pending_spell_data = {}
	
	clear_spell_target_area()
	show_movement_area()
	show_attack_area_for_unit(get_acting_unit())
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_cancel_spell_visible(
			false
		)
	
	show_floating_text_on_unit(
		hero,
		"CANCELADO",
		20,
		"miss"
	)
	
	update_movement_label()

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
	
	load_saved_player_presets_into_game_state()
	configure_hero_from_game_state()
	print_applied_hero_preset()

func show_abandon_confirmation():
	abandon_confirm_popup.popup_centered()


func create_manual_save_popups() -> void:
	save_slot_popup = PopupPanel.new()
	save_slot_popup.title = "Salvar jogo"
	ui_layer.add_child(save_slot_popup)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	save_slot_popup.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)
	var title_label := Label.new()
	title_label.text = "Escolha um dos 4 slots para salvar"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 30 if OS.has_feature("mobile") else 18)
	content.add_child(title_label)
	save_slot_buttons.clear()
	for slot_number in range(1, MANUAL_SAVE_SLOT_COUNT + 1):
		var slot_button := Button.new()
		slot_button.custom_minimum_size = Vector2(700 if OS.has_feature("mobile") else 500, 96 if OS.has_feature("mobile") else 70)
		slot_button.add_theme_font_size_override("font_size", 26 if OS.has_feature("mobile") else 18)
		slot_button.pressed.connect(on_manual_save_slot_selected.bind(slot_number))
		content.add_child(slot_button)
		save_slot_buttons.append(slot_button)
	var close_button := Button.new()
	close_button.text = "Voltar"
	close_button.custom_minimum_size = Vector2(700 if OS.has_feature("mobile") else 500, 76 if OS.has_feature("mobile") else 40)
	close_button.add_theme_font_size_override("font_size", 28 if OS.has_feature("mobile") else 18)
	close_button.pressed.connect(save_slot_popup.hide)
	content.add_child(close_button)
	replace_save_confirmation = ConfirmationDialog.new()
	replace_save_confirmation.title = "Substituir save"
	replace_save_confirmation.ok_button_text = "Substituir"
	replace_save_confirmation.cancel_button_text = "Cancelar"
	replace_save_confirmation.confirmed.connect(confirm_manual_save_replacement)
	if OS.has_feature("mobile"):
		replace_save_confirmation.size = Vector2i(760, 360)
		replace_save_confirmation.get_label().add_theme_font_size_override("font_size", 28)
		replace_save_confirmation.get_ok_button().add_theme_font_size_override("font_size", 28)
		replace_save_confirmation.get_cancel_button().add_theme_font_size_override("font_size", 28)
		replace_save_confirmation.get_ok_button().custom_minimum_size.y = 76
		replace_save_confirmation.get_cancel_button().custom_minimum_size.y = 76
	ui_layer.add_child(replace_save_confirmation)


func create_abandon_popup() -> void:
	abandon_confirm_popup = (
		ConfirmationDialog.new()
	)
	
	abandon_confirm_popup.title = (
		"Abandonar batalha"
	)
	
	abandon_confirm_popup.dialog_text = (
		"Deseja abandonar a batalha e retornar "
		+ "à vila?\n\n"
		+ "Todo XP, ouro e demais progressos obtidos "
		+ "nesta tentativa serão perdidos."
	)
	
	abandon_confirm_popup.ok_button_text = (
		"Abandonar e voltar"
	)
	
	abandon_confirm_popup.cancel_button_text = (
		"Continuar batalha"
	)
	if OS.has_feature("mobile"):
		abandon_confirm_popup.size = Vector2i(820, 400)
		abandon_confirm_popup.get_label().add_theme_font_size_override("font_size", 28)
		abandon_confirm_popup.get_ok_button().add_theme_font_size_override("font_size", 28)
		abandon_confirm_popup.get_cancel_button().add_theme_font_size_override("font_size", 28)
		abandon_confirm_popup.get_ok_button().custom_minimum_size.y = 76
		abandon_confirm_popup.get_cancel_button().custom_minimum_size.y = 76
	
	abandon_confirm_popup.confirmed.connect(
		abandon_game
	)
	
	ui_layer.add_child(
		abandon_confirm_popup
	)


func abandon_game() -> void:
	var return_was_prepared: bool = (
		save_battle_progress_for_village()
	)
	
	if not return_was_prepared:
		push_warning(
			"A batalha não foi abandonada porque "
			+ "o save anterior não pôde ser restaurado."
		)
		
		return
	
	battle_finished = true
	
	clear_movement_area()
	clear_attack_area()
	
	if MusicManage != null:
		MusicManage.fade_out_music(
			0.8
		)
	
	await get_tree().create_timer(
		0.85,
		true
	).timeout
	
	get_tree().change_scene_to_file(
		"res://Scene/main.tscn"
	)
	
func grant_hero_xp(
	amount: int
) -> void:
	if not is_instance_valid(hero):
		return
	
	hero.gain_xp(
		amount
	)
	
	# Durante a batalha, somente o XP é sincronizado.
	# Nível, HP e demais atributos permanecem inalterados
	# até o painel de evolução ser concluído.
	GameState.hero_total_xp = hero.total_xp
	
	GameState.hero_xp_to_next_level = (
		hero.xp_to_next_level
	)
	
	update_movement_label()
	
	if hero.get_pending_level_up_count() > 0:
		print(
			"Herói possui ",
			hero.get_pending_level_up_count(),
			" evolução ou evoluções pendentes."
		)

func update_movement_label() -> void:
	if not is_instance_valid(
		combat_action_panel_controller
	):
		return
	
	var unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(unit):
		combat_action_panel_controller.set_combat_info_text(
			"Nenhuma unidade ativa"
		)
		return
	
	var current_movement: float = 0.0
	var max_movement: float = 0.0
	var attack_used: bool = false
	
	if "current_movement_meters" in unit:
		current_movement = float(
			unit.current_movement_meters
		)
	
	if "max_movement_meters" in unit:
		max_movement = float(
			unit.max_movement_meters
		)
	
	if "has_attacked" in unit:
		attack_used = bool(
			unit.has_attacked
		)
	combat_action_panel_controller.set_turn_resources(current_movement, max_movement, not attack_used)

func can_hero_sneak_attack_enemy() -> bool:
	if not is_instance_valid(hero):
		return false
	
	if not is_instance_valid(enemy):
		return false
	
	if hero.character_class != "Ladino":
		return false
	
	if is_enemy_flanked():
		print("Ataque furtivo permitido: inimigo flanqueado.")
		return true
	
	if hero.is_hidden and hero.enemy_is_surprised and not rogue_was_spotted:
		print("Ataque furtivo permitido: inimigo surpreso.")
		return true
	
	print("Ataque furtivo não permitido.")
	print("Flanqueado: ", is_enemy_flanked())
	print("Escondido: ", hero.is_hidden)
	print("Inimigo surpreso: ", hero.enemy_is_surprised)
	print("Ladino percebido: ", rogue_was_spotted)
	
	return false
	
func use_class_skill():
	var unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(unit):
		return
	
	if current_turn != TurnState.HERO_TURN or not initiative_started or battle_finished:
		return
	
	var unit_class: String = get_unit_class_name(unit)
	
	match unit_class:
		"Bárbaro":
			if unit == hero:
				use_barbarian_rage()
		
		"Bardo":
			print("Música Bárdica selecionada.")
		
		"Clérigo":
			print(
				"Expulsar Mortos-Vivos selecionado."
			)
		
		"Druida":
			print("Forma Selvagem selecionada.")
		
		"Feiticeiro":
			print(
				"Abrir seleção de magia arcana."
			)
		
		"Guerreiro":
			print("Tática de Combate selecionada.")
		
		"Ladino":
			if not unit.has_method("can_use_hide_skill") or not unit.can_use_hide_skill():
				show_floating_text_on_unit(unit, "NÃO PODE ESCONDER-SE", 18, "miss")
				return
			unit.use_hide_skill()
			if unit == hero:
				rogue_was_spotted = false
				rogue_hide_check_done = false
			show_floating_text_on_unit(unit, "ESCONDIDO", 20, "utility")
			check_hidden_rogue_perception(unit)
		
		"Mago":
			print("Abrir magias preparadas.")
		
		"Monge":
			if unit.has_attacked:
				show_floating_text_on_unit(unit, "ATAQUE USADO", 18, "miss")
				return
			prepared_class_attack = "flurry"
			prepared_class_attacker = unit
			show_floating_text_on_unit(unit, "ESCOLHA O ALVO", 18, "utility")
			show_attack_area_for_unit(unit)
		
		"Paladino":
			if unit.has_attacked or not unit.has_method("can_use_smite_evil") or not unit.can_use_smite_evil():
				show_floating_text_on_unit(unit, "DESTRUIR INDISPONÍVEL", 18, "miss")
				return
			unit.activate_smite_evil()
			prepared_class_attack = "smite"
			prepared_class_attacker = unit
			show_floating_text_on_unit(unit, "ESCOLHA O ALVO", 18, "utility")
			show_attack_area_for_unit(unit)
		
		"Ranger":
			print("Inimigo Predileto selecionado.")
		
		_:
			print(
				"Classe sem habilidade configurada: ",
				unit_class
			)
	
	update_class_skill_button()
	update_movement_label()

func clear_prepared_class_attack() -> void:
	if prepared_class_attack == "smite" and is_instance_valid(prepared_class_attacker):
		if "smite_evil_active" in prepared_class_attacker:
			prepared_class_attacker.smite_evil_active = false
	prepared_class_attack = ""
	prepared_class_attacker = null


func perform_flurry_attack(attacker: Node2D) -> void:
	if get_unit_class_name(attacker) != "Monge":
		clear_prepared_class_attack()
		return

	enemy = prepare_player_attack_target(attacker, enemy)
	if not is_instance_valid(enemy):
		return
	var target: Node2D = enemy
	var attack_bonus: int = get_high_ground_attack_bonus_for_unit(attacker)
	if attacker == hero:
		attack_bonus += hero.get_weapon_attack_bonus()
		attack_bonus += int(hero.feat_attack_bonus)
		attack_bonus += int(hero.feat_melee_attack_bonus)
		attack_bonus += int(hero.temporary_attack_bonus)
	else:
		attack_bonus += get_npc_attack_bonus(attacker)

	# Os dois golpes usam o mesmo alvo e consomem uma ação de ataque.
	clear_prepared_class_attack()
	for strike in range(2):
		if not is_instance_valid(target) or target.hp <= 0:
			break
		show_floating_text_on_unit(attacker, "RAJADA %d/2" % (strike + 1), 18, "utility")
		var target_ac: int = int(target.get_armor_class())
		var result: Dictionary = roll_attack_result(attack_bonus, target_ac, attacker, target)
		if bool(result.get("hit", false)):
			var damage: int = 0
			if attacker == hero:
				damage = int(hero.roll_total_weapon_damage())
				damage += int(hero.feat_damage_bonus) + int(hero.feat_melee_damage_bonus)
				damage += int(hero.temporary_damage_bonus)
				if hero.equipped_weapon == "Soco":
					damage += int(hero.feat_unarmed_damage_bonus)
			else:
				damage = get_npc_attack_damage(attacker)
			if bool(result.get("critical_hit", false)):
				damage *= 2
			apply_attack_damage_to_unit(target, damage, bool(result.get("critical_hit", false)))
		else:
			show_floating_text_on_unit(target, "ERROU", 22, "miss")
		if strike == 0 and is_instance_valid(target) and target.hp > 0:
			await get_tree().create_timer(0.3).timeout

	await finish_player_attack(attacker)

func get_smite_status_text() -> String:
	if not is_instance_valid(hero):
		return "-"
	
	if hero.character_class != "Paladino":
		return "-"
	
	if hero.smite_evil_used:
		return "Usado"
	
	if hero.smite_evil_active:
		return "Ativo"
	
	return "Pronto"
func get_player_save_data() -> Dictionary:
	var player_data := {
		"player_name": GameState.player_name,
		"player_class": GameState.player_class,
		"player_race": GameState.player_race,
		
		"hero_level": GameState.hero_level,
		"hero_total_xp": GameState.hero_total_xp,
		"hero_xp_to_next_level":
			GameState.hero_xp_to_next_level,
		"hero_max_level": GameState.hero_max_level,
		
		"hero_max_hp": GameState.hero_max_hp,
		"hero_attack_power":
			GameState.hero_attack_power,
		"hero_max_movement_meters":
			GameState.hero_max_movement_meters,
		
		"hero_strength": GameState.hero_strength,
		"hero_dexterity": GameState.hero_dexterity,
		"hero_constitution":
			GameState.hero_constitution,
		"hero_wisdom": GameState.hero_wisdom,
		"hero_intelligence":
			GameState.hero_intelligence,
		"hero_charisma": GameState.hero_charisma,
		
		"hero_size": GameState.hero_size,
		"hero_size_modifier":
			GameState.hero_size_modifier,
		"hero_favored_class":
			GameState.hero_favored_class,
		"hero_race_traits":
			GameState.hero_race_traits.duplicate(true),
		
		"hero_class_hit_die":
			GameState.hero_class_hit_die,
		"hero_hp_fixed_per_level":
			GameState.hero_hp_fixed_per_level,
		"hero_hp_progression_mode":
			GameState.hero_hp_progression_mode,
		
		"hero_base_attack_bonus_type":
			GameState.hero_base_attack_bonus_type,
		"hero_fortitude_type":
			GameState.hero_fortitude_type,
		"hero_reflex_type":
			GameState.hero_reflex_type,
		"hero_will_type":
			GameState.hero_will_type,
		
		"hero_fortitude_base_bonus":
			GameState.hero_fortitude_base_bonus,
		"hero_reflex_base_bonus":
			GameState.hero_reflex_base_bonus,
		"hero_will_base_bonus":
			GameState.hero_will_base_bonus,
		
		"hero_class_movement_bonus":
			GameState.hero_class_movement_bonus,
		"hero_damage_reduction":
			GameState.hero_damage_reduction,
		"hero_class_features":
			GameState.hero_class_features.duplicate(true),
		
		"hero_feats":
			GameState.hero_feats.duplicate(true),
		
		"hero_equipped_weapon":
			GameState.hero_equipped_weapon,
		"hero_equipped_armor":
			GameState.hero_equipped_armor,
		"hero_equipped_shield":
			GameState.hero_equipped_shield,
		"hero_gold": GameState.hero_gold,
		"hero_animal_companion_type":
			GameState.hero_animal_companion_type,
		
		"hero_known_spells":
			GameState.hero_known_spells.duplicate(true),
		
		"hero_spell_slots_level_0":
			GameState.hero_spell_slots_level_0,
		"hero_spell_slots_level_1":
			GameState.hero_spell_slots_level_1,
		"hero_spell_slots_level_2":
			GameState.hero_spell_slots_level_2,
		
		"hero_max_spell_slots_level_0":
			GameState.hero_max_spell_slots_level_0,
		"hero_max_spell_slots_level_1":
			GameState.hero_max_spell_slots_level_1,
		"hero_max_spell_slots_level_2":
			GameState.hero_max_spell_slots_level_2
	}
	
	if is_instance_valid(hero):
		player_data["player_name"] = (
			hero.character_name
		)
		player_data["player_class"] = (
			hero.character_class
		)
		player_data["player_race"] = (
			hero.character_race
		)
		
		player_data["hero_level"] = hero.level
		player_data["hero_total_xp"] = (
			hero.total_xp
		)
		player_data["hero_xp_to_next_level"] = (
			hero.xp_to_next_level
		)
		player_data["hero_max_level"] = (
			hero.max_level
		)
		
		player_data["hero_max_hp"] = hero.max_hp
		player_data["hero_attack_power"] = (
			hero.attack_power
		)
		player_data["hero_max_movement_meters"] = (
			hero.max_movement_meters
		)
		
		player_data["hero_strength"] = (
			hero.strength
		)
		player_data["hero_dexterity"] = (
			hero.dexterity
		)
		player_data["hero_constitution"] = (
			hero.constitution
		)
		player_data["hero_wisdom"] = (
			hero.wisdom
		)
		player_data["hero_intelligence"] = (
			hero.intelligence
		)
		player_data["hero_charisma"] = (
			hero.charisma
		)
		
		player_data["hero_size"] = (
			hero.character_size
		)
		player_data["hero_size_modifier"] = (
			hero.size_modifier
		)
		player_data["hero_favored_class"] = (
			hero.favored_class
		)
		player_data["hero_race_traits"] = (
			hero.race_traits.duplicate(true)
		)
		
		player_data["hero_class_hit_die"] = (
			hero.class_hit_die
		)
		player_data["hero_hp_fixed_per_level"] = (
			hero.hp_fixed_per_level
		)
		player_data["hero_hp_progression_mode"] = (
			hero.hp_progression_mode
		)
		
		player_data["hero_base_attack_bonus_type"] = (
			hero.base_attack_bonus_type
		)
		player_data["hero_fortitude_type"] = (
			hero.fortitude_type
		)
		player_data["hero_reflex_type"] = (
			hero.reflex_type
		)
		player_data["hero_will_type"] = (
			hero.will_type
		)
		
		player_data["hero_fortitude_base_bonus"] = (
			hero.fortitude_base_bonus
		)
		player_data["hero_reflex_base_bonus"] = (
			hero.reflex_base_bonus
		)
		player_data["hero_will_base_bonus"] = (
			hero.will_base_bonus
		)
		
		player_data["hero_class_movement_bonus"] = (
			hero.class_movement_bonus
		)
		player_data["hero_damage_reduction"] = (
			hero.damage_reduction
		)
		player_data["hero_class_features"] = (
			hero.class_features.duplicate(true)
		)
		
		player_data["hero_feats"] = (
			hero.selected_feats.duplicate(true)
		)
		
		player_data["hero_equipped_weapon"] = (
			hero.equipped_weapon
		)
		player_data["hero_equipped_armor"] = (
			hero.equipped_armor
		)
		player_data["hero_equipped_shield"] = (
			hero.equipped_shield
		)
		player_data["hero_gold"] = hero.gold
		
		player_data[
			"hero_animal_companion_type"
		] = selected_companion_type
		
		player_data["hero_known_spells"] = (
			hero.known_spells.duplicate(true)
		)
		
		player_data["hero_spell_slots_level_0"] = (
			hero.spell_slots_level_0
		)
		player_data["hero_spell_slots_level_1"] = (
			hero.spell_slots_level_1
		)
		player_data["hero_spell_slots_level_2"] = (
			hero.spell_slots_level_2
		)
		
		player_data[
			"hero_max_spell_slots_level_0"
		] = hero.max_spell_slots_level_0
		
		player_data[
			"hero_max_spell_slots_level_1"
		] = hero.max_spell_slots_level_1
		
		player_data[
			"hero_max_spell_slots_level_2"
		] = hero.max_spell_slots_level_2
	
	return player_data
	
func sync_hero_to_game_state() -> void:
	if not is_instance_valid(hero):
		return
	
	GameState.player_name = hero.character_name
	GameState.player_class = hero.character_class
	GameState.player_race = hero.character_race
	
	GameState.hero_level = hero.level
	GameState.hero_total_xp = hero.total_xp
	GameState.hero_xp_to_next_level = (
		hero.xp_to_next_level
	)
	GameState.hero_max_level = hero.max_level
	
	GameState.hero_max_hp = hero.max_hp
	GameState.hero_attack_power = (
		hero.attack_power
	)
	GameState.hero_max_movement_meters = (
		hero.max_movement_meters
	)
	
	GameState.hero_strength = hero.strength
	GameState.hero_dexterity = hero.dexterity
	GameState.hero_constitution = (
		hero.constitution
	)
	GameState.hero_wisdom = hero.wisdom
	GameState.hero_intelligence = (
		hero.intelligence
	)
	GameState.hero_charisma = hero.charisma
	
	GameState.hero_size = (
		hero.character_size
	)
	GameState.hero_size_modifier = (
		hero.size_modifier
	)
	GameState.hero_favored_class = (
		hero.favored_class
	)
	GameState.hero_race_traits = (
		hero.race_traits.duplicate(true)
	)
	
	GameState.hero_class_hit_die = (
		hero.class_hit_die
	)
	GameState.hero_hp_fixed_per_level = (
		hero.hp_fixed_per_level
	)
	GameState.hero_hp_progression_mode = (
		hero.hp_progression_mode
	)
	
	GameState.hero_base_attack_bonus_type = (
		hero.base_attack_bonus_type
	)
	
	GameState.hero_fortitude_base_bonus = (
		hero.fortitude_base_bonus
	)
	GameState.hero_reflex_base_bonus = (
		hero.reflex_base_bonus
	)
	GameState.hero_will_base_bonus = (
		hero.will_base_bonus
	)
	
	GameState.hero_class_movement_bonus = (
		hero.class_movement_bonus
	)
	GameState.hero_damage_reduction = (
		hero.damage_reduction
	)
	GameState.hero_class_features = (
		hero.class_features.duplicate(true)
	)
	
	GameState.hero_equipped_weapon = (
		hero.equipped_weapon
	)
	GameState.hero_equipped_armor = (
		hero.equipped_armor
	)
	GameState.hero_equipped_shield = (
		hero.equipped_shield
	)
	
	GameState.hero_gold = hero.gold
	
	GameState.hero_feats = (
		hero.selected_feats.duplicate(true)
	)
	
	# =====================================================
	# MAGIAS CONHECIDAS
	# =====================================================
	GameState.hero_known_spells = (
		hero.known_spells.duplicate(true)
	)
	
	# =====================================================
	# ESPAÇOS DE MAGIA RESTANTES
	# =====================================================
	GameState.hero_spell_slots_level_0 = (
		hero.spell_slots_level_0
	)
	
	GameState.hero_spell_slots_level_1 = (
		hero.spell_slots_level_1
	)
	
	GameState.hero_spell_slots_level_2 = (
		hero.spell_slots_level_2
	)
	
	# =====================================================
	# ESPAÇOS MÁXIMOS DE MAGIA
	# =====================================================
	GameState.hero_max_spell_slots_level_0 = (
		hero.max_spell_slots_level_0
	)
	
	GameState.hero_max_spell_slots_level_1 = (
		hero.max_spell_slots_level_1
	)
	
	GameState.hero_max_spell_slots_level_2 = (
		hero.max_spell_slots_level_2
	)
	
func create_character_sheet_panel() -> void:
	if is_instance_valid(
		combat_character_sheet_controller
	):
		combat_character_sheet_controller.queue_free()
	
	combat_character_sheet_controller = (
		CombatCharacterSheetScript.new()
	)
	
	add_child(
		combat_character_sheet_controller
	)
	
	combat_character_sheet_controller.setup(
		ui_layer
	)
	combat_character_sheet_controller.set_panel_visible(false)
	sheet_requested_open = false

func create_battle_unit_hud() -> void:
	if is_instance_valid(battle_unit_hud_controller):
		battle_unit_hud_controller.queue_free()
	battle_unit_hud_controller = BattleUnitHudScript.new()
	add_child(battle_unit_hud_controller)
	battle_unit_hud_controller.setup(ui_layer, Callable(self, "toggle_character_sheet"), Callable(self, "toggle_actions_bar"))

func toggle_actions_bar() -> void:
	if not is_instance_valid(combat_action_panel_controller):
		return
	var collapsed: bool = combat_action_panel_controller.toggle_actions_collapsed()
	if is_instance_valid(battle_unit_hud_controller):
		battle_unit_hud_controller.set_actions_collapsed(collapsed)

func toggle_character_sheet() -> void:
	if not is_instance_valid(combat_character_sheet_controller):
		return
	sheet_requested_open = not sheet_requested_open
	combat_character_sheet_controller.set_panel_visible(sheet_requested_open)
	if is_instance_valid(battle_unit_hud_controller):
		battle_unit_hud_controller.set_sheet_open(sheet_requested_open)
	if sheet_requested_open:
		update_character_sheet_panel()

func update_battle_unit_hud() -> void:
	if not is_instance_valid(battle_unit_hud_controller):
		return
	var unit: Node2D = selected_player_unit if is_instance_valid(selected_player_unit) else hero
	if not is_instance_valid(unit):
		return
	var unit_name: String = get_unit_display_name(unit)
	var portrait_texture: Texture2D = get_battle_portrait_texture(unit_name)
	var armor_class: int = int(unit.get_armor_class()) if unit.has_method("get_armor_class") else 10
	battle_unit_hud_controller.update_unit(unit_name, int(unit.hp), int(unit.max_hp), armor_class, portrait_texture)

func get_battle_portrait_texture(unit_name: String) -> Texture2D:
	var enemy_portrait_path: String = get_enemy_turn_portrait_path(unit_name)
	if not enemy_portrait_path.is_empty():
		if not hud_portrait_cache.has(enemy_portrait_path):
			hud_portrait_cache[enemy_portrait_path] = load(enemy_portrait_path) as Texture2D
		return hud_portrait_cache[enemy_portrait_path] as Texture2D
	
	if not is_instance_valid(story_dialog_popup):
		return null
	var portrait_path: String = story_dialog_popup.get_speaker_portrait_path(unit_name)
	if portrait_path.is_empty():
		return null
	if not hud_portrait_cache.has(portrait_path):
		hud_portrait_cache[portrait_path] = story_dialog_popup.load_dialogue_portrait(portrait_path)
	return hud_portrait_cache[portrait_path] as Texture2D

func get_enemy_turn_portrait_path(unit_name: String) -> String:
	var name_lower: String = unit_name.strip_edges().to_lower()
	if name_lower.begins_with("goblin guerreiro"):
		return "res://Assets/Characters/Goblinguerreiro.png"
	if name_lower.begins_with("goblin dardeiro"):
		return "res://Assets/Characters/Goblindardeiro.png"
	if name_lower.begins_with("lobo da ordem") or name_lower.begins_with("lobo cultista"):
		return "res://Assets/Characters/Lobo cultista.png"
	if name_lower.begins_with("cão de caça") or name_lower.begins_with("cão do culto"):
		return "res://Assets/Characters/Lobo cultista.png"
	if name_lower.begins_with("cultista"):
		return "res://Assets/Characters/Cultista1.png"
	return ""

func create_action_panel() -> void:
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.queue_free()
	
	combat_action_panel_controller = (
		CombatActionPanelScript.new()
	)
	
	add_child(
		combat_action_panel_controller
	)
	
	var button_callbacks: Dictionary = {
		"class_skill": Callable(
			self,
			"use_class_skill"
		),
		"magic": Callable(
			self,
			"open_spell_menu"
		),
		"items": Callable(
			self,
			"open_battle_items_menu"
		),
		"tutorial": Callable(
			self,
			"replay_battle_tutorial"
		),
		"end_turn": Callable(
			self,
			"end_hero_turn"
		),
		"save": Callable(
			self,
			"save_manual_game"
		),
		"abandon": Callable(
			self,
			"show_abandon_confirmation"
		)
	}
	
	combat_action_panel_controller.setup(
		ui_layer,
		button_callbacks,
		Callable(
			self,
			"apply_button_sfx"
		)
	)
	combat_action_panel_controller.set_tutorial_button_visible(current_stage == 1)
	
	update_class_skill_button()
	update_movement_label()

func open_battle_items_menu() -> void:
	if not initiative_started or battle_finished or current_turn != TurnState.HERO_TURN:
		return
	if waiting_spell_target:
		cancel_pending_spell()
	var unit: Node2D = get_acting_unit()
	if not is_instance_valid(unit):
		return
	if not is_instance_valid(battle_items_popup):
		battle_items_popup = PopupPanel.new()
		battle_items_popup.name = "BattleItemsPopup"
		ui_layer.add_child(battle_items_popup)
	var popup_style := StyleBoxFlat.new()
	popup_style.bg_color = Color(0.025, 0.035, 0.03, 0.98)
	popup_style.border_color = Color(0.74, 0.57, 0.26)
	popup_style.set_border_width_all(3)
	popup_style.set_corner_radius_all(12)
	popup_style.set_content_margin_all(18)
	battle_items_popup.add_theme_stylebox_override("panel", popup_style)
	for child in battle_items_popup.get_children():
		child.queue_free()

	var content := VBoxContainer.new()
	content.custom_minimum_size = Vector2(740, 220) if OS.has_feature("mobile") else Vector2(510, 180)
	content.add_theme_constant_override("separation", 12)
	battle_items_popup.add_child(content)
	var title := Label.new()
	title.text = "ITENS  •  " + get_unit_display_name(unit)
	title.add_theme_font_size_override("font_size", 26 if OS.has_feature("mobile") else 22)
	title.add_theme_color_override("font_color", Color(0.98, 0.86, 0.59))
	content.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "Poções disponíveis nesta batalha"
	subtitle.add_theme_font_size_override("font_size", 25 if OS.has_feature("mobile") else 15)
	subtitle.modulate = Color(0.82, 0.88, 0.82)
	content.add_child(subtitle)
	content.add_child(HSeparator.new())
	var item_scroll := ScrollContainer.new()
	item_scroll.custom_minimum_size.y = 220 if OS.has_feature("mobile") else 160
	item_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(item_scroll)
	var item_list := VBoxContainer.new()
	item_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_list.add_theme_constant_override("separation", 8)
	item_scroll.add_child(item_list)

	var found_usable: bool = false
	for item_data in InventoryManager.get_inventory_entries():
		if str(item_data.get("item_type", "")) != "consumable":
			continue
		if str(item_data.get("effect_type", "")) != "healing":
			continue
		found_usable = true
		var item_button := Button.new()
		item_button.text = "✚  %s   ×%d" % [
			str(item_data.get("display_name", "Poção")),
			int(item_data.get("quantity", 0))
		]
		item_button.custom_minimum_size.y = 78 if OS.has_feature("mobile") else 42
		item_button.add_theme_font_size_override("font_size", 27 if OS.has_feature("mobile") else 17)
		item_button.add_theme_stylebox_override("normal", create_battle_item_style(Color(0.08, 0.19, 0.13), Color(0.37, 0.75, 0.45)))
		item_button.add_theme_stylebox_override("hover", create_battle_item_style(Color(0.13, 0.28, 0.18), Color(0.56, 0.94, 0.61)))
		item_button.add_theme_stylebox_override("disabled", create_battle_item_style(Color(0.09, 0.10, 0.09), Color(0.30, 0.34, 0.30)))
		item_button.disabled = bool(unit.has_attacked) or int(unit.hp) >= int(unit.max_hp)
		item_button.pressed.connect(use_battle_item.bind(str(item_data.get("id", ""))))
		item_list.add_child(item_button)

	if not found_usable:
		var empty_label := Label.new()
		empty_label.text = "Você ainda não tem poções de cura. Itens encontrados ou comprados aparecerão aqui."
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		item_list.add_child(empty_label)
	elif bool(unit.has_attacked):
		var used_label := Label.new()
		used_label.text = "Esta unidade já usou sua ação de ataque neste turno."
		item_list.add_child(used_label)
	elif int(unit.hp) >= int(unit.max_hp):
		var full_label := Label.new()
		full_label.text = "Esta unidade está com a vida completa."
		item_list.add_child(full_label)
	TouchScrollSupport.enable(item_scroll)

	var close_button := Button.new()
	close_button.text = "Fechar"
	close_button.custom_minimum_size.y = 72 if OS.has_feature("mobile") else 42
	close_button.add_theme_stylebox_override("normal", create_battle_item_style(Color(0.20, 0.14, 0.07), Color(0.78, 0.60, 0.28)))
	close_button.add_theme_font_size_override("font_size", 26 if OS.has_feature("mobile") else 17)
	close_button.pressed.connect(battle_items_popup.hide)
	content.add_child(close_button)
	battle_items_popup.popup_centered(Vector2i(780, 520) if OS.has_feature("mobile") else Vector2i(560, 330))

func create_battle_item_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 7
	style.content_margin_bottom = 7
	return style

func use_battle_item(item_id: String) -> void:
	if not initiative_started or battle_finished or current_turn != TurnState.HERO_TURN:
		return
	var unit: Node2D = get_acting_unit()
	if not is_instance_valid(unit) or bool(unit.has_attacked):
		return
	if int(unit.hp) <= 0 or int(unit.hp) >= int(unit.max_hp):
		return
	var item_data: Dictionary = ItemDatabase.get_item(item_id)
	if str(item_data.get("effect_type", "")) != "healing":
		return
	if not InventoryManager.remove_item(item_id, 1):
		return
	var healed: int = int(item_data.get("healing_bonus", 0))
	for i in range(int(item_data.get("healing_dice_count", 1))):
		healed += randi_range(1, maxi(1, int(item_data.get("healing_dice", 8))))
	apply_healing_to_unit(unit, healed)
	unit.has_attacked = true
	clear_prepared_class_attack()
	if is_instance_valid(battle_items_popup):
		battle_items_popup.hide()
	refresh_selected_unit_ui()
	refresh_action_ui()

func update_magic_button() -> void:
	if not is_instance_valid(
		combat_action_panel_controller
	):
		return
	
	combat_action_panel_controller.configure_magic_button(
		false,
		true,
		"Magias"
	)
	
	if not is_instance_valid(hero):
		return
	
	var acting_unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(acting_unit):
		return
	
	if acting_unit != hero:
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	
	if battle_finished:
		return
	
	var max_spell_level: int = (
		get_max_spell_level_available()
	)
	
	if max_spell_level < 0:
		return
	
	if hero.known_spells.is_empty():
		return
	
	if hero.has_attacked:
		combat_action_panel_controller.configure_magic_button(
			true,
			true,
			"Magia Usada"
		)
		return
	
	var available_slots: int = (
		hero.spell_slots_level_1
		+ hero.spell_slots_level_2
	)
	
	combat_action_panel_controller.configure_magic_button(
		true,
		false,
		(
			"Magias ("
			+ str(available_slots)
			+ ")"
		)
	)

func update_character_sheet_panel() -> void:
	if not is_instance_valid(
		combat_character_sheet_controller
	):
		return
	
	var unit: Node2D = get_inspected_unit()
	var sheet_text: String = ""
	
	if not is_instance_valid(unit):
		sheet_text = "Sem unidade selecionada."
	elif unit == hero:
		sheet_text = (
			combat_character_sheet_controller
			.build_hero_text(
				hero,
				animal_companion,
				get_smite_status_text()
			)
		)
	elif unit == animal_companion:
		sheet_text = (
			combat_character_sheet_controller
			.build_companion_text(
				animal_companion
			)
		)
	elif is_npc_unit(unit):
		sheet_text = (
			combat_character_sheet_controller
			.build_npc_text(
				unit,
				get_unit_display_name(unit)
			)
		)
	else:
		sheet_text = get_unit_display_name(unit)
	
	combat_character_sheet_controller.set_text(
		sheet_text
	)
	update_battle_unit_hud()
	
func get_distance_in_meters(from_position: Vector2i, to_position: Vector2i) -> float:
	var tile_distance: int = get_attack_distance(from_position, to_position)
	return float(tile_distance) * STRAIGHT_MOVE_COST
func update_after_hero_attack():
	refresh_combat_ui_after_attack(true, true)

func update_after_enemy_attack():
	refresh_combat_ui_after_attack()

func check_battle_result() -> void:
	if battle_finished:
		return
	
	await process_defeated_enemy_rewards()
	remove_defeated_enemies_from_initiative()
	refresh_current_enemy_after_death()
	
	# Condições de derrota têm prioridade.
	# Isso impede vitória caso o último inimigo
	# e um NPC protegido morram ao mesmo tempo.
	if is_instance_valid(hero):
		if hero.hp <= 0:
			battle_finished = true
			
			clear_movement_area()
			clear_attack_area()
			
			print(
				"Derrota: o herói foi eliminado."
			)
			
			show_defeat()
			return
	
	var defeated_critical_npc: Node2D = (
		get_defeated_critical_npc()
	)
	
	if is_instance_valid(
		defeated_critical_npc
	):
		battle_finished = true
		
		clear_movement_area()
		clear_attack_area()
		
		print(
			"Derrota: ",
			get_unit_display_name(
				defeated_critical_npc
			),
			" foi eliminado."
		)
		
		show_defeat()
		return
	
	var any_enemy_alive: bool = false
	
	for enemy_unit in enemies:
		if not is_instance_valid(
			enemy_unit
		):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		any_enemy_alive = true
		break
	
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.hp > 0 and enemy.visible:
				any_enemy_alive = true
	
	if not any_enemy_alive:
		battle_finished = true
		
		clear_movement_area()
		clear_attack_area()
		
		var special_victory_was_played: bool = await (
			play_scenario_victory_sequence()
		)
		
		if not special_victory_was_played:
			show_victory()
		
		return

func get_defeated_critical_npc() -> Node2D:
	if current_scenario_data.is_empty():
		return null
	
	var defeat_conditions: Array = (
		current_scenario_data.get(
			"defeat_conditions",
			[]
		)
	)
	
	for condition_data in defeat_conditions:
		var condition_type: String = str(
			condition_data.get(
				"type",
				""
			)
		)
		
		if condition_type != "npc_defeated":
			continue
		
		var npc_id: String = str(
			condition_data.get(
				"npc_id",
				""
			)
		)
		
		if npc_id == "":
			continue
		
		var protected_npc: Node2D = (
			find_scenario_npc_by_id(
				npc_id
			)
		)
		
		if not is_instance_valid(
			protected_npc
		):
			continue
		
		if protected_npc.hp <= 0:
			return protected_npc
	
	return null

func get_battle_result_controller() -> Node:
	if is_instance_valid(
		battle_result_controller
	):
		return battle_result_controller
	
	battle_result_controller = (
		BattleResultDialogsScript.new()
	)
	
	battle_result_controller.name = (
		"BattleResultController"
	)
	
	add_child(battle_result_controller)
	
	var victory_callback := Callable(
		self,
		"on_victory_confirmed"
	)
	
	var defeat_callback := Callable(
		self,
		"on_defeat_confirmed"
	)
	
	if not battle_result_controller.is_connected(
		"victory_confirmed",
		victory_callback
	):
		battle_result_controller.connect(
			"victory_confirmed",
			victory_callback
		)
	
	if not battle_result_controller.is_connected(
		"defeat_confirmed",
		defeat_callback
	):
		battle_result_controller.connect(
			"defeat_confirmed",
			defeat_callback
		)
	
	return battle_result_controller

func create_battle_result_dialogs() -> void:
	if not is_instance_valid(ui_layer):
		return
	
	var controller: Node = (
		get_battle_result_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.setup(ui_layer)

func show_victory() -> void:
	var controller: Node = (
		get_battle_result_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	var hero_level_text: String = "-"
	var hero_xp_text: String = "-"
	var hero_gold_text: String = "-"
	var hero_hp_text: String = "-"
	
	if is_instance_valid(hero):
		hero_level_text = str(hero.level)
		hero_gold_text = str(hero.gold)
		
		hero_hp_text = (
			str(hero.hp)
			+ "/"
			+ str(hero.max_hp)
		)
		
		if (
			hero.has_method(
				"get_xp_progress_in_current_level"
			)
			and hero.has_method(
				"get_xp_needed_for_current_level"
			)
		):
			hero_xp_text = (
				str(
					hero.get_xp_progress_in_current_level()
				)
				+ "/"
				+ str(
					hero.get_xp_needed_for_current_level()
				)
			)
		else:
			hero_xp_text = str(
				hero.total_xp
			)
	
	var result_data: Dictionary = {
		"stage": current_stage,
		"defeated_enemies":
			battle_enemies_defeated,
		"gained_xp":
			battle_xp_gained,
		"gained_gold":
			battle_gold_gained,
		"hero_level":
			hero_level_text,
		"hero_xp":
			hero_xp_text,
		"hero_hp":
			hero_hp_text,
		"hero_gold":
			hero_gold_text
	}
	
	controller.show_victory(
		result_data
	)


func show_defeat() -> void:
	var controller: Node = (
		get_battle_result_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.show_defeat()


func on_victory_confirmed() -> void:
	print("Vitória confirmada.")
	
	await process_pending_hero_level_ups()
	
	sync_hero_to_game_state()
	PartyManager.sync_hero_from_game_state()
	var bridge_was_completed: bool = (
		current_stage == 3
		and MissionManager.is_mission_completed("emerald_bridge")
	)
	if bridge_was_completed:
		GameState.current_location = "village"
	
	var save_successful: bool = (
		save_auto_game(
			"village",
			"town_hall" if bridge_was_completed else ""
		)
	)
	
	if not save_successful:
		push_warning(
			"A evolução foi aplicada, mas o autosave "
			+ "da vitória não pôde ser concluído."
		)
		show_victory()
		var result_controller: Node = get_battle_result_controller()
		var retry_dialog: AcceptDialog = result_controller.get("victory_dialog") as AcceptDialog
		if is_instance_valid(retry_dialog):
			retry_dialog.title = "Falha ao salvar — tente novamente"
		return
	if bridge_was_completed and MusicManage != null:
		MusicManage.fade_out_music(0.8)
		await get_tree().create_timer(0.85, true).timeout
	
	get_tree().change_scene_to_file(
		"res://Scene/village.tscn"
		if bridge_was_completed
		else "res://Scene/main_menu.tscn"
	)


func on_defeat_confirmed() -> void:
	print(
		"Derrota confirmada. Restaurando último save."
	)
	
	var save_path: String = (
		SaveManager.get_active_save_path()
	)
	
	if save_path.strip_edges() == "":
		save_path = AUTOSAVE_PATH
	
	if not FileAccess.file_exists(
		save_path
	):
		push_warning(
			"Nenhum save foi encontrado para restaurar."
		)
		
		get_tree().change_scene_to_file(
			"res://Scene/main_menu.tscn"
		)
		
		return
	
	var save_data: Dictionary = (
		SaveManager.read_save_data(
			save_path
		)
	)
	
	if save_data.is_empty():
		push_warning(
			"O último save está vazio ou não pôde ser lido."
		)
		
		get_tree().change_scene_to_file(
			"res://Scene/main_menu.tscn"
		)
		
		return
	
	GameState.selected_save_path = (
		save_path
	)
	
	GameState.selected_stage = max(
		1,
		int(
			save_data.get(
				"current_stage",
				1
			)
		)
	)
	
	GameState.current_location = str(
		save_data.get(
			"current_location",
			"battle"
		)
	)
	
	GameState.should_load_save = true
	
	# Segurança caso algum sistema futuro pause a árvore
	# durante a tela de derrota.
	get_tree().paused = false
	
	get_tree().change_scene_to_file(
		"res://Scene/main.tscn"
	)

func apply_button_sfx(button: BaseButton):
	if button == null:
		return
	
	if UIAudioManager == null:
		return
	
	button.mouse_entered.connect(UIAudioManager.play_hover)
	button.pressed.connect(UIAudioManager.play_click)
func create_board_root():
	var old_board := get_node_or_null("BoardRoot")
	
	if old_board != null:
		old_board.queue_free()
		await old_board.tree_exited
	
	board_root = Node2D.new()
	board_root.name = "BoardRoot"
	add_child(board_root)
	move_child(board_root, 0)
	
func move_units_to_board_root():
	if board_root == null:
		return
	
	if is_instance_valid(hero):
		if hero.get_parent() != board_root:
			hero.get_parent().remove_child(hero)
			board_root.add_child(hero)
	
	if is_instance_valid(enemy):
		if enemy.get_parent() != board_root:
			enemy.get_parent().remove_child(enemy)
			board_root.add_child(enemy)
func update_board_transform():
	if board_root == null:
		return
	
	board_scale = 1.0
	board_root.scale = Vector2.ONE
	board_root.position = Vector2.ZERO
	
func update_enemy_hp_bar():
	if not is_instance_valid(enemy):
		return
	
	if enemy.has_method("update_health_display"):
		enemy.update_health_display()
	
func update_enemy_control_effects_turn() -> void:
	if not is_instance_valid(enemy):
		return
	
	if enemy.has_method(
		"update_status_effects"
	):
		enemy.update_status_effects(
			battle_turn_count
		)
	
	update_active_effects_panel()

func _process(_delta):
	update_manual_camera_control()
	update_camera_follow()
	
func clear_old_ui() -> void:
	var nodes_to_remove := [
		"UILayer",
		"CharacterSheetPanel",
		"ActionPanel",
		"ScenarioStartPanel",
		"AbandonConfirmPopup"
	]
	
	for node_name in nodes_to_remove:
		var old_node := get_node_or_null(
			node_name
		)
		
		if old_node != null:
			old_node.queue_free()
			await old_node.tree_exited
	
	if is_instance_valid(
		turn_banner_controller
	):
		turn_banner_controller.reset()
	
	ui_layer = null
	abandon_confirm_popup = null
	save_slot_popup = null
	save_slot_buttons.clear()
	replace_save_confirmation = null
	pending_manual_save_slot = 0

func update_class_skill_button() -> void:
	update_magic_button()
	
	if not is_instance_valid(
		combat_action_panel_controller
	):
		return
	
	combat_action_panel_controller.configure_class_skill_button(
		false,
		true,
		""
	)
	
	var unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(unit):
		return
	
	if is_enemy_unit(unit):
		return
	
	if is_npc_unit(unit):
		if not is_player_controlled_npc(unit):
			return
	
	var unit_class: String = get_unit_class_name(
		unit
	)
	
	var skill_labels: Dictionary = {
		"Bárbaro": "Fúria",
		"Bardo": "Música Bárdica",
		"Clérigo": "Expulsar Mortos-Vivos",
		"Druida": "Forma Selvagem",
		"Feiticeiro": "Poder da Linhagem",
		"Guerreiro": "Tática de Combate",
		"Ladino": "Esconder-se",
		"Mago": "Tradição Arcana",
		"Monge": "Rajada de Golpes",
		"Paladino": "Destruir o Mal",
		"Ranger": "Inimigo Predileto"
	}
	
	if not skill_labels.has(unit_class):
		return
	
	var button_text: String = str(
		skill_labels[unit_class]
	)
	
	var button_disabled: bool = false
	
	if unit_class == "Bárbaro" and unit == hero:
		if hero.is_raging:
			button_text = "Fúria Ativa"
			button_disabled = true
		elif not hero.can_use_rage():
			button_text = "Fúria Usada"
			button_disabled = true
	
	if unit_class == "Paladino":
		if unit.has_method("can_use_smite_evil"):
			button_disabled = (
				not unit.can_use_smite_evil()
				and not (prepared_class_attack == "smite" and prepared_class_attacker == unit)
			)
		if prepared_class_attack == "smite" and prepared_class_attacker == unit:
			button_text = "Destruir: alvo?"
			button_disabled = true

	if unit_class == "Ladino" and unit.has_method("can_use_hide_skill"):
		button_disabled = not unit.can_use_hide_skill()
		if "is_hidden" in unit and unit.is_hidden:
			button_text = "Escondido"

	if unit_class == "Monge":
		button_disabled = unit.has_attacked
		if prepared_class_attack == "flurry" and prepared_class_attacker == unit:
			button_text = "Rajada: alvo?"
			button_disabled = true
	
	combat_action_panel_controller.configure_class_skill_button(
		true,
		button_disabled,
		button_text
	)

func use_barbarian_rage():
	if not is_instance_valid(hero):
		return
	
	if hero.character_class != "Bárbaro":
		return
	
	if hero.is_raging:
		print("Fúria já está ativa.")
		show_floating_text_on_unit(hero, "FÚRIA ATIVA", 22, "miss")
		return
	
	if not hero.can_use_rage():
		print("Fúria já foi usada nesta batalha.")
		show_floating_text_on_unit(hero, "FÚRIA USADA", 22, "miss")
		return
	
	if hero.has_method("activate_rage"):
		hero.activate_rage()
		
		if hero.has_method("set_rage_end_turn"):
			hero.set_rage_end_turn(battle_turn_count)
		
		show_floating_text_on_unit(hero, "FÚRIA!", 30, "critical")
		pulse_unit(hero, 0.18, 0.30)
		flash_unit(hero, Color(1.0, 0.25, 0.15, 1.0), 0.24)
		
		if UIAudioManager != null:
			if UIAudioManager.has_method("play_rage"):
				UIAudioManager.play_rage()
	
	update_movement_label()
	update_class_skill_button()
	update_active_effects_panel()
	
	if has_method("update_character_sheet_panel"):
		update_character_sheet_panel()

func use_rogue_hide():
	if not is_instance_valid(hero):
		return
	
	if hero.character_class != "Ladino":
		return
	
	if not hero.has_method("use_hide_skill"):
		print("Herói não possui use_hide_skill().")
		return
	
	if not hero.can_use_hide_skill():
		UIAudioManager.play_error()
		print("Não é possível usar Esconder-se agora.")
		return
	
	UIAudioManager.play_confirm()
	
	hero.use_hide_skill()
	rogue_was_spotted = false
	rogue_hide_check_done = false
	
	update_movement_label()
	update_class_skill_button()
	
	if has_method("update_character_sheet_panel"):
		update_character_sheet_panel()
	
	print("Ladino usou Esconder-se.")
func check_hidden_rogue_perception(rogue: Node2D) -> void:
	if not is_instance_valid(rogue) or get_unit_class_name(rogue) != "Ladino":
		return
	if not rogue.is_hidden:
		return

	var hide_bonus: int = int(rogue.get_dexterity_modifier())
	if rogue == hero:
		hide_bonus += 4 + int(hero.feat_hide_bonus)
	else:
		hide_bonus += int(rogue.hide_bonus)

	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit) or enemy_unit.hp <= 0 or not enemy_unit.visible:
			continue
		if get_distance_in_meters(rogue.grid_position, enemy_unit.grid_position) > 3.0:
			continue
		var enemy_id: int = enemy_unit.get_instance_id()
		if rogue.hide_checked_enemies.has(enemy_id):
			continue
		rogue.hide_checked_enemies[enemy_id] = true

		var observe_bonus: int = int(enemy_unit.observe_bonus)
		if enemy_unit.has_method("get_wisdom_modifier"):
			observe_bonus += int(enemy_unit.get_wisdom_modifier())
		var observe_total: int = randi_range(1, 20) + observe_bonus
		var hide_total: int = randi_range(1, 20) + hide_bonus
		print("Observar de ", get_unit_display_name(enemy_unit), ": ", observe_total,
			" | Esconder-se de ", get_unit_display_name(rogue), ": ", hide_total)

		if observe_total >= hide_total:
			rogue.reveal_after_attack()
			if rogue == hero:
				rogue_was_spotted = true
			show_floating_text_on_unit(rogue, "PERCEBIDO!", 20, "miss")
			break
		show_floating_text_on_unit(enemy_unit, "NÃO PERCEBEU", 18, "utility")

	update_class_skill_button()
func is_enemy_flanked() -> bool:
	if not is_instance_valid(enemy):
		return false
	
	var allies: Array = get_hero_allies_near_enemy()
	return allies.size() > 0

func is_target_flanked_by_ally(target_unit: Node2D, attacker: Node2D) -> bool:
	if not is_instance_valid(target_unit):
		return false
	var allied_units: Array = get_tree().get_nodes_in_group("player_allies")
	if is_instance_valid(hero) and not allied_units.has(hero):
		allied_units.append(hero)
	for ally_unit in allied_units:
		if not is_instance_valid(ally_unit) or ally_unit == attacker or ally_unit == target_unit:
			continue
		if "hp" in ally_unit and ally_unit.hp <= 0:
			continue
		if get_distance_in_meters(ally_unit.grid_position, target_unit.grid_position) <= 1.5:
			return true
	return false

func get_hero_allies_near_enemy() -> Array:
	var allies: Array = []
	
	if not is_instance_valid(enemy):
		return allies
	
	var ally_nodes: Array = get_tree().get_nodes_in_group("player_allies")
	
	for ally_node in ally_nodes:
		if not is_instance_valid(ally_node):
			continue
		
		if ally_node == hero:
			continue
		
		var ally_grid_position: Vector2i = ally_node.grid_position
		var distance_meters: float = get_distance_in_meters(ally_grid_position, enemy.grid_position)
		
		if distance_meters <= 1.5:
			allies.append(ally_node)
	
	return allies
	
func create_spell_popup() -> void:
	if is_instance_valid(
		spell_menu_controller
	):
		spell_menu_controller.queue_free()
	
	spell_menu_controller = (
		SpellMenuScript.new()
	)
	
	add_child(spell_menu_controller)
	
	spell_menu_controller.setup(
		Callable(
			self,
			"apply_button_sfx"
		)
	)
	
func open_spell_menu() -> void:
	if not is_instance_valid(hero):
		print(
			"Não é possível abrir magias: herói inválido."
		)
		return
	
	print("====================================")
	print("ABRINDO MENU DE MAGIAS")
	print("Classe: ", hero.character_class)
	print("Nível: ", hero.level)
	print("Magias conhecidas: ", hero.known_spells)
	print(
		"Slots nível 1: ",
		hero.spell_slots_level_1
	)
	print(
		"Slots nível 2: ",
		hero.spell_slots_level_2
	)
	print("====================================")
	
	if hero.known_spells.is_empty():
		print(
			"O herói não possui magias conhecidas."
		)
		
		show_floating_text_on_unit(
			hero,
			"SEM MAGIAS",
			20,
			"miss"
		)
		return
	
	if not is_instance_valid(
		spell_menu_controller
	):
		create_spell_popup()
	
	if not is_instance_valid(
		spell_menu_controller
	):
		return
	
	var max_spell_level: int = (
		get_max_spell_level_available()
	)
	
	var spell_entries: Array = []
	
	for spell_name_value in hero.known_spells:
		var spell_name: String = str(
			spell_name_value
		)
		
		var spell_data: Dictionary = {}
		
		if SpellDatabase != null:
			if SpellDatabase.has_method(
				"get_spell_data"
			):
				spell_data = (
					SpellDatabase.get_spell_data(
						spell_name
					)
				)
		
		if spell_data.is_empty():
			print(
				"Magia não encontrada no banco: ",
				spell_name
			)
			continue
		
		var spell_level: int = int(
			spell_data.get(
				"level",
				0
			)
		)
		
		if spell_level > max_spell_level:
			continue
		
		var effect: String = (
			get_spell_effect_from_data(
				spell_data
			)
		)
		
		var spell_type: String = (
			get_spell_type_from_data(
				spell_data
			)
		)
		
		var description: String = str(
			spell_data.get(
				"description",
				""
			)
		)
		
		var slot_available: bool = (
			has_spell_slot_available(
				spell_level
			)
		)
		
		var slot_text: String = ""
		
		if spell_level == 0:
			slot_text = "Livre"
			slot_available = true
		elif slot_available:
			slot_text = "Slot disponível"
		else:
			slot_text = "Sem slot"
		
		spell_entries.append(
			{
				"name": spell_name,
				"level": spell_level,
				"slot_text": slot_text,
				"disabled": (
					spell_level > 0
					and not slot_available
				),
				"effect": effect,
				"visual_kind": get_spell_visual_kind(spell_name, spell_data),
				"description": description
			}
		)
		
		print(
			"Magia adicionada ao menu: ",
			spell_name
		)
		print("Efeito: ", effect)
		print("Tipo: ", spell_type)
	
	if spell_entries.is_empty():
		print(
			"Nenhuma magia disponível para este nível."
		)
		
		show_floating_text_on_unit(
			hero,
			"SEM MAGIA DISPONÍVEL",
			18,
			"miss"
		)
		return
	
	spell_menu_controller.show_entries(
		spell_entries,
		Callable(
			self,
			"cast_spell"
		)
	)

		
func cast_spell(
	spell_name: String
) -> void:
	if current_turn != TurnState.HERO_TURN:
		return
	
	if battle_finished:
		return
	
	if not is_instance_valid(hero):
		return
	
	if hero.has_attacked:
		print(
			"O herói já usou sua ação neste turno."
		)
		
		show_floating_text_on_unit(
			hero,
			"AÇÃO USADA",
			22,
			"miss"
		)
		return
	
	var spell_data: Dictionary = {}
	
	if SpellDatabase != null:
		if SpellDatabase.has_method(
			"get_spell_data"
		):
			spell_data = (
				SpellDatabase.get_spell_data(
					spell_name
				)
			)
	
	if spell_data.is_empty():
		print(
			"Magia não encontrada: ",
			spell_name
		)
		return
	
	var spell_level: int = int(
		spell_data.get(
			"level",
			0
		)
	)
	
	if not has_spell_slot_available(
		spell_level
	):
		print(
			"Sem espaço de magia disponível para nível ",
			spell_level
		)
		
		show_floating_text_on_unit(
			hero,
			"SEM SLOT",
			22,
			"miss"
		)
		return
	
	var effect: String = (
		get_spell_effect_from_data(
			spell_data
		)
	)
	
	var spell_type: String = (
		get_spell_type_from_data(
			spell_data
		)
	)
	
	if effect == "":
		print(
			"Magia sem tipo de efeito configurado: ",
			spell_name
		)
		print(
			"Dados da magia: ",
			spell_data
		)
		return
	
	if spell_type == "":
		spell_type = effect
	
	print("====================================")
	print("MAGIA SELECIONADA")
	print("Magia: ", spell_name)
	print("Nível: ", spell_level)
	print("Efeito: ", effect)
	print("Tipo: ", spell_type)
	print("Agora toque no alvo.")
	print("====================================")
	
	pending_spell_name = spell_name
	pending_spell_data = spell_data
	waiting_spell_target = true
	
	clear_movement_area()
	clear_attack_area()
	show_spell_target_area(effect)
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_cancel_spell_visible(
			true
		)
	
	if is_instance_valid(
		spell_menu_controller
	):
		spell_menu_controller.hide_menu()
	
	show_floating_text_on_unit(
		hero,
		"TOQUE NO ALVO",
		20,
		"utility"
	)
	
	update_movement_label()
	on_stage_one_spell_selected()


func cast_pending_spell_on_target(
	target_unit: Node2D
) -> void:
	if not waiting_spell_target:
		return
	
	if pending_spell_name == "":
		waiting_spell_target = false
		return
	
	if pending_spell_data.is_empty():
		waiting_spell_target = false
		return
	
	var effect: String = (
		get_spell_effect_from_data(
			pending_spell_data
		)
	)
	
	var spell_type: String = (
		get_spell_type_from_data(
			pending_spell_data
		)
	)
	
	var spell_level: int = int(
		pending_spell_data.get(
			"level",
			0
		)
	)
	
	if spell_type == "":
		spell_type = effect
	
	if not can_spell_target_unit(
		effect,
		target_unit
	):
		print("Alvo inválido para esta magia.")
		print("Magia: ", pending_spell_name)
		print("Efeito: ", effect)
		
		show_floating_text_on_unit(
			target_unit,
			"ALVO INVÁLIDO",
			20,
			"miss"
		)
		return
	
	if not is_spell_target_in_range(
		target_unit,
		pending_spell_data
	):
		show_floating_text_on_unit(
			target_unit,
			"FORA DO ALCANCE",
			18,
			"miss"
		)
		return
	
	print("====================================")
	print("CONJURAÇÃO")
	print("Magia: ", pending_spell_name)
	print("Nível: ", spell_level)
	print("Efeito: ", effect)
	print("Tipo: ", spell_type)
	print("Alvo: ", target_unit.name)
	print("====================================")
	
	if spell_level > 0:
		consume_spell_slot(
			spell_level
		)

	if UIAudioManager != null:
		UIAudioManager.play_spell(pending_spell_name, pending_spell_data)
	show_spell_visual_on_unit(pending_spell_name, pending_spell_data, target_unit)
	
	if effect == "damage":
		cast_damage_spell(
			pending_spell_name,
			pending_spell_data,
			target_unit
		)
	elif effect == "heal":
		cast_heal_spell(
			pending_spell_name,
			pending_spell_data,
			target_unit
		)
	elif effect == "buff":
		cast_buff_spell(
			pending_spell_name,
			pending_spell_data,
			target_unit
		)
	elif effect == "control":
		cast_control_spell(
			pending_spell_name,
			pending_spell_data,
			target_unit
		)
	elif effect == "utility":
		cast_utility_spell(
			pending_spell_name,
			pending_spell_data,
			target_unit
		)
	else:
		print(
			"Tipo de efeito de magia não reconhecido: ",
			effect
		)
		return
	
	hero.has_attacked = true
	on_stage_one_spell_cast()
	
	waiting_spell_target = false
	pending_spell_name = ""
	pending_spell_data = {}
	
	clear_spell_target_area()
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_cancel_spell_visible(
			false
		)
	
	update_movement_label()
	update_class_skill_button()
	
	if has_method(
		"update_character_sheet_panel"
	):
		update_character_sheet_panel()
	
	if has_method("check_battle_result"):
		check_battle_result()

func get_spell_visual_kind(spell_name: String, spell_data: Dictionary) -> String:
	var configured_kind: String = str(spell_data.get("visual_kind", ""))
	if configured_kind in ["fire", "light", "energy", "heal"]:
		return configured_kind
	var effect: String = get_spell_effect_from_data(spell_data)
	if effect == "heal":
		return "heal"
	var lower_name: String = spell_name.to_lower()
	if "fogo" in lower_name or "chama" in lower_name or "flame" in lower_name:
		return "fire"
	if "luz" in lower_name or "sagrad" in lower_name or "divino" in lower_name:
		return "light"
	return "energy"


func show_spell_visual_on_unit(
	spell_name: String, spell_data: Dictionary, target_unit: Node2D
) -> void:
	if not is_instance_valid(target_unit):
		return
	var visual_parent: Node2D = board_root if is_instance_valid(board_root) else self
	var local_position: Vector2 = visual_parent.to_local(target_unit.global_position)
	spawn_spell_visual(spell_name, spell_data, visual_parent, local_position)


func show_spell_visual_at_grid(
	spell_name: String, spell_data: Dictionary, center_position: Vector2i
) -> void:
	var visual_parent: Node2D = board_root if is_instance_valid(board_root) else self
	spawn_spell_visual(
		spell_name, spell_data, visual_parent,
		grid_to_world_position(center_position)
	)


func spawn_spell_visual(
	spell_name: String, spell_data: Dictionary,
	visual_parent: Node2D, local_position: Vector2
) -> void:
	var visual: Node2D = SpellVisualEffectScript.new()
	visual_parent.add_child(visual)
	visual.position = local_position
	visual.call("configure", get_spell_visual_kind(spell_name, spell_data))


func create_spell_target_layer() -> void:
	if is_instance_valid(
		spell_target_overlay
	):
		return
	
	spell_target_overlay = (
		SpellTargetOverlayScript.new()
	)
	
	spell_target_overlay.setup(
		TILE_SIZE
	)
	
	if is_instance_valid(board_root):
		board_root.add_child(
			spell_target_overlay
		)
	else:
		add_child(
			spell_target_overlay
		)
	
	print("SpellTargetLayer criada.")


func clear_spell_target_area() -> void:
	if not is_instance_valid(
		spell_target_overlay
	):
		return
	
	spell_target_overlay.clear_tiles()


func create_spell_target_tile(
	grid_position: Vector2i,
	feedback_type: String
) -> void:
	if not is_instance_valid(
		spell_target_overlay
	):
		create_spell_target_layer()
	
	if not is_instance_valid(
		spell_target_overlay
	):
		return
	
	spell_target_overlay.create_target_tile(
		grid_position,
		feedback_type
	)

func get_living_enemy_units_for_spells() -> Array[Node2D]:
	var living_enemies: Array[Node2D] = []
	
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		if not living_enemies.has(enemy_unit):
			living_enemies.append(enemy_unit)
	
	if is_instance_valid(enemy):
		if enemy.hp > 0 and enemy.visible:
			if is_enemy_unit(enemy):
				if not living_enemies.has(enemy):
					living_enemies.append(enemy)
	
	return living_enemies
func show_spell_impact_area(
	center_position: Vector2i,
	radius: int,
	feedback_type: String
) -> void:
	if not is_instance_valid(
		spell_target_overlay
	):
		create_spell_target_layer()
	
	if not is_instance_valid(
		spell_target_overlay
	):
		return
	
	var cells: Array = get_spell_area_cells(
		center_position,
		radius
	)
	
	spell_target_overlay.show_impact(
		cells,
		feedback_type
	)
func get_living_allied_units_for_spells() -> Array[Node2D]:
	var living_allies: Array[Node2D] = []
	
	if is_instance_valid(hero):
		if hero.hp > 0 and hero.visible:
			living_allies.append(hero)
	
	var grouped_allies: Array = (
		get_tree().get_nodes_in_group(
			"player_allies"
		)
	)
	
	for ally_candidate in grouped_allies:
		if not ally_candidate is Node2D:
			continue
		
		var ally_unit: Node2D = ally_candidate
		
		if not is_instance_valid(ally_unit):
			continue
		
		if not "hp" in ally_unit:
			continue
		
		if ally_unit.hp <= 0:
			continue
		
		if not ally_unit.visible:
			continue
		
		if not living_allies.has(ally_unit):
			living_allies.append(ally_unit)
	
	if is_instance_valid(animal_companion):
		if (
			animal_companion.hp > 0
			and animal_companion.visible
		):
			if not living_allies.has(
				animal_companion
			):
				living_allies.append(
					animal_companion
				)
	
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if npc_unit.hp <= 0:
			continue
		
		if not npc_unit.visible:
			continue
		
		if str(npc_unit.faction) != "ally":
			continue
		
		if not living_allies.has(npc_unit):
			living_allies.append(npc_unit)
	
	return living_allies

func get_spell_target_candidates(
	effect: String
) -> Array[Node2D]:
	var candidates: Array[Node2D] = []
	
	match effect:
		"damage", "control":
			candidates = (
				get_living_enemy_units_for_spells()
			)
		
		"heal", "buff":
			candidates = (
				get_living_allied_units_for_spells()
			)
		
		"utility":
			candidates = (
				get_living_allied_units_for_spells()
			)
			
			var living_enemies: Array[Node2D] = (
				get_living_enemy_units_for_spells()
			)
			
			for enemy_unit in living_enemies:
				if not candidates.has(enemy_unit):
					candidates.append(enemy_unit)
	
	return candidates

func show_spell_target_area(
	effect: String
) -> void:
	clear_spell_target_area()
	
	if effect == "":
		print(
			"show_spell_target_area recebeu "
			+ "effect vazio."
		)
		return
	
	if not is_instance_valid(hero):
		print(
			"show_spell_target_area: "
			+ "herói inválido."
		)
		return
	
	if pending_spell_data.is_empty():
		print(
			"show_spell_target_area: "
			+ "pending_spell_data vazio."
		)
		return
	
	var spell_range: float = (
		get_spell_range_meters(
			pending_spell_data
		)
	)
	
	var area_radius: int = (
		get_spell_area_radius(
			pending_spell_data
		)
	)
	
	var target_type: String = str(
		pending_spell_data.get(
			"target",
			""
		)
	)
	
	print("====================================")
	print("MOSTRANDO ÁREA/ALVOS DA MAGIA")
	print("Magia: ", pending_spell_name)
	print("Efeito: ", effect)
	print("Target: ", target_type)
	print("Alcance: ", spell_range)
	print("Raio da área: ", area_radius)
	print("====================================")
	
	var is_area_spell: bool = (
		area_radius > 0
		or target_type == "area"
	)
	if not is_instance_valid(spell_target_overlay):
		create_spell_target_layer()
	if not is_instance_valid(spell_target_overlay):
		return
	
	if is_area_spell:
		var area_tiles_created: int = 0
		
		for x in range(current_grid_width):
			for y in range(current_grid_height):
				var grid_position := Vector2i(
					x,
					y
				)
				
				var distance_to_cell: float = (
					get_distance_in_meters(
						hero.grid_position,
						grid_position
					)
				)
				
				if distance_to_cell > spell_range:
					continue
				
				create_spell_target_tile(
					grid_position,
					effect
				)
				
				area_tiles_created += 1
		
		print(
			"Tiles de área criados: ",
			area_tiles_created
		)
		return
	for x in range(current_grid_width):
		for y in range(current_grid_height):
			var cell := Vector2i(x, y)
			if get_distance_in_meters(hero.grid_position, cell) <= spell_range:
				spell_target_overlay.create_range_tile(cell, effect)
	
	var target_tiles_created: int = 0
	
	var target_candidates: Array[Node2D] = (
		get_spell_target_candidates(
			effect
		)
	)
	
	for target_unit in target_candidates:
		if not is_instance_valid(target_unit):
			continue
		
		var distance_to_target: float = (
			get_distance_in_meters(
				hero.grid_position,
				target_unit.grid_position
			)
		)
		
		if distance_to_target > spell_range:
			continue
		
		create_spell_target_tile(
			target_unit.grid_position,
			effect
		)
		
		target_tiles_created += 1
	
	print(
		"Alvos válidos destacados: ",
		target_tiles_created
	)

func is_spell_target_in_range(target_unit: Node2D, spell_data: Dictionary) -> bool:
	if not is_instance_valid(hero):
		return false
	
	if not is_instance_valid(target_unit):
		return false
	
	var spell_range: float = get_spell_range_meters(spell_data)
	var distance_to_target: float = get_distance_in_meters(hero.grid_position, target_unit.grid_position)
	
	if distance_to_target <= spell_range:
		return true
	
	print("Alvo fora do alcance da magia.")
	print("Distância: ", distance_to_target, "m")
	print("Alcance da magia: ", spell_range, "m")
	return false

func has_spell_slot_available(spell_level: int) -> bool:
	if not is_instance_valid(hero):
		return false
	
	var max_spell_level: int = get_max_spell_level_available()
	
	if spell_level > max_spell_level:
		return false
	
	if spell_level == 0:
		return true
	
	if spell_level == 1:
		return hero.spell_slots_level_1 > 0
	
	if spell_level == 2:
		return hero.spell_slots_level_2 > 0
	
	return false


func consume_spell_slot(spell_level: int):
	if not is_instance_valid(hero):
		return
	
	if spell_level == 0:
		return
	
	if spell_level == 1:
		hero.spell_slots_level_1 -= 1
		
		if hero.spell_slots_level_1 < 0:
			hero.spell_slots_level_1 = 0
	
	elif spell_level == 2:
		hero.spell_slots_level_2 -= 1
		
		if hero.spell_slots_level_2 < 0:
			hero.spell_slots_level_2 = 0

func cast_damage_spell(
	spell_name: String,
	spell_data: Dictionary,
	target_unit: Node2D = null
) -> void:
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(target_unit):
		target_unit = enemy
	
	if not is_instance_valid(target_unit):
		return
	
	var save_result: Dictionary = (
		roll_spell_save_for_unit(
			target_unit,
			spell_name,
			spell_data,
			"damage"
		)
	)
	
	if save_result.is_empty():
		return
	
	var dice: int = int(
		spell_data.get(
			"value_dice",
			4
		)
	)
	
	var dice_count: int = int(
		spell_data.get(
			"value_dice_count",
			1
		)
	)
	
	var flat_bonus: int = int(
		spell_data.get(
			"flat_bonus",
			0
		)
	)
	
	var spell_type: String = (
		get_spell_type_from_data(
			spell_data
		)
	)
	
	if spell_type == "":
		spell_type = "damage"
	
	var rolled_damage: int = flat_bonus
	
	if dice > 0:
		for i in range(dice_count):
			rolled_damage += randi_range(
				1,
				dice
			)
	
	rolled_damage += int(
		hero.feat_spell_power_bonus
	)
	rolled_damage += int(hero.feat_spell_damage_bonus)
	rolled_damage += hero.get_class_spell_damage_bonus(int(spell_data.get("level", 0)))
	rolled_damage += hero.get_racial_damage_bonus()
	if hero.character_race == "Halfling" and is_target_flanked_by_ally(target_unit, hero):
		rolled_damage += 1
	
	if hero.has_method(
		"get_spell_feat_bonus_for_type"
	):
		rolled_damage += int(
			hero.get_spell_feat_bonus_for_type(
				spell_type
			)
		)
	
	var resisted: bool = bool(
		save_result.get(
			"resisted",
			false
		)
	)
	
	var final_damage: int = max(
		0,
		rolled_damage
	)
	
	var effect_description: String = (
		"Dano completo."
	)
	
	if resisted:
		final_damage = int(
			ceil(
				float(final_damage) / 2.0
			)
		)
		
		effect_description = (
			"Resistiu: metade do dano."
		)
	
	var applied_damage: int = (
		apply_damage_to_unit(
			target_unit,
			final_damage,
			28,
			7.0,
			0.24,
			Color(
				0.65,
				0.25,
				1.0,
				1.0
			),
			0.20
		)
	)
	
	show_spell_resolution_box(
		spell_name,
		target_unit,
		save_result,
		applied_damage,
		effect_description
	)
	
	print("====================================")
	print("MAGIA DE DANO")
	print("Magia: ", spell_name)
	print("Tipo da magia: ", spell_type)
	print(
		"Alvo: ",
		get_unit_display_name(target_unit)
	)
	print("Dano rolado: ", rolled_damage)
	print("Dano aplicado: ", applied_damage)
	print("Resistiu: ", resisted)
	print("====================================")


func cast_heal_spell(
	spell_name: String,
	spell_data: Dictionary,
	target_unit: Node2D = null
):
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(target_unit):
		target_unit = hero
	
	var dice: int = int(
		spell_data.get("value_dice", 8)
	)
	
	var dice_count: int = int(
		spell_data.get("value_dice_count", 1)
	)
	
	var flat_bonus: int = int(
		spell_data.get("flat_bonus", 0)
	)
	
	var spell_type: String = (
		get_spell_type_from_data(spell_data)
	)
	
	if spell_type == "":
		spell_type = "heal"
	
	var heal_value: int = flat_bonus
	
	for i in range(dice_count):
		heal_value += randi_range(1, dice)
	
	heal_value += int(hero.feat_spell_power_bonus)
	heal_value += int(hero.feat_healing_bonus)
	if hero.character_class == "Clérigo" or hero.character_class == "Paladino":
		heal_value += int(hero.feat_divine_healing_bonus)
	
	if hero.has_method(
		"get_spell_feat_bonus_for_type"
	):
		heal_value += int(
			hero.get_spell_feat_bonus_for_type(
				spell_type
			)
		)
	
	var restored_hp: int = apply_healing_to_unit(
		target_unit,
		heal_value,
		28,
		0.16,
		0.28,
		0.22
	)
	
	print("====================================")
	print("MAGIA DE CURA")
	print("Magia: ", spell_name)
	print("Tipo da magia: ", spell_type)
	print(
		"Alvo: ",
		get_unit_display_name(target_unit)
	)
	print("Cura final: ", restored_hp)
	print(
		"HP atual: ",
		target_unit.hp,
		"/",
		target_unit.max_hp
	)
	print("====================================")


func cast_buff_spell(
	spell_name: String,
	spell_data: Dictionary,
	target_unit: Node2D = null
) -> void:
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(target_unit):
		target_unit = hero
	
	if not can_spell_target_unit(
		"buff",
		target_unit
	):
		return
	
	var spell_type: String = (
		get_spell_type_from_data(
			spell_data
		)
	)
	
	if spell_type == "":
		spell_type = "buff"
	
	var attack_bonus: int = int(
		spell_data.get(
			"attack_bonus",
			0
		)
	)
	
	var damage_bonus: int = int(
		spell_data.get(
			"damage_bonus",
			0
		)
	)
	
	var armor_bonus: int = int(
		spell_data.get(
			"armor_bonus",
			0
		)
	)
	
	var movement_bonus: float = float(
		spell_data.get(
			"movement_bonus",
			0.0
		)
	)
	
	var duration: int = max(
		1,
		int(
			spell_data.get(
				"duration",
				1
			)
		)
	)
	if hero.character_class == "Clérigo" or hero.character_class == "Paladino":
		duration += int(hero.feat_divine_buff_duration_bonus)
	
	var feat_bonus: int = 0
	
	if hero.has_method(
		"get_spell_feat_bonus_for_type"
	):
		feat_bonus = int(
			hero.get_spell_feat_bonus_for_type(
				spell_type
			)
		)
	
	if attack_bonus > 0:
		attack_bonus += feat_bonus
	
	if damage_bonus > 0:
		damage_bonus += feat_bonus
	
	if armor_bonus > 0:
		armor_bonus += feat_bonus
	
	if movement_bonus > 0.0:
		movement_bonus += float(
			feat_bonus
		)
	
	var effect_end_turn: int = (
		battle_turn_count + duration
	)
	
	if target_unit == hero:
		hero.temporary_attack_bonus = attack_bonus
		hero.temporary_damage_bonus = damage_bonus
		hero.temporary_armor_class_bonus = armor_bonus
		hero.temporary_movement_bonus = movement_bonus
		hero.temporary_effects_active = true
		hero.temporary_effects_end_turn = effect_end_turn
		hero.temporary_effects_turns_remaining = duration
		
		hero.max_movement_meters += movement_bonus
		hero.current_movement_meters += movement_bonus
	
	elif target_unit.has_method(
		"apply_spell_buff"
	):
		target_unit.apply_spell_buff(
			attack_bonus,
			damage_bonus,
			armor_bonus,
			movement_bonus,
			effect_end_turn
		)
	else:
		print(
			"Alvo não possui suporte funcional para buffs: ",
			get_unit_display_name(target_unit)
		)
		return
	
	print("====================================")
	print("MAGIA DE BUFF")
	print("Magia: ", spell_name)
	print("Tipo da magia: ", spell_type)
	print(
		"Alvo: ",
		get_unit_display_name(target_unit)
	)
	print("Bônus ataque: ", attack_bonus)
	print("Bônus dano: ", damage_bonus)
	print("Bônus CA: ", armor_bonus)
	print("Bônus movimento: ", movement_bonus)
	print("Duração: ", duration, " turnos")
	print("====================================")
	
	show_floating_text_on_unit(
		target_unit,
		"BUFF",
		26,
		"buff"
	)
	
	pulse_unit(
		target_unit,
		0.14,
		0.28
	)
	
	flash_unit(
		target_unit,
		Color(
			0.3,
			0.55,
			1.0,
			1.0
		),
		0.22
	)
	
	update_active_effects_panel()
	update_movement_label()
	
	if has_method(
		"update_character_sheet_panel"
	):
		update_character_sheet_panel()


func cast_control_spell(
	spell_name: String,
	spell_data: Dictionary,
	target_unit: Node2D = null
) -> void:
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(target_unit):
		target_unit = enemy
	
	if not is_instance_valid(target_unit):
		return
	
	if not can_spell_target_unit(
		"control",
		target_unit
	):
		return
	
	var save_result: Dictionary = (
		roll_spell_save_for_unit(
			target_unit,
			spell_name,
			spell_data,
			"control"
		)
	)
	
	if save_result.is_empty():
		return
	
	var resisted: bool = bool(
		save_result.get(
			"resisted",
			false
		)
	)
	
	if resisted:
		show_spell_resolution_box(
			spell_name,
			target_unit,
			save_result,
			0,
			"Efeito de controle evitado."
		)
		
		show_floating_text_on_unit(
			target_unit,
			"RESISTIU",
			22,
			"miss"
		)
		
		flash_unit(
			target_unit,
			Color(
				0.85,
				0.85,
				0.85,
				1.0
			),
			0.18
		)
		
		return
	
	var spell_type: String = (
		get_spell_type_from_data(
			spell_data
		)
	)
	
	if spell_type == "":
		spell_type = "control"
	
	var damage_dice: int = int(
		spell_data.get(
			"value_dice",
			0
		)
	)
	
	var damage_dice_count: int = int(
		spell_data.get(
			"value_dice_count",
			0
		)
	)
	
	var flat_damage: int = int(
		spell_data.get(
			"flat_bonus",
			0
		)
	)
	
	var duration: int = max(
		1,
		int(
			spell_data.get(
				"duration",
				2
			)
		)
	)
	
	var attack_penalty: int = int(
		spell_data.get(
			"attack_penalty",
			0
		)
	)
	
	var armor_penalty: int = int(
		spell_data.get(
			"armor_penalty",
			0
		)
	)
	
	var movement_penalty: float = float(
		spell_data.get(
			"movement_penalty",
			0.0
		)
	)
	
	var feat_bonus: int = 0
	
	if hero.has_method(
		"get_spell_feat_bonus_for_type"
	):
		feat_bonus = int(
			hero.get_spell_feat_bonus_for_type(
				spell_type
			)
		)
	
	var rolled_damage: int = flat_damage
	
	if damage_dice > 0:
		for i in range(
			damage_dice_count
		):
			rolled_damage += randi_range(
				1,
				damage_dice
			)
	
	if rolled_damage > 0:
		rolled_damage += feat_bonus + int(hero.feat_spell_damage_bonus)
		rolled_damage += hero.get_class_spell_damage_bonus(int(spell_data.get("level", 0)))
		rolled_damage += hero.get_racial_damage_bonus()
		if hero.character_race == "Halfling" and is_target_flanked_by_ally(target_unit, hero):
			rolled_damage += 1
	
	var applied_damage: int = 0
	
	if rolled_damage > 0:
		applied_damage = apply_damage_to_unit(
			target_unit,
			rolled_damage,
			28,
			7.0,
			0.24,
			Color(
				0.35,
				0.55,
				1.0,
				1.0
			),
			0.20
		)
	
	var effect_end_turn: int = (
		battle_turn_count + duration
	)
	
	if target_unit.has_method(
		"apply_control_effect"
	):
		target_unit.apply_control_effect(
			attack_penalty,
			armor_penalty,
			movement_penalty,
			effect_end_turn
		)
	else:
		print(
			"Alvo não possui suporte para controle: ",
			get_unit_display_name(target_unit)
		)
		return
	
	enemy = target_unit
	show_spell_resolution_box(
		spell_name,
		target_unit,
		save_result,
		applied_damage,
		"Efeito de controle aplicado."
	)
	
	print("====================================")
	print("MAGIA DE CONTROLE")
	print("Magia: ", spell_name)
	print("Tipo da magia: ", spell_type)
	print(
		"Alvo: ",
		get_unit_display_name(target_unit)
	)
	print("Dano: ", applied_damage)
	print(
		"Penalidade ataque: ",
		attack_penalty
	)
	print(
		"Penalidade CA: ",
		armor_penalty
	)
	print(
		"Penalidade movimento: ",
		movement_penalty
	)
	print(
		"Duração: ",
		duration,
		" turnos"
	)
	print("====================================")
	
	show_floating_text_on_unit(
		target_unit,
		"CONTROLE",
		24,
		"control"
	)
	
	shake_unit(
		target_unit,
		5.0,
		0.22
	)
	
	flash_unit(
		target_unit,
		Color(
			0.35,
			0.55,
			1.0,
			1.0
		),
		0.22
	)
	
	update_enemy_hp_bar()
	update_active_effects_panel()

func cast_utility_spell(spell_name: String, spell_data: Dictionary, target_unit: Node2D = null):
	if not is_instance_valid(hero):
		return
	
	if not is_instance_valid(target_unit):
		target_unit = hero
	
	var spell_type: String = get_spell_type_from_data(spell_data)
	
	if spell_type == "":
		spell_type = "utility"
	
	var effect_name: String = str(spell_data.get("utility_effect", "none"))
	var duration: int = int(spell_data.get("duration", 1))
	
	var feat_bonus: int = 0
	
	if hero.has_method("get_spell_feat_bonus_for_type"):
		feat_bonus = int(hero.get_spell_feat_bonus_for_type(spell_type))
	
	print("====================================")
	print("MAGIA DE UTILIDADE")
	print("Magia: ", spell_name)
	print("Tipo da magia: ", spell_type)
	print("Alvo: ", target_unit.name)
	print("Efeito utilitário: ", effect_name)
	print("Bônus por talento: ", feat_bonus)
	print("Duração: ", duration, " turnos")
	print("====================================")
	
	if effect_name == "detect":
		print("Você sente presenças ou perigos próximos.")
	
	elif effect_name == "light":
		print("Uma luz mágica ilumina a área.")
	
	elif effect_name == "protect":
		if target_unit == hero:
			hero.temporary_armor_class_bonus += 1 + feat_bonus
			hero.temporary_effects_turns_remaining = duration
		
		print("Proteção mágica aplicada.")
	
	else:
		print("Efeito utilitário ainda não implementado.")
	
	show_floating_text_on_unit(target_unit, "UTILIDADE", 22, "utility")
	pulse_unit(target_unit, 0.10, 0.24)
	flash_unit(target_unit, Color(0.3, 0.55, 1.0, 1.0), 0.22)

func get_max_spell_level_available() -> int:
	if not is_instance_valid(hero):
		return -1
	
	if hero.character_class == "Bardo":
		if hero.level >= 4:
			return 2
		return 1
	
	if hero.character_class == "Mago":
		if hero.level >= 3:
			return 2
		return 1
	
	if hero.character_class == "Feiticeiro":
		if hero.level >= 4:
			return 2
		return 1
	
	if hero.character_class == "Clérigo":
		if hero.level >= 3:
			return 2
		return 1
	
	if hero.character_class == "Druida":
		if hero.level >= 3:
			return 2
		return 1
	
	if hero.character_class == "Paladino":
		if hero.level >= 7:
			return 2
		if hero.level >= 4:
			return 1
		return -1
	
	if hero.character_class == "Ranger":
		if hero.level >= 7:
			return 2
		if hero.level >= 4:
			return 1
		return -1
	
	return -1
func hero_has_animal_companion() -> bool:
	if not is_instance_valid(hero):
		return false
	
	if hero.character_class == "Druida":
		return true
	
	if hero.character_class == "Ranger" and hero.level >= 4:
		return true
	
	return false
func setup_animal_companion():
	remove_animal_companion()
	
	if not hero_has_animal_companion():
		return
	
	animal_companion = (
		ANIMAL_COMPANION_SCENE.instantiate()
	)
	animal_companion.name = "AnimalCompanion"
	
	if board_root != null:
		board_root.add_child(
			animal_companion
		)
	else:
		add_child(
			animal_companion
		)
	
	if animal_companion.has_signal(
		"companion_defeated"
	):
		animal_companion.companion_defeated.connect(
			on_animal_companion_defeated
		)
	
	animal_companion.grid_position = (
		find_free_position_near_hero()
	)
	animal_companion.z_index = 20
	animal_companion.visible = true
	
	if animal_companion.has_method(
		"setup_companion"
	):
		animal_companion.setup_companion(
			selected_companion_type,
			hero.character_class,
			hero.level
		)
	
	# =====================================================
	# TALENTOS DO COMPANHEIRO ANIMAL
	# =====================================================
	if is_instance_valid(hero):
		animal_companion.max_hp += int(
			hero.feat_animal_companion_hp_bonus
		)
		
		animal_companion.hp = (
			animal_companion.max_hp
		)
		
		animal_companion.base_attack_bonus += int(
			hero.feat_animal_companion_attack_bonus
		)
		
		animal_companion.damage_bonus += int(
			hero.feat_animal_companion_damage_bonus
		)
		
		animal_companion.attack_power = (
			animal_companion.damage_dice
			+ animal_companion.damage_bonus
		)
		
		animal_companion.armor_class += int(
			hero.feat_animal_companion_armor_bonus
		)
		
		animal_companion.max_movement_meters += float(
			hero.feat_animal_companion_movement_bonus
		)
		
		animal_companion.current_movement_meters = (
			animal_companion.max_movement_meters
		)
	
	if animal_companion.has_method(
		"update_world_position"
	):
		animal_companion.update_world_position()
	
	if animal_companion.has_method(
		"update_health_display"
	):
		animal_companion.update_health_display()
	
	apply_active_spell_area_to_unit(
		animal_companion
	)
	
	animal_companion.add_to_group(
		"player_allies"
	)
	
	print(
		"Companheiro animal criado: ",
		selected_companion_type
	)
	print(
		"HP do companheiro: ",
		animal_companion.hp,
		"/",
		animal_companion.max_hp
	)
	print(
		"Ataque do companheiro: ",
		animal_companion.get_attack_bonus()
	)
	print(
		"CA do companheiro: ",
		animal_companion.get_armor_class()
	)
	print(
		"Movimento do companheiro: ",
		animal_companion.max_movement_meters
	)


func remove_animal_companion():
	if not is_instance_valid(animal_companion):
		animal_companion = null
		return
	
	var companion_to_remove: Node2D = animal_companion
	
	for index in range(
		initiative_order.size() - 1,
		-1,
		-1
	):
		if initiative_order[index] != companion_to_remove:
			continue
		
		initiative_order.remove_at(index)
		
		if index < current_initiative_index:
			current_initiative_index -= 1
	
	if current_initiative_index < 0:
		current_initiative_index = 0
	
	if current_active_unit == companion_to_remove:
		current_active_unit = null
	
	if selected_player_unit == companion_to_remove:
		if is_instance_valid(hero):
			selected_player_unit = hero
		else:
			selected_player_unit = null
	
	companion_to_remove.queue_free()
	animal_companion = null
	
	refresh_action_ui()
	refresh_selected_unit_ui()

func find_free_position_near_hero() -> Vector2i:
	if not is_instance_valid(hero):
		return Vector2i(6, 7)
	
	var possible_positions: Array[Vector2i] = [
		hero.grid_position + Vector2i(-1, 0),
		hero.grid_position + Vector2i(1, 0),
		hero.grid_position + Vector2i(0, -1),
		hero.grid_position + Vector2i(0, 1),
		hero.grid_position + Vector2i(-1, -1),
		hero.grid_position + Vector2i(1, -1),
		hero.grid_position + Vector2i(-1, 1),
		hero.grid_position + Vector2i(1, 1)
	]
	
	for grid_pos in possible_positions:
		if is_position_free_for_ally(grid_pos):
			return grid_pos
	
	return hero.grid_position + Vector2i(-1, 0)


func is_position_free_for_ally(grid_pos: Vector2i) -> bool:
	if not is_inside_grid(grid_pos):
		return false
	
	if is_instance_valid(hero):
		if grid_pos == hero.grid_position:
			return false
	
	if is_instance_valid(enemy):
		if grid_pos == enemy.grid_position:
			return false
	
	return true
func handle_player_grid_click(
	clicked_grid_position: Vector2i
):
	if not initiative_started:
		return
	
	if battle_finished:
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	
	if not is_inside_grid(
		clicked_grid_position
	):
		return
	
	if not is_instance_valid(
		current_active_unit
	):
		print(
			"Nenhuma unidade ativa no turno."
		)
		return
	
	if current_active_unit.hp <= 0:
		return
	
	var clicked_unit: Node2D = (
		get_unit_at_grid_position(
			clicked_grid_position
		)
	)
	
	# =====================================================
	# CLIQUE PARA CONJURAÇÃO
	# Deve ser processado antes de ataque, seleção e movimento.
	# =====================================================
	if waiting_spell_target:
		if pending_spell_data.is_empty():
			cancel_pending_spell()
			return
		
		var area_radius: int = (
			get_spell_area_radius(
				pending_spell_data
			)
		)
		
		var target_type: String = str(
			pending_spell_data.get(
				"target",
				""
			)
		)
		
		var is_area_spell: bool = (
			area_radius > 0
			or target_type == "area"
		)
		
		if is_area_spell:
			if not is_spell_cell_in_range(
				clicked_grid_position,
				pending_spell_data
			):
				show_floating_text_on_unit(
					hero,
					"FORA DO ALCANCE",
					18,
					"miss"
				)
				return
			
			await cast_pending_area_spell(
				clicked_grid_position
			)
			return
		
		if not is_instance_valid(
			clicked_unit
		):
			show_floating_text_on_unit(
				hero,
				"SELECIONE UM ALVO",
				18,
				"miss"
			)
			return
		
		var pending_effect: String = (
			get_spell_effect_from_data(
				pending_spell_data
			)
		)
		
		if pending_effect in [
			"damage",
			"control"
		]:
			if is_enemy_unit(clicked_unit):
				enemy = clicked_unit
		
		cast_pending_spell_on_target(
			clicked_unit
		)
		return
	
	# =====================================================
	# SELEÇÃO, ATAQUE NORMAL E MOVIMENTO
	# =====================================================
	if is_instance_valid(clicked_unit):
		if clicked_unit == hero:
			select_player_unit(hero)
			return
		
		if is_instance_valid(
			animal_companion
		):
			if clicked_unit == animal_companion:
				select_player_unit(
					animal_companion
				)
				return
		
		if is_npc_unit(clicked_unit):
			if str(clicked_unit.faction) == "ally":
				select_player_unit(
					clicked_unit
				)
				return
		
		if is_enemy_unit(clicked_unit):
			if clicked_unit.hp <= 0:
				return
			
			enemy = clicked_unit
			
			print(
				"Alvo selecionado por ",
				get_unit_display_name(
					current_active_unit
				),
				": ",
				get_unit_display_name(
					clicked_unit
				)
			)
			
			await attack_selected_player_unit()
			return
	
	if not is_position_in_current_movement_area(
		clicked_grid_position
	):
		clear_player_unit_selection_for_camera()
		return
	
	await move_selected_player_unit(
		clicked_grid_position
	)

func move_animal_companion(
	new_grid_position: Vector2i
):
	if not is_instance_valid(animal_companion):
		return
	
	await move_player_unit(
		animal_companion,
		new_grid_position
	)

func animal_companion_attack() -> void:
	enemy = prepare_player_attack_target(
		animal_companion,
		enemy
	)
	
	if not is_instance_valid(enemy):
		return
	
	var distance_meters: float = (
		get_distance_in_meters(
			animal_companion.grid_position,
			enemy.grid_position
		)
	)
	
	var attack_range: float = 1.5
	
	if animal_companion.has_method(
		"get_weapon_range_meters"
	):
		attack_range = float(
			animal_companion
			.get_weapon_range_meters()
		)
	
	var attack_bonus: int = 0
	
	if animal_companion.has_method(
		"get_base_attack_bonus"
	):
		attack_bonus += int(
			animal_companion
			.get_base_attack_bonus()
		)
	else:
		attack_bonus += 2
	
	if animal_companion.has_method(
		"get_strength_modifier"
	):
		attack_bonus += int(
			animal_companion
			.get_strength_modifier()
		)
	
	if is_instance_valid(hero):
		attack_bonus += int(
			hero.feat_animal_companion_attack_bonus
		)
	
	var high_ground_bonus: int = (
		get_high_ground_attack_bonus_for_unit(
			animal_companion
		)
	)
	
	attack_bonus += high_ground_bonus
	
	if high_ground_bonus > 0:
		print(
			"Bônus de terreno alto do companheiro: +",
			high_ground_bonus
		)
		
		show_floating_text_on_unit(
			animal_companion,
			"TERRENO ALTO +%d"
			% high_ground_bonus,
			18,
			"utility"
		)
	
	var target_ac: int = 10
	
	if enemy.has_method(
		"get_armor_class"
	):
		target_ac = int(
			enemy.get_armor_class()
		)
	
	target_ac = max(
		target_ac,
		1
	)
	
	var control_armor_penalty: int = 0
	
	if "control_armor_penalty" in enemy:
		control_armor_penalty = int(
			enemy.control_armor_penalty
		)
	
	var attack_result: Dictionary = (
		roll_attack_result(
			attack_bonus,
			target_ac,
			animal_companion,
			enemy
		)
	)
	
	var dice_roll: int = int(
		attack_result["dice_roll"]
	)
	
	var attack_total: int = int(
		attack_result["attack_total"]
	)
	
	var attack_hit: bool = bool(
		attack_result["hit"]
	)
	
	var critical_hit: bool = bool(
		attack_result["critical_hit"]
	)
	
	print("====================================")
	print("ATAQUE DO COMPANHEIRO")
	print(
		"Atacante: ",
		animal_companion.companion_name
	)
	print(
		"Alvo: ",
		get_unit_display_name(enemy)
	)
	print(
		"Distância: ",
		distance_meters,
		"m"
	)
	print(
		"Alcance: ",
		attack_range,
		"m"
	)
	print(
		"Rolagem: d20 ",
		dice_roll
	)
	print(
		"Bônus de terreno alto: ",
		high_ground_bonus
	)
	print(
		"Bônus de ataque: ",
		attack_bonus
	)
	print(
		"Total do ataque: ",
		attack_total
	)
	print(
		"Penalidade de CA no inimigo: ",
		control_armor_penalty
	)
	print(
		"CA final do inimigo: ",
		target_ac
	)
	print("====================================")
	
	if dice_roll == 20:
		print(
			"Companheiro acertou crítico natural."
		)
		
		show_floating_text_on_unit(
			enemy,
			"CRÍTICO!",
			30,
			"critical"
		)
	elif dice_roll == 1:
		print(
			"Companheiro errou com 1 natural."
		)
		
		show_floating_text_on_unit(
			enemy,
			"ERROU",
			26,
			"miss"
		)
	
	if attack_hit:
		var damage: int = 1
		
		if animal_companion.has_method(
			"roll_attack_damage"
		):
			damage = int(
				animal_companion
				.roll_attack_damage()
			)
		else:
			damage = int(
				animal_companion.attack_power
			)
		
		if is_instance_valid(hero):
			damage += int(
				hero.feat_animal_companion_damage_bonus
			)
		
		if critical_hit:
			damage *= 2
		
		damage = apply_attack_damage_to_unit(
			enemy,
			damage,
			critical_hit
		)
		
		print("Companheiro acertou.")
		print(
			"Dano final: ",
			damage
		)
	else:
		print(
			"Companheiro errou o ataque."
		)
		
		if dice_roll != 1:
			show_floating_text_on_unit(
				enemy,
				"ERROU",
				26,
				"miss"
			)
	
	await finish_player_attack(
		animal_companion
	)

func get_feat_choice_count(selected_class: String, selected_race: String, level: int) -> int:
	var count: int = 1
	
	if selected_race == "Humano":
		count += 1
	
	if selected_class == "Guerreiro":
		count += 1
	
	return count

func get_combat_feedback_controller() -> Node:
	if is_instance_valid(combat_feedback):
		if combat_feedback.has_method(
			"set_board_root"
		):
			combat_feedback.set_board_root(
				board_root
			)
		
		return combat_feedback
	
	combat_feedback = (
		CombatFeedbackScript.new()
	)
	
	combat_feedback.name = "CombatFeedback"
	add_child(combat_feedback)
	
	if combat_feedback.has_method("setup"):
		combat_feedback.setup(board_root)
	
	return combat_feedback

func create_floating_text_layer() -> void:
	get_combat_feedback_controller()


func show_floating_text(
	text: String,
	world_position: Vector2,
	font_size: int = 26,
	feedback_type: String = "neutral"
) -> void:
	var feedback_controller: Node = (
		get_combat_feedback_controller()
	)
	
	feedback_controller.show_floating_text(
		text,
		world_position,
		font_size,
		feedback_type
	)

func show_floating_text_on_unit(
	unit: Node2D,
	text: String,
	font_size: int = 26,
	feedback_type: String = "neutral"
) -> void:
	if not is_instance_valid(unit):
		return
	
	var feedback_controller: Node = (
		get_combat_feedback_controller()
	)
	
	feedback_controller.show_on_unit(
		unit,
		text,
		font_size,
		feedback_type
	)

func shake_unit(
	unit: Node2D,
	strength: float = 6.0,
	duration: float = 0.22
) -> void:
	if not is_instance_valid(unit):
		return
	
	var feedback_controller: Node = (
		get_combat_feedback_controller()
	)
	
	feedback_controller.shake_unit(
		unit,
		strength,
		duration
	)

func pulse_unit(
	unit: Node2D,
	scale_bonus: float = 0.18,
	duration: float = 0.25
) -> void:
	if not is_instance_valid(unit):
		return
	
	var feedback_controller: Node = (
		get_combat_feedback_controller()
	)
	
	feedback_controller.pulse_unit(
		unit,
		scale_bonus,
		duration
	)

func flash_unit(
	unit: Node2D,
	flash_color: Color = Color.WHITE,
	duration: float = 0.18
) -> void:
	if not is_instance_valid(unit):
		return
	
	var feedback_controller: Node = (
		get_combat_feedback_controller()
	)
	
	feedback_controller.flash_unit(
		unit,
		flash_color,
		duration
	)

func get_spell_effect_from_data(spell_data: Dictionary) -> String:
	var effect: String = ""
	
	if spell_data.has("effect"):
		effect = str(spell_data.get("effect", ""))
	
	if effect == "" and spell_data.has("spell_type"):
		effect = str(spell_data.get("spell_type", ""))
	
	if effect == "" and spell_data.has("type"):
		effect = str(spell_data.get("type", ""))
	
	return effect


func get_spell_type_from_data(spell_data: Dictionary) -> String:
	var spell_type: String = ""
	
	if spell_data.has("spell_type"):
		spell_type = str(spell_data.get("spell_type", ""))
	
	if spell_type == "" and spell_data.has("type"):
		spell_type = str(spell_data.get("type", ""))
	
	if spell_type == "" and spell_data.has("effect"):
		spell_type = str(spell_data.get("effect", ""))
	
	return spell_type


func get_unit_at_grid_position(grid_position: Vector2i) -> Node2D:
	# =====================================================
	# HERÓI
	# =====================================================
	if is_instance_valid(hero):
		if hero.hp > 0:
			if hero.grid_position == grid_position:
				return hero
	
	# =====================================================
	# COMPANHEIRO
	# =====================================================
	if is_instance_valid(animal_companion):
		if animal_companion.hp > 0:
			if animal_companion.visible:
				if animal_companion.grid_position == grid_position:
					return animal_companion
	
	# =====================================================
	# NPCs
	# =====================================================
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if npc_unit.hp <= 0:
			continue
		
		if not npc_unit.visible:
			continue
		
		if npc_unit.grid_position == grid_position:
			return npc_unit
	
	# =====================================================
	# INIMIGOS
	# =====================================================
	var enemy_unit: Node2D = get_enemy_at_grid_position(
		grid_position
	)
	
	if is_instance_valid(enemy_unit):
		return enemy_unit
	
	return null


func can_spell_target_unit(
	effect: String,
	target_unit: Node2D
) -> bool:
	if not is_instance_valid(target_unit):
		return false
	
	if not "hp" in target_unit:
		return false
	
	if target_unit.hp <= 0:
		return false
	
	if effect in [
		"heal",
		"buff"
	]:
		if target_unit == hero:
			return true
		
		if is_animal_companion_unit(
			target_unit
		):
			return true
		
		if is_npc_unit(target_unit):
			return (
				str(target_unit.faction)
				== "ally"
			)
		
		if target_unit.is_in_group(
			"player_allies"
		):
			return true
		
		return false
	
	if effect in [
		"damage",
		"control"
	]:
		return is_enemy_unit(
			target_unit
		)
	
	if effect == "utility":
		return true
	
	return false


func get_spell_range_meters(spell_data: Dictionary) -> float:
	var feat_range_bonus: float = 0.0
	if is_instance_valid(hero):
		feat_range_bonus = float(hero.feat_spell_range_bonus)
	if spell_data.is_empty():
		return 6.0 + feat_range_bonus
	
	if spell_data.has("range_meters"):
		var base_range: float = float(spell_data.get("range_meters", 6.0))
		return base_range + feat_range_bonus if base_range > 0.0 else base_range
	
	return 6.0 + feat_range_bonus
func get_spell_area_cells(center_position: Vector2i, radius: int) -> Array:
	var cells: Array = []
	
	if radius <= 0:
		cells.append(center_position)
		return cells
	
	for x in range(center_position.x - radius, center_position.x + radius + 1):
		for y in range(center_position.y - radius, center_position.y + radius + 1):
			var test_position := Vector2i(x, y)
			
			if not is_inside_grid(test_position):
				continue
			
			var distance_tiles: int = max(
				abs(test_position.x - center_position.x),
				abs(test_position.y - center_position.y)
			)
			
			if distance_tiles <= radius:
				cells.append(test_position)
	
	return cells


func get_units_in_spell_area(center_position: Vector2i, radius: int) -> Array:
	var units: Array = []
	var cells: Array = get_spell_area_cells(center_position, radius)
	
	for cell in cells:
		var unit: Node2D = get_unit_at_grid_position(cell)
		
		if is_instance_valid(unit):
			units.append(unit)
	
	return units

func show_spell_area_preview(center_position: Vector2i, radius: int, feedback_type: String):
	if radius <= 0:
		return
	
	var cells: Array = get_spell_area_cells(center_position, radius)
	
	for cell in cells:
		create_spell_target_tile(cell, feedback_type)
func is_spell_cell_in_range(target_position: Vector2i, spell_data: Dictionary) -> bool:
	if not is_instance_valid(hero):
		return false
	
	var spell_range: float = get_spell_range_meters(spell_data)
	var distance_to_cell: float = get_distance_in_meters(hero.grid_position, target_position)
	
	if distance_to_cell <= spell_range:
		return true
	
	print("Célula fora do alcance da magia.")
	print("Distância: ", distance_to_cell, "m")
	print("Alcance da magia: ", spell_range, "m")
	return false
func cast_pending_area_spell(
	center_position: Vector2i
) -> void:
	if not waiting_spell_target:
		return
	
	if pending_spell_name == "":
		return
	
	if pending_spell_data.is_empty():
		return
	
	var effect: String = (
		get_spell_effect_from_data(
			pending_spell_data
		)
	)
	
	var spell_type: String = (
		get_spell_type_from_data(
			pending_spell_data
		)
	)
	
	var spell_level: int = int(
		pending_spell_data.get(
			"level",
			0
		)
	)
	
	var area_radius: int = (
		get_spell_area_radius(
			pending_spell_data
		)
	)
	
	var units_in_area: Array = (
		get_units_in_spell_area(
			center_position,
			area_radius
		)
	)
	
	if spell_type == "":
		spell_type = effect
	
	print("====================================")
	print("CONJURAÇÃO EM ÁREA")
	print("Magia: ", pending_spell_name)
	print("Efeito: ", effect)
	print("Tipo: ", spell_type)
	print("Centro: ", center_position)
	print("Raio: ", area_radius)
	print(
		"Unidades na área: ",
		units_in_area.size()
	)
	print("====================================")
	
	clear_spell_target_area()
	if UIAudioManager != null:
		UIAudioManager.play_spell(pending_spell_name, pending_spell_data)
	show_spell_visual_at_grid(pending_spell_name, pending_spell_data, center_position)
	
	show_spell_impact_area(
		center_position,
		area_radius,
		effect
	)
	
	await get_tree().create_timer(
		0.25
	).timeout
	
	var duration: int = int(
		pending_spell_data.get(
			"duration",
			0
		)
	)
	
	if duration > 0:
		create_active_spell_area(
			center_position,
			area_radius,
			pending_spell_name,
			effect,
			duration
		)
	
	if spell_level > 0:
		consume_spell_slot(
			spell_level
		)
	
	for target_unit in units_in_area:
		if not is_instance_valid(target_unit):
			continue
		
		if not can_spell_target_unit(
			effect,
			target_unit
		):
			continue
		
		if effect == "damage":
			cast_damage_spell(
				pending_spell_name,
				pending_spell_data,
				target_unit
			)
		elif effect == "heal":
			cast_heal_spell(
				pending_spell_name,
				pending_spell_data,
				target_unit
			)
		elif effect == "buff":
			cast_buff_spell(
				pending_spell_name,
				pending_spell_data,
				target_unit
			)
		elif effect == "control":
			cast_control_spell(
				pending_spell_name,
				pending_spell_data,
				target_unit
			)
		elif effect == "utility":
			cast_utility_spell(
				pending_spell_name,
				pending_spell_data,
				target_unit
			)
	
	hero.has_attacked = true
	on_stage_one_spell_cast()
	
	waiting_spell_target = false
	pending_spell_name = ""
	pending_spell_data = {}
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_cancel_spell_visible(
			false
		)
	
	update_movement_label()
	update_class_skill_button()
	
	if has_method(
		"update_character_sheet_panel"
	):
		update_character_sheet_panel()
	
	if has_method("check_battle_result"):
		check_battle_result()

func get_spell_area_radius(
	spell_data: Dictionary
) -> int:
	if spell_data.is_empty():
		return 0
	
	var target_type: String = str(
		spell_data.get(
			"target",
			""
		)
	)
	
	var is_area_spell: bool = bool(
		spell_data.get(
			"is_area",
			target_type == "area"
		)
	)
	
	# Mesmo que uma magia antiga possua area_radius = 1,
	# ela não será uma explosão sem estar explicitamente
	# marcada como magia de área.
	if not is_area_spell:
		return 0
	
	return max(
		1,
		int(
			spell_data.get(
				"area_radius",
				1
			)
		)
	)

func create_active_spell_area_layer() -> void:
	if is_instance_valid(
		active_spell_area_overlay
	):
		return
	
	active_spell_area_overlay = (
		ActiveSpellAreaOverlayScript.new()
	)
	
	active_spell_area_overlay.setup(
		TILE_SIZE
	)
	
	if is_instance_valid(board_root):
		board_root.add_child(
			active_spell_area_overlay
		)
	else:
		add_child(
			active_spell_area_overlay
		)


func create_active_spell_area(
	center_position: Vector2i,
	radius: int,
	spell_name: String,
	effect: String,
	duration: int
) -> void:
	if radius <= 0:
		return
	
	if not is_instance_valid(
		active_spell_area_overlay
	):
		create_active_spell_area_layer()
	
	if not is_instance_valid(
		active_spell_area_overlay
	):
		return
	
	var cells: Array = get_spell_area_cells(
		center_position,
		radius
	)
	
	var visual_data: Dictionary = (
		active_spell_area_overlay.create_area_visual(
			cells,
			center_position,
			effect,
			duration
		)
	)
	
	var visual_nodes: Array = visual_data.get(
		"visual_nodes",
		[]
	)
	
	var duration_label: Label = visual_data.get(
		"duration_label",
		null
	)
	
	var copied_spell_data: Dictionary = (
		pending_spell_data.duplicate(true)
	)
	
	if copied_spell_data.has("duration"):
		copied_spell_data["effect_duration"] = (
			copied_spell_data["duration"]
		)
		copied_spell_data.erase("duration")
	
	var start_turn: int = battle_turn_count
	var end_turn: int = (
		battle_turn_count
		+ duration
	)
	
	var area_data := {
		"spell_name": spell_name,
		"effect": effect,
		"center_position": center_position,
		"radius": radius,
		"cells": cells,
		"start_turn": start_turn,
		"end_turn": end_turn,
		"visual_nodes": visual_nodes,
		"duration_label": duration_label,
		"spell_data": copied_spell_data,
		"affected_units_this_turn": {}
	}
	
	active_spell_areas.append(area_data)
	
	print(
		"Área mágica ativa criada: ",
		spell_name
	)
	print("Efeito: ", effect)
	print("Turno inicial: ", start_turn)
	print("Turno final: ", end_turn)
	print(
		"Duração: ",
		duration,
		" turnos"
	)
	
	update_active_effects_panel()
	
func get_active_area_turns_remaining(area_data: Dictionary) -> int:
	var end_turn: int = int(area_data.get("end_turn", battle_turn_count))
	var remaining: int = end_turn - battle_turn_count
	
	if remaining < 0:
		remaining = 0
	
	return remaining

func apply_active_spell_area_to_unit(unit: Node2D):
	if not is_instance_valid(unit):
		return
	
	if active_spell_areas.is_empty():
		return
	
	for i in range(active_spell_areas.size()):
		var area_data: Dictionary = active_spell_areas[i]
		var area_turns_remaining: int = get_active_area_turns_remaining(area_data)
		
		if area_turns_remaining <= 0:
			continue
		
		var cells: Array = area_data.get("cells", [])
		
		if not cells.has(unit.grid_position):
			continue
		
		var affected_units_this_turn: Dictionary = area_data.get("affected_units_this_turn", {})
		var unit_key: String = get_unit_area_key(unit)
		
		if unit_key == "":
			continue
		
		if affected_units_this_turn.has(unit_key):
			var last_turn_applied: int = int(affected_units_this_turn[unit_key])
			
			if last_turn_applied == battle_turn_count:
				print("Área já afetou esta unidade neste turno.")
				print("Unidade: ", unit.name)
				print("Turno: ", battle_turn_count)
				continue
		
		affected_units_this_turn[unit_key] = battle_turn_count
		area_data["affected_units_this_turn"] = affected_units_this_turn
		
		active_spell_areas[i] = area_data
		
		var spell_name: String = str(area_data.get("spell_name", ""))
		var effect: String = str(area_data.get("effect", ""))
		var spell_data: Dictionary = area_data.get("spell_data", {})
		
		print("====================================")
		print("UNIDADE EM ÁREA MÁGICA")
		print("Unidade: ", unit.name)
		print("Área: ", spell_name)
		print("Efeito: ", effect)
		print("Turno atual: ", battle_turn_count)
		print("Turnos restantes reais: ", area_turns_remaining)
		print("====================================")
		
		if effect == "damage":
			apply_damage_area_effect(unit, spell_name, spell_data)
		
		elif effect == "control":
			apply_control_area_effect(unit, spell_name, spell_data)
		
		elif effect == "heal":
			apply_heal_area_effect(unit, spell_name, spell_data)
		
		elif effect == "buff":
			apply_buff_area_effect(unit, spell_name, spell_data)
		
		elif effect == "utility":
			apply_utility_area_effect(unit, spell_name, spell_data)

func apply_damage_area_effect(
	unit: Node2D,
	spell_name: String,
	spell_data: Dictionary
) -> void:
	if not is_instance_valid(unit):
		return
	
	if unit.hp <= 0:
		return
	
	if not is_enemy_unit(unit):
		return
	
	var area_spell_data: Dictionary = (
		spell_data.duplicate(true)
	)
	
	area_spell_data["value_dice"] = int(
		spell_data.get(
			"area_value_dice",
			spell_data.get(
				"value_dice",
				4
			)
		)
	)
	
	area_spell_data["value_dice_count"] = int(
		spell_data.get(
			"area_value_dice_count",
			spell_data.get(
				"value_dice_count",
				1
			)
		)
	)
	
	area_spell_data["flat_bonus"] = int(
		spell_data.get(
			"area_flat_bonus",
			spell_data.get(
				"flat_bonus",
				0
			)
		)
	)
	
	cast_damage_spell(
		spell_name,
		area_spell_data,
		unit
	)
	
	print(
		spell_name,
		" aplicou dano persistente em ",
		get_unit_display_name(unit)
	)


func apply_control_area_effect(
	unit: Node2D,
	spell_name: String,
	spell_data: Dictionary
) -> void:
	if not is_instance_valid(unit):
		return
	
	if unit.hp <= 0:
		return
	
	if not is_enemy_unit(unit):
		return
	
	var area_spell_data: Dictionary = (
		spell_data.duplicate(true)
	)
	
	area_spell_data["value_dice"] = int(
		spell_data.get(
			"area_value_dice",
			spell_data.get(
				"value_dice",
				0
			)
		)
	)
	
	area_spell_data["value_dice_count"] = int(
		spell_data.get(
			"area_value_dice_count",
			spell_data.get(
				"value_dice_count",
				0
			)
		)
	)
	
	area_spell_data["flat_bonus"] = int(
		spell_data.get(
			"area_flat_bonus",
			spell_data.get(
				"flat_bonus",
				0
			)
		)
	)
	
	area_spell_data["duration"] = max(
		1,
		int(
			spell_data.get(
				"effect_duration",
				spell_data.get(
					"duration",
					1
				)
			)
		)
	)
	
	cast_control_spell(
		spell_name,
		area_spell_data,
		unit
	)
	
	print(
		spell_name,
		" processou controle persistente em ",
		get_unit_display_name(unit)
	)


func apply_heal_area_effect(
	unit: Node2D,
	spell_name: String,
	spell_data: Dictionary
) -> void:
	if not is_instance_valid(unit):
		return
	
	if not can_spell_target_unit(
		"heal",
		unit
	):
		return
	
	var area_spell_data: Dictionary = (
		spell_data.duplicate(true)
	)
	
	area_spell_data["value_dice"] = int(
		spell_data.get(
			"area_value_dice",
			spell_data.get(
				"value_dice",
				4
			)
		)
	)
	
	area_spell_data["value_dice_count"] = int(
		spell_data.get(
			"area_value_dice_count",
			spell_data.get(
				"value_dice_count",
				1
			)
		)
	)
	
	area_spell_data["flat_bonus"] = int(
		spell_data.get(
			"area_flat_bonus",
			spell_data.get(
				"flat_bonus",
				0
			)
		)
	)
	
	cast_heal_spell(
		spell_name,
		area_spell_data,
		unit
	)
	
	print(
		spell_name,
		" aplicou cura de área em ",
		get_unit_display_name(unit)
	)


func apply_buff_area_effect(
	unit: Node2D,
	spell_name: String,
	spell_data: Dictionary
) -> void:
	if not is_instance_valid(unit):
		return
	
	if not can_spell_target_unit(
		"buff",
		unit
	):
		return
	
	var area_spell_data: Dictionary = (
		spell_data.duplicate(true)
	)
	
	area_spell_data["attack_bonus"] = int(
		spell_data.get(
			"area_attack_bonus",
			spell_data.get(
				"attack_bonus",
				0
			)
		)
	)
	
	area_spell_data["damage_bonus"] = int(
		spell_data.get(
			"area_damage_bonus",
			spell_data.get(
				"damage_bonus",
				0
			)
		)
	)
	
	area_spell_data["armor_bonus"] = int(
		spell_data.get(
			"area_armor_bonus",
			spell_data.get(
				"armor_bonus",
				0
			)
		)
	)
	
	area_spell_data["movement_bonus"] = float(
		spell_data.get(
			"area_movement_bonus",
			spell_data.get(
				"movement_bonus",
				0.0
			)
		)
	)
	
	# O efeito é renovado por um turno enquanto
	# a unidade permanecer dentro da área.
	area_spell_data["duration"] = 1
	
	cast_buff_spell(
		spell_name,
		area_spell_data,
		unit
	)
	
	print(
		spell_name,
		" aplicou buff de área em ",
		get_unit_display_name(unit)
	)


func apply_utility_area_effect(unit: Node2D, spell_name: String, spell_data: Dictionary):
	if not is_instance_valid(unit):
		return
	
	print(spell_name, " aplicou efeito utilitário por área em ", unit.name)
	show_floating_text_on_unit(unit, "EFEITO", 20, "utility")

func update_active_spell_areas_turn():
	if active_spell_areas.is_empty():
		return
	
	for i in range(active_spell_areas.size()):
		var area_data: Dictionary = active_spell_areas[i]
		area_data["affected_units_this_turn"] = {}
		active_spell_areas[i] = area_data
	
	refresh_active_spell_area_labels()
	update_active_effects_panel()

func get_unit_area_key(unit: Node2D) -> String:
	if not is_instance_valid(unit):
		return ""
	
	return str(unit.get_instance_id())
func roll_enemy_spell_resistance_save(spell_name: String, spell_data: Dictionary) -> bool:
	if not is_instance_valid(enemy):
		return false
	
	var save_dc: int = get_spell_save_dc(spell_data)
	var save_bonus: int = 0
	
	if enemy.has_method("get_will_save_bonus"):
		save_bonus = int(enemy.get_will_save_bonus())
	elif enemy.has_method("get_will_bonus"):
		save_bonus = int(enemy.get_will_bonus())
	elif enemy.has_method("get_wisdom_modifier"):
		save_bonus = int(enemy.get_wisdom_modifier())
	else:
		save_bonus = 0
	
	var dice_roll: int = randi_range(1, 20)
	var save_total: int = dice_roll + save_bonus
	
	print("====================================")
	print("TESTE DE RESISTÊNCIA DO INIMIGO")
	print("Magia: ", spell_name)
	print("Rolagem: d20 ", dice_roll)
	print("Bônus: ", save_bonus)
	print("Total: ", save_total)
	print("CD: ", save_dc)
	print("====================================")
	
	if dice_roll == 20:
		print("Inimigo resistiu com 20 natural.")
		show_floating_text_on_unit(enemy, "RESISTIU", 22, "miss")
		return true
	
	if dice_roll == 1:
		print("Inimigo falhou com 1 natural.")
		return false
	
	if save_total >= save_dc:
		print("Inimigo resistiu ao efeito.")
		show_floating_text_on_unit(enemy, "RESISTIU", 22, "miss")
		return true
	
	print("Inimigo falhou no teste de resistência.")
	return false

func get_turn_status_controller() -> Node:
	if not is_instance_valid(ui_layer):
		return null
	
	if is_instance_valid(
		turn_status_controller
	):
		turn_status_controller.setup(
			ui_layer
		)
		
		return turn_status_controller
	
	turn_status_controller = (
		TurnStatusDisplayScript.new()
	)
	
	turn_status_controller.name = (
		"TurnStatusController"
	)
	
	add_child(turn_status_controller)
	
	turn_status_controller.setup(
		ui_layer
	)
	
	return turn_status_controller

func create_turn_counter_label() -> void:
	var controller: Node = (
		get_turn_status_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	update_turn_counter_label()

func update_turn_counter_label() -> void:
	var controller: Node = (
		get_turn_status_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	var unit_name: String = ""
	var order_names: Array[String] = []
	var order_portraits: Array = []
	var order_enemy_flags: Array[bool] = []
	
	if initiative_started:
		var current_unit: Node2D = (
			get_current_initiative_unit()
		)
		
		if is_instance_valid(current_unit):
			unit_name = get_unit_display_name(
				current_unit
			)
		
		for unit in initiative_order:
			if is_instance_valid(unit):
				var display_name: String = get_unit_display_name(unit)
				order_names.append(display_name)
				order_portraits.append(get_battle_portrait_texture(display_name))
				order_enemy_flags.append(is_enemy_unit(unit))
			else:
				order_names.append("—")
				order_portraits.append(null)
				order_enemy_flags.append(false)
	
	controller.update_display(
		initiative_started,
		battle_turn_count,
		unit_name
	)
	
	controller.update_order(
		order_names,
		current_initiative_index,
		order_portraits,
		order_enemy_flags
	)


func refresh_active_spell_area_labels() -> void:
	if active_spell_areas.is_empty():
		return
	
	for area_index in range(
		active_spell_areas.size() - 1,
		-1,
		-1
	):
		var area_data: Dictionary = (
			active_spell_areas[area_index]
		)
		
		var area_turns_remaining: int = (
			get_active_area_turns_remaining(
				area_data
			)
		)
		
		if is_instance_valid(
			active_spell_area_overlay
		):
			active_spell_area_overlay.update_area_duration(
				area_data,
				area_turns_remaining
			)
		
		if area_turns_remaining > 0:
			continue
		
		if is_instance_valid(
			active_spell_area_overlay
		):
			active_spell_area_overlay.remove_area_visual(
				area_data
			)
		
		active_spell_areas.remove_at(
			area_index
		)
		
		print(
			"Área mágica acabou: ",
			area_data.get(
				"spell_name",
				""
			)
		)

func create_active_effects_panel() -> void:
	var controller: Node = (
		get_active_effects_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	update_active_effects_panel()

func update_active_effects_panel() -> void:
	var controller: Node = (
		get_active_effects_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	var safe_current_enemy: Node2D = null
	var safe_hero: Node2D = null
	
	if (
		is_instance_valid(enemy)
		and not enemy.is_queued_for_deletion()
	):
		safe_current_enemy = enemy
	
	if (
		is_instance_valid(hero)
		and not hero.is_queued_for_deletion()
	):
		safe_hero = hero
	
	controller.update_display(
		active_spell_areas,
		enemies,
		safe_current_enemy,
		safe_hero,
		battle_turn_count
	)

func get_enemy_target_unit() -> Node2D:
	return EnemyAI.choose_target(enemy, self)

func get_unit_display_name(unit: Node2D) -> String:
	if not is_instance_valid(unit):
		return "Unidade"
	
	if unit == hero:
		if "character_name" in unit:
			if str(unit.character_name) != "":
				return str(unit.character_name)
		
		return "Herói"
	
	if is_instance_valid(animal_companion):
		if unit == animal_companion:
			if unit.has_method("get_companion_display_name"):
				return str(unit.get_companion_display_name())
			
			return str(unit.companion_name)
	
	if is_npc_unit(unit):
		if unit.has_method("get_npc_display_name"):
			return str(unit.get_npc_display_name())
		
		if "display_name" in unit:
			return str(unit.display_name)
	
	if is_enemy_unit(unit):
		if unit.has_method("get_enemy_display_name"):
			return str(unit.get_enemy_display_name())
		
		if unit.has_method("get_display_name"):
			return str(unit.get_display_name())
	
	return str(unit.name)


func enemy_get_intelligence_score() -> int:
	return EnemyAI.get_intelligence_score(enemy)

func enemy_use_buff():
	if not is_instance_valid(enemy):
		return
	
	enemy.temporary_attack_bonus = int(enemy.buff_attack_bonus)
	enemy.temporary_damage_bonus = int(enemy.buff_damage_bonus)
	enemy.temporary_armor_class_bonus = int(enemy.buff_armor_bonus)
	enemy.temporary_movement_bonus = float(enemy.buff_movement_bonus)
	
	enemy.is_buffed = true
	enemy.buff_available = false
	enemy.has_attacked = true
	
	var duration: int = 2
	
	if enemy_get_intelligence_score() >= 17:
		duration = 3
	
	enemy.temporary_effects_end_turn = battle_turn_count + duration
	
	if enemy.temporary_movement_bonus > 0.0:
		enemy.max_movement_meters += enemy.temporary_movement_bonus
		enemy.current_movement_meters += enemy.temporary_movement_bonus
	
	print("====================================")
	print("INIMIGO USOU BUFF")
	print("Bônus ataque: ", enemy.temporary_attack_bonus)
	print("Bônus dano: ", enemy.temporary_damage_bonus)
	print("Bônus CA: ", enemy.temporary_armor_class_bonus)
	print("Bônus movimento: ", enemy.temporary_movement_bonus)
	print("Buff ativo até o turno: ", enemy.temporary_effects_end_turn)
	print("====================================")
	
	show_floating_text_on_unit(enemy, "BUFF", 26, "buff")
	pulse_unit(enemy, 0.16, 0.28)
	flash_unit(enemy, Color(0.3, 0.55, 1.0, 1.0), 0.22)
	
	update_enemy_hp_bar()
	update_movement_label()
	update_active_effects_panel()

func update_enemy_temporary_effects_turn():
	if not is_instance_valid(enemy):
		return
	
	if not enemy.is_buffed:
		return
	
	if enemy.temporary_effects_end_turn <= 0:
		return
	
	if battle_turn_count >= enemy.temporary_effects_end_turn:
		if enemy.temporary_movement_bonus > 0.0:
			enemy.max_movement_meters -= enemy.temporary_movement_bonus
			
			if enemy.current_movement_meters > enemy.max_movement_meters:
				enemy.current_movement_meters = enemy.max_movement_meters
		
		enemy.temporary_attack_bonus = 0
		enemy.temporary_damage_bonus = 0
		enemy.temporary_armor_class_bonus = 0
		enemy.temporary_movement_bonus = 0.0
		enemy.temporary_effects_end_turn = 0
		enemy.is_buffed = false
		
		print("Buff temporário do inimigo acabou.")

func enemy_use_potion():
	if not is_instance_valid(enemy):
		return
	
	if enemy.potion_count <= 0:
		return
	
	var heal_value: int = int(
		enemy.potion_heal_amount
	)
	
	enemy.potion_count -= 1
	
	apply_enemy_healing_action(
		heal_value,
		"INIMIGO USOU POÇÃO",
		"Poções restantes",
		enemy.potion_count
	)
	
func is_grid_position_inside_dangerous_spell_area(grid_position: Vector2i) -> bool:
	if active_spell_areas.is_empty():
		return false
	
	for area_data in active_spell_areas:
		var area_turns_remaining: int = get_active_area_turns_remaining(area_data)
		
		if area_turns_remaining <= 0:
			continue
		
		var effect: String = str(area_data.get("effect", ""))
		
		if effect != "damage" and effect != "control":
			continue
		
		var cells: Array = area_data.get("cells", [])
		
		if cells.has(grid_position):
			return true
	
	return false
func get_spell_area_danger_score(grid_position: Vector2i) -> float:
	if active_spell_areas.is_empty():
		return 0.0
	
	var danger_score: float = 0.0
	
	for area_data in active_spell_areas:
		var area_turns_remaining: int = get_active_area_turns_remaining(area_data)
		
		if area_turns_remaining <= 0:
			continue
		
		var effect: String = str(area_data.get("effect", ""))
		var cells: Array = area_data.get("cells", [])
		
		if not cells.has(grid_position):
			continue
		
		if effect == "damage":
			danger_score += 100.0
		elif effect == "control":
			danger_score += 70.0
	
	return danger_score
func enemy_should_avoid_spell_areas() -> bool:
	return EnemyAI.should_avoid_spell_areas(enemy)


func enemy_heal_self():
	if not is_instance_valid(enemy):
		return
	
	if enemy.self_heal_uses <= 0:
		return
	
	var heal_value: int = int(
		enemy.self_heal_amount
	)
	
	enemy.self_heal_uses -= 1
	
	apply_enemy_healing_action(
		heal_value,
		"INIMIGO USOU CURA PRÓPRIA",
		"Usos restantes",
		enemy.self_heal_uses
	)

func get_unit_initiative_bonus(unit: Node2D) -> int:
	if not is_instance_valid(unit):
		return 0
	
	var bonus: int = 0
	
	if unit.has_method("get_dexterity_modifier"):
		bonus += int(unit.get_dexterity_modifier())
	elif "dexterity" in unit:
		bonus += int(floor((float(unit.dexterity) - 10.0) / 2.0))
	
	if "initiative_bonus" in unit:
		bonus += int(unit.initiative_bonus)
	if unit == hero:
		bonus += int(hero.feat_initiative_bonus)
	
	return bonus
func roll_initiative_for_unit(unit: Node2D) -> Dictionary:
	var dice_roll: int = randi_range(1, 20)
	var bonus: int = get_unit_initiative_bonus(unit)
	var total: int = dice_roll + bonus
	
	return {
		"unit": unit,
		"roll": dice_roll,
		"bonus": bonus,
		"total": total
	}
func setup_initiative_order():
	initiative_order.clear()
	current_initiative_index = 0
	
	var initiative_results: Array = []
	
	# =====================================================
	# HERÓI
	# =====================================================
	if is_instance_valid(hero):
		if hero.hp > 0 and hero.visible:
			initiative_results.append(
				roll_initiative_for_unit(hero)
			)
	
	# =====================================================
	# COMPANHEIRO ANIMAL
	# =====================================================
	if is_instance_valid(animal_companion):
		if (
			animal_companion.hp > 0
			and animal_companion.visible
		):
			initiative_results.append(
				roll_initiative_for_unit(
					animal_companion
				)
			)
	
	# =====================================================
	# NPCs
	# =====================================================
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if npc_unit.hp <= 0:
			continue
		
		if not npc_unit.visible:
			continue
		
		initiative_results.append(
			roll_initiative_for_unit(npc_unit)
		)
	
	# =====================================================
	# INIMIGOS
	# =====================================================
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.hp > 0 and enemy.visible:
				initiative_results.append(
					roll_initiative_for_unit(enemy)
				)
	else:
		for enemy_unit in enemies:
			if not is_instance_valid(enemy_unit):
				continue
			
			if enemy_unit.hp <= 0:
				continue
			
			if not enemy_unit.visible:
				continue
			
			initiative_results.append(
				roll_initiative_for_unit(enemy_unit)
			)
	
	initiative_results.sort_custom(
		sort_initiative_descending
	)
	
	print("====================================")
	print("ORDEM DE INICIATIVA")
	print("====================================")
	
	for result in initiative_results:
		var unit: Node2D = result["unit"]
		
		initiative_order.append(unit)
		
		print(
			get_unit_display_name(unit),
			" | d20: ",
			result["roll"],
			" | bônus: ",
			result["bonus"],
			" | total: ",
			result["total"]
		)
	
	print("====================================")

func sort_initiative_descending(a: Dictionary, b: Dictionary) -> bool:
	if int(a["total"]) == int(b["total"]):
		return int(a["bonus"]) > int(b["bonus"])
	
	return int(a["total"]) > int(b["total"])
func get_current_initiative_unit() -> Node2D:
	if initiative_order.is_empty():
		return null
	
	if current_initiative_index < 0:
		current_initiative_index = 0
	
	if current_initiative_index >= initiative_order.size():
		current_initiative_index = 0
	
	return initiative_order[current_initiative_index]
func advance_initiative_turn() -> void:
	if not initiative_started:
		print(
			"Não é possível avançar turno antes da iniciativa."
		)
		return
	
	if initiative_order.is_empty():
		return
	
	current_initiative_index += 1
	
	# Só aumenta a rodada quando todos da iniciativa já jogaram.
	if current_initiative_index >= initiative_order.size():
		current_initiative_index = 0
		battle_turn_count += 1
		
		print("====================================")
		print(
			"NOVA RODADA DA BATALHA: ",
			battle_turn_count
		)
		print("====================================")
		
		update_all_status_effects()
		update_active_spell_areas_turn()
		update_enemy_control_effects_turn()
		
		if has_method(
			"update_enemy_temporary_effects_turn"
		):
			update_enemy_temporary_effects_turn()
		
		await process_scenario_round_events()
	
	start_current_initiative_turn()

func should_skip_initiative_unit(
	unit: Node2D
) -> bool:
	if not is_instance_valid(unit):
		return true
	
	if "hp" in unit:
		if unit.hp <= 0:
			return true
	
	if not unit.visible:
		return true
	
	if unit.has_method("has_status_effect"):
		if unit.has_status_effect(
			"paralyzed",
			battle_turn_count
		):
			print(
				get_unit_display_name(unit),
				" está paralisado e perdeu o turno."
			)
			
			show_floating_text_on_unit(
				unit,
				"PARALISADO",
				22,
				"control"
			)
			update_active_effects_panel()
			var turn_status: Node = get_turn_status_controller()
			var turn_label: Label = null
			if is_instance_valid(turn_status):
				turn_label = turn_status.get("status_label") as Label
			if is_instance_valid(turn_label):
				turn_label.text = (
					"Rodada %d — %s perdeu o turno: paralisado"
					% [battle_turn_count, get_unit_display_name(unit)]
				)
			
			return true
	
	return false
func prepare_active_initiative_unit(
	unit: Node2D
):
	current_active_unit = unit
	
	update_class_skill_button()
	show_turn_banner_for_unit_if_needed(unit)
	update_turn_counter_label()
	refresh_active_spell_area_labels()
	update_active_effects_panel()
func start_npc_initiative_turn(
	npc_unit: Node2D
):
	var control_type: String = str(
		npc_unit.control_type
	)
	
	if control_type == "player":
		await start_player_npc_turn(npc_unit)
		return
	
	if control_type == "ai":
		current_turn = TurnState.ENEMY_TURN
		
		clear_movement_area()
		clear_attack_area()
		if current_stage == 1 and stage_one_tutorial_enabled and not stage_one_ai_tutorial_shown and not stage_one_tutorial_skipped:
			stage_one_ai_tutorial_shown = true
			await show_stage_one_guided_tip(
				"Este guarda age sozinho",
				"O guarda é seu aliado, mas é um NPC: você não escolhe o movimento nem o ataque dele. Quando o nome do seu herói aparecer como turno ativo, você volta a controlar suas ações.",
				"ai_ally"
			)
		
		print(
			"Turno de NPC IA: ",
			get_unit_display_name(npc_unit)
		)
		
		await npc_ai_turn(npc_unit)
		advance_initiative_turn()
		return
	
	print(
		"Tipo de controle de NPC desconhecido: ",
		control_type,
		" | NPC: ",
		get_unit_display_name(npc_unit)
	)
	
	advance_initiative_turn()
func start_enemy_initiative_turn(
	enemy_unit: Node2D
):
	enemy = enemy_unit
	current_turn = TurnState.ENEMY_TURN
	
	clear_movement_area()
	clear_attack_area()
	
	print(
		"Turno de inimigo pela iniciativa: ",
		get_unit_display_name(enemy)
	)
	
	await enemy_turn()
	advance_initiative_turn()

func start_current_initiative_turn():
	if not initiative_started:
		print("A iniciativa ainda não foi rolada.")
		return
	
	if battle_finished:
		return
	
	var unit: Node2D = get_current_initiative_unit()
	
	if should_skip_initiative_unit(unit):
		if is_instance_valid(unit) and unit.has_method("has_status_effect"):
			if unit.has_status_effect("paralyzed", battle_turn_count):
				await get_tree().create_timer(1.0).timeout
		advance_initiative_turn()
		return
	
	prepare_active_initiative_unit(unit)
	
	if unit == hero:
		await start_hero_turn_from_initiative()
		return
	
	if unit == animal_companion:
		await begin_player_controlled_turn(
			animal_companion
		)
		return
	
	if is_npc_unit(unit):
		await start_npc_initiative_turn(unit)
		return
	
	if is_enemy_unit(unit) or unit == enemy:
		await start_enemy_initiative_turn(unit)
		return
	
	print(
		"Unidade da iniciativa não reconhecida: ",
		get_unit_display_name(unit)
	)
	
	advance_initiative_turn()

func start_hero_turn_from_initiative():
	if not is_instance_valid(hero):
		advance_initiative_turn()
		return
	
	await begin_player_controlled_turn(hero)

func is_enemy_unit(
	unit: Node2D
) -> bool:
	if not is_instance_valid(unit):
		return false
	
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if unit == enemy_unit:
			return true
	
	if is_instance_valid(enemy):
		if unit == enemy:
			return true
	
	# Identificação pelo script da unidade.
	# Impede que um inimigo deixe de ser reconhecido
	# quando a referência global "enemy" muda.
	if unit.has_method(
		"get_enemy_display_name"
	):
		return true
	
	return false

func get_alive_enemy_count() -> int:
	var count: int = 0
	
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp > 0:
			count += 1
	
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.hp > 0:
				count += 1
	
	return count

func get_scenario_start_text() -> String:
	var enemy_count: int = (
		get_alive_enemy_count()
	)
	
	var scenario_name: String = str(
		current_scenario_data.get(
			"name",
			"Cenário " + str(current_stage)
		)
	)
	
	var victory_conditions: Array = (
		current_scenario_data.get(
			"victory_conditions",
			[]
		)
	)
	
	var defeat_conditions: Array = (
		current_scenario_data.get(
			"defeat_conditions",
			[]
		)
	)
	
	var text: String = (
		"Cenário "
		+ str(current_stage)
		+ " — "
		+ scenario_name
		+ "\n\n"
	)
	
	text += "Condições de vitória:\n"
	
	if victory_conditions.is_empty():
		text += "- Derrote todos os inimigos.\n"
	else:
		for condition_data in victory_conditions:
			var description: String = str(
				condition_data.get(
					"description",
					""
				)
			)
			
			if description != "":
				text += (
					"- "
					+ description
					+ "\n"
				)
	
	text += "\nCondições de derrota:\n"
	
	if defeat_conditions.is_empty():
		text += "- O herói ser derrotado.\n"
	else:
		for condition_data in defeat_conditions:
			var description: String = str(
				condition_data.get(
					"description",
					""
				)
			)
			
			if description != "":
				text += (
					"- "
					+ description
					+ "\n"
				)
	
	text += (
		"\nInimigos detectados: "
		+ str(enemy_count)
		+ "\n"
	)
	
	if enemy_count == 1:
		text += "- 1 inimigo no campo.\n"
	else:
		text += (
			"- "
			+ str(enemy_count)
			+ " inimigos no campo.\n"
		)
	
	text += (
		"\nClique em Rolar Iniciativa "
		+ "para iniciar a batalha."
	)
	
	return text

func get_initiative_panel_controller() -> Node:
	if is_instance_valid(
		initiative_panel_controller
	):
		return initiative_panel_controller
	
	initiative_panel_controller = (
		InitiativePanelScript.new()
	)
	
	initiative_panel_controller.name = (
		"InitiativePanelController"
	)
	
	add_child(initiative_panel_controller)
	
	var roll_callback := Callable(
		self,
		"on_roll_initiative_pressed"
	)
	
	if not initiative_panel_controller.is_connected(
		"roll_requested",
		roll_callback
	):
		initiative_panel_controller.connect(
			"roll_requested",
			roll_callback
		)
	
	return initiative_panel_controller

func create_scenario_start_panel() -> void:
	if not is_instance_valid(ui_layer):
		return
	
	var controller: Node = (
		get_initiative_panel_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.setup(
		ui_layer,
		get_scenario_start_text(),
		Callable(
			self,
			"apply_button_sfx"
		)
	)
	if current_stage == 1 and stage_one_tutorial_enabled and not stage_one_tutorial_skipped and not stage_one_tutorial_shown:
		show_stage_one_initiative_tutorial()

func on_roll_initiative_pressed() -> void:
	if initiative_started:
		return
	
	initiative_started = true
	start_current_scenario_music()
	
	var controller: Node = (
		get_initiative_panel_controller()
	)
	
	if is_instance_valid(controller):
		controller.mark_as_rolled()
	
	setup_initiative_order()
	show_initiative_result_on_panel()
	# O som dos canídeos marca o início do combate, não a revelação.
	play_canine_intro_at_initiative()
	
	await get_tree().create_timer(
		2.5
	).timeout
	
	if is_instance_valid(controller):
		controller.close_panel()
	
	set_gameplay_panels_visible(true)
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.configure_control_buttons(
			false,
			false,
			false
		)
	
	update_class_skill_button()
	start_current_initiative_turn()

func show_initiative_result_on_panel() -> void:
	var controller: Node = (
		get_initiative_panel_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.show_initiative_results(
		initiative_order,
		Callable(
			self,
			"get_unit_display_name"
		)
	)

func clear_enemies():
	for enemy_unit in enemies:
		if is_instance_valid(enemy_unit):
			enemy_unit.queue_free()
	
	enemies.clear()
	
	if is_instance_valid(enemy):
		enemy.queue_free()
	
	enemy = null

func spawn_monster(
	monster_name: String,
	grid_position: Vector2i,
	instance_display_name: String = ""
) -> Node2D:
	if MonsterDatabase == null:
		print("MonsterDatabase não encontrado.")
		return null
	
	if not MonsterDatabase.has_method(
		"get_monster_data"
	):
		print(
			"MonsterDatabase não possui ",
			"get_monster_data()."
		)
		return null
	
	var monster_data: Dictionary = (
		MonsterDatabase.get_monster_data(
			monster_name
		)
	)
	
	if monster_data.is_empty():
		print(
			"Ficha de monstro não encontrada: ",
			monster_name
		)
		return null
	
	var enemy_instance := ENEMY_SCENE.instantiate()
	var final_display_name: String = monster_name
	
	if instance_display_name != "":
		final_display_name = instance_display_name
	
	enemy_instance.name = final_display_name.replace(
		" ",
		"_"
	)
	
	if board_root != null:
		board_root.add_child(enemy_instance)
	else:
		add_child(enemy_instance)
	
	enemy_instance.grid_position = grid_position
	
	if enemy_instance.has_method(
		"setup_from_monster_data"
	):
		enemy_instance.setup_from_monster_data(
			monster_data
		)
	else:
		print(
			"Enemy não possui ",
			"setup_from_monster_data()."
		)
	
	enemy_instance.display_name = final_display_name
	enemy_instance.monster_id = monster_name
	enemy_instance.grid_position = grid_position
	
	if enemy_instance.has_method(
		"update_world_position"
	):
		enemy_instance.update_world_position()
	
	enemies.append(enemy_instance)
	
	if not is_instance_valid(enemy):
		enemy = enemy_instance
	
	print(
		"Monstro criado: ",
		final_display_name,
		" em ",
		grid_position
	)
	
	return enemy_instance


func get_enemy_at_grid_position(
	grid_position: Vector2i
) -> Node2D:
	# =====================================================
	# ARRAY PRINCIPAL DE INIMIGOS
	# =====================================================
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		if enemy_unit.grid_position == grid_position:
			return enemy_unit
	
	# =====================================================
	# REFERÊNCIA ATUAL DE INIMIGO
	# =====================================================
	if is_instance_valid(enemy):
		if enemy.hp > 0:
			if enemy.visible:
				if enemy.grid_position == grid_position:
					return enemy
	
	# =====================================================
	# GARANTIA PELA ORDEM DE INICIATIVA
	# Recupera inimigos que estejam participando da batalha,
	# mesmo que uma referência tenha sido trocada.
	# =====================================================
	for initiative_unit in initiative_order:
		if not is_instance_valid(initiative_unit):
			continue
		
		if not is_enemy_unit(initiative_unit):
			continue
		
		if not "hp" in initiative_unit:
			continue
		
		if initiative_unit.hp <= 0:
			continue
		
		if not initiative_unit.visible:
			continue
		
		if not "grid_position" in initiative_unit:
			continue
		
		if initiative_unit.grid_position == grid_position:
			return initiative_unit
	
	return null

func unit_can_make_opportunity_attack(unit: Node2D) -> bool:
	if not is_instance_valid(unit):
		return false
	
	if not unit.has_method("get_equipped_weapon_data"):
		return true
	
	var weapon_data: Dictionary = unit.get_equipped_weapon_data()
	var weapon_type: String = str(weapon_data.get("type", "melee"))
	
	# Armas à distância não ameaçam área para ataque de oportunidade.
	if weapon_type == "ranged":
		return false
	
	return true
func grid_to_world_position(grid_position: Vector2i) -> Vector2:
	return Vector2(
		grid_position.x * TILE_SIZE + TILE_SIZE / 2,
		grid_position.y * TILE_SIZE + TILE_SIZE / 2
	)

func animate_unit_movement(unit: Node2D, path: Array[Vector2i]):
	if not is_instance_valid(unit):
		is_movement_animating = false
		return
	
	if path.is_empty():
		is_movement_animating = false
		return
	
	is_movement_animating = true
	
	for cell in path:
		if not is_instance_valid(unit):
			break
		
		if unit == hero:
			if hero.hp <= 0:
				break
		
		if is_instance_valid(animal_companion):
			if unit == animal_companion:
				if animal_companion.hp <= 0:
					break
		
		if is_enemy_unit(unit):
			if unit.hp <= 0 or not unit.visible:
				break
		
		unit.grid_position = cell
		
		var target_position: Vector2 = grid_to_world_position(cell)
		var tween := create_tween()
		tween.tween_property(unit, "position", target_position, movement_step_duration)
		
		await tween.finished
		if is_instance_valid(unit) and get_unit_class_name(unit) == "Ladino":
			check_hidden_rogue_perception(unit)
		elif is_instance_valid(unit) and is_enemy_unit(unit):
			if is_instance_valid(hero) and hero.is_hidden:
				check_hidden_rogue_perception(hero)
			for npc_unit in npcs:
				if is_instance_valid(npc_unit) and npc_unit.is_hidden:
					check_hidden_rogue_perception(npc_unit)
	
	is_movement_animating = false
	clear_path_preview_tiles()

func create_attack_area_layer() -> void:
	get_tactical_board_overlay()

func clear_attack_area() -> void:
	var overlay: Node = (
		get_tactical_board_overlay()
	)
	
	if not is_instance_valid(overlay):
		return
	
	overlay.clear_attack_tiles()


func create_attack_target_tile(
	grid_position: Vector2i
) -> void:
	var overlay: Node = (
		get_tactical_board_overlay()
	)
	
	if not is_instance_valid(overlay):
		return
	
	overlay.create_attack_tile(
		grid_position
	)


func has_enemy_within_weapon_range(unit: Node2D, weapon_range: float) -> bool:
	if not is_instance_valid(unit) or weapon_range <= 0.0:
		return false
	var targets: Array[Node2D] = enemies.duplicate()
	if is_instance_valid(enemy) and is_enemy_unit(enemy) and not targets.has(enemy):
		targets.append(enemy)
	for target in targets:
		if not is_instance_valid(target):
			continue
		if target.hp <= 0 or not target.visible:
			continue
		if get_distance_in_meters(unit.grid_position, target.grid_position) <= weapon_range:
			return true
	return false


func show_attack_area_for_unit(
	unit: Node2D
) -> void:
	clear_attack_area()
	
	if not is_instance_valid(unit):
		return
	
	if not initiative_started:
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	if waiting_spell_target:
		return
	
	if unit.hp <= 0:
		return
	
	if not unit.visible:
		return
	
	var attack_range: float = 1.5
	
	if unit.has_method(
		"get_weapon_range_meters"
	):
		attack_range = float(
			unit.get_weapon_range_meters()
		)
	
	if attack_range <= 0.0:
		return
	if not has_enemy_within_weapon_range(unit, attack_range):
		return
	
	for grid_x in range(current_grid_width):
		for grid_y in range(current_grid_height):
			var grid_position := Vector2i(
				grid_x,
				grid_y
			)
			
			if grid_position == unit.grid_position:
				continue
			
			var distance_to_position: float = (
				get_distance_in_meters(
					unit.grid_position,
					grid_position
				)
			)
			
			if distance_to_position > attack_range:
				continue
			
			create_attack_target_tile(
				grid_position
			)

func remove_defeated_enemies_from_initiative():
	for i in range(initiative_order.size() - 1, -1, -1):
		var unit: Node2D = initiative_order[i]
		var should_remove: bool = not is_instance_valid(unit)
		if not should_remove and is_enemy_unit(unit):
			should_remove = unit.hp <= 0
		if not should_remove:
			continue
		initiative_order.remove_at(i)
		# Preserva a posição do combatente ativo quando alguém
		# anterior a ele sai da iniciativa. Sem isso, o próximo
		# avanço pula uma unidade viva.
		if i <= current_initiative_index:
			current_initiative_index -= 1


func refresh_current_enemy_after_death():
	if is_instance_valid(enemy):
		if enemy.hp > 0 and enemy.visible:
			return
	
	enemy = null
	
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		enemy = enemy_unit
		return

func get_valid_attack_target_for_unit(attacker: Node2D, preferred_target: Node2D = null) -> Node2D:
	if not is_instance_valid(attacker):
		return null
	
	var attack_range: float = 1.5
	
	if attacker.has_method("get_weapon_range_meters"):
		attack_range = float(attacker.get_weapon_range_meters())
	
	if is_instance_valid(preferred_target):
		if preferred_target.hp > 0 and preferred_target.visible:
			var preferred_distance: float = get_distance_in_meters(
				attacker.grid_position,
				preferred_target.grid_position
			)
			
			if preferred_distance <= attack_range:
				return preferred_target
	
	var best_target: Node2D = null
	var best_distance: float = 999999.0
	
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		var distance_to_enemy: float = get_distance_in_meters(
			attacker.grid_position,
			enemy_unit.grid_position
		)
		
		if distance_to_enemy <= attack_range:
			if distance_to_enemy < best_distance:
				best_distance = distance_to_enemy
				best_target = enemy_unit
	
	return best_target
	
func create_movement_tile(
	grid_position: Vector2i,
	opportunity_risk: bool = false
) -> void:
	var overlay: Node = (
		get_tactical_board_overlay()
	)
	
	if not is_instance_valid(overlay):
		return
	
	overlay.create_movement_tile(
		grid_position,
		opportunity_risk
	)
	
func show_path_preview(
	path: Array[Vector2i]
) -> void:
	var overlay: Node = (
		get_tactical_board_overlay()
	)
	
	if not is_instance_valid(overlay):
		return
	
	overlay.show_path_preview(path)

func is_grid_position_blocked_for_path(
	grid_position: Vector2i,
	moving_unit: Node2D
) -> bool:
	
	# =====================================================
	# FORA DO MAPA
	# =====================================================
	if not is_inside_grid(grid_position):
		return true
	
	# =====================================================
	# TERRENO BLOQUEADO PELO CENÁRIO
	# =====================================================
	if is_terrain_blocked(grid_position):
		return true
	
	# =====================================================
	# HERÓI
	# =====================================================
	if is_instance_valid(hero):
		if moving_unit != hero:
			if hero.hp > 0:
				if hero.grid_position == grid_position:
					return true
	
	# =====================================================
	# COMPANHEIRO
	# =====================================================
	if is_instance_valid(animal_companion):
		if moving_unit != animal_companion:
			if animal_companion.hp > 0:
				if animal_companion.visible:
					if animal_companion.grid_position == grid_position:
						return true
	
	# =====================================================
	# NPCs
	# =====================================================
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if moving_unit == npc_unit:
			continue
		
		if npc_unit.hp <= 0:
			continue
		
		if not npc_unit.visible:
			continue
		
		if npc_unit.grid_position == grid_position:
			return true
	
	# =====================================================
	# INIMIGOS
	# =====================================================
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if moving_unit == enemy_unit:
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		if enemy_unit.grid_position == grid_position:
			return true
	
	# =====================================================
	# FALLBACK DO INIMIGO ÚNICO ANTIGO
	# =====================================================
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if moving_unit != enemy:
				if enemy.hp > 0:
					if enemy.visible:
						if enemy.grid_position == grid_position:
							return true
	
	return false

func get_path_neighbors(grid_position: Vector2i, moving_unit: Node2D) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	
	for offset_x in range(-1, 2):
		for offset_y in range(-1, 2):
			if offset_x == 0 and offset_y == 0:
				continue
			
			var neighbor_position := Vector2i(
				grid_position.x + offset_x,
				grid_position.y + offset_y
			)
			
			if not is_inside_grid(neighbor_position):
				continue
			
			if is_grid_position_blocked_for_path(neighbor_position, moving_unit):
				continue
			
			# =====================================================
			# BLOQUEIO DE CORTE DIAGONAL
			# Se mover na diagonal, não pode "passar pelo canto"
			# de uma unidade ocupando uma das laterais.
			# =====================================================
			if offset_x != 0 and offset_y != 0:
				var side_position_x := Vector2i(grid_position.x + offset_x, grid_position.y)
				var side_position_y := Vector2i(grid_position.x, grid_position.y + offset_y)
				
				if is_grid_position_blocked_for_path(side_position_x, moving_unit):
					continue
				
				if is_grid_position_blocked_for_path(side_position_y, moving_unit):
					continue
			
			neighbors.append(neighbor_position)
	
	return neighbors
	
func get_grid_path_avoiding_units(
	start_position: Vector2i,
	end_position: Vector2i,
	moving_unit: Node2D,
	max_movement: float,
	show_log: bool = true
) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	
	if start_position == end_position:
		return path
	
	if is_grid_position_blocked_for_path(end_position, moving_unit):
		if show_log:
			print("Destino bloqueado: ", end_position)
		return path
	
	var frontier: Array[Vector2i] = []
	var came_from: Dictionary = {}
	var cost_so_far: Dictionary = {}
	
	frontier.append(start_position)
	came_from[start_position] = start_position
	cost_so_far[start_position] = 0.0
	
	while not frontier.is_empty():
		var current_index: int = 0
		var current_best_cost: float = float(cost_so_far[frontier[0]])
		
		for i in range(frontier.size()):
			var test_position: Vector2i = frontier[i]
			var test_cost: float = float(cost_so_far[test_position])
			
			if test_cost < current_best_cost:
				current_best_cost = test_cost
				current_index = i
		
		var current_position: Vector2i = frontier[current_index]
		frontier.remove_at(current_index)
		
		if current_position == end_position:
			break
		
		var neighbors: Array[Vector2i] = get_path_neighbors(current_position, moving_unit)
		
		for next_position in neighbors:
			var step_cost: float = get_movement_cost(current_position, next_position)
			var new_cost: float = float(cost_so_far[current_position]) + step_cost
			
			if new_cost > max_movement:
				continue
			
			if not cost_so_far.has(next_position):
				cost_so_far[next_position] = new_cost
				came_from[next_position] = current_position
				frontier.append(next_position)
			else:
				var old_cost: float = float(cost_so_far[next_position])
				
				if new_cost < old_cost:
					cost_so_far[next_position] = new_cost
					came_from[next_position] = current_position
					
					if not frontier.has(next_position):
						frontier.append(next_position)
	
	if not came_from.has(end_position):
		if show_log:
			print("Nenhum caminho encontrado até o destino: ", end_position)
		return path
	
	var current: Vector2i = end_position
	
	while current != start_position:
		path.push_front(current)
		current = came_from[current]
	
	return path
	
func get_path_total_cost(start_position: Vector2i, path: Array[Vector2i]) -> float:
	var total_cost: float = 0.0
	var current_position: Vector2i = start_position
	
	for next_position in path:
		total_cost += get_movement_cost(current_position, next_position)
		current_position = next_position
	
	return total_cost
	
func clear_path_preview_tiles() -> void:
	if not is_instance_valid(
		tactical_board_overlay
	):
		return
	
	tactical_board_overlay.clear_path_preview()

func update_all_status_effects() -> void:
	if is_instance_valid(hero):
		if hero.has_method(
			"update_status_effects"
		):
			hero.update_status_effects(
				battle_turn_count
			)
	
	if is_instance_valid(animal_companion):
		if animal_companion.has_method(
			"update_status_effects"
		):
			animal_companion.update_status_effects(
				battle_turn_count
			)
	
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if npc_unit.has_method(
			"update_status_effects"
		):
			npc_unit.update_status_effects(
				battle_turn_count
			)
	
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.has_method(
			"update_status_effects"
		):
			enemy_unit.update_status_effects(
				battle_turn_count
			)
	
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.has_method(
				"update_status_effects"
			):
				enemy.update_status_effects(
					battle_turn_count
				)
				
	
func award_enemy_rewards(
	enemy_unit: Node2D
) -> void:
	if not is_instance_valid(enemy_unit):
		return

	if enemy_unit.hp > 0:
		return

	if enemy_unit.reward_given:
		return

	enemy_unit.reward_given = true

	var gained_xp: int = int(
		enemy_unit.xp_reward
	)

	var gained_gold: int = int(
		enemy_unit.gold_reward
	)

	battle_xp_gained += gained_xp
	battle_gold_gained += gained_gold
	battle_enemies_defeated += 1

	# O herói usa seu próprio sistema de progressão.
	if is_instance_valid(hero):
		grant_hero_xp(
			gained_xp
		)

		hero.gold += gained_gold
		GameState.hero_gold = hero.gold

	# Integrantes ativos e aliados jogáveis presentes no combate
	# recebem XP uma única vez, mesmo se estiverem na reserva.
	var playable_npc_ids: Array[String] = []
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		if str(npc_unit.control_type) != "player":
			continue
		var playable_id: String = str(npc_unit.npc_id)
		if PartyManager.has_member(playable_id) and not playable_npc_ids.has(playable_id):
			playable_npc_ids.append(playable_id)
	var rewarded_member_ids: Array[String] = (
		PartyManager.grant_xp_to_active_members(
			gained_xp,
			"hero",
			playable_npc_ids
		)
	)

	print("====================================")
	print("RECOMPENSA RECEBIDA")

	print(
		"Inimigo derrotado: ",
		get_unit_display_name(
			enemy_unit
		)
	)

	print(
		"XP ganho por integrante: ",
		gained_xp
	)

	print(
		"Ouro ganho pelo grupo: ",
		gained_gold
	)

	print(
		"Inimigos derrotados nesta batalha: ",
		battle_enemies_defeated
	)

	print(
		"XP ganho nesta batalha: ",
		battle_xp_gained
	)

	print(
		"Ouro ganho nesta batalha: ",
		battle_gold_gained
	)

	if is_instance_valid(hero):
		print(
			"XP total do herói: ",
			hero.total_xp
		)

		print(
			"Ouro total do grupo: ",
			hero.gold
		)

		print(
			"Nível atual do herói: ",
			hero.level
		)

	if not rewarded_member_ids.is_empty():
		print(
			"Outros integrantes que receberam XP: ",
			rewarded_member_ids
		)

	print("====================================")

	if is_instance_valid(hero):
		show_floating_text_on_unit(
			hero,
			"+" + str(gained_xp) + " XP",
			22,
			"utility"
		)

		if gained_gold > 0:
			await get_tree().create_timer(
				0.25
			).timeout

			show_floating_text_on_unit(
				hero,
				"+" + str(gained_gold) + " ouro",
				20,
				"utility"
			)

	# Atualiza imediatamente cada NPC integrante ativo.
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue

		var npc_member_id: String = ""

		if "npc_id" in npc_unit:
			npc_member_id = str(
				npc_unit.npc_id
			)

		if not rewarded_member_ids.has(
			npc_member_id
		):
			continue

		var member_data: Dictionary = (
			PartyManager.get_member(
				npc_member_id
			)
		)

		if npc_unit.has_method(
			"apply_party_member_progression"
		):
			npc_unit.apply_party_member_progression(
				member_data
			)

		show_floating_text_on_unit(
			npc_unit,
			"+" + str(gained_xp) + " XP",
			22,
			"utility"
		)

	update_movement_label()
	update_active_effects_panel()

	if has_method(
		"update_character_sheet_panel"
	):
		update_character_sheet_panel()

func process_defeated_enemy_rewards():
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			await award_enemy_rewards(enemy_unit)
	
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.hp <= 0:
				await award_enemy_rewards(enemy)

func get_enemy_basic_ai_action(enemy_target: Node2D) -> Dictionary:
	return EnemyAI.decide_basic_action(enemy, enemy_target, self)
	
func get_enemy_advanced_ai_action(enemy_target: Node2D) -> Dictionary:
	return EnemyAI.decide_advanced_action(enemy, enemy_target, self)

func execute_enemy_advanced_action(
	advanced_action: Dictionary,
	enemy_target: Node2D
) -> bool:
	if not is_instance_valid(enemy):
		return false
	
	if not is_instance_valid(enemy_target):
		return false
	
	var action_type: String = str(
		advanced_action.get(
			"type",
			"none"
		)
	)
	
	var action_reason: String = str(
		advanced_action.get(
			"reason",
			"none"
		)
	)
	
	if action_type == "none":
		return false
	
	print("====================================")
	print("AÇÃO AVANÇADA DA IA")
	print(
		"Inimigo: ",
		get_unit_display_name(enemy)
	)
	print("Ação: ", action_type)
	print("Motivo: ", action_reason)
	print("====================================")
	
	match action_type:
		"move":
			var move_position: Vector2i = (
				advanced_action.get(
					"position",
					enemy.grid_position
				)
			)
			
			if move_position == enemy.grid_position:
				return false
			
			var moved: bool = await move_enemy_to(
				move_position
			)
			
			if moved:
				if action_reason == "escape_spell_area":
					show_floating_text_on_unit(
						enemy,
						"SAIU DA ÁREA",
						18,
						"utility"
					)
				elif action_reason == "retreat":
					show_floating_text_on_unit(
						enemy,
						"RECUOU",
						22,
						"miss"
					)
				else:
					show_floating_text_on_unit(
						enemy,
						"MOVEU",
						18,
						"utility"
					)
				
				return true
			
			return false
		
		"cast_spell":
			var spell_name: String = str(
				advanced_action.get(
					"spell_name",
					""
				)
			)
			
			return await enemy_cast_offensive_spell(
				enemy_target,
				spell_name
			)
		
		"buff":
			enemy_use_buff()
			return true
		
		"heal_self":
			enemy_heal_self()
			return true
		
		"potion":
			enemy_use_potion()
			return true
		
		_:
			print(
				"Ação avançada desconhecida: ",
				action_type
			)
			
			return false

func enemy_cast_offensive_spell(
	target_unit: Node2D,
	spell_name: String
) -> bool:
	if not is_instance_valid(enemy):
		return false
	
	if not is_instance_valid(target_unit):
		return false
	
	if target_unit.hp <= 0:
		return false
	
	if spell_name != "Mísseis Mágicos":
		print(
			"Magia ofensiva inimiga não implementada: ",
			spell_name
		)
		return false
	
	if not enemy.has_method(
		"knows_spell"
	):
		return false
	
	if not enemy.knows_spell(
		spell_name
	):
		return false
	
	if not enemy.has_method(
		"has_spell_slot_available"
	):
		return false
	
	if not enemy.has_spell_slot_available(
		1
	):
		return false
	
	var distance_to_target: float = (
		get_distance_in_meters(
			enemy.grid_position,
			target_unit.grid_position
		)
	)
	
	var spell_range: float = 12.0
	
	if distance_to_target > spell_range:
		return false
	
	if not enemy.has_method(
		"consume_spell_slot"
	):
		return false
	
	if not enemy.consume_spell_slot(
		1
	):
		return false

	if UIAudioManager != null:
		UIAudioManager.play_spell(spell_name, {"effect": "damage"})
	show_spell_visual_on_unit(spell_name, {"visual_kind": "energy"}, target_unit)
	
	if (
		UIAudioManager != null
		and UIAudioManager.has_method(
			"play_dice_roll"
		)
	):
		UIAudioManager.play_dice_roll()
	
	var damage_roll: int = randi_range(
		1,
		4
	)
	
	var damage_bonus: int = 1
	
	var total_damage: int = (
		damage_roll
		+ damage_bonus
	)
	
	var applied_damage: int = (
		apply_damage_to_unit(
			target_unit,
			total_damage,
			28,
			7.0,
			0.24,
			Color(
				0.62,
				0.30,
				1.0,
				1.0
			),
			0.22
		)
	)
	
	enemy.has_attacked = true
	
	show_spell_resolution_box(
		spell_name,
		target_unit,
		{},
		applied_damage,
		(
			"d4 "
			+ str(damage_roll)
			+ " + "
			+ str(damage_bonus)
			+ " = "
			+ str(total_damage)
		)
	)
	
	show_floating_text_on_unit(
		enemy,
		"CONJUROU!",
		22,
		"utility"
	)
	
	print("====================================")
	print("MAGIA DO INIMIGO")
	print(
		"Conjurador: ",
		get_unit_display_name(enemy)
	)
	print("Magia: ", spell_name)
	print(
		"Alvo: ",
		get_unit_display_name(target_unit)
	)
	print(
		"Dano: d4 ",
		damage_roll,
		" + ",
		damage_bonus,
		" = ",
		total_damage
	)
	print(
		"Espaços restantes: ",
		enemy.spell_slots_level_1
	)
	print("====================================")
	
	refresh_combat_ui_after_attack()
	update_active_effects_panel()
	
	await get_tree().create_timer(
		0.35
	).timeout
	
	return true
func enemy_attack_target(
	target_unit: Node2D
) -> void:
	if not is_instance_valid(enemy):
		return
	
	if not is_instance_valid(target_unit):
		return
	
	if enemy.has_attacked:
		print(
			"Inimigo já atacou neste turno."
		)
		return
	
	var enemy_range: float = 1.5
	
	if enemy.has_method(
		"get_weapon_range_meters"
	):
		enemy_range = float(
			enemy.get_weapon_range_meters()
		)
	
	var distance_to_target: float = (
		get_distance_in_meters(
			enemy.grid_position,
			target_unit.grid_position
		)
	)
	
	if distance_to_target > enemy_range:
		print(
			"Alvo fora do alcance do inimigo."
		)
		return
	
	var attack_bonus: int = 0
	
	if enemy.has_method(
		"get_base_attack_bonus"
	):
		attack_bonus += int(
			enemy.get_base_attack_bonus()
		)
	
	var weapon_type: String = "melee"
	
	if enemy.has_method(
		"get_equipped_weapon_data"
	):
		var weapon_data: Dictionary = (
			enemy.get_equipped_weapon_data()
		)
		
		weapon_type = str(
			weapon_data.get(
				"type",
				"melee"
			)
		)
		
		if weapon_data.has(
			"attack_bonus"
		):
			attack_bonus += int(
				weapon_data[
					"attack_bonus"
				]
			)
	
	if weapon_type == "ranged":
		if enemy.has_method(
			"get_dexterity_modifier"
		):
			attack_bonus += int(
				enemy.get_dexterity_modifier()
			)
	else:
		if enemy.has_method(
			"get_strength_modifier"
		):
			attack_bonus += int(
				enemy.get_strength_modifier()
			)
	
	attack_bonus += int(
		enemy.temporary_attack_bonus
	)
	
	var control_attack_penalty: int = 0
	
	if "control_attack_penalty" in enemy:
		control_attack_penalty = int(
			enemy.control_attack_penalty
		)
	
	var high_ground_bonus: int = (
		get_high_ground_attack_bonus_for_unit(
			enemy
		)
	)
	
	attack_bonus += high_ground_bonus
	
	if high_ground_bonus > 0:
		print(
			"Bônus de terreno alto do inimigo: +",
			high_ground_bonus
		)
		
		show_floating_text_on_unit(
			enemy,
			"TERRENO ALTO +%d"
			% high_ground_bonus,
			18,
			"utility"
		)
	
	var target_ac: int = 10
	
	if target_unit.has_method(
		"get_armor_class"
	):
		target_ac = int(
			target_unit.get_armor_class()
		)
	
	var attack_result: Dictionary = (
		roll_attack_result(
			attack_bonus,
			target_ac,
			enemy,
			target_unit
		)
	)
	
	var dice_roll: int = int(
		attack_result["dice_roll"]
	)
	
	var attack_total: int = int(
		attack_result["attack_total"]
	)
	
	var hit: bool = bool(
		attack_result["hit"]
	)
	
	var critical_hit: bool = bool(
		attack_result["critical_hit"]
	)
	
	print("====================================")
	print("ATAQUE DO INIMIGO")
	print(
		"Inimigo: ",
		get_unit_display_name(enemy)
	)
	print(
		"Alvo: ",
		get_unit_display_name(
			target_unit
		)
	)
	print(
		"Distância: ",
		distance_to_target,
		"m"
	)
	print(
		"Alcance: ",
		enemy_range,
		"m"
	)
	print(
		"Rolagem: d20 ",
		dice_roll
	)
	print(
		"Penalidade de controle: ",
		control_attack_penalty
	)
	print(
		"Bônus de terreno alto: ",
		high_ground_bonus
	)
	print(
		"Bônus final: ",
		attack_bonus
	)
	print(
		"Total: ",
		attack_total
	)
	print(
		"CA do alvo: ",
		target_ac
	)
	print("====================================")
	
	if dice_roll == 20:
		print(
			"Inimigo tirou 20 natural."
		)
		
		show_floating_text_on_unit(
			target_unit,
			"CRÍTICO!",
			30,
			"critical"
		)
	elif dice_roll == 1:
		print(
			"Inimigo tirou 1 natural."
		)
		
		show_floating_text_on_unit(
			target_unit,
			"ERROU",
			26,
			"miss"
		)
	
	if hit:
		var damage: int = int(
			enemy.attack_power
		)
		
		if enemy.has_method(
			"roll_total_weapon_damage"
		):
			damage = int(
				enemy.roll_total_weapon_damage()
			)
		
		if critical_hit:
			damage *= 2
		
		damage = apply_attack_damage_to_unit(
			target_unit,
			damage,
			critical_hit
		)
		
		print("Inimigo acertou.")
		print(
			"Dano: ",
			damage
		)
	else:
		print(
			"Inimigo errou o ataque."
		)
		
		if dice_roll != 1:
			show_floating_text_on_unit(
				target_unit,
				"ERROU",
				26,
				"miss"
			)
	
	enemy.has_attacked = true
	
	update_after_enemy_attack()
	update_active_effects_panel()

func create_game_camera():
	var old_camera := get_node_or_null(
		"GameCamera"
	)
	
	if old_camera != null:
		old_camera.queue_free()
	
	game_camera = (
		GameCameraControllerScript.new()
	)
	
	game_camera.name = "GameCamera"
	game_camera.enabled = true
	
	game_camera.position_smoothing_enabled = true
	game_camera.position_smoothing_speed = 3.5
	
	game_camera.zoom = Vector2(
		camera_zoom_value,
		camera_zoom_value
	)
	
	game_camera.connect(
		"manual_control_started",
		Callable(
			self,
			"on_manual_camera_control_started"
		)
	)
	
	add_child(game_camera)
	game_camera.make_current()

func create_battle_zoom_controls() -> void:
	if not is_instance_valid(ui_layer):
		return

	var zoom_controls := VBoxContainer.new()
	zoom_controls.name = "BattleZoomControls"
	zoom_controls.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	zoom_controls.offset_left = -76
	zoom_controls.offset_right = -12
	zoom_controls.offset_top = -110
	zoom_controls.offset_bottom = 30
	zoom_controls.add_theme_constant_override("separation", 8)
	ui_layer.add_child(zoom_controls)

	var zoom_in_button := Button.new()
	zoom_in_button.text = "+"
	zoom_in_button.tooltip_text = "Aproximar a câmera"
	zoom_in_button.custom_minimum_size = Vector2(64, 64)
	zoom_in_button.add_theme_font_size_override("font_size", 32)
	zoom_in_button.pressed.connect(change_battle_zoom.bind(0.15))
	zoom_controls.add_child(zoom_in_button)

	var zoom_out_button := Button.new()
	zoom_out_button.text = "−"
	zoom_out_button.tooltip_text = "Afastar a câmera"
	zoom_out_button.custom_minimum_size = Vector2(64, 64)
	zoom_out_button.add_theme_font_size_override("font_size", 32)
	zoom_out_button.pressed.connect(change_battle_zoom.bind(-0.15))
	zoom_controls.add_child(zoom_out_button)

func change_battle_zoom(amount: float) -> void:
	if not is_instance_valid(game_camera):
		return

	camera_zoom_value = clampf(camera_zoom_value + amount, 0.75, 2.0)
	game_camera.zoom = Vector2.ONE * camera_zoom_value
	update_game_camera_limits()

func update_game_camera_limits() -> void:
	if not is_instance_valid(game_camera):
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var half_visible_world: Vector2 = viewport_size / game_camera.zoom / 2.0
	game_camera.limit_left = -int(half_visible_world.x)
	game_camera.limit_top = -int(half_visible_world.y)
	game_camera.limit_right = int(current_grid_width * TILE_SIZE + half_visible_world.x)
	game_camera.limit_bottom = int(current_grid_height * TILE_SIZE + half_visible_world.y)
	game_camera.limit_smoothed = true

func center_camera_on_unit(unit: Node2D):
	if not is_instance_valid(game_camera):
		return
	
	if not is_instance_valid(unit):
		return
	
	camera_follow_unit = unit

func update_camera_follow():
	if not is_instance_valid(game_camera):
		return
	
	if not is_instance_valid(camera_follow_unit):
		return
	
	game_camera.global_position = camera_follow_unit.global_position
func get_reachable_positions_for_unit(unit: Node2D, max_movement: float) -> Dictionary:
	var reachable: Dictionary = {}
	
	if not is_instance_valid(unit):
		return reachable
	
	var start_position: Vector2i = unit.grid_position
	
	var frontier: Array[Vector2i] = []
	frontier.append(start_position)
	
	reachable[start_position] = 0.0
	
	while not frontier.is_empty():
		var current_index: int = 0
		var current_best_cost: float = float(reachable[frontier[0]])
		
		for i in range(frontier.size()):
			var test_position: Vector2i = frontier[i]
			var test_cost: float = float(reachable[test_position])
			
			if test_cost < current_best_cost:
				current_best_cost = test_cost
				current_index = i
		
		var current_position: Vector2i = frontier[current_index]
		frontier.remove_at(current_index)
		
		var neighbors: Array[Vector2i] = get_path_neighbors(current_position, unit)
		
		for next_position in neighbors:
			if is_grid_position_blocked_for_path(next_position, unit):
				continue
			
			var step_cost: float = get_movement_cost(current_position, next_position)
			var new_cost: float = float(reachable[current_position]) + step_cost
			
			if new_cost > max_movement:
				continue
			
			if not reachable.has(next_position):
				reachable[next_position] = new_cost
				frontier.append(next_position)
			else:
				var old_cost: float = float(reachable[next_position])
				
				if new_cost < old_cost:
					reachable[next_position] = new_cost
					
					if not frontier.has(next_position):
						frontier.append(next_position)
	
	return reachable

func get_turn_banner_controller() -> Node:
	if is_instance_valid(
		turn_banner_controller
	):
		return turn_banner_controller
	
	turn_banner_controller = (
		TurnBannerScript.new()
	)
	
	turn_banner_controller.name = (
		"TurnBannerController"
	)
	
	add_child(turn_banner_controller)
	
	if turn_banner_controller.has_method(
		"setup"
	):
		turn_banner_controller.setup()
	
	return turn_banner_controller

func create_turn_banner_layer() -> void:
	var controller: Node = (
		get_turn_banner_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.setup()


func get_turn_banner_group_for_unit(unit: Node2D) -> String:
	if not is_instance_valid(unit):
		return ""
	
	if unit == hero:
		return "hero"
	
	if is_instance_valid(animal_companion):
		if unit == animal_companion:
			return "hero"
	
	if is_npc_unit(unit):
		if unit.faction == "ally":
			return "hero"
	
	if is_enemy_unit(unit):
		return "enemy"
	
	return ""

func show_turn_banner(
	text: String
) -> void:
	var controller: Node = (
		get_turn_banner_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.show_text(text)

func show_turn_banner_for_unit_if_needed(
	unit: Node2D
) -> void:
	var current_group: String = (
		get_turn_banner_group_for_unit(
			unit
		)
	)
	
	if current_group == "":
		return
	
	var controller: Node = (
		get_turn_banner_controller()
	)
	
	if not is_instance_valid(controller):
		return
	
	controller.show_for_group(
		current_group
	)

func wait_before_action():
	var action_delay: float = (
		ACTION_DELAY_WITH_ROLL_BOX
		if GameState.show_attack_roll_box
		else ACTION_DELAY_WITHOUT_ROLL_BOX
	)
	
	if action_delay <= 0.0:
		return
	
	await get_tree().create_timer(
		action_delay
	).timeout

func load_scenario_data(stage_number: int):
	current_scenario_data = (
		ScenarioDatabase.get_scenario_data(
			stage_number
		)
	)
	
	terrain_map.clear()
	collected_scenario_interactions.clear()
	triggered_scenario_events.clear()
	
	current_grid_width = int(
		current_scenario_data.get(
			"grid_width",
			GRID_WIDTH
		)
	)
	
	current_grid_height = int(
		current_scenario_data.get(
			"grid_height",
			GRID_HEIGHT
		)
	)
	
	update_game_camera_limits()
	
	var terrain_data: Dictionary = (
		current_scenario_data.get(
			"terrain",
			{}
		)
	)
	
	for difficult_cell in terrain_data.get(
		"difficult",
		[]
	):
		terrain_map[difficult_cell] = "difficult"
	
	for blocked_cell in terrain_data.get(
		"blocked",
		[]
	):
		terrain_map[blocked_cell] = "blocked"
	
	for danger_cell in terrain_data.get(
		"danger",
		[]
	):
		terrain_map[danger_cell] = "danger"
	
	print("====================================")
	print("CENÁRIO CARREGADO")
	print(
		"ID: ",
		current_scenario_data.get(
			"id",
			stage_number
		)
	)
	print(
		"Nome: ",
		current_scenario_data.get(
			"name",
			"Cenário"
		)
	)
	print(
		"Tamanho: ",
		current_grid_width,
		"x",
		current_grid_height
	)
	print(
		"Terrenos especiais: ",
		terrain_map.size()
	)
	print("====================================")


func get_terrain_type(grid_position: Vector2i) -> String:
	if terrain_map.has(grid_position):
		return str(terrain_map[grid_position])
	
	return "normal"


func is_terrain_blocked(grid_position: Vector2i) -> bool:
	return get_terrain_type(grid_position) == "blocked"


func get_terrain_movement_multiplier(grid_position: Vector2i) -> float:
	var terrain_type: String = get_terrain_type(grid_position)
	
	match terrain_type:
		"difficult":
			return 2.0
		"danger":
			return 1.0
		"blocked":
			return 999.0
		_:
			return 1.0
func apply_scenario_start_positions():
	if current_scenario_data.is_empty():
		return
	
	if is_instance_valid(hero):
		var hero_start: Vector2i = current_scenario_data.get("player_start", Vector2i(4, 16))
		hero.grid_position = hero_start
		hero.position = grid_to_world_position(hero_start)
	
	if is_instance_valid(animal_companion):
		var companion_start: Vector2i = current_scenario_data.get("companion_start", Vector2i(5, 17))
		animal_companion.grid_position = companion_start
		animal_companion.position = grid_to_world_position(companion_start)
func setup_scenario_monsters():
	clear_enemies()
	
	if current_scenario_data.is_empty():
		print("Nenhum dado de cenário carregado.")
		return
	
	var enemy_list: Array = current_scenario_data.get(
		"enemies",
		[]
	)
	
	for enemy_data in enemy_list:
		var monster_id: String = str(
			enemy_data.get("monster_id", "")
		)
		
		var display_name: String = str(
			enemy_data.get(
				"display_name",
				monster_id
			)
		)
		
		var spawn_position: Vector2i = (
			enemy_data.get(
				"position",
				Vector2i(20, 16)
			)
		)
		
		if monster_id == "":
			continue
		
		spawn_monster(
			monster_id,
			spawn_position,
			display_name
		)
	
	print(
		"Inimigos do cenário criados: ",
		enemies.size()
	)


func play_enemy_intro_sound_for_group(enemy_units: Array[Node2D]) -> void:
	if UIAudioManager == null:
		return
	for enemy_unit in enemy_units:
		if not is_instance_valid(enemy_unit) or not enemy_unit.visible:
			continue
		if UIAudioManager.get_enemy_sound_family(str(enemy_unit.monster_id)) == "canine":
			continue
		if UIAudioManager.play_enemy_intro(str(enemy_unit.monster_id)):
			return

func play_canine_intro_at_initiative() -> void:
	if UIAudioManager == null:
		return
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit) or enemy_unit.hp <= 0 or not enemy_unit.visible:
			continue
		if UIAudioManager.get_enemy_sound_family(str(enemy_unit.monster_id)) == "canine":
			UIAudioManager.play_enemy_intro(str(enemy_unit.monster_id))
			return

func get_scenario_interaction_at_position(grid_position: Vector2i) -> Dictionary:
	if current_scenario_data.is_empty():
		return {}
	
	var interactions: Array = current_scenario_data.get("interactions", [])
	
	for interaction_data in interactions:
		var interaction_position: Vector2i = interaction_data.get("position", Vector2i(-999, -999))
		
		if interaction_position == grid_position:
			return interaction_data
	
	return {}


func process_scenario_interaction_for_unit(unit: Node2D):
	if not is_instance_valid(unit):
		return
	
	# Por enquanto apenas o herói pode vasculhar/interagir.
	if unit != hero:
		return
	
	var interaction_data: Dictionary = get_scenario_interaction_at_position(unit.grid_position)
	
	if interaction_data.is_empty():
		return
	
	var interaction_id: String = str(interaction_data.get("id", ""))
	
	if interaction_id == "":
		return
	
	var once: bool = bool(interaction_data.get("once", true))
	
	if once:
		if collected_scenario_interactions.has(interaction_id):
			return
	
	collected_scenario_interactions[interaction_id] = true
	
	var interaction_type: String = str(interaction_data.get("type", ""))
	var reward_gold: int = int(interaction_data.get("reward_gold", 0))
	var message: String = str(interaction_data.get("message", ""))
	
	if interaction_type == "search":
		if reward_gold > 0:
			hero.gold += reward_gold
			GameState.hero_gold = hero.gold
		
		if message != "":
			print(message)
			show_floating_text_on_unit(hero, message, 18, "utility")
		
		update_movement_label()
		update_active_effects_panel()
		
		if has_method("update_character_sheet_panel"):
			update_character_sheet_panel()


func is_high_ground_position(grid_position: Vector2i) -> bool:
	if current_scenario_data.is_empty():
		return false
	
	var high_ground_positions: Array = current_scenario_data.get("high_ground", [])
	
	for high_ground_position in high_ground_positions:
		if high_ground_position == grid_position:
			return true
	
	return false


func get_high_ground_attack_bonus_for_unit(unit: Node2D) -> int:
	if not is_instance_valid(unit):
		return 0
	
	if current_scenario_data.is_empty():
		return 0
	
	if is_high_ground_position(unit.grid_position):
		return int(current_scenario_data.get("high_ground_attack_bonus", 2))
	
	return 0

func find_scenario_npc_by_id(
	npc_id: String
) -> Node2D:
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if not ("npc_id" in npc_unit):
			continue
		
		if str(npc_unit.npc_id) == npc_id:
			return npc_unit
	
	return null

func play_scenario_intro_camera():
	if scenario_intro_running:
		return
	
	if not is_instance_valid(game_camera):
		return
	
	scenario_intro_running = true
	
	var original_follow_unit: Node2D = camera_follow_unit
	
	# =====================================================
	# 1. MOSTRA HERÓI
	# =====================================================
	if is_instance_valid(hero):
		camera_follow_unit = null
		game_camera.global_position = hero.global_position
		
		await get_tree().create_timer(scenario_intro_focus_time).timeout
	
	# =====================================================
	# 2. MOSTRA COMPANHEIRO
	# =====================================================
	if is_instance_valid(animal_companion):
		if animal_companion.visible:
			game_camera.global_position = animal_companion.global_position
			
			await get_tree().create_timer(scenario_intro_focus_time).timeout
	
	# =====================================================
	# 3. MOSTRA NPCs ALIADOS
	# =====================================================
	
		for npc_unit in npcs:
			if not is_instance_valid(npc_unit):
				continue
			
			if not npc_unit.visible:
				continue
			
			if npc_unit.faction != "ally":
				continue
			
			game_camera.global_position = npc_unit.global_position
			
			await get_tree().create_timer(scenario_intro_focus_time).timeout
	
	# =====================================================
	# 4. MOSTRA TODOS OS INIMIGOS
	# =====================================================
	var enemy_intro_played: bool = false
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		game_camera.global_position = enemy_unit.global_position
		if not enemy_intro_played:
			play_enemy_intro_sound_for_group(enemies)
			enemy_intro_played = true
		
		await get_tree().create_timer(scenario_intro_focus_time).timeout
	
	# Fallback caso ainda exista apenas enemy.
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.hp > 0 and enemy.visible:
				game_camera.global_position = enemy.global_position
				play_enemy_intro_sound_for_group([enemy])
				
				await get_tree().create_timer(scenario_intro_focus_time).timeout
	
	# =====================================================
	# 5. RETORNA AO HERÓI
	# =====================================================
	if is_instance_valid(hero):
		game_camera.global_position = hero.global_position
		
		await get_tree().create_timer(0.4).timeout
		
		camera_follow_unit = hero
	else:
		camera_follow_unit = original_follow_unit
	
	scenario_intro_running = false
func clear_npcs():
	for npc_unit in npcs:
		if is_instance_valid(npc_unit):
			npc_unit.queue_free()
	
	npcs.clear()


func spawn_npc(
	npc_id: String,
	grid_position: Vector2i,
	instance_display_name: String = "",
	control_type_override: String = ""
) -> Node2D:
	var npc_data: Dictionary = (
		NpcDatabase.get_npc_data(
			npc_id
		)
	)

	if npc_data.is_empty():
		print(
			"NPC não encontrado: ",
			npc_id
		)
		return null

	# Trabalhamos com uma cópia para não alterar
	# permanentemente os dados do NpcDatabase.
	npc_data = npc_data.duplicate(true)

	var npc_instance := (
		NPC_SCENE.instantiate()
	)

	var final_display_name: String = str(
		npc_data.get(
			"display_name",
			npc_id
		)
	)

	if instance_display_name != "":
		final_display_name = (
			instance_display_name
		)
	# Saves antigos podem trazer o título anterior como nome de exibição.
	if npc_id == "Sr Uiliam":
		final_display_name = "Sir Uiliam"

	if control_type_override != "":
		npc_data["control_type"] = (
			control_type_override
		)

	npc_instance.name = (
		final_display_name.replace(
			" ",
			"_"
		)
	)

	if board_root != null:
		board_root.add_child(
			npc_instance
		)
	else:
		add_child(
			npc_instance
		)

	npc_instance.grid_position = (
		grid_position
	)

	if npc_instance.has_method(
		"setup_from_npc_data"
	):
		npc_instance.setup_from_npc_data(
			npc_data
		)

	npc_instance.display_name = (
		final_display_name
	)

	npc_instance.npc_id = npc_id
	npc_instance.grid_position = grid_position

	# Se o NPC já integra o grupo, aplica seu nível
	# e sua experiência persistentes.
	if PartyManager.has_member(
		npc_id
	):
		var party_member_data: Dictionary = (
			PartyManager.get_member(
				npc_id
			)
		)

		if npc_instance.has_method(
			"apply_party_member_progression"
		):
			npc_instance.apply_party_member_progression(
				party_member_data
			)

	if npc_instance.has_method(
		"update_world_position"
	):
		npc_instance.update_world_position()

	if npc_instance.has_signal(
		"died"
	):
		npc_instance.died.connect(
			on_npc_died
		)

	npcs.append(
		npc_instance
	)

	print(
		"NPC criado: ",
		final_display_name,
		" | posição: ",
		grid_position,
		" | controle: ",
		npc_instance.control_type,
		" | nível: ",
		npc_instance.level,
		" | XP total: ",
		npc_instance.total_xp
	)

	return npc_instance


func setup_scenario_npcs():
	clear_npcs()
	
	if current_scenario_data.is_empty():
		return
	
	var npc_list: Array = current_scenario_data.get("npcs", [])
	
	for npc_entry in npc_list:
		var npc_id: String = str(npc_entry.get("npc_id", ""))
		
		if npc_id == "":
			continue
		if current_stage == 3 and npc_id == "Aniri":
			PartyManager.recruit_npc("Aniri", false)
		
		var display_name: String = str(
			npc_entry.get("display_name", npc_id)
		)
		
		var spawn_position: Vector2i = npc_entry.get(
			"position",
			Vector2i.ZERO
		)
		
		var control_type: String = str(
			npc_entry.get("control_type", "")
		)
		
		spawn_npc(
			npc_id,
			spawn_position,
			display_name,
			control_type
		)
	
	print("NPCs do cenário criados: ", npcs.size())
func start_current_scenario_music():
	if current_scenario_data.is_empty():
		return
	
	var music_path: String = str(
		current_scenario_data.get("music", "")
	)
	
	if music_path == "":
		return
	
	if not ResourceLoader.exists(music_path):
		print(
			"Música do cenário não encontrada: ",
			music_path
		)
		return
	
	var music_volume_percent: float = (
		ScenarioDatabase.get_scenario_music_volume_percent(
			current_stage
		)
	)
	
	MusicManage.play_music(
		music_path,
		music_volume_percent
	)

func is_npc_unit(unit: Node2D) -> bool:
	if not is_instance_valid(unit):
		return false
	
	for npc_unit in npcs:
		if not is_instance_valid(npc_unit):
			continue
		
		if npc_unit == unit:
			return true
	
	return false
func is_player_controlled_npc(unit: Node2D) -> bool:
	if not is_npc_unit(unit):
		return false
	
	return str(unit.control_type) == "player"
func start_player_npc_turn(npc_unit: Node2D):
	if not is_instance_valid(npc_unit):
		advance_initiative_turn()
		return
	
	if not is_npc_unit(npc_unit):
		print(
			"Unidade enviada para start_player_npc_turn não é NPC: ",
			get_unit_display_name(npc_unit)
		)
		
		advance_initiative_turn()
		return
	
	await begin_player_controlled_turn(npc_unit)
	

func on_npc_died(
	npc_unit: Node2D
) -> void:
	if not is_instance_valid(
		npc_unit
	):
		return
	
	print("====================================")
	print("NPC DERROTADO")
	print(
		"NPC: ",
		get_unit_display_name(
			npc_unit
		)
	)
	print(
		"ID: ",
		npc_unit.npc_id
	)
	print("====================================")
	
	remove_npc_from_initiative(
		npc_unit
	)
	
	await process_scenario_npc_death_events(
		npc_unit
	)
	
	await check_battle_result()

func remove_npc_from_initiative(npc_unit: Node2D):
	if not is_instance_valid(npc_unit):
		return
	
	for i in range(initiative_order.size() - 1, -1, -1):
		if initiative_order[i] == npc_unit:
			initiative_order.remove_at(i)
			
			if i < current_initiative_index:
				current_initiative_index -= 1
	
	if current_initiative_index < 0:
		current_initiative_index = 0
func process_scenario_npc_death_events(
	dead_npc: Node2D
) -> void:
	if current_scenario_data.is_empty():
		return
	
	var events: Array = (
		current_scenario_data.get(
			"events",
			[]
		)
	)
	
	for event_data in events:
		var event_id: String = str(
			event_data.get(
				"id",
				""
			)
		)
		
		if event_id == "":
			continue
		
		if ScenarioDatabase.is_round_event(
			current_stage,
			event_id
		):
			continue
		
		if triggered_scenario_events.has(event_id):
			continue
		
		var trigger_type: String = str(
			event_data.get(
				"trigger",
				""
			)
		)
		
		if trigger_type != "npc_death":
			continue
		
		var required_npc_id: String = str(
			event_data.get(
				"trigger_npc_id",
				""
			)
		)
		
		if required_npc_id != str(
			dead_npc.npc_id
		):
			continue
		
		triggered_scenario_events[event_id] = true
		
		await execute_scenario_event(
			event_data
		)

func execute_scenario_event(
	event_data: Dictionary
) -> void:
	var event_id: String = str(
		event_data.get(
			"id",
			""
		)
	)
	
	print("====================================")
	print("EVENTO DO CENÁRIO")
	print("Evento: ", event_id)
	print("====================================")
	
	var spawn_data: Dictionary = (
		get_scenario_event_spawn_data(
			event_data
		)
	)
	
	if spawn_data.is_empty():
		return
	
	var final_spawn_position: Vector2i = (
		spawn_data.get(
			"position",
			Vector2i.ZERO
		)
	)
	
	var entry_data: Dictionary = (
		ScenarioDatabase
		.get_scenario_event_entry_data(
			event_id
		)
	)
	
	# Durante duas rodadas, qualquer combatente pode
	# ocupar a posição prevista para Hashagur.
	if event_id == "hashagur_arrival":
		final_spawn_position = (
			find_free_scenario_arrival_cell(
				final_spawn_position
			)
		)
		
		if final_spawn_position == Vector2i(-1, -1):
			push_warning(
				"Hashagur não encontrou uma célula "
				+ "livre para entrar na batalha."
			)
			return
		
		var preferred_entry: Vector2i = (
			entry_data.get(
				"map_entry_position",
				Vector2i(12, 10)
			)
		)
		
		var safe_entry: Vector2i = (
			find_free_scenario_arrival_cell(
				preferred_entry,
				final_spawn_position
			)
		)
		
		if safe_entry == Vector2i(-1, -1):
			safe_entry = final_spawn_position
			entry_data["movement_duration"] = 0.0
		
		entry_data["map_entry_position"] = (
			safe_entry
		)
	
	var camera_position: Vector2i = (
		event_data.get(
			"camera_focus",
			final_spawn_position
		)
	)
	
	if not entry_data.is_empty():
		camera_position = entry_data.get(
			"camera_focus",
			camera_position
		)
	
	var pre_spawn_dialogue: Array = event_data.get(
		"pre_spawn_dialogue",
		[]
	)
	if not pre_spawn_dialogue.is_empty():
		await show_scenario_dialogue_entries(pre_spawn_dialogue)
	
	var unit_spawn_data: Dictionary = (
		spawn_data.duplicate(true)
	)
	
	if not entry_data.is_empty():
		var legacy_start_position := Vector2i(
			int(
				entry_data.get(
					"start_x",
					current_grid_width + 1
				)
			),
			final_spawn_position.y
		)
		
		var start_position: Vector2i = (
			entry_data.get(
				"start_position",
				legacy_start_position
			)
		)
		
		unit_spawn_data["position"] = (
			start_position
		)
	
	var spawned_unit: Node2D = (
		spawn_scenario_event_unit(
			unit_spawn_data
		)
	)
	
	if not is_instance_valid(spawned_unit):
		push_warning(
			"Não foi possível criar a unidade do evento: "
			+ str(
				spawn_data.get(
					"id",
					""
				)
			)
		)
		return
	
	if not entry_data.is_empty():
		spawned_unit.visible = false
		is_movement_animating = true
	
	await focus_camera_on_grid_position(
		camera_position
	)
	
	if not entry_data.is_empty():
		await animate_scenario_event_unit_entry(
			spawned_unit,
			final_spawn_position,
			entry_data
		)
		
		is_movement_animating = false
	
	print("NPC criado com sucesso.")
	print(
		"Nome: ",
		get_unit_display_name(
			spawned_unit
		)
	)
	print(
		"Posição final: ",
		spawned_unit.grid_position
	)
	
	await configure_spawned_scenario_unit(
		spawned_unit,
		event_data
	)
	
	center_camera_on_unit(
		spawned_unit
	)
	
	await get_tree().create_timer(
		1.0
	).timeout
	
	print("====================================")
	print("EVENTO CONCLUÍDO")
	print("Evento: ", event_id)
	print(
		"NPC criado: ",
		get_unit_display_name(
			spawned_unit
		)
	)
	print("====================================")
	
	
func add_npc_to_current_initiative(
	npc_unit: Node2D
) -> void:
	if not is_instance_valid(npc_unit):
		return
	
	if initiative_order.has(npc_unit):
		return
	
	# Eventos de chegada ocorrem na passagem de rodada.
	# O recém-chegado age antes da primeira unidade
	# da nova rodada.
	var insert_index: int = clampi(
		current_initiative_index,
		0,
		initiative_order.size()
	)
	
	initiative_order.insert(
		insert_index,
		npc_unit
	)
	
	print(
		get_unit_display_name(npc_unit),
		" entrou na iniciativa e será o próximo a agir."
	)
	
func move_npc_to(
	npc_unit: Node2D,
	new_grid_position: Vector2i
) -> bool:
	
	if not is_instance_valid(npc_unit):
		return false
	
	if npc_unit.hp <= 0:
		return false
	
	if not npc_unit.visible:
		return false
	
	if not is_inside_grid(new_grid_position):
		return false
	
	if new_grid_position == npc_unit.grid_position:
		return false
	
	if is_grid_position_blocked_for_path(
		new_grid_position,
		npc_unit
	):
		return false
	
	var old_position: Vector2i = npc_unit.grid_position
	
	var allowed_movement: float = min(
		3.0,
		npc_unit.current_movement_meters
	)
	
	var path: Array[Vector2i] = get_grid_path_avoiding_units(
		old_position,
		new_grid_position,
		npc_unit,
		allowed_movement,
		false
	)
	
	if path.is_empty():
		return false
	
	var movement_cost: float = get_path_total_cost(
		old_position,
		path
	)
	
	if movement_cost > allowed_movement:
		return false
	
	npc_unit.current_movement_meters -= movement_cost
	
	if npc_unit.current_movement_meters < 0.0:
		npc_unit.current_movement_meters = 0.0
	
	show_path_preview(path)
	
	await animate_unit_movement(
		npc_unit,
		path
	)
	
	if not is_instance_valid(npc_unit):
		return false
	
	if npc_unit.hp <= 0:
		return false
	
	npc_unit.grid_position = new_grid_position
	npc_unit.position = grid_to_world_position(
		new_grid_position
	)
	
	return true
	

func npc_ai_attack_target(
	npc_unit: Node2D,
	target_unit: Node2D
) -> void:
	if not is_instance_valid(
		npc_unit
	):
		return
	
	if not is_instance_valid(
		target_unit
	):
		return
	
	if npc_unit.hp <= 0:
		return
	
	if target_unit.hp <= 0:
		return
	
	var attack_range: float = 1.5
	
	if npc_unit.has_method(
		"get_weapon_range_meters"
	):
		attack_range = float(
			npc_unit.get_weapon_range_meters()
		)
	
	var distance_to_target: float = (
		get_distance_in_meters(
			npc_unit.grid_position,
			target_unit.grid_position
		)
	)
	
	if distance_to_target > attack_range:
		return
	
	var attack_bonus: int = (
		get_npc_attack_bonus(
			npc_unit
		)
	)
	
	attack_bonus += (
		get_high_ground_attack_bonus_for_unit(
			npc_unit
		)
	)
	
	var target_ac: int = 10
	
	if target_unit.has_method(
		"get_armor_class"
	):
		target_ac = int(
			target_unit.get_armor_class()
		)
	
	var attack_result: Dictionary = (
		roll_attack_result(
			attack_bonus,
			target_ac,
			npc_unit,
			target_unit
		)
	)
	
	var dice_roll: int = int(
		attack_result.get(
			"dice_roll",
			1
		)
	)
	
	var attack_total: int = int(
		attack_result.get(
			"attack_total",
			dice_roll + attack_bonus
		)
	)
	
	var attack_hit: bool = bool(
		attack_result.get(
			"hit",
			false
		)
	)
	
	var critical_hit: bool = bool(
		attack_result.get(
			"critical_hit",
			false
		)
	)
	
	print("====================================")
	print("ATAQUE DO GUARDA")
	print(
		"Atacante: ",
		get_unit_display_name(
			npc_unit
		)
	)
	print(
		"Alvo: ",
		get_unit_display_name(
			target_unit
		)
	)
	print("d20: ", dice_roll)
	print("Bônus: ", attack_bonus)
	print("Total: ", attack_total)
	print("CA: ", target_ac)
	print("====================================")
	
	if attack_hit:
		var damage: int = (
			get_npc_attack_damage(
				npc_unit
			)
		)
		if npc_unit.race == "Halfling" and is_target_flanked_by_ally(target_unit, npc_unit):
			damage += 1
		
		if critical_hit:
			damage *= 2
			
			show_floating_text_on_unit(
				target_unit,
				"CRÍTICO!",
				30,
				"critical"
			)
		
		apply_attack_damage_to_unit(
			target_unit,
			damage,
			critical_hit
		)
	else:
		show_floating_text_on_unit(
			target_unit,
			"ERROU",
			26,
			"miss"
		)
	
	npc_unit.has_attacked = true
	
	await process_defeated_enemy_rewards()
	remove_defeated_enemies_from_initiative()
	refresh_current_enemy_after_death()
	refresh_combat_ui_after_attack(
		true,
		false
	)
	
	await check_battle_result()

func npc_ai_turn(
	npc_unit: Node2D
) -> void:
	if not is_instance_valid(
		npc_unit
	):
		return
	
	if npc_unit.hp <= 0:
		return
	
	if not npc_unit.visible:
		return
	
	if npc_unit.has_method(
		"reset_movement"
	):
		npc_unit.reset_movement()
	
	center_camera_on_unit(
		npc_unit
	)
	
	await wait_before_action()
	
	var action: Dictionary = (
		NpcAI.decide_action(
			npc_unit,
			self
		)
	)
	
	var action_type: String = str(
		action.get(
			"type",
			"wait"
		)
	)
	
	var action_reason: String = str(
		action.get(
			"reason",
			""
		)
	)
	
	print("====================================")
	print("TURNO DO NPC IA")
	print(
		"NPC: ",
		get_unit_display_name(
			npc_unit
		)
	)
	print("Ação: ", action_type)
	print("Motivo: ", action_reason)
	print("====================================")
	
	match action_type:
		"move":
			var target_position: Vector2i = (
				action.get(
					"position",
					npc_unit.grid_position
				)
			)
			
			await move_npc_to(
				npc_unit,
				target_position
			)
		
		"attack":
			var target_unit: Node2D = (
				action.get(
					"target",
					null
				)
			)
			
			if is_instance_valid(
				target_unit
			):
				await npc_ai_attack_target(
					npc_unit,
					target_unit
				)
		
		"wait":
			print(
				get_unit_display_name(
					npc_unit
				),
				" aguardou."
			)
		
		_:
			print(
				"Ação de NPC desconhecida: ",
				action_type
			)
	
	await get_tree().create_timer(
		0.25
	).timeout

func move_player_npc(
	npc_unit: Node2D,
	new_grid_position: Vector2i
):
	if not is_instance_valid(npc_unit):
		return
	
	if not is_npc_unit(npc_unit):
		return
	
	if str(npc_unit.control_type) != "player":
		return
	
	await move_player_unit(
		npc_unit,
		new_grid_position
	)

func get_npc_attack_bonus(npc_unit: Node2D) -> int:
	if not is_instance_valid(npc_unit):
		return 0
	
	if npc_unit.has_method("get_total_attack_bonus"):
		return int(npc_unit.get_total_attack_bonus())
	
	return 0
func get_npc_attack_damage(npc_unit: Node2D) -> int:
	if not is_instance_valid(npc_unit):
		return 0
	
	if npc_unit.has_method("roll_total_weapon_damage"):
		return int(npc_unit.roll_total_weapon_damage())
	
	return 1


func move_selected_player_unit(destination: Vector2i):
	if not initiative_started:
		return
	
	if battle_finished:
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	
	var acting_unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(acting_unit):
		print("Nenhuma unidade ativa para mover.")
		return
	
	if acting_unit.hp <= 0:
		return
	
	if not acting_unit.visible:
		return
	
	selected_player_unit = acting_unit
	refresh_selected_unit_ui()
	
	if acting_unit == hero:
		await move_hero(destination)
		return
	
	if is_instance_valid(animal_companion):
		if acting_unit == animal_companion:
			await move_animal_companion(destination)
			return
	
	if is_npc_unit(acting_unit):
		if str(acting_unit.control_type) != "player":
			return
		
		await move_player_npc(
			acting_unit,
			destination
		)
		
		return
	
	print(
		"Tipo de unidade sem movimento configurado: ",
		get_unit_display_name(acting_unit)
	)
		
func attack_selected_player_unit():
	var acting_unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(acting_unit):
		return

	if prepared_class_attack == "flurry" and prepared_class_attacker == acting_unit:
		await perform_flurry_attack(acting_unit)
		return
	
	if acting_unit == hero:
		await hero_attack()
		return
	
	if acting_unit == animal_companion:
		await animal_companion_attack()
		return
	
	if is_player_controlled_npc(acting_unit):
		await npc_controlled_attack(acting_unit)
	
func npc_controlled_attack(
	npc_unit: Node2D
) -> void:
	enemy = prepare_player_attack_target(
		npc_unit,
		enemy
	)
	
	if not is_instance_valid(enemy):
		return

	if npc_unit.character_class == "Ladino" and npc_unit.is_hidden:
		check_hidden_rogue_perception(npc_unit)

	var using_smite: bool = (
		prepared_class_attack == "smite"
		and prepared_class_attacker == npc_unit
		and npc_unit.character_class == "Paladino"
	)
	
	var attack_bonus: int = (
		get_npc_attack_bonus(
			npc_unit
		)
	)
	
	attack_bonus += (
		get_high_ground_attack_bonus_for_unit(
			npc_unit
		)
	)

	if using_smite:
		attack_bonus += floori((float(npc_unit.charisma) - 10.0) / 2.0)
	
	var target_ac: int = 10
	
	if enemy.has_method(
		"get_armor_class"
	):
		target_ac = int(
			enemy.get_armor_class()
		)
	
	var attack_result: Dictionary = (
		roll_attack_result(
			attack_bonus,
			target_ac,
			npc_unit,
			enemy
		)
	)
	
	var dice_roll: int = int(
		attack_result["dice_roll"]
	)
	
	var attack_total: int = int(
		attack_result["attack_total"]
	)
	
	var hit: bool = bool(
		attack_result["hit"]
	)
	
	var critical_hit: bool = bool(
		attack_result["critical_hit"]
	)
	
	print("====================================")
	print("ATAQUE DO NPC")
	print(
		"Atacante: ",
		get_unit_display_name(
			npc_unit
		)
	)
	print(
		"Alvo: ",
		get_unit_display_name(enemy)
	)
	print("d20: ", dice_roll)
	print("Bônus: ", attack_bonus)
	print("Total: ", attack_total)
	print("CA: ", target_ac)
	print("====================================")
	
	if hit:
		var damage: int = (
			get_npc_attack_damage(
				npc_unit
			)
		)
		if npc_unit.race == "Halfling" and is_target_flanked_by_ally(enemy, npc_unit):
			damage += 1

		if using_smite:
			damage += npc_unit.level

		if npc_unit.character_class == "Ladino" and npc_unit.is_hidden:
			var sneak_damage: int = npc_unit.get_sneak_attack_damage()
			damage += sneak_damage
			show_floating_text_on_unit(enemy, "FURTIVO +%d" % sneak_damage, 22, "critical")
		
		if critical_hit:
			damage *= 2
			
			show_floating_text_on_unit(
				enemy,
				"CRÍTICO!",
				30,
				"critical"
			)
		
		damage = apply_attack_damage_to_unit(
			enemy,
			damage,
			critical_hit
		)
		
		print("NPC acertou.")
		print("Dano final: ", damage)
	else:
		show_floating_text_on_unit(
			enemy,
			"ERROU",
			26,
			"miss"
		)

	if npc_unit.character_class == "Ladino":
		npc_unit.reveal_after_attack()

	if using_smite:
		npc_unit.consume_smite_evil()
		clear_prepared_class_attack()
	
	await finish_player_attack(
		npc_unit
	)

func refresh_selected_unit_ui():
	var inspected_unit: Node2D = get_inspected_unit()
	
	if not is_instance_valid(inspected_unit):
		return
	
	update_character_sheet_panel()

func get_acting_unit() -> Node2D:
	if is_instance_valid(current_active_unit):
		return current_active_unit
	
	return null
func get_inspected_unit() -> Node2D:
	if is_instance_valid(selected_player_unit):
		return selected_player_unit
	
	if is_instance_valid(current_active_unit):
		return current_active_unit
	
	if is_instance_valid(hero):
		return hero
	
	return null
func refresh_action_ui():
	update_movement_label()
	update_class_skill_button()
	update_active_effects_panel()
func begin_player_controlled_turn(unit: Node2D):
	clear_prepared_class_attack()
	# =====================================================
	# VALIDAÇÃO DA UNIDADE
	# =====================================================
	if not is_instance_valid(unit):
		advance_initiative_turn()
		return
	
	if unit.hp <= 0:
		advance_initiative_turn()
		return
	
	if not unit.visible:
		advance_initiative_turn()
		return
	
	# =====================================================
	# VALIDAÇÃO DE NPC CONTROLÁVEL
	# =====================================================
	if is_npc_unit(unit):
		if str(unit.control_type) != "player":
			print(
				"NPC não controlado pelo jogador: ",
				get_unit_display_name(unit)
			)
			
			advance_initiative_turn()
			return
	
	# =====================================================
	# DEFINE TURNO E SELEÇÃO
	# =====================================================
	current_turn = TurnState.HERO_TURN
	current_active_unit = unit
	selected_player_unit = unit
	
	print(
		"Turno da unidade controlável: ",
		get_unit_display_name(unit)
	)
	
	# =====================================================
	# RESET DA UNIDADE
	# =====================================================
	if unit.has_method("reset_movement"):
		unit.reset_movement()
	else:
		if "current_movement_meters" in unit:
			if "max_movement_meters" in unit:
				unit.current_movement_meters = (
					unit.max_movement_meters
				)
		
		if "has_attacked" in unit:
			unit.has_attacked = false
		
		if "has_opportunity_attacked" in unit:
			unit.has_opportunity_attacked = false
	
	# =====================================================
	# INTERFACE E CÂMERA
	# =====================================================
	refresh_selected_unit_ui()
	refresh_action_ui()
	center_camera_on_unit(unit)
	
	await wait_before_action()
	
	if not is_instance_valid(unit):
		advance_initiative_turn()
		return
	
	if unit.hp <= 0:
		advance_initiative_turn()
		return
	
	# =====================================================
	# ÁREAS DE AÇÃO
	# =====================================================
	clear_movement_area()
	clear_attack_area()
	
	show_movement_area()
	show_attack_area_for_unit(unit)
	
	refresh_action_ui()
	if current_stage == 1 and not stage_one_tutorial_skipped:
		if unit == hero:
			if stage_one_tutorial_pending and not stage_one_tutorial_shown:
				stage_one_tutorial_pending = false
				begin_stage_one_guided_tutorial()
			elif stage_one_tutorial_phase in ["movement", "approach", "attack"]:
				if stage_one_tutorial_phase == "attack":
					stage_one_tutorial_phase = "approach"
				if has_enemy_within_weapon_range(hero, float(hero.get_weapon_range_meters())):
					maybe_show_stage_one_attack_tutorial()
				else:
					show_stage_one_guided_step(
						"approach", "Aproxime-se para atacar",
						"Toque em uma casa azul para chegar ao alcance de um inimigo. Se não houver movimento suficiente neste turno, termine-o e tente novamente quando seu herói agir.",
						"movement_area"
					)
			elif stage_one_tutorial_phase in ["magic_wait", "magic_menu"]:
				show_stage_one_magic_tutorial()
		else:
			show_stage_one_ally_tutorial(unit)
	
	print(
		get_unit_display_name(unit),
		" pronto para agir. Movimento: ",
		unit.current_movement_meters,
		"/",
		unit.max_movement_meters
	)
func end_active_unit_turn() -> void:
	if not initiative_started:
		print(
			"Role a iniciativa antes de terminar o turno."
		)
		return
	
	if battle_finished:
		return
	
	if current_turn != TurnState.HERO_TURN:
		return
	
	var unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(unit):
		print(
			"Nenhuma unidade ativa para encerrar o turno."
		)
		return
	
	if is_npc_unit(unit):
		if str(unit.control_type) != "player":
			return

	clear_prepared_class_attack()
	
	print(
		"Encerrando turno de: ",
		get_unit_display_name(unit)
	)
	
	if unit == hero:
		if unit.has_method("update_rage_turn"):
			unit.update_rage_turn(
				battle_turn_count
			)
	
	if unit.has_method(
		"update_temporary_effects_turn"
	):
		unit.update_temporary_effects_turn(
			battle_turn_count
		)
	if unit.has_method("finish_unstoppable_turn"):
		unit.finish_unstoppable_turn()
	
	clear_movement_area()
	clear_attack_area()
	clear_spell_target_area()
	
	waiting_spell_target = false
	pending_spell_name = ""
	pending_spell_data = {}
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_cancel_spell_visible(
			false
		)
	
	current_active_unit = null
	
	refresh_action_ui()
	advance_initiative_turn()

func move_player_unit(
	unit: Node2D,
	destination: Vector2i
) -> bool:
	if opportunity_warning_open:
		return false
	if not can_player_unit_move_to(
		unit,
		destination
	):
		return false
	
	var start_position: Vector2i = (
		unit.grid_position
	)
	
	var available_movement: float = float(
		unit.current_movement_meters
	)
	
	var path: Array[Vector2i] = (
		get_grid_path_avoiding_units(
			start_position,
			destination,
			unit,
			available_movement,
			true
		)
	)
	
	if path.is_empty():
		print(
			get_unit_display_name(unit),
			" não encontrou caminho válido."
		)
		
		show_floating_text_on_unit(
			unit,
			"SEM CAMINHO",
			20,
			"miss"
		)
		
		show_movement_area()
		show_attack_area_for_unit(unit)
		return false
	
	var movement_cost: float = get_path_total_cost(
		start_position,
		path
	)
	
	if movement_cost > available_movement:
		print(
			"Movimento insuficiente. Custo: ",
			movement_cost,
			"m | Disponível: ",
			available_movement,
			"m"
		)
		
		show_floating_text_on_unit(
			unit,
			"SEM MOVIMENTO",
			20,
			"miss"
		)
		
		show_movement_area()
		show_attack_area_for_unit(unit)
		return false
	var threatening_enemies: Array[Node2D] = get_opportunity_attackers_for_move(unit, destination)
	if not threatening_enemies.is_empty():
		var threat_names: Array[String] = []
		for attacker in threatening_enemies:
			threat_names.append(get_unit_display_name(attacker))
		opportunity_warning_open = true
		var decision: String = await show_story_choice(
			"ATAQUE DE OPORTUNIDADE!\nAo sair do alcance de %s, você pode sofrer um golpe de cada inimigo ANTES de andar e perder PV." % ", ".join(threat_names),
			[
				{"id": "move", "button_text": "Mover e aceitar o risco"},
				{"id": "cancel", "button_text": "Ficar onde estou"}
			]
		)
		opportunity_warning_open = false
		if decision != "move" or not is_instance_valid(unit) or battle_finished:
			return false
	if not process_player_move_opportunity_attacks(unit, destination):
		return false
	
	unit.current_movement_meters -= movement_cost
	
	unit.current_movement_meters = max(
		0.0,
		float(unit.current_movement_meters)
	)
	
	clear_movement_area()
	clear_attack_area()
	show_path_preview(path)
	
	await get_tree().create_timer(0.12).timeout
	await animate_unit_movement(unit, path)
	
	if should_cancel_player_movement(unit):
		clear_path_preview_tiles()
		return false
	
	unit.grid_position = destination
	unit.position = grid_to_world_position(
		destination
	)
	
	apply_active_spell_area_to_unit(unit)
	process_scenario_interaction_for_unit(unit)
	
	if should_cancel_player_movement(unit):
		return false
	
	show_movement_area()
	show_attack_area_for_unit(unit)
	
	refresh_action_ui()
	refresh_selected_unit_ui()
	on_stage_one_player_moved(unit)
	
	return true

func refresh_combat_ui_after_attack(
	refresh_enemy_health: bool = false,
	refresh_class_skill: bool = false
):
	if refresh_enemy_health:
		update_enemy_hp_bar()
	
	update_movement_label()
	
	if refresh_class_skill:
		update_class_skill_button()
	
	update_character_sheet_panel()
	check_battle_result()
func prepare_player_attack_target(
	attacker: Node2D,
	preferred_target: Node2D = null
) -> Node2D:
	if not initiative_started:
		print("Role a iniciativa antes de atacar.")
		return null
	
	if current_turn != TurnState.HERO_TURN:
		return null
	
	if battle_finished:
		return null
	
	if is_movement_animating:
		return null
	
	if not is_instance_valid(attacker):
		return null
	
	if attacker.hp <= 0:
		return null
	
	if attacker.has_attacked:
		print(
			get_unit_display_name(attacker),
			" já atacou neste turno."
		)
		
		show_floating_text_on_unit(
			attacker,
			"ATAQUE USADO",
			22,
			"miss"
		)
		
		return null
	
	var target: Node2D = get_valid_attack_target_for_unit(
		attacker,
		preferred_target
	)
	
	if not is_instance_valid(target):
		print("Nenhum inimigo em alcance para atacar.")
		
		show_floating_text_on_unit(
			attacker,
			"SEM ALVO",
			22,
			"miss"
		)
		
		show_attack_area_for_unit(attacker)
		return null
	
	if target.hp <= 0:
		print("O inimigo selecionado já está derrotado.")
		refresh_current_enemy_after_death()
		show_attack_area_for_unit(attacker)
		return null
	
	if not target.visible:
		print("O inimigo selecionado não está visível.")
		refresh_current_enemy_after_death()
		show_attack_area_for_unit(attacker)
		return null
	
	var attack_range: float = 1.5
	
	if attacker.has_method("get_weapon_range_meters"):
		attack_range = float(
			attacker.get_weapon_range_meters()
		)
	
	var distance: float = get_distance_in_meters(
		attacker.grid_position,
		target.grid_position
	)
	
	if distance > attack_range:
		print("Inimigo fora de alcance.")
		print(
			"Distância: ",
			distance,
			"m | Alcance: ",
			attack_range,
			"m"
		)
		
		show_floating_text_on_unit(
			target,
			"FORA DE ALCANCE",
			20,
			"miss"
		)
		
		show_attack_area_for_unit(attacker)
		return null
	
	return target
func finish_player_attack(attacker: Node2D):
	if not is_instance_valid(attacker):
		return
	
	attacker.has_attacked = true
	
	await process_defeated_enemy_rewards()
	refresh_current_enemy_after_death()
	update_after_hero_attack()
	
	if is_instance_valid(attacker):
		show_attack_area_for_unit(attacker)
	
	update_active_effects_panel()
	on_stage_one_attack_completed(attacker)
func roll_attack_result(
	attack_bonus: int,
	target_ac: int,
	attacker_unit: Node2D,
	target_unit: Node2D
) -> Dictionary:
	if (
		is_instance_valid(attacker_unit)
		and is_instance_valid(target_unit)
		and attacker_unit.has_method("play_attack_animation")
	):
		attacker_unit.play_attack_animation(target_unit.position)
	if UIAudioManager != null:
		if UIAudioManager.has_method(
			"play_dice_roll"
		):
			UIAudioManager.play_dice_roll()
	
	var attack_result: Dictionary = (
		CombatAttackResolverScript.resolve_attack(
			attack_bonus,
			target_ac
		)
	)
	
	var dice_roll: int = int(
		attack_result.get(
			"dice_roll",
			1
		)
	)
	
	var attack_total: int = int(
		attack_result.get(
			"attack_total",
			dice_roll + attack_bonus
		)
	)
	
	var hit: bool = bool(
		attack_result.get(
			"hit",
			false
		)
	)
	
	var critical_hit: bool = bool(
		attack_result.get(
			"critical_hit",
			false
		)
	)
	if UIAudioManager != null and is_instance_valid(attacker_unit):
		var weapon_name: String = ""
		var weapon_type: String = "melee"
		if "equipped_weapon" in attacker_unit:
			weapon_name = str(attacker_unit.equipped_weapon)
		if attacker_unit.has_method("get_weapon_type"):
			weapon_type = str(attacker_unit.get_weapon_type())
		elif "weapon_type" in attacker_unit:
			weapon_type = str(attacker_unit.weapon_type)
		UIAudioManager.play_attack_result(hit, weapon_name, weapon_type)
	
	var attacker_name: String = ""
	var target_name: String = ""
	
	if is_instance_valid(attacker_unit):
		attacker_name = get_unit_display_name(
			attacker_unit
		)
	
	if is_instance_valid(target_unit):
		target_name = get_unit_display_name(
			target_unit
		)
	
	if (
		GameState.show_attack_roll_box
		and is_instance_valid(
			attack_roll_box
		)
	):
		attack_roll_box.call(
			"show_roll",
			dice_roll,
			attack_bonus,
			attack_total,
			target_ac,
			hit,
			critical_hit,
			attacker_name,
			target_name
		)
	
	attack_result["attacker_name"] = (
		attacker_name
	)
	attack_result["target_name"] = target_name
	
	return attack_result

func get_unit_class_name(unit: Node2D) -> String:
	if not is_instance_valid(unit):
		return ""
	
	if unit == hero:
		return str(hero.character_class)
	
	if is_npc_unit(unit):
		if "character_class" in unit:
			return str(unit.character_class)
	
	return ""
func apply_enemy_healing_action(
	heal_amount: int,
	action_title: String,
	uses_label: String,
	remaining_uses: int
):
	if not is_instance_valid(enemy):
		return
	
	var restored_hp: int = apply_healing_to_unit(
		enemy,
		heal_amount,
		28,
		0.16,
		0.28,
		0.22
	)
	
	enemy.has_attacked = true
	
	print("====================================")
	print(action_title)
	print("Cura: ", restored_hp)
	print(uses_label, ": ", remaining_uses)
	print("HP atual: ", enemy.hp, "/", enemy.max_hp)
	print("====================================")
	
	refresh_combat_ui_after_attack()
	update_active_effects_panel()

func apply_healing_to_unit(
	unit: Node2D,
	heal_amount: int,
	font_size: int = 28,
	pulse_strength: float = 0.16,
	pulse_duration: float = 0.28,
	flash_duration: float = 0.22
) -> int:
	if not is_instance_valid(unit):
		return 0
	
	if not "hp" in unit:
		return 0
	
	if not "max_hp" in unit:
		return 0
	
	if unit.hp <= 0:
		return 0
	
	var previous_hp: int = int(unit.hp)
	var safe_heal_amount: int = max(
		heal_amount,
		1
	)
	
	unit.hp = min(
		int(unit.hp) + safe_heal_amount,
		int(unit.max_hp)
	)
	
	var restored_hp: int = (
		int(unit.hp) - previous_hp
	)
	
	show_floating_text_on_unit(
		unit,
		"+" + str(restored_hp),
		font_size,
		"heal"
	)
	
	pulse_unit(
		unit,
		pulse_strength,
		pulse_duration
	)
	
	flash_unit(
		unit,
		Color(
			0.25,
			1.0,
			0.35,
			1.0
		),
		flash_duration
	)
	
	if unit.has_method(
		"update_health_display"
	):
		unit.update_health_display()
	elif unit.has_method(
		"update_health_bar"
	):
		unit.update_health_bar()
	
	return restored_hp

func apply_damage_to_unit(
	unit: Node2D,
	damage_amount: int,
	font_size: int = 28,
	shake_strength: float = 7.0,
	shake_duration: float = 0.24,
	flash_color: Color = Color(
		1.0,
		0.25,
		0.25,
		1.0
	),
	flash_duration: float = 0.20
) -> int:
	if not is_instance_valid(unit):
		return 0
	
	var safe_damage: int = max(
		damage_amount,
		1
	)
	
	show_floating_text_on_unit(
		unit,
		"-" + str(safe_damage),
		font_size,
		"damage"
	)
	
	shake_unit(
		unit,
		shake_strength,
		shake_duration
	)
	
	flash_unit(
		unit,
		flash_color,
		flash_duration
	)
	
	var was_unstoppable: bool = false
	if unit.has_method("finish_unstoppable_turn"):
		was_unstoppable = bool(unit.get("unstoppable_active"))
	if unit.has_method("take_damage"):
		unit.take_damage(safe_damage)
	if is_instance_valid(unit) and unit.has_method("finish_unstoppable_turn"):
		if not was_unstoppable and bool(unit.get("unstoppable_active")):
			show_floating_text_on_unit(unit, "IMPARÁVEL!", 24, "buff")
			update_active_effects_panel()
	
	return safe_damage
func apply_attack_damage_to_unit(
	target_unit: Node2D,
	damage_amount: int,
	critical_hit: bool
) -> int:
	var applied_damage: int = 0
	
	if critical_hit:
		applied_damage = apply_damage_to_unit(
			target_unit,
			damage_amount,
			28,
			12.0,
			0.30,
			Color(1.0, 0.85, 0.1, 1.0),
			0.22
		)
	else:
		applied_damage = apply_damage_to_unit(
			target_unit,
			damage_amount,
			28,
			6.0,
			0.22,
			Color(1.0, 0.25, 0.25, 1.0),
			0.18
		)
	
	if (
		GameState.show_attack_roll_box
		and is_instance_valid(attack_roll_box)
		and attack_roll_box.has_method("show_damage")
	):
		attack_roll_box.call(
			"show_damage",
			applied_damage
		)
	
	return applied_damage

func load_saved_player_presets_into_game_state() -> void:
	if not GameState.should_load_save:
		return
	
	if loaded_player_presets.is_empty():
		return
	
	GameState.player_name = str(
		loaded_player_presets.get(
			"player_name",
			GameState.player_name
		)
	)
	
	GameState.player_class = str(
		loaded_player_presets.get(
			"player_class",
			GameState.player_class
		)
	)
	
	GameState.player_race = str(
		loaded_player_presets.get(
			"player_race",
			GameState.player_race
		)
	)
	
	# =====================================================
	# PROGRESSÃO
	# =====================================================
	GameState.hero_level = int(
		loaded_player_presets.get(
			"hero_level",
			GameState.hero_level
		)
	)
	
	GameState.hero_total_xp = int(
		loaded_player_presets.get(
			"hero_total_xp",
			GameState.hero_total_xp
		)
	)
	
	GameState.hero_xp_to_next_level = int(
		loaded_player_presets.get(
			"hero_xp_to_next_level",
			GameState.hero_xp_to_next_level
		)
	)
	
	GameState.hero_max_level = int(
		loaded_player_presets.get(
			"hero_max_level",
			GameState.hero_max_level
		)
	)
	
	# =====================================================
	# RECURSOS PRINCIPAIS
	# =====================================================
	GameState.hero_max_hp = int(
		loaded_player_presets.get(
			"hero_max_hp",
			GameState.hero_max_hp
		)
	)
	
	GameState.hero_attack_power = int(
		loaded_player_presets.get(
			"hero_attack_power",
			GameState.hero_attack_power
		)
	)
	
	GameState.hero_max_movement_meters = float(
		loaded_player_presets.get(
			"hero_max_movement_meters",
			GameState.hero_max_movement_meters
		)
	)
	
	# =====================================================
	# ATRIBUTOS
	# =====================================================
	GameState.hero_strength = int(
		loaded_player_presets.get(
			"hero_strength",
			GameState.hero_strength
		)
	)
	
	GameState.hero_dexterity = int(
		loaded_player_presets.get(
			"hero_dexterity",
			GameState.hero_dexterity
		)
	)
	
	GameState.hero_constitution = int(
		loaded_player_presets.get(
			"hero_constitution",
			GameState.hero_constitution
		)
	)
	
	GameState.hero_wisdom = int(
		loaded_player_presets.get(
			"hero_wisdom",
			GameState.hero_wisdom
		)
	)
	
	GameState.hero_intelligence = int(
		loaded_player_presets.get(
			"hero_intelligence",
			GameState.hero_intelligence
		)
	)
	
	GameState.hero_charisma = int(
		loaded_player_presets.get(
			"hero_charisma",
			GameState.hero_charisma
		)
	)
	
	# =====================================================
	# RAÇA
	# =====================================================
	GameState.hero_size = str(
		loaded_player_presets.get(
			"hero_size",
			GameState.hero_size
		)
	)
	
	GameState.hero_size_modifier = int(
		loaded_player_presets.get(
			"hero_size_modifier",
			GameState.hero_size_modifier
		)
	)
	
	GameState.hero_favored_class = str(
		loaded_player_presets.get(
			"hero_favored_class",
			GameState.hero_favored_class
		)
	)
	
	GameState.hero_race_traits = (
		loaded_player_presets.get(
			"hero_race_traits",
			GameState.hero_race_traits
		)
	).duplicate(true)
	
	# =====================================================
	# CLASSE
	# =====================================================
	GameState.hero_class_hit_die = int(
		loaded_player_presets.get(
			"hero_class_hit_die",
			GameState.hero_class_hit_die
		)
	)
	
	GameState.hero_hp_fixed_per_level = int(
		loaded_player_presets.get(
			"hero_hp_fixed_per_level",
			GameState.hero_hp_fixed_per_level
		)
	)
	
	GameState.hero_hp_progression_mode = str(
		loaded_player_presets.get(
			"hero_hp_progression_mode",
			GameState.hero_hp_progression_mode
		)
	)
	
	GameState.hero_base_attack_bonus_type = str(
		loaded_player_presets.get(
			"hero_base_attack_bonus_type",
			GameState.hero_base_attack_bonus_type
		)
	)
	
	GameState.hero_fortitude_type = str(
		loaded_player_presets.get(
			"hero_fortitude_type",
			GameState.hero_fortitude_type
		)
	)
	
	GameState.hero_reflex_type = str(
		loaded_player_presets.get(
			"hero_reflex_type",
			GameState.hero_reflex_type
		)
	)
	
	GameState.hero_will_type = str(
		loaded_player_presets.get(
			"hero_will_type",
			GameState.hero_will_type
		)
	)
	
	GameState.hero_fortitude_base_bonus = int(
		loaded_player_presets.get(
			"hero_fortitude_base_bonus",
			GameState.hero_fortitude_base_bonus
		)
	)
	
	GameState.hero_reflex_base_bonus = int(
		loaded_player_presets.get(
			"hero_reflex_base_bonus",
			GameState.hero_reflex_base_bonus
		)
	)
	
	GameState.hero_will_base_bonus = int(
		loaded_player_presets.get(
			"hero_will_base_bonus",
			GameState.hero_will_base_bonus
		)
	)
	
	GameState.hero_class_movement_bonus = float(
		loaded_player_presets.get(
			"hero_class_movement_bonus",
			GameState.hero_class_movement_bonus
		)
	)
	
	GameState.hero_damage_reduction = int(
		loaded_player_presets.get(
			"hero_damage_reduction",
			GameState.hero_damage_reduction
		)
	)
	
	GameState.hero_class_features = (
		loaded_player_presets.get(
			"hero_class_features",
			GameState.hero_class_features
		)
	).duplicate(true)
	
	# =====================================================
	# TALENTOS
	# =====================================================
	GameState.hero_feats = (
		loaded_player_presets.get(
			"hero_feats",
			GameState.hero_feats
		)
	).duplicate(true)
	
	# =====================================================
	# EQUIPAMENTO E OURO
	# =====================================================
	GameState.hero_equipped_weapon = str(
		loaded_player_presets.get(
			"hero_equipped_weapon",
			GameState.hero_equipped_weapon
		)
	)
	
	GameState.hero_equipped_armor = str(
		loaded_player_presets.get(
			"hero_equipped_armor",
			GameState.hero_equipped_armor
		)
	)
	
	GameState.hero_equipped_shield = str(
		loaded_player_presets.get(
			"hero_equipped_shield",
			GameState.hero_equipped_shield
		)
	)
	
	GameState.hero_gold = int(
		loaded_player_presets.get(
			"hero_gold",
			GameState.hero_gold
		)
	)
	
	GameState.hero_animal_companion_type = str(
		loaded_player_presets.get(
			"hero_animal_companion_type",
			GameState.hero_animal_companion_type
		)
	)
func configure_hero_from_game_state() -> void:
	if not is_instance_valid(hero):
		return
	
	load_hero_spell_state_from_presets()
	
	hero.character_name = GameState.player_name
	hero.character_class = GameState.player_class
	hero.character_race = GameState.player_race
	
	hero.level = GameState.hero_level
	hero.total_xp = GameState.hero_total_xp
	hero.xp_to_next_level = (
		GameState.hero_xp_to_next_level
	)
	hero.max_level = GameState.hero_max_level
	
	hero.strength = GameState.hero_strength
	hero.dexterity = GameState.hero_dexterity
	hero.constitution = (
		GameState.hero_constitution
	)
	hero.wisdom = GameState.hero_wisdom
	hero.intelligence = (
		GameState.hero_intelligence
	)
	hero.charisma = GameState.hero_charisma
	
	hero.character_size = GameState.hero_size
	hero.size_modifier = (
		GameState.hero_size_modifier
	)
	hero.favored_class = (
		GameState.hero_favored_class
	)
	hero.race_traits = (
		GameState.hero_race_traits.duplicate(true)
	)
	
	hero.class_hit_die = (
		GameState.hero_class_hit_die
	)
	hero.hp_fixed_per_level = (
		GameState.hero_hp_fixed_per_level
	)
	hero.hp_progression_mode = (
		GameState.hero_hp_progression_mode
	)
	
	hero.base_attack_bonus_type = (
		GameState.hero_base_attack_bonus_type
	)
	hero.fortitude_type = (
		GameState.hero_fortitude_type
	)
	hero.reflex_type = (
		GameState.hero_reflex_type
	)
	hero.will_type = (
		GameState.hero_will_type
	)
	
	hero.fortitude_base_bonus = (
		GameState.hero_fortitude_base_bonus
	)
	hero.reflex_base_bonus = (
		GameState.hero_reflex_base_bonus
	)
	hero.will_base_bonus = (
		GameState.hero_will_base_bonus
	)
	
	hero.class_movement_bonus = (
		GameState.hero_class_movement_bonus
	)
	hero.damage_reduction = (
		GameState.hero_damage_reduction
	)
	hero.class_features = (
		GameState.hero_class_features.duplicate(true)
	)
	
	hero.equipped_weapon = (
		GameState.hero_equipped_weapon
	)
	hero.equipped_armor = (
		GameState.hero_equipped_armor
	)
	hero.equipped_shield = (
		GameState.hero_equipped_shield
	)
	hero.gold = GameState.hero_gold
	
	if hero.has_method("setup_feats"):
		hero.setup_feats(
			GameState.hero_feats
		)
		if not GameState.should_load_save:
			hero.max_spell_slots_level_1 += int(hero.feat_extra_spell_slot_level_1)
			hero.spell_slots_level_1 += int(hero.feat_extra_spell_slot_level_1)
	
	# =====================================================
	# VIDA MÁXIMA
	# =====================================================
	hero.max_hp = max(
		1,
		GameState.hero_max_hp
	)
	
	if not GameState.should_load_save:
		hero.max_hp += int(
			hero.feat_max_hp_bonus
		)
		
		GameState.hero_max_hp = (
			hero.max_hp
		)
	
	hero.attack_power = (
		GameState.hero_attack_power
	)
	
	# =====================================================
	# MOVIMENTO MÁXIMO
	# =====================================================
	hero.max_movement_meters = maxf(
		0.0,
		GameState.hero_max_movement_meters
	)
	
	# Em personagem recém-criado, o GameState ainda contém
	# apenas movimento racial e movimento da classe.
	if not GameState.should_load_save:
		hero.max_movement_meters += float(
			hero.feat_movement_bonus
		)
		
		GameState.hero_max_movement_meters = (
			hero.max_movement_meters
		)
	
	hero.hp = hero.max_hp
	hero.current_movement_meters = (
		hero.max_movement_meters
	)
	hero.has_attacked = false
	hero.has_opportunity_attacked = false
	
	selected_companion_type = (
		GameState.hero_animal_companion_type
	)
	
	# =====================================================
	# MAGIAS
	# =====================================================
	var has_saved_spell_state: bool = (
		not GameState.hero_known_spells.is_empty()
	)
	
	if hero.has_method("setup_class_spells"):
		hero.setup_class_spells(
			GameState.hero_known_spells
		)
	
	if has_saved_spell_state:
		var saved_maximum_total: int = (
			GameState.hero_max_spell_slots_level_0
			+ GameState.hero_max_spell_slots_level_1
			+ GameState.hero_max_spell_slots_level_2
		)
		
		if saved_maximum_total > 0:
			hero.max_spell_slots_level_0 = max(
				0,
				GameState.hero_max_spell_slots_level_0
			)
			
			hero.max_spell_slots_level_1 = max(
				0,
				GameState.hero_max_spell_slots_level_1
			)
			
			hero.max_spell_slots_level_2 = max(
				0,
				GameState.hero_max_spell_slots_level_2
			)
		
		hero.spell_slots_level_0 = clampi(
			GameState.hero_spell_slots_level_0,
			0,
			hero.max_spell_slots_level_0
		)
		
		hero.spell_slots_level_1 = clampi(
			GameState.hero_spell_slots_level_1,
			0,
			hero.max_spell_slots_level_1
		)
		
		hero.spell_slots_level_2 = clampi(
			GameState.hero_spell_slots_level_2,
			0,
			hero.max_spell_slots_level_2
		)
		
		# Saves antigos de magos não incluem o uso adicional da classe.
		if hero.character_class == "Mago":
			var class_slots: Dictionary = LevelUpManager.new().get_spell_slot_limits("Mago", hero.level)
			var expected_level_1: int = int(class_slots.get(1, 0)) + int(hero.feat_extra_spell_slot_level_1)
			var missing_level_1: int = maxi(0, expected_level_1 - hero.max_spell_slots_level_1)
			hero.max_spell_slots_level_1 += missing_level_1
			hero.spell_slots_level_1 += missing_level_1
			var expected_level_2: int = int(class_slots.get(2, 0))
			var missing_level_2: int = maxi(0, expected_level_2 - hero.max_spell_slots_level_2)
			hero.max_spell_slots_level_2 += missing_level_2
			hero.spell_slots_level_2 += missing_level_2
	
	if hero.has_method(
		"get_pending_level_up_count"
	):
		hero.get_pending_level_up_count()
	
	hero.update_health_bar()

func print_applied_hero_preset():
	if not is_instance_valid(hero):
		return
	
	print("Preset aplicado no herói:")
	print("Nome: ", hero.character_name)
	print("Classe: ", hero.character_class)
	print("Raça: ", hero.character_race)
	print("Arma equipada: ", hero.equipped_weapon)
	print("Armadura equipada: ", hero.equipped_armor)
	print("Ouro: ", hero.gold)
	print("Talentos: ", hero.selected_feats)
	print("Magias após setup:")
	print(hero.known_spells)
	print("Slots nível 0: ", hero.spell_slots_level_0)
	print("Slots nível 1: ", hero.spell_slots_level_1)
	print("Slots nível 2: ", hero.spell_slots_level_2)
func is_current_enemy_unable_to_act() -> bool:
	if battle_finished:
		return true
	
	if not is_instance_valid(enemy):
		return true
	
	if not enemy.visible:
		return true
	
	if enemy.hp <= 0:
		return true
	
	return false
func execute_enemy_basic_action(
	ai_action: Dictionary,
	enemy_target: Node2D
) -> bool:
	var action_type: String = str(
		ai_action.get("type", "wait")
	)
	
	var action_reason: String = str(
		ai_action.get("reason", "none")
	)
	
	print("Ação escolhida pela IA: ", action_type)
	print("Motivo: ", action_reason)
	
	match action_type:
		"attack":
			await enemy_attack_target(enemy_target)
		
		"move":
			var move_position: Vector2i = (
				ai_action.get(
					"position",
					enemy.grid_position
				)
			)
			
			if move_position == enemy.grid_position:
				print(
					"IA mandou mover, mas a posição ",
					"é a mesma."
				)
				return false
			
			var moved: bool = await move_enemy_to(
				move_position
			)
			
			if moved:
				print(
					"Inimigo moveu para: ",
					enemy.grid_position
				)
			else:
				print(
					"Movimento do inimigo falhou."
				)
		
		"move_and_attack":
			var move_position: Vector2i = (
				ai_action.get(
					"position",
					enemy.grid_position
				)
			)
			
			if move_position != enemy.grid_position:
				var moved: bool = await move_enemy_to(
					move_position
				)
				
				if moved:
					print(
						"Inimigo moveu para atacar: ",
						enemy.grid_position
					)
				else:
					print(
						"Movimento para ataque falhou."
					)
			
			if is_current_enemy_unable_to_act():
				return true
			
			var refreshed_target: Node2D = (
				get_enemy_target_unit()
			)
			
			if is_instance_valid(refreshed_target):
				await enemy_attack_target(
					refreshed_target
				)
		
		"wait":
			print(
				"Inimigo aguardou. Motivo: ",
				action_reason
			)
		
		_:
			print(
				"Ação de IA desconhecida: ",
				action_type
			)
	
	return false
func can_player_unit_move_to(
	unit: Node2D,
	destination: Vector2i
) -> bool:
	if is_movement_animating:
		return false
	
	if not initiative_started:
		print("Role a iniciativa antes de mover.")
		return false
	
	if battle_finished:
		return false
	
	if current_turn != TurnState.HERO_TURN:
		return false
	
	if not is_instance_valid(unit):
		return false
	
	if unit != get_acting_unit():
		print(
			"Unidade tentou agir fora do próprio turno: ",
			get_unit_display_name(unit)
		)
		return false
	
	if unit.hp <= 0 or not unit.visible:
		return false
	
	if is_npc_unit(unit):
		if not is_player_controlled_npc(unit):
			return false
	
	if not ("current_movement_meters" in unit):
		return false
	
	if not ("grid_position" in unit):
		return false
	
	if not is_inside_grid(destination):
		return false
	
	if destination == unit.grid_position:
		return false
	
	var occupant: Node2D = get_unit_at_grid_position(
		destination
	)
	
	if is_instance_valid(occupant):
		if occupant != unit:
			print("Posição ocupada.")
			
			show_floating_text_on_unit(
				unit,
				"POSIÇÃO OCUPADA",
				20,
				"miss"
			)
			
			return false
	
	return true
func should_cancel_player_movement(
	unit: Node2D
) -> bool:
	if not is_instance_valid(unit):
		clear_movement_area()
		clear_attack_area()
		return true
	
	if unit.hp <= 0:
		clear_movement_area()
		clear_attack_area()
		check_battle_result()
		return true
	
	if battle_finished:
		clear_movement_area()
		clear_attack_area()
		return true
	
	return false
func process_player_move_opportunity_attacks(
	unit: Node2D,
	destination: Vector2i
) -> bool:
	for enemy_unit in enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		if not enemy_unit.visible:
			continue
		
		check_opportunity_attack(
			unit,
			enemy_unit,
			destination
		)
		
		if should_cancel_player_movement(unit):
			return false
	
	# Compatibilidade com o inimigo único antigo.
	if enemies.is_empty():
		if is_instance_valid(enemy):
			if enemy.hp > 0 and enemy.visible:
				check_opportunity_attack(
					unit,
					enemy,
					destination
				)
	
	if should_cancel_player_movement(unit):
		return false
	
	return true
func get_scenario_event_spawn_data(
	event_data: Dictionary
) -> Dictionary:
	var spawn_data: Dictionary = event_data.get(
		"spawn",
		{}
	)
	
	if spawn_data.is_empty():
		print("ERRO DO EVENTO: spawn está vazio.")
		return {}
	
	var spawn_id: String = str(
		spawn_data.get("id", "")
	)
	
	if spawn_id == "":
		print(
			"ERRO DO EVENTO: ID do spawn está vazio."
		)
		return {}
	
	return {
		"type": str(spawn_data.get("type", "")),
		"id": spawn_id,
		"position": spawn_data.get(
			"position",
			Vector2i.ZERO
		),
		"control_type": str(
			spawn_data.get("control_type", "")
		)
	}

func animate_scenario_event_unit_entry(
	unit: Node2D,
	final_position: Vector2i,
	entry_data: Dictionary
) -> void:
	if not is_instance_valid(unit):
		return
	
	var appearance_delay: float = float(
		entry_data.get(
			"appearance_delay",
			0.18
		)
	)
	
	var movement_duration: float = float(
		entry_data.get(
			"movement_duration",
			1.6
		)
	)
	
	var start_position: Vector2i = (
		entry_data.get(
			"start_position",
			Vector2i(
				current_grid_width,
				final_position.y
			)
		)
	)
	
	var default_map_entry_position := Vector2i(
		clampi(
			start_position.x,
			0,
			max(
				current_grid_width - 1,
				0
			)
		),
		clampi(
			start_position.y,
			0,
			max(
				current_grid_height - 1,
				0
			)
		)
	)
	
	var map_entry_position: Vector2i = (
		entry_data.get(
			"map_entry_position",
			default_map_entry_position
		)
	)
	
	# Mantém a unidade escondida fora do mapa.
	unit.grid_position = start_position
	unit.position = grid_to_world_position(
		start_position
	)
	unit.visible = false
	
	if appearance_delay > 0.0:
		await get_tree().create_timer(
			appearance_delay
		).timeout
	
	if not is_instance_valid(unit):
		return
	
	# A unidade somente aparece quando alcança
	# a primeira célula dentro do mapa.
	unit.grid_position = map_entry_position
	unit.position = grid_to_world_position(
		map_entry_position
	)
	unit.visible = true
	
	if unit.has_method(
		"update_health_display"
	):
		unit.update_health_display()
	
	var final_world_position: Vector2 = (
		grid_to_world_position(
			final_position
		)
	)
	
	if movement_duration <= 0.0:
		unit.grid_position = final_position
		unit.position = final_world_position
		return
	
	var movement_tween := create_tween()
	movement_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	movement_tween.set_trans(
		Tween.TRANS_SINE
	)
	
	movement_tween.set_ease(
		Tween.EASE_IN_OUT
	)
	
	movement_tween.tween_property(
		unit,
		"position",
		final_world_position,
		movement_duration
	)
	
	await movement_tween.finished
	
	if not is_instance_valid(unit):
		return
	
	unit.grid_position = final_position
	unit.position = final_world_position
	
	if unit.has_method(
		"update_health_display"
	):
		unit.update_health_display()

func focus_camera_on_grid_position(
	grid_position: Vector2i
):
	camera_follow_unit = null
	
	clear_movement_area()
	clear_attack_area()
	
	if is_instance_valid(game_camera):
		var previous_camera_process_mode: int = game_camera.process_mode
		game_camera.process_mode = Node.PROCESS_MODE_ALWAYS
		var target_position: Vector2 = (
			grid_to_world_position(grid_position)
		)
		
		var camera_tween := create_tween()
		camera_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		camera_tween.set_trans(Tween.TRANS_SINE)
		camera_tween.set_ease(Tween.EASE_IN_OUT)
		
		camera_tween.tween_property(
			game_camera,
			"global_position",
			target_position,
			0.65
		)
		
		await camera_tween.finished
		if is_instance_valid(game_camera):
			game_camera.process_mode = previous_camera_process_mode
	
	await get_tree().create_timer(0.4).timeout
func spawn_scenario_event_unit(
	spawn_data: Dictionary
) -> Node2D:
	var spawn_type: String = str(
		spawn_data.get("type", "")
	)
	
	var spawn_id: String = str(
		spawn_data.get("id", "")
	)
	
	var spawn_position: Vector2i = (
		spawn_data.get(
			"position",
			Vector2i.ZERO
		)
	)
	
	var control_type: String = str(
		spawn_data.get("control_type", "")
	)
	
	print("Tipo de spawn: ", spawn_type)
	print("ID do spawn: ", spawn_id)
	print("Posição: ", spawn_position)
	print("Controle: ", control_type)
	
	match spawn_type:
		"npc":
			print("Tentando criar NPC: ", spawn_id)
			
			return spawn_npc(
				spawn_id,
				spawn_position,
				spawn_id,
				control_type
			)
		
		_:
			print(
				"ERRO DO EVENTO: tipo de spawn ",
				"desconhecido: ",
				spawn_type
			)
			return null
func show_scenario_dialogue_entries(
	entries: Array,
	default_speaker: String = "Narrador",
	speaker_focus_unit: Node2D = null
) -> void:
	var player_name: String = get_victory_player_name()
	for entry_value in entries:
		if not entry_value is Dictionary:
			continue
		var entry: Dictionary = entry_value
		var speaker_name: String = str(entry.get(
			"speaker",
			entry.get("speaker_name", default_speaker)
		)).replace("[NOME_DO_JOGADOR]", player_name)
		var dialogue_text: String = str(entry.get(
			"text",
			""
		)).replace("[NOME_DO_JOGADOR]", player_name)
		if dialogue_text.strip_edges() == "":
			continue
		
		var focus_position: Vector2 = Vector2.ZERO
		var has_focus: bool = false
		if entry.has("camera_focus"):
			var focus_grid: Vector2i = entry.get("camera_focus", Vector2i.ZERO)
			focus_position = grid_to_world_position(focus_grid)
			has_focus = true
		elif is_instance_valid(speaker_focus_unit):
			if speaker_name == player_name and is_instance_valid(hero):
				focus_position = hero.global_position
				has_focus = true
			elif speaker_name == get_unit_display_name(speaker_focus_unit) or speaker_name == "Narrador":
				focus_position = speaker_focus_unit.global_position
				has_focus = true
		
		var previous_camera_process_mode: int = 0
		var camera_tween: Tween = null
		if has_focus and is_instance_valid(game_camera):
			var camera_distance: float = game_camera.global_position.distance_to(focus_position)
			if camera_distance > 24.0:
				previous_camera_process_mode = game_camera.process_mode
				game_camera.process_mode = Node.PROCESS_MODE_ALWAYS
				camera_follow_unit = null
				camera_tween = create_tween()
				camera_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
				camera_tween.set_trans(Tween.TRANS_SINE)
				camera_tween.set_ease(Tween.EASE_IN_OUT)
				camera_tween.tween_property(
					game_camera,
					"global_position",
					focus_position,
					clampf(camera_distance / 1200.0, 0.45, 1.1)
				)
		await show_story_dialog(speaker_name, dialogue_text)
		if is_instance_valid(camera_tween):
			if camera_tween.is_running():
				await camera_tween.finished
			if is_instance_valid(game_camera):
				game_camera.process_mode = previous_camera_process_mode

func configure_spawned_scenario_unit(
	spawned_unit: Node2D,
	event_data: Dictionary
) -> void:
	if not is_instance_valid(
		spawned_unit
	):
		return
	
	var message: String = str(
		event_data.get(
			"message",
			""
		)
	)
	
	if message != "":
		print(message)
		
		await show_story_dialog(
			"Narrador",
			message
		)
	
	var dialogue_entries: Array = (
		event_data.get(
			"dialogue",
			[]
		)
	)
	
	var dialogue_focus_unit: Node2D = null
	if str(event_data.get("id", "")) == "sr_uiliam_arrival":
		dialogue_focus_unit = spawned_unit
	await show_scenario_dialogue_entries(dialogue_entries, "Narrador", dialogue_focus_unit)
	
	# Mantém compatibilidade com NPCs antigos que
	# possuem somente uma fala de apresentação.
	if dialogue_entries.is_empty():
		var dialogue_intro: String = ""
		
		if "dialogue_intro" in spawned_unit:
			dialogue_intro = str(
				spawned_unit.dialogue_intro
			)
		
		if dialogue_intro != "":
			await show_story_dialog(
				get_unit_display_name(
					spawned_unit
				),
				dialogue_intro
			)
	
	var initiative_data: Dictionary = (
		event_data.get(
			"initiative",
			{}
		)
	)
	
	var add_to_current_battle: bool = bool(
		initiative_data.get(
			"add_to_current_battle",
			false
		)
	)
	
	if add_to_current_battle:
		add_npc_to_current_initiative(
			spawned_unit
		)
		
		print(
			get_unit_display_name(
				spawned_unit
			),
			" adicionado à iniciativa."
		)
	
	if (
		str(
			event_data.get(
				"id",
				""
			)
		) == "hashagur_arrival"
	):
		await show_story_dialog(
			"Narrador",
			"COMBATE RETOMADO"
		)

func create_story_dialog_popup():
	if is_instance_valid(story_dialog_popup):
		return
	
	story_dialog_popup = StoryDialogBox.new()
	ui_layer.add_child(story_dialog_popup)
	
	var continue_button: Button = (
		story_dialog_popup.get_ok_button()
	)
	
	if is_instance_valid(continue_button):
		apply_button_sfx(continue_button)

func set_gameplay_panels_visible(
	should_be_visible: bool
) -> void:
	if is_instance_valid(
		combat_character_sheet_controller
	):
		combat_character_sheet_controller.set_panel_visible(
			should_be_visible and sheet_requested_open
		)
	if is_instance_valid(battle_unit_hud_controller):
		battle_unit_hud_controller.set_panel_visible(should_be_visible)
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_panel_visible(
			should_be_visible
		)

func show_story_dialog(
	speaker_name: String,
	dialogue_text: String
) -> void:
	if dialogue_text.strip_edges() == "":
		return
	
	if not is_instance_valid(story_dialog_popup):
		create_story_dialog_popup()
	
	if not is_instance_valid(story_dialog_popup):
		return
	
	var character_sheet_was_visible: bool = false
	var action_panel_was_visible: bool = false
	
	if is_instance_valid(
		combat_character_sheet_controller
	):
		character_sheet_was_visible = (
			combat_character_sheet_controller
			.is_panel_visible()
		)
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		action_panel_was_visible = (
			combat_action_panel_controller
			.is_panel_visible()
		)
	
	set_gameplay_panels_visible(false)
	# Todas as falas neste mapa usam a caixa compacta de combate,
	# inclusive introdução e diálogos ao derrotar o último inimigo.
	story_dialog_popup.set_cinematic_mode(false)
	var participants: Array[String] = active_cinematic_cast.duplicate()
	if participants.is_empty():
		participants.append(speaker_name)
		if str(GameState.player_name).strip_edges() != "":
			participants.append(str(GameState.player_name))
	story_dialog_popup.set_conversation_cast(participants)
	
	await story_dialog_popup.show_dialog(
		speaker_name,
		dialogue_text
	)
	
	if is_instance_valid(
		combat_character_sheet_controller
	):
		combat_character_sheet_controller.set_panel_visible(
			character_sheet_was_visible
		)
	
	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_panel_visible(
			action_panel_was_visible
		)

func create_story_choice_panel() -> void:
	if is_instance_valid(story_choice_panel):
		return

	if not is_instance_valid(ui_layer):
		return

	story_choice_panel = (
		StoryChoicePanelScript.new()
	)

	ui_layer.add_child(
		story_choice_panel
	)


func show_story_choice(
	prompt_text: String,
	options: Array
) -> String:
	if options.is_empty():
		return ""

	if not is_instance_valid(story_choice_panel):
		create_story_choice_panel()

	if not is_instance_valid(story_choice_panel):
		return ""

	var character_sheet_was_visible: bool = false
	var action_panel_was_visible: bool = false

	if is_instance_valid(
		combat_character_sheet_controller
	):
		character_sheet_was_visible = (
			combat_character_sheet_controller
			.is_panel_visible()
		)

	if is_instance_valid(
		combat_action_panel_controller
	):
		action_panel_was_visible = (
			combat_action_panel_controller
			.is_panel_visible()
		)

	set_gameplay_panels_visible(
		false
	)

	var selected_choice_id: String = await (
		story_choice_panel.show_choices(
			prompt_text,
			options
		)
	)

	if is_instance_valid(
		combat_character_sheet_controller
	):
		combat_character_sheet_controller.set_panel_visible(
			character_sheet_was_visible
		)

	if is_instance_valid(
		combat_action_panel_controller
	):
		combat_action_panel_controller.set_panel_visible(
			action_panel_was_visible
		)

	return selected_choice_id

func on_manual_camera_control_started(
	block_player_click: bool
):
	camera_follow_unit = null
	
	if block_player_click:
		camera_drag_block_player_click = true
func update_manual_camera_control():
	if not is_instance_valid(game_camera):
		return
	
	var manual_control_enabled: bool = (
		initiative_started
		and not battle_finished
		and current_turn == TurnState.HERO_TURN
		and is_instance_valid(current_active_unit)
		and not is_instance_valid(selected_player_unit)
	)
	
	game_camera.set(
		"manual_control_enabled",
		manual_control_enabled
	)


func select_player_unit(
	unit: Node2D
):
	if not is_instance_valid(unit):
		return
	
	selected_player_unit = unit
	
	clear_movement_area()
	clear_attack_area()
	
	refresh_selected_unit_ui()
	update_manual_camera_control()
	
	if unit == get_acting_unit():
		show_movement_area()
		show_attack_area_for_unit(unit)


func clear_player_unit_selection_for_camera():
	selected_player_unit = null
	
	clear_movement_area()
	clear_attack_area()
	
	update_manual_camera_control()
	
	print(
		"Seleção cancelada. Controle manual da câmera ativo."
	)
func is_position_in_current_movement_area(
	grid_position: Vector2i
) -> bool:
	var acting_unit: Node2D = get_acting_unit()
	
	if not is_instance_valid(acting_unit):
		return false
	
	if selected_player_unit != acting_unit:
		return false
	
	if not (
		"current_movement_meters"
		in acting_unit
	):
		return false
	
	var available_movement: float = float(
		acting_unit.current_movement_meters
	)
	
	if available_movement <= 0.0:
		return false
	
	var reachable_positions: Dictionary = (
		get_reachable_positions_for_unit(
			acting_unit,
			available_movement
		)
	)
	
	if not reachable_positions.has(grid_position):
		return false
	
	if grid_position == acting_unit.grid_position:
		return false
	
	var occupant: Node2D = (
		get_unit_at_grid_position(
			grid_position
		)
	)
	
	if is_instance_valid(occupant):
		return false
	
	return true
func create_attack_roll_box():
	if is_instance_valid(attack_roll_box):
		return
	
	attack_roll_box = AttackRollBoxScript.new()
	ui_layer.add_child(attack_roll_box)
func is_goblin_unit(unit: Node2D) -> bool:
	if not is_instance_valid(unit):
		return false
	
	if not "subtype" in unit:
		return false
	
	var unit_subtype: String = str(
		unit.subtype
	).strip_edges().to_lower()
	
	return unit_subtype == "goblin"
func set_intro_unit_grid_position(
	unit: Node2D,
	grid_position: Vector2i
) -> void:
	if not is_instance_valid(unit):
		return
	
	unit.grid_position = grid_position
	unit.position = grid_to_world_position(
		grid_position
	)
	
	if (
		is_enemy_unit(unit)
		and not is_inside_grid(grid_position)
	):
		unit.visible = false
		
func animate_intro_unit_to_grid(
	unit: Node2D,
	destination: Vector2i,
	duration: float
) -> void:
	if not is_instance_valid(unit):
		return
	
	var target_position: Vector2 = (
		grid_to_world_position(destination)
	)
	
	if duration <= 0.0:
		unit.grid_position = destination
		unit.position = target_position
		return
	
	var movement_tween := create_tween()
	
	movement_tween.set_trans(
		Tween.TRANS_SINE
	)
	
	movement_tween.set_ease(
		Tween.EASE_IN_OUT
	)
	
	movement_tween.tween_property(
		unit,
		"position",
		target_position,
		duration
	)
	
	await movement_tween.finished
	
	if not is_instance_valid(unit):
		return
	
	unit.grid_position = destination
	unit.position = target_position

func animate_intro_enemy_group(
	final_positions: Dictionary,
	duration: float
) -> void:
	var valid_enemies: Array[Node2D] = []
	
	for unit_key in final_positions.keys():
		var enemy_unit: Node2D = (
			unit_key as Node2D
		)
		
		if not is_instance_valid(enemy_unit):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		valid_enemies.append(enemy_unit)
	
	if valid_enemies.is_empty():
		return
	
	# Pequena espera antes de os inimigos cruzarem
	# a borda direita do mapa.
	await get_tree().create_timer(
		0.18
	).timeout
	
	var map_entry_x: int = max(
		current_grid_width - 1,
		0
	)
	
	for enemy_unit in valid_enemies:
		var final_grid_position: Vector2i = (
			final_positions[enemy_unit]
		)
		
		var map_entry_position := Vector2i(
			map_entry_x,
			final_grid_position.y
		)
		
		enemy_unit.grid_position = (
			map_entry_position
		)
		
		enemy_unit.position = (
			grid_to_world_position(
				map_entry_position
			)
		)
		
		enemy_unit.visible = true
		
		if enemy_unit.has_method(
			"update_health_display"
		):
			enemy_unit.update_health_display()

	play_enemy_intro_sound_for_group(valid_enemies)
	
	var movement_tween := create_tween()
	
	movement_tween.set_parallel(true)
	
	movement_tween.set_trans(
		Tween.TRANS_SINE
	)
	
	movement_tween.set_ease(
		Tween.EASE_OUT
	)
	
	for enemy_unit in valid_enemies:
		var final_grid_position: Vector2i = (
			final_positions[enemy_unit]
		)
		
		movement_tween.tween_property(
			enemy_unit,
			"position",
			grid_to_world_position(
				final_grid_position
			),
			duration
		)
	
	await movement_tween.finished
	
	for enemy_unit in valid_enemies:
		if not is_instance_valid(enemy_unit):
			continue
		
		var final_grid_position: Vector2i = (
			final_positions[enemy_unit]
		)
		
		enemy_unit.grid_position = (
			final_grid_position
		)
		
		enemy_unit.position = (
			grid_to_world_position(
				final_grid_position
			)
		)

func find_intro_enemy_by_display_name(
	enemy_name: String
) -> Node2D:
	for enemy_unit in enemies:
		if not is_instance_valid(
			enemy_unit
		):
			continue
		
		if get_unit_display_name(
			enemy_unit
		) == enemy_name:
			return enemy_unit
	
	return null


func play_scripted_scenario_intro(
	sequence_data: Dictionary
) -> void:
	var hidden_enemy_names: Array = (
		sequence_data.get(
			"initially_hidden_enemies",
			[]
		)
	)
	
	for enemy_name_value in hidden_enemy_names:
		var enemy_name: String = str(
			enemy_name_value
		)
		
		var hidden_enemy: Node2D = (
			find_intro_enemy_by_display_name(
				enemy_name
			)
		)
		
		if is_instance_valid(
			hidden_enemy
		):
			hidden_enemy.visible = false
	
	var player_name: String = (
		get_victory_player_name()
	)
	
	var steps: Array = sequence_data.get(
		"steps",
		[]
	)
	var previous_intro_cast: Array[String] = active_cinematic_cast.duplicate()
	active_cinematic_cast.clear()
	for step_value in steps:
		if not step_value is Dictionary or str(step_value.get("type", "")) != "dialogue":
			continue
		var cast_name: String = str(step_value.get("speaker", "")).replace("[NOME_DO_JOGADOR]", player_name).strip_edges()
		if cast_name != "" and not active_cinematic_cast.has(cast_name):
			active_cinematic_cast.append(cast_name)
	
	for step_value in steps:
		if not step_value is Dictionary:
			continue
		
		var step_data: Dictionary = (
			step_value
		)
		
		var step_type: String = str(
			step_data.get(
				"type",
				""
			)
		)
		
		match step_type:
			"camera":
				var camera_position: Vector2i = (
					step_data.get(
						"position",
						Vector2i.ZERO
					)
				)
				
				await focus_camera_on_grid_position(
					camera_position
				)
			
			"dialogue":
				var speaker_name: String = str(
					step_data.get(
						"speaker",
						""
					)
				)
				
				var dialogue_text: String = str(
					step_data.get(
						"text",
						""
					)
				)
				
				speaker_name = speaker_name.replace(
					"[NOME_DO_JOGADOR]",
					player_name
				)
				
				dialogue_text = dialogue_text.replace(
					"[NOME_DO_JOGADOR]",
					player_name
				)
				
				if dialogue_text.strip_edges() == "":
					continue
				
				await show_story_dialog(
					speaker_name,
					dialogue_text
				)
			
			"reveal_enemies":
				var camera_focus: Vector2i = (
					step_data.get(
						"camera_focus",
						Vector2i.ZERO
					)
				)
				
				await focus_camera_on_grid_position(
					camera_focus
				)
				
				var enemy_names: Array = (
					step_data.get(
						"names",
						[]
					)
				)
				var revealed_enemies: Array[Node2D] = []
				
				for enemy_name_value in enemy_names:
					var enemy_name: String = str(
						enemy_name_value
					)
					
					var revealed_enemy: Node2D = (
						find_intro_enemy_by_display_name(
							enemy_name
						)
					)
					
					if not is_instance_valid(
						revealed_enemy
					):
						continue
					
					revealed_enemy.visible = true
					revealed_enemies.append(revealed_enemy)
					
					if revealed_enemy.has_method(
						"update_health_display"
					):
						revealed_enemy.update_health_display()
				play_enemy_intro_sound_for_group(revealed_enemies)
				
				await get_tree().create_timer(
					0.35
				).timeout
			"move_npcs":
				var moves: Array = step_data.get("moves", [])
				var duration: float = maxf(
					0.01,
					float(step_data.get("duration", 1.25))
				)

				var moving_units: Array[Node2D] = []
				var destinations: Array[Vector2i] = []

				var movement_tween: Tween = create_tween()
				movement_tween.set_parallel(true)
				movement_tween.set_trans(Tween.TRANS_SINE)
				movement_tween.set_ease(Tween.EASE_IN_OUT)

				for move_value in moves:
					if not move_value is Dictionary:
						continue

					var move_data: Dictionary = move_value
					var npc_unit: Node2D = find_scenario_npc_by_id(
						str(move_data.get("npc_id", ""))
					)

					if not is_instance_valid(npc_unit):
						continue

					var destination: Vector2i = move_data.get(
						"destination",
						npc_unit.grid_position
					)

					if is_grid_position_blocked_for_path(
						destination,
						npc_unit
					):
						continue

					moving_units.append(npc_unit)
					destinations.append(destination)

					movement_tween.tween_property(
						npc_unit,
						"position",
						grid_to_world_position(destination),
						duration
					)

				if moving_units.is_empty():
					movement_tween.kill()
					continue

				await movement_tween.finished

				for index in range(moving_units.size()):
					var npc_unit: Node2D = moving_units[index]

					if not is_instance_valid(npc_unit):
						continue

					npc_unit.grid_position = destinations[index]
					npc_unit.position = grid_to_world_position(
						destinations[index]
					)
	
	# Segurança: nenhum inimigo pode permanecer
	# invisível quando a iniciativa for liberada.
	for enemy_unit in enemies:
		if not is_instance_valid(
			enemy_unit
		):
			continue
		
		if enemy_unit.hp <= 0:
			continue
		
		enemy_unit.visible = true
		
		if enemy_unit.has_method(
			"update_health_display"
		):
			enemy_unit.update_health_display()
	active_cinematic_cast = previous_intro_cast

func play_scenario_intro_sequence() -> void:
	var sequence_data: Dictionary = (
		ScenarioDatabase.get_scenario_intro_sequence(
			current_stage
		)
	)
	
	if sequence_data.is_empty():
		await play_scenario_intro_camera()
		return
	
	if scenario_intro_running:
		return
	
	var sequence_type: String = str(
		sequence_data.get(
			"type",
			"legacy"
		)
	)
	
	if sequence_type == "scripted_dialogue":
		scenario_intro_running = true
		is_movement_animating = true
		
		await play_scripted_scenario_intro(
			sequence_data
		)
		
		camera_follow_unit = null
		is_movement_animating = false
		scenario_intro_running = false
		return
	
	scenario_intro_running = true
	is_movement_animating = true
	
	var speaker_id: String = str(
		sequence_data.get(
			"speaker_id",
			""
		)
	)
	
	var speaker_name: String = str(
		sequence_data.get(
			"speaker_name",
			"Soldado Ferido"
		)
	)
	
	var guard_unit: Node2D = (
		find_scenario_npc_by_id(
			speaker_id
		)
	)
	
	if not is_instance_valid(
		guard_unit
	):
		scenario_intro_running = false
		is_movement_animating = false
		
		await play_scenario_intro_camera()
		return
	
	var guard_start_position: Vector2i = (
		sequence_data.get(
			"guard_start_position",
			guard_unit.grid_position
		)
	)
	
	var guard_final_position: Vector2i = (
		sequence_data.get(
			"guard_final_position",
			guard_unit.grid_position
		)
	)
	
	var first_dialogue: String = str(
		sequence_data.get(
			"first_dialogue",
			""
		)
	)
	
	var second_dialogue: String = str(
		sequence_data.get(
			"second_dialogue",
			""
		)
	)
	var opening_dialogues: Array = sequence_data.get(
		"opening_dialogues",
		[]
	)
	var encounter_dialogues: Array = sequence_data.get(
		"encounter_dialogues",
		[]
	)
	var dialogue_camera_focus: Vector2i = sequence_data.get(
		"dialogue_camera_focus",
		guard_final_position
	)
	var hero_reveal_duration: float = float(sequence_data.get(
		"hero_reveal_duration",
		0.8
	))
	
	var enemy_entry_x: int = int(
		sequence_data.get(
			"enemy_entry_x",
			current_grid_width + 1
		)
	)
	
	var enemy_camera_focus: Vector2i = (
		sequence_data.get(
			"enemy_camera_focus",
			guard_final_position
		)
	)
	
	var guard_walk_duration: float = float(
		sequence_data.get(
			"guard_walk_duration",
			2.4
		)
	)
	
	var enemy_walk_duration: float = float(
		sequence_data.get(
			"enemy_walk_duration",
			1.6
		)
	)
	
	var pause_before_enemies: float = float(
		sequence_data.get(
			"pause_before_enemies",
			0.35
		)
	)
	
	var enemy_final_positions: Dictionary = {}
	
	set_intro_unit_grid_position(
		guard_unit,
		guard_start_position
	)
	
	for enemy_unit in enemies:
		if not is_instance_valid(
			enemy_unit
		):
			continue
		
		var final_position: Vector2i = (
			enemy_unit.grid_position
		)
		
		enemy_final_positions[enemy_unit] = (
			final_position
		)
		
		var entry_position := Vector2i(
			enemy_entry_x,
			final_position.y
		)
		
		set_intro_unit_grid_position(
			enemy_unit,
			entry_position
		)
	
	# A abertura começa no herói. O guarda só entra no enquadramento
	# depois, sem tirar o jogador da tela antes da primeira fala.
	if is_instance_valid(hero) and is_instance_valid(game_camera):
		camera_follow_unit = hero
		game_camera.global_position = hero.global_position
		game_camera.reset_smoothing()
		if hero_reveal_duration > 0.0:
			await get_tree().create_timer(hero_reveal_duration).timeout
	
	await focus_camera_on_grid_position(dialogue_camera_focus)
	
	await animate_intro_unit_to_grid(
		guard_unit,
		guard_final_position,
		guard_walk_duration
	)
	
	if not opening_dialogues.is_empty():
		await show_scenario_dialogue_entries(opening_dialogues, speaker_name)
	elif first_dialogue.strip_edges() != "":
		await show_story_dialog(
			speaker_name,
			first_dialogue
		)
	
	if pause_before_enemies > 0.0:
		await get_tree().create_timer(
			pause_before_enemies
		).timeout
	
	await focus_camera_on_grid_position(
		enemy_camera_focus
	)
	
	await animate_intro_enemy_group(
		enemy_final_positions,
		enemy_walk_duration
	)
	
	await focus_camera_on_grid_position(dialogue_camera_focus)
	
	if not encounter_dialogues.is_empty():
		await show_scenario_dialogue_entries(encounter_dialogues, speaker_name)
	elif second_dialogue.strip_edges() != "":
		await show_story_dialog(
			speaker_name,
			second_dialogue
		)
	
	camera_follow_unit = null
	is_movement_animating = false
	scenario_intro_running = false

func get_victory_uiliam() -> Node2D:
	var uiliam_unit: Node2D = (
		find_scenario_npc_by_id(
			"Sr Uiliam"
		)
	)
	
	if is_instance_valid(uiliam_unit):
		return uiliam_unit
	
	# Segurança narrativa:
	# caso o evento de entrada não tenha sido ativado,
	# Sir Uiliam ainda estará presente na cena final.
	uiliam_unit = spawn_npc(
		"Sr Uiliam",
		Vector2i(24, 2),
		"Sir Uiliam",
		"player"
	)
	
	return uiliam_unit
func get_victory_player_name() -> String:
	var player_name: String = str(
		GameState.player_name
	).strip_edges()
	
	if player_name != "":
		return player_name
	
	if is_instance_valid(hero):
		return get_unit_display_name(hero)
	
	return "Aventureiro"
func show_scenario_victory_dialogues(
	sequence_data: Dictionary,
	uiliam_unit: Node2D
) -> void:
	var dialogues: Array = sequence_data.get(
		"dialogues",
		[]
	)

	if dialogues.is_empty():
		return

	var default_speaker_name: String = str(
		sequence_data.get(
			"speaker_name",
			"Sir Uiliam"
		)
	)

	var player_name: String = (
		get_victory_player_name()
	)

	camera_follow_unit = null

	var camera_focus_position := Vector2i.ZERO

	if (
		is_instance_valid(hero)
		and is_instance_valid(uiliam_unit)
	):
		camera_focus_position = Vector2i(
			int(
				(
					hero.grid_position.x
					+ uiliam_unit.grid_position.x
				) / 2.0
			),
			int(
				(
					hero.grid_position.y
					+ uiliam_unit.grid_position.y
				) / 2.0
			)
		)
	elif is_instance_valid(uiliam_unit):
		camera_focus_position = (
			uiliam_unit.grid_position
		)
	elif is_instance_valid(hero):
		camera_focus_position = (
			hero.grid_position
		)

	await focus_camera_on_grid_position(
		camera_focus_position
	)
	var previous_victory_cast: Array[String] = active_cinematic_cast.duplicate()
	active_cinematic_cast.clear()
	for entry_value in dialogues:
		if not entry_value is Dictionary:
			continue
		var cast_name: String = str(entry_value.get("speaker_name", default_speaker_name)).replace("[NOME_DO_JOGADOR]", player_name).strip_edges()
		if cast_name != "" and not active_cinematic_cast.has(cast_name):
			active_cinematic_cast.append(cast_name)

	for dialogue_entry_value in dialogues:
		if not dialogue_entry_value is Dictionary:
			continue

		var dialogue_entry: Dictionary = (
			dialogue_entry_value
		)

		var dialogue_text: String = str(
			dialogue_entry.get(
				"text",
				""
			)
		)

		var dialogue_speaker: String = str(
			dialogue_entry.get(
				"speaker_name",
				default_speaker_name
			)
		)

		dialogue_text = dialogue_text.replace(
			"[NOME_DO_JOGADOR]",
			player_name
		)

		dialogue_speaker = dialogue_speaker.replace(
			"[NOME_DO_JOGADOR]",
			player_name
		)

		if dialogue_text.strip_edges() == "":
			continue

		if dialogue_speaker.strip_edges() == "":
			dialogue_speaker = default_speaker_name

		await show_story_dialog(
			dialogue_speaker,
			dialogue_text
		)
	active_cinematic_cast = previous_victory_cast

func animate_victory_units_to_village(
	sequence_data: Dictionary,
	uiliam_unit: Node2D,
	guard_unit: Node2D = null
) -> void:
	var hero_is_valid: bool = is_instance_valid(hero)
	var uiliam_is_valid: bool = (
		is_instance_valid(uiliam_unit)
	)
	var guard_is_valid: bool = is_instance_valid(guard_unit) and guard_unit.hp > 0
	
	if not hero_is_valid and not uiliam_is_valid:
		return
	
	var hero_exit: Vector2i = sequence_data.get(
		"hero_village_exit",
		Vector2i(GRID_WIDTH + 1, 12)
	)
	
	var uiliam_exit: Vector2i = sequence_data.get(
		"uiliam_village_exit",
		Vector2i(GRID_WIDTH + 1, 11)
	)
	var guard_exit: Vector2i = sequence_data.get(
		"guard_village_exit",
		Vector2i(GRID_WIDTH + 1, 13)
	)
	
	var movement_duration: float = max(
		0.1,
		float(
			sequence_data.get(
				"movement_duration",
				2.5
			)
		)
	)
	
	is_movement_animating = true
	camera_follow_unit = null
	
	clear_movement_area()
	clear_attack_area()
	
	var movement_tween := create_tween()
	
	movement_tween.set_trans(
		Tween.TRANS_SINE
	)
	
	movement_tween.set_ease(
		Tween.EASE_IN_OUT
	)
	
	if hero_is_valid:
		movement_tween.tween_property(
			hero,
			"position",
			grid_to_world_position(hero_exit),
			movement_duration
		)
	
	if uiliam_is_valid:
		if hero_is_valid:
			movement_tween.parallel().tween_property(
				uiliam_unit,
				"position",
				grid_to_world_position(uiliam_exit),
				movement_duration
			)
		else:
			movement_tween.tween_property(
				uiliam_unit,
				"position",
				grid_to_world_position(uiliam_exit),
				movement_duration
			)
	
	if guard_is_valid:
		movement_tween.parallel().tween_property(
			guard_unit,
			"position",
			grid_to_world_position(guard_exit),
			movement_duration
		)
	
	if is_instance_valid(game_camera):
		var camera_y: int = int(
			(
				hero_exit.y
				+ uiliam_exit.y
			) / 2.0
		)
		
		var camera_focus_grid := Vector2i(
			max(0, GRID_WIDTH - 4),
			clampi(
				camera_y,
				0,
				GRID_HEIGHT - 1
			)
		)
		
		movement_tween.parallel().tween_property(
			game_camera,
			"global_position",
			grid_to_world_position(
				camera_focus_grid
			),
			movement_duration
		)
	
	await movement_tween.finished
	
	if hero_is_valid and is_instance_valid(hero):
		hero.grid_position = hero_exit
		hero.position = grid_to_world_position(
			hero_exit
		)
		
		if not is_inside_grid(hero_exit):
			hero.visible = false
	
	if (
		uiliam_is_valid
		and is_instance_valid(uiliam_unit)
	):
		uiliam_unit.grid_position = uiliam_exit
		uiliam_unit.position = grid_to_world_position(
			uiliam_exit
		)
		
		if not is_inside_grid(uiliam_exit):
			uiliam_unit.visible = false
	
	if guard_is_valid and is_instance_valid(guard_unit):
		guard_unit.grid_position = guard_exit
		guard_unit.position = grid_to_world_position(guard_exit)
		if not is_inside_grid(guard_exit):
			guard_unit.visible = false
	
	is_movement_animating = false
func fade_out_scenario_transition(
	duration: float = 1.0
) -> void:
	if not is_instance_valid(ui_layer):
		return
	
	var transition_overlay: ColorRect = (
		ui_layer.get_node_or_null(
			"ScenarioTransitionOverlay"
		) as ColorRect
	)
	
	if not is_instance_valid(transition_overlay):
		transition_overlay = ColorRect.new()
		transition_overlay.name = (
			"ScenarioTransitionOverlay"
		)
		
		transition_overlay.set_anchors_and_offsets_preset(
			Control.PRESET_FULL_RECT
		)
		
		transition_overlay.color = Color(
			0.0,
			0.0,
			0.0,
			0.0
		)
		
		transition_overlay.mouse_filter = (
			Control.MOUSE_FILTER_STOP
		)
		
		transition_overlay.process_mode = (
			Node.PROCESS_MODE_ALWAYS
		)
		
		transition_overlay.z_index = 10000
		
		ui_layer.add_child(
			transition_overlay
		)
		
		transition_overlay.set_anchors_and_offsets_preset(
			Control.PRESET_FULL_RECT
		)
	
	var fade_duration: float = max(
		0.05,
		duration
	)
	
	var fade_tween := create_tween()
	
	fade_tween.set_pause_mode(
		Tween.TWEEN_PAUSE_PROCESS
	)
	
	fade_tween.set_trans(
		Tween.TRANS_SINE
	)
	
	fade_tween.set_ease(
		Tween.EASE_IN_OUT
	)
	
	fade_tween.tween_property(
		transition_overlay,
		"color",
		Color.BLACK,
		fade_duration
	)
	
	await fade_tween.finished
func play_stage_3_victory_sequence() -> bool:
	var sequence: Dictionary = Stage3VictoryData.get_sequence()
	if sequence.is_empty():
		return false
	if MusicManage != null:
		MusicManage.play_music(STAGE_3_VICTORY_MUSIC_PATH, 75.0)

	set_gameplay_panels_visible(false)
	selected_player_unit = null
	camera_follow_unit = null
	is_movement_animating = true
	clear_movement_area()
	clear_attack_area()

	# Toda a conversa acontece sobre o próprio mapa da ponte.
	var hashagur_unit: Node2D = find_scenario_npc_by_id("Hashagur")
	if not is_instance_valid(hashagur_unit):
		# O combate pode acabar antes do evento de entrada da rodada 3.
		hashagur_unit = spawn_npc(
			"Hashagur",
			Vector2i(13, 11),
			"Hashagur",
			"player"
		)
	await focus_camera_on_grid_position(Vector2i(15, 13))
	await show_story_dialogue_entries(sequence.get("last_cultist", []))
	await show_story_dialogue_entries(sequence.get("hashagur_before_exit", []))

	if is_instance_valid(hashagur_unit) and hashagur_unit.hp > 0:
		await animate_intro_unit_to_grid(hashagur_unit, Vector2i(8, 10), 1.6)
		hashagur_unit.visible = false

	await show_story_dialogue_entries(sequence.get("hashagur_after_exit", []))
	await show_story_dialogue_entries(sequence.get("mystery", []))

	var choice_options: Array = sequence.get("choice_options", [])
	var selected_choice_id: String = await show_story_choice(
		str(sequence.get("choice_prompt", "O que você diz?")),
		choice_options
	)
	if selected_choice_id == "":
		is_movement_animating = false
		return false

	MissionManager.set_story_choice(
		"emerald_bridge_response",
		selected_choice_id
	)
	for option_value in choice_options:
		if not option_value is Dictionary:
			continue
		var option_data: Dictionary = option_value
		if str(option_data.get("id", "")) == selected_choice_id:
			await show_story_dialogue_entries(option_data.get("dialogues", []))
			break

	await show_story_dialogue_entries(sequence.get("repair", []))
	await transition_to_stage_3_night()
	await show_story_dialogue_entries(sequence.get("night_intro", []))
	await show_story_dialogue_entries(sequence.get("night_dialogues", []))

	stage_3_jhon_working = false
	if is_instance_valid(stage_3_work_tween) and stage_3_work_tween.is_running():
		await stage_3_work_tween.finished
	if is_instance_valid(stage_3_hammer_player):
		stage_3_hammer_player.stop()
	if is_instance_valid(stage_3_night_tint):
		var closing_fade := create_tween()
		closing_fade.tween_property(
			stage_3_night_tint,
			"color",
			Color.BLACK,
			0.8
		)
		await closing_fade.finished

	await transition_to_stage_3_morning()
	await show_story_dialogue_entries(sequence.get("morning", []))
	await show_story_dialogue_entries(sequence.get("road_warning", []))
	await bring_stage_3_reinforcements()
	await show_story_dialogue_entries(sequence.get("road_arrival", []))
	await show_story_dialogue_entries(sequence.get("kasum", []))
	start_stage_3_convoy_departure()
	await show_story_dialogue_entries(sequence.get("kasum_after_departure", []))
	await show_story_dialogue_entries(sequence.get("return_to_village", []))
	await animate_stage_3_return_to_village()

	if (
		not MissionManager.is_mission_active("emerald_bridge")
		and not MissionManager.is_mission_completed("emerald_bridge")
	):
		MissionManager.start_mission({
			"id": "emerald_bridge",
			"title": "A Ponte da Esmeralda",
			"description": "Proteja Jhon e restaure a passagem."
		})
	MissionManager.update_mission_progress("emerald_bridge", "jhon_found", true)
	MissionManager.update_mission_progress("emerald_bridge", "jhon_protected", true)
	MissionManager.update_mission_progress("emerald_bridge", "bridge_repaired", true)
	MissionManager.complete_mission("emerald_bridge")
	MissionManager.set_story_choice("kasum_met", "yes")
	await show_story_dialog(
		"Missão concluída",
		str(sequence.get("mission_complete", "A Ponte da Esmeralda"))
	)

	is_movement_animating = false
	show_victory()
	return true


func transition_to_stage_3_night() -> void:
	if not is_instance_valid(ui_layer) or not is_instance_valid(board_root):
		return

	var night_fade := ColorRect.new()
	night_fade.name = "Stage3NightFade"
	night_fade.color = Color(0.0, 0.0, 0.0, 0.0)
	night_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	night_fade.process_mode = Node.PROCESS_MODE_ALWAYS
	night_fade.z_index = 9999
	ui_layer.add_child(night_fade)
	night_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var fade_to_black := create_tween()
	fade_to_black.tween_property(night_fade, "color:a", 1.0, 0.8)
	await fade_to_black.finished

	stage_3_night_tint = CanvasModulate.new()
	stage_3_night_tint.name = "Stage3NightTint"
	stage_3_night_tint.color = Color(0.52, 0.57, 0.72)
	board_root.add_child(stage_3_night_tint)

	var campfire: Node2D = CampfireVisualScript.new()
	campfire.name = "BridgeCampfire"
	campfire.position = grid_to_world_position(Vector2i(15, 19))
	campfire.z_index = 5
	campfire.process_mode = Node.PROCESS_MODE_ALWAYS
	board_root.add_child(campfire)

	if UIAudioManager != null and UIAudioManager.heavy_hit_stream != null:
		stage_3_hammer_player = AudioStreamPlayer.new()
		stage_3_hammer_player.name = "BridgeHammerSound"
		stage_3_hammer_player.stream = UIAudioManager.heavy_hit_stream
		stage_3_hammer_player.bus = "Sfx"
		stage_3_hammer_player.volume_db = -12.0
		stage_3_hammer_player.process_mode = Node.PROCESS_MODE_ALWAYS
		board_root.add_child(stage_3_hammer_player)

	set_intro_unit_grid_position(hero, Vector2i(15, 21))
	set_intro_unit_grid_position(find_scenario_npc_by_id("Sr Uiliam"), Vector2i(14, 20))
	set_intro_unit_grid_position(find_scenario_npc_by_id("Aniri"), Vector2i(16, 20))
	set_intro_unit_grid_position(find_scenario_npc_by_id("Guarda da Ponte"), Vector2i(14, 18))

	var jhon_unit: Node2D = find_scenario_npc_by_id("Jhon")
	set_intro_unit_grid_position(jhon_unit, Vector2i(15, 14))
	await focus_camera_on_grid_position(Vector2i(15, 18))

	if is_instance_valid(jhon_unit):
		stage_3_jhon_working = true
		animate_stage_3_jhon_work_loop(jhon_unit)

	var reveal_night := create_tween()
	reveal_night.tween_property(night_fade, "color:a", 0.0, 0.8)
	await reveal_night.finished
	night_fade.queue_free()


func animate_stage_3_jhon_work_loop(jhon_unit: Node2D) -> void:
	# Quatro estágios, repetidos enquanto a conversa da noite prossegue.
	var work_positions: Array[Vector2i] = [
		Vector2i(14, 14),
		Vector2i(16, 14),
		Vector2i(16, 13),
		Vector2i(14, 13)
	]
	var work_stage: int = 0
	while stage_3_jhon_working and is_instance_valid(jhon_unit):
		var destination: Vector2i = work_positions[work_stage]
		stage_3_work_tween = create_tween()
		stage_3_work_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		stage_3_work_tween.set_trans(Tween.TRANS_SINE)
		stage_3_work_tween.tween_property(
			jhon_unit,
			"position",
			grid_to_world_position(destination),
			1.1
		)
		await stage_3_work_tween.finished
		if not stage_3_jhon_working or not is_instance_valid(jhon_unit):
			break
		jhon_unit.grid_position = destination
		if is_instance_valid(stage_3_hammer_player):
			stage_3_hammer_player.play()
		work_stage = (work_stage + 1) % work_positions.size()
		await get_tree().create_timer(0.45, true).timeout


func transition_to_stage_3_morning() -> void:
	var campfire: Node = board_root.get_node_or_null("BridgeCampfire")
	if is_instance_valid(campfire):
		campfire.queue_free()
	if is_instance_valid(stage_3_hammer_player):
		stage_3_hammer_player.queue_free()
		stage_3_hammer_player = null

	set_intro_unit_grid_position(find_scenario_npc_by_id("Jhon"), Vector2i(15, 16))
	set_intro_unit_grid_position(find_scenario_npc_by_id("Guarda da Ponte"), Vector2i(14, 17))
	set_intro_unit_grid_position(find_scenario_npc_by_id("Sr Uiliam"), Vector2i(13, 19))
	set_intro_unit_grid_position(find_scenario_npc_by_id("Aniri"), Vector2i(17, 19))
	set_intro_unit_grid_position(hero, Vector2i(15, 20))
	await focus_camera_on_grid_position(Vector2i(15, 17))

	if is_instance_valid(stage_3_night_tint):
		var sunrise := create_tween()
		sunrise.tween_property(
			stage_3_night_tint,
			"color",
			Color.WHITE,
			1.25
		)
		await sunrise.finished
		stage_3_night_tint.queue_free()
		stage_3_night_tint = null


func bring_stage_3_reinforcements() -> void:
	if not is_instance_valid(board_root):
		return

	await focus_camera_on_grid_position(Vector2i(15, 6))
	stage_3_convoy = BridgeConvoyVisualScript.new()
	stage_3_convoy.name = "BridgeMerchantConvoy"
	stage_3_convoy.z_index = 4
	stage_3_convoy.position = grid_to_world_position(Vector2i(15, 2))
	board_root.add_child(stage_3_convoy)

	stage_3_reinforcements.clear()
	var left_guard: Node2D = spawn_npc(
		"Guarda da Ponte", Vector2i(13, 2), "Reforço de Vanir 1", "passive"
	)
	var right_guard: Node2D = spawn_npc(
		"Guarda da Ponte", Vector2i(18, 2), "Reforço de Vanir 2", "passive"
	)
	var kasum_unit: Node2D = spawn_npc(
		"Kasum", Vector2i(18, 3), "Kasum", "passive"
	)
	if is_instance_valid(left_guard):
		stage_3_reinforcements.append(left_guard)
	if is_instance_valid(right_guard):
		stage_3_reinforcements.append(right_guard)

	var arrival := create_tween()
	arrival.set_parallel(true)
	arrival.set_trans(Tween.TRANS_SINE)
	arrival.tween_property(
		stage_3_convoy,
		"position",
		grid_to_world_position(Vector2i(15, 12)),
		3.0
	)
	if is_instance_valid(left_guard):
		arrival.tween_property(
			left_guard, "position", grid_to_world_position(Vector2i(13, 12)), 3.0
		)
	if is_instance_valid(right_guard):
		arrival.tween_property(
			right_guard, "position", grid_to_world_position(Vector2i(18, 12)), 3.0
		)
	if is_instance_valid(kasum_unit):
		arrival.tween_property(
			kasum_unit, "position", grid_to_world_position(Vector2i(18, 13)), 3.0
		)
	await arrival.finished
	if is_instance_valid(left_guard):
		left_guard.grid_position = Vector2i(13, 12)
	if is_instance_valid(right_guard):
		right_guard.grid_position = Vector2i(18, 12)
	if is_instance_valid(kasum_unit):
		kasum_unit.grid_position = Vector2i(18, 13)
	await focus_camera_on_grid_position(Vector2i(15, 13))


func start_stage_3_convoy_departure() -> void:
	var departure := create_tween()
	departure.set_parallel(true)
	departure.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	departure.set_trans(Tween.TRANS_SINE)
	if is_instance_valid(stage_3_convoy):
		departure.tween_property(
			stage_3_convoy,
			"position",
			grid_to_world_position(Vector2i(15, 25)),
			6.0
		)
	var kasum_unit: Node2D = find_scenario_npc_by_id("Kasum")
	if is_instance_valid(kasum_unit):
		departure.tween_property(
			kasum_unit,
			"position",
			grid_to_world_position(Vector2i(18, 25)),
			6.0
		)
	for guard_unit in stage_3_reinforcements:
		if not is_instance_valid(guard_unit):
			continue
		departure.tween_property(
			guard_unit,
			"position",
			grid_to_world_position(Vector2i(guard_unit.grid_position.x, 25)),
			6.0
		)


func animate_stage_3_return_to_village() -> void:
	var return_tween := create_tween()
	return_tween.set_parallel(true)
	return_tween.set_trans(Tween.TRANS_SINE)
	return_tween.set_ease(Tween.EASE_IN_OUT)

	var party_destinations: Dictionary = {
		hero: Vector2i(15, 25),
		find_scenario_npc_by_id("Sr Uiliam"): Vector2i(13, 24),
		find_scenario_npc_by_id("Aniri"): Vector2i(17, 24),
		find_scenario_npc_by_id("Guarda da Ponte"): Vector2i(14, 23),
		find_scenario_npc_by_id("Jhon"): Vector2i(16, 23)
	}
	for unit_value in party_destinations.keys():
		var unit: Node2D = unit_value
		if not is_instance_valid(unit):
			continue
		return_tween.tween_property(
			unit,
			"position",
			grid_to_world_position(party_destinations[unit]),
			3.5
		)
	if is_instance_valid(game_camera):
		return_tween.tween_property(
			game_camera,
			"zoom",
			game_camera.zoom * 0.78,
			3.5
		)
		return_tween.tween_property(
			game_camera,
			"global_position",
			grid_to_world_position(Vector2i(15, 16)),
			3.5
		)
	await return_tween.finished


func play_scenario_victory_sequence() -> bool:
	# O cenário 2 possui escolha narrativa,
	# surgimento de Aniri e início de missão.
	if current_stage == 2:
		return await play_stage_2_victory_sequence()
	if current_stage == 3:
		return await play_stage_3_victory_sequence()

	var sequence_data: Dictionary = (
		ScenarioDatabase.get_scenario_victory_sequence(
			current_stage
		)
	)

	if sequence_data.is_empty():
		return false

	var next_scene_path: String = str(
		sequence_data.get(
			"next_scene",
			""
		)
	).strip_edges()

	if next_scene_path == "":
		push_warning(
			"A sequência de vitória não possui próxima cena."
		)

		return false

	if not ResourceLoader.exists(
		next_scene_path
	):
		push_warning(
			"A próxima cena não foi encontrada: "
			+ next_scene_path
		)

		return false

	set_gameplay_panels_visible(
		false
	)

	selected_player_unit = null
	camera_follow_unit = null
	is_movement_animating = true

	clear_movement_area()
	clear_attack_area()

	var uiliam_unit: Node2D = (
		get_victory_uiliam()
	)
	var guard_unit: Node2D = null
	if current_stage == 1:
		var stage_one_guard: Node2D = find_scenario_npc_by_id("Guarda Aliado")
		if is_instance_valid(stage_one_guard) and stage_one_guard.hp > 0:
			guard_unit = stage_one_guard
			var bonus_gold: int = int(sequence_data.get("guard_survival_bonus_gold", 0))
			if bonus_gold > 0 and is_instance_valid(hero):
				hero.gold += bonus_gold
				GameState.hero_gold = hero.gold
				battle_gold_gained += bonus_gold
			var guard_dialogues: Array = sequence_data.get("guard_survival_dialogues", [])
			var victory_dialogues: Array = sequence_data.get("dialogues", [])
			sequence_data["dialogues"] = guard_dialogues + victory_dialogues

	await show_scenario_victory_dialogues(
		sequence_data,
		uiliam_unit
	)

	await animate_victory_units_to_village(
		sequence_data,
		uiliam_unit,
		guard_unit
	)

	# Antes de salvar e trocar de cenário,
	# resolve todas as evoluções pendentes.
	await process_pending_hero_level_ups()

	sync_hero_to_game_state()

	PartyManager.sync_hero_from_game_state()

	PartyManager.recruit_npc(
		"Sr Uiliam",
		false
	)

	current_stage += 1
	GameState.selected_stage = current_stage

	if not save_auto_game("village"):
		push_warning("Não foi possível salvar automaticamente após a batalha.")
		return false

	if MusicManage != null:
		MusicManage.fade_out_music(
			1.0
		)

	await fade_out_scenario_transition(
		1.0
	)

	get_tree().change_scene_to_file(
		next_scene_path
	)

	return true

func restore_saved_inventory_and_party_state() -> void:
	var save_path: String = (
		GameState.selected_save_path
	)
	
	if save_path.strip_edges() == "":
		save_path = AUTOSAVE_PATH
	
	var save_data: Dictionary = (
		SaveManager.read_save_data(
			save_path
		)
	)
	
	if save_data.is_empty():
		InventoryManager.reset_inventory()
		return
	
	var legacy_inventory_data := {
		"gold": int(
			loaded_player_presets.get(
				"hero_gold",
				GameState.hero_gold
			)
		),
		"items": {}
	}
	
	var inventory_data_variant = (
		save_data.get(
			"inventory",
			legacy_inventory_data
		)
	)
	
	if inventory_data_variant is Dictionary:
		InventoryManager.load_save_data(
			inventory_data_variant
		)
	else:
		InventoryManager.load_save_data(
			legacy_inventory_data
		)
	
	var hero_member_data: Dictionary = (
		PartyManager.get_member(
			PartyManager.HERO_MEMBER_ID
		)
	)
	
	if not hero_member_data.is_empty():
		var equipment_data: Dictionary = (
			PartyManager.normalize_equipment_data(
				hero_member_data.get(
					"equipment",
					{}
				)
			)
		)
		
		GameState.hero_equipped_weapon = str(
			equipment_data.get(
				"weapon",
				"Espada Curta"
			)
		)
		
		GameState.hero_equipped_armor = str(
			equipment_data.get(
				"armor",
				"Roupa Comum"
			)
		)
		
		GameState.hero_equipped_shield = str(
			equipment_data.get(
				"shield",
				"Nenhum"
			)
		)
		
		GameState.hero_feats = (
			hero_member_data.get(
				"feats",
				GameState.hero_feats
			).duplicate(true)
		)
	
	GameState.hero_gold = (
		InventoryManager.get_gold()
	)
	
	GameState.selected_stage = current_stage
func get_hero_spellcasting_modifier() -> int:
	if not is_instance_valid(hero):
		return 0
	
	match hero.character_class:
		"Mago":
			return hero.get_intelligence_modifier()
		
		"Clérigo", "Druida", "Paladino", "Ranger":
			return hero.get_wisdom_modifier()
		
		"Bardo", "Feiticeiro":
			return hero.get_charisma_modifier()
		
		_:
			return 0
func get_spell_save_dc(
	spell_data: Dictionary
) -> int:
	if spell_data.has("save_dc"):
		return int(
			spell_data.get(
				"save_dc",
				12
			)
		) + (1 if is_instance_valid(hero) and hero.character_race == "Elfo" else 0)
	
	var spell_level: int = int(
		spell_data.get(
			"level",
			0
		)
	)
	
	return max(
		1,
		10
		+ spell_level
		+ get_hero_spellcasting_modifier()
	) + (1 if is_instance_valid(hero) and hero.character_race == "Elfo" else 0)
func get_unit_spell_save_bonus(
	target_unit: Node2D,
	save_type: String
) -> int:
	if not is_instance_valid(target_unit):
		return 0
	
	match save_type:
		"fortitude":
			if target_unit.has_method(
				"get_fortitude_save_bonus"
			):
				return int(
					target_unit.get_fortitude_save_bonus()
				)
			
			if target_unit.has_method(
				"get_constitution_modifier"
			):
				return int(
					target_unit.get_constitution_modifier()
				)
		
		"reflex":
			if target_unit.has_method(
				"get_reflex_save_bonus"
			):
				return int(
					target_unit.get_reflex_save_bonus()
				)
			
			if target_unit.has_method(
				"get_dexterity_modifier"
			):
				return int(
					target_unit.get_dexterity_modifier()
				)
		
		"will":
			if target_unit.has_method(
				"get_will_save_bonus"
			):
				return int(
					target_unit.get_will_save_bonus()
				)
			
			if target_unit.has_method(
				"get_wisdom_modifier"
			):
				return int(
					target_unit.get_wisdom_modifier()
				)
	
	return 0
func roll_spell_save_for_unit(
	target_unit: Node2D,
	spell_name: String,
	spell_data: Dictionary,
	effect: String
) -> Dictionary:
	if not is_instance_valid(target_unit):
		return {}
	
	var default_save_type: String = "will"
	
	if effect == "damage":
		default_save_type = "reflex"
	
	var save_type: String = str(
		spell_data.get(
			"save_type",
			default_save_type
		)
	)
	
	var save_dc: int = get_spell_save_dc(
		spell_data
	)
	
	var save_bonus: int = (
		get_unit_spell_save_bonus(
			target_unit,
			save_type
		)
	)
	
	if (
		UIAudioManager != null
		and UIAudioManager.has_method(
			"play_dice_roll"
		)
	):
		UIAudioManager.play_dice_roll()
	
	var dice_roll: int = randi_range(
		1,
		20
	)
	
	var save_total: int = (
		dice_roll + save_bonus
	)
	
	var resisted: bool = false
	
	if dice_roll == 20:
		resisted = true
	elif dice_roll == 1:
		resisted = false
	else:
		resisted = (
			save_total >= save_dc
		)
	
	print("====================================")
	print("TESTE DE RESISTÊNCIA MÁGICA")
	print("Magia: ", spell_name)
	print(
		"Alvo: ",
		get_unit_display_name(target_unit)
	)
	print("Tipo: ", save_type)
	print("Rolagem: d20 ", dice_roll)
	print("Bônus: ", save_bonus)
	print("Total: ", save_total)
	print("CD: ", save_dc)
	print("Resistiu: ", resisted)
	print("====================================")
	
	return {
		"dice_roll": dice_roll,
		"save_bonus": save_bonus,
		"save_total": save_total,
		"save_dc": save_dc,
		"save_type": save_type,
		"resisted": resisted
	}
func show_spell_resolution_box(
	spell_name: String,
	target_unit: Node2D,
	save_result: Dictionary,
	damage_amount: int,
	effect_description: String = ""
) -> void:
	if not GameState.show_attack_roll_box:
		return
	
	if not is_instance_valid(attack_roll_box):
		return
	
	if not attack_roll_box.has_method(
		"show_spell_result"
	):
		return
	
	if not is_instance_valid(target_unit):
		return
	
	attack_roll_box.call(
		"show_spell_result",
		spell_name,
		get_unit_display_name(target_unit),
		int(
			save_result.get(
				"dice_roll",
				0
			)
		),
		int(
			save_result.get(
				"save_bonus",
				0
			)
		),
		int(
			save_result.get(
				"save_total",
				0
			)
		),
		int(
			save_result.get(
				"save_dc",
				0
			)
		),
		bool(
			save_result.get(
				"resisted",
				false
			)
		),
		damage_amount,
		effect_description
	)
func on_animal_companion_defeated() -> void:
	print(
		"Removendo companheiro derrotado "
		+ "da ordem de iniciativa."
	)
	
	remove_animal_companion()

func is_animal_companion_unit(
	unit: Node2D
) -> bool:
	if not is_instance_valid(unit):
		return false
	
	if is_instance_valid(animal_companion):
		if unit == animal_companion:
			return true
	
	return unit.has_method(
		"get_companion_display_name"
	)
func get_active_effects_controller() -> Node:
	if not is_instance_valid(ui_layer):
		return null
	
	if is_instance_valid(
		active_effects_controller
	):
		if active_effects_controller.has_method(
			"setup"
		):
			active_effects_controller.setup(
				ui_layer
			)
		
		return active_effects_controller
	
	active_effects_controller = (
		ActiveEffectsPanelScript.new()
	)
	
	active_effects_controller.name = (
		"ActiveEffectsController"
	)
	
	add_child(active_effects_controller)
	
	if active_effects_controller.has_method(
		"setup"
	):
		active_effects_controller.setup(
			ui_layer
		)
	
	return active_effects_controller
func setup_scenario_weather() -> void:
	if not is_instance_valid(
		scenario_weather_controller
	):
		scenario_weather_controller = (
			ScenarioWeatherScript.new()
		)
		
		add_child(
			scenario_weather_controller
		)
	
	var weather_data: Dictionary = (
		ScenarioDatabase.get_scenario_weather(
			current_stage
		)
	)
	
	scenario_weather_controller.configure(
		weather_data
	)
func process_scenario_round_events() -> void:
	var round_events: Array = (
		ScenarioDatabase.get_scenario_round_events(
			current_stage
		)
	)
	
	for event_data in round_events:
		var event_id: String = str(
			event_data.get(
				"id",
				""
			)
		)
		
		if event_id == "":
			continue
		
		if triggered_scenario_events.has(event_id):
			continue
		
		var required_round: int = int(
			event_data.get(
				"round",
				-1
			)
		)
		
		if required_round != battle_turn_count:
			continue
		
		triggered_scenario_events[event_id] = true
		
		await execute_scenario_event(
			event_data
		)
func save_battle_progress_for_village() -> bool:
	var save_path: String = (
		SaveManager.get_active_save_path()
	)
	
	var save_data: Dictionary = (
		SaveManager.read_save_data(
			save_path
		)
	)
	
	if save_data.is_empty():
		push_warning(
			"Não existe um save anterior à batalha "
			+ "para restaurar."
		)
		
		return false
	
	# Atualiza somente o local de retorno.
	# XP, ouro, itens, vida e nível permanecem
	# com os valores anteriores à batalha.
	save_data["current_location"] = "village"
	
	var save_was_written: bool = (
		SaveManager.write_save_data(
			save_path,
			save_data
		)
	)
	
	if not save_was_written:
		return false
	
	GameState.current_location = "village"
	GameState.should_load_save = true
	
	print(
		"Batalha abandonada. O estado anterior "
		+ "será restaurado."
	)
	
	return true
func load_hero_spell_state_from_presets() -> void:
	if loaded_player_presets.is_empty():
		return
	
	GameState.hero_known_spells = (
		loaded_player_presets.get(
			"hero_known_spells",
			[]
		)
	).duplicate(true)
	
	GameState.hero_spell_slots_level_0 = max(
		0,
		int(
			loaded_player_presets.get(
				"hero_spell_slots_level_0",
				0
			)
		)
	)
	
	GameState.hero_spell_slots_level_1 = max(
		0,
		int(
			loaded_player_presets.get(
				"hero_spell_slots_level_1",
				0
			)
		)
	)
	
	GameState.hero_spell_slots_level_2 = max(
		0,
		int(
			loaded_player_presets.get(
				"hero_spell_slots_level_2",
				0
			)
		)
	)
	
	GameState.hero_max_spell_slots_level_0 = max(
		0,
		int(
			loaded_player_presets.get(
				"hero_max_spell_slots_level_0",
				0
			)
		)
	)
	
	GameState.hero_max_spell_slots_level_1 = max(
		0,
		int(
			loaded_player_presets.get(
				"hero_max_spell_slots_level_1",
				0
			)
		)
	)
	
	GameState.hero_max_spell_slots_level_2 = max(
		0,
		int(
			loaded_player_presets.get(
				"hero_max_spell_slots_level_2",
				0
			)
		)
	)
func process_pending_hero_level_ups() -> void:
	if not is_instance_valid(hero):
		return
	
	if not hero.has_method(
		"get_pending_level_up_count"
	):
		return
	
	if hero.get_pending_level_up_count() <= 0:
		return
	
	if not is_instance_valid(level_up_panel):
		level_up_panel = (
			LevelUpPanelScript.new()
		)
		
		level_up_panel.name = (
			"LevelUpPanel"
		)
		
		add_child(level_up_panel)
	
	while (
		is_instance_valid(hero)
		and hero.get_pending_level_up_count() > 0
	):
		level_up_panel.open_for_hero(
			hero,
			hero.level + 1
		)
		
		var level_up_data: Dictionary = (
			await level_up_panel.level_up_confirmed
		)
		
		if level_up_data.is_empty():
			level_up_panel.open_for_hero(
				hero,
				hero.level + 1
			)
			
			continue
		
		var level_was_applied: bool = (
			hero.apply_level_up_result(
				level_up_data
			)
		)
		
		if not level_was_applied:
			level_up_panel.open_for_hero(
				hero,
				hero.level + 1
			)
			
			continue
		
		sync_hero_to_game_state()
		PartyManager.sync_hero_from_game_state()
	
	if is_instance_valid(level_up_panel):
		level_up_panel.hide_panel()
		level_up_panel.queue_free()
	
	level_up_panel = null
func connect_aniri_theme_trigger(
	aniri_unit: Node2D
) -> void:
	if not is_instance_valid(
		aniri_unit
	):
		return
	
	var visibility_callback := Callable(
		self,
		"on_stage_2_aniri_visibility_changed"
	).bind(
		aniri_unit
	)
	
	if not aniri_unit.visibility_changed.is_connected(
		visibility_callback
	):
		aniri_unit.visibility_changed.connect(
			visibility_callback
		)


func on_stage_2_aniri_visibility_changed(
	aniri_unit: Node2D
) -> void:
	if current_stage != 2:
		return
	
	if aniri_theme_started:
		return
	
	if not is_instance_valid(
		aniri_unit
	):
		return
	
	if not aniri_unit.visible:
		return
	
	aniri_theme_started = true
	
	if MusicManage == null:
		return
	
	MusicManage.play_music(
		ANIRI_THEME_PATH,
		75.0
	)
func get_stage_2_victory_aniri(
	intro_data: Dictionary
) -> Node2D:
	var existing_aniri: Node2D = (
		find_scenario_npc_by_id(
			"Aniri"
		)
	)
	
	if is_instance_valid(
		existing_aniri
	):
		connect_aniri_theme_trigger(
			existing_aniri
		)
		
		return existing_aniri
	
	var aniri_position: Vector2i = (
		intro_data.get(
			"aniri_position",
			Vector2i(
				24,
				7
			)
		)
	)
	
	var aniri_unit: Node2D = spawn_npc(
		"Aniri",
		aniri_position,
		"Aniri",
		"player"
	)
	
	if not is_instance_valid(
		aniri_unit
	):
		push_warning(
			"Não foi possível criar Aniri "
			+ "para o encerramento do cenário 2."
		)
		
		return null
	
	connect_aniri_theme_trigger(
		aniri_unit
	)
	
	# Aniri permanece escondida até o momento
	# de sua revelação narrativa.
	aniri_unit.visible = false
	
	# Ela aparece depois do combate e não participa
	# da iniciativa desta batalha.
	initiative_order.erase(
		aniri_unit
	)
	
	return aniri_unit


func show_story_dialogue_entries(
	dialogue_entries: Array
) -> void:
	if dialogue_entries.is_empty():
		return

	var player_name: String = (
		get_victory_player_name()
	)
	var previous_cast: Array[String] = active_cinematic_cast.duplicate()
	active_cinematic_cast.clear()
	for entry_value in dialogue_entries:
		if not entry_value is Dictionary:
			continue
		var cast_name: String = str(entry_value.get("speaker_name", "")).replace("[NOME_DO_JOGADOR]", player_name).strip_edges()
		if cast_name != "" and not active_cinematic_cast.has(cast_name):
			active_cinematic_cast.append(cast_name)

	for dialogue_entry_value in dialogue_entries:
		if not dialogue_entry_value is Dictionary:
			continue

		var dialogue_entry: Dictionary = (
			dialogue_entry_value
		)

		var speaker_name: String = str(
			dialogue_entry.get(
				"speaker_name",
				"História"
			)
		)

		var dialogue_text: String = str(
			dialogue_entry.get(
				"text",
				""
			)
		)

		speaker_name = speaker_name.replace(
			"[NOME_DO_JOGADOR]",
			player_name
		)

		dialogue_text = dialogue_text.replace(
			"[NOME_DO_JOGADOR]",
			player_name
		)

		if dialogue_text.strip_edges() == "":
			continue

		if speaker_name.strip_edges() == "":
			speaker_name = "História"

		await show_story_dialog(
			speaker_name,
			dialogue_text
		)
	active_cinematic_cast = previous_cast
func play_stage_2_victory_dialogue_sequence() -> String:
	var intro_data: Dictionary = (
		ScenarioDatabase.get_stage_2_victory_intro_data()
	)

	var choice_data: Dictionary = (
		ScenarioDatabase.get_stage_2_victory_choice_data()
	)

	var conclusion_data: Dictionary = (
		ScenarioDatabase.get_stage_2_victory_conclusion_data()
	)

	if intro_data.is_empty():
		push_warning(
			"Introdução da vitória do cenário 2 não encontrada."
		)
		return ""

	set_gameplay_panels_visible(
		false
	)

	selected_player_unit = null
	camera_follow_unit = null
	is_movement_animating = true

	clear_movement_area()
	clear_attack_area()

	var uiliam_unit: Node2D = (
		get_victory_uiliam()
	)

	var aniri_unit: Node2D = (
		get_stage_2_victory_aniri(
			intro_data
		)
	)

	if not is_instance_valid(uiliam_unit):
		push_warning(
			"Sir Uiliam não foi encontrado "
			+ "no encerramento do cenário 2."
		)

		is_movement_animating = false
		return ""

	if not is_instance_valid(aniri_unit):
		is_movement_animating = false
		return ""

	var camera_focus_position: Vector2i = (
		intro_data.get(
			"camera_focus_position",
			Vector2i(23, 8)
		)
	)

	await focus_camera_on_grid_position(
		camera_focus_position
	)

	var dialogues_before_approach: Array = (
		intro_data.get(
			"dialogues_before_approach",
			[]
		)
	)

	var opening_dialogues: Array = []
	var reveal_dialogues: Array = []
	var opening_dialogue_count: int = int(
		intro_data.get("opening_dialogue_count", 2)
	)

	for dialogue_index in range(
		dialogues_before_approach.size()
	):
		if dialogue_index < opening_dialogue_count:
			opening_dialogues.append(
				dialogues_before_approach[
					dialogue_index
				]
			)
		else:
			reveal_dialogues.append(
				dialogues_before_approach[
					dialogue_index
				]
			)

	# Uiliam observa o fim do combate e percebe
	# que há mais alguém no porão.
	await show_story_dialogue_entries(
		opening_dialogues
	)

	# Pequena pausa para representar o barulho
	# vindo da área das caixas.
	await get_tree().create_timer(
		0.65,
		true
	).timeout

	aniri_unit.visible = true

	await get_tree().create_timer(
		0.35,
		true
	).timeout

	# Aniri sai de trás das caixas.
	await show_story_dialogue_entries(
		reveal_dialogues
	)

	var uiliam_approach_position: Vector2i = (
		intro_data.get(
			"uiliam_approach_position",
			Vector2i(22, 9)
		)
	)

	var approach_path: Array[Vector2i] = (
		get_grid_path_avoiding_units(
			uiliam_unit.grid_position,
			uiliam_approach_position,
			uiliam_unit,
			9999.0,
			false
		)
	)

	if not approach_path.is_empty():
		await animate_unit_movement(
			uiliam_unit,
			approach_path
		)
	elif (
		uiliam_unit.grid_position
		!= uiliam_approach_position
	):
		push_warning(
			"Sir Uiliam não encontrou caminho "
			+ "até Aniri."
		)

	await focus_camera_on_grid_position(
		camera_focus_position
	)

	var dialogues_after_approach: Array = (
		intro_data.get(
			"dialogues_after_approach",
			[]
		)
	)

	await show_story_dialogue_entries(
		dialogues_after_approach
	)

	var choice_prompt: String = str(
		choice_data.get(
			"prompt",
			"O que devemos fazer?"
		)
	)

	var choice_options: Array = (
		choice_data.get(
			"options",
			[]
		)
	)

	var selected_choice_id: String = await (
		show_story_choice(
			choice_prompt,
			choice_options
		)
	)

	var selected_branch_dialogues: Array = []

	for option_value in choice_options:
		if not option_value is Dictionary:
			continue

		var option_data: Dictionary = (
			option_value
		)

		var option_id: String = str(
			option_data.get(
				"id",
				""
			)
		)

		if option_id != selected_choice_id:
			continue

		selected_branch_dialogues = (
			option_data.get(
				"dialogues",
				[]
			)
		)

		break

	await show_story_dialogue_entries(
		selected_branch_dialogues
	)

	var conclusion_dialogues: Array = (
		conclusion_data.get(
			"dialogues",
			[]
		)
	)

	await show_story_dialogue_entries(
		conclusion_dialogues
	)

	is_movement_animating = false

	return selected_choice_id
func play_stage_2_victory_sequence() -> bool:
	var selected_choice_id: String = await (
		play_stage_2_victory_dialogue_sequence()
	)

	if selected_choice_id.strip_edges() == "":
		push_warning(
			"O encerramento do cenário 2 terminou "
			+ "sem uma escolha válida."
		)
		return false

	MissionManager.set_story_choice(
		"aniri_judgment",
		selected_choice_id
	)

	var conclusion_data: Dictionary = (
		ScenarioDatabase
		.get_stage_2_victory_conclusion_data()
	)

	var mission_data: Dictionary = (
		conclusion_data.get(
			"mission",
			{}
		).duplicate(true)
	)

	if not mission_data.is_empty():
		mission_data["return_location"] = str(
			conclusion_data.get(
				"return_location",
				"carpenter"
			)
		)

		mission_data["target_npc"] = "Jhon"
		mission_data["future_recruit"] = "Aniri"

		MissionManager.start_mission(
			mission_data
		)

		MissionManager.update_mission_progress(
			"aniri_second_chance",
			"objects_returned",
			false
		)

		MissionManager.update_mission_progress(
			"aniri_second_chance",
			"apology_made",
			false
		)

		await show_story_dialog(
			"Missão atualizada",
			(
				str(
					mission_data.get(
						"title",
						"Uma Segunda Chance"
					)
				)
				+ "\n\n"
				+ str(
					mission_data.get(
						"description",
						""
					)
				)
			)
		)

	await process_pending_hero_level_ups()

	sync_hero_to_game_state()

	PartyManager.sync_hero_from_game_state()
	var recruit_npc_id: String = str(conclusion_data.get("recruit_npc_id", ""))
	if recruit_npc_id != "":
		PartyManager.recruit_npc(
			recruit_npc_id,
			bool(conclusion_data.get("recruit_immediately", false))
		)

	# Se o jogador concluiu o cenário 2, necessariamente
	# já assistiu à história inicial da taverna.
	# Isso também repara saves antigos que perderam o evento.
	var tavern_event_was_preserved: bool = (
		SaveManager.mark_story_event_completed(
			"tavern_uiliam_history"
		)
	)

	if not tavern_event_was_preserved:
		push_warning(
			"Não foi possível reparar imediatamente "
			+ "o evento inicial da taverna."
		)

	current_stage += 1

	GameState.selected_stage = (
		current_stage
	)

	GameState.current_location = "village"

	# Retorna especificamente para a carpintaria.
	var save_was_created: bool = (
		save_auto_game(
			"village",
			"carpenter"
		)
	)

	if not save_was_created:
		push_warning(
			"Não foi possível salvar o encerramento "
			+ "do cenário 2."
		)
		return false

	var next_scene_path: String = str(
		conclusion_data.get(
			"return_scene",
			"res://Scene/village.tscn"
		)
	).strip_edges()

	if next_scene_path == "":
		next_scene_path = (
			"res://Scene/village.tscn"
		)

	if not ResourceLoader.exists(
		next_scene_path
	):
		push_warning(
			"Cena de retorno não encontrada: "
			+ next_scene_path
		)
		return false

	if MusicManage != null:
		MusicManage.fade_out_music(
			1.0
		)

	await fade_out_scenario_transition(
		1.0
	)

	get_tree().change_scene_to_file(
		next_scene_path
	)

	return true
func find_free_scenario_arrival_cell(
	preferred_position: Vector2i,
	excluded_position: Vector2i = Vector2i(-1, -1)
) -> Vector2i:
	for radius in range(9):
		for offset_x in range(
			-radius,
			radius + 1
		):
			for offset_y in range(
				-radius,
				radius + 1
			):
				if (
					abs(offset_x)
					+ abs(offset_y)
					!= radius
				):
					continue
				
				var candidate: Vector2i = (
					preferred_position
					+ Vector2i(
						offset_x,
						offset_y
					)
				)
				
				if candidate == excluded_position:
					continue
				
				if is_grid_position_blocked_for_path(
					candidate,
					null
				):
					continue
				
				return candidate
	
	return Vector2i(-1, -1)
