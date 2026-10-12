extends RefCounted

# Allows a drag started on a card or button to reach its ScrollContainer.
static func enable(scroll_container: ScrollContainer) -> void:
	if not is_instance_valid(scroll_container):
		return
	scroll_container.scroll_deadzone = 4
	for child in scroll_container.get_children():
		_enable_descendants(child)


static func _enable_descendants(node: Node) -> void:
	if node is Control:
		(node as Control).mouse_filter = Control.MOUSE_FILTER_PASS
	for child in node.get_children():
		_enable_descendants(child)
