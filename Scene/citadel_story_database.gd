extends RefCounted


static func get_arrival() -> Array[Dictionary]:
	return [
		{"speaker": "Narrador", "text": "Aniri rasteja pela antiga passagem sob a cidadela. Pedras quebradas tornam o túnel cada vez mais estreito."},
		{"speaker": "Aniri", "text": "Porão é minha especialidade."},
		{"speaker": "Aniri", "text": "Túneis desabando... nem tanto."},
		{"speaker": "Narrador", "text": "Ela força o corpo por uma abertura, remove cuidadosamente uma velha grade de madeira e entra em uma sala escura."},
		{"speaker": "Novo objetivo", "text": "Evite os cultistas. Procure informações sobre o próximo destino do culto."},
	]


static func get_bedroom_report() -> Array[Dictionary]:
	return [
		{"speaker": "Narrador", "text": "No quarto parcialmente iluminado, Aniri encontra mapas, velas queimadas e documentos espalhados sobre uma mesa."},
		{"speaker": "Aniri", "text": "Finalmente. Vamos descobrir o que estão escondendo."},
		{"speaker": "Narrador", "text": "Entre os papéis, ela encontra um relatório assinado."},
		{"speaker": "Narrador", "text": "RELATÓRIO DE EBRAMIR — Ao comando superior. O ritual foi realizado conforme as instruções recebidas. Nenhuma alteração foi observada imediatamente. Durante algum tempo, considerei o teste um fracasso."},
		{"speaker": "Narrador", "text": "Na noite seguinte, uma fenda surgiu nas proximidades de Montirel."},
		{"speaker": "Aniri", "text": "Montirel..."},
		{"speaker": "Narrador", "text": "Alguns dos irmãos enviados para observar a região relataram fortes dores de cabeça. Dois perderam a consciência ao se aproximarem do local onde a fenda surgiria horas depois. Não sabemos a causa."},
		{"speaker": "Narrador", "text": "Também não encontrei explicação para a queda do Selo da cidade. Não acredito que tenhamos sido responsáveis por isso. Ainda assim, o resultado do ritual é inegável. O efeito apenas não foi imediato."},
		{"speaker": "Narrador", "text": "Entre a conclusão do ritual e a abertura da fenda houve aproximadamente um dia. Portanto, considero o teste bem-sucedido. — Ebramir"},
		{"speaker": "Aniri", "text": "Então foi isso. O ritual veio primeiro. A fenda depois."},
		{"speaker": "Narrador", "text": "Aniri dobra o relatório e o guarda consigo."},
		{"speaker": "Aniri", "text": "Uiliam vai querer ver isto."},
		{"speaker": "Missão atualizada", "text": "Ebramir, um gnomo, lidera esta ramificação do culto. O ritual antecedeu em cerca de um dia a abertura de uma fenda próxima a Montirel. Ele afirma não saber por que o Selo da cidade caiu."},
	]


static func get_strategy_report() -> Array[Dictionary]:
	return [
		{"speaker": "Narrador", "text": "Na sala da mesa com seis tocos, Aniri continua procurando. Sob um mapa da região, encontra outro pergaminho."},
		{"speaker": "Aniri", "text": "Mais um."},
		{"speaker": "Narrador", "text": "RETALIAÇÃO — O templo não será poupado. Eles destruíram nossos predecessores e ocuparam estas terras acreditando que o passado havia sido enterrado. É hora de devolver aquilo que fizeram conosco."},
		{"speaker": "Narrador", "text": "A força principal marchará durante a madrugada. O templo deverá ser cercado antes do amanhecer. Nenhum reforço deve chegar."},
		{"speaker": "Aniri", "text": "Madrugada?"},
		{"speaker": "Narrador", "text": "Aniri olha para uma pequena janela. O céu já está escuro. Ela procura rapidamente a data do documento."},
		{"speaker": "Aniri", "text": "Não. É hoje."},
		{"speaker": "Narrador", "text": "Passos são ouvidos do outro lado da porta."},
		{"speaker": "Cultista 1", "text": "(Ao longe) O último grupo já saiu?"},
		{"speaker": "Cultista 2", "text": "(Ao longe) Há algum tempo."},
		{"speaker": "Cultista 1", "text": "Então ao amanhecer estará terminado."},
		{"speaker": "Aniri", "text": "(Baixo) Eles já partiram."},
		{"speaker": "Narrador", "text": "Os passos se aproximam. Aniri apaga a pequena vela sobre a mesa."},
		{"speaker": "Aniri", "text": "Hora de ir."},
		{"speaker": "Objetivo atualizado", "text": "FUJA DA CIDADELA. O ataque ao templo já começou. Retorne pelo túnel e avise o grupo."},
	]
