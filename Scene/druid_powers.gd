extends RefCounted

# Poderes originais de Aviant, organizados por frequência de uso.
const POWERS := [
	{
		"id": "druid_barkguard",
		"name": "Casca Viva",
		"frequency": "Sem limite",
		"utility": true,
		"description": "Ganhe +1 na defesa até seu próximo turno ao selecionar. Não gasta ataque."
	},
	{
		"id": "druid_wild_aspect",
		"name": "Aspecto Selvagem",
		"frequency": "Por encontro",
		"utility": true,
		"description": "Ganhe +1 na defesa e +2 de dano corpo a corpo por 3 rodadas ao selecionar. Não gasta ataque."
	},
	{
		"id": "druid_life_circle",
		"name": "Círculo Vital",
		"frequency": "Diário",
		"utility": true,
		"description": "Cure todos os aliados vivos ao selecionar, sem gastar ataque. Recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
