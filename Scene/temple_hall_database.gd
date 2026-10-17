extends RefCounted

const SCENES := {
	"temple": """
Ação|O grupo atravessa os portões. O interior do templo é antigo e austero.
Ação|Há marcas recentes de combate nas paredes. Poucos monges treinam no pátio; outros cuidam dos feridos.
Ação|Hashagur conduz o grupo até uma sala simples.
Hashagur|Sentem.
Kasum|Tem comida?
Hashagur|Não.
Kasum|Então fico em pé.
Ação|Aniri segura um sorriso. Hashagur se vira para Uiliam.
Hashagur|O que sabem sobre o culto?
Sir Uiliam|Pouco.
Sir Uiliam|Encontramos alguns deles na Ponte da Esmeralda.
Sir Uiliam|Reconheceram a Ordem e tentaram impedir que descobríssemos o que estavam fazendo.
Hashagur|Só isso?
Sir Uiliam|Um deles disse que outros estavam chegando.
Hashagur|Então sabe quase nada.
Sir Uiliam|Por isso estou aqui.
""",
	"old_cult": """
Hashagur|O culto que existia antes era simples.
Aniri|Cultistas raramente parecem simples.
Hashagur|Queriam poder.
Hashagur|Influência. Seguidores. Medo.
Hashagur|Ficavam na cidadela e esperavam que outros viessem até eles.
Aventureiro|E este?
Ação|Hashagur cruza os braços.
Hashagur|Este se move.
Hashagur|Atacam um lugar.
Hashagur|Permanecem algum tempo.
Hashagur|Depois desaparecem.
Sir Uiliam|Sabe o que procuram?
Hashagur|Não.
Hashagur|Mas realizam rituais.
Ação|Uiliam fica mais atento.
Hashagur|Encontrei pergaminhos.
Hashagur|Símbolos.
Hashagur|Restos de cerimônias em lugares que abandonaram.
Aventureiro|Alguma ligação com os Selos?
Hashagur|Talvez.
Sir Uiliam|“Talvez” novamente.
Hashagur|Quando tiver certeza, direi “sim”.
Hashagur|Até lá, tenho pistas.
Hashagur|Não respostas.
""",
	"smaller_temple": """
Sir Uiliam|Se sabe onde estão, por que ainda não os atacou?
Ação|Hashagur olha através da porta para o pátio.
Hashagur|Porque este templo já foi maior.
Ação|Alguns jovens discípulos treinam do lado de fora.
Hashagur|Depois que nosso mestre morreu...
Hashagur|muitos partiram.
Hashagur|Outros morreram combatendo as criaturas.
@pause
Hashagur|Restaram poucos.
Aniri|E o culto?
Hashagur|Não tem esse problema.
Sir Uiliam|Posso entrar em contato com a Ordem.
Sir Uiliam|Solicitar mais homens.
Hashagur|Não.
Ação|Uiliam encara Hashagur.
Sir Uiliam|Por quê?
Hashagur|Porque até a Ordem decidir enviar alguém...
Hashagur|o culto já terá mudado de lugar novamente.
Sir Uiliam|Ainda assim, soldados ajudariam.
Hashagur|Talvez.
Ação|Hashagur faz uma pequena pausa.
Hashagur|E talvez eu não queira a Ordem dentro deste templo.
Sir Uiliam|Está dizendo que não confia nela?
Hashagur|Estou.
Ação|O ambiente fica mais tenso.
Sir Uiliam|A Ordem de Vanir existe para proteger Aviant.
Sir Uiliam|Não somos governados por disputas políticas.
Hashagur|Se acredita nisso...
Ação|Hashagur encara Uiliam.
Hashagur|não serei eu a discutir hoje.
Sir Uiliam|Hashagur—
Hashagur|Mas talvez devesse olhar com mais atenção para quem serve.
@pause
Ação|Uiliam claramente não gosta da afirmação.
Sir Uiliam|Conheço a Ordem.
Hashagur|Conhece sua parte nela.
@pause
Hashagur|Não é a mesma coisa.
Ação|Uiliam permanece em silêncio.
""",
	"golden_question": """
Aventureiro|Espere.
Ação|Hashagur olha para ele.
Aventureiro|Você tem poucos discípulos.
Aventureiro|Não confia na Ordem.
Aventureiro|E o culto continua crescendo.
@pause
Aventureiro|Como pretende lutar contra eles?
Ação|Hashagur observa o aventureiro.
Hashagur|Essa...
@pause
Hashagur|é a pergunta de ouro.
Kasum|Ouro?
Ação|Todos olham para ele.
Kasum|Se houver ouro, posso resolver parte do problema.
Hashagur|Fiz voto de não possuir bens.
Kasum|Finalmente encontrei uma religião que não me interessa.
Aniri|Durou mais do que eu esperava.
""",
	"citadel": """
Hashagur|Não preciso de um exército.
Hashagur|Ainda não.
Sir Uiliam|Do que precisa?
Hashagur|Informação.
Ação|Hashagur coloca um antigo mapa sobre a mesa. Nele está marcada uma cidadela abandonada.
Hashagur|O culto voltou à antiga cidadela.
Aniri|Achei que disse que eles não permanecem no mesmo lugar.
Hashagur|Não permanecem.
Hashagur|É por isso que precisamos agir antes que partam.
Aventureiro|Quer saber para onde irão depois.
Ação|Hashagur olha para ele.
Hashagur|Exatamente.
Hashagur|O antigo culto foi destruído graças a uma passagem que poucos conheciam.
Ação|Ele aponta para uma lateral da cidadela.
Hashagur|Durante a construção, escavaram um túnel estreito sob as fundações.
Hashagur|Meus predecessores o usaram para entrar sem serem vistos.
Sir Uiliam|E atacar de surpresa.
Hashagur|Foi assim que o antigo culto terminou.
Aniri|Então por que não repetir?
Hashagur|Porque meus discípulos não conseguem passar pelo túnel. Depois da batalha, tudo desmoronou e a passagem diminuiu.
Ação|Aniri olha para o mapa. Depois olha para si mesma.
Aniri|Eu consigo.
Sir Uiliam|Aniri—
Aniri|É estreito.
Aniri|Escuro.
Aniri|Provavelmente cheio de coisas desagradáveis.
Ação|Ela sorri.
Aniri|Porão é minha especialidade.
Ação|Uiliam deixa escapar uma breve risada. Todos olham para ele.
Sir Uiliam|...
Aniri|Você riu.
Sir Uiliam|Continue.
""",
	"alone_first": """
Aventureiro|Espere.
Ação|Aniri olha para ele.
Aventureiro|Você pretende entrar sozinha numa cidadela cheia de cultistas?
Aniri|Quando coloca desse jeito, parece imprudente.
Aventureiro|Porque é.
Hashagur|Ela não precisa enfrentá-los.
Hashagur|Precisa entrar.
Hashagur|Ouvir.
Hashagur|Descobrir para onde pretendem ir quando abandonarem a cidadela.
Sir Uiliam|E sair sem ser vista.
Hashagur|Exatamente.
Aventureiro|Ainda é perigoso.
Aniri|Já fiz coisa parecida antes.
""",
	"alone_second": """
Aventureiro|Quando?
Aniri|Espionei um antigo amor.
@pause
Kasum|Isso parece uma história melhor que a do culto.
Sir Uiliam|Não pergunte.
Aniri|Foi muito educativo.
Aventureiro|Aniri.
Ação|Ela percebe que ele está realmente preocupado.
Aniri|Ei.
Aniri|Eu sei entrar sem ser vista.
Aniri|E sei quando é hora de fugir.
@pause
Aniri|Desta vez...
Aniri|vocês vão estar esperando por mim aqui.
Ação|O aventureiro olha para ela por um instante.
Aventureiro|Volte.
Ação|Aniri sorri.
Aniri|Esse é o plano.
""",
	"plan_first": """
Hashagur|Se descobrir o próximo destino deles...
Hashagur|poderemos chegar antes.
Sir Uiliam|E preparar uma emboscada.
Hashagur|Ou impedir o próximo ritual.
Aventureiro|Se os rituais realmente estiverem ligados aos Selos...
Hashagur|Então finalmente teremos algo concreto.
Ação|Hashagur enrola o mapa.
Hashagur|Partam antes do anoitecer.
Hashagur|O túnel é mais seguro depois que escurece.
""",
	"plan_second": """
Kasum|“Mais seguro” costuma significar o quê neste grupo?
Aniri|Que talvez não morramos.
Kasum|Estou começando a entender.
"""
}

const ORDER := [
	"temple", "old_cult", "smaller_temple", "golden_question",
	"citadel", "alone_first", "alone_second", "plan_first", "plan_second"
]

const CASTS := {
	"temple": ["Hashagur", "Sir Uiliam", "Kasum", "Aniri"],
	"old_cult": ["Hashagur", "Aventureiro", "Sir Uiliam", "Aniri"],
	"smaller_temple": ["Hashagur", "Sir Uiliam", "Aniri"],
	"golden_question": ["Hashagur", "Aventureiro", "Kasum", "Aniri"],
	"citadel": ["Hashagur", "Aniri", "Sir Uiliam", "Aventureiro"],
	"alone_first": ["Aniri", "Aventureiro", "Hashagur", "Sir Uiliam"],
	"alone_second": ["Aniri", "Aventureiro", "Kasum", "Sir Uiliam"],
	"plan_first": ["Hashagur", "Sir Uiliam", "Aventureiro"],
	"plan_second": ["Aniri", "Kasum"]
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
