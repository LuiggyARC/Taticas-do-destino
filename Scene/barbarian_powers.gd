extends RefCounted

# Estrutura inspirada em progressão por frequência, com poderes originais de Aviant.
const POWERS := [
	{
		"id": "barbarian_impetuous",
		"name": "Golpe Impetuoso",
		"frequency": "Sem limite",
		"description": "Prepare um ataque corpo a corpo que causa +1 de dano."
	},
	{
		"id": "barbarian_decisive",
		"name": "Golpe Decisivo",
		"frequency": "Diário",
		"description": "Prepare um ataque corpo a corpo que causa +4 de dano. Recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
