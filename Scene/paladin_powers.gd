extends RefCounted

# Poderes originais de Aviant, organizados por frequência de uso.
const POWERS := [
	{
		"id": "paladin_guarding_strike",
		"name": "Golpe Vigilante",
		"frequency": "Sem limite",
		"description": "Prepare um ataque corpo a corpo com +1 para acertar."
	},
	{
		"id": "paladin_smite",
		"name": "Investida Consagrada",
		"frequency": "Por encontro",
		"description": "Prepare um ataque corpo a corpo com Carisma para acertar e nível no dano."
	},
	{
		"id": "paladin_verdict",
		"name": "Veredito Radiante",
		"frequency": "Diário",
		"description": "Prepare um ataque corpo a corpo com +4 de dano. Recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
