extends RefCounted

# O texto permanece dividido pelo local onde a cena é apresentada.
const INSIDE := """
Narrador|O último cultista cai. A passagem para fora do templo está livre.
Narrador|Do outro lado da muralha de fogo, Hashagur continua cercado por Ebramir e seus guerreiros.
Hashagur|A saída está livre.
Hashagur|Vão. Agora.
Sir Uiliam|Não.
Narrador|Uiliam olha para a muralha de fogo.
Sir Uiliam|Apague essas chamas.
Sir Uiliam|Eu fico com você.
Hashagur|Não.
Sir Uiliam|Então encontrarei outra forma de atravessar.
Aventureiro|Uiliam, olhe para eles.
Narrador|Os guerreiros de elite ainda cercam Hashagur.
Aventureiro|Não conseguimos chegar até ele.
Aniri|E mesmo se conseguirmos...
Aniri|Não vamos sair daqui vivos.
Sir Uiliam|Então lutaremos até o fim.
Aniri|Esse é exatamente o problema.
Sir Uiliam|Eu não vou abandoná-lo!
Hashagur|Uiliam.
Narrador|Uiliam encara Hashagur através das chamas.
Hashagur|Já escolhi ficar.
Sir Uiliam|E eu escolho lutar!
Narrador|Hashagur respira fundo e firma os pés no chão.
Hashagur|Então vou ajudá-lo a escolher melhor.
Sir Uiliam|O quê?
Hashagur|HAAAAA!
@wind_burst
Narrador|Hashagur gira o corpo e desfere um poderoso chute no ar. BOOM! Uma massa de ar comprimido atravessa o salão.
Aventureiro|Segurem—!
Narrador|A rajada atinge o grupo inteiro e os lança pelo corredor, através da saída do templo.
Sir Uiliam|HASHAGUR!
"""

const OUTSIDE := """
Narrador|O grupo cai violentamente no pátio externo. Uiliam é o primeiro a se levantar.
Sir Uiliam|Não!
Narrador|Ele corre de volta. As grandes portas começam a se fechar.
Sir Uiliam|HASHAGUR!
@doors_close
Narrador|BOOM. As portas se fecham. Uiliam chega um instante tarde demais e bate contra elas.
Sir Uiliam|Abra!
Narrador|Nada.
Sir Uiliam|HASHAGUR!
Narrador|Do outro lado, abafados pela pedra e pela madeira, continuam os sons do combate.
Aventureiro|Uiliam...
Sir Uiliam|Ele fez isso de propósito.
Aniri|Sim.
Aniri|Ele queria que saíssemos vivos.
Sir Uiliam|Eu não pedi que decidisse isso por mim.
Narrador|Um impacto violento ecoa de dentro do templo. Todos ficam em silêncio.
Kasum|Podemos discutir depois.
Kasum|Ainda temos companhia.
Narrador|Gritos e sons de batalha continuam do lado de fora.
Novo objetivo|SOBREVIVA AO ATAQUE — Hashagur permaneceu dentro do templo. Elimine os cultistas restantes no pátio.
"""

const AFTER_BATTLE := """
Narrador|O último cultista cai. O pátio fica em silêncio. Armas quebradas, corpos e partes do templo destruído estão espalhados pelo chão.
Narrador|Kasum apoia a arma no chão. Aniri permanece imóvel. Uiliam olha imediatamente para as portas fechadas.
Sir Uiliam|Temos que voltar.
Aventureiro|Não.
Sir Uiliam|Hashagur ainda está lá dentro.
Aventureiro|Eu sei.
Sir Uiliam|Então abrimos aquela porta.
Aventureiro|E depois?
Narrador|Uiliam não responde imediatamente.
Aventureiro|Estamos feridos. Cansados. E não sabemos quantos ainda estão lá.
Sir Uiliam|Isso não significa que devemos deixá-lo morrer.
Aniri|Uiliam... Escute.
Aniri|Eu também quero voltar. Mas tenho medo.
Sir Uiliam|Todos temos.
Aniri|Não deles. De nós.
Aniri|Passei anos sem ninguém. Agora finalmente encontrei pessoas com quem quero continuar amanhã.
Aniri|Não quero entrar naquele templo e assistir isso acabar em uma noite.
Aniri|Eu não quero ficar sozinha outra vez.
Kasum|Ela está certa.
Kasum|Já lutei por dinheiro. Por comida. Por gente que eu nem conhecia.
Kasum|Nunca lutei assim. Estou cansado.
Sir Uiliam|Todos estamos.
Kasum|Não. Estou dizendo que meu corpo acabou. Se entrar lá agora, talvez eu não saia.
Sir Uiliam|Hashagur também pode não sair.
Kasum|Eu sei.
Sir Uiliam|E isso basta para você?
Kasum|Cuidado, paladino.
Sir Uiliam|Ele ficou para nos salvar! E agora todos querem simplesmente ir embora porque estão cansados?!
Narrador|Aniri recua um passo. Kasum aperta o cabo da arma.
Sir Uiliam|Se ainda podemos ficar de pé, ainda podemos lutar, não seremos fracos outra vez!!
Aventureiro|Uiliam.
Sir Uiliam|Não podemos abandonar alguém só porque—
Narrador|Uiliam percebe os olhares ao redor. Sua respiração está pesada. O silêncio dura alguns segundos.
Sir Uiliam|Desculpem. Eu me exaltei.
Sir Uiliam|Kasum, você lutou ao nosso lado. Não tinha o direito de questionar isso.
Kasum|Não tinha. Mas aceito.
Sir Uiliam|Aniri, você tem o direito de ter medo.
Aniri|Isso não significa que eu goste dele.
Sir Uiliam|Eu sei.
Sir Uiliam|Hashagur escolheu nos tirar de lá. Preciso respeitar isso.
Aventureiro|Precisamos voltar para a vila.
Aniri|Concordo.
Sir Uiliam|Por quê?
Aventureiro|Porque eu também cheguei ao meu limite.
Aventureiro|Há três dias eu nem sabia onde estava. Agora sei que uma cidade protegida perdeu seu Selo...
Aventureiro|Que o culto consegue provocar fendas...
Aventureiro|Que essas fendas podem estar relacionadas às minhas memórias...
Aventureiro|E acabamos de deixar alguém lutando sozinho lá dentro.
Aventureiro|Eu preciso parar. Pensar. Descansar.
Aventureiro|Nem eu consigo absorver tudo isso enquanto continuo lutando sem parar.
Aventureiro|Se voltarmos agora, não estaremos ajudando Hashagur. Só estaremos entrando cansados numa batalha que não podemos vencer.
Kasum|A vila fica longe. Estamos com pouca comida. Pouca água. E pouco ouro.
Aniri|Você realmente precisava colocar o ouro na lista?
Kasum|É uma lista de recursos.
Aniri|Claro.
Kasum|Mas ele tem razão. É melhor uma caminhada longa do que outra luta agora.
Sir Uiliam|...Voltamos para a vila.
Aniri|E Hashagur?
Sir Uiliam|Não estou desistindo dele. Voltaremos preparados.
Aventureiro|Voltaremos.
Narrador|Aniri olha para os três. Todos ainda estão ali. Ela respira um pouco melhor.
Narrador|O grupo começa a deixar o templo. Uiliam para e olha uma última vez para as portas fechadas.
Narrador|Um impacto abafado ecoa do interior. Por um instante, parece que ele vai voltar.
Sir Uiliam|Vamos.
Novo objetivo|ECOS DO TEMPLO — O destino de Hashagur é desconhecido. Retorne à vila, descanse e decida o próximo passo.
"""


static func parse_steps(script: String) -> Array[Dictionary]:
	var steps: Array[Dictionary] = []
	for raw_line in script.strip_edges().split("\n"):
		var line: String = raw_line.strip_edges()
		if line.begins_with("@"):
			steps.append({"type": line.substr(1)})
			continue
		var divider: int = line.find("|")
		if divider <= 0:
			continue
		steps.append({"type": "dialogue", "speaker": line.substr(0, divider), "text": line.substr(divider + 1)})
	return steps


static func get_inside() -> Array[Dictionary]:
	return parse_steps(INSIDE)


static func get_outside() -> Array[Dictionary]:
	return parse_steps(OUTSIDE)


static func get_after_battle() -> Array[Dictionary]:
	return parse_steps(AFTER_BATTLE)
