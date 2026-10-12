extends CanvasLayer
const THUNDER_SOUND_1: AudioStream = preload(
	"res://Assets/Audio/SFX/Tunder1.mp3"
)

const THUNDER_SOUND_2: AudioStream = preload(
	"res://Assets/Audio/SFX/Tunder2.mp3"
)

const THUNDER_SOUNDS: Array[AudioStream] = [
	THUNDER_SOUND_1,
	THUNDER_SOUND_2
]
var weather_root: Control
var lightning_overlay: ColorRect
var rain_drops: Array[ColorRect] = []
var thunder_audio_player: AudioStreamPlayer

var rain_enabled: bool = false
var lightning_enabled: bool = false

var rain_speed: float = 850.0
var rain_drift: float = -110.0

var lightning_min_interval: float = 15.0
var lightning_max_interval: float = 30.0
var lightning_timer: float = 5.0
var lightning_in_progress: bool = false


func _ready() -> void:
	layer = 0
	
	create_interface()
	create_thunder_audio_player()
	
	set_process(false)

func create_thunder_audio_player() -> void:
	if is_instance_valid(thunder_audio_player):
		return
	
	thunder_audio_player = AudioStreamPlayer.new()
	thunder_audio_player.name = "ThunderAudioPlayer"
	thunder_audio_player.volume_db = 0.0
	thunder_audio_player.bus = "Sfx"
	
	add_child(thunder_audio_player)

func play_random_thunder_sound() -> void:
	if not is_instance_valid(thunder_audio_player):
		return
	
	if THUNDER_SOUNDS.is_empty():
		return
	
	var random_index: int = randi_range(
		0,
		THUNDER_SOUNDS.size() - 1
	)
	
	thunder_audio_player.stop()
	thunder_audio_player.stream = (
		THUNDER_SOUNDS[random_index]
	)
	thunder_audio_player.play()

func create_interface() -> void:
	weather_root = Control.new()
	weather_root.name = "WeatherRoot"
	weather_root.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	
	add_child(weather_root)
	
	update_weather_size()
	
	lightning_overlay = ColorRect.new()
	lightning_overlay.name = "LightningOverlay"
	lightning_overlay.position = Vector2.ZERO
	lightning_overlay.size = (
		get_viewport_size()
	)
	lightning_overlay.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)
	lightning_overlay.color = Color(
		0.88,
		0.94,
		1.0,
		0.0
	)
	
	weather_root.add_child(
		lightning_overlay
	)


func configure(
	weather_data: Dictionary
) -> void:
	clear_rain()
	
	rain_enabled = bool(
		weather_data.get(
			"rain_enabled",
			false
		)
	)
	
	lightning_enabled = bool(
		weather_data.get(
			"lightning_enabled",
			false
		)
	)
	
	rain_speed = float(
		weather_data.get(
			"rain_speed",
			850.0
		)
	)
	
	rain_drift = float(
		weather_data.get(
			"rain_drift",
			-110.0
		)
	)
	
	lightning_min_interval = float(
		weather_data.get(
			"lightning_min_interval",
			15.0
		)
	)
	
	lightning_max_interval = float(
		weather_data.get(
			"lightning_max_interval",
			30.0
		)
	)
	
	lightning_timer = randf_range(
		lightning_min_interval,
		lightning_max_interval
	)
	
	update_weather_size()
	
	if rain_enabled:
		var rain_count: int = int(
			weather_data.get(
				"rain_count",
				140
			)
		)
		
		create_rain(
			max(
				rain_count,
				1
			)
		)
	
	visible = (
		rain_enabled
		or lightning_enabled
	)
	
	set_process(visible)


func create_rain(rain_count: int) -> void:
	if not is_instance_valid(weather_root):
		return
	
	var viewport_size: Vector2 = (
		get_viewport_size()
	)
	
	for drop_index in range(rain_count):
		var drop := ColorRect.new()
		drop.name = "RainDrop"
		drop.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)
		
		drop.size = Vector2(
			randf_range(
				1.0,
				2.2
			),
			randf_range(
				14.0,
				27.0
			)
		)
		
		drop.position = Vector2(
			randf_range(
				0.0,
				viewport_size.x
			),
			randf_range(
				-viewpoint_height(),
				viewport_size.y
			)
		)
		
		drop.rotation = -0.12
		
		drop.color = Color(
			0.68,
			0.82,
			1.0,
			randf_range(
				0.28,
				0.62
			)
		)
		
		weather_root.add_child(drop)
		weather_root.move_child(
			drop,
			0
		)
		
		rain_drops.append(drop)


func _process(delta: float) -> void:
	update_weather_size()
	
	if rain_enabled:
		update_rain(delta)
	
	if lightning_enabled:
		update_lightning(delta)


func update_rain(delta: float) -> void:
	var viewport_size: Vector2 = (
		get_viewport_size()
	)
	
	for drop in rain_drops:
		if not is_instance_valid(drop):
			continue
		
		drop.position += Vector2(
			rain_drift,
			rain_speed
		) * delta
		
		if (
			drop.position.y
			> viewport_size.y + 30.0
		):
			drop.position = Vector2(
				randf_range(
					0.0,
					viewport_size.x + 120.0
				),
				randf_range(
					-160.0,
					-20.0
				)
			)


func update_lightning(delta: float) -> void:
	if lightning_in_progress:
		return
	
	lightning_timer -= delta
	
	if lightning_timer > 0.0:
		return
	
	flash_lightning()
	
	lightning_timer = randf_range(
		lightning_min_interval,
		lightning_max_interval
	)


func flash_lightning() -> void:
	if not is_instance_valid(
		lightning_overlay
	):
		return
	
	lightning_in_progress = true
	lightning_overlay.color.a = 0.0
	
	play_random_thunder_sound()
	
	var lightning_tween := create_tween()
	
	lightning_tween.tween_property(
		lightning_overlay,
		"color:a",
		0.68,
		0.05
	)
	
	lightning_tween.tween_property(
		lightning_overlay,
		"color:a",
		0.08,
		0.10
	)
	
	lightning_tween.tween_interval(
		0.07
	)
	
	lightning_tween.tween_property(
		lightning_overlay,
		"color:a",
		0.42,
		0.04
	)
	
	lightning_tween.tween_property(
		lightning_overlay,
		"color:a",
		0.0,
		0.22
	)
	
	lightning_tween.tween_callback(
		finish_lightning
	)


func finish_lightning() -> void:
	lightning_in_progress = false


func clear_rain() -> void:
	for drop in rain_drops:
		if is_instance_valid(drop):
			drop.queue_free()
	
	rain_drops.clear()


func update_weather_size() -> void:
	var viewport_size: Vector2 = (
		get_viewport_size()
	)
	
	if is_instance_valid(weather_root):
		weather_root.position = Vector2.ZERO
		weather_root.size = viewport_size
	
	if is_instance_valid(lightning_overlay):
		lightning_overlay.position = Vector2.ZERO
		lightning_overlay.size = viewport_size


func get_viewport_size() -> Vector2:
	if not is_instance_valid(get_viewport()):
		return Vector2(
			1280,
			720
		)
	
	return get_viewport().get_visible_rect().size


func viewpoint_height() -> float:
	return max(
		get_viewport_size().y,
		1.0
	)
