extends Node

signal victory_confirmed
signal defeat_confirmed

var victory_dialog: AcceptDialog
var defeat_dialog: AcceptDialog
var ui_parent: CanvasLayer


func setup(
	new_ui_parent: CanvasLayer
) -> void:
	if not is_instance_valid(new_ui_parent):
		return
	
	ui_parent = new_ui_parent
	
	clear_dialog_references()
	create_victory_dialog()
	create_defeat_dialog()


func clear_dialog_references() -> void:
	if is_instance_valid(victory_dialog):
		victory_dialog.queue_free()
	
	if is_instance_valid(defeat_dialog):
		defeat_dialog.queue_free()
	
	victory_dialog = null
	defeat_dialog = null


func create_victory_dialog() -> void:
	if not is_instance_valid(ui_parent):
		return
	
	var old_dialog := ui_parent.get_node_or_null(
		"VictoryPopup"
	)
	
	if is_instance_valid(old_dialog):
		old_dialog.queue_free()
	
	victory_dialog = AcceptDialog.new()
	victory_dialog.name = "VictoryPopup"
	victory_dialog.title = "Vitória"
	victory_dialog.dialog_text = (
		"Você derrotou o monstro."
	)
	victory_dialog.ok_button_text = "Continuar"
	victory_dialog.size = Vector2(
		760 if OS.has_feature("mobile") else 520,
		650 if OS.has_feature("mobile") else 360
	)
	if OS.has_feature("mobile"):
		victory_dialog.get_label().add_theme_font_size_override("font_size", 28)
		victory_dialog.get_ok_button().add_theme_font_size_override("font_size", 30)
		victory_dialog.get_ok_button().custom_minimum_size = Vector2(240, 76)
	
	victory_dialog.confirmed.connect(
		emit_victory_confirmed
	)
	
	ui_parent.add_child(victory_dialog)


func create_defeat_dialog() -> void:
	if not is_instance_valid(ui_parent):
		return
	
	var old_dialog := ui_parent.get_node_or_null(
		"DefeatPopup"
	)
	
	if is_instance_valid(old_dialog):
		old_dialog.queue_free()
	
	defeat_dialog = AcceptDialog.new()
	defeat_dialog.name = "DefeatPopup"
	defeat_dialog.title = "Derrota"
	defeat_dialog.dialog_text = (
		"O herói foi derrotado."
	)
	defeat_dialog.ok_button_text = (
		"Carregar último save"
	)
	defeat_dialog.size = Vector2(
		700 if OS.has_feature("mobile") else 480,
		350 if OS.has_feature("mobile") else 220
	)
	if OS.has_feature("mobile"):
		defeat_dialog.get_label().add_theme_font_size_override("font_size", 30)
		defeat_dialog.get_ok_button().add_theme_font_size_override("font_size", 28)
		defeat_dialog.get_ok_button().custom_minimum_size = Vector2(340, 76)
	
	defeat_dialog.confirmed.connect(
		emit_defeat_confirmed
	)
	
	ui_parent.add_child(
		defeat_dialog
	)

func show_victory(
	result_data: Dictionary
) -> void:
	if not is_instance_valid(victory_dialog):
		return
	
	var stage_text: String = str(
		result_data.get(
			"stage",
			"-"
		)
	)
	
	var defeated_enemies_text: String = str(
		result_data.get(
			"defeated_enemies",
			0
		)
	)
	
	var gained_xp_text: String = str(
		result_data.get(
			"gained_xp",
			0
		)
	)
	
	var gained_gold_text: String = str(
		result_data.get(
			"gained_gold",
			0
		)
	)
	
	var hero_level_text: String = str(
		result_data.get(
			"hero_level",
			"-"
		)
	)
	
	var hero_xp_text: String = str(
		result_data.get(
			"hero_xp",
			"-"
		)
	)
	
	var hero_hp_text: String = str(
		result_data.get(
			"hero_hp",
			"-"
		)
	)
	
	var hero_gold_text: String = str(
		result_data.get(
			"hero_gold",
			"-"
		)
	)
	
	var lines: Array[String] = [
		"Vitória!",
		"",
		"Cenário concluído: "
		+ stage_text,
		"Inimigos derrotados: "
		+ defeated_enemies_text,
		"XP ganho nesta batalha: "
		+ gained_xp_text,
		"Ouro ganho nesta batalha: "
		+ gained_gold_text,
		"",
		"Nível atual: "
		+ hero_level_text,
		"XP atual: "
		+ hero_xp_text,
		"HP atual: "
		+ hero_hp_text,
		"Ouro total: "
		+ hero_gold_text,
		"",
		"A ameaça da fenda continua em Aviant."
	]
	
	victory_dialog.title = "Vitória"
	victory_dialog.dialog_text = "\n".join(
		lines
	)
	
	victory_dialog.popup_centered()


func show_defeat() -> void:
	if not is_instance_valid(defeat_dialog):
		return
	
	defeat_dialog.dialog_text = (
		"O herói caiu em batalha.\n\n"
		+ "As criaturas da fenda continuam "
		+ "avançando por Aviant."
	)
	
	defeat_dialog.popup_centered()


func emit_victory_confirmed() -> void:
	victory_confirmed.emit()


func emit_defeat_confirmed() -> void:
	defeat_confirmed.emit()


func get_victory_dialog() -> AcceptDialog:
	return victory_dialog


func get_defeat_dialog() -> AcceptDialog:
	return defeat_dialog
