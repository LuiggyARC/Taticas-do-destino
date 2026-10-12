extends RefCounted


static func line(speaker: String, text: String) -> Dictionary:
	return {"speaker_name": speaker, "text": text}


static func get_sequence() -> Dictionary:
	return {
		"last_cultist": [
			line("Ação", "O último inimigo cai. Um cultista permanece no chão, gravemente ferido. Ele tenta se apoiar no próprio braço enquanto observa o grupo."),
			line("Cultista", "Vocês... não fazem ideia do que acabaram de fazer."),
			line("Ação", "Sir Uiliam se aproxima."),
			line("Sir Uiliam", "Quem são vocês?"),
			line("Cultista", "Isso não importa mais."),
			line("Ação", "O cultista olha para Hashagur."),
			line("Cultista", "Vocês vão pagar por isso."),
			line("Cultista", "Todos vocês."),
			line("Hashagur", "Não."),
			line("Ação", "Hashagur se aproxima alguns passos."),
			line("Hashagur", "Isso nunca acontecerá."),
			line("Cultista", "Você acha que acabou?"),
			line("Hashagur", "Acabou para você."),
			line("Ação", "O cultista tenta rir, mas perde as forças."),
			line("Cultista", "Eles já estão chegando..."),
			line("Ação", "Ele cai e não se move mais. Um silêncio toma a ponte.")
		],
		"hashagur_before_exit": [
			line("Sir Uiliam", "Espere."),
			line("Ação", "Hashagur já começa a se afastar."),
			line("Sir Uiliam", "Você disse que esse mesmo culto vinha atacando seu templo."),
			line("Hashagur", "Sim."),
			line("Sir Uiliam", "Por quê?"),
			line("Hashagur", "Ainda não sabemos."),
			line("Sir Uiliam", "Quantos são?"),
			line("Hashagur", "Mais do que deveriam."),
			line("Sir Uiliam", "Então precisamos conversar."),
			line("Ação", "Hashagur olha rapidamente para Uiliam."),
			line("Hashagur", "Não hoje."),
			line("Sir Uiliam", "Se essas pessoas atacam seu templo e agora bloqueiam uma estrada próxima à vila, isso não é coincidência."),
			line("Hashagur", "Provavelmente não."),
			line("Sir Uiliam", "Então venha conosco."),
			line("Hashagur", "Meu lugar ainda é no templo."),
			line("Ação", "Uma breve pausa."),
			line("Hashagur", "O trabalho aqui terminou."),
			line("Sir Uiliam", "Hashagur—"),
			line("Hashagur", "Voltaremos a nos encontrar, paladino."),
			line("Ação", "Hashagur observa o aventureiro e Aniri."),
			line("Hashagur", "Até lá, permaneçam atentos.")
		],
		"hashagur_after_exit": [
			line("Ação", "Hashagur desaparece entre as árvores."),
			line("Aniri", "Ele sempre conversa tão pouco?"),
			line("[NOME_DO_JOGADOR]", "Nós o conhecemos há poucos minutos."),
			line("Aniri", "E já descobri que a resposta é sim.")
		],
		"mystery": [
			line("Ação", "Sir Uiliam observa a direção por onde Hashagur desapareceu."),
			line("Sir Uiliam", "Cultistas atacando um templo."),
			line("Sir Uiliam", "Homens bloqueando uma ponte."),
			line("Sir Uiliam", "Criaturas cada vez mais próximas da vila..."),
			line("Aniri", "Está pensando a mesma coisa que eu?"),
			line("Sir Uiliam", "Espero que não."),
			line("Aniri", "Eu estava pensando em comida."),
			line("Ação", "Sir Uiliam olha para ela."),
			line("Aniri", "Mas agora que mencionou... sim. Tem alguma coisa errada."),
			line("Guarda da Vila", "Nunca vimos homens como aqueles por estas estradas."),
			line("Jhon", "E eu preferia continuar assim."),
			line("Sir Uiliam", "Precisamos descobrir o que esse culto está fazendo nesta região."),
			line("Ação", "O aventureiro observa os corpos dos cultistas.")
		],
		"choice_prompt": "O que você diz sobre o culto?",
		"choice_options": [
			{
				"id": "investigar",
				"button_text": "Se eles estão atacando pessoas, precisamos descobrir quem são.",
				"dialogues": [
					line("[NOME_DO_JOGADOR]", "Se eles estão atacando pessoas, precisamos descobrir quem são."),
					line("Sir Uiliam", "Concordo."),
					line("Aniri", "E eu achando que você ainda estava tentando entender por que seguia esse paladino."),
					line("[NOME_DO_JOGADOR]", "Ainda estou."),
					line("Aniri", "Ótimo. Pelo menos agora somos dois."),
					line("Ação", "Sir Uiliam olha para os dois, sem entender completamente o comentário.")
				]
			},
			{
				"id": "cautela",
				"button_text": "Isso parece problema demais para quem acabou de chegar.",
				"dialogues": [
					line("[NOME_DO_JOGADOR]", "Isso parece problema demais para quem acabou de chegar."),
					line("Aniri", "Finalmente alguém sensato."),
					line("Sir Uiliam", "Não precisamos persegui-los agora."),
					line("Sir Uiliam", "Mas ignorá-los também seria um erro."),
					line("[NOME_DO_JOGADOR]", "Uma coisa de cada vez."),
					line("Sir Uiliam", "Justo.")
				]
			},
			{
				"id": "recompensa",
				"button_text": "Se existe perigo por aqui, talvez exista uma recompensa também.",
				"dialogues": [
					line("[NOME_DO_JOGADOR]", "Se existe perigo por aqui, talvez exista uma recompensa também."),
					line("Aniri", "Sabia que estava aprendendo."),
					line("Sir Uiliam", "Vocês dois têm uma relação preocupante com ouro."),
					line("Aniri", "É porque ouro costuma ter uma relação muito importante com comida."),
					line("Sir Uiliam", "Ainda assim, descobriremos mais sobre esse culto quando voltarmos à vila.")
				]
			}
		],
		"repair": [
			line("Jhon", "Já terminaram de discutir conspirações?"),
			line("Ação", "Todos olham para ele."),
			line("Jhon", "Porque a ponte continua quebrada."),
			line("Aniri", "Você realmente pretende trabalhar depois de tudo isso?"),
			line("Jhon", "Metade da vila depende dessa estrada."),
			line("Jhon", "E eu trouxe madeira demais até aqui para simplesmente voltar carregando tudo."),
			line("Sir Uiliam", "Quanto tempo levará?"),
			line("Jhon", "Se ninguém tentar me matar novamente?"),
			line("Jhon", "Até amanhã de manhã."),
			line("Guarda da Vila", "Eu fico de vigia."),
			line("Sir Uiliam", "Todos ficaremos."),
			line("Aniri", "Então vamos dormir ao lado de uma ponte quebrada?"),
			line("Jhon", "Você queria uma aventura."),
			line("Aniri", "Estou começando a achar que devia ter definido melhor o que queria.")
		],
		"night_intro": [
			line("Ação", "Anoitece. Uma pequena fogueira é acesa próxima à estrada."),
			line("Ação", "O guarda permanece atento. Aniri se enrola em uma manta. Sir Uiliam observa a floresta, enquanto o aventureiro repousa próximo ao fogo."),
			line("Ação", "Ao fundo, Jhon continua trabalhando na ponte. O martelo bate; a madeira se encaixa; o martelo bate novamente.")
		],
		"night_dialogues": [
			line("Aniri", "Ele pretende fazer isso a noite inteira?"),
			line("[NOME_DO_JOGADOR]", "Aparentemente."),
			line("Aniri", "Estou começando a entender por que aquela carpintaria estava cheia de ratos."),
			line("Ação", "A noite envolve a ponte, mas o trabalho de Jhon continua.")
		],
		"morning": [
			line("Ação", "A luz da manhã surge. Jhon está sentado próximo à ponte, completamente exausto. Seus olhos estão pesados; suas roupas estão cobertas de poeira e serragem."),
			line("Jhon", "Pronto."),
			line("Aniri", "Pronto?"),
			line("Jhon", "Pronto."),
			line("Ação", "Aniri olha para a ponte."),
			line("Aniri", "Você não dormiu."),
			line("Jhon", "Dormir não conserta pontes."),
			line("Aniri", "Também não ajuda carpinteiros mortos de cansaço."),
			line("Jhon", "Quando voltarmos à vila... eu durmo."),
			line("Ação", "Jhon tenta se levantar e sente as costas."),
			line("Jhon", "Por uns três dias."),
			line("Sir Uiliam", "Bom trabalho."),
			line("Jhon", "Obrigado."),
			line("Jhon", "Agora podemos voltar antes que apareça outro culto, outro bando de lobos ou alguma coisa ainda pior.")
		],
		"road_warning": [
			line("Ação", "Antes que o grupo comece a retornar, sons surgem do outro lado da ponte: rodas de carroça, cavalos e várias vozes."),
			line("Ação", "O grupo assume posição por um instante."),
			line("Guarda da Vila", "Movimento na estrada!")
		],
		"road_arrival": [
			line("Ação", "Bandeiras da Ordem de Vanir aparecem. Um pequeno grupo de combatentes atravessa a ponte recém-reparada, acompanhado por comerciantes e carroças."),
			line("Jhon", "Finalmente."),
			line("Sir Uiliam", "Os reforços."),
			line("Ação", "Comerciantes começam a atravessar a ponte."),
			line("Ação", "Uma das carroças é escoltada por um homem extremamente robusto, carregando uma grande arma. Ele usa roupas simples e equipamento gasto, sem qualquer símbolo de reino ou ordem."),
			line("Ação", "Sir Uiliam observa o homem.")
		],
		"kasum": [
			line("Sir Uiliam", "Você não parece pertencer aos reforços."),
			line("Kasum", "Porque não pertenço."),
			line("Sir Uiliam", "Mercenário?"),
			line("Kasum", "Hoje, sim."),
			line("Ação", "Kasum aponta com o polegar para a carroça."),
			line("Kasum", "O comerciante paga. Eu garanto que a mercadoria chega inteira."),
			line("Aniri", "E amanhã?"),
			line("Kasum", "Depende de quem pagar."),
			line("Ação", "Aniri sorri."),
			line("Aniri", "Já gosto dele."),
			line("Sir Uiliam", "Qual seu nome?"),
			line("Kasum", "Kasum."),
			line("Sir Uiliam", "Sou Sir Uiliam, paladino a serviço da Ordem de Vanir. Consagrei minha espada à preservação da ordem, à defesa dos inocentes e ao triunfo da justiça."),
			line("Kasum", "Parabéns."),
			line("Ação", "Sir Uiliam fica brevemente em silêncio. Aniri segura o riso."),
			line("Sir Uiliam", "Você sabe lutar."),
			line("Kasum", "É por isso que me pagam."),
			line("Sir Uiliam", "Já considerou usar essa força para algo maior?"),
			line("Kasum", "Quanto paga?"),
			line("Sir Uiliam", "Não estava falando de pagamento."),
			line("Kasum", "Então não."),
			line("Aniri", "Definitivamente gosto dele."),
			line("Ação", "Kasum continua acompanhando a carroça."),
			line("Sir Uiliam", "Espere."),
			line("Ação", "Kasum olha por cima do ombro."),
			line("Sir Uiliam", "Estamos investigando ataques de criaturas e de um culto nesta região."),
			line("Kasum", "Parece perigoso."),
			line("Sir Uiliam", "É."),
			line("Kasum", "Ótimo."),
			line("Sir Uiliam", "Ótimo?"),
			line("Kasum", "Trabalho perigoso paga melhor."),
			line("Ação", "Sir Uiliam percebe a oportunidade."),
			line("Sir Uiliam", "Se houver recompensa, você viria?"),
			line("Kasum", "Se houver ouro, minha arma está disponível."),
			line("Aniri", "Ele realmente simplifica as coisas."),
			line("Kasum", "A vida é simples."),
			line("Kasum", "Alguém tem ouro."),
			line("Kasum", "Alguém precisa de alguém forte."),
			line("Kasum", "Eu resolvo os dois problemas."),
			line("Ação", "Sir Uiliam observa Kasum com interesse."),
			line("Sir Uiliam", "Quando chegarmos à vila, procure por mim."),
			line("Kasum", "Se o pagamento for bom... você me encontra antes.")
		],
		"kasum_after_departure": [
			line("Ação", "Kasum acompanha a carroça através da ponte."),
			line("Aniri", "Então agora recrutamos mercenários também?"),
			line("Sir Uiliam", "A Ordem de Vanir precisa de combatentes. Qualquer reforço capaz de ajudar é bem-vindo."),
			line("Aniri", "Você realmente pretende transformar todo mundo que sabe segurar uma arma em aventureiro, não é?"),
			line("Ação", "Sir Uiliam acompanha Kasum com o olhar."),
			line("Sir Uiliam", "Se forem capazes de lutar..."),
			line("Ação", "Uma pequena pausa."),
			line("Sir Uiliam", "...seria um desperdício não fazê-lo."),
			line("Ação", "Aniri observa Sir Uiliam por um instante."),
			line("Aniri", "Hum."),
			line("[NOME_DO_JOGADOR]", "O quê?"),
			line("Aniri", "Nada, acho que estou percebendo alguma coisa.")
		],
		"return_to_village": [
			line("Jhon", "Podemos ir agora?"),
			line("Aniri", "Antes que ele encontre mais alguém para recrutar?"),
			line("Jhon", "Exatamente."),
			line("Sir Uiliam", "Vamos."),
			line("Ação", "O grupo começa a caminhar em direção à vila enquanto comerciantes e carroças continuam atravessando a Ponte da Esmeralda.")
		],
		"mission_complete": (
			"A PONTE DA ESMERALDA\n\n"
			+ "A passagem foi restaurada e os reforços de Vanir chegaram à região.\n\n"
			+ "Novo mistério: quem são os cultistas e por que estavam bloqueando a ponte?\n\n"
			+ "Novo personagem encontrado: Kasum — Mercenário Bárbaro."
		)
	}
