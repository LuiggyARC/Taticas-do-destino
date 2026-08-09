extends Node

var should_load_save: bool = false
var selected_save_path: String = ""
var selected_stage: int = 1

var player_name: String = "Herói"
var player_class: String = "Guerreiro"

var hero_max_hp: int = 100
var hero_attack_power: int = 20
var hero_max_movement_meters: float = 9.0

var hero_level: int = 1
var hero_total_xp: int = 0
var hero_xp_to_next_level: int = 1000
var hero_max_level: int = 20
