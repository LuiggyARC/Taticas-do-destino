# Táticas do Destino

**Táticas do Destino** é um protótipo de jogo tático/RPG por turno desenvolvido em **Godot 4.6**, com foco em combate em grade, movimentação por metros, sistema de turnos, IA inimiga, ataques de oportunidade, menu inicial e sistema de save.

O projeto começou como um estudo prático de Godot/GDScript e está sendo construído passo a passo, com objetivo de evoluir para um RPG tático de tabuleiro com fases, terreno, cobertura, vantagem de posição e progressão do jogador.

---

## Status atual

Protótipo funcional em desenvolvimento.

Já existe uma base jogável com:

- tabuleiro 2D em grade;
- herói controlável;
- inimigo com IA simples/tática;
- movimentação por distância em metros;
- combate corpo a corpo;
- ataque de oportunidade;
- interface básica de combate;
- menu inicial;
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

## Sistemas implementados

### 1. Cena principal do jogo

Foi criada uma cena principal chamada `main.tscn`, responsável por carregar o tabuleiro, o herói, o inimigo, a interface de combate e os sistemas principais.

A cena principal contém atualmente:

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
- interface;
- save/load;
- início de stage.

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

Visualmente, o tabuleiro é formado por quadrados verdes alternados, criando um efeito de grade.

O mapa atual representa uma arena simples para testes de movimentação e combate.

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

Esse sistema permite criar personagens com deslocamentos diferentes, como:

```text
Guerreiro: 9m
Mago: 6m
Inimigo básico: 6m
```

---

### 4. Herói

O herói foi criado como uma cena própria:

```text
Scene/units/Hero.tscn
Scene/units/hero.gd
```

Características atuais:

```text
HP máximo: 100
Dano: 20
Movimento máximo: 9m
Posição inicial: 7,7
```

O herói é representado visualmente por um quadrado azul criado por código.

Funções principais do herói:

- atualizar posição no mundo;
- receber dano;
- morrer;
- resetar movimento;
- resetar ataque normal;
- resetar ataque de oportunidade.

---

### 5. Inimigo

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

Funções principais do inimigo:

- atualizar posição no mundo;
- receber dano;
- morrer;
- resetar movimento;
- controlar ataque de oportunidade.

---

### 6. Movimento do herói

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

### 7. Área de movimentação visível

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

### 8. Interface de combate

Foi criada uma interface básica em `CanvasLayer`, gerada por código.

A interface mostra:

- turno atual;
- HP do herói;
- movimento restante do herói;
- HP do inimigo;
- botão Atacar;
- botão Terminar Turno;
- botão Salvar;
- botão Abandonar.

Botões atuais:

```text
Atacar
Terminar Turno
Salvar
Abandonar
```

---

### 9. Sistema de turnos

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

### 10. Combate básico

O herói pode atacar o inimigo se estiver adjacente.

O ataque considera distância por grade:

```text
Alcance corpo a corpo = 1 casa
```

O ataque pode atingir:

- horizontal;
- vertical;
- diagonal.

O herói causa atualmente:

```text
20 de dano
```

O inimigo causa atualmente:

```text
10 de dano
```

Cada personagem só pode fazer um ataque normal por turno.

---

### 11. Ataque de oportunidade

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

### 12. IA inimiga

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

### 13. Menu inicial

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

- **Iniciar:** começa um jogo novo;
- **Continuar:** abre a tela/lista de saves;
- **Configurações:** ainda não implementado;
- **Sair:** fecha o jogo.

---

### 14. Sistema global GameState

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
- guardar o stage selecionado.

Estrutura esperada:

```gdscript
extends Node

var should_load_save: bool = false
var selected_save_path: String = ""
var selected_stage: int = 1
```

---

### 15. Sistema de stages

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

### 16. Sistema de save

O sistema de save foi dividido em dois tipos:

```text
AutoSave
Save Manual
```

#### AutoSave

Criado ao abandonar a partida ou fechar o jogo.

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

### 17. Tela de seleção de saves

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

### 18. Botão Abandonar com confirmação

O botão **Abandonar** agora abre um popup de confirmação.

Fluxo:

```text
Jogador clica em Abandonar
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

Ele grava apenas:

```json
{
  "current_stage": 1,
  "player_presets": {
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
4. Clique nas casas azuis para mover o herói.
5. Aproxime-se do inimigo.
6. Clique em **Atacar** quando estiver adjacente.
7. Clique em **Terminar Turno** para passar a vez.
8. O inimigo executará sua IA.
9. Use **Salvar** para criar um save manual.
10. Use **Abandonar** para gerar autosave e voltar ao menu.
11. Use **Continuar** para escolher AutoSave ou saves manuais.

---

## Regras atuais de movimentação

```text
Casa reta: 1,5m
Casa diagonal: 3,0m
Herói: 9m por turno
Inimigo: 6m por turno
```

A movimentação é consumida a cada clique.

---

## Regras atuais de combate

```text
Ataque corpo a corpo: alcance 1 casa
Ataque normal: 1 vez por turno
Ataque de oportunidade: 1 vez por turno
Herói: 20 de dano
Inimigo: 10 de dano
```

---

## Próximos passos planejados

### Sistemas de gameplay

- criar múltiplos inimigos;
- criar classes de herói;
- criar arqueiro, mago e guerreiro;
- implementar alcance diferente por arma;
- implementar magias;
- implementar itens;
- implementar XP e progressão;
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

- melhorar HUD;
- criar tela de configurações;
- criar tela de seleção de fase;
- criar tela de seleção de personagem;
- criar tela de carregamento manual mais bonita;
- mostrar dano flutuante;
- mostrar preview do custo de movimento.

### Arte e apresentação

- substituir quadrados por sprites;
- criar tiles de cenário;
- adicionar animações;
- adicionar efeitos de ataque;
- adicionar música e efeitos sonoros;
- criar identidade visual do menu.

---

## Objetivo do projeto

O objetivo é evoluir este protótipo para um RPG tático por turnos inspirado em jogos de tabuleiro, onde posicionamento, terreno, cobertura, vantagem de altura e gerenciamento de ações sejam importantes para vencer.

Este projeto também serve como prática de:

- Godot;
- GDScript;
- lógica de jogos por turno;
- sistemas de movimentação em grade;
- IA baseada em pontuação;
- organização de projeto;
- versionamento com Git/GitHub.

---

## Repositório

Projeto mantido por **LuiggyARC**.

Repositório:

```text
https://github.com/LuiggyARC/Taticas-do-destino
```
