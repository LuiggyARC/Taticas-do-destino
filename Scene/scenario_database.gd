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

static func _stage_2_dialogues(script: String) -> Array:
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
		"opening_dialogue_count": 18,
		"dialogues_before_approach": _stage_2_dialogues("""
Ação|O último rato cai.
Ação|O aventureiro recupera o fôlego. Uiliam observa os corpos espalhados pelo porão.
[NOME_DO_JOGADOR]|Então esses eram os ratos.
Sir Uiliam|Aparentemente.
[NOME_DO_JOGADOR]|Depois das criaturas lá fora, esperava alguma coisa pior.
Sir Uiliam|Não subestime aquilo que possui dentes.
Ação|O aventureiro começa a observar o porão.
Ação|Entre algumas caixas, vê ferramentas semelhantes às que Jhon descreveu.
[NOME_DO_JOGADOR]|Uiliam.
Sir Uiliam|Sim?
[NOME_DO_JOGADOR]|Ratos costumam guardar martelos?
Ação|Uiliam olha.
Sir Uiliam|Não.
Voz desconhecida|Talvez sejam ratos particularmente organizados.
Ação|Silêncio.
Ação|Os dois imediatamente olham para o outro lado do porão.
[NOME_DO_JOGADOR]|Quem disse isso?
Ação|Algumas caixas se mexem.
Ação|Uma pequena figura surge lentamente detrás de tábuas empilhadas.
Ação|É uma halfling já de certa idade. Ela carrega uma bolsa exageradamente cheia. Um dos martelos de Jhon está preso ao cinto e várias ferramentas aparecem entre seus pertences.
Aniri|Antes que tirem conclusões precipitadas...
Ação|Ela olha para o próprio cinto.
Ação|Depois para a bolsa.
Aniri|...admito que minha situação visual não está ajudando.
[NOME_DO_JOGADOR]|Acho que encontramos o rato que estava levando as ferramentas.
Aniri|Halfling.
Aniri|A diferença é importante.
SR. UILIAM|Coloque a bolsa no chão.
Aniri|Podemos começar com um “boa tarde”?
SR. UILIAM|A bolsa.
Ação|Aniri observa Uiliam por alguns segundos.
Aniri|Paladino?
"""),
		"dialogues_after_approach": _stage_2_dialogues("""
Ação|Uiliam se aproxima dela.
SR. UILIAM|Isso importa?
Aniri|Explica muita coisa.
[NOME_DO_JOGADOR]|Especialmente a maneira como ele pede as coisas.
SR. UILIAM|[NOME_DO_JOGADOR].
[NOME_DO_JOGADOR]|Só estou observando.
Ação|Aniri suspira e coloca a bolsa no chão.
Aniri|Muito bem.
Aniri|Sem movimentos bruscos.
Aniri|Principalmente porque minhas costas não permitem mais.
Ação|Uiliam abre a bolsa.
Ação|Dentro estão ferramentas, moedas e outros objetos pertencentes à carpintaria.
SR. UILIAM|Estas são as ferramentas de Jhon.
[NOME_DO_JOGADOR]|Então realmente não eram os ratos.
Aniri|Eu gostaria de dizer que eram.
Aniri|Resolveria grande parte dos meus problemas.
SR. UILIAM|Você roubou este estabelecimento.
Aniri|Tecnicamente—
Ação|Uiliam encara Aniri.
Aniri|Sim.
Aniri|Roubei.
SR. UILIAM|Pelo menos não acrescentou mentira ao crime.
Aniri|Com a minha idade, mentir dá mais trabalho do que confessar.
SR. UILIAM|Roubo não se torna aceitável porque decidiu tratá-lo como piada.
Ação|O sorriso de Aniri diminui.
Aniri|Eu sei.
[NOME_DO_JOGADOR]|Então por quê?
Ação|Aniri olha para ele.
Aniri|Por quê o quê?
[NOME_DO_JOGADOR]|Você estava escondida no porão de outra pessoa...
Ação|Ele aponta para a bolsa.
[NOME_DO_JOGADOR]|com ferramentas roubadas...
Ação|Olha para os ratos.
[NOME_DO_JOGADOR]|e cercada por ratos gigantes.
[NOME_DO_JOGADOR]|Imagino que exista uma história.
Aniri|Existe.
Aniri|Não é uma das minhas melhores.
[NOME_DO_JOGADOR]|Tenho tempo.
SR. UILIAM|Eu também quero ouvi-la.
Aniri|Naturalmente.
Ação|Ela cruza os braços.
Aniri|Meu nome é Aniri.
[NOME_DO_JOGADOR]|[NOME_DO_JOGADOR].
Aniri|Prazer.
Ação|Ela olha para Uiliam.
Aniri|E você é obviamente um paladino.
Ação|Uiliam assume postura.
SR. UILIAM|Sou Uiliam, paladino a serviço da Ordem de Vanir. Consagrei minha—
Aniri|Não precisava provar.
Ação|O aventureiro segura um sorriso.
SR. UILIAM|...
Aniri|Desculpe.
Aniri|Continue.
SR. UILIAM|Não.
Aniri|Uma pena.
[NOME_DO_JOGADOR]|Aniri.
Aniri|Sim?
[NOME_DO_JOGADOR]|Por que roubou essas coisas?
Aniri|Porque precisava delas.
SR. UILIAM|Essa costuma ser a justificativa de quem rouba.
Aniri|Não estou dizendo que fiz certo.
Aniri|Estou dizendo por que fiz.
Ação|Ela olha para a bolsa.
Aniri|Eu estava indo embora.
[NOME_DO_JOGADOR]|Embora da vila?
SR. UILIAM|Para onde pretendia ir?
Aniri|Para fora dos muros como sempre.
Ação|Uiliam fica mais atento.
[NOME_DO_JOGADOR]|Sozinha?
Aniri|Esse era o plano.
[NOME_DO_JOGADOR]|Você ouviu a parte sobre as criaturas lá fora?
Aniri|Ouvi durante a maior parte da minha vida.
[NOME_DO_JOGADOR]|E mesmo assim decidiu sair?
Aniri|Justamente por isso.
Aniri|Passei anos vendo o mundo passar diante de mim.
Aniri|Mercadores chegavam contando histórias de lugares que nunca vi.
Aniri|Soldados voltavam das estradas.
Aniri|Aventureiros apareciam cobertos de lama, sangue e coisas que eu preferia não identificar.
Aniri|E eu?
Ação|Ela dá de ombros.
Aniri|Acordava.
Aniri|Trabalhava.
Aniri|Comia.
Aniri|Dormia.
Aniri|Depois fazia tudo novamente.
SR. UILIAM|Uma vida tranquila não é motivo de vergonha.
Aniri|Nunca disse que era.
Aniri|Só deixou de ser a vida que eu queria.
Ação|Breve silêncio.
Aniri|Durante anos pensei: “algum dia”.
Aniri|Algum dia vou atravessar aqueles portões.
Aniri|Algum dia vou ver essas florestas.
Aniri|Algum dia vou descobrir se metade das histórias que contam nas tavernas é verdade.
Ação|Ela olha para as próprias mãos.
Aniri|Até perceber que “algum dia” estava começando a ficar perigosamente parecido com “nunca”.
Ação|O aventureiro observa Aniri com mais atenção.
Aniri|Halflings vivem bastante.
Aniri|Mas não para sempre.
[NOME_DO_JOGADOR]|Então você resolveu sair da sua cidade?
Aniri|Sim.
[NOME_DO_JOGADOR]|Sem equipamento.
Aniri|Sim.
[NOME_DO_JOGADOR]|Sem dinheiro suficiente.
Aniri|Também.
Aniri|Não precisava incluir essa parte.
[NOME_DO_JOGADOR]|Só estou tentando entender o plano.
Aniri|O plano tinha algumas falhas.
SR. UILIAM|Então decidiu tornar-se ladra.
Aniri|Não.
Ação|Aniri olha diretamente para Uiliam.
Aniri|Decidi me tornar aventureira.
Ação|Ela aponta para a bolsa.
Aniri|Ser ladra foi uma decisão ruim tomada no caminho.
[NOME_DO_JOGADOR]|Uma distinção importante.
SR. UILIAM|Não tão importante quanto ela acredita.
Aniri|Provavelmente não.
SR. UILIAM|Você pretende enfrentar criaturas?
Aniri|Pretendo.
SR. UILIAM|Sabe quantos aventureiros morrem fora dessas muralhas?
Aniri|Não.
SR. UILIAM|Muitos.
Aniri|Imagino.
SR. UILIAM|E ainda pretende sair?
Aniri|Sim.
SR. UILIAM|Por quê?
Ação|Aniri demora um pouco para responder.
Aniri|Porque estou cansada de esperar que outras pessoas façam isso por mim.
Ação|Uiliam fica em silêncio.
Aniri|Passei a vida inteira protegida por muralhas que outras pessoas defenderam.
Aniri|Dormindo enquanto alguém patrulhava.
Aniri|Comendo enquanto alguém mantinha as estradas abertas.
Aniri|Esperando que aventureiros voltassem vivos para que eu pudesse continuar fingindo que o mundo terminava nos portões da cidade.
Ação|A expressão de Uiliam muda discretamente.
Aniri|Se existem monstros lá fora...
Aniri|então quero passar o que me resta fazendo alguma coisa a respeito.
Ação|Silêncio.
[NOME_DO_JOGADOR]|Você está com medo?
Ação|Aniri olha para ele.
Aniri|Muito.
[NOME_DO_JOGADOR]|Não parece.
Aniri|Anos de prática.
Ação|Pequena pausa.
Aniri|Coragem não significa não ter medo, certo?
Ação|Uiliam olha para ela.
SR. UILIAM|Não.
SR. UILIAM|Significa decidir o que fazer apesar dele.
Aniri|Então talvez eu tenha alguma.
SR. UILIAM|Ainda assim...
Ação|Ele olha para a bolsa.
SR. UILIAM|isso não apaga o que fez.
Aniri|Eu sei.
SR. UILIAM|Jhon trabalhou por tudo que colocou aí.
Aniri|Eu sei.
SR. UILIAM|E alguém que deseja proteger outras pessoas precisa começar respeitando aquilo que pertence a elas.
Ação|Aniri olha para a bolsa.
Aniri|Então devolvo tudo.
[NOME_DO_JOGADOR]|Só isso?
Aniri|Posso devolver mais do que roubei?
[NOME_DO_JOGADOR]|Quero dizer... está disposta a encarar Jhon?
Ação|Aniri fica muito menos confiante.
Aniri|Preferia enfrentar mais ratos.
SR. UILIAM|Aniri.
Aniri|Sim.
Aniri|Vou falar com ele.
SR. UILIAM|E reparar qualquer prejuízo que tenha causado.
Aniri|Também.
[NOME_DO_JOGADOR]|Sem fugir?
Aniri|Agora vocês estão apenas tornando isso doloroso.
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
				"button_text": "Se ela devolver tudo e reparar o prejuízo, merece uma chance.",
				"dialogues": _stage_2_dialogues("""
[NOME_DO_JOGADOR]|Se ela devolver tudo e reparar o prejuízo...
[NOME_DO_JOGADOR]|acho que merece uma chance.
Ação|Aniri olha para ele, surpresa.
Aniri|Você me conhece há quanto tempo?
[NOME_DO_JOGADOR]|Poucos minutos.
Aniri|E já confia em mim?
[NOME_DO_JOGADOR]|Não disse isso.
Aniri|Ah.
[NOME_DO_JOGADOR]|Disse que acho que merece a oportunidade de provar que está falando sério.
Ação|Aniri sorri discretamente.
Aniri|Gosto mais dessa resposta.
Ação|Uiliam olha para o aventureiro.
SR. UILIAM|Tem certeza?
[NOME_DO_JOGADOR]|Você acabou de passar um bom tempo me dizendo que Aviant precisa de pessoas dispostas a lutar.
Ação|Pequena pausa.
[NOME_DO_JOGADOR]|Encontramos uma.
Ação|Uiliam olha para Aniri.
SR. UILIAM|Encontramos alguém dizendo que está disposta.
Aniri|Posso provar.
SR. UILIAM|Então prove.
SR. UILIAM|Devolva o que roubou.
SR. UILIAM|Repare o prejuízo.
SR. UILIAM|E não volte a roubar daqueles que afirma querer proteger.
Aniri|Justo.
SR. UILIAM|Não é absolvição.
Aniri|Também não pedi uma.
Ação|Uiliam assente.
SR. UILIAM|Muito bem.
Aniri|Então isso significa que posso acompanhar vocês?
Ação|Uiliam olha para o aventureiro.
SR. UILIAM|Isso não cabe apenas a mim decidir.
Ação|Aniri também olha para o aventureiro.
[NOME_DO_JOGADOR]|Primeiro Jhon.
Aniri|Eu estava torcendo para que esquecessem essa parte.
""")
			},
			{
				"id": "jhon_decides",
				"button_text": "Ela roubou Jhon. Ele deve decidir o que acontece agora.",
				"dialogues": _stage_2_dialogues("""
[NOME_DO_JOGADOR]|Ela roubou Jhon.
Ação|Aniri perde o sorriso.
[NOME_DO_JOGADOR]|Não acho que nós devamos decidir simplesmente que está tudo bem.
SR. UILIAM|Concordo.
Aniri|Isso parece ruim para mim.
[NOME_DO_JOGADOR]|Você disse que devolveria tudo.
Aniri|E vou.
[NOME_DO_JOGADOR]|Então vamos começar por aí.
[NOME_DO_JOGADOR]|Jhon foi quem perdeu as ferramentas e as moedas.
[NOME_DO_JOGADOR]|Ele deve saber o que aconteceu e decidir como quer resolver isso.
Ação|Aniri respira fundo.
Aniri|Justo.
SR. UILIAM|Não cabe a nós absolvê-la de algo que não foi cometido contra nós.
Aniri|Quando vocês dois concordam, fica muito mais difícil discutir.
[NOME_DO_JOGADOR]|Pode tentar.
Aniri|Não.
Aniri|Desta vez vocês estão certos.
Ação|Ela olha para a bolsa.
Aniri|Vou devolver tudo.
SR. UILIAM|E se Jhon exigir reparação?
Aniri|Eu reparo.
[NOME_DO_JOGADOR]|E se ele quiser chamar os guardas?
Ação|Aniri fica em silêncio.
Aniri|Então...
Ação|Ela engole em seco.
Aniri|eu fui eu quem entrou aqui.
Aniri|Eu fui quem roubou.
Aniri|Não vou fingir que não sabia o risco.
Ação|O aventureiro percebe que, desta vez, ela não está brincando.
SR. UILIAM|Muito bem.
Ação|Uiliam observa Aniri.
SR. UILIAM|Se realmente deseja mudar de caminho...
SR. UILIAM|começar assumindo as consequências é uma boa primeira escolha.
Aniri|Não poderia ser uma primeira escolha menos desconfortável?
SR. UILIAM|Não.
Aniri|Imaginei.
""")
			}
		]
	}


static func get_stage_2_victory_conclusion_data() -> Dictionary:
	return {
		"dialogues": _stage_2_dialogues("""
[NOME_DO_JOGADOR]|Você realmente pretendia carregar tudo isso?
Aniri|Eu não disse que meu plano era bom.
[NOME_DO_JOGADOR]|Estou começando a perceber.
Ação|Aniri termina.
Aniri|Pronto.
Ação|Ela pega apenas os próprios pertences.
Aniri|Então...
Aniri|se eu sobreviver à conversa com o carpinteiro...
Aniri|como alguém começa a ser aventureiro?
SR. UILIAM|Normalmente não roubando uma carpintaria.
Aniri|Vocês insistem muito nesse detalhe.
[NOME_DO_JOGADOR]|É um detalhe bastante grande.
Aniri|Para você talvez.
Ação|Ela olha para o aventureiro.
Ação|Aniri fica em silêncio por um instante.
Aniri|Ponto para você.
Aniri|Sabe...
Aniri|acho que vou gostar de viajar com você.
[NOME_DO_JOGADOR]|Ninguém disse que você vai.
Aniri|Ainda.
Ação|Uiliam observa os dois.
SR. UILIAM|Primeiro, vamos falar com Jhon.
Aniri|Vocês realmente sabem acabar com um momento.
Ação|Ela começa a seguir em direção à escada.
Aniri|Muito bem.
Aniri|Vamos descobrir se minha carreira de aventureira termina antes mesmo de eu sair da carpintaria.
Ação|O aventureiro começa a acompanhá-la.
[NOME_DO_JOGADOR]|Pelo menos terá sido uma carreira memorável.
Aniri|Está aprendendo.
"""),
		"mission": {
			"id": "aniri_second_chance",
			"title": "Uma Segunda Chance",
			"description": (
				"Aniri roubou ferramentas, moedas e suprimentos para tentar iniciar sua jornada. "
				+ "Ela concordou em devolver o que pegou e enfrentar as consequências.\n"
				+ "Objetivo: leve Aniri até Jhon e ajude-a a reparar o prejuízo causado."
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
				"guard_survival_dialogues": [
					{
						"speaker_name": "Soldado Ferido",
						"text": "Graças a vocês, ainda estou vivo. Aceitem estas 10 peças de ouro. Vou acompanhá-los até a vila."
					}
				],
				"dialogues": [
					{
					},
					{
						"text": "Mas antes de prosseguirmos, permita-me saber: como devo chamá-lo?"
					},
					{
						"text": "Então és [NOME_DO_JOGADOR]. É uma honra conhecê-lo. Você me parece ser um aventureiro. O que faz por estas áreas? Aventureiros tornaram-se uma raridade em Aviant... mas temo que isso não seja mero acaso."
					},
					{
						"text": "Antes de me contar, venha. Retornemos à aldeia. Partilharemos um cálice de vinho e, com a devida calma, conversaremos sobre aquilo que está acontecendo nestas terras."
					}
				],
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
