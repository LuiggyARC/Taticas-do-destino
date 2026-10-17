extends RefCounted

# Técnicas originais de Aviant. Esconder-se é uma ação própria no painel.
const POWERS := [
	{
		"id": "rogue_precise_strike",
		"name": "Brecha Calculada",
		"frequency": "Por encontro",
		"description": "Prepare um ataque com arma com +2 para acertar. O uso é gasto ao atacar."
	},
	{
		"id": "rogue_final_cut",
		"name": "Corte Decisivo",
		"frequency": "Diário",
		"description": "Prepare um ataque com arma com +4 de dano se acertar. O uso é gasto ao atacar e volta após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
