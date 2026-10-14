extends RefCounted

# Técnicas originais de Aviant para combate com qualquer arma.
const POWERS := [
	{
		"id": "fighter_technical_strike",
		"name": "Golpe Técnico",
		"frequency": "Sem limite",
		"description": "Prepare um ataque com arma com +1 para acertar."
	},
	{
		"id": "fighter_steady_stance",
		"name": "Postura Firme",
		"frequency": "Por encontro",
		"description": "Receba +2 na Classe de Armadura até o início do seu próximo turno. Usa a ação principal."
	},
	{
		"id": "fighter_breaking_strike",
		"name": "Ruptura de Linha",
		"frequency": "Diário",
		"description": "Prepare um ataque com arma com +2 para acertar e +3 de dano se acertar. Volta após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
