extends RefCounted

# Técnicas originais de Aviant; magias e companheiro animal permanecem separados.
const POWERS := [
	{
		"id": "ranger_field_aim",
		"name": "Mira de Campo",
		"frequency": "Sem limite",
		"description": "Prepare um ataque com arma com +1 para acertar."
	},
	{
		"id": "ranger_trail_step",
		"name": "Passo da Trilha",
		"frequency": "Por encontro",
		"description": "Recupere 3 m de movimento neste turno, mesmo depois de atacar."
	},
	{
		"id": "ranger_relentless_hunt",
		"name": "Caçada Implacável",
		"frequency": "Diário",
		"description": "Prepare um ataque com arma com +4 de dano se acertar. O uso volta após descansar."
	}
]


static func get_powers() -> Array:
	return POWERS.duplicate(true)
