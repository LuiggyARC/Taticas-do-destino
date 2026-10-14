extends RefCounted

# Pactos e manifestações originais de Aviant. Não consomem espaços de magia.
const POWERS := [
	{
		"id": "warlock_eldritch_spark",
		"name": "Centelha do Pacto",
		"frequency": "Sem limite",
		"description": "Ataque mágico a até 9 m: 1d6 + Carisma de dano. Usa a ação de ataque."
	},
	{
		"id": "warlock_binding_burst",
		"name": "Pulso Vinculante",
		"frequency": "Por encontro",
		"description": "Ataque mágico a até 9 m: 1d6 + Carisma + 2 de dano. Usa a ação de ataque."
	},
	{
		"id": "warlock_pact_judgment",
		"name": "Julgamento do Pacto",
		"frequency": "Diário",
		"description": "Ataque mágico a até 9 m: 1d6 + Carisma + 5 de dano. Volta após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
