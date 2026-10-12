extends Node

# Noite posterior ao recrutamento de Kasum. Ele permanece na taverna.
const SCENES := {
	"long_day": [
		"Ação|A taverna fica para trás. Kasum permanece junto à sua caneca enquanto o restante do grupo segue para a Casa de Cura.",
		"Ação|Uma breve transição revela o hall quase vazio. Velas iluminam a sala e a vila silencia do lado de fora.",
		"Ação|Uiliam retira as luvas. O aventureiro se aproxima. Aniri olha pela janela.",
		"Aniri|Foi um dia e tanto.",
		"Aventureiro|Isso vindo de alguém que começou a aventura escondida no porão de uma carpintaria.",
		"Aniri|É... mas acho que vou guardar este dia comigo.",
		"Aventureiro|Por quê?",
		"Aniri|Porque esta manhã eu ainda era apenas uma velha halfling tentando fugir da vida que tinha.",
		"Aniri|Roubei ferramentas, medicamentos e pensei que bastava sair pelos portões para me tornar alguém diferente.",
		"Aniri|Agora estou aqui. Lutei contra criaturas, ajudei pessoas, quase morri...",
		"Aniri|Conheci um monge orc que fala menos do que uma pedra e amanhã vou viajar com um bárbaro que mede o mundo em moedas.",
		"Aniri|Nunca imaginei que me tornaria aquilo que passei tantos anos temendo.",
		"Aventureiro|Uma aventureira?",
		"Aniri|Uma aventureira.",
		"Aniri|Eu achava que aventureiros eram pessoas sem medo de morrer. Hoje descobri que era mentira. Tive muito medo.",
		"Aventureiro|Mas continuou lutando.",
		"Aniri|Continuei. E, pela primeira vez em muito tempo, não me arrependo de estar aqui com vocês."
	],
	"uiliam": [
		"Ação|Uiliam termina de guardar seu equipamento. Ele escutava em silêncio.",
		"Sir Uiliam|O mundo tem esse hábito.",
		"Aniri|Que hábito?",
		"Sir Uiliam|Nos levar para lugares que jamais imaginamos conhecer.",
		"Sir Uiliam|Você pode acordar acreditando que encontrou seu lugar: uma casa, pessoas esperando sua volta, uma vida que continuará amanhã.",
		"Sir Uiliam|E então... em apenas um dia... perder tudo aquilo que amava.",
		"Ação|Aniri percebe a mudança na voz dele.",
		"Aniri|Uiliam... Isso não pareceu algo que leu em um juramento de paladino. Quer falar sobre isso?",
		"Sir Uiliam|Não. Não há necessidade.",
		"Aniri|Necessidade e vontade são coisas diferentes.",
		"Sir Uiliam|Então não tenho nenhuma das duas.",
		"Aniri|Tudo bem.",
		"Sir Uiliam|O passado não pode ser alterado. O que podemos mudar é aquilo que fazemos amanhã.",
		"Sir Uiliam|E amanhã ainda há pessoas que precisam de nós.",
		"Aniri|Pronto. O paladino voltou.",
		"Ação|Uiliam esboça discretamente um sorriso."
	],
	"memory": [
		"Aventureiro|Talvez você tenha razão sobre uma coisa: o passado. Preciso descobrir o meu.",
		"Aniri|Ainda pensando naquilo da prefeitura?",
		"Aventureiro|Sim. Quanto mais tento lembrar, mais estranho fica.",
		"Sir Uiliam|Não se lembra de sua família? De sua cidade?",
		"Aventureiro|Não.",
		"Aniri|Infância?",
		"Aventureiro|Nada. Mas não parece apenas que esqueci.",
		"Aventureiro|Sei que existia antes de chegar aqui. Sinto isso.",
		"Aniri|Mas?",
		"Aventureiro|Quando tento pensar em qualquer coisa antes de Aviant... não existe nada.",
		"Aventureiro|Nenhum rosto, nenhum lugar, nenhum nome.",
		"Aventureiro|É como se minha vida começasse no momento em que abri os olhos aqui. Mas sei que não começou.",
		"Aventureiro|Só não sei como sei disso.",
		"Nova missão pessoal|QUEM SOU EU? — Procure pistas sobre sua origem e descubra como chegou a Aviant."
	],
	"aniri_idea": [
		"Aniri|Talvez eu consiga ajudar. Conheci uma mulher que preparava um veneno.",
		"Sir Uiliam|Já não gosto desta história.",
		"Aniri|Quem bebia dizia enxergar coisas esquecidas: memórias, rostos, lugares.",
		"Aventureiro|Isso poderia funcionar?",
		"Aniri|Talvez.",
		"Sir Uiliam|É veneno.",
		"Aniri|Tecnicamente.",
		"Aventureiro|Qual é o problema?",
		"Aniri|Algumas pessoas morreram.",
		"Aventureiro|Prefiro começar por algo sem morte entre os possíveis resultados.",
		"Aniri|Sensato.",
		"Sir Uiliam|Definitivamente."
	],
	"second_chance": [
		"Ação|Aniri se senta em um dos bancos do hall.",
		"Aniri|Acho que ainda não agradeci direito por não ter me colocado numa cela.",
		"Sir Uiliam|Você devolveu o que roubou.",
		"Aniri|Depois que você me pegou. Poderia ter me entregado aos guardas, mas me deu uma segunda chance.",
		"Sir Uiliam|Você disse que queria lutar e provou que falava sério.",
		"Aniri|Mesmo assim... obrigada.",
		"Sir Uiliam|Faça essa oportunidade valer alguma coisa.",
		"Aniri|Pretendo.",
		"Aniri|Quando o prefeito disse que ainda existia um pingo de esperança nesta cidade, senti que falava de nós. De mim.",
		"Aniri|Passei anos trabalhando, voltando para casa, dormindo e fazendo tudo outra vez. Se desaparecesse, o mundo continuaria igual.",
		"Aniri|Hoje alguém enxergou esperança no que fizemos. Talvez pareça bobo, mas me senti importante.",
		"Sir Uiliam|Não é bobo.",
		"Aniri|Eu sei. Estou aprendendo."
	],
	"solitude": [
		"Ação|O aventureiro senta-se perto de Aniri.",
		"Aventureiro|Posso perguntar uma coisa? O que você mais teme daqui para frente?",
		"Aniri|Depois de tudo que contei, já passou da hora de pedir permissão.",
		"Ação|Desta vez, ela não sorri.",
		"Aniri|Ficar sozinha outra vez.",
		"Aventureiro|Outra vez?",
		"Aniri|Passei quase toda a vida cercada de pessoas. Isso não significa que não estivesse sozinha.",
		"Aniri|Trabalhava porque era o que deveria fazer. Vivia porque todo mundo fazia. Nunca tive um sonho pelo qual alguém perguntaria.",
		"Aniri|Até decidir sair. E agora, pela primeira vez, há pessoas esperando que eu esteja ao lado delas amanhã.",
		"Aventureiro|Então qual é o medo?",
		"Aniri|Descobrir que isso também acaba. Que um dia eu acorde sozinha novamente.",
		"Nova missão de companheiro|SOLIDÃO — Conheça melhor Aniri e descubra a vida que ela deixou para trás."
	],
	"goodnight": [
		"Aventureiro|Você não está sozinha agora. Eu nem sei quem sou. Uiliam tenta carregar todos os problemas de Aviant sozinho.",
		"Sir Uiliam|Não estou.",
		"Aventureiro|E Kasum provavelmente conta nossas moedas na taverna antes mesmo de ganhá-las.",
		"Aniri|Provavelmente.",
		"Aventureiro|É um grupo estranho. Mas é um grupo.",
		"Aniri|É. É um grupo.",
		"Sir Uiliam|Lembrem disso amanhã, quando estivermos cercados por cultistas.",
		"Aniri|Você realmente sabe destruir momentos bonitos.",
		"Sir Uiliam|É uma habilidade adquirida.",
		"Aniri|Finalmente admitiu possuir senso de humor.",
		"Sir Uiliam|Não exagere.",
		"Sir Uiliam|Descansem. Amanhã seguiremos para o templo de Hashagur.",
		"Aniri|E descobriremos por que aquele culto voltou.",
		"Aventureiro|E talvez alguma coisa sobre mim.",
		"Aniri|Uma coisa de cada vez. E, aventureiro? Se descobrir que caiu do céu, quero poder dizer que acertei.",
		"Aniri|Você é o melhor meteoro que pude encontrar.",
		"Aventureiro|Boa noite, Aniri.",
		"Aniri|Boa noite.",
		"Ação|Aniri segue para o quarto. O aventureiro permanece só no hall e olha pela janela.",
		"Aventureiro (pensamento)|Minha história não começou aqui. Então onde começou?",
		"Ação|A câmera se afasta e a noite toma a Casa de Cura."
	]
}

static func get_scene(scene_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for raw_line in SCENES.get(scene_id, []):
		var line: String = str(raw_line)
		var divider: int = line.find("|")
		if divider < 1:
			continue
		result.append({
			"type": "action" if line.substr(0, divider) == "Ação" else "dialogue",
			"speaker": line.substr(0, divider),
			"text": line.substr(divider + 1)
		})
	return result
