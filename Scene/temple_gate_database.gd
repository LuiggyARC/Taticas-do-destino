extends RefCounted

const ARRIVAL := """
Ação|A estrada termina diante de um antigo templo entre as montanhas e a floresta. Marcas de batalha cobrem os muros; flechas quebradas e barricadas ainda cercam a entrada.
@hashagur_enters
Ação|Antes que o grupo alcance os portões, Hashagur surge no caminho.
Hashagur|Sabia que viriam.
Aniri|Isso é reconfortante.
Hashagur|Não deveria ser.
Ação|Hashagur olha para Uiliam.
Hashagur|Não preciso de ajuda.
Hashagur|Voltem pelo caminho que vieram.
Sir Uiliam|Hashagur, não viemos tomar seu templo.
Hashagur|Nem conseguiriam.
Hashagur|Será mais fácil partir.
Sir Uiliam|Podemos ajudá-lo contra o culto.
Hashagur|Já estou lutando contra eles.
Sir Uiliam|E eu preciso de respostas.
Ação|Hashagur encara o paladino.
Sir Uiliam|Encontramos os mesmos homens na Ponte da Esmeralda.
Sir Uiliam|Uma grande cidade perdeu seu Selo.
Sir Uiliam|Quero saber se essas duas coisas estão relacionadas.
Ação|Hashagur fica em silêncio por um instante.
Hashagur|Talvez.
Sir Uiliam|Então sabe de alguma coisa.
Hashagur|Talvez.
Hashagur|Mas tenho outros problemas.
Hashagur|E continuo não precisando de vocês.
Ação|Hashagur começa a se virar.
Aventureiro|Espere.
Ação|Hashagur para. Uiliam olha para o aventureiro.
Aventureiro|Viemos até aqui procurando respostas.
Aventureiro|Encontramos pessoas feridas vindas de uma cidade destruída, um Selo que caiu e gente fugindo.
Aventureiro|Não vamos simplesmente voltar porque você disse que está ocupado.
Ação|Um breve silêncio se instala.
Aniri|Olha só.
Ação|Ela sorri discretamente.
Aniri|Ele está aprendendo a falar por nós.
Kasum|Desde que não aprenda a negociar nossa parte do ouro.
Aventureiro|Kasum.
Kasum|Só verificando.
Ação|Hashagur observa o aventureiro por alguns segundos.
Hashagur|Não fala como alguém acostumado a receber ordens.
Aventureiro|Não lembro se sou.
Ação|Hashagur quase sorri.
Hashagur|Interessante.
Ação|Uiliam observa o aventureiro com clara aprovação.
Sir Uiliam|Ele tem razão.
Sir Uiliam|Se existe alguma ligação entre o culto e a queda dos Selos, precisamos saber.
Ação|Hashagur olha novamente para Uiliam.
Hashagur|Um paladino da Ordem perguntando por que um Selo caiu...
@pause
Hashagur|Isso merece uma conversa.
Ação|Ele se afasta da entrada.
Hashagur|Entrem.
Aniri|Isso significa que agora precisa da nossa ajuda?
Hashagur|Não.
Aniri|Tinha que tentar.
Hashagur|Entrem antes que eu mude de ideia.
Kasum|Há comida?
Ação|Hashagur olha para ele.
Hashagur|Não para você.
Kasum|Já gostei menos do templo.
Ação|O grupo atravessa os portões.
"""


static func get_arrival() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for raw_line in ARRIVAL.strip_edges().split("\n"):
		var line: String = raw_line.strip_edges()
		if line == "@pause":
			result.append({"type": "pause", "duration": 0.6})
			continue
		if line == "@hashagur_enters":
			result.append({"type": "hashagur_enters"})
			continue
		var divider: int = line.find("|")
		if divider < 1:
			continue
		var speaker: String = line.substr(0, divider)
		var content: String = line.substr(divider + 1)
		if speaker == "Ação":
			result.append({"type": "action", "text": content})
		else:
			result.append({"type": "dialogue", "speaker": speaker, "text": content})
	return result
