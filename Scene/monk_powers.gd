extends RefCounted

# Técnicas originais de Aviant; preservam o combate desarmado do Monge.
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
