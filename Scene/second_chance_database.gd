extends RefCounted

# Roteiro de "Uma Segunda Chance", apresentado após a batalha no porão.
const SCRIPTS := {
	"second_chance_carpenter_return": """
Ação|O grupo sobe as escadas do porão.
Ação|Aniri carrega a bolsa com os objetos roubados. Pela primeira vez desde que foi encontrada, ela está visivelmente menos confiante.
Ação|Jhon está próximo ao balcão quando percebe os três.
Jhon|Voltaram.
Ação|Ele olha para Uiliam e o aventureiro.
Jhon|Então?
Aventureiro|Os ratos não serão mais um problema.
Jhon|Finalmente uma boa notícia.
Aventureiro|Tem outra notícia.
Jhon|Pela sua cara, imagino que essa não seja boa.
Ação|O aventureiro olha para Aniri.
Aniri|Depende muito do seu conceito de “boa”.
Jhon|Quem é ela?
Aniri|Aniri.
Jhon|E por que está saindo do meu porão?
Ação|Silêncio.
Aniri|Essa é a parte ruim.
Sir Uiliam|Aniri.
Ação|Aniri respira fundo.
Aniri|Eu sei.
Ação|Ela se aproxima do balcão e coloca a bolsa sobre ele.
Aniri|Antes de qualquer coisa...
Aniri|isto pertence a você.
Ação|Aniri começa a retirar os objetos.
Jhon|Essas são minhas ferramentas.
Aniri|Sim.
Jhon|Foi você?
Aniri|Foi.
Jhon|Você estava roubando minha carpintaria?
Aniri|Estava.
Jhon|Debaixo do meu próprio teto?
Aniri|Tecnicamente, era debaixo do chão do seu teto—
Ação|Uiliam olha para ela.
Aniri|Não é hora.
Sir Uiliam|Não.
Aniri|Entendido.
Ação|Aniri volta a olhar para Jhon.
Aniri|Eu roubei você.
Aniri|E sinto muito.
Jhon|“Sinto muito”?
Ação|Jhon pega uma das ferramentas.
Jhon|Sabe quanto tempo levei para conseguir algumas dessas coisas?
Aniri|Não.
Jhon|Anos.
Jhon|Algumas eu comprei.
Jhon|Outras eram do meu pai.
Ação|Aniri perde completamente o sorriso.
Aniri|Eu não sabia.
Jhon|Só entrou aqui e pegou.
Aniri|Sim.
Ação|O aventureiro observa Aniri. Ela não tenta se defender.
Jhon|Por quê?
Jhon|Com minhas coisas.
Aniri|Desculpe.
Ação|Ela respira fundo.
Aniri|Eu queria me tornar aventureira.
Jhon|Aventureira?
Aniri|Sim.
Jhon|E aventureiros começam roubando carpinteiros agora?
Sir Uiliam|Definitivamente não.
Aniri|Eu já recebi essa explicação.
Jhon|Ótimo.
Jhon|Então receba novamente.
Aniri|Eu não tinha equipamento.
Aniri|Não tinha ouro suficiente.
Aniri|E estava tão preocupada em finalmente sair daqui que comecei a pensar apenas no que eu precisava.
Aniri|Não em quem teria de pagar por isso.
Ação|Ela olha para as ferramentas.
Aniri|Foi errado.
Aniri|Não tenho uma justificativa melhor.
Jhon|Finalmente alguma coisa sensata.
Aniri|Estou tendo um dia cheio delas.
Ação|Jhon confere os objetos.
Jhon|As ferramentas estão aqui.
Ação|Ele abre a bolsa de moedas e conta.
Jhon|Quase todo o dinheiro também.
Ação|Aniri fica desconfortável.
Aventureiro|“Quase”?
Aniri|Eu...
Ação|Ela levanta a mão.
Aniri|Antes de qualquer julgamento...
Aniri|admito que gastei uma parte.
Jhon|Quanto?
Aniri|Pouco.
Jhon|Quanto?
Aniri|Pouco o bastante para eu preferir não responder.
Jhon|Aniri.
Aniri|Certo.
Ação|Ela diz o valor.
Ação|Jhon fecha os olhos por alguns segundos.
Jhon|Então ainda me deve.
Aniri|Eu sei.
Aniri|E vou pagar.
Jhon|Com quê?
Ação|Aniri olha para a própria bolsa praticamente vazia.
Aniri|Essa parte do plano ainda está em desenvolvimento.
Aventureiro|Seu plano tem muitas partes “em desenvolvimento”.
Aniri|Estou percebendo isso.
""",
	"second_chance_carpenter_choice_chance": """
Aventureiro|Ela poderia ter tentado fugir quando descobrimos tudo.
Aventureiro|Não fugiu.
Jhon|Isso deveria me impressionar?
Aventureiro|Não.
Aventureiro|Mas acho que deveria contar para alguma coisa.
Ação|Jhon olha para Aniri.
Jhon|Conta.
Jhon|Não tanto quanto devolver meu dinheiro.
Aniri|Justo.
""",
	"second_chance_carpenter_choice_jhon": """
Aventureiro|No porão eu disse que essa decisão deveria ser sua.
Ação|Jhon olha para ele.
Aventureiro|Foi você quem ela roubou.
Aventureiro|Então não vou fingir que cabe a mim dizer que está tudo resolvido.
Ação|Aniri permanece em silêncio.
Jhon|Pelo menos alguém aqui pensa assim.
Aniri|Eu também penso assim.
Jhon|Depois de ser pega.
Aniri|...
Aniri|Também é justo.
""",
	"second_chance_carpenter_conclusion": """
Ação|Jhon permanece alguns segundos em silêncio.
Ação|Ele olha para as ferramentas recuperadas.
Ação|Depois para Aniri.
Jhon|Eu poderia chamar os guardas.
Ação|Aniri fica séria.
Aniri|Poderia.
Jhon|E você não tentaria fugir?
Aniri|...
Aniri|Quero dizer que não.
Ação|Breve pausa.
Aniri|Então não.
Aniri|Não fugiria.
Jhon|Hum.
Ação|Jhon aponta para a porta do porão.
Jhon|Sabe o estado em que aquele lugar ficou?
Aniri|Infestado de ratos?
Jhon|Além disso.
Jhon|Caixas quebradas.
Jhon|Madeira espalhada.
Jhon|Estoque destruído.
Jhon|E aparentemente alguém resolveu usar meu porão como esconderijo particular.
Aniri|Essa última parte foi minha.
Jhon|Eu sei.
Ação|Jhon cruza os braços.
Jhon|Vai trabalhar para mim.
Aniri|Como?
Jhon|Até pagar o que ainda me deve.
Aniri|Você prefere isso a me entregar aos guardas?
Jhon|Prefiro recuperar meu prejuízo.
Jhon|Uma cela não vai limpar meu porão.
Ação|Aniri olha para o aventureiro.
Aniri|Estou começando a gostar deste homem.
Jhon|Não se acostume.
Aniri|Todo mundo diz isso por aqui?
Sir Uiliam|Parece ser necessário com você.
Aniri|Então temos um acordo.
Jhon|Não.
Aniri|Não?
Jhon|Temos uma dívida.
Aniri|Isso soa muito menos amigável.
Jhon|Porque é.
Ação|Aniri estende a mão.
Aniri|Mesmo assim.
Ação|Jhon olha para a mão dela.
Ação|Depois aperta.
Jhon|Cumpra sua palavra.
Aniri|Vou cumprir.
Ação|Jhon recolhe as ferramentas.
Jhon|E se alguma coisa desaparecer novamente...
Aniri|Você chama os guardas.
Jhon|Não.
Ação|Aniri parece surpresa.
Jhon|Primeiro eu encontro você.
Aniri|...
Aniri|Os guardas parecem melhores.
Aventureiro|Estou começando a entender por que você não roubou uma segunda vez.
Aniri|Ainda estamos no mesmo dia.
Aventureiro|Bom ponto.
Ação|O grupo começa a se afastar do balcão.
Aniri|Pronto.
Aniri|Ferramentas devolvidas.
Aniri|Dívida negociada.
Aniri|Ninguém foi preso.
Ação|Ela respira aliviada.
Aniri|Considero isso uma vitória.
Sir Uiliam|Ainda não terminamos.
Ação|Aniri congela.
Aniri|Por quê?
Ação|Uiliam aponta para a bolsa dela.
Sir Uiliam|E aquilo?
Ação|Aniri olha.
Aniri|Aquilo?
Sir Uiliam|Sim.
Aniri|Meus pertences pessoais.
Aventureiro|Você pareceu muito rápida para responder.
Aniri|Sou uma mulher decidida.
Sir Uiliam|Abra.
Aniri|Estamos ficando muito próximos muito rápido.
Sir Uiliam|Aniri.
Aniri|Certo.
Ação|Ela abre a bolsa.
Ação|Silêncio.
Aventureiro|Aniri.
Aniri|Sim?
Aventureiro|Por favor, diga que comprou isso.
Ação|Aniri olha para ele.
Aniri|Eu poderia dizer.
Aventureiro|Mas seria verdade?
Aniri|Não.
Aventureiro|Imaginei.
Aniri|Este está sendo um dia muito educativo.
""",
	"second_chance_healer_return": """
Ação|O grupo entra na Casa de Cura.
Ação|A curandeira organiza frascos e bandagens atrás do balcão.
Curandeira|Sr. Uiliam.
Curandeira|Que surpresa.
Ação|Ela olha para o aventureiro e Aniri.
Curandeira|Precisam de atendimento?
Aniri|Depende.
Aniri|Arrependimento é uma condição médica?
Curandeira|Normalmente não.
Aniri|Então estamos aqui por outro motivo.
Ação|Aniri coloca a poção e as bandagens sobre o balcão.
Ação|A curandeira reconhece imediatamente os objetos.
Curandeira|Onde encontraram isso?
Ação|Aniri fecha os olhos por um instante.
Aniri|Não encontramos.
Curandeira|Como?
Aniri|Eu roubei.
Ação|Silêncio.
Curandeira|Você...
Aniri|Sim.
Aniri|Eu sei.
Curandeira|Nem terminei.
Aniri|Depois da carpintaria estou começando a prever a conversa.
Curandeira|Por que levou isso?
Aniri|Eu pretendia viajar.
Aniri|Imaginei que precisaria de algo para tratar ferimentos.
Curandeira|Então decidiu roubar medicamentos.
Aniri|Naquele momento pareceu uma ideia melhor.
Aventureiro|Ela tinha um plano ruim.
Aniri|Obrigado pelo apoio.
Aventureiro|Estou sendo preciso.
Curandeira|Sabe quem usa essas poções?
Aniri|Aventureiros?
Curandeira|Também.
Curandeira|Crianças feridas.
Curandeira|Trabalhadores.
Curandeira|Guardas.
Curandeira|Viajantes que chegam aqui sem condições de procurar outro lugar.
Ação|Aniri fica séria.
Curandeira|Ontem uma dessas pessoas poderia ter entrado por aquela porta.
Curandeira|E eu teria uma poção a menos porque você decidiu que sua viagem era mais importante.
Ação|Aniri baixa os olhos.
Aniri|Eu não pensei nisso.
Curandeira|Esse é exatamente o problema.
Ação|Silêncio.
Aniri|Tem razão.
Aniri|Eu estava tão preocupada em conseguir sair daqui...
Aniri|que comecei a tratar todo mundo ao meu redor como parte do caminho.
Ação|Ela olha para os itens.
Aniri|Jhon tinha ferramentas.
Aniri|Você tinha medicamentos.
Aniri|E eu só enxerguei coisas das quais precisava.
Ação|Pequena pausa.
Aniri|Não as pessoas que precisavam delas também.
Curandeira|Agora enxergou?
Aniri|Agora sim.
Aventureiro|Posso perguntar uma coisa?
Curandeira|Claro.
Aventureiro|Se ela tivesse simplesmente desaparecido com tudo...
Aventureiro|o que aconteceria?
Curandeira|Eu provavelmente teria comprado novos suprimentos.
Curandeira|Se tivesse dinheiro.
Aventureiro|Então devolver não desfaz o problema.
Curandeira|Não.
Aventureiro|Mas impede que ele fique pior.
Ação|A curandeira olha para Aniri.
Curandeira|Sim.
Aniri|Estou gostando mais dessa parte.
Aventureiro|Não terminei.
Aniri|Naturalmente.
Aventureiro|Você ainda precisa aprender a não criar o problema primeiro.
Ação|Aniri suspira.
Aniri|Estava bom por alguns segundos.
Sir Uiliam|Se pretende realmente seguir pelas estradas...
Sir Uiliam|precisa compreender uma coisa.
Ação|Aniri olha para ele.
Sir Uiliam|Ser capaz de lutar não transforma alguém em aventureiro.
Sir Uiliam|Uma espada pode proteger uma pessoa.
Sir Uiliam|Também pode tomar aquilo que pertence a ela.
Sir Uiliam|A diferença está em quem a segura.
Ação|Aniri fica em silêncio.
Sir Uiliam|Você disse que não quer mais esperar que outros protejam este mundo.
Sir Uiliam|Então comece decidindo que tipo de pessoa pretende ser quando tiver poder para fazer alguma coisa.
Aniri|...
Aniri|Uma melhor do que aquela que entrou neste lugar ontem.
Sir Uiliam|É um começo.
Ação|A curandeira examina a poção.
Curandeira|O lacre continua intacto.
Ação|Ela verifica as bandagens.
Curandeira|E isto também pode voltar ao estoque.
Aniri|Então...
Curandeira|Então não vou chamar os guardas.
Ação|Aniri solta o ar.
Curandeira|Mas não confunda isso com aprovação.
Aniri|Não confundirei.
Curandeira|E se quiser alguma coisa daqui novamente...
Aniri|Eu pago.
Curandeira|Antes de pegar.
Aniri|Parece um detalhe importante.
Curandeira|Para você, aparentemente é.
Ação|O aventureiro sorri.
Curandeira|Onde vocês vão dormir esta noite?
Ação|Aniri parece surpresa.
Aniri|Depois de tudo isso?
Curandeira|Não estou recompensando você por roubar minha loja.
Aniri|Bom esclarecer.
Curandeira|Estou reconhecendo que voltou para devolver o que pegou quando poderia ter fugido.
Curandeira|E vocês dois ajudaram esta vila hoje.
Ação|Ela olha para Uiliam e o aventureiro.
Curandeira|Podem passar esta noite aqui.
Aventureiro|Sem cobrar?
Curandeira|Sem cobrar.
Aniri|Estou começando a gostar muito desta segunda chance.
Curandeira|Não abuse dela.
Aniri|Essa frase também está começando a aparecer bastante hoje.
""",
	"second_chance_village_choice_intro": """
Ação|O grupo permanece no hall da Casa de Cura.
Aniri|Então...
Aniri|Jhon não me entregou aos guardas.
Aniri|A curandeira também não.
Aniri|E, tecnicamente, terminei o dia com um lugar melhor para dormir do que tinha quando comecei.
Aventureiro|Você está tentando transformar isso numa vitória de novo?
Aniri|Estou procurando o lado positivo.
Aventureiro|Você ainda deve ouro para Jhon.
Aniri|Lado positivo menor.
Sir Uiliam|E trabalho.
Aniri|Muito menor.
Ação|Ela sorri.
""",
	"second_chance_choice_acceptance": """
Aventureiro|Você fez besteira.
Aniri|Uma forma delicada de dizer.
Aventureiro|Mas voltou.
Aventureiro|Devolveu o que conseguiu devolver.
Aventureiro|E não fugiu quando as pessoas ficaram com raiva.
Ação|Aniri fica um pouco mais séria.
Aventureiro|Isso importa.
Aniri|Então ainda acha que mereço uma chance?
Aventureiro|Acho.
Aventureiro|Mas uma chance não significa que vou acreditar em tudo que disser.
Aniri|Justo.
Ação|Ela sorri.
Aniri|Vou considerar isso um começo.
""",
	"second_chance_choice_distrust": """
Aventureiro|Ainda não confio em você.
Ação|Aniri fica em silêncio.
Aventureiro|Mas isso não significa que quero ver você fracassar.
Aniri|Então o que significa?
Aventureiro|Que quero ver se aquilo que disse no porão era verdade.
Aventureiro|Que realmente pretende mudar.
Ação|Aniri assente.
Aniri|Justo.
Aniri|Confiança não é uma coisa que eu possa simplesmente pegar de alguém.
Ação|Pausa.
Aniri|Já descobri que tenho problemas suficientes com esse conceito.
Aventureiro|Você vai precisar conquistar a minha.
Aniri|Então é isso que vou fazer.
""",
	"second_chance_new_adventurer": """
Ação|Uiliam, que estava ouvindo a conversa, olha para Aniri.
Sir Uiliam|Aniri.
Aniri|Já devolvi tudo que encontramos.
Sir Uiliam|Não é sobre isso.
Aniri|Ah.
Sir Uiliam|Depois de hoje...
Sir Uiliam|ainda pretende sair dessas muralhas?
Ação|Aniri não precisa pensar.
Aniri|Sim.
Sir Uiliam|Ainda pretende se tornar aventureira?
Aniri|Mais do que antes.
Aventureiro|Mesmo com uma dívida agora?
Aniri|Principalmente porque tenho uma dívida agora.
Aventureiro|Como isso ajuda?
Aniri|Ainda estou desenvolvendo essa parte.
Ação|Uiliam quase sorri.
Sir Uiliam|Não estou perguntando por brincadeira.
Ação|Aniri percebe o tom.
Sir Uiliam|Lá fora, seus erros não terminarão apenas em moedas perdidas.
Sir Uiliam|Uma decisão errada pode matar você.
Ação|Pausa.
Sir Uiliam|Ou alguém que esteja confiando em você.
Ação|Aniri fica séria.
Aniri|Eu sei.
Sir Uiliam|Ainda quer ir?
Aniri|Quero.
Sir Uiliam|Por escolha própria?
Aniri|Sim.
Ação|Uiliam observa Aniri por alguns segundos.
Sir Uiliam|Então termine o que começou aqui.
Sir Uiliam|Cumpra sua palavra a Jhon.
Sir Uiliam|E prove que está disposta a carregar algo além de uma arma.
Aniri|Responsabilidade?
Sir Uiliam|Responsabilidade.
Aniri|Eu preferia uma espada.
Aventureiro|Imagino que seja mais leve.
Aniri|Muito.
Aniri|E depois?
Sir Uiliam|Depois...
Ação|Uiliam olha para o aventureiro.
Sir Uiliam|se ainda quiser seguir esse caminho...
Sir Uiliam|podemos viajar juntos por algum tempo.
Ação|Aniri fica surpresa.
Aniri|Está me convidando?
Sir Uiliam|Estou oferecendo uma oportunidade.
Aniri|Isso parece exatamente um convite dito por um paladino.
Aventureiro|Ele também transforma apresentações em juramentos.
Aniri|Estou começando a perceber.
Sir Uiliam|A decisão é sua, Aniri.
Ação|Pequena pausa.
Aniri|Então sim.
Aniri|Quero ir.
Sir Uiliam|Muito bem.
Aniri|Só existe um problema.
Sir Uiliam|Qual?
Aniri|Nunca fiz isso antes.
Aventureiro|Nem eu.
Ação|Aniri olha para ele.
Aniri|Você não se lembra se fez.
Aventureiro|Detalhes.
Ação|Ela sorri.
Aniri|Então talvez sejamos uma dupla promissora.
Sir Uiliam|Essa conclusão é prematura.
Aniri|Ele realmente sabe acabar com momentos.
Ação|Uiliam começa a seguir para os quartos.
Sir Uiliam|Descansem.
Sir Uiliam|Amanhã continuaremos.
Aniri|“Continuaremos” o quê?
Sir Uiliam|Descobrindo se vocês dois conseguem permanecer vivos tempo suficiente para se tornarem aventureiros.
Aventureiro|Reconfortante.
Aniri|Ele faz isso bastante?
Aventureiro|Mais do que gostaria.
Ação|Uiliam para por um momento.
Sir Uiliam|Há pouca gente disposta a sair dessas muralhas.
Ação|Ele olha para Aniri.
Sir Uiliam|Quando alguém escolhe enfrentar aquilo que existe lá fora...
Sir Uiliam|essa escolha deve significar alguma coisa.
Ação|Pequena pausa.
Sir Uiliam|Já perdemos aventureiros demais.
Ação|Por um instante sua expressão muda.
Sir Uiliam|Não quero ver mais alguém disposto a lutar desaparecer por falta de preparo.
Ação|Aniri observa Uiliam.
Aniri|Então pretende manter todos nós vivos?
Sir Uiliam|Pretendo tentar.
Aniri|Boa sorte.
Sir Uiliam|Vou precisar.
""",
	"second_chance_healer_morning": """
Ação|O grupo segue para os quartos.
@fade_out
@fade_in
Ação|O aventureiro, Uiliam e Aniri estão novamente no hall da Casa de Cura.
Ação|A curandeira se aproxima carregando três pequenas poções.
Curandeira|Antes que partam.
Ação|Ela coloca os frascos sobre o balcão.
Aniri|Essas são...
Curandeira|Três poções.
Aniri|De graça?
Curandeira|Para o grupo.
Ação|Ela olha diretamente para Aniri.
Curandeira|Não para recompensar você pelo que fez ontem.
Aniri|Eu já estava preparando um agradecimento.
Curandeira|Pode agradecer usando-as para manter alguém vivo.
Ação|Aniri fica mais séria.
Curandeira|Você queria levar uma poção porque achava que uma aventureira precisava estar preparada.
Curandeira|Nisso estava certa.
Curandeira|Só precisava aprender que existem maneiras melhores de conseguir uma.
Aniri|Entendido.
Ação|A curandeira empurra os frascos na direção do aventureiro.
Ação|Item recebido: +3 Poções de Cura.
Curandeira|Usem com sabedoria.
Aventureiro|Obrigado.
Aniri|E...
Ação|Aniri parece um pouco constrangida.
Aniri|obrigada pela chance.
Curandeira|Faça alguma coisa boa com ela.
Ação|Aniri assente.
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
		if line == "@fade_out":
			sequence.append({"type": "start_fade_to_black", "duration": 1.5})
			sequence.append({"type": "wait_for_fade"})
			sequence.append({"type": "pause", "duration": 1.0})
			continue
		if line == "@fade_in":
			sequence.append({"type": "fade_from_black", "duration": 1.5})
			sequence.append({"type": "action", "text": "Uma noite se passa."})
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
