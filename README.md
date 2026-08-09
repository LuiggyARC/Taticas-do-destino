# Táticas do Destino

**Táticas do Destino** é um protótipo de jogo tático/RPG por turnos desenvolvido em **Godot 4.6**, com foco em combate em grade, movimentação por metros, criação de personagem, progressão de nível, IA inimiga, ataques de oportunidade, interface de batalha e sistema de save.

O projeto começou como um estudo prático de Godot/GDScript e está sendo construído passo a passo, com objetivo de evoluir para um RPG tático de tabuleiro com fases, raças, classes, terreno, cobertura, vantagem de posição, habilidades, itens e progressão do jogador.

---

## Status atual

Protótipo funcional em desenvolvimento.

Já existe uma base jogável com:

- tabuleiro 2D em grade 15x15;
- herói controlável;
- inimigo com IA simples/tática;
- movimentação por distância em metros;
- combate corpo a corpo;
- ataque de oportunidade;
- criação de personagem antes do início do jogo;
- sistema de níveis com XP total acumulado;
- nível máximo 20;
- HUD de batalha horizontal, compacta e semi-transparente;
- menu inicial;
- tela de configurações;
- autosave e saves manuais;
- carregamento de saves pelo menu.

---

## Engine e configuração

- **Engine:** Godot 4.6
- **Tipo:** 2D
- **Renderização:** Mobile
- **Resolução base:** 1024x1024
- **Linguagem:** GDScript
- **Cena principal:** Menu inicial
- **Autoload:** `GameState`

---

## Estrutura atual do projeto

```text
res://
  Scene/
    main.tscn
    main.gd
    main_menu.tscn
    main_menu.gd
    character_creation.tscn
    character_creation.gd
    game_state.gd

    units/
      Hero.tscn
      hero.gd
      Enemy.tscn
      enemy.gd

  project.godot
  icon.svg
```

---

## Fluxo atual do jogo

```text
Menu Inicial
  ↓ Iniciar
Criação de Personagem
  ↓ Confirmar personagem
Combate / Stage atual
  ↓ Salvar, Abandonar ou Continuar progressão
Menu Inicial / Saves
```

O botão **Iniciar** não abre mais o combate diretamente. Agora ele leva o jogador para a tela de criação de personagem.

---

## Sistemas implementados

### 1. Cena principal do jogo

A cena principal `main.tscn` carrega o tabuleiro, o herói, o inimigo, a interface de combate e os sistemas principais.

A cena contém atualmente:

```text
Main
  Hero
  Enemy
```

O script principal é:

```text
Scene/main.gd
```

Ele centraliza a lógica de:

- criação da grade;
- movimentação;
- turnos;
- combate;
- IA inimiga;
- interface de batalha;
- save/load;
- início de stage;
- aplicação dos dados do personagem.

---

### 2. Tabuleiro 15x15

O jogo possui um tabuleiro gerado por código.

Configuração atual:

```gdscript
const TILE_SIZE := 64
const GRID_WIDTH := 15
const GRID_HEIGHT := 15
```

Cada casa possui 64x64 pixels na tela.

Visualmente, o tabuleiro é formado por quadrados verdes alternados, criando um efeito de grade. O mapa atual funciona como arena de teste para movimentação, combate e IA.

---

### 3. Sistema de escala em metros

Foi definido que cada casa do tabuleiro equivale a:

```text
1 casa = 1,5 metros
```

O movimento reto custa:

```text
1,5m
```

O movimento diagonal custa:

```text
3,0m
```

Constantes usadas:

```gdscript
const STRAIGHT_MOVE_COST := 1.5
const DIAGONAL_MOVE_COST := 3.0
```

Esse sistema permite criar personagens com deslocamentos diferentes, como 6m, 7,5m, 9m, 10,5m ou 12m por turno.

---

### 4. Criação de personagem

Foi adicionada uma tela antes do início do jogo:

```text
Scene/character_creation.tscn
Scene/character_creation.gd
```

A tela permite definir dados iniciais do personagem antes de entrar no combate.

Funcionalidades atuais:

- escolha de nome do personagem;
- escolha de classe inicial;
- prévia de atributos;
- botão para confirmar e iniciar o jogo;
- botão para voltar ao menu inicial.

Ao confirmar, os dados escolhidos são armazenados no `GameState` e aplicados ao herói no início da fase.

---

### 5. Herói

O herói foi criado como uma cena própria:

```text
Scene/units/Hero.tscn
Scene/units/hero.gd
```

O herói é representado visualmente por um quadrado azul criado por código.

Dados atuais controlados pelo herói:

```text
Nome
Classe
HP máximo
HP atual
Ataque
Movimento máximo
Movimento atual
Nível
XP total
XP necessário para o próximo nível
Nível máximo
```

Funções principais:

- atualizar posição no mundo;
- receber dano;
- morrer;
- resetar movimento;
- resetar ataque normal;
- resetar ataque de oportunidade;
- aplicar dados do personagem;
- ganhar XP;
- calcular nível pelo XP total;
- subir de nível;
- calcular progresso de XP no nível atual.

---

### 6. Sistema de níveis

Foi implementado um sistema de progressão baseado em **XP total acumulado**.

Regras atuais:

```text
Nível máximo: 20
Nível 1 → 2: 1000 XP total
A partir daí, cada faixa de nível multiplica a exigência anterior por 1.5
```

Exemplo:

```text
Nível 1 → 2: +1000 XP | total 1000
Nível 2 → 3: +1500 XP | total 2500
Nível 3 → 4: +2250 XP | total 4750
Nível 4 → 5: +3375 XP | total 8125
Nível 5 → 6: +5063 XP | total 13188
```

O sistema guarda:

```text
level
total_xp
xp_to_next_level
max_level
```

A HUD mostra o progresso do nível atual, por exemplo:

```text
Nv 2 | XP 0/1500
```

Ao subir de nível, atualmente o herói recebe aumento básico de atributos:

```text
+10 HP máximo
+2 ataque
+1,5m de movimento a cada 3 níveis
```

Esses valores são provisórios e poderão ser ajustados quando o sistema completo de raças e classes for implementado.

---

### 7. Inimigo

O inimigo foi criado como uma cena própria:

```text
Scene/units/Enemy.tscn
Scene/units/enemy.gd
```

Características atuais:

```text
HP máximo: 50
Dano: 10
Movimento máximo: 6m
Posição inicial: 10,7
```

O inimigo é representado visualmente por um quadrado vermelho criado por código.

Funções principais:

- atualizar posição no mundo;
- receber dano;
- morrer;
- resetar movimento;
- controlar ataque de oportunidade.

---

### 8. Movimento do herói

O jogador pode mover o herói clicando nas casas do tabuleiro.

O sistema calcula:

- casa clicada;
- distância entre posição atual e destino;
- custo em metros;
- se o movimento está dentro do deslocamento restante;
- se a casa está ocupada pelo inimigo.

O movimento consome deslocamento restante.

Exemplo:

```text
Movimento inicial: 9m
Andou 1 casa reta: -1,5m
Restante: 7,5m

Andou 1 casa diagonal: -3m
Restante: 4,5m
```

O jogador pode continuar andando enquanto ainda tiver deslocamento disponível.

---

### 9. Área de movimentação visível

Foi criada uma camada visual para mostrar as casas alcançáveis pelo personagem.

As casas possíveis aparecem destacadas em azul claro.

A área muda automaticamente conforme o personagem gasta movimento.

Exemplo:

```text
Herói com 9m disponíveis → área maior.
Herói com 3m restantes → área menor.
Herói com 0m → nenhuma casa de movimento disponível.
```

---

### 10. HUD de batalha

A interface de combate foi reformulada para uma HUD retangular horizontal, compacta e semi-transparente, posicionada próxima ao rodapé da tela.

A HUD mostra:

- nome do personagem;
- classe atual;
- nível;
- XP do nível atual;
- vida atual e máxima;
- movimento atual e máximo;
- turno atual;
- HP do inimigo;
- botões de ação.

Botões atuais:

```text
Ataque
Magia
Itens
Terminar Turno
Salvar
Sair
```

Estado atual dos botões:

```text
Ataque: funcional
Magia: placeholder/desativado
Itens: placeholder/desativado
Terminar Turno: funcional
Salvar: funcional
Sair: funcional, com confirmação
```

A HUD substituiu a interface vertical anterior e ocupa menos espaço visual no mapa.

---

### 11. Sistema de turnos

O jogo usa um `enum` para controlar o turno atual.

```gdscript
enum TurnState {
  HERO_TURN,
  ENEMY_TURN
}
```

Fluxo atual:

```text
Turno do Herói
  jogador move
  jogador ataca
  jogador encerra turno

Turno do Inimigo
  inimigo avalia posição
  inimigo move
  inimigo ataca se possível

Volta para o Herói
```

Ao iniciar um novo turno do herói:

- movimento é restaurado;
- ataque normal é restaurado;
- ataque de oportunidade é restaurado;
- área de movimento é recalculada.

---

### 12. Combate básico

O herói pode atacar o inimigo se estiver adjacente.

O ataque considera distância por grade:

```text
Alcance corpo a corpo = 1 casa
```

O ataque pode atingir:

- horizontal;
- vertical;
- diagonal.

Cada personagem só pode fazer um ataque normal por turno.

Quando o inimigo é derrotado, o herói recebe XP. Atualmente, para teste do sistema de nível, o inimigo concede:

```text
1000 XP
```

Esse valor será balanceado futuramente por tipo de inimigo, desafio ou stage.

---

### 13. Ataque de oportunidade

Foi implementada a regra de ataque de oportunidade.

Regra atual:

```text
Se um personagem estava dentro da área de ataque de outro personagem
e se move para fora dessa área,
ele recebe automaticamente um ataque de oportunidade.
```

Funciona nos dois sentidos:

```text
Herói sai da zona de ameaça do inimigo → inimigo ataca automaticamente.
Inimigo sai da zona de ameaça do herói → herói ataca automaticamente.
```

Cada personagem só pode realizar um ataque de oportunidade por turno.

---

### 14. IA inimiga

Foi criada uma IA inimiga baseada em pontuação.

A IA avalia todas as casas possíveis e escolhe a melhor posição.

Critérios atuais:

- priorizar ficar em alcance de ataque;
- aproximar-se do herói;
- gastar menos movimento quando possível;
- evitar ficar na mesma casa do herói;
- preparar espaço para pontuação futura de terreno.

A função de terreno ainda está preparada para expansão:

```text
terreno alto: +80
cobertura: +60
terreno difícil: -40
lava/veneno: -200
posição exposta: -30
```

Esses valores ainda são planejamento, mas a estrutura já existe para evoluir a IA.

---

### 15. Menu inicial

Foi criada uma tela inicial em:

```text
Scene/main_menu.tscn
Scene/main_menu.gd
```

Opções atuais:

```text
Iniciar
Continuar
Configurações
Sair
```

Funções atuais:

- **Iniciar:** abre a criação de personagem;
- **Continuar:** abre a tela/lista de saves;
- **Configurações:** abre tela de configurações;
- **Sair:** fecha o jogo.

---

### 16. Configurações

O botão **Configurações** abre uma tela própria dentro do menu inicial.

Opções implementadas:

- volume geral do jogo;
- volume dos efeitos;
- idioma;
- créditos;
- salvar configurações;
- voltar.

As configurações são salvas em:

```text
user://settings.json
```

O volume geral usa o bus `Master`.

O volume dos efeitos usa o bus `SFX`. Caso o bus `SFX` não exista, o jogo cria esse bus em tempo de execução.

---

### 17. Sistema global GameState

Foi criado um Autoload chamado:

```text
GameState
```

Arquivo:

```text
Scene/game_state.gd
```

Função atual:

- guardar se o jogo deve carregar save;
- guardar qual arquivo de save foi escolhido;
- guardar o stage selecionado;
- guardar dados do personagem criado;
- guardar nível e XP;
- guardar presets atuais do herói.

Dados atuais esperados:

```gdscript
extends Node

var should_load_save: bool = false
var selected_save_path: String = ""
var selected_stage: int = 1

var player_name: String = "Herói"
var player_class: String = "Guerreiro"

var hero_level: int = 1
var hero_total_xp: int = 0
var hero_xp_to_next_level: int = 1000
var hero_max_level: int = 20

var hero_max_hp: int = 100
var hero_attack_power: int = 20
var hero_max_movement_meters: float = 9.0
```

---

### 18. Sistema de stages

O jogo já possui estrutura para iniciar fases.

Função central:

```gdscript
start_stage(stage_number)
```

A lógica atual reinicia a fase com presets salvos, em vez de carregar o combate exatamente do ponto onde parou.

Modelo escolhido:

```text
Se o jogador sair no meio da fase 5,
ao continuar ele volta para o início da fase 5,
com os presets que tinha salvo.
```

Atualmente existem presets para:

```text
Stage 1
Stage 2 - estrutura inicial de exemplo
```

---

### 19. Sistema de save

O sistema de save foi dividido em dois tipos:

```text
AutoSave
Save Manual
```

#### AutoSave

Criado ao abandonar a partida.

Caminho:

```text
user://autosave.json
```

Uso:

```text
Continuar rapidamente a partir do último progresso salvo automaticamente.
```

#### Save Manual

Criado pelo botão **Salvar**.

Caminho:

```text
user://manual_saves/
```

Formato dos arquivos:

```text
save_stage_1_YYYY-MM-DD_HH-MM-SS.json
```

Uso:

```text
Permitir que o jogador tenha saves antigos separados.
```

---

### 20. Tela de seleção de saves

O botão **Continuar** abre uma tela com a lista de saves disponíveis.

A lista pode mostrar:

```text
AutoSave - Stage X
Manual - Stage X - nome_do_arquivo.json
```

Ao escolher um save:

- o caminho do arquivo é salvo em `GameState.selected_save_path`;
- o jogo abre `main.tscn`;
- o stage salvo é carregado;
- a fase inicia do começo com os presets salvos.

---

### 21. Botão Sair/Abandonar com confirmação

O botão de saída da batalha abre um popup de confirmação.

Fluxo:

```text
Jogador clica em Sair/Abandonar
  aparece popup: deseja salvar e voltar ao menu?

Não
  fecha popup e permanece no jogo

Sim
  cria/atualiza autosave
  volta para o menu inicial
```

---

## Modelo de save atual

O save não grava o estado exato do combate.

Ele grava o progresso principal do personagem e da fase:

```json
{
  "current_stage": 1,
  "player_presets": {
    "player_name": "Herói",
    "player_class": "Guerreiro",
    "hero_level": 1,
    "hero_total_xp": 0,
    "hero_xp_to_next_level": 1000,
    "hero_max_hp": 100,
    "hero_attack_power": 20,
    "hero_max_movement_meters": 9.0
  }
}
```

Esse modelo foi escolhido para evitar abuso de save no meio da luta e manter o design mais próximo de fases táticas.

---

## Como jogar o protótipo atual

1. Abra o projeto no Godot.
2. Execute a cena principal pelo botão Play.
3. No menu, clique em **Iniciar**.
4. Crie o personagem.
5. Confirme para começar o jogo.
6. Clique nas casas azuis para mover o herói.
7. Aproxime-se do inimigo.
8. Clique em **Ataque** quando estiver adjacente.
9. Clique em **Terminar Turno** para passar a vez.
10. O inimigo executará sua IA.
11. Use **Salvar** para criar um save manual.
12. Use **Sair/Abandonar** para gerar autosave e voltar ao menu.
13. Use **Continuar** para escolher AutoSave ou saves manuais.

---

## Regras atuais de movimentação

```text
Casa reta: 1,5m
Casa diagonal: 3,0m
Herói: conforme personagem criado/preset atual
Inimigo: 6m por turno
```

A movimentação é consumida a cada clique.

---

## Regras atuais de combate

```text
Ataque corpo a corpo: alcance 1 casa
Ataque normal: 1 vez por turno
Ataque de oportunidade: 1 vez por turno
XP por inimigo derrotado: 1000 XP temporário para teste
```

---

## Regras atuais de nível

```text
Nível inicial: 1
Nível máximo: 20
XP total para nível 2: 1000
Multiplicador de exigência por nível: 1.5
```

Progressão inicial:

```text
Nível 1 → 2: +1000 XP | total 1000
Nível 2 → 3: +1500 XP | total 2500
Nível 3 → 4: +2250 XP | total 4750
Nível 4 → 5: +3375 XP | total 8125
```

---

## Próximos passos planejados

### Raças e classes

- implementar raças básicas;
- aplicar bônus raciais;
- criar classes básicas completas;
- definir dado de vida por classe;
- definir deslocamento por raça;
- definir vantagens raciais;
- criar atributos principais: Força, Destreza, Constituição, Inteligência, Sabedoria e Carisma.

### Sistemas de gameplay

- criar múltiplos inimigos;
- implementar alcance diferente por arma;
- implementar magias;
- implementar itens;
- implementar CA real;
- criar tela de vitória e derrota;
- criar mudança real de stages.

### Terreno e estratégia

- terreno alto com vantagem de ataque;
- cobertura parcial e total;
- terreno difícil;
- obstáculos;
- linha de visão;
- áreas perigosas, como fogo, veneno ou armadilhas.

### IA

- IA agressiva;
- IA defensiva;
- IA que busca cobertura;
- IA que busca terreno alto;
- IA que foge com pouca vida;
- IA de chefe;
- IA que trabalha em grupo.

### Interface

- melhorar visual da HUD;
- adicionar retrato do personagem;
- criar tooltip de habilidades;
- criar menu de magia;
- criar menu de itens;
- criar tela de ficha do personagem;
- melhorar tela de criação de personagem.

### Progressão

- balancear XP por inimigo;
- criar recompensas por stage;
- implementar evolução por classe;
- criar talentos;
- criar perícias;
- salvar raça, classe, atributos e habilidades.

---

## Créditos

Desenvolvimento:

```text
Luiggy Alberto
```

Engine:

```text
Godot 4.6
```

Projeto criado como estudo prático de desenvolvimento de jogos táticos, GDScript, sistemas de RPG e organização de projeto em GitHub.
