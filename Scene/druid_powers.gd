extends RefCounted

# Poderes originais de Aviant, organizados por frequência de uso.
const POWERS := [
	{
		"id": "druid_barkguard",
		"name": "Casca Viva",
		"frequency": "Sem limite",
		"description": "Gaste a ação principal para ganhar +1 na defesa até seu próximo turno."
	},
	{
		"id": "druid_wild_aspect",
		"name": "Aspecto Selvagem",
		"frequency": "Por encontro",
		"description": "Gaste a ação principal para ganhar +1 na defesa e +2 de dano corpo a corpo por 3 rodadas."
	},
	{
		"id": "druid_life_circle",
		"name": "Círculo Vital",
		"frequency": "Diário",
		"description": "Gaste a ação principal para curar todos os aliados vivos. Recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
