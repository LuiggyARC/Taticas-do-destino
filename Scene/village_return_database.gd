extends Node

# Retorno à prefeitura após a Ponte da Esmeralda.
const SCENES := {
	"mission": """
Ação|O grupo entra novamente na prefeitura. O prefeito se levanta ao ver Jhon.
Prefeito|Jhon! Conseguiram?
Jhon|A ponte está de pé.
Ação|Jhon boceja.
Jhon|Quanto a mim... não tenho tanta certeza.
Prefeito|Você está péssimo.
Jhon|Passei a noite consertando uma ponte.
Aniri|Nós sugerimos dormir.
Jhon|Dormir não conserta pontes.
Aniri|Ele continua defendendo essa teoria.
Prefeito|De qualquer forma, prestou um grande serviço à vila.
Jhon|Ótimo.
Jhon|Agora pretendo prestar um grande serviço à minha cama.
Ação|Jhon começa a sair, mas para ao lado de Aniri.
Jhon|Ah... pequena.
Aniri|Eu ainda pretendo pagar o restante.
Jhon|Esqueça.
Aniri|Como?
Jhon|Você devolveu minhas coisas.
Jhon|E me ajudou a sair vivo daquela ponte.
Ação|Aniri fica em silêncio.
Jhon|Considere sua dívida paga.
Aniri|Tem certeza?
Jhon|Tenho.
Jhon|Só não transforme minha carpintaria em depósito novamente.
Aniri|Prometo usar a porta da próxima vez.
Jhon|Não foi isso que eu quis dizer.
Aniri|Eu sei.
Ação|Ela sorri.
Aniri|Obrigada, Jhon.
Jhon|Faça valer a segunda chance.
Ação|Jhon começa a sair.
Jhon|Se alguém precisar de mim nas próximas doze horas...
Ação|Ele abre a porta.
Jhon|...não precisa.
Ação|Jhon sai. Aniri não possui mais dívidas com ele.
Aniri|Então é oficial.
Aventureiro|O quê?
Aniri|Sou uma aventureira sem dívidas.
@pause
Aniri|Financeiras, pelo menos.
""",
	"reward": """
Prefeito|Também devo agradecer a vocês.
Prefeito|A ponte foi restaurada, os comerciantes voltaram e os reforços da Ordem finalmente chegaram.
Ação|O prefeito retira uma bolsa da mesa.
Prefeito|Como prometido.
Ação|A recompensa pelo serviço é de 300 peças de ouro.
Aniri|Trezentas?
Ação|Ela olha para o aventureiro.
Aniri|Só quero registrar que fui fundamental nessa missão.
Sir Uiliam|Você havia esquecido da recompensa.
Aniri|Lembrei no momento importante.
Prefeito|As carroças também trouxeram os estoques que estavam presos do outro lado da ponte.
Prefeito|As lojas estão abastecidas novamente.
""",
	"cult": """
Ação|O tom de Uiliam muda.
Sir Uiliam|Prefeito.
Prefeito|Sim?
Sir Uiliam|Há outra questão.
Sir Uiliam|Fomos atacados por homens usando símbolos de um culto.
Aniri|E não pareceram felizes ao encontrar alguém da Ordem.
Sir Uiliam|Um deles disse que outros estavam chegando.
Sir Uiliam|Reconhece isso?
Ação|O prefeito pensa.
Prefeito|Talvez.
Prefeito|Antes de eu assumir este cargo, existia um grupo numa construção abandonada próxima à floresta.
Aniri|Um culto?
Prefeito|Era o que diziam.
Prefeito|Reuniam-se durante a noite, até que monges de um templo próximo acabaram com o grupo.
Sir Uiliam|Monges...
Ação|Uiliam percebe.
Sir Uiliam|Hashagur.
Prefeito|Conhece esse nome?
Sir Uiliam|Um orc. Monge.
Sir Uiliam|Lutou conosco na ponte.
Prefeito|Então ele ainda protege o templo.
Aventureiro|Você o conhece?
Prefeito|Só de vista.
Prefeito|Eu era muito mais jovem.
Ação|Ele sorri discretamente.
Prefeito|Naquela época eu ficava atrás dos muros e deixava monstros e estradas perigosas para aventureiros.
Prefeito|Bons tempos.
Ação|Uiliam não sorri.
Sir Uiliam|Para quem estava atrás dos muros.
Ação|O prefeito percebe o tom.
Prefeito|Não quis dizer—
Sir Uiliam|Eu sei.
@pause
Sir Uiliam|Mas alguém sempre esteve lá fora tornando aqueles dias tranquilos possíveis.
Aniri|E muitos não voltaram.
Sir Uiliam|Exatamente.
Ação|Uiliam olha para ela.
Sir Uiliam|É por isso que precisamos daqueles que ainda estão dispostos a lutar.
""",
	"aurora": """
Prefeito|Curioso.
Aventureiro|O quê?
Prefeito|Quando eu era criança, minha avó contava histórias sobre Aurora como se tivesse conhecido a própria rainha.
Aniri|Espero que sua avó não tivesse trezentos anos.
Prefeito|As histórias passaram pela família.
Prefeito|Diziam que Aurora foi uma grande governante.
Sir Uiliam|E ainda assim causou a Ruptura.
Prefeito|Cometeu um erro.
Aniri|Um erro considerável.
Prefeito|Alguns dizem que foi ganância.
Sir Uiliam|Outros, medo.
Sir Uiliam|Ela temia que os Sete Reinos voltassem à guerra depois de sua morte.
Aniri|E existe outra versão.
Aventureiro|Qual?
Aniri|Que Aurora não fez tudo sozinha.
Prefeito|Também ouvi essa.
Sir Uiliam|Não existem provas.
Aniri|São histórias, Uiliam.
Aniri|Dizem que alguém próximo conhecia o ritual.
Aniri|Um conselheiro, um mago, um amante...
@pause
Aniri|Um cozinheiro muito suspeito.
Sir Uiliam|Aniri.
Aniri|As versões variam.
Prefeito|Segundo uma delas, alguém convenceu Aurora de que o Guardião poderia ser criado sem consequências.
Aventureiro|E essa pessoa sabia o que aconteceria?
Prefeito|Talvez.
Sir Uiliam|Ou talvez nunca tenha existido.
Aniri|Essa é a parte divertida dos mistérios.
Sir Uiliam|Até alguém começar a tratá-los como fatos.
""",
	"memory": """
Ação|O aventureiro permanece pensativo.
Aniri|O que foi?
Aventureiro|Vocês falam de Aurora e da Ruptura como se todo mundo conhecesse essas histórias.
Aniri|Porque conhece.
Aventureiro|Então eu deveria conhecer também.
@pause
Aniri|Talvez realmente tenha batido a cabeça.
Aventureiro|Aniri.
Aniri|Certo.
Ação|Ela o observa.
Aniri|Ou talvez tenha caído do céu ontem.
Aniri|“Puf.”
Aniri|Um aventureiro apareceu em Aviant sem passado e sem memória.
Ação|O aventureiro fica imóvel por um instante.
Aniri|Ei?
Ação|O som ambiente diminui.
Aventureiro (pensamento)|Como eu cheguei aqui?
Ação|Ele olha ao redor.
Aventureiro (pensamento)|Não aqui.
Aventureiro (pensamento)|Em Aviant.
Ação|Ele tenta lembrar.
Aventureiro (pensamento)|O que havia antes?
@pause
Aventureiro (pensamento)|Eu...
Aventureiro (pensamento)|não consigo lembrar.
Ação|Por um instante, seu olhar parece atravessar o ambiente.
Aventureiro (pensamento)|Mas por que sinto que deveria?
Ação|Aniri estala os dedos diante dele.
Aniri|Ei.
Aniri|Volte para Aviant.
Ação|O som retorna.
Aventureiro|O quê?
Aniri|Você ficou olhando para o nada.
Aniri|Achei que sua alma tivesse decidido começar uma aventura sem você.
Aventureiro|Eu estava pensando.
Aniri|Isso costuma ser perigoso.
Ação|Ela sorri, mas continua observando-o por alguns segundos.
""",
	"next": """
Sir Uiliam|Se o culto da ponte é o mesmo que existia aqui antes...
Sir Uiliam|Hashagur pode saber mais.
Aniri|Então vamos ao templo?
Sir Uiliam|Amanhã.
Aniri|Você está sugerindo descanso?
Sir Uiliam|Até paladinos dormem.
Aniri|Precisava ouvir isso pessoalmente.
Sir Uiliam|Antes disso, quero falar com Kasum.
Aniri|O bárbaro que ama ouro.
Sir Uiliam|O combatente experiente.
Aniri|Que ama ouro.
Sir Uiliam|Sim, Aniri.
Aventureiro|Quer que ele venha conosco?
Sir Uiliam|Quero oferecer a oportunidade.
Aniri|Com ouro?
Sir Uiliam|Se necessário.
Aniri|Agora está falando a língua dele.
Ação|Uiliam começa a seguir para a saída.
Sir Uiliam|Encontraremos Kasum.
Sir Uiliam|Depois descansamos.
Sir Uiliam|Pela manhã, procuraremos Hashagur.
Aventureiro|E descobrimos se o culto realmente voltou.
Sir Uiliam|Exatamente.
Aniri|Então vamos à taverna.
Aniri|Pela investigação, naturalmente.
Aventureiro|Naturalmente.
Aniri|E talvez pela comida.
Ação|O grupo deixa a prefeitura.
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
