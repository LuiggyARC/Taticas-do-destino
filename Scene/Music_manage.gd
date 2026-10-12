extends Node

const INTRO_MUSIC_PATH := "res://Assets/Audio/intro_theme.mp3"
const MUSIC_BUS_NAME := "Music"

var music_player: AudioStreamPlayer
var should_loop_music: bool = true
var music_tween: Tween

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_music_volume_percent(70.0)
	
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.bus = MUSIC_BUS_NAME
	
	add_child(music_player)
	
	music_player.finished.connect(
		restart_music
	)


func play_intro_music():
	if music_player == null:
		print("MusicPlayer ainda não foi criado.")
		return
	
	if music_player.playing:
		return
	
	if not ResourceLoader.exists(INTRO_MUSIC_PATH):
		print("Música da intro não encontrada: ", INTRO_MUSIC_PATH)
		return
	
	var music_stream = load(INTRO_MUSIC_PATH)
	
	if music_stream == null:
		print("Falha ao carregar música: ", INTRO_MUSIC_PATH)
		return
	
	should_loop_music = true
	
	music_player.stream = music_stream
	music_player.volume_db = 0.0
	music_player.play()
	
	print("Música da intro iniciada em loop.")


func restart_music():
	if not should_loop_music:
		return
	
	if music_player == null:
		return
	
	if music_player.stream == null:
		return
	
	music_player.play()


func stop_music():
	if music_player == null:
		return
	
	should_loop_music = false
	music_player.stop()


func fade_out_music(
	duration: float = 2.0
) -> void:
	if music_player == null:
		return
	
	if not music_player.playing:
		return
	
	if is_instance_valid(music_tween):
		music_tween.kill()
	
	should_loop_music = false
	
	music_tween = create_tween()
	
	music_tween.tween_property(
		music_player,
		"volume_db",
		-40.0,
		max(
			0.01,
			duration
		)
	)
	
	music_tween.finished.connect(
		stop_music
	)
	
func play_music(
	music_path: String,
	volume_percent: float = 100.0
):
	if music_path == "":
		return
	
	if music_player == null:
		print("MusicPlayer ainda não foi criado.")
		return
	
	if not ResourceLoader.exists(music_path):
		print(
			"Arquivo de música não encontrado: ",
			music_path
		)
		return
	
	var stream: AudioStream = load(music_path)
	
	if stream == null:
		print(
			"Não foi possível carregar a música: ",
			music_path
		)
		return
	
	if music_tween != null:
		music_tween.kill()
		music_tween = null
	
	if stream is AudioStreamMP3:
		stream.loop = true
	elif stream is AudioStreamOggVorbis:
		stream.loop = true
	
	var safe_volume_percent: float = clamp(
		volume_percent,
		0.0,
		100.0
	)
	
	var target_volume_db: float = -70.0
	
	if safe_volume_percent > 0.0:
		target_volume_db = linear_to_db(
			safe_volume_percent / 100.0
		)
	
	should_loop_music = true
	
	music_player.stop()
	music_player.stream = stream
	
	music_player.volume_db = (
		target_volume_db - 5.0
	)
	
	music_player.play()
	
	music_tween = create_tween()
	
	music_tween.tween_property(
		music_player,
		"volume_db",
		target_volume_db,
		1.0
	)
	
	print(
		"Música iniciada em loop: ",
		music_path,
		" | volume: ",
		safe_volume_percent,
		"%"
	)


func set_music_volume_percent(value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(MUSIC_BUS_NAME)
	if bus_index == -1:
		AudioServer.add_bus(AudioServer.get_bus_count())
		bus_index = AudioServer.get_bus_count() - 1
		AudioServer.set_bus_name(bus_index, MUSIC_BUS_NAME)
		AudioServer.set_bus_send(bus_index, "Master")
	var clamped_value: float = clampf(value, 0.0, 100.0)
	var volume_db: float = -80.0
	if clamped_value > 0.0:
		volume_db = linear_to_db(clamped_value / 100.0)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
