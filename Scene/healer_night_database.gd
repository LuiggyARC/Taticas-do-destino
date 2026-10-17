extends Node

# Segunda noite na Casa de Cura. Kasum permanece na taverna.
const SCENES := {
	"long_day": """
Ação|O hall da Casa de Cura está quase vazio. Algumas velas permanecem acesas; a vila está silenciosa depois de dois dias agitados.
Ação|Uiliam retira as luvas e parte da armadura. O aventureiro descansa próximo à janela. Aniri observa a rua.
@pause
Aniri|Dois dias.
Aventureiro|O quê?
Aniri|Faz dois dias que tudo isso começou.
Ação|Ela pensa por um instante.
Aniri|Parece muito mais.
Aventureiro|No primeiro você estava escondida num porão.
Aniri|E você não sabia nem onde estava.
Aventureiro|Ainda não sei muita coisa.
Aniri|Mas agora sabe onde fica a taverna.
Aventureiro|Progresso.
Ação|Aniri sorri.
Aniri|Ontem eu estava tentando fugir da vila com ferramentas roubadas.
Aniri|Hoje ajudei a defender uma ponte, enfrentei cultistas...
Aniri|e terminei o dia viajando com um paladino, um homem sem memória e um bárbaro que provavelmente está contando nosso ouro neste momento.
Aventureiro|Quando coloca desse jeito...
Aniri|Parece uma péssima decisão.
@pause
Aniri|Mas não estou arrependida.
Aventureiro|Nem com medo?
Aniri|Com muito medo.
Ação|Ela olha para ele.
Aniri|Só não quero mais deixar o medo decidir por mim.
@pause
Aniri|E é estranho.
Aventureiro|O quê?
Aniri|Conheço vocês há dois dias.
Ação|Ela olha para Uiliam e depois para o aventureiro.
Aniri|Mas já não parece que estou fazendo isso sozinha.
""",
	"uiliam": """
Ação|Uiliam termina de guardar a armadura.
Sir Uiliam|Dois dias podem mudar muita coisa.
Aniri|Isso parece experiência falando.
@pause
Sir Uiliam|Às vezes basta um.
Ação|Aniri perde o sorriso.
Sir Uiliam|Você pode acordar com uma casa...
Sir Uiliam|pessoas esperando sua volta...
Ação|Ele para.
Sir Uiliam|e terminar o mesmo dia sem nada disso.
@pause
Aniri|Uiliam...
Ação|Ele olha para ela.
Aniri|Quer falar sobre isso?
Sir Uiliam|Não.
Ação|Aniri apenas assente.
Sir Uiliam|O passado não muda.
Sir Uiliam|O que fazemos amanhã, sim.
Aniri|E amanhã existem pessoas para salvar.
Sir Uiliam|Exatamente.
Aniri|Pronto.
Aniri|O paladino voltou.
Ação|Uiliam quase sorri.
""",
	"memory": """
Aventureiro|É estranho ouvir vocês falando sobre dois dias.
Aniri|Por quê?
Aventureiro|Porque são todas as lembranças que eu tenho.
Ação|O tom muda.
Sir Uiliam|Nada antes disso?
Aventureiro|Nada.
Aniri|Família?
Aventureiro|Não.
Sir Uiliam|Algum lugar?
Aventureiro|Não.
@pause
Aventureiro|É como se minha vida tivesse começado há dois dias.
Ação|O som ambiente diminui discretamente.
Aventureiro|Mas eu sei que não começou.
Aniri|Como sabe?
Ação|O aventureiro demora a responder.
Aventureiro|Esse é o problema.
Aventureiro|Eu não sei.
@pause
Sir Uiliam|Então encontraremos uma resposta.
Aventureiro|“Encontraremos”?
Sir Uiliam|Se permitir.
Ação|O aventureiro assente.
""",
	"aniri_idea": """
Aniri|Talvez eu conheça uma maneira de recuperar memórias.
Aventureiro|Sério?
Aniri|Conheci uma mulher que preparava uma mistura.
Sir Uiliam|Que mistura?
Aniri|Veneno.
Sir Uiliam|Não.
Aniri|Você nem ouviu o resto.
Sir Uiliam|Ouvi a parte necessária.
Aniri|Algumas pessoas diziam lembrar coisas antigas depois de beber.
Aventureiro|E as outras?
Aniri|Algumas morriam.
@pause
Aventureiro|Vamos guardar essa opção para... nunca.
Sir Uiliam|Concordo.
Aniri|Vocês são muito fechados a métodos alternativos.
""",
	"second_chance": """
Ação|Aniri se senta.
Aniri|Uiliam.
Sir Uiliam|Sim?
Aniri|Obrigada.
Sir Uiliam|Pelo quê?
Aniri|Por ontem.
Aniri|Por não ter me entregado aos guardas.
Sir Uiliam|Você assumiu o que fez.
Aniri|Depois que fui pega.
Sir Uiliam|Continua contando.
Ação|Ela sorri.
Aniri|Hoje Jhon disse que minha dívida estava paga.
Aniri|O prefeito falou de esperança.
Ação|Ela olha para as próprias mãos.
Aniri|E por alguns segundos achei que ele também estava falando de mim.
Aventureiro|Gostou disso?
Aniri|Mais do que deveria.
Sir Uiliam|Por quê?
Aniri|Porque passei muito tempo sem sentir que fazia diferença.
@pause
Aniri|Agora faz dois dias que alguém espera que eu apareça no dia seguinte.
""",
	"solitude": """
Aventureiro|É disso que tem medo?
Aniri|Não.
Ação|Ela pensa.
Aniri|Tenho medo de perder isso.
Aventureiro|O grupo?
Aniri|Ter alguém.
@pause
Aniri|Passei muito tempo cercada de pessoas.
Aniri|Ainda assim, estava sozinha.
Ação|Ela olha para os dois.
Aniri|Agora acordo sabendo que alguém espera que eu esteja lá.
Aniri|É bom.
Ação|O sorriso diminui.
Aniri|Talvez bom demais.
Aventureiro|E se acabar?
Aniri|Esse é exatamente o medo.
""",
	"goodnight": """
Ação|O aventureiro fica alguns segundos em silêncio.
Aventureiro|Bem...
Aventureiro|não acabou hoje.
Ação|Aniri olha para ele.
Aventureiro|Eu não sei quem sou.
Aventureiro|Uiliam transforma qualquer problema em uma missão.
Sir Uiliam|Não faço isso.
Aventureiro|E Kasum provavelmente está gastando o pagamento antes de receber.
Aniri|Com certeza.
Aventureiro|Somos um grupo estranho.
Aniri|Muito.
Aventureiro|Mas amanhã ainda seremos um grupo estranho.
Ação|Aniri sorri.
Aniri|Amanhã basta.
Ação|Uiliam observa os dois.
Sir Uiliam|Espero que mantenham esse entusiasmo quando estivermos diante dos cultistas.
Aniri|Você realmente sabe destruir momentos.
Sir Uiliam|Tenho prática.
Aniri|Isso foi uma piada.
Sir Uiliam|Descansem.
Ação|Aniri se levanta.
Aniri|Aventureiro.
Aventureiro|Sim?
Aniri|Se descobrir que realmente caiu do céu...
Aniri|Quero que saiba que você é o melhor meteorito que ja conheci.
Aventureiro|Obrigado.
Aniri|Boa noite.
Aventureiro|Boa noite.
Ação|Ela segue para o quarto. O aventureiro permanece sozinho no hall.
Aventureiro (pensamento)|Dois dias.
@pause
Aventureiro (pensamento)|São todas as lembranças que tenho.
Ação|Ele olha através da janela.
Aventureiro (pensamento)|Então onde estava antes?
"""
}


static func get_scene(scene_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not SCENES.has(scene_id):
		return result
	for raw_line in str(SCENES[scene_id]).strip_edges().split("\n"):
		var line: String = raw_line.strip_edges()
		if line == "@pause":
			result.append({"type": "pause", "duration": 0.6})
			continue
		var divider: int = line.find("|")
		if divider < 1:
			continue
		var speaker: String = line.substr(0, divider)
		var dialogue_text: String = line.substr(divider + 1)
		if speaker == "Ação":
			result.append({"type": "action", "text": dialogue_text})
		else:
			result.append({"type": "dialogue", "speaker": speaker, "text": dialogue_text})
	return result
