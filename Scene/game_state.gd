extends Node

var should_load_save: bool = false
var selected_save_path: String = ""
var selected_stage: int = 1

var player_name: String = "Herói"
var player_class: String = "Sem Classe"
var player_race: String = "Humano"

var hero_max_hp: int = 100
var hero_attack_power: int = 20
var hero_max_movement_meters: float = 9.0

var hero_level: int = 1
var hero_total_xp: int = 0
var hero_xp_to_next_level: int = 1000
var hero_max_level: int = 20

var hero_strength: int = 10      # FOR
var hero_dexterity: int = 10     # DES
var hero_constitution: int = 10  # CON
var hero_wisdom: int = 10        # SAB
var hero_intelligence: int = 10  # INT
var hero_charisma: int = 10      # CAR

var hero_size: String = "Médio"
var hero_size_modifier: int = 0
var hero_favored_class: String = "Qualquer"
var hero_race_traits: Array = []
var hero_class_hit_die: int = 12
var hero_hp_fixed_per_level: int = 8
var hero_hp_progression_mode: String = "fixed"

var hero_base_attack_bonus_type: String = "alto"
var hero_fortitude_type: String = "bom"
var hero_reflex_type: String = "ruim"
var hero_will_type: String = "ruim"

var hero_fortitude_base_bonus: int = 2
var hero_reflex_base_bonus: int = 2
var hero_will_base_bonus: int = 0

var hero_class_movement_bonus: float = 0.0
var hero_damage_reduction: int = 0
var hero_class_features: Array = []
