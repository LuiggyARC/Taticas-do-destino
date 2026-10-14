extends RefCounted

# Técnicas originais de Aviant. Esconder-se e Ataque Furtivo continuam
# seguindo as regras de combate já existentes.
const POWERS := [
	{
		"id": "rogue_hide",
		"name": "Passo Oculto",
		"frequency": "Sem limite",
		"description": "Esconda-se uma vez por turno antes de atacar. A percepção dos inimigos ainda pode revelar você."
	},
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
