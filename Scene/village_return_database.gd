extends Node

# Falas do retorno da Ponte da Esmeralda. Uma linha por caixa de diálogo;
# linhas consecutivas do mesmo personagem são agrupadas para leitura no celular.
const SCENES := {
	"mission": [
		"Ação|O grupo entra novamente na prefeitura. O prefeito se levanta ao ver Jhon e os aventureiros.",
		"Prefeito|Jhon! Então conseguiram?",
		"Jhon|A ponte está de pé novamente. Quanto a mim... não sei se posso dizer o mesmo.",
		"Ação|Jhon boceja, completamente exausto.",
		"Prefeito|Você está péssimo.",
		"Jhon|Passei a noite inteira trabalhando.",
		"Aniri|Nós avisamos que dormir costuma ser útil.",
		"Jhon|E eu avisei que dormir não conserta pontes.",
		"Aniri|Ele continua defendendo essa teoria.",
		"Prefeito|De qualquer maneira, você prestou um grande serviço à vila.",
		"Jhon|Agora, se não se importa, pretendo prestar um grande serviço à minha cama.",
		"Ação|Jhon começa a sair, mas para ao lado de Aniri.",
		"Jhon|Ah... pequena.",
		"Aniri|Se isso for sobre a carpintaria, eu ainda pretendo—",
		"Jhon|Esqueça.",
		"Aniri|Como?",
		"Jhon|Você devolveu minhas coisas, ajudou a proteger minha pele na ponte e já trabalhou o bastante para pagar o restante da dívida.",
		"Aniri|Então...",
		"Jhon|Não me deve mais nada.",
		"Ação|Aniri fica genuinamente surpresa.",
		"Aniri|Tem certeza?",
		"Jhon|Tenho. Só não transforme minha carpintaria em seu depósito pessoal novamente.",
		"Aniri|Prometo usar portas da próxima vez.",
		"Jhon|Isso não foi o que eu quis dizer.",
		"Aniri|Eu sei. Obrigada, Jhon.",
		"Jhon|Faça valer a segunda chance.",
		"Jhon|Agora, com licença... se alguém precisar de mim nas próximas doze horas... não precisa.",
		"Ação|Jhon sai da prefeitura.",
		"Missão concluída|UMA SEGUNDA CHANCE — Aniri reparou sua dívida com Jhon e está livre para seguir sua jornada.",
		"Aniri|Então é oficial. Sou uma aventureira sem dívidas.",
		"Aventureiro|O quê?",
		"Aniri|Financeiras, pelo menos."
	],
	"reward": [
		"Prefeito|Também devo agradecer a vocês. A ponte está restaurada, os comerciantes voltaram e os reforços da Ordem finalmente chegaram.",
		"Prefeito|Depois dos últimos dias... talvez finalmente tenhamos algum tempo de paz.",
		"Sir Uiliam|Espero que tenha razão.",
		"Ação|O prefeito retira uma bolsa da mesa e a entrega ao aventureiro.",
		"Prefeito|E, como prometido: trezentas peças de ouro. Pelo reparo da ponte e, principalmente, por trazer Jhon de volta inteiro.",
		"Aniri|Trezentas? Só quero deixar registrado que fui uma parte fundamental dessa missão.",
		"Sir Uiliam|Você esqueceu da recompensa até alguns segundos atrás.",
		"Aniri|Mas lembrei no momento mais importante.",
		"Recompensa|+300 peças de ouro.",
		"Prefeito|E há outra boa notícia: as carroças trouxeram as mercadorias que estavam presas do outro lado da ponte.",
		"Prefeito|Se precisarem de equipamento, agora é a hora.",
		"Loja atualizada|Armas, armaduras, escudos e suprimentos básicos estão disponíveis no Fole & Fardo."
	],
	"cult": [
		"Sir Uiliam|Prefeito. Há outra questão. Fomos atacados por homens usando símbolos de um culto.",
		"Aniri|E aparentemente eles não gostaram muito de encontrar alguém da Ordem.",
		"Sir Uiliam|Um deles mencionou que outros viriam. Sabe alguma coisa sobre isso?",
		"Prefeito|Há muito tempo ouvi falar de algo parecido, antes mesmo de assumir este cargo.",
		"Prefeito|Um homem tentava reunir seguidores numa antiga mesquita, próxima à floresta. O lugar já estava abandonado. Diziam que se reuniam à noite.",
		"Sir Uiliam|E o que aconteceu?",
		"Prefeito|Os monges de um templo próximo descobriram o grupo e acabaram com ele antes que crescesse.",
		"Aniri|Monges?",
		"Sir Uiliam|Hashagur.",
		"Prefeito|Hashagur?",
		"Sir Uiliam|Um orc. Monge. Encontramos com ele na ponte.",
		"Prefeito|Então ele ainda protege aquele templo... Eu o vi algumas vezes quando era mais jovem.",
		"Prefeito|Naquela época, eu ficava atrás dos muros e deixava monstros, cultistas e estradas perigosas para aventureiros como ele. Bons tempos.",
		"Sir Uiliam|Bons tempos para quem estava atrás dos muros.",
		"Sir Uiliam|Aventureiros morreram para que pessoas dentro dessas cidades pudessem chamar aqueles dias de pacíficos.",
		"Sir Uiliam|Todo aventureiro capaz de lutar merece estar lá fora. Precisamos deles lá fora.",
		"Sir Uiliam|Ainda estamos tentando livrar este mundo das consequências deixadas por Aurora.",
		"Aniri|Lá vem Aurora outra vez."
	],
	"aurora": [
		"Prefeito|Minha avó falava de Aurora como se tivesse conhecido a própria rainha.",
		"Aniri|Imagino que sua avó não tenha trezentos anos.",
		"Prefeito|As histórias eram passadas pela família. Aurora foi uma excelente governante. Unificou os reinos e acabou com guerras intermináveis.",
		"Sir Uiliam|E ainda assim abriu a Ruptura.",
		"Prefeito|Cometeu um erro.",
		"Aniri|Um erro um pouco maior do que esquecer uma panela no fogo.",
		"Prefeito|Alguns dizem que foi ganância: não suportava imaginar seu império existindo sem ela.",
		"Sir Uiliam|Outros dizem que foi medo de que os sete reinos voltassem a se destruir após sua morte.",
		"Aniri|E existe aquela outra história.",
		"Aventureiro|Qual?",
		"Aniri|A de que Aurora não teria feito tudo sozinha.",
		"Sir Uiliam|Não há provas.",
		"Aniri|Nunca disse que havia. Falam de um conselheiro, um mago, um amante... um cozinheiro particularmente suspeito.",
		"Sir Uiliam|Aniri.",
		"Aniri|As versões variam.",
		"Prefeito|Segundo algumas histórias, convenceram Aurora de que poderia criar o Guardião sem consequências. Talvez alguém soubesse o verdadeiro preço.",
		"Sir Uiliam|Especulação.",
		"Prefeito|Completamente.",
		"Aniri|Histórias são mais interessantes quando ninguém sabe exatamente o que aconteceu.",
		"Sir Uiliam|E mais perigosas quando passam a ser tratadas como fatos."
	],
	"memory": [
		"Ação|O aventureiro fica em silêncio por alguns segundos.",
		"Aventureiro|É estranho. Vocês falam de Aurora, da Ruptura, dos reinos... como coisas que todo mundo conhece.",
		"Aniri|Porque praticamente todo mundo conhece.",
		"Aventureiro|Então por que eu não lembro de nada disso?",
		"Aniri|Talvez você tenha batido a cabeça.",
		"Aventureiro|Estou falando sério.",
		"Aniri|Eu também. Ou talvez tenha simplesmente caído do céu ontem. Puf! Um aventureiro completo apareceu em Aviant sem passado nem memória.",
		"Ação|O aventureiro fica imóvel.",
		"Aventureiro (pensamento)|Como eu cheguei aqui? Não aqui na prefeitura. Aqui, em Aviant.",
		"Aventureiro (pensamento)|Qual foi o primeiro lugar que eu vi? De onde vim antes disso? Eu... não consigo lembrar.",
		"Aventureiro (pensamento)|E por que sinto que deveria conseguir?",
		"Ação|Aniri estala os dedos diante do rosto do aventureiro.",
		"Aniri|Ei. Aventureiro. Volte para Aviant.",
		"Aventureiro|O quê?",
		"Aniri|Você ficou olhando para o nada. Achei que sua alma tivesse decidido começar uma aventura sem você.",
		"Aventureiro|Eu estava pensando.",
		"Aniri|Isso costuma ser perigoso.",
		"Aventureiro|Muito engraçado.",
		"Aniri|Obrigada.",
		"Ação|Aniri sorri, mas ainda observa o aventureiro com preocupação."
	],
	"next": [
		"Sir Uiliam|Se aquele culto está ligado ao grupo da antiga mesquita, Hashagur deve saber mais.",
		"Aniri|Então vamos ao templo?",
		"Sir Uiliam|Amanhã.",
		"Aniri|Você está sugerindo descanso?",
		"Sir Uiliam|Até paladinos dormem.",
		"Aniri|Eu precisava ouvir isso de você pessoalmente.",
		"Sir Uiliam|Antes disso, tenho outro assunto.",
		"Aniri|O bárbaro que ama ouro.",
		"Sir Uiliam|Kasum. Ele é um combatente experiente.",
		"Aniri|E ama ouro. Provavelmente será relevante para a negociação.",
		"Sir Uiliam|Vou encontrá-lo na taverna.",
		"Aventureiro|Para convencê-lo a vir conosco?",
		"Sir Uiliam|Para oferecer a ele uma oportunidade.",
		"Aniri|Com ouro.",
		"Sir Uiliam|Se necessário.",
		"Aniri|Agora estamos falando a língua dele.",
		"Sir Uiliam|Depois descansamos. Pela manhã, procuraremos Hashagur no templo.",
		"Sir Uiliam|Se os homens da ponte pertencem ao mesmo grupo, algo que terminou há muitos anos começou novamente.",
		"Aniri|E não vai terminar apenas perguntando educadamente.",
		"Sir Uiliam|Por isso quero Kasum conosco.",
		"Aniri|Então vamos à taverna. Pela investigação, naturalmente. E talvez pela comida.",
		"Aventureiro|Naturalmente.",
		"Ação|O grupo deixa a prefeitura.",
		"Novo objetivo|OURO COMPRA UMA BOA ESPADA — Encontre Kasum na taverna e descubra quanto custará convencê-lo a acompanhar o grupo."
	]
}

static func get_scene(scene_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var lines: Array = SCENES.get(scene_id, [])
	for raw_line in lines:
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
