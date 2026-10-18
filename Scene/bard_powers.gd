extends RefCounted

# Técnicas originais de Aviant. A magia Inspirar Coragem permanece separada.
const POWERS := [
	{
		"id": "bard_precise_rhythm",
		"name": "Compasso Preciso",
		"frequency": "Sem limite",
		"description": "Prepare um ataque com arma com +1 para acertar."
	},
	{
		"id": "bard_courage_refrain",
		"name": "Refrão de Coragem",
		"frequency": "Por encontro",
		"utility": true,
		"description": "Aliados recebem +1 para acertar ataques com armas até o fim da próxima rodada. Ativa ao selecionar, sem gastar ataque."
	},
	{
		"id": "bard_renewal_song",
		"name": "Canção de Recomeço",
		"frequency": "Diário",
		"utility": true,
		"description": "Cure todos os aliados feridos ao selecionar, sem gastar ataque. Recupera após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
