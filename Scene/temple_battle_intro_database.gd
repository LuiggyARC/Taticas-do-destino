extends RefCounted

const SCENE_8 := """
Narrador|Os sinos continuam tocando. Do lado de fora, os discípulos correm para defender os portões.
Narrador|Hashagur observa o pátio através da entrada do salão.
Hashagur|Eles tentarão romper a entrada principal.
Hashagur|Uiliam, leve os outros para o pátio.
Sir Uiliam|E você?
Hashagur|Vou impedir que—
@breach
Narrador|BOOM! Uma explosão violenta rompe a parede atrás de Hashagur. Pedras atravessam o salão e a poeira cobre tudo.
Aniri|O que foi isso?!
Narrador|Hashagur se vira. Entre a fumaça, silhuetas atravessam a abertura: armaduras reforçadas, armas melhores e movimentos disciplinados.
@reveal_elites
Narrador|Por último, um pequeno gnomo atravessa os escombros.
Ebramir|Hashagur.
Hashagur|Ebramir.
Ebramir|Diga-me... como é estar do lado que foi surpreendido?
Narrador|Hashagur não responde.
Ebramir|Foi assim que acabaram com aqueles que vieram antes de nós.
Ebramir|Entraram sem serem vistos. Atacaram por onde ninguém esperava.
Ebramir|Quando perceberam o que estava acontecendo... já era tarde demais.
Hashagur|Eles tiveram a oportunidade de se render.
Ebramir|E isso deveria tornar a história mais bonita?
Ebramir|Passei anos ouvindo sobre aquela noite. Sobre os grandes monges que destruíram o culto sem sequer bater aos portões.
Ebramir|Preciso admitir... há certo prazer em devolver na mesma moeda.
Aniri (baixo)|Não gostei dele.
Kasum|Só agora?
Hashagur|Você atravessou meus muros. Ainda não tomou meu templo.
Ebramir|Não. Mas pretendo corrigir isso.
Narrador|Os guerreiros ao redor dele sacam suas armas.
Sir Uiliam|Esses homens... não são como os da ponte.
Hashagur|Não. São os melhores de Ebramir.
Hashagur|Saiam daqui.
Sir Uiliam|Não.
Hashagur|Uiliam.
Sir Uiliam|Podemos lutar.
Kasum|Finalmente concordamos em alguma coisa.
Aniri|Estou aqui para o que der e vier... mas ainda prefiro que ninguém morra tentando provar isso.
Hashagur|Escutem-na.
Ebramir|Interessante.
Hashagur|O quê?
Ebramir|Você realmente não quer que eles morram. Quase comovente.
Sir Uiliam|Hashagur não precisa que você—
Ebramir|Já que a presença deles o incomoda tanto...
Narrador|Ebramir ergue uma das mãos. Símbolos avermelhados surgem no chão.
Hashagur|Afastem-se!
@fire_wall
Narrador|FWOOSH! Uma muralha de fogo explode entre Hashagur e o grupo, de uma parede à outra. O calor obriga todos a recuar.
Sir Uiliam|Hashagur!
Hashagur|Não atravesse!
Aventureiro|Não existe passagem!
Narrador|Do outro lado das chamas estão Hashagur, Ebramir e seus guerreiros de elite.
Ebramir|Pronto. Eles não vão se intrometer.
Ebramir|Agora somos só nós... contra você.
Hashagur|Era isso que eu queria.
Narrador|O sorriso de Ebramir diminui ligeiramente.
"""

const SCENE_9 := """
Sir Uiliam|HASHAGUR!
Narrador|Uiliam procura uma abertura entre as chamas.
Hashagur|Pare!
Sir Uiliam|Podemos atravessar!
Hashagur|Não. Essas chamas vão matá-los antes que cheguem até mim.
Kasum|Ele está certo.
Sir Uiliam|Não pedi sua opinião.
Kasum|Mesmo assim recebeu.
Hashagur|Os homens da ponte eram seguidores. Estes foram treinados para matar.
Sir Uiliam|Não tenho medo deles.
Hashagur|Não pedi que tivesse medo. Pedi que sobrevivesse.
Narrador|Gritos surgem no corredor atrás do grupo.
Aniri|Temos outro problema.
@reveal_cultists
Narrador|Cinco cultistas comuns entram pela única rota de saída. O grupo está preso entre eles e a muralha de fogo.
Kasum|Isso está ficando apertado.
Ebramir|Parece que minha ajuda não foi suficiente.
Hashagur|Querem ajudar? Eliminem aqueles cinco.
Aventureiro|E você?
Hashagur|Eu termino o que começou dentro do meu templo.
Sir Uiliam|Hashagur—
Hashagur|Abram a passagem e saiam.
Narrador|Um dos guerreiros de elite avança. Hashagur bloqueia o golpe.
Hashagur|AGORA!
Novo objetivo|ABRA UMA ROTA DE FUGA — A muralha de fogo impede o grupo de alcançar Hashagur e Ebramir. Elimine os cinco cultistas que bloqueiam a única saída.
"""


static func get_scene(scene_number: int) -> Array[Dictionary]:
	var script: String = SCENE_8 if scene_number == 8 else (SCENE_9 if scene_number == 9 else "")
	var result: Array[Dictionary] = []
	for raw_line in script.strip_edges().split("\n"):
		var line: String = raw_line.strip_edges()
		if line.begins_with("@"):
			result.append({"type": line.substr(1)})
			continue
		var divider: int = line.find("|")
		if divider <= 0:
			continue
		result.append({"type": "dialogue", "speaker": line.substr(0, divider), "text": line.substr(divider + 1)})
	return result
