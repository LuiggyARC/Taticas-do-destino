extends RefCounted

# Roteiro de "Uma Segunda Chance", apresentado após a batalha no porão.
const SCRIPTS := {
	"second_chance_carpenter_return": """
Ação|O grupo sobe do porão.
Jhon|E então?
Aventureiro|Os ratos não serão mais um problema.
Jhon|Finalmente.
Ação|Ele percebe Aniri.
Jhon|Quem é ela?
Aniri|A outra parte do problema.
Ação|Aniri coloca a bolsa sobre o balcão e começa a retirar as ferramentas.
Jhon|Essas são minhas coisas.
Aniri|São.
Jhon|Foi você?
Aniri|Foi.
Ação|Jhon encara Aniri.
Jhon|Por quê?
Aniri|Eu queria sair da vila e não tinha dinheiro nem equipamento.
Aniri|Foi uma péssima ideia.
Jhon|Uma ideia que me custou dinheiro.
Aniri|Eu sei.
Aniri|Por isso estou devolvendo tudo.
Ação|Jhon conta as moedas.
Jhon|Não tudo.
Ação|Aniri fica desconfortável.
Aniri|Gastei uma parte.
Jhon|Então ainda me deve.
Aniri|Vou pagar.
Jhon|Com quê?
Aniri|Outra excelente pergunta.
Ação|Jhon aponta para o porão.
Jhon|Tem muita coisa quebrada lá embaixo.
Jhon|Vai trabalhar até pagar o restante.
Aniri|Melhor do que uma cela.
Jhon|Não me faça reconsiderar.
Aniri|Combinado.
Jhon|Não é um acordo.
Jhon|É uma dívida.
Aniri|Você realmente sabe destruir a parte amigável das conversas.
""",
	"second_chance_carpenter_conclusion": """
Ação|O grupo se prepara para sair.
Sir Uiliam|Aniri.
Aniri|O quê agora?
Ação|Uiliam aponta para a bolsa dela.
Sir Uiliam|Aquilo.
Aniri|Meus pertences.
Aventureiro|Comprados?
Ação|Aniri olha para ele.
Aniri|Essa pergunta está ficando inconveniente.
Ação|Ela abre a bolsa. Dentro há uma poção e algumas bandagens.
Aventureiro|Não comprados.
Aniri|Não comprados.
Sir Uiliam|Vamos.
Aniri|Eu estava com medo de ouvir isso.
""",
	"second_chance_healer_return": """
Ação|Na Casa de Cura, Aniri coloca a poção e as bandagens sobre o balcão.
Aniri|Olá.
Curandeira|Olá.
Aniri|Tome.
Curandeira|Esses itens desapareceram ontem.
Aniri|Eu sei.
Curandeira|Você os encontrou?
Aniri|Eu os roubei.
Ação|A curandeira fica em silêncio.
Aniri|Essa reação também está ficando familiar.
Curandeira|Por quê?
Aniri|Achei que precisaria deles na estrada.
Curandeira|E se alguém tivesse chegado aqui precisando dessa poção?
Ação|Aniri perde o sorriso.
Aniri|...
Aniri|Não pensei nisso.
Curandeira|Esse é o problema.
Aniri|Tem razão.
Aniri|Eu só pensei no que precisava para partir.
Aniri|Sinto muito.
Ação|A curandeira verifica os itens.
Curandeira|Estão intactos.
Curandeira|Vou aceitá-los de volta.
Aniri|Obrigada.
Curandeira|Da próxima vez, compre.
Aniri|Estou descobrindo que esse método causa menos problemas.
Curandeira|Vocês têm onde passar a noite?
Aventureiro|Ainda não.
Curandeira|Podem ficar aqui hoje.
Aniri|Mesmo depois disso?
Curandeira|Não é uma recompensa pelo roubo.
Curandeira|Vocês ajudaram a vila e você voltou para devolver o que pegou.
Aniri|Vou aceitar antes que mude de ideia.
""",
	"second_chance_choice_acceptance": """
Aventureiro|Você errou.
Aventureiro|Mas está tentando consertar.
Aniri|Então ainda acha que mereço uma chance?
Aventureiro|Acho.
Aniri|Vou tentar não desperdiçá-la.
Ação|Afinidade com Aniri aumentou.
""",
	"second_chance_choice_distrust": """
Aventureiro|Ainda quero ver se posso confiar em você.
Aniri|Justo.
Aniri|Acho que roubar duas lojas não foi uma boa primeira impressão.
Aventureiro|Não ajudou.
Aniri|Então vou melhorar a segunda.
Ação|Afinidade com Aniri não se altera.
""",
	"second_chance_new_adventurer": """
Sir Uiliam|Aniri.
Aniri|Sim?
Sir Uiliam|Depois de tudo isso...
Sir Uiliam|ainda pretende se tornar aventureira?
Aniri|Mais do que antes.
Sir Uiliam|Então aprenda com hoje.
Sir Uiliam|Na estrada, uma escolha ruim pode custar mais do que moedas.
Aniri|Entendido.
Sir Uiliam|Ainda precisa pagar sua dívida com Jhon.
Aniri|Eu vou.
Sir Uiliam|Mas, se realmente deseja seguir esse caminho...
Ação|Uiliam olha para o aventureiro.
Sir Uiliam|pode viajar conosco enquanto cumpre sua palavra.
Aniri|Está me convidando?
Sir Uiliam|Estou oferecendo uma oportunidade.
Aniri|Isso é um “sim” dito por um paladino?
Aventureiro|Estou começando a traduzir.
Sir Uiliam|A decisão é sua.
Aniri|Então eu vou.
Ação|Uiliam assente.
Sir Uiliam|Muito bem.
Sir Uiliam|Já perdemos aventureiros demais.
Ação|Por um instante, seu tom fica mais sério.
Sir Uiliam|Não pretendo perder mais um por falta de preparo.
Aniri|Ótimo.
Aniri|Porque pretendo durar bastante.
""",
	"second_chance_healer_morning": """
@fade_out
@fade_in
Ação|Na manhã seguinte, a curandeira entrega três pequenos frascos ao grupo.
Curandeira|Antes que partam.
Ação|Item recebido: +3 Poções de Cura.
Aniri|De graça?
Curandeira|Para o grupo.
Curandeira|E usem com sabedoria.
Aniri|Desta vez prometo não roubar nenhuma.
Curandeira|É um começo.
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
