extends RefCounted

# Preces originais de Aviant; o clérigo continua usando suas magias normalmente.
const POWERS := [
	{
		"id": "cleric_guarding_light",
		"name": "Luz Vigilante",
		"frequency": "Sem limite",
		"utility": true,
		"description": "Receba +1 na Classe de Armadura até o início do seu próximo turno. Ativa ao selecionar, sem gastar ataque."
	},
	{
		"id": "cleric_helping_prayer",
		"name": "Prece de Socorro",
		"frequency": "Por encontro",
		"utility": true,
		"description": "Cure o aliado ferido com menos vida proporcional ao selecionar. Não gasta ataque."
	},
	{
		"id": "cleric_renewing_dawn",
		"name": "Aurora Renovadora",
		"frequency": "Diário",
		"utility": true,
		"description": "Cure todos os aliados feridos ao selecionar, sem gastar ataque. Recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
