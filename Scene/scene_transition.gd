extends CanvasLayer

const DEFAULT_DURATION := 0.45

var transition_overlay: ColorRect
var is_transitioning: bool = false
var queued_scene_path: String = ""


func _ready() -> void:
	layer = 200
	process_mode = Node.PROCESS_MODE_ALWAYS
	transition_overlay = ColorRect.new()
	transition_overlay.name = "SceneTransitionOverlay"
	transition_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	transition_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_overlay.visible = false
	add_child(transition_overlay)
	transition_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func change_scene_to_file(scene_path: String, duration: float = DEFAULT_DURATION) -> bool:
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		push_warning("Cena de destino não encontrada: " + scene_path)
		return false
	if is_transitioning:
		# Uma cena recém-aberta pode redirecionar o jogador durante o próprio _ready.
		# Mantenha o fade fechado até o destino final para não mostrar a cena intermediária.
		queued_scene_path = scene_path
		return true
	is_transitioning = true
	transition_overlay.visible = true
	transition_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	transition_overlay.color.a = 0.0
	await _fade_to(1.0, duration)
	var destination: String = scene_path
	while not destination.is_empty():
		var result: Error = get_tree().change_scene_to_file(destination)
		if result != OK:
			push_warning("Não foi possível abrir a cena: " + destination)
			await _fade_to(0.0, duration)
			_finish_transition()
			return false
		await get_tree().scene_changed
		destination = queued_scene_path
		queued_scene_path = ""
	await _fade_to(0.0, duration)
	_finish_transition()
	if not queued_scene_path.is_empty():
		var late_destination: String = queued_scene_path
		queued_scene_path = ""
		change_scene_to_file(late_destination, duration)
	return true


func _fade_to(alpha: float, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(transition_overlay, "color:a", alpha, maxf(0.05, duration))
	await tween.finished


func _finish_transition() -> void:
	transition_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_overlay.visible = false
	is_transitioning = false
