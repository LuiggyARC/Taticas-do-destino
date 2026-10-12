extends Node

const HOVER_SFX_PATH := "res://Assets/Audio/SFX/ui_hover.wav"
const CLICK_SFX_PATH := "res://Assets/Audio/SFX/ui_click.wav"
const CONFIRM_SFX_PATH := "res://Assets/Audio/SFX/ui_confirm.wav"
const BACK_SFX_PATH := "res://Assets/Audio/SFX/ui_back.wav"
const ERROR_SFX_PATH := "res://Assets/Audio/SFX/ui_error.wav"
const SELECT_SFX_PATH := "res://Assets/Audio/SFX/ui_select.wav"
const RAGE_SFX_PATH := "res://Assets/Audio/SFX/rage_activate.wav"
const DICE_ROLL_SFX_PATH := (
	"res://Assets/Audio/SFX/dice-roll-sound.mp3"
)
const GOBLIN_HIT_SFX_PATHS: Array[String] = [
	"res://Assets/Audio/SFX/Goblin.hited.mp3",
	"res://Assets/Audio/SFX/Goblin.hited2.mp3"
]
const GOBLIN_INTRO_SFX_PATH := "res://Assets/Audio/SFX/Goblinsintro.mp3"
const RAT_INTRO_SFX_PATH := "res://Assets/Audio/SFX/Ratsintro.mp3"
const RAT_HIT_SFX_PATHS: Array[String] = [
	"res://Assets/Audio/SFX/RatsHited.mp3",
	"res://Assets/Audio/SFX/HatsHited2.mp3"
]
const CANINE_INTRO_SFX_PATHS: Array[String] = [
	"res://Assets/Audio/SFX/Wolfintro.mp3",
	"res://Assets/Audio/SFX/Wolfintro (2).mp3",
	"res://Assets/Audio/SFX/Wolfintro (3).mp3"
]
const CANINE_HIT_SFX_PATHS: Array[String] = [
	"res://Assets/Audio/SFX/Doghited.mp3",
	"res://Assets/Audio/SFX/Doghited (2).mp3",
	"res://Assets/Audio/SFX/Doghited (3).mp3"
]
const MAGIC_MISSILE_SFX_PATH := "res://Assets/Audio/SFX/MagicMissle.wav"
const HEAL_SFX_PATH := "res://Assets/Audio/SFX/curasound.mp3"
const NATURE_SFX_PATH := "res://Assets/Audio/SFX/Enrredar,espinhossound.wav"
const THUNDER_SFX_PATHS: Array[String] = [
	"res://Assets/Audio/SFX/Tunder1.mp3",
	"res://Assets/Audio/SFX/Tunder2.mp3"
]
const SWORD_HIT_SFX_PATH := "res://Assets/Audio/SFX/Swordatacksucsses.mp3"
const HEAVY_HIT_SFX_PATH := "res://Assets/Audio/SFX/AxesHammercksucsses.mp3"
const ARROW_HIT_SFX_PATH := "res://Assets/Audio/SFX/Arrow.mp3"
const ATTACK_MISS_SFX_PATH := "res://Assets/Audio/SFX/Failataque.mp3"
const SFX_BUS_NAME := "Sfx"

const DICE_ROLL_VOLUME_BOOST_DB := 6.0
var hover_stream: AudioStream
var click_stream: AudioStream
var confirm_stream: AudioStream
var back_stream: AudioStream
var error_stream: AudioStream
var select_stream: AudioStream
var rage_stream: AudioStream
var dice_roll_stream: AudioStream
var goblin_hit_streams: Array[AudioStream] = []
var goblin_intro_stream: AudioStream
var rat_intro_stream: AudioStream
var rat_hit_streams: Array[AudioStream] = []
var canine_intro_streams: Array[AudioStream] = []
var canine_hit_streams: Array[AudioStream] = []
var magic_missile_stream: AudioStream
var heal_stream: AudioStream
var nature_stream: AudioStream
var thunder_streams: Array[AudioStream] = []
var sword_hit_stream: AudioStream
var heavy_hit_stream: AudioStream
var arrow_hit_stream: AudioStream
var attack_miss_stream: AudioStream


var players: Array[AudioStreamPlayer] = []
var current_player_index: int = 0
var sfx_volume_db: float = 0.0


func _ready():
	ensure_sfx_bus()
	set_sfx_volume_percent(110.0)
	load_sfx()
	create_audio_pool()


func load_sfx():
	hover_stream = load(HOVER_SFX_PATH)
	click_stream = load(CLICK_SFX_PATH)
	confirm_stream = load(CONFIRM_SFX_PATH)
	back_stream = load(BACK_SFX_PATH)
	error_stream = load(ERROR_SFX_PATH)
	select_stream = load(SELECT_SFX_PATH)
	rage_stream = load(RAGE_SFX_PATH)
	dice_roll_stream = load(DICE_ROLL_SFX_PATH)
	magic_missile_stream = load(MAGIC_MISSILE_SFX_PATH)
	heal_stream = load(HEAL_SFX_PATH)
	nature_stream = load(NATURE_SFX_PATH)
	if magic_missile_stream == null:
		push_warning("Som de magia não encontrado: " + MAGIC_MISSILE_SFX_PATH)
	if heal_stream == null:
		push_warning("Som de cura não encontrado: " + HEAL_SFX_PATH)
	if nature_stream == null:
		push_warning("Som de natureza não encontrado: " + NATURE_SFX_PATH)
	thunder_streams.clear()
	for sound_path in THUNDER_SFX_PATHS:
		var thunder_stream: AudioStream = load(sound_path)
		if thunder_stream != null:
			thunder_streams.append(thunder_stream)
	sword_hit_stream = load(SWORD_HIT_SFX_PATH)
	heavy_hit_stream = load(HEAVY_HIT_SFX_PATH)
	arrow_hit_stream = load(ARROW_HIT_SFX_PATH)
	attack_miss_stream = load(ATTACK_MISS_SFX_PATH)
	
	goblin_hit_streams.clear()
	
	for sound_path in GOBLIN_HIT_SFX_PATHS:
		var goblin_stream: AudioStream = load(sound_path)
		
		if goblin_stream != null:
			goblin_hit_streams.append(goblin_stream)
		else:
			print(
				"Som de goblin não encontrado: ",
				sound_path
			)
	goblin_intro_stream = load(GOBLIN_INTRO_SFX_PATH)
	rat_intro_stream = load(RAT_INTRO_SFX_PATH)
	rat_hit_streams = load_stream_variants(RAT_HIT_SFX_PATHS)
	canine_intro_streams = load_stream_variants(CANINE_INTRO_SFX_PATHS)
	canine_hit_streams = load_stream_variants(CANINE_HIT_SFX_PATHS)
	if goblin_intro_stream == null:
		push_warning("Som de introdução não encontrado: " + GOBLIN_INTRO_SFX_PATH)
	if rat_intro_stream == null:
		push_warning("Som de introdução não encontrado: " + RAT_INTRO_SFX_PATH)


func load_stream_variants(paths: Array[String]) -> Array[AudioStream]:
	var streams: Array[AudioStream] = []
	for sound_path in paths:
		var sound_stream: AudioStream = load(sound_path)
		if sound_stream != null:
			streams.append(sound_stream)
		else:
			push_warning("Efeito sonoro não encontrado: " + sound_path)
	return streams
	
func play_rage():
	play_stream(rage_stream)

func play_dice_roll():
	play_stream(
		dice_roll_stream,
		DICE_ROLL_VOLUME_BOOST_DB
	)

func create_audio_pool():
	for i in range(8):
		var player := AudioStreamPlayer.new()
		player.name = "UISfxPlayer" + str(i)
		player.volume_db = sfx_volume_db
		player.bus = SFX_BUS_NAME
		add_child(player)
		players.append(player)


func play_stream(
	stream: AudioStream,
	volume_offset_db: float = 0.0
):
	if stream == null:
		return
	
	if players.is_empty():
		return
	
	var player: AudioStreamPlayer = players[
		current_player_index
	]
	
	current_player_index += 1
	
	if current_player_index >= players.size():
		current_player_index = 0
	
	player.stop()
	player.stream = stream
	player.volume_db = (
		sfx_volume_db
		+ volume_offset_db
	)
	player.play()


func play_hover():
	play_stream(hover_stream)


func play_click():
	play_stream(click_stream)


func play_confirm():
	play_stream(confirm_stream)


func play_back():
	play_stream(back_stream)


func play_error():
	play_stream(error_stream)


func play_select():
	play_stream(select_stream)


func set_sfx_volume_percent(value: float):
	var clamped_value: float = clampf(value, 0.0, 110.0)
	var bus_index: int = ensure_sfx_bus()
	
	if clamped_value <= 0.0:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(clamped_value / 100.0))


func ensure_sfx_bus() -> int:
	var bus_index: int = AudioServer.get_bus_index(SFX_BUS_NAME)
	if bus_index == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, SFX_BUS_NAME)
		AudioServer.set_bus_send(bus_index, "Master")
	return bus_index


func play_spell(spell_name: String, spell_data: Dictionary = {}) -> void:
	var lower_name: String = spell_name.to_lower()
	var effect: String = str(spell_data.get("effect", ""))
	if effect == "heal" or "cura" in lower_name or "curar" in lower_name:
		play_stream(heal_stream)
	elif "enredar" in lower_name or "espinhos" in lower_name:
		play_stream(nature_stream)
	elif "chocante" in lower_name or "trovão" in lower_name or "raio elétrico" in lower_name:
		if not thunder_streams.is_empty():
			play_stream(thunder_streams.pick_random())
	else:
		# As demais magias usam o som arcano até receberem um arquivo próprio.
		play_stream(magic_missile_stream)


func play_attack_result(hit: bool, weapon_name: String, weapon_type: String) -> void:
	if not hit:
		play_stream(attack_miss_stream)
		return
	var lower_name: String = weapon_name.to_lower()
	if weapon_type == "ranged" or "arco" in lower_name or "flecha" in lower_name or "besta" in lower_name:
		play_stream(arrow_hit_stream)
	elif "machado" in lower_name or "martelo" in lower_name or "maça" in lower_name or "maca" in lower_name or "clava" in lower_name:
		play_stream(heavy_hit_stream)
	elif "espada" in lower_name or "adaga" in lower_name or "faca" in lower_name or "sabre" in lower_name or "lâmina" in lower_name or "lamina" in lower_name:
		play_stream(sword_hit_stream)
func play_goblin_hit():
	if goblin_hit_streams.is_empty():
		return
	
	var selected_stream: AudioStream = (
		goblin_hit_streams.pick_random()
	)
	
	play_stream(selected_stream)


func get_enemy_sound_family(monster_id: String) -> String:
	var lower_id: String = monster_id.to_lower()
	if "goblin" in lower_id:
		return "goblin"
	if "rato" in lower_id or "rat" in lower_id:
		return "rat"
	if "lobo" in lower_id or "cão" in lower_id or "cao" in lower_id:
		return "canine"
	return ""


func play_enemy_intro(monster_id: String) -> bool:
	match get_enemy_sound_family(monster_id):
		"goblin":
			if goblin_intro_stream != null:
				play_stream(goblin_intro_stream)
				return true
		"rat":
			if rat_intro_stream != null:
				play_stream(rat_intro_stream)
				return true
		"canine":
			if not canine_intro_streams.is_empty():
				play_stream(canine_intro_streams.pick_random())
				return true
	return false


func play_enemy_hit(monster_id: String) -> void:
	match get_enemy_sound_family(monster_id):
		"goblin":
			if not goblin_hit_streams.is_empty():
				play_stream(goblin_hit_streams.pick_random())
		"rat":
			if not rat_hit_streams.is_empty():
				play_stream(rat_hit_streams.pick_random())
		"canine":
			if not canine_hit_streams.is_empty():
				play_stream(canine_hit_streams.pick_random())
