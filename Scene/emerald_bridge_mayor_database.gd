extends RefCounted

# Novo roteiro da prefeitura para a missão da Ponte da Esmeralda.
const SCRIPTS := {
	"emerald_bridge_mayor_intro": """
Ação|O grupo entra. O prefeito está diante de uma mesa coberta de documentos e mapas.
Prefeito|Sejam bem-vindos.
Prefeito|Peço desculpas pela situação da vila. Estamos com poucos guardas e problemas demais.
Sir Uiliam|Encontramos criaturas nas proximidades. Até a carpintaria foi infestada.
Prefeito|Eu soube.
Aventureiro|Isso costuma acontecer tão perto das casas?
Prefeito|Não.
Prefeito|E esse é justamente o problema.
Sir Uiliam|A Ordem enviou reforços?
Prefeito|Estão a caminho.
Prefeito|Mas existe algo que não pode esperar.
Ação|O prefeito aponta para o mapa.
Prefeito|A Ponte da Esmeralda foi danificada.
Aniri|A estrada comercial.
Aventureiro|Você conhece?
Aniri|Passei por ela quando cheguei aqui.
Prefeito|Sem a ponte, suprimentos e mercadores não chegam. Se continuar assim, ficaremos isolados.
Aventureiro|Então alguém precisa consertá-la.
Prefeito|Enviei Jhon.
Aniri|Jhon?
Prefeito|Saiu esta manhã.
Aventureiro|Com quantos guardas?
Prefeito|Um.
Aniri|Um?
Prefeito|Era o único que eu podia dispensar.
Prefeito|Se protejo as estradas, enfraqueço a vila. Se protejo a vila, abandono as estradas.
Aniri|Entendi.
Ação|Ela olha para o mapa.
Aniri|Mas eu vou atrás dele.
Aventureiro|Por causa da dívida?
Aniri|Também.
Aniri|Ele me deu uma chance. Não vou esperar aqui para descobrir se voltou vivo.
Ação|Uiliam se aproxima da mesa.
Sir Uiliam|Sou Uiliam, paladino a serviço da Ordem de Vanir.
Sir Uiliam|Consagrei minha espada à preservação da ordem, à defesa dos inocentes e ao triunfo da justiça.
Aniri|Lá vem.
Ação|Uiliam ignora.
Sir Uiliam|Fui enviado para reforçar esta região, mas um único paladino não é suficiente.
Prefeito|Então entende nossa situação.
Sir Uiliam|Entendo.
Sir Uiliam|Eu irei até a ponte.
Ação|Ele olha para os outros.
Sir Uiliam|Vocês decidem se desejam acompanhar.
Aventureiro|O que sabemos sobre o lugar?
Prefeito|Guardas relataram movimentos próximos à estrada. Provavelmente criaturas.
Aventureiro|Que tipo?
Prefeito|Não sabemos.
Aniri|Jhon sozinho, ponte quebrada e monstros desconhecidos.
@pause
Aniri|Bom começo.
""",
	"emerald_bridge_choice_help": """
Aventureiro|Eu vou com vocês.
Aniri|Sabia que estava começando a gostar de você.
Aventureiro|“Começando”?
Aniri|Não estrague.
Prefeito|E haverá pagamento pelo serviço.
Aniri|Melhor ainda.
""",
	"emerald_bridge_choice_payment": """
Aventureiro|Esse tipo de serviço é remunerado?
Prefeito|Sim. Protejam Jhon e restabeleçam a passagem e serão pagos.
Aniri|Excelente.
Sir Uiliam|Nem toda ajuda deveria depender de recompensa.
Aniri|Estou tentando deixar de roubar. Preciso de alternativas.
Aventureiro|Então eu vou.
""",
	"emerald_bridge_mayor_conclusion": """
Prefeito|Partam logo. Jhon já deve estar chegando à ponte.
Ação|O grupo se prepara para sair.
Prefeito|E tenham cuidado.
Prefeito|As criaturas estão chegando cada vez mais perto da vila.
Ação|O aventureiro para.
Aventureiro|Uiliam...
Aventureiro|você disse que os Selos protegiam as cidades.
Sir Uiliam|Protegem.
Aventureiro|Então como as criaturas chegam tão perto daqui?
Prefeito|Porque não temos um Selo.
Aventureiro|Por quê?
Prefeito|Somos pequenos demais. Eles ficam nas grandes cidades e em pontos considerados estratégicos.
Ação|O aventureiro olha para Uiliam.
Aventureiro|Isso é comum?
Sir Uiliam|Sim.
Aventureiro|E quem não recebe um Selo?
Sir Uiliam|Recebe soldados, paladinos e aventureiros.
Aniri|Pessoas no lugar de uma barreira.
Sir Uiliam|É a proteção que podemos oferecer.
Aventureiro|E quem decide onde colocar os Selos?
Ação|Uiliam hesita.
Sir Uiliam|Não sei exatamente.
Aventureiro|Nunca perguntou?
Sir Uiliam|Não.
@pause
Sir Uiliam|Nunca tive motivo para perguntar.
Ação|Uiliam olha para o mapa por alguns segundos.
Prefeito|Existe uma rota curta até a ponte.
Ação|Ele indica no mapa.
Prefeito|Sigam por aqui.
Sir Uiliam|Vamos.
Aniri|Salvar Jhon primeiro.
Aventureiro|E descobrir o que está acontecendo depois.
Sir Uiliam|Exatamente.
Ação|O grupo deixa a prefeitura. Uiliam é o último a sair.
Ação|Por um instante, olha novamente para as grandes cidades marcadas no mapa.
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
