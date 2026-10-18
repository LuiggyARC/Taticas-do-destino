extends RefCounted

# Técnicas originais de Aviant; preservam o combate desarmado do Monge.
const FLURRY_UNLIMITED_LEVEL := 10
const POWERS := [
	{
		"id": "monk_focused_strike",
		"name": "Golpe Concentrado",
		"frequency": "Sem limite",
		"description": "Ataque corpo a corpo com +1 para acertar. Usa a ação de ataque."
	},
	{
		"id": "monk_flurry",
		"name": "Rajada de Golpes",
		"frequency": "Por encontro",
		"description": "Dois ataques corpo a corpo contra o mesmo alvo. Usa a ação de ataque."
	},
	{
		"id": "monk_inner_force",
		"name": "Força Interior",
		"frequency": "Diário",
		"description": "Ataque corpo a corpo com +4 de dano se acertar. Volta após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)


static func is_flurry_unlimited(level: int) -> bool:
	return level >= FLURRY_UNLIMITED_LEVEL


static func get_powers_for_level(level: int) -> Array:
	var powers: Array = get_powers()
	if is_flurry_unlimited(level):
		for power in powers:
			if str(power.get("id", "")) == "monk_flurry":
				power["frequency"] = "Sem limite"
				power["description"] = "Dois ataques corpo a corpo contra o mesmo alvo. Sem limite a partir do nível 10; usa um ataque do turno."
	return powers
