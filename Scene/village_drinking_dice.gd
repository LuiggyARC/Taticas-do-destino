extends Control
class_name VillageDrinkingDice

var title_label: Label
var left_label: Label
var right_label: Label
var result_label: Label

func _ready() -> void:
	name = "VillageDrinkingDice"
	z_index = 800
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.color = Color(0.0, 0.0, 0.0, 0.77)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 300)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.05, 0.04, 0.98)
	style.border_color = Color(0.78, 0.58, 0.28)
	style.set_border_width_all(3)
	style.set_corner_radius_all(14)
	style.set_content_margin_all(22)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 20)
	panel.add_child(column)
	title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 28)
	column.add_child(title_label)
	var dice_row := HBoxContainer.new()
	dice_row.alignment = BoxContainer.ALIGNMENT_CENTER
	dice_row.add_theme_constant_override("separation", 50)
	column.add_child(dice_row)
	left_label = Label.new()
	right_label = Label.new()
	for die_label in [left_label, right_label]:
		die_label.custom_minimum_size = Vector2(190, 100)
		die_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		die_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		die_label.add_theme_font_size_override("font_size", 30)
		die_label.add_theme_color_override("font_color", Color(1.0, 0.89, 0.65))
		dice_row.add_child(die_label)
	result_label = Label.new()
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.add_theme_font_size_override("font_size", 24)
	column.add_child(result_label)

func roll_duel(first_name: String, second_name: String) -> Dictionary:
	title_label.text = "TESTE DE BEBIDA — 2d20"
	result_label.text = "Os dados estão rolando..."
	var first_roll: int = 0
	var second_roll: int = 0
	while true:
		for animation_step in range(9):
			left_label.text = first_name + "\nD20  " + str(randi_range(1, 20))
			right_label.text = second_name + "\nD20  " + str(randi_range(1, 20))
			await get_tree().create_timer(0.10).timeout
		first_roll = randi_range(1, 20)
		second_roll = randi_range(1, 20)
		left_label.text = first_name + "\nD20  " + str(first_roll)
		right_label.text = second_name + "\nD20  " + str(second_roll)
		if first_roll != second_roll:
			break
		result_label.text = "Empate! Nova rodada."
		await get_tree().create_timer(0.9).timeout
	result_label.text = (first_name if first_roll > second_roll else second_name) + " venceu!"
	await get_tree().create_timer(1.6).timeout
	return {"first": first_roll, "second": second_roll, "first_won": first_roll > second_roll}
