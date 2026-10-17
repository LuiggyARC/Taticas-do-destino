extends Node


const STARTING_VILLAGE_ID := "starting_village"
const SecondChanceDatabase := preload("res://Scene/second_chance_database.gd")
const EmeraldBridgeMayorDatabase := preload("res://Scene/emerald_bridge_mayor_database.gd")

const CARPENTER_BASEMENT_SCRIPTS := {
	"carpenter_basement_request": """
Ação|O aventureiro e Uiliam entram na carpintaria. Há móveis incompletos e bancadas praticamente vazias.
Jhon|Se vieram encomendar alguma coisa, chegaram numa péssima hora.
Aventureiro|O que aconteceu?
Jhon|Minhas ferramentas desapareceram.
Jhon|Martelos, formões, moedas... levaram um pouco de tudo.
Sir Uiliam|Viu alguém entrar?
Jhon|Não.
Ação|Jhon aponta para a porta do porão.
Jhon|E ainda tenho ratos lá embaixo.
Aventureiro|Os ratos levaram as ferramentas?
Ação|Jhon encara o aventureiro.
Jhon|Espero que não.
Jhon|Se começarem a usar martelos, abandono esta vila.
Aventureiro|Justo.
Ação|Jhon observa os dois.
Jhon|Vocês não são daqui.
Ação|Uiliam assume sua postura habitual.
Sir Uiliam|Sou Uiliam, paladino a serviço da Ordem de Vanir. Consagrei minha espada à preservação da ordem, à defesa dos inocentes e ao triunfo da justiça.
Jhon|...
Jhon|Certo.
Aventureiro|Ele realmente faz isso sempre.
Sir Uiliam|Eu disse que fazia.
Jhon|E você?
Aventureiro|[PLAYER_NAME].
Jhon|De onde veio?
Aventureiro|Ainda estou tentando descobrir.
Ação|Jhon olha para Uiliam.
Jhon|Bateu a cabeça?
Aventureiro|Parece que essa pergunta vai me acompanhar por algum tempo.
Sir Uiliam|Quando os ratos apareceram?
Jhon|Pouco antes das ferramentas sumirem.
Aventureiro|Pode ter relação.
Jhon|Também pensei nisso.
Ação|Um forte barulho vem do porão. Os três olham para a porta.
Aventureiro|São ratos?
Jhon|Até onde sei.
Aventureiro|Isso não pareceu muito convincente.
Jhon|É por isso que continuo aqui em cima.
Ação|Uiliam se aproxima da porta.
Sir Uiliam|Eu posso verificar.
Ação|Ele olha para o aventureiro.
Sir Uiliam|Se quiser acompanhar.
""",
	"carpenter_basement_accept": """
Aventureiro|Vamos ajudar.
Ação|O aventureiro olha para a própria arma.
Aventureiro|Lutar parece ser uma das poucas coisas que sei fazer.
Sir Uiliam|Então espero que os ratos saibam disso.
Jhon|Eu também.
""",
	"carpenter_basement_question": """
Aventureiro|Primeiro quero saber com o que estamos lidando.
Jhon|Ratos.
Aventureiro|Você acabou de dizer “até onde sei”.
Jhon|Ratos grandes?
Aventureiro|Melhorou muito.
Sir Uiliam|Podemos descobrir descendo.
Ação|O aventureiro olha para a porta do porão.
Aventureiro|Certo.
Aventureiro|Eu vou.
""",
	"carpenter_basement_warning": """
Ação|Jhon abre a porta do porão. Uma escada desce para a escuridão.
Jhon|Matem os ratos.
Jhon|E, se encontrarem minhas ferramentas, tragam tudo de volta.
Aventureiro|Mais alguma coisa?
Jhon|Sim.
Jhon|Se vocês não voltarem...
Ação|Uma pequena pausa.
Jhon|não vou descer para buscar os corpos.
Aventureiro|Reconfortante.
Jhon|Sou carpinteiro, não motivador.
Sir Uiliam|Vamos.
Ação|Uiliam começa a descer.
Ação|O aventureiro olha para a escuridão.
Aventureiro|Monstros na estrada.
Aventureiro|Ratos no porão.
Sir Uiliam|Está conhecendo Aviant rapidamente.
Aventureiro|Isso começa a me preocupar.
Ação|Ele desce.
Novo objetivo|O Porão de Jhon: elimine os ratos e encontre as ferramentas desaparecidas.
"""
}

const TAVERN_HISTORY_BEFORE_VIDEO := """
Ação|O aventureiro entra na taverna acompanhado por Uiliam. Os dois se sentam em uma mesa afastada.
Aventureiro|Então...
Aventureiro|você disse que explicaria onde estou.
Sir Uiliam|E explicarei.
Sir Uiliam|Mas primeiro precisa entender o que aconteceu com este mundo.
Aventureiro|Parece simples.
Sir Uiliam|Não é.
"""

const TAVERN_HISTORY_AFTER_VIDEO := """
Ação|A imagem retorna à taverna. O aventureiro permanece alguns segundos em silêncio.
Aventureiro|Então aquelas criaturas vieram por causa da Ruptura.
Sir Uiliam|Muitas delas, sim.
Aventureiro|E os Selos protegem as cidades.
Sir Uiliam|Sim.
Sir Uiliam|É graças a eles que nossas cidades permanecem protegidas.
Aventureiro|Então como aquele guarda foi cercado?
Sir Uiliam|Porque os Selos protegem as cidades.
Sir Uiliam|Não as estradas, florestas ou regiões além delas.
Aventureiro|Entendi.
Aventureiro|Então sair dos muros é que é perigoso.
Sir Uiliam|Pode ser.
Ação|Uiliam fica mais sério.
Sir Uiliam|E ultimamente está ficando mais perigoso.
Aventureiro|Mais criaturas?
Sir Uiliam|Sim.
Aventureiro|Sabem por quê?
Sir Uiliam|Ainda não.
Aventureiro|E quem enfrenta essas criaturas?
Sir Uiliam|Soldados.
Sir Uiliam|A Ordem.
Sir Uiliam|E aventureiros.
Aventureiro|Como eu?
Sir Uiliam|Ainda não.
Aventureiro|“Ainda”?
Ação|Uiliam quase sorri.
Sir Uiliam|Há cada vez menos pessoas dispostas a seguir esse caminho.
Aventureiro|Porque é perigoso.
Sir Uiliam|Porque muitos não voltam.
Aventureiro|Faz sentido.
Sir Uiliam|Faz.
Ação|Uma pequena pausa.
Sir Uiliam|Mas as criaturas não desaparecem porque temos medo delas.
Sir Uiliam|Por isso o que fez hoje chamou minha atenção.
Aventureiro|Proteger o guarda?
Sir Uiliam|Você não sabia onde estava.
Sir Uiliam|Não lembrava quem era.
Sir Uiliam|Nem sabia se conseguiria lutar.
Aventureiro|Ele precisava de ajuda.
Sir Uiliam|Exatamente.
Ação|Um breve silêncio.
Sir Uiliam|Não faltam pessoas em Aviant.
Sir Uiliam|Faltam pessoas dispostas a lutar.
Aventureiro|Está tentando me recrutar?
Sir Uiliam|Não.
Ação|Uma pausa.
Sir Uiliam|Ainda não.
Aventureiro|Você gosta dessa palavra.
Sir Uiliam|Ela mantém possibilidades abertas.
Aventureiro|E se eu não quiser ser aventureiro?
Sir Uiliam|Então não será.
Aventureiro|Simples assim?
Sir Uiliam|Sua força pode ajudar pessoas.
Sir Uiliam|Mas a escolha precisa ser sua.
Ação|O aventureiro observa Uiliam.
Aventureiro|Entendi.
Sir Uiliam|Por enquanto, existe algo mais importante.
Aventureiro|Descobrir quem sou.
Sir Uiliam|Exatamente.
Aventureiro|E agora?
Sir Uiliam|Não sabe de onde veio.
Sir Uiliam|Ainda conhece pouco de Aviant.
Sir Uiliam|Viajar sozinho não seria prudente.
Aventureiro|Está oferecendo ajuda?
Sir Uiliam|Estou.
Aventureiro|Sem juramento?
Sir Uiliam|Sem juramento.
Ação|O aventureiro pensa por um instante.
Aventureiro|Então fico por perto.
Sir Uiliam|Por enquanto?
Aventureiro|Por enquanto.
Diário atualizado|O Mundo de Aviant: você conheceu a história da Grande Ruptura, dos Cinco Guerreiros e dos Selos de Vanir. Segundo Uiliam, os Selos mantêm as cidades protegidas, enquanto as regiões além delas continuam perigosas. O número de criaturas parece estar aumentando.
Novo objetivo|Explore a vila e descubra mais sobre Aviant — e sobre quem você era antes de chegar aqui.
"""

const LOCATION_EVENT_SEQUENCES := {
	"starting_village": {
		"town_hall_closed": [
			{
				"type": "dialogue",
				"speaker": "Aviso da Prefeitura",
				"text": "Prefeitura fechada."
			},
			{
				"type": "dialogue",
				"speaker": "Aviso da Prefeitura",
				"text": (
					"Fomos atrás de novos guardas."
				)
			}
		],
		"carpenter_emerald_bridge_sign": [
			{
				"type": "dialogue",
				"speaker": "Placa da Carpintaria",
				"text": (
					"Loja fechada. Fui reconstruir "
					+ "a Ponte da Esmeralda."
				)
				}
			],
	}
	}

const DIALOGUES := {
	"starting_village": {
		"healer": {
			"welcome": {
				"speaker": "Curandeira",
				"text": (
					"Bem-vindos! O que vão querer? "
					+ "Descansar? Poções?"
				)
			},
			"rest_success": {
				"speaker": "Curandeira",
				"text": (
					"Ótimo, são 2 peças de ouro. "
					+ "Aproveitem a estadia."
				)
			},
			"rest_no_gold": {
				"speaker": "Curandeira",
				"text": (
					"Receio que vocês não tenham "
					+ "as 2 peças de ouro necessárias."
				)
			},
			"potion_no_stock": {
				"speaker": "Curandeira",
				"text": (
					"Infelizmente, fui roubada. "
					+ "Alguém levou minhas poções "
					+ "durante a noite de chuva."
				)
			}
		},
		"tavern": {
			"welcome": {
				"speaker": "Taverneiro",
				"text": (
					"Olá! Vai uma bebida ou um boato?"
				)
			},
						"story_interruption": {
				"speaker": "Taverneiro",
				"text": (
					"Aos aventureiros, uma rodada grátis! "
					+ "Não é todo dia que vemos guerreiros "
					+ "por esta região."
				)
			},
			"drink_success": {
				"speaker": "Taverneiro",
				"text": (
					"Aqui está sua cerveja."
				)
			},
			"drink_no_gold": {
				"speaker": "Taverneiro",
				"text": (
					"Parece que você não tem ouro "
					+ "suficiente para a bebida."
				)
			},
			"rumor_first": {
				"speaker": "Taverneiro",
				"text": (
					"Há um boato de que existe um ladrão "
					+ "entre nós. Roubaram a loja de cura "
					+ "ontem, durante a chuva."
				)
			},
			"rumor_second": {
				"speaker": "Taverneiro",
				"text": (
					"É raro termos pessoas por aqui, "
					+ "mas, quando aparecem, parece que "
					+ "só vêm para roubar."
				)
			}
		}
	}
}


static func get_dialogue(
	village_id: String,
	location_id: String,
	dialogue_id: String
) -> Dictionary:
	if not DIALOGUES.has(village_id):
		return {}
	
	var village_dialogues: Dictionary = (
		DIALOGUES.get(
			village_id,
			{}
		)
	)
	
	if not village_dialogues.has(location_id):
		return {}
	
	var location_dialogues: Dictionary = (
		village_dialogues.get(
			location_id,
			{}
		)
	)
	
	if not location_dialogues.has(dialogue_id):
		return {}
	
	var dialogue_data: Dictionary = (
		location_dialogues.get(
			dialogue_id,
			{}
		)
	)
	
	return dialogue_data.duplicate(true)
static func append_tavern_history_lines(
	sequence: Array[Dictionary],
	script_lines: String,
	cast: Array
) -> void:
	var first_dialogue: bool = true
	for raw_line in script_lines.split("\n", false):
		var line: String = raw_line.strip_edges()
		var separator: int = line.find("|")
		if separator < 0:
			continue
		var speaker: String = line.substr(0, separator)
		var text: String = line.substr(separator + 1)
		match speaker:
			"Ação":
				sequence.append({"type": "action", "text": text})
			"Pausa":
				sequence.append({"type": "pause", "duration": text.to_float()})
			_:
				var step: Dictionary = {
					"type": "dialogue",
					"speaker": speaker,
					"text": text
				}
				if first_dialogue:
					step["cast"] = cast.duplicate()
					first_dialogue = false
				sequence.append(step)

static func get_tavern_history_sequence() -> Array[Dictionary]:
	var sequence: Array[Dictionary] = []
	append_tavern_history_lines(
		sequence,
		TAVERN_HISTORY_BEFORE_VIDEO,
		["Sir Uiliam", "Aventureiro"]
	)
	sequence.append({"type": "start_fade_to_black", "duration": 2.0})
	sequence.append({"type": "wait_for_fade"})
	sequence.append({
		"type": "video",
		"video_path": "res://Assets/UI/Intro/Historiamundo.ogv"
	})
	sequence.append({"type": "fade_from_black", "duration": 2.0})
	sequence.append({
		"type": "dialogue",
		"speaker": "Taverneiro",
		"cast": ["Taverneiro", "Sir Uiliam"],
		"text": "E agora, com vocês, os bardos Os Sem Destino!"
	})
	sequence.append({
		"type": "start_music",
		"music_path": "res://Assets/Audio/Musictaverna1.mp3",
		"volume_percent": 75.0
	})
	append_tavern_history_lines(
		sequence,
		TAVERN_HISTORY_AFTER_VIDEO,
		["Sir Uiliam", "Aventureiro"]
	)
	return sequence

static func get_event_sequence(
	village_id: String,
	event_id: String
) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if village_id == STARTING_VILLAGE_ID and event_id == "tavern_uiliam_history":
		return get_tavern_history_sequence()
	return result
static func get_location_event_sequence(
	village_id: String,
	event_id: String
) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if village_id == STARTING_VILLAGE_ID and SecondChanceDatabase.has_event(event_id):
		return SecondChanceDatabase.get_event(event_id)
	if village_id == STARTING_VILLAGE_ID and EmeraldBridgeMayorDatabase.has_event(event_id):
		return EmeraldBridgeMayorDatabase.get_event(event_id)
	if village_id == STARTING_VILLAGE_ID and CARPENTER_BASEMENT_SCRIPTS.has(event_id):
		append_tavern_history_lines(result, str(CARPENTER_BASEMENT_SCRIPTS[event_id]), [])
		return result
	
	if not LOCATION_EVENT_SEQUENCES.has(
		village_id
	):
		return result
	
	var village_events: Dictionary = (
		LOCATION_EVENT_SEQUENCES.get(
			village_id,
			{}
		)
	)
	
	if not village_events.has(event_id):
		return result
	
	var raw_sequence: Array = (
		village_events.get(
			event_id,
			[]
		)
	)
	
	for raw_step in raw_sequence:
		if raw_step is Dictionary:
			result.append(
				raw_step.duplicate(true)
			)
	
	return result
