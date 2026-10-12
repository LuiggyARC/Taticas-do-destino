extends RefCounted

# Novo roteiro da prefeitura para a missão da Ponte da Esmeralda.
const SCRIPTS := {
	"emerald_bridge_mayor_intro": """
Ação|O grupo entra na prefeitura.
Ação|O prefeito está diante de uma mesa coberta de documentos, relatórios e um grande mapa da região.
Ação|Ao perceber os três, interrompe a leitura.
Prefeito|Ora. Visitantes.
Prefeito|Sejam bem-vindos.
Prefeito|Peço desculpas pela situação da vila. Precisei me ausentar por alguns dias para tratar de assuntos urgentes.
Prefeito|Com tão poucos guardas disponíveis, não foi uma decisão fácil.
Aventureiro|Percebemos que estão com poucos homens.
Prefeito|Menos do que eu gostaria.
Sir Uiliam|Encontramos criaturas nas proximidades da vila.
Sir Uiliam|E até a carpintaria sofreu uma infestação.
Prefeito|Jhon já me informou sobre os ratos.
Ação|Ele suspira.
Prefeito|Como se já não tivéssemos problemas suficientes.
Aventureiro|Essas criaturas costumam chegar tão perto das casas?
Prefeito|Não.
@pause
Prefeito|E gostaria que continuasse assim.
Aniri|Eu também.
Aniri|Porões já são ruins o bastante sem coisas tentando arrancar pedaços de você.
Sir Uiliam|A Ordem enviou reforços?
Prefeito|Sim.
Prefeito|Novos combatentes estão a caminho.
Prefeito|Mas ainda levarão algum tempo para chegar.
Aventureiro|E até lá?
Ação|O prefeito olha para os documentos sobre a mesa.
Prefeito|Até lá, fazemos o possível com o que temos.
Ação|O prefeito se aproxima do mapa.
Prefeito|E existe outra questão que não pode esperar.
Ação|Ele aponta para uma estrada a leste.
Prefeito|A Ponte da Esmeralda foi danificada.
Aniri|A ponte da estrada comercial?
Aventureiro|Você conhece?
Aniri|Passei por ela para chegar até esta região.
Aniri|É uma das principais rotas daqui.
Prefeito|Sem a ponte, nossos suprimentos atrasam.
Prefeito|Mercadores precisam fazer grandes desvios.
Prefeito|E, se a passagem permanecer fechada por muito tempo...
Prefeito|a vila começa a ficar isolada.
Aventureiro|Então alguém precisa consertá-la.
Prefeito|Exatamente.
Prefeito|Enviei nosso melhor carpinteiro.
Aniri|Não.
Ação|Todos olham para ela.
Prefeito|Como?
Aniri|Diga que não mandou Jhon.
Prefeito|Jhon saiu esta manhã.
Ação|Aniri fecha os olhos por um instante.
Aventureiro|Ele foi acompanhado?
Prefeito|Sim.
Aventureiro|Por quantos guardas?
Ação|O prefeito hesita.
Prefeito|Um.
Aniri|Um?
Prefeito|Era o único que eu poderia dispensar.
Aniri|Você mandou um carpinteiro e um único guarda para uma estrada onde criaturas estão aparecendo?
Prefeito|Mandei quem tinha.
Ação|Aniri fica em silêncio.
Ação|O prefeito não responde com irritação. Parece apenas cansado.
Prefeito|Se mantenho todos os homens dentro da vila, deixo as estradas sem proteção.
Prefeito|Se envio muitos para as estradas, deixo as casas desprotegidas.
Prefeito|Tenho feito esse tipo de escolha há dias.
Ação|Aniri perde um pouco do tom acusatório.
Aniri|Entendo.
Aventureiro|Então o problema não é só a ponte.
Prefeito|Não.
Prefeito|A ponte é apenas o problema que não pode esperar.
Ação|Uiliam se aproxima da mesa.
Sir Uiliam|Nesse caso, permita-me apresentar-me adequadamente.
Ação|Aniri olha discretamente para o aventureiro.
Aniri|Lá vem.
Aventureiro|Ele realmente faz isso sempre.
Ação|Uiliam ignora os dois.
Sir Uiliam|Sou Uiliam, paladino a serviço da Ordem de Vanir.
Sir Uiliam|Consagrei minha espada à preservação da ordem, à defesa dos inocentes e ao triunfo da justiça.
Ação|O prefeito muda imediatamente de postura.
Prefeito|Um paladino da Ordem?
Prefeito|Então os reforços—
Sir Uiliam|Ainda não chegaram.
Sir Uiliam|Fui enviado para esta região justamente para reforçar a defesa contra as criaturas.
Sir Uiliam|Mas, ao chegar, ficou claro que um único paladino não seria suficiente.
Sir Uiliam|Pretendia solicitar mais homens assim que tivesse oportunidade.
Ação|Ele olha para o prefeito.
Sir Uiliam|Vejo que se antecipou.
Prefeito|Não tive muita escolha.
Prefeito|Ainda assim...
Prefeito|é bom saber que alguém da Ordem já está aqui.
Sir Uiliam|Se Jhon está naquela estrada com apenas um guarda...
Sir Uiliam|eu irei até a ponte.
Ação|Uiliam olha para Aniri e para o aventureiro.
Sir Uiliam|Quanto a vocês...
Sir Uiliam|podem decidir se desejam me acompanhar.
Aventureiro|Quero entender melhor a situação primeiro.
Sir Uiliam|Naturalmente.
Aniri|Eu vou.
Ação|O aventureiro olha para ela.
Aventureiro|Já decidiu?
Aniri|Sim.
Aventureiro|Por causa de Jhon?
Ação|Aniri toca a pequena bolsa presa ao cinto.
Aniri|Em parte.
Aniri|Eu roubei aquele homem.
Aniri|Ele poderia ter chamado os guardas.
Aniri|Em vez disso, me deixou trabalhar para pagar o que devo.
Ação|Ela olha para o ponto marcado no mapa.
Aniri|Se ele está naquela ponte com pouca proteção...
Aniri|não vou ficar aqui esperando para descobrir se conseguiu voltar.
Aventureiro|Por causa da dívida?
Aniri|Também.
@pause
Aniri|Mas não apenas por causa dela.
Ação|O aventureiro percebe que ela está falando sério.
Sir Uiliam|Muito bem.
Aniri|Isso foi aprovação?
Sir Uiliam|Reconhecimento.
Aniri|Você consegue fazer até isso soar como coisa de paladino.
Aventureiro|Estou começando a entender.
Ação|Uiliam olha para o aventureiro.
Sir Uiliam|E você?
Aventureiro|O que sabemos sobre a ponte além de estar danificada?
Prefeito|Pouco.
Prefeito|Guardas que passaram pela região relataram movimentos estranhos nas proximidades.
Aventureiro|Criaturas?
Prefeito|Provavelmente.
Aventureiro|Sabem quais?
Prefeito|Não conseguiram chegar perto o suficiente para identificar.
Aniri|Excelente.
Aniri|Uma ponte quebrada.
Aniri|Jhon praticamente sozinho.
Aniri|E alguma coisa que ninguém conseguiu identificar.
Aventureiro|Você ainda acha uma boa primeira aventura?
Aniri|Não.
@pause
Aniri|Agora parece ainda melhor.
Aventureiro|Você é estranha.
Aniri|Estou começando uma carreira nova.
""",
	"emerald_bridge_choice_help": """
Aventureiro|Eu vou com vocês.
Ação|Aniri sorri.
Aniri|Sabia que estava começando a gostar de você.
Aventureiro|“Começando”?
Aniri|Não estrague.
Sir Uiliam|Então iremos juntos.
Aniri|Agora falta apenas uma pequena questão.
Sir Uiliam|Qual?
Aniri|Comida e ouro.
Ação|Uiliam olha para ela.
Aniri|Estou tentando deixar de roubar.
Aniri|Precisamos começar a pensar em alternativas.
Prefeito|Haverá pagamento.
Aniri|Viu?
Aniri|A honestidade já está dando resultados.
Sir Uiliam|Não tire conclusões tão rápido.
""",
	"emerald_bridge_choice_payment": """
Aventureiro|Eu posso ajudar.
Aventureiro|Mas ainda estou entendendo como as coisas funcionam por aqui.
Prefeito|Claro.
Aventureiro|Esse tipo de serviço costuma ser remunerado?
Prefeito|Sim.
Prefeito|Se protegerem Jhon e garantirem que a passagem seja restaurada...
Prefeito|receberão pelo serviço.
Aniri|Excelente.
Sir Uiliam|Não podemos reduzir toda necessidade de ajuda a uma questão de recompensa.
Aniri|Também não podemos pagar comida com boas intenções.
Ação|Uiliam olha para ela.
Aniri|O quê?
Aniri|Estou tentando deixar de roubar.
Aniri|Preciso entender a parte honesta da economia.
Aventureiro|Nesse caso, eu vou.
Sir Uiliam|Muito bem.
""",
	"emerald_bridge_mayor_conclusion": """
Prefeito|Jhon já deve estar próximo da ponte.
Prefeito|Se pretendem alcançá-lo, precisam partir logo.
Sir Uiliam|Partiremos imediatamente.
Ação|Uiliam faz uma breve pausa e olha para os outros.
Sir Uiliam|Alguma objeção?
Aniri|Nenhuma.
Aventureiro|Não.
Ação|O grupo começa a se afastar da mesa.
Prefeito|Paladino.
Ação|Uiliam para.
Prefeito|Há mais uma coisa.
Ação|O tom do prefeito muda.
Prefeito|Os ataques não costumavam ser tão frequentes.
Aventureiro|Quando começaram a aumentar?
Prefeito|Não saberia dizer exatamente.
Prefeito|Primeiro eram relatos nas estradas.
Prefeito|Depois animais começaram a desaparecer.
Prefeito|Agora as criaturas estão chegando cada vez mais perto das casas.
Ação|O aventureiro pensa por alguns segundos.
Aventureiro|Espere.
Ação|Ele olha para Uiliam.
Aventureiro|Na taverna você disse que os Selos mantinham as cidades protegidas.
Sir Uiliam|Sim.
Aventureiro|Então por que as criaturas conseguem chegar tão perto daqui?
Ação|O prefeito responde antes de Uiliam.
Prefeito|Porque não temos um Selo.
Ação|O aventureiro olha para ele.
Aventureiro|Não têm?
Prefeito|Nunca tivemos.
Aventureiro|Por quê?
Prefeito|Somos uma vila pequena.
Prefeito|Os Selos ficam principalmente nas grandes cidades e em alguns pontos considerados estratégicos.
Ação|O aventureiro olha novamente para Uiliam.
Aventureiro|Isso é normal?
Sir Uiliam|É comum.
Aventureiro|Não foi isso que perguntei.
Ação|Uiliam fica alguns segundos em silêncio.
Sir Uiliam|Então...
Sir Uiliam|não sei se chamaria de normal.
Aventureiro|Por que uma cidade grande recebe um Selo e uma vila como esta não?
Sir Uiliam|A explicação que recebemos é que não existem recursos suficientes para manter Selos em todos os assentamentos de Aviant.
Sir Uiliam|Por isso, as maiores cidades e regiões consideradas estratégicas recebem prioridade.
Aventureiro|E as outras?
Sir Uiliam|Recebem proteção de outra forma.
Aventureiro|Como?
Sir Uiliam|Soldados.
Sir Uiliam|Paladinos.
Sir Uiliam|Aventureiros.
@pause
Sir Uiliam|Pessoas como eu.
Ação|O aventureiro olha ao redor da prefeitura.
Aventureiro|Então é por isso que você foi enviado para cá.
Sir Uiliam|Sim.
Aniri|Um Selo protege uma cidade inteira.
Aniri|Aqui precisam colocar pessoas na estrada para fazer o mesmo trabalho.
Sir Uiliam|Não é exatamente a mesma coisa.
Aniri|Eu sei.
Aniri|Pessoas sangram.
@pause
Ação|Uiliam olha para Aniri.
Sir Uiliam|É por isso que precisamos de mais combatentes.
Aniri|Talvez.
Ação|Ela não insiste.
Aventureiro|Mas quem decide quais lugares recebem um Selo?
Ação|Uiliam demora um pouco para responder.
Sir Uiliam|Não sei exatamente.
Aventureiro|Você é da Ordem.
Sir Uiliam|Sou paladino.
Sir Uiliam|Minha função sempre foi proteger as pessoas.
Sir Uiliam|Não decidir onde os Selos seriam construídos.
Aventureiro|Nunca perguntou?
Ação|Uiliam pensa.
Sir Uiliam|Não.
@pause
Sir Uiliam|Nunca tive motivo para perguntar.
Ação|O aventureiro aceita a resposta.
Aventureiro|Entendi.
Ação|Mas Uiliam permanece olhando para o mapa.
Prefeito|Por isso precisamos tanto dos homens da Ordem.
Prefeito|Sem um Selo, são eles que mantêm essas estradas abertas.
Ação|Uiliam assente.
Sir Uiliam|Sim.
Ação|Ele olha para o mapa.
Sir Uiliam|Uma infestação dentro da vila.
Sir Uiliam|Criaturas nas estradas.
Sir Uiliam|Movimentos próximos à ponte.
Aventureiro|Então os reforços podem ajudar agora...
Aventureiro|mas não explicam por que as criaturas estão aparecendo com mais frequência.
Ação|Uiliam olha para ele.
Sir Uiliam|Exatamente.
Aniri|Então temos dois problemas.
Aventureiro|Jhon.
Aniri|E descobrir por que tudo está ficando pior.
Sir Uiliam|Um de cada vez.
Aniri|Finalmente algo em que todos concordamos.
Prefeito|Existe uma rota mais curta até a Ponte da Esmeralda.
Ação|Ele aponta no mapa.
Prefeito|Sigam por aqui.
Prefeito|Se forem rápidos, alcançarão Jhon pouco depois de ele começar os reparos.
Sir Uiliam|Muito bem.
Prefeito|Tenham cuidado.
Prefeito|E tragam o carpinteiro de volta inteiro.
Aniri|Pretendo.
Ação|Ela começa a caminhar.
Aniri|Principalmente porque ainda preciso trabalhar para ele.
Aventureiro|Essa é sua principal preocupação?
Aniri|Estou aprendendo responsabilidade aos poucos.
Sir Uiliam|Comecemos mantendo o homem vivo.
Aniri|Uma meta bastante razoável.
Ação|Os três deixam a prefeitura.
Ação|Uiliam é o último a sair.
Ação|Por um breve instante, olha novamente para o mapa da vila.
Ação|Seu olhar passa pela localização da vila e depois pelas grandes cidades marcadas ao redor.
Ação|Ele não diz nada.
""",
}


static func has_event(event_id: String) -> bool:
	return SCRIPTS.has(event_id)


static func get_event(event_id: String) -> Array[Dictionary]:
	var sequence: Array[Dictionary] = []
	if not SCRIPTS.has(event_id):
		return sequence

	for raw_line in str(SCRIPTS[event_id]).strip_edges().split("\n"):
		var line: String = raw_line.strip_edges()
		if line == "@pause":
			sequence.append({"type": "pause", "duration": 0.6})
			continue
		var separator: int = line.find("|")
		if separator <= 0:
			continue
		var speaker: String = line.substr(0, separator)
		var dialogue_text: String = line.substr(separator + 1)
		if speaker == "Ação":
			sequence.append({"type": "action", "text": dialogue_text})
		else:
			sequence.append({"type": "dialogue", "speaker": speaker, "text": dialogue_text})

	return sequence
