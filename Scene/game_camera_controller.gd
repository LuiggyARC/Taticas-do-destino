extends Camera2D


signal manual_control_started(
	block_player_click: bool
)


@export_range(0.1, 3.0, 0.1)
var drag_sensitivity: float = 1.0

var manual_control_enabled: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if not manual_control_enabled:
		return
	
	if event is InputEventScreenDrag:
		move_camera_from_drag(
			event.relative,
			true
		)
		return
	
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(
			MOUSE_BUTTON_LEFT
		):
			move_camera_from_drag(
				event.relative,
				true
			)
			return
		
		if Input.is_mouse_button_pressed(
			MOUSE_BUTTON_MIDDLE
		):
			move_camera_from_drag(
				event.relative,
				false
			)


func move_camera_from_drag(
	drag_relative: Vector2,
	block_player_click: bool
) -> void:
	if drag_relative == Vector2.ZERO:
		return
	
	manual_control_started.emit(
		block_player_click
	)
	
	var safe_zoom := Vector2(
		max(zoom.x, 0.01),
		max(zoom.y, 0.01)
	)
	
	global_position -= (
		drag_relative
		/ safe_zoom
		* drag_sensitivity
	)
	
	get_viewport().set_input_as_handled()
