extends Node


static func get_scenario_data(stage_number: int) -> Dictionary:
	match stage_number:
		1:
			return get_stage_1()
		2:
			return get_stage_2()
		3:
			return get_stage_3()
		_:
			return get_stage_1()


static func get_stage_1() -> Dictionary:
	return {
		"id": 1,
		"name": "Acampamento na Estrada",
		"description": "Uma estrada seca atravessa um pequeno acampamento goblin. O local possui pedras, arbustos, árvores, uma tenda abandonada e uma estrutura goblinoide.",
		
		"grid_width": 32,
		"grid_height": 24,
		"tile_size": 64,
		"background_image": "res://Assets/Maps/stage_1.jpg",
		"music": "res://Assets/Audio/stage_1.mp3",
		"music_start": "initiative",
		
		"player_start": Vector2i(2, 12),
		"companion_start": Vector2i(3, 13),
		"camera_start": Vector2i(2, 12),
		
		"npcs": [
	{
		"npc_id": "Guarda Aliado",
		"display_name": "Guarda Aliado",
		"position": Vector2i(16, 12),
		"control_type": "ai"
	}
],
		
		"terrain": {
			# Mato, arbustos e áreas mais fechadas.
			"difficult": [
				# Arbustos superior esquerdo
				Vector2i(5, 3),
				Vector2i(6, 3),
				Vector2i(7, 3),
				Vector2i(5, 4),
				Vector2i(6, 4),
				Vector2i(7, 4),
				
				# Arbustos superiores centrais
				Vector2i(12, 2),
				Vector2i(13, 2),
				Vector2i(14, 2),
				Vector2i(14, 3),
				Vector2i(15, 3),
				Vector2i(16, 3),
				
				# Arbustos região central
				Vector2i(17, 6),
				Vector2i(18, 6),
				Vector2i(19, 6),
				Vector2i(18, 7),
				Vector2i(19, 7),
				
				# Arbustos próximos da estrada direita
				Vector2i(25, 6),
				Vector2i(26, 6),
				Vector2i(27, 6),
				Vector2i(27, 7),
				Vector2i(28, 7),
				
				# Arbustos inferiores centrais
				Vector2i(14, 17),
				Vector2i(15, 17),
				Vector2i(16, 17),
				Vector2i(14, 18),
				Vector2i(15, 18),
				
				# Arbustos inferiores direitos
				Vector2i(25, 11),
				Vector2i(26, 11),
				Vector2i(27, 11),
				Vector2i(28, 11),
				Vector2i(27, 12),
				Vector2i(28, 12)
			],
			
			# Apenas o centro das árvores, pedras, muros e casa goblin bloqueiam.
			"blocked": [
				# Muro esquerdo superior
				Vector2i(1, 0),
				Vector2i(1, 1),
				Vector2i(1, 2),
				Vector2i(1, 3),
				Vector2i(1, 4),
				Vector2i(1, 5),
				Vector2i(1, 6),
				Vector2i(1, 7),
				
				# Muro esquerdo inferior
				Vector2i(1, 15),
				Vector2i(1, 16),
				Vector2i(1, 17),
				Vector2i(1, 18),
				Vector2i(1, 19),
				Vector2i(1, 20),
				Vector2i(1, 21),
				Vector2i(1, 22),
				Vector2i(1, 23),
				
				# Pedras grandes lado esquerdo/superior
				Vector2i(4, 1),
				Vector2i(9, 5),
				Vector2i(10, 6),
				Vector2i(11, 8),
				
				# Pedra superior central
				Vector2i(20, 1),
				
				# Pedras inferiores centrais
				Vector2i(21, 18),
				Vector2i(21, 19),
				Vector2i(21, 20),
				Vector2i(21, 21),
				
				# Centro das árvores
				Vector2i(6, 4),
				Vector2i(13, 4),
				Vector2i(18, 8),
				Vector2i(27, 4),
				Vector2i(12, 11),
				Vector2i(20, 12),
				Vector2i(25, 12),
				Vector2i(15, 17),
				
				# Tenda abandonada
				Vector2i(4, 19),
				Vector2i(5, 19),
				
				# Casa / estrutura goblin vermelha
				Vector2i(28, 18),
				Vector2i(29, 18),
				Vector2i(28, 19),
				Vector2i(29, 19)
			],
			
			# Reservado para dano futuro.
			"danger": []
		},
		
		# Tocos de árvore: áreas altas.
		"high_ground": [
			Vector2i(15, 6),
			Vector2i(21, 4),
			Vector2i(10, 17),
			Vector2i(18, 18)
		],
		
		"high_ground_attack_bonus": 2,
		
		# A recompensa desta batalha depende da sobrevivência do guarda.
		"interactions": [],
		
		"enemies": [
			{
				"monster_id": "Goblin Guerreiro",
				"display_name": "Goblin Guerreiro 1",
				"position": Vector2i(21, 12)
			},
			{
				"monster_id": "Goblin Guerreiro",
				"display_name": "Goblin Guerreiro 2",
				"position": Vector2i(24, 13)
			},
			{
				"monster_id": "Goblin Guerreiro",
				"display_name": "Goblin Guerreiro 3",
				"position": Vector2i(26, 9)
			},
			{
				"monster_id": "Goblin Guerreiro",
				"display_name": "Goblin Guerreiro 4",
				"position": Vector2i(27, 15)
			},
			{
				"monster_id": "Goblin Dardeiro",
				"display_name": "Goblin Dardeiro 1",
				"position": Vector2i(29, 6)
			},
			{
				"monster_id": "Goblin Dardeiro",
				"display_name": "Goblin Dardeiro 2",
				"position": Vector2i(29, 19)
			}
		],
	
	"events": [
	{
		"id": "sr_uiliam_arrival",
		"trigger": "npc_death",
		"trigger_npc_id": "Guarda Aliado",
		"once": true,
		
		"spawn": {
			"type": "npc",
			"id": "Sr Uiliam",
			"position": Vector2i(24, 2),
			"control_type": "player"
},

			"camera_focus": Vector2i(24, 6),
		
		"message": "Sir Uiliam chegou ao campo de batalha!",
		
		"initiative": {
			"add_to_current_battle": true,
			"position": "end"
		}
	}
],
}
static func get_scenario_music_volume_percent(
	stage_number: int
) -> float:
	match stage_number:
		1:
			return 80.0
		
		_:
			return 100.0
static func get_scenario_intro_sequence(
	stage_number: int
) -> Dictionary:
	match stage_number:
		1:
			return {
				"speaker_id": "Guarda Aliado",
				"speaker_name": "Soldado Ferido",
				"hero_reveal_duration": 0.8,
				"dialogue_camera_focus": Vector2i(9, 12),
				"opening_dialogues": [
					{"speaker": "Soldado Ferido", "text": "Ei! Você aí, me ajude!"}
				],
				"encounter_dialogues": [
					{"speaker": "Soldado Ferido", "text": "Se pretende continuar vivo, não fique parado!"},
					{"speaker": "[NOME_DO_JOGADOR]", "text": "Eu? Mas onde eu estou?... E já querem me matar."},
					{"speaker": "Soldado Ferido", "text": "Pare de falar besteiras e me ajude!"},
					{"speaker": "[NOME_DO_JOGADOR]", "text": "Sim!"},
					{"speaker": "[NOME_DO_JOGADOR]", "text": "Venha para perto de mim."},
					{"speaker": "Soldado Ferido", "text": "Você sabe lutar?"},
					{"speaker": "[NOME_DO_JOGADOR]", "text": "..."},
					{"speaker": "[NOME_DO_JOGADOR]", "text": "Vamos descobrir."}
				],
				
				"guard_start_position": Vector2i(
					30,
					12
				),
				
				"guard_final_position": Vector2i(
					16,
					12
				),
				
				"enemy_entry_x": 33,
				
				"enemy_camera_focus": Vector2i(
					24,
					12
				),
				
				"guard_walk_duration": 2.4,
				"enemy_walk_duration": 1.6,
				"pause_before_enemies": 0.35
			}
		
		3:
			return {
				"type": "scripted_dialogue",
				
				"initially_hidden_enemies": [
					"Cultista 1",
					"Cultista 2",
					"Cão de Caça 1",
					"Cão de Caça 2",
					"Lobo da Ordem 1",
					"Lobo da Ordem 2",
					"Lobo da Ordem 3"
				],
				
				"steps": [
					{
						"type": "camera",
						"position": Vector2i(
							15,
							13
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Hum... isso é pior do que eu imaginava."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Consegue consertar?"
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Consigo. Mas vou precisar substituir "
							+ "algumas vigas e reforçar a estrutura."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Não chegue tão perto."
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Se eu não olhar, como vou saber "
							+ "o que precisa ser feito?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Não estou falando da ponte."
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": (
							"Recebemos relatos de criaturas nessa região. "
							+ "E, com tão poucos soldados, não temos como "
							+ "patrulhar todas as estradas."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"O prefeito disse que a Ordem "
							+ "enviaria reforços."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": (
							"Enviou. Mas ainda não chegaram."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Ótimo. Então vamos terminar antes que "
							+ "alguma coisa resolva aparecer."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Espere."
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Tem alguém ali."
					},
					
					{
						"type": "reveal_enemies",
						"names": [
							"Cultista 1"
						],
						"camera_focus": Vector2i(
							12,
							5
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": (
							"Vocês não deveriam estar aqui."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Identifique-se!"
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": (
							"Esta área está bloqueada. Deem meia-volta."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Bloqueada? Por ordem de quem?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Isso não importa."
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Importa para mim. Fui enviado pelo prefeito "
							+ "para consertar essa ponte."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": (
							"Então o prefeito cometeu um erro."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": (
							"Você não tem autoridade para interditar "
							+ "uma estrada da vila."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": (
							"Pegue suas ferramentas e vá embora."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Escute, amigo. Não sei que tipo de problema "
							+ "você tem com essa ponte, mas metade da vila "
							+ "depende dela."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Último aviso."
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"E o que pretende fazer? Impedir que eu "
							+ "conserte umas tábuas?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Eu tentei avisá-los."
					},
					
					{
						"type": "reveal_enemies",
						"names": [
							"Cultista 2",
							"Cão de Caça 1",
							"Cão de Caça 2",
							"Lobo da Ordem 1",
							"Lobo da Ordem 2",
							"Lobo da Ordem 3"
						],
						"camera_focus": Vector2i(
							15,
							8
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": "Pelas barbas de Vanir..."
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Jhon! Para trás!"
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 2",
						"text": (
							"Eu disse que deveríamos ter eliminado "
							+ "os guardas antes."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Ainda há tempo."
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Certo... acho que os reparos vão "
							+ "ter de esperar!"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Fique atrás de mim!"
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Não se aproximem!"
					},
					
					{
						"type": "camera",
						"position": Vector2i(
							15,
							20
						)
					},
					{
						"type": "dialogue",
						"speaker": "Aniri",
						"text": "Ora, ora..."
					},
					{
						"type": "dialogue",
						"speaker": "Aniri",
						"text": (
							"Parece que encontramos Jhon."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Aniri",
						"text": (
							"E alguns amigos que ele não mencionou."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": "Vocês?!"
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"O que estão fazendo aqui?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": (
							"O prefeito nos enviou para "
							+ "garantir sua segurança."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": (
							"Então chegaram na hora certa!"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": "Baixem suas armas."
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Quem é você?"
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": (
							"Sou Uiliam, paladino a serviço "
							+ "da Ordem de Vanir."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": (
							"Consagrei minha espada à preservação "
							+ "da ordem, à defesa dos inocentes "
							+ "e ao triunfo da justiça."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "A Ordem de Vanir?!"
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 2",
						"text": (
							"O que um paladino está fazendo "
							+ "nestas terras?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": "Cumprindo meu dever."
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": (
							"Afastem essas criaturas e identifiquem-se."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": (
							"Não permitirei que ameacem estas pessoas."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Não..."
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": (
							"Não podemos permitir que a Ordem "
							+ "descubra o que estamos fazendo aqui."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 2",
						"text": (
							"Então acabemos com isso antes "
							+ "que cheguem mais."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Matem o paladino!"
					},
					{
						"type": "dialogue",
						"speaker": "Cultista 1",
						"text": "Eliminem todos eles!"
					},
					
					{
						"type": "camera",
						"position": Vector2i(
							15,
							14
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": "Jhon! Afaste-se da ponte!"
					},
					{
						"type": "dialogue",
						"speaker": "Jhon",
						"text": "Não precisa pedir duas vezes!"
					},
					{
						"type": "dialogue",
						"speaker": "Guarda da Vila",
						"text": "Paladino! Estou com você!"
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": (
							"Proteja o carpinteiro. Não deixe "
							+ "que essas criaturas o alcancem!"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Aniri",
						"text": (
							"Dois homens encapuzados, dois cães "
							+ "e três lobos..."
						)
					},
					{
						"type": "dialogue",
						"speaker": "Aniri",
						"text": (
							"Para minha primeira aventura, "
							+ "até que estou me saindo bem."
						)
					},
					{
						"type": "dialogue",
						"speaker": "[NOME_DO_JOGADOR]",
						"text": (
							"Você chama isso de se sair bem?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Aniri",
						"text": (
							"Ainda estamos vivos, não estamos?"
						)
					},
					{
						"type": "dialogue",
						"speaker": "Sir Uiliam",
						"text": "Companheiros! Preparem-se!"
					},
					{
						"type": "camera",
						"position": Vector2i(
							15,
							16
						)
					},
					{
	"type": "camera",
	"position": Vector2i(15, 16)
			},
			{
				"type": "move_npcs",
				"duration": 1.25,
				"moves": [
				{
					"npc_id": "Jhon",
					"destination": Vector2i(15, 17)
				},
				{
					"npc_id": "Guarda da Ponte",
					"destination": Vector2i(15, 16)
				}
			]
		}
				]
			}
		
		_:
			return {}

static func get_stage_2_blocked_cells() -> Array[Vector2i]:
	var blocked_cells: Array[Vector2i] = []

	# Mapa: 2048 x 1536 pixels.
	# Grade: 32 colunas x 24 linhas.
	# Cada célula possui 64 x 64 pixels.

	var upper_wall_polygon := PackedVector2Array(
		[
			Vector2(0.0, 0.0),
			Vector2(2048.0, 0.0),
			Vector2(2048.0, 235.0),
			Vector2(1700.0, 235.0),
			Vector2(1500.0, 240.0),
			Vector2(1355.0, 240.0),
			Vector2(1240.0, 232.0),
			Vector2(1050.0, 240.0),
			Vector2(870.0, 230.0),
			Vector2(790.0, 245.0),
			Vector2(730.0, 285.0),
			Vector2(640.0, 320.0),
			Vector2(605.0, 360.0),
			Vector2(575.0, 430.0),
			Vector2(530.0, 505.0),
			Vector2(490.0, 590.0),
			Vector2(430.0, 670.0),
			Vector2(360.0, 725.0),
			Vector2(280.0, 770.0),
			Vector2(150.0, 800.0),
			Vector2(0.0, 800.0)
		]
	)

	# Formação central deslocada:
	# 64 pixels para a direita;
	# 64 pixels para baixo em relação à versão anterior.
	var central_rock_polygon := PackedVector2Array(
		[
			Vector2(429.0, 1008.0),
			Vector2(534.0, 978.0),
			Vector2(614.0, 928.0),
			Vector2(754.0, 828.0),
			Vector2(834.0, 738.0),
			Vector2(914.0, 668.0),
			Vector2(994.0, 663.0),
			Vector2(1024.0, 688.0),
			Vector2(1144.0, 708.0),
			Vector2(1194.0, 758.0),
			Vector2(1234.0, 828.0),
			Vector2(1234.0, 978.0),
			Vector2(1184.0, 1048.0),
			Vector2(1094.0, 1098.0),
			Vector2(914.0, 1148.0),
			Vector2(714.0, 1178.0),
			Vector2(544.0, 1178.0),
			Vector2(464.0, 1128.0),
			Vector2(424.0, 1078.0)
		]
	)

	var campsite_and_right_wall_polygon := PackedVector2Array(
		[
			Vector2(1355.0, 235.0),
			Vector2(2048.0, 235.0),
			Vector2(2048.0, 1536.0),
			Vector2(1670.0, 1536.0),
			Vector2(1705.0, 1000.0),
			Vector2(1705.0, 570.0),
			Vector2(1600.0, 575.0),
			Vector2(1510.0, 570.0),
			Vector2(1440.0, 540.0),
			Vector2(1390.0, 500.0),
			Vector2(1360.0, 450.0)
		]
	)

	var bottom_wall_polygon := PackedVector2Array(
		[
			Vector2(0.0, 1198.0),
			Vector2(280.0, 1218.0),
			Vector2(350.0, 1288.0),
			Vector2(570.0, 1278.0),
			Vector2(750.0, 1338.0),
			Vector2(1170.0, 1338.0),
			Vector2(1190.0, 1303.0),
			Vector2(1360.0, 1328.0),
			Vector2(1410.0, 1358.0),
			Vector2(1550.0, 1358.0),
			Vector2(1650.0, 1308.0),
			Vector2(1705.0, 1128.0),
			Vector2(1705.0, 1536.0),
			Vector2(0.0, 1536.0)
		]
	)

	var blocked_polygons: Array = [
		upper_wall_polygon,
		central_rock_polygon,
		campsite_and_right_wall_polygon,
		bottom_wall_polygon
	]

	for grid_y in range(24):
		for grid_x in range(32):
			var cell := Vector2i(
				grid_x,
				grid_y
			)

			var cell_center := Vector2(
				(float(grid_x) + 0.5) * 64.0,
				(float(grid_y) + 0.5) * 64.0
			)

			for blocked_polygon in blocked_polygons:
				if Geometry2D.is_point_in_polygon(
					cell_center,
					blocked_polygon
				):
					blocked_cells.append(cell)
					break

	return blocked_cells

static func get_stage_2() -> Dictionary:
	return {
		"id": 2,
		"name": "O Porão do Carpinteiro",
		"description": (
			"Jhon perdeu suas ferramentas em um porão "
			+ "tomado por ratos. O grupo precisa limpar "
			+ "o local e descobrir o que aconteceu."
		),
		
		"grid_width": 32,
		"grid_height": 24,
		"tile_size": 64,
		
		"background_image": (
			"res://Assets/Maps/Submissao1.1.jpg"
		),
		
		"music": (
			"res://Assets/Audio/Batalha2.mp3"
		),
		
		"music_start": "initiative",
		
		# Entrada aberta no lado esquerdo.
		"player_start": Vector2i(2, 14),
		"companion_start": Vector2i(3, 15),
		"camera_start": Vector2i(2, 14),
		
		"npcs": [
			{
				"npc_id": "Sr Uiliam",
				"display_name": "Sir Uiliam",
				"position": Vector2i(3, 13),
				"control_type": "player"
			}
		],
		
		"terrain": {
			"difficult": [],
			"blocked": get_stage_2_blocked_cells(),
			"danger": []
		},
		
		"high_ground": [],
		"high_ground_attack_bonus": 2,
		"interactions": [],
		
		"enemies": [
			{
				"monster_id": "Rato",
				"display_name": "Rato 1",
				"position": Vector2i(8, 12)
			},
			{
				"monster_id": "Rato",
				"display_name": "Rato 2",
				"position": Vector2i(10, 6)
			},
			{
				"monster_id": "Rato",
				"display_name": "Rato 3",
				"position": Vector2i(15, 5)
			},
			{
				"monster_id": "Rato",
				"display_name": "Rato 4",
				"position": Vector2i(21, 6)
			},
			{
				"monster_id": "Rato",
				"display_name": "Rato 5",
				"position": Vector2i(23, 12)
			},
			{
				"monster_id": "Rato Atroz",
				"display_name": "Rato Atroz 1",
				"position": Vector2i(20, 10)
			},
			{
				"monster_id": "Rato Atroz",
				"display_name": "Rato Atroz 2",
				"position": Vector2i(24, 15)
			}
		]
	}


static func get_stage_3() -> Dictionary:
	return {
		"id": 3,
		"name": "A Ponte da Esmeralda",
		"description": (
			"Proteja Jhon e elimine as criaturas "
			+ "que bloquearam a Ponte da Esmeralda."
		),
		
		"grid_width": 32,
		"grid_height": 24,
		"tile_size": 64,
		
		"background_image": (
			"res://Assets/Maps/Batalha ponte.jpg"
		),
		
		"music": (
			"res://Assets/Audio/Batalha3.mp3"
		),
		
		"music_start": "initiative",
		
		# O grupo chega pela estrada ao sul.
		"player_start": Vector2i(
			15,
			21
		),
		
		"companion_start": Vector2i(
			18,
			22
		),
		
		"camera_start": Vector2i(
			15,
			17
		),
		
		"victory_conditions": [
			{
				"type": "eliminate_all_enemies",
				"description": (
					"Elimine todos os inimigos."
				)
			}
		],
		
		"defeat_conditions": [
			{
				"type": "hero_defeated",
				"description": (
					"O aventureiro foi derrotado."
				)
			},
			{
				"type": "npc_defeated",
				"npc_id": "Jhon",
				"description": (
					"Jhon foi morto."
				)
			}
		],
		
		"npcs": [
			{
				"npc_id": "Sr Uiliam",
				"display_name": "Sir Uiliam",
				"position": Vector2i(
					14,
					21
				),
				"control_type": "player"
			},
			{
				"npc_id": "Aniri",
				"display_name": "Aniri",
				"position": Vector2i(
					16,
					21
				),
				"control_type": "player"
			},
			{
				"npc_id": "Jhon",
				"display_name": "Jhon",
				"position": Vector2i(
					15,
					13
				),
				"control_type": "passive"
			},
			{
				"npc_id": "Guarda da Ponte",
				"display_name": "Guarda da Vila",
				"position": Vector2i(
					15,
					12
				),
				"control_type": "ai"
			}
		],
		
		"terrain": {
			"difficult": [],
			"blocked": [],
			"danger": []
		},
		
		"high_ground": [],
		"high_ground_attack_bonus": 2,
		"interactions": [],
		
		"enemies": [
			{
				"monster_id": "Cultista",
				"display_name": "Cultista 1",
				"position": Vector2i(
					12,
					5
				)
			},
			{
				"monster_id": "Cultista",
				"display_name": "Cultista 2",
				"position": Vector2i(
					19,
					5
				)
			},
			{
				"monster_id": "Cão de Caça",
				"display_name": "Cão de Caça 1",
				"position": Vector2i(
					14,
					7
				)
			},
			{
				"monster_id": "Cão de Caça",
				"display_name": "Cão de Caça 2",
				"position": Vector2i(
					17,
					7
				)
			},
			{
				"monster_id": "Lobo da Ordem",
				"display_name": "Lobo da Ordem 1",
				"position": Vector2i(
					11,
					9
				)
			},
			{
				"monster_id": "Lobo da Ordem",
				"display_name": "Lobo da Ordem 2",
				"position": Vector2i(
					15,
					9
				)
			},
			{
				"monster_id": "Lobo da Ordem",
				"display_name": "Lobo da Ordem 3",
				"position": Vector2i(
					20,
					9
				)
			}
		]
	}

static func get_scenario_round_events(
	stage_number: int
) -> Array:
	match stage_number:
		1:
			return [
				{
					"id": "sr_uiliam_arrival",
					"round": 2,
					"once": true,
					
					"spawn": {
						"type": "npc",
						"id": "Sr Uiliam",
						"position": Vector2i(
							24,
							4
						),
						"control_type": "player"
					},
					
					"camera_focus": Vector2i(
						24,
						1
					),
					
					"pre_spawn_dialogue": [
						{"speaker": "Narrador", "text": "Uma das criaturas prepara um ataque. Um golpe interrompe seu avanço.", "camera_focus": Vector2i(21, 12)}
					],
					"dialogue": [
						{"speaker": "Narrador", "text": "Sir Uiliam entra no campo de batalha."},
						{"speaker": "Sir Uiliam", "text": "Afastem-se deles!"},
						{"speaker": "Sir Uiliam", "text": "Sou Uiliam, paladino a serviço da Ordem de Vanir."},
						{"speaker": "Sir Uiliam", "text": "Consagrei minha espada à preservação da ordem, à defesa dos inocentes e ao triunfo da justiça."},
						{"speaker": "Sir Uiliam", "text": "Fui enviado pela Ordem para ajudar a proteger esta vila."},
						{"speaker": "[NOME_DO_JOGADOR]", "text": "Ótimo. Porque eu cheguei aqui faz pouco e já estou começando a achar que este lugar não gosta muito de visitantes."},
						{"speaker": "Sir Uiliam", "text": "Sobreviva a isto e poderá formar uma opinião melhor."},
						{"speaker": "[NOME_DO_JOGADOR]", "text": "Reconfortante."},
						{"speaker": "[NOME_DO_JOGADOR]", "text": "Você sempre se apresenta desse jeito no meio de uma batalha?"},
						{"speaker": "Sir Uiliam", "text": "Sempre que há tempo."},
						{"speaker": "[NOME_DO_JOGADOR]", "text": "Estamos cercados."},
						{"speaker": "Sir Uiliam", "text": "Então serei breve."},
						{"speaker": "Narrador", "text": "Uiliam ergue a espada."}
					],
					
					"initiative": {
						"add_to_current_battle": true,
						"position": "end"
					}
				}
			]
		
		3:
			return [
				{
					"id": "hashagur_arrival",
					"round": 3,
					"once": true,
					
					"spawn": {
						"type": "npc",
						"id": "Hashagur",
						"position": Vector2i(
							13,
							11
						),
						"control_type": "player"
					},
					
					"camera_focus": Vector2i(
						13,
						10
					),
					
					"dialogue": [
						{
							"speaker": "Narrador",
							"text": (
								"Durante a batalha, um dos lobos "
								+ "se prepara para atacar o aventureiro."
							)
						},
						{
							"speaker": "Narrador",
							"text": (
								"Subitamente, uma figura robusta salta "
								+ "de uma elevação próxima e atinge a "
								+ "criatura com um poderoso golpe."
							)
						},
						{
							"speaker": "Narrador",
							"text": (
								"Um meio-orc de vestes monásticas pousa "
								+ "entre o grupo e os inimigos."
							)
						},
						{
							"speaker": "Aniri",
							"text": "Um orc?!"
						},
						{
							"speaker": "Narrador",
							"text": (
								"Uiliam ergue o escudo, mas percebe que "
								+ "o recém-chegado está enfrentando os "
								+ "cultistas."
							)
						},
						{
							"speaker": "Sir Uiliam",
							"text": (
								"Espere, Aniri! Ele não é nosso inimigo."
							)
						},
						{
							"speaker": "Cultista 1",
							"text": "Você?!"
						},
						{
							"speaker": "Hashagur",
							"text": "Reconheço suas vestes."
						},
						{
							"speaker": "Narrador",
							"text": "Hashagur fecha os punhos."
						},
						{
							"speaker": "Hashagur",
							"text": (
								"Seu culto vem atacando nosso templo "
								+ "há semanas."
							)
						},
						{
							"speaker": "Hashagur",
							"text": (
								"Pensei que encontraria vocês "
								+ "por estas terras."
							)
						},
						{
							"speaker": "Cultista 2",
							"text": (
								"Deveria ter permanecido no seu "
								+ "templo, orc!"
							)
						},
						{
							"speaker": "Hashagur",
							"text": (
								"E permitir que continuassem "
								+ "atacando inocentes?"
							)
						},
						{
							"speaker": "Narrador",
							"text": (
								"Hashagur assume sua postura de combate."
							)
						},
						{
							"speaker": "Hashagur",
							"text": "Não desta vez."
						},
						{
							"speaker": "Sir Uiliam",
							"text": (
								"Sou Uiliam, paladino da Ordem de Vanir! "
								+ "Estamos aqui para proteger estas pessoas."
							)
						},
						{
							"speaker": "Hashagur",
							"text": (
								"Hashagur. Protetor do templo "
								+ "nas montanhas."
							)
						},
						{
							"speaker": "Narrador",
							"text": (
								"Os dois trocam um breve olhar "
								+ "de reconhecimento."
							)
						},
						{
							"speaker": "Sir Uiliam",
							"text": (
								"Então temos um inimigo em comum."
							)
						},
						{
							"speaker": "Hashagur",
							"text": "Parece que sim."
						},
						{
							"speaker": "Aniri",
							"text": (
								"Ótimo! Mais um para nosso lado!"
							)
						},
						{
							"speaker": "Hashagur",
							"text": (
								"Conversaremos depois. Primeiro, "
								+ "terminemos isto!"
							)
						},
						{
							"speaker": "Narrador",
							"text": (
								"Hashagur avança contra os cultistas."
							)
						},
						{
							"speaker": "Narrador",
							"text": (
								"HASHAGUR ENTROU NA BATALHA!"
							)
						}
					],
					
					"initiative": {
						"add_to_current_battle": true,
						"position": "end"
					}
				}
			]
		
		_:
			return []

static func get_scenario_event_entry_data(
	event_id: String
) -> Dictionary:
	match event_id:
		"sr_uiliam_arrival":
			return {
				"start_position": Vector2i(
					24,
					-1
				),
				"map_entry_position": Vector2i(
					24,
					0
				),
				"camera_focus": Vector2i(
					24,
					1
				),
				"movement_duration": 1.0,
				"appearance_delay": 0.18
			}
		
		"hashagur_arrival":
			return {
				"start_position": Vector2i(
					10,
					8
				),
				"map_entry_position": Vector2i(
					12,
					10
				),
				"camera_focus": Vector2i(
					13,
					10
				),
				"movement_duration": 0.75,
				"appearance_delay": 0.15
			}
		
		_:
			return {}

static func is_round_event(
	stage_number: int,
	event_id: String
) -> bool:
	var round_events: Array = (
		get_scenario_round_events(
			stage_number
		)
	)
	
	for event_data in round_events:
		if str(
			event_data.get(
				"id",
				""
			)
		) == event_id:
			return true
	
	return false

static func _scripted_dialogues(script: String) -> Array:
	var dialogues: Array = []
	for raw_line in script.strip_edges().split("\n"):
		var line: String = raw_line.strip_edges()
		var separator: int = line.find("|")
		if separator <= 0:
			continue
		var speaker_name: String = line.substr(0, separator)
		if speaker_name == "SR. UILIAM" or speaker_name == "SiR. UILIAM":
			speaker_name = "Sir Uiliam"
		dialogues.append({
			"speaker_name": speaker_name,
			"text": line.substr(separator + 1)
		})
	return dialogues


static func get_stage_2_victory_intro_data() -> Dictionary:
	return {
		"aniri_position": Vector2i(24, 7),
		"uiliam_approach_position": Vector2i(22, 9),
		"camera_focus_position": Vector2i(23, 8),
		"opening_dialogue_count": 10,
		"dialogues_before_approach": _scripted_dialogues("""
Ação|O último rato cai.
[NOME_DO_JOGADOR]|Então esses eram os ratos.
Sir Uiliam|Aparentemente.
Ação|O aventureiro observa o porão e encontra algumas ferramentas.
[NOME_DO_JOGADOR]|Uiliam.
Sir Uiliam|Sim?
[NOME_DO_JOGADOR]|Ratos costumam guardar martelos?
Sir Uiliam|Não.
Voz desconhecida|Talvez sejam ratos particularmente organizados.
Ação|Os dois se viram.
Ação|Uma halfling de certa idade surge atrás das caixas. Carrega uma bolsa cheia e uma das ferramentas de Jhon está presa ao cinto.
Aniri|Antes que tirem conclusões...
Ação|Ela olha para a própria bolsa.
Aniri|...admito que a situação não está me favorecendo.
[NOME_DO_JOGADOR]|Acho que encontramos o rato.
Aniri|Halfling.
Aniri|Diferença importante.
Sir Uiliam|A bolsa.
Aniri|Nem um “boa tarde”?
Sir Uiliam|Aniri.
Aniri|Nem sabe meu nome ainda.
Sir Uiliam|A bolsa.
Aniri|Paladino.
Aniri|Agora faz sentido.
"""),
		"dialogues_after_approach": _scripted_dialogues("""
Ação|Aniri coloca a bolsa no chão. Dentro estão ferramentas, moedas e outros objetos da carpintaria.
[NOME_DO_JOGADOR]|Então não foram os ratos.
Aniri|Eu realmente gostaria que tivessem sido.
Sir Uiliam|Você roubou Jhon.
Aniri|Sim.
Sir Uiliam|Sem desculpas?
Aniri|Tenho algumas.
Aniri|Nenhuma muito boa.
[NOME_DO_JOGADOR]|Por quê?
Ação|Aniri olha para ele.
Aniri|Meu nome é Aniri.
[NOME_DO_JOGADOR]|[NOME_DO_JOGADOR].
Aniri|Prazer.
Ação|Ela olha para Uiliam.
Aniri|E você é obviamente um paladino.
Ação|Uiliam assume sua postura.
Sir Uiliam|Sou Uiliam, paladino a serviço da Ordem de Vanir. Consagrei minha—
Aniri|Não precisava provar.
Ação|Silêncio.
Aniri|Desculpe.
Aniri|Continue.
Sir Uiliam|Não.
Aniri|Uma pena.
[NOME_DO_JOGADOR]|Ainda não respondeu.
Aniri|Eu estava indo embora.
[NOME_DO_JOGADOR]|Da vila?
Aniri|Sim.
[NOME_DO_JOGADOR]|Sozinha?
Aniri|Esse era o plano.
Ação|O aventureiro olha para a bolsa.
[NOME_DO_JOGADOR]|Sem dinheiro e sem equipamento.
Aniri|O plano tinha falhas.
Sir Uiliam|Então resolveu roubar.
Aniri|Resolvi virar aventureira.
Ação|Ela aponta para a bolsa.
Aniri|Isso foi uma péssima decisão no caminho.
[NOME_DO_JOGADOR]|Uma distinção importante.
Sir Uiliam|Não tanto quanto ela gostaria.
Sir Uiliam|Por que se tornar aventureira agora?
Ação|Aniri hesita.
Aniri|Porque esperei demais.
Aniri|Passei anos vendo outras pessoas atravessarem aqueles portões enquanto eu pensava...
Aniri|“Algum dia.”
Ação|Ela dá de ombros.
Aniri|Até perceber que “algum dia” estava ficando parecido demais com “nunca”.
[NOME_DO_JOGADOR]|E resolveu sair.
Aniri|Enquanto ainda posso.
Sir Uiliam|Sabe o que existe além dos muros?
Aniri|Monstros.
Aniri|Estradas ruins.
Aniri|E várias maneiras desagradáveis de morrer.
[NOME_DO_JOGADOR]|Está com medo?
Aniri|Muito.
[NOME_DO_JOGADOR]|Não parece.
Aniri|Anos de prática.
Ação|Uiliam observa Aniri.
Sir Uiliam|Coragem não é ausência de medo.
Sir Uiliam|É continuar apesar dele.
Aniri|Então talvez eu tenha alguma.
Sir Uiliam|Ainda existe o roubo.
Aniri|Eu sei.
Sir Uiliam|Querer mudar de vida não lhe dá direito de prejudicar outra pessoa.
Ação|Aniri olha para a bolsa.
Aniri|Então devolvo tudo.
[NOME_DO_JOGADOR]|E Jhon?
Aniri|...
[NOME_DO_JOGADOR]|Vai falar com ele?
Aniri|Preferia mais ratos.
Sir Uiliam|Aniri.
Aniri|Sim.
Aniri|Vou falar com ele.
[NOME_DO_JOGADOR]|Sem fugir?
Aniri|Vocês realmente gostam dessa parte.
[NOME_DO_JOGADOR]|Sem fugir?
Aniri|Sem fugir.
""")
	}


static func get_stage_2_victory_choice_data() -> Dictionary:
	return {
		"prompt": "O que você diz sobre Aniri?",
		"options": [
			{
				"id": "give_aniri_a_chance",
				"button_text": "Se reparar o prejuízo, merece uma chance.",
				"dialogues": _scripted_dialogues("""
[NOME_DO_JOGADOR]|Se devolver tudo e reparar o prejuízo...
[NOME_DO_JOGADOR]|acho que merece uma chance.
Aniri|Já confia em mim?
[NOME_DO_JOGADOR]|Não.
Aniri|Ah.
[NOME_DO_JOGADOR]|Mas pode provar que está falando sério.
Ação|Aniri sorri discretamente.
Aniri|Melhor.
Sir Uiliam|Então prove.
Sir Uiliam|Devolva o que roubou e cumpra sua palavra.
Aniri|Justo.
Aniri|E depois posso acompanhar vocês?
Ação|Uiliam olha para o aventureiro.
Sir Uiliam|Isso não cabe apenas a mim decidir.
[NOME_DO_JOGADOR]|Primeiro Jhon.
Aniri|Claro que vocês lembrariam dessa parte.
""")
			},
			{
				"id": "jhon_decides",
				"button_text": "Jhon deve decidir o que acontece.",
				"dialogues": _scripted_dialogues("""
[NOME_DO_JOGADOR]|Você roubou Jhon.
[NOME_DO_JOGADOR]|Acho que ele deve decidir como isso termina.
Ação|Aniri respira fundo.
Aniri|Justo.
Sir Uiliam|Se ele exigir reparação?
Aniri|Eu reparo.
[NOME_DO_JOGADOR]|E se chamar os guardas?
Ação|Aniri perde o sorriso.
Aniri|Então assumo o que fiz.
Ação|Uiliam assente.
Sir Uiliam|Um bom começo.
Aniri|Não poderia ser um começo menos desconfortável?
Sir Uiliam|Não.
Aniri|Imaginei.
""")
			}
		]
	}


static func get_stage_2_victory_conclusion_data() -> Dictionary:
	return {
		"dialogues": _scripted_dialogues("""
Ação|Aniri pega a bolsa.
Aniri|Então vamos descobrir se minha carreira de aventureira termina antes mesmo de sair desta carpintaria.
[NOME_DO_JOGADOR]|Começou muito bem.
Aniri|Você é sempre tão encorajador?
[NOME_DO_JOGADOR]|Ainda estou descobrindo.
Ação|Aniri olha para ele por um instante.
Aniri|Acho que vou gostar de viajar com você.
[NOME_DO_JOGADOR]|Ninguém disse que você vai.
Aniri|Ainda.
Sir Uiliam|Primeiro, Jhon.
Aniri|Vocês sabem acabar com um momento.
Ação|Os três seguem para a escada.
"""),
		"mission": {
			"id": "aniri_second_chance",
			"title": "Uma Segunda Chance",
			"description": (
				"Aniri roubou ferramentas e suprimentos para tentar iniciar sua própria jornada. "
				+ "Ela concordou em devolver tudo e enfrentar Jhon.\n"
				+ "Objetivo: leve Aniri até Jhon."
			),
			"status": "active"
		},
		"return_scene": "res://Scene/village.tscn",
		"return_location": "carpenter",
		"recruit_npc_id": "Aniri",
		"recruit_immediately": false
	}


static func get_scenario_victory_sequence(
	stage_number: int
) -> Dictionary:
	match stage_number:
		1:
			return {
				"speaker_id": "Sir Uiliam",
				"speaker_name": "Sir Uiliam",
				"guard_survival_bonus_gold": 10,
				"dialogues": _scripted_dialogues("""
Narrador|A última criatura cai. O aventureiro observa a própria arma.
Sir Uiliam|Lutou bem.
[NOME_DO_JOGADOR]|Eu nem sabia que conseguia lutar.
Sir Uiliam|Não se lembra de ter aprendido?
[NOME_DO_JOGADOR]|Não. Nem de onde vim.
Sir Uiliam|Do que se lembra?
[NOME_DO_JOGADOR]|Só de estar aqui.
Sir Uiliam|E mesmo assim entrou na batalha para proteger um desconhecido.
[NOME_DO_JOGADOR]|Ele precisava de ajuda.
Sir Uiliam|Isso diz algo sobre quem você é.
[NOME_DO_JOGADOR]|Onde estamos?
Sir Uiliam|Aviant.
[NOME_DO_JOGADOR]|Nunca ouvi esse nome.
Sir Uiliam|Então temos mais para conversar do que imaginei.
[NOME_DO_JOGADOR]|E essas criaturas?
Sir Uiliam|Explicarei na vila. Venha conosco.
[NOME_DO_JOGADOR]|Talvez lá eu descubra por que sei usar esta arma.
Sir Uiliam|Talvez.
"""),
				"guard_survival_dialogues": _scripted_dialogues("""
Narrador|O guarda se aproxima.
Soldado Ferido|Você salvou minha vida.
Narrador|Ele entrega uma pequena bolsa.
Recompensa|+10 peças de ouro.
Soldado Ferido|Considere um agradecimento.
Soldado Ferido|Também estou voltando para a vila.
Soldado Ferido|Mostro o caminho.
Sir Uiliam|Então vamos juntos.
"""),
				"guard_death_dialogues": _scripted_dialogues("""
Narrador|O aventureiro observa o corpo do guarda.
[NOME_DO_JOGADOR]|Não consegui protegê-lo.
Sir Uiliam|Você tentou.
Sir Uiliam|Mas ainda devemos tentar.
[NOME_DO_JOGADOR]|Vamos.
"""),
				"convergence_dialogues": _scripted_dialogues("""
Narrador|O grupo segue pela estrada.
[NOME_DO_JOGADOR] (pensamento)|Não sei quem sou.
[NOME_DO_JOGADOR] (pensamento)|Mas alguma coisa em mim sabia que eu precisava ajudar.
Narrador|Cenário 1 concluído.
Novo objetivo|Siga Sir Uiliam até a vila. Encontre-o na taverna e descubra mais sobre Aviant.
"""),
				"hero_village_exit": Vector2i(
					33,
					12
				),
				"uiliam_village_exit": Vector2i(
					33,
					11
				),
				"guard_village_exit": Vector2i(33, 13),
				"movement_duration": 2.5,
				"next_scene": (
					"res://Scene/village.tscn"
				)
			}
		
		_:
			return {}


static func assemble_stage_1_victory_dialogues(
	sequence_data: Dictionary,
	guard_survived: bool
) -> Array:
	var dialogues: Array = sequence_data.get("dialogues", []).duplicate()
	if guard_survived:
		dialogues.append_array(sequence_data.get("guard_survival_dialogues", []))
	else:
		dialogues.append_array(sequence_data.get("guard_death_dialogues", []))
	dialogues.append_array(sequence_data.get("convergence_dialogues", []))
	return dialogues


static func get_scenario_weather(
	stage_number: int
) -> Dictionary:
	match stage_number:
		1:
			return {
				"rain_enabled": true,
				"rain_count": 150,
				"rain_speed": 880.0,
				"rain_drift": -115.0,
				"lightning_enabled": true,
				"lightning_min_interval": 20.0,
				"lightning_max_interval": 20.0
			}
		
		_:
			return {
				"rain_enabled": false,
				"lightning_enabled": false
			}
