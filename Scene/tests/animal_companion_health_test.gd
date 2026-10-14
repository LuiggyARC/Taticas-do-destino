extends Node

const CompanionScene = preload("res://Scene/units/AnimalCompanion.tscn")


func _ready() -> void:
	var companion: Node2D = CompanionScene.instantiate()
	add_child(companion)
	companion.setup_companion("Pantera", "Druida", 2)

	var name_label: Label = companion.get_node("HealthNameLabel")
	var background: ColorRect = companion.get_node("HealthBarBackground")
	var fill: ColorRect = background.get_node("HealthBarFill")
	assert(name_label.text == "Pantera")
	assert(name_label.position.y < 0)
	assert(background.position.y < 0)
	assert(is_equal_approx(fill.size.x, 50.0))

	companion.take_damage(5)
	var expected_width: float = 50.0 * float(companion.hp) / float(companion.max_hp)
	assert(is_equal_approx(fill.size.x, expected_width))

	companion.heal(5)
	assert(is_equal_approx(fill.size.x, 50.0))
	print("Animal companion health display test passed")
	get_tree().quit(0)
