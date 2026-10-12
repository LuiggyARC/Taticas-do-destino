extends Node


const STARTING_VILLAGE_ID := "starting_village"
const SecondChanceDatabase := preload("res://Scene/second_chance_database.gd")
const EmeraldBridgeMayorDatabase := preload("res://Scene/emerald_bridge_mayor_database.gd")

const CARPENTER_BASEMENT_SCRIPTS := {
	"carpenter_basement_request": """
Ação|O aventureiro e Uiliam entram na carpintaria. Há madeira empilhada, móveis incompletos e bancadas praticamente vazias. Jhon está próximo a uma mesa, claramente irritado.
Jhon|Olá.
Jhon|Se vieram encomendar alguma coisa, chegaram em uma péssima hora.
Aventureiro|Por quê?
Jhon|Porque minhas ferramentas sumiram.
Ação|O aventureiro olha para as bancadas vazias.
Jhon|Martelos.
Jhon|Formões.
Jhon|Algumas ferramentas pequenas.
Jhon|Até uma bolsa com moedas desapareceu.
Aventureiro|Tudo de uma vez?
Jhon|Praticamente.
Sir Uiliam|Alguém entrou aqui?
Jhon|Se entrou, não vi.
Jhon|Mas tenho outro problema.
Ação|Jhon aponta para uma porta que leva ao porão.
Jhon|Ratos.
Aventureiro|Ratos?
Jhon|Muitos.
Jhon|Começaram a aparecer no porão e agora não consigo nem descer lá.
Aventureiro|E você acha que os ratos roubaram seus martelos?
Ação|Jhon olha para o aventureiro.
Jhon|Não.
Jhon|Se começarem a usar ferramentas, aí eu abandono a carpintaria.
Aventureiro|Só queria confirmar.
Ação|Jhon observa os dois com mais atenção.
Jhon|Vocês não são daqui.
Sir Uiliam|Não.
Ação|Uiliam assume sua postura habitual.
Sir Uiliam|Sou Uiliam, paladino a serviço da Ordem de Vanir. Consagrei minha espada à preservação da ordem, à defesa dos inocentes e ao triunfo da justiça.
Ação|Jhon fica alguns segundos olhando para ele.
Jhon|Certo.
Ação|O aventureiro olha para Uiliam.
Aventureiro|Você realmente faz isso toda vez.
Sir Uiliam|Eu disse que fazia.
Jhon|E ele?
Ação|Jhon aponta para o aventureiro.
Sir Uiliam|Este é—
Aventureiro|[PLAYER_NAME].
Ação|Uiliam para.
Aventureiro|Essa parte eu consigo responder sozinho.
Jhon|De onde veio?
Aventureiro|Essa parte já é mais complicada.
Jhon|Como assim?
Aventureiro|Ainda estamos tentando descobrir.
Ação|Jhon olha para Uiliam.
Jhon|Ele bateu a cabeça?
Aventureiro|Todo mundo pergunta isso?
Sir Uiliam|Quando começaram os problemas com os ratos?
Jhon|Pouco antes das ferramentas desaparecerem.
Aventureiro|Isso parece importante.
Jhon|Também achei.
Jhon|Mas toda vez que tento descer...
Ação|Um barulho vem do porão. Algo cai lá embaixo.
Jhon|...acontece isso.
Aventureiro|Ratos fazem esse tipo de barulho?
Jhon|Esses fazem.
Ação|Outro ruído vem do porão.
Aventureiro|Tem certeza de que só existem ratos lá embaixo?
Jhon|Não.
Aventureiro|Isso também parece importante.
Jhon|É por isso que ainda estou aqui em cima.
Sir Uiliam|Podemos verificar seu porão.
Ação|O aventureiro imediatamente olha para Uiliam.
Aventureiro|“Podemos”?
Ação|Uiliam percebe.
Sir Uiliam|...
Sir Uiliam|Eu posso verificar seu porão.
Ação|Ele olha para o aventureiro.
Sir Uiliam|Se quiser me acompanhar.
Aventureiro|Melhor.
Jhon|Vocês dois discutem isso com frequência?
Aventureiro|Nós nos conhecemos há algumas horas.
Jhon|Então ainda vai piorar.
Sir Uiliam|Jhon.
Jhon|Só estou avisando.
""",
	"carpenter_basement_accept": """
Aventureiro|Vamos ajudar.
Sir Uiliam|Tem certeza?
Aventureiro|Além disso...
Ação|O aventureiro olha para a própria arma.
Aventureiro|aparentemente lutar é uma das poucas coisas que sei fazer.
Sir Uiliam|Uma razão aceitável.
Jhon|Para mim também.
""",
	"carpenter_basement_question": """
Aventureiro|Por que exatamente isso virou problema nosso?
Sir Uiliam|Não virou.
Aventureiro|Você acabou de oferecer nossa ajuda.
Sir Uiliam|Ofereci a minha.
Ação|Uma pequena pausa.
Sir Uiliam|Estamos aqui.
Sir Uiliam|Somos capazes de ajudar.
Sir Uiliam|Mas a decisão de descer comigo é sua.
Ação|O aventureiro observa Uiliam por alguns segundos.
Aventureiro|Você realmente levou aquela conversa da taverna a sério.
Sir Uiliam|Eu costumo levar minhas palavras a sério.
Aventureiro|Certo.
Ação|O aventureiro olha para a porta do porão.
Aventureiro|Então eu escolho ir.
Sir Uiliam|Muito bem.
Aventureiro|Mas se esses ratos começarem a usar martelos...
Aventureiro|eu vou embora.
Jhon|Justo.
""",
	"carpenter_basement_warning": """
Ação|Jhon abre a porta que leva ao porão. Uma escada desce para a escuridão.
Jhon|O porão fica aí embaixo.
Jhon|Matem os ratos e, se encontrarem minhas ferramentas, tragam tudo de volta.
Aventureiro|Mais alguma coisa que deveríamos saber?
Jhon|Sim.
Jhon|Se vocês não voltarem...
Ação|Uma pequena pausa.
Jhon|não vou descer para retirar os corpos.
Ação|Silêncio.
Aventureiro|Você é muito bom em incentivar pessoas.
Jhon|Sou carpinteiro.
Jhon|Não trabalho com motivação.
Sir Uiliam|Vamos.
Ação|Uiliam começa a descer.
"""
}

const TAVERN_HISTORY_BEFORE_VIDEO := """
Ação|O aventureiro entra na taverna acompanhado por Uiliam. O lugar está tranquilo; Uiliam escolhe uma mesa afastada e se senta.
Aventureiro|Então?
Ação|Uiliam observa o aventureiro por alguns segundos. Seu semblante fica mais sério.
Sir Uiliam|Sente-se.
Sir Uiliam|Vou lhe contar uma história, [PLAYER_NAME].
Aventureiro|Isso vai responder minhas perguntas?
Sir Uiliam|Vai criar algumas novas.
Aventureiro|Ótimo.
Sir Uiliam|Mas sem ela, nenhuma das respostas fará sentido.
Ação|O aventureiro se senta.
Sir Uiliam|Para compreender o estado deste mundo...
Sir Uiliam|primeiro você precisa entender como chegamos até aqui.
"""

const TAVERN_HISTORY_AFTER_VIDEO := """
Ação|A imagem retorna lentamente. O aventureiro permanece alguns segundos em silêncio.
Aventureiro|Então...
Ação|Ele tenta organizar tudo que acabou de ouvir.
Aventureiro|Sete reinos passaram séculos lutando entre si.
Aventureiro|Aurora conseguiu unir todos eles.
Aventureiro|Depois tentou garantir que tudo continuasse unido quando ela morresse...
Aventureiro|e acabou abrindo uma passagem entre mundos.
Sir Uiliam|Essencialmente.
Aventureiro|Cinco guerreiros fecharam a Ruptura.
Aventureiro|Mas as criaturas que já tinham atravessado ficaram.
Sir Uiliam|Exatamente.
Aventureiro|E os Selos protegem as cidades.
Sir Uiliam|A maioria delas.
Ação|O aventureiro olha para Uiliam.
Aventureiro|Então acho que estou começando a entender.
Sir Uiliam|O quê?
Aventureiro|Por que aquele guarda estava cercado de monstros mesmo existindo essas tais barreiras.
Sir Uiliam|Os Selos não protegem todos.
Sir Uiliam|Protegem cidades grandes e alguns pontos considerados importantes.
Sir Uiliam|Estradas, florestas e cavernas seguem nas mãos do mal...
Sir Uiliam|grande parte de Aviant permanece fora de sua proteção.
Aventureiro|Então sair de uma cidade é sempre daquele jeito?
Sir Uiliam|Não.
Sir Uiliam|Pelo menos não deveria ser.
Aventureiro|Isso não pareceu muito reconfortante.
Sir Uiliam|Não pretendia ser.
Sir Uiliam|Os Selos mantiveram nossas cidades relativamente seguras durante gerações.
Sir Uiliam|Mas nunca fizeram as criaturas desaparecerem.
Sir Uiliam|Elas continuam lá fora.
Sir Uiliam|Nas cavernas.
Sir Uiliam|Nas florestas.
Sir Uiliam|Nas ruínas deixadas desde a Grande Ruptura.
Aventureiro|Há trezentos anos?
Sir Uiliam|Sim.
Aventureiro|E ninguém conseguiu acabar com elas nesse tempo todo?
Sir Uiliam|Muitos tentaram.
Sir Uiliam|Muitos ainda tentam.
Sir Uiliam|Mas Aviant é grande.
Sir Uiliam|E as criaturas nunca deixaram de aparecer.
Ação|Uiliam faz uma pequena pausa.
Sir Uiliam|O problema é que, ultimamente...
Sir Uiliam|parecem existir cada vez mais delas.
Aventureiro|Como as que encontramos hoje.
Sir Uiliam|Sim.
Aventureiro|Tão perto da vila.
Sir Uiliam|Exatamente.
Ação|O aventureiro começa a perceber a preocupação de Uiliam.
Sir Uiliam|Antigamente, histórias sobre grandes guerreiros faziam jovens sonharem em se tornar aventureiros.
Sir Uiliam|Homens e mulheres deixavam suas casas para enfrentar aquilo que existia além dos Selos.
Aventureiro|E hoje não fazem mais isso?
Sir Uiliam|Alguns fazem.
Sir Uiliam|Cada vez menos.
Aventureiro|Por quê?
Sir Uiliam|Porque muitos não voltam.
Pausa|0.6
Sir Uiliam|Hoje, poucas pessoas desejam trocar a segurança dos muros por uma espada e uma estrada incerta.
Sir Uiliam|E não posso culpá-las.
Aventureiro|Mas isso incomoda você.
Ação|Uiliam olha para o aventureiro.
Sir Uiliam|Incomoda.
Aventureiro|Por quê?
Sir Uiliam|Porque as criaturas não se importam com nossos medos.
Sir Uiliam|Enquanto o número delas cresce...
Sir Uiliam|o número daqueles dispostos a enfrentá-las diminui.
Sir Uiliam|É isso que preocupa a Ordem de Vanir.
Sir Uiliam|Precisamos constantemente de novos guerreiros.
Sir Uiliam|Pessoas dispostas a proteger estradas, investigar ataques e enfrentar aquilo que os Selos não conseguem deter.
Aventureiro|“Precisamos”?
Sir Uiliam|Sim.
Aventureiro|Você está tentando me recrutar?
Ação|Uiliam fica alguns segundos em silêncio.
Sir Uiliam|Ainda não.
Aventureiro|Ainda?
Sir Uiliam|Você apareceu sem conhecer Aviant e sem sequer saber como chegou aqui.
Sir Uiliam|Seria irresponsável pedir que jurasse lealdade a alguma causa agora.
Aventureiro|Pelo menos concordamos nisso.
Sir Uiliam|Mas há algo que não posso ignorar.
Aventureiro|O quê?
Sir Uiliam|Quando viu um homem cercado por criaturas...
Sir Uiliam|você entrou na batalha.
Aventureiro|Eu nem sabia se conseguia lutar.
Sir Uiliam|Isso torna sua decisão ainda mais significativa.
Aventureiro|Ou mais estúpida.
Sir Uiliam|As duas coisas não são necessariamente incompatíveis.
Ação|O aventureiro olha para Uiliam.
Aventureiro|Isso foi uma piada?
Sir Uiliam|Não se acostume.
Ação|Uiliam fica mais sério novamente.
Sir Uiliam|Aviant já teve pessoas capazes de representar resistência.
Sir Uiliam|Heróis cujos nomes faziam outros encontrarem coragem para lutar.
Aventureiro|Os Cinco?
Sir Uiliam|Eles são o maior exemplo.
Sir Uiliam|Mas houve muitos outros depois deles.
Sir Uiliam|Hoje...
Ação|Uiliam olha ao redor da taverna.
Sir Uiliam|não temos ninguém assim.
Aventureiro|E você acha que isso é tão importante quanto ter soldados?
Sir Uiliam|Talvez mais.
Aventureiro|Por quê?
Sir Uiliam|Porque monstros podem ser enfrentados.
Pausa|0.6
Sir Uiliam|Mas quando um povo perde a esperança de que alguém ainda pode enfrentá-los...
Sir Uiliam|ele começa a acreditar que já perdeu a guerra.
Ação|O aventureiro permanece pensativo.
Aventureiro|Então o problema não é falta de gente.
Ação|Uiliam olha diretamente para ele.
Sir Uiliam|Não.
Sir Uiliam|Não faltam pessoas em Aviant.
Pausa|0.6
Sir Uiliam|Faltam pessoas dispostas a lutar.
Aventureiro|Você fala disso como alguém que pensa muito sobre o assunto.
Sir Uiliam|É meu dever pensar.
Aventureiro|E convencer pessoas a lutar também faz parte desse dever?
Ação|Uiliam demora um pouco mais para responder.
Sir Uiliam|Quando alguém possui capacidade para proteger os outros...
Sir Uiliam|acredito que vale a pena mostrar a essa pessoa que sua força pode significar alguma coisa.
Aventureiro|Mostrar.
Sir Uiliam|Sim.
Aventureiro|Não decidir por ela.
Ação|Uiliam encara o aventureiro.
Sir Uiliam|Não.
Sir Uiliam|A escolha ainda deve pertencer a ela.
Pausa|0.6
Aventureiro|Certo.
Sir Uiliam|Por quê?
Aventureiro|Só queria saber.
Aventureiro|Então já sei onde estou.
Sir Uiliam|Em parte.
Aventureiro|Se isso foi apenas “em parte”, começo a sentir falta de quando eu não sabia de nada.
Sir Uiliam|Logo aprenderá que Aviant possui esse efeito.
Aventureiro|E agora?
Sir Uiliam|Isso depende de você.
Aventureiro|Finalmente uma resposta que gosto.
Sir Uiliam|Não sabe de onde veio.
Sir Uiliam|Mas sabe lutar.
Sir Uiliam|Até descobrir mais sobre si mesmo, talvez seja melhor não viajar sozinho.
Aventureiro|Está oferecendo ajuda?
Sir Uiliam|Estou.
Aventureiro|Sem juramento à Ordem?
Sir Uiliam|Sem juramento.
Aventureiro|Sem me transformar em aventureiro contra minha vontade?
Sir Uiliam|Você parece particularmente preocupado com isso.
Aventureiro|Acabei de conhecer você.
Sir Uiliam|Justo.
Aventureiro|Então, por enquanto...
Aventureiro|acho que continuarei por perto.
Sir Uiliam|Por enquanto.
Ação|Uiliam reconhece a expressão usada pelo aventureiro anteriormente.
Aventureiro|Você presta atenção.
Sir Uiliam|É uma habilidade útil.
Ação|Diário atualizado — O Mundo de Aviant: você descobriu a história da Grande Ruptura, dos Cinco Guerreiros e dos Selos de Vanir. As criaturas continuam além das áreas protegidas e parecem estar aumentando.
Ação|Novo objetivo: conheça a vila e descubra mais sobre o mundo em que despertou.
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
