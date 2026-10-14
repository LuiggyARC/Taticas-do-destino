extends RefCounted

# Preces originais de Aviant; o clérigo continua usando suas magias normalmente.
const POWERS := [
	{
		"id": "cleric_guarding_light",
		"name": "Luz Vigilante",
		"frequency": "Sem limite",
		"description": "Receba +1 na Classe de Armadura até o início do seu próximo turno. Usa a ação principal."
	},
	{
		"id": "cleric_helping_prayer",
		"name": "Prece de Socorro",
		"frequency": "Por encontro",
		"description": "Cure o aliado ferido com menos vida proporcional. Usa a ação principal."
	},
	{
		"id": "cleric_renewing_dawn",
		"name": "Aurora Renovadora",
		"frequency": "Diário",
		"description": "Cure todos os aliados feridos. Usa a ação principal; recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
