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
		"description": "Aliados recebem +1 para acertar ataques com armas até o fim da próxima rodada. Usa a ação principal."
	},
	{
		"id": "bard_renewal_song",
		"name": "Canção de Recomeço",
		"frequency": "Diário",
		"description": "Cure todos os aliados feridos. Usa a ação principal e volta após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
