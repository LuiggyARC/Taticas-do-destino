extends Node

# Encontro na estrada para o monastério de Hashagur.
const SCENES := {
	"road": """
Ação|O grupo segue pela estrada entre a floresta e as montanhas.
Kasum|Quanto falta?
Sir Uiliam|Segundo o mapa, horas.
Kasum|Disse isso antes.
Sir Uiliam|Há quarenta minutos.
Kasum|Pareceu mais.
Aniri|Começou a se arrepender?
Kasum|Ainda não encontrei ouro suficiente para decidir.
Aniri|Pelo menos é consistente.
Ação|Mais adiante, duas pessoas caminham na direção contrária: um humano e uma elfa, exaustos e cobertos de fuligem e poeira.
Ação|A elfa segura um velho grimório contra o peito. O homem permanece sempre próximo dela.
Aniri|Uma elfa?
Aventureiro|Isso é estranho?
Aniri|Fora dos bosques? Bastante.
Ação|Os dois se aproximam.
""",
	"meeting": """
Litz|Antes que perguntem, não somos uma ameaça.
Arievilo|Litz...
Litz|O quê?
Arievilo|Ninguém perguntou.
Litz|Estou me antecipando.
Aniri|Não está ajudando.
Ação|Arievilo faz uma pequena reverência.
Arievilo|Sou Arievilo.
Ação|Ela indica o homem ao seu lado.
Arievilo|E ele é Litz.
Litz|Feiticeiro.
@pause
Litz|Um bom feiticeiro.
Arievilo|É melhor com magia do que com apresentações.
Litz|Muito melhor.
Ação|Uiliam observa as roupas queimadas dos dois.
Sir Uiliam|De onde estão vindo?
Ação|O leve humor desaparece.
Arievilo|Da Cidade de Montirel.
""",
	"capital": """
Sir Uiliam|A cidade mais próxima.
Litz|O que restou dela.
Ação|Uiliam imediatamente fica sério.
Sir Uiliam|Explique.
Litz|Estamos andando há dois dias.
Litz|Duas noites atrás, a cidade foi atacada.
Aventureiro|Criaturas?
Arievilo|Muitas.
Sir Uiliam|A capital possui um Selo.
Arievilo|Possuía.
@pause
Sir Uiliam|O Selo caiu?
Litz|Sim.
Ação|Uiliam claramente não esperava essa resposta.
Aniri|Isso já aconteceu antes?
Sir Uiliam|Não com uma grande cidade.
@pause
Aventureiro|Sabem por que falhou?
Litz|Não.
Litz|A única coisa diferente foi a troca de rei.
Sir Uiliam|Troca de rei?
Litz|O novo rei assumiu há pouco mais de um mês.
Ação|Uiliam pensa por um instante.
Sir Uiliam|E um mês depois a capital foi atacada.
Litz|Sim.
Arievilo|Mas ninguém sabia o que estava acontecendo.
Arievilo|Quando perceberam que o Selo não estava nos protegendo...
Ação|Ela olha para o chão.
Arievilo|já havia criaturas dentro da cidade.
""",
	"forest": """
Aniri|E você?
Ação|Ela olha para Arievilo.
Aniri|Não parece alguém da capital.
Arievilo|Não sou.
Arievilo|Eu vivia no Bosque ao lado da cidade.
Ação|Ela aperta o grimório.
Arievilo|Perto demais da cidade.
Litz|Quando o ataque começou, alguma coisa também aconteceu na floresta.
Aventureiro|O quê?
Litz|Uma fenda.
Ação|O aventureiro fica imóvel por um instante.
Litz|As criaturas vieram de todos os lados.
Arievilo|A floresta queimou.
@pause
Arievilo|Minha casa também.
Ação|Ela não continua. Litz olha para ela antes de falar.
Litz|Eu morava na capital.
Aniri|Então como vocês acabaram juntos?
Litz|Eu fui procurá-la.
Aniri|Durante o ataque?
Litz|Sim.
Aniri|Na floresta?
Litz|Sim.
Ação|Aniri olha para Arievilo.
Aniri|Vocês já se conheciam?
Arievilo|Sim, mas não é hora de falar sobre.
Ação|É a primeira vez que ela esboça um sorriso.
""",
	"book": """
Sir Uiliam|Como a encontrou?
Litz|Inconsciente.
Ação|Ele olha para o grimório.
Litz|Segurando esse livro.
Arievilo|Era da minha mãe.
@pause
Aniri|Havia criaturas por perto?
Litz|Sim.
Aniri|E você matou todas?
Litz|Não.
Ação|Arievilo baixa os olhos.
Litz|Elas já estavam mortas.
Aventureiro|Como?
Litz|Queimadas.
Litz|Todas.
Sir Uiliam|Magia?
Litz|Imagino.
Ação|Uiliam olha para Arievilo.
Sir Uiliam|Você se lembra?
Arievilo|Não.
Ação|Ela aperta o grimório.
Arievilo|Minha última lembrança é da minha mãe.
Arievilo|Depois disso...
Ação|Ela olha para Litz.
Arievilo|eu acordei com ele ao meu lado.
""",
	"together": """
Aniri|E ele ficou?
Arievilo|A noite inteira.
Litz|Ela estava ferida.
Arievilo|Ele quase morreu duas vezes.
Litz|Mas não morri.
Arievilo|Ele sempre responde isso.
Litz|Continua sendo verdade.
Ação|Arievilo segura discretamente a mão dele.
Arievilo|Quando acordei...
Arievilo|não tinha casa.
Arievilo|Não sabia se minha família estava viva.
@pause
Arievilo|Não havia nada para onde voltar.
Ação|Ela olha para Litz.
Arievilo|Mas ele ficou.
Litz|Não ia deixar você sozinha.
Arievilo|Eu sei.
Ação|Os dois permanecem de mãos dadas.
Aniri|Entendi.
Litz|O quê?
Aniri|Vocês dois.
Ação|Litz sorri.
Litz|Eu sempre achei ela bonita.
Arievilo|Litz...
Litz|O quê? É verdade.
Ação|Arievilo balança a cabeça, mas pela primeira vez parece genuinamente mais leve.
""",
	"rift": """
Ação|O aventureiro permanece olhando para Arievilo.
Aventureiro|Você perdeu suas lembranças perto da fenda.
Arievilo|Sim.
Aventureiro|E não lembra do que aconteceu antes de acordar.
Arievilo|Não daquela parte.
Ação|O som ao redor diminui discretamente.
Aventureiro (pensamento)|Uma fenda.
@pause
Aventureiro (pensamento)|E uma parte da memória desaparecida.
Ação|Ele sente um calafrio.
Aniri|[PLAYER_NAME]?
Ação|O som retorna.
Aventureiro|Estou bem.
Aniri|Você sempre diz isso com uma cara que diz o contrário.
Aventureiro|Só estava pensando.
Aniri|Nas fendas.
Ação|Ele não responde.
Aniri|Imaginei.
""",
	"directions": """
Sir Uiliam|Para onde estão indo?
Arievilo|Não sabemos.
Litz|Para longe da capital.
Arievilo|Estamos caminhando há dois dias.
Litz|E quase sem comida.
Arievilo|Você poderia pedir de uma maneira menos vergonhosa.
Litz|Estou tentando ser objetivo.
Ação|Ele olha para o grupo.
Litz|Vocês conhecem algum lugar seguro?
Aventureiro|Há uma vila atrás de nós.
Aventureiro|A Ponte da Esmeralda foi restaurada ontem.
Arievilo|É segura?
Ação|Uiliam hesita apenas um instante.
Sir Uiliam|Há reforços da Ordem lá.
Sir Uiliam|É o melhor lugar próximo.
Ação|Arievilo respira aliviada.
Arievilo|Obrigada.
Ação|Uiliam entrega algumas moedas a Litz.
Litz|Não precisamos—
Arievilo|Precisamos.
Ação|Litz olha para ela.
Litz|Precisamos.
Sir Uiliam|Comprem comida.
Litz|Obrigado.
Aniri|Viu? Não foi tão difícil.
Litz|Eu estava chegando nessa parte.
""",
	"farewell": """
Arievilo|E vocês?
Sir Uiliam|Vamos ao monastério de Hashagur.
Ação|Arievilo fica séria.
Arievilo|Tenham cuidado.
Kasum|Pretendemos.
Arievilo|Não estava falando por educação.
Ação|Litz segura a mão dela.
Litz|Ela acha que tudo vai dar errado.
Arievilo|Ultimamente costuma dar.
Litz|Nem tudo.
Ação|Arievilo olha para ele e esboça um pequeno sorriso.
Arievilo|Nem tudo.
Aniri|Gostei dela.
Litz|Eu também.
Arievilo|Percebi.
Ação|Aniri ri.
Arievilo|Espero que nos encontremos novamente.
Sir Uiliam|Boa viagem.
Ação|O casal segue pela estrada de mãos dadas.
""",
	"after": """
Ação|O grupo observa os dois se afastarem.
Aniri|Uma capital protegida caiu.
Sir Uiliam|Sim.
Aniri|Um mês depois da troca de rei.
Ação|Uiliam permanece olhando para a estrada.
Sir Uiliam|Também percebi.
Kasum|Isso muda nosso caminho?
Sir Uiliam|Não.
Sir Uiliam|Primeiro Hashagur.
Aventureiro|E depois?
Ação|Uiliam olha na direção de onde Litz e Arievilo vieram.
Sir Uiliam|Depois descobrimos como um Selo de uma capital simplesmente caiu.
Ação|O aventureiro permanece pensativo.
Aventureiro (pensamento)|E o que uma fenda tem a ver comigo.
"""
}

const ORDER := [
	"road", "meeting", "capital", "forest", "book",
	"together", "rift", "directions", "farewell", "after"
]


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
