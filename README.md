# Táticas do Destino

**Táticas do Destino** é um protótipo de RPG tático por turnos desenvolvido em **Godot 4.6**, com foco em combate em grade, movimentação por metros, criação de personagem, raças, classes, armas, CA, testes de resistência, habilidades de classe, IA inimiga, ataques de oportunidade, HUD de batalha e sistema de save.

O projeto começou como um estudo prático de **Godot/GDScript** e está sendo desenvolvido passo a passo, com o objetivo de evoluir para um RPG tático inspirado em regras de RPG de mesa, com progressão de personagem, fases, inimigos, habilidades, equipamentos, magias, terreno, cobertura e decisões táticas.

---

## Status atual

Protótipo funcional em desenvolvimento.

A base atual já possui:

- tabuleiro 2D em grade 15x15;
- escala de distância em metros;
- movimentação reta e diagonal com custos diferentes;
- herói controlável;
- inimigo com IA tática básica;
- sistema de turnos;
- ataques corpo a corpo e à distância;
- sistema de armas com dados de dano, alcance, crítico e recarga;
- classe de armadura normal, de toque e desprevenida;
- testes de resistência: Fortitude, Reflexos e Vontade;
- bônus base de ataque por tipo de classe;
- criação de personagem com raça e classe;
- seleção de bônus humano;
- rolagem ou valor fixo de vida por classe;
- sistema de XP e níveis até o nível 20;
- habilidades iniciais de classe;
- fúria do Bárbaro com duração;
- redução de dano do Bárbaro;
- Destruir o Mal do Paladino ativado por botão;
- bônus de Sabedoria na CA para Monge;
- ataque furtivo do Ladino em condição vulnerável temporária;
- ataque de oportunidade;
- autosave e saves manuais;
- menu inicial;
- tela de configurações;
- HUD horizontal de batalha.

---

## Engine e configuração

- **Engine:** Godot 4.6
- **Tipo:** 2D
- **Renderização:** Mobile
- **Resolução base:** 1024x1024
- **Linguagem:** GDScript
- **Cena principal:** menu inicial
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
  ↓ Escolha de nome, raça, classe e vida
Combate / Stage atual
  ↓ Salvar, abandonar ou continuar progressão
Menu Inicial / Saves
```

O botão **Iniciar** leva para a tela de criação de personagem. Após confirmar a criação, os dados são salvos no `GameState` e aplicados ao herói no início da fase.

---

## Sistema de tabuleiro

O jogo usa um tabuleiro 2D gerado por código.

Configuração atual:

```gdscript
const TILE_SIZE := 64
const GRID_WIDTH := 15
const GRID_HEIGHT := 15
```

Cada casa possui 64x64 pixels e representa uma posição tática no campo de batalha.

---

## Escala de movimento

A escala adotada é:

```text
1 casa = 1,5 metros
```

Custos atuais:

```text
Movimento reto: 1,5m
Movimento diagonal: 3,0m
```

Constantes usadas:

```gdscript
const STRAIGHT_MOVE_COST := 1.5
const DIAGONAL_MOVE_COST := 3.0
```

Esse sistema permite que raças e classes tenham deslocamentos diferentes, como 6m, 9m ou 12m por turno.

---

## Criação de personagem

A tela de criação fica em:

```text
Scene/character_creation.tscn
Scene/character_creation.gd
```

Ela permite definir:

- nome do personagem;
- raça;
- bônus humano de atributo;
- classe;
- modo de vida por nível;
- rolagem de vida quando aplicável;
- prévia da ficha antes de iniciar.

A tela usa `ScrollContainer`, pois a ficha de personagem cresceu com a adição de raças, classes, atributos, vantagens e habilidades.

---

## Atributos do personagem

Os personagens usam seis atributos principais:

```text
FOR - Força
DES - Destreza
CON - Constituição
SAB - Sabedoria
INT - Inteligência
CAR - Carisma
```

O modificador é calculado com base no valor do atributo:

```gdscript
func get_attribute_modifier(attribute_value: int) -> int:
    return int(floor((attribute_value - 10) / 2.0))
```

Uso atual dos atributos:

- **Força:** ataque e dano corpo a corpo;
- **Destreza:** CA, Reflexos e ataques à distância;
- **Constituição:** HP inicial, vida por nível e Fortitude;
- **Sabedoria:** Vontade, magias divinas e bônus de CA do Monge;
- **Inteligência:** magias de Mago;
- **Carisma:** magias de Bardo/Feiticeiro e habilidades do Paladino.

---

## Raças implementadas

As raças são escolhidas na criação de personagem e alteram atributos, tamanho, deslocamento e vantagens raciais.

### Humano

- **Atributos:** +2 em um atributo à escolha.
- **Tamanho:** Médio.
- **Deslocamento:** 9m.
- **Classe favorecida:** qualquer.
- **Vantagens:** talento extra no 1º nível e pontos de perícia adicionais.

### Anão

- **Atributos:** +2 Constituição.
- **Tamanho:** Médio.
- **Deslocamento:** 6m.
- **Classe favorecida:** Guerreiro.
- **Vantagens:** visão no escuro, ligação com pedras, bônus contra venenos e magias, bônus contra orcs/goblinoides e +4 CA contra gigantes.
- **Observação:** armaduras pesadas não reduzem seu deslocamento.

### Elfo

- **Atributos:** +2 Destreza.
- **Tamanho:** Médio.
- **Deslocamento:** 9m.
- **Classe favorecida:** Mago ou Ranger.
- **Vantagens:** imunidade a sono, visão no escuro, proficiência com espada longa, rapieira, arco longo e arco curto, +2 em Ouvir, Procurar e Observar.

### Gnomo

- **Atributos:** +2 Constituição.
- **Tamanho:** Pequeno.
- **Deslocamento:** 6m.
- **Classe favorecida:** Bardo.
- **Vantagens:** visão na penumbra, bônus contra kobolds/goblinoides, +4 CA contra gigantes, +2 em Ouvir e habilidades mágicas inatas se tiver Carisma 10+.
- **Regra ativa:** tamanho pequeno aplica `size_modifier = +1`, afetando CA e ataque.

### Halfling

- **Atributos:** +2 Destreza.
- **Tamanho:** Pequeno.
- **Deslocamento:** 6m.
- **Classe favorecida:** Ladino.
- **Vantagens:** +2 em Escalar, Saltar e Mover-se Silenciosamente, +1 em testes de resistência, +2 adicional contra medo e +1 em ataques com armas à distância.
- **Regra ativa:** tamanho pequeno aplica `size_modifier = +1`, afetando CA e ataque.

### Meio-Elfo

- **Atributos:** +2 Inteligência.
- **Tamanho:** Médio.
- **Deslocamento:** 9m.
- **Classe favorecida:** qualquer.
- **Vantagens:** imunidade a sono, visão na penumbra, +1 em Ouvir, Procurar e Observar, +2 em Diplomacia e Obter Informação, sangue élfico.

### Meio-Orc

- **Atributos:** +2 Força.
- **Tamanho:** Médio.
- **Deslocamento:** 9m.
- **Classe favorecida:** Bárbaro.
- **Vantagens:** visão no escuro e sangue orc.

---

## Classes implementadas

As classes definem dado de vida, HP por nível, foco, bônus base de ataque, resistências, atributo mágico e habilidades principais.

O jogador pode escolher entre:

```text
Bárbaro
Bardo
Clérigo
Druida
Feiticeiro
Guerreiro
Ladino
Mago
Monge
Paladino
Ranger
```

---

## Progressão de vida por classe

Na criação do personagem, o jogador escolhe como a vida será tratada por classe:

```text
Modo padrão: valor fixo da classe + modificador de CON
Modo rolagem: rola o dado da classe + modificador de CON
```

Exemplo com Guerreiro:

```text
Padrão: +6 por nível
Rolagem: 1d10 por nível
```

No nível inicial, a vida considera o dado cheio ou a rolagem escolhida, somando o modificador de Constituição.

---

## Classes detalhadas

### Bárbaro

- **Dado de Vida:** d12 ou +8 por nível.
- **BBA:** alto.
- **Fortitude:** boa.
- **Reflexos:** ruim, com +2 extra definido no projeto.
- **Vontade:** ruim.
- **Foco:** combate corpo a corpo feroz.
- **Habilidades:** Fúria, +3m de deslocamento, +2 Reflexos, Redução de Dano 5 no nível 10 e Redução de Dano 10 no nível 15.
- **Regra ativa:** Fúria com duração e Redução de Dano.

### Bardo

- **Dado de Vida:** d6 ou +4 por nível.
- **BBA:** médio.
- **Fortitude:** ruim.
- **Reflexos:** bons.
- **Vontade:** boa.
- **Atributo mágico:** Carisma.
- **Foco:** suporte, magia arcana e perícias variadas.
- **Habilidades:** Música Bárdica, Conhecimento Bárdico e conjuração arcana espontânea.

### Clérigo

- **Dado de Vida:** d8 ou +5 por nível.
- **BBA:** médio.
- **Fortitude:** boa.
- **Reflexos:** ruim.
- **Vontade:** boa.
- **Atributo mágico:** Sabedoria.
- **Foco:** cura, suporte divino e combate durável.
- **Habilidades:** conjuração divina, cura, Expulsar/Fascinar Mortos-Vivos e magias adicionais por divindade.

### Druida

- **Dado de Vida:** d8 ou +5 por nível.
- **BBA:** médio.
- **Fortitude:** boa.
- **Reflexos:** ruim.
- **Vontade:** boa.
- **Atributo mágico:** Sabedoria.
- **Foco:** magia da natureza, controle de terreno e transformação.
- **Habilidades:** magia divina da natureza, Companheiro Animal e Forma Selvagem.

### Feiticeiro

- **Dado de Vida:** d4 ou +3 por nível.
- **BBA:** baixo.
- **Fortitude:** ruim.
- **Reflexos:** ruim.
- **Vontade:** boa.
- **Atributo mágico:** Carisma.
- **Foco:** poder mágico bruto e instintivo.
- **Habilidades:** conjuração arcana espontânea, muitas conjurações sem preparo e Familiar.

### Guerreiro

- **Dado de Vida:** d10 ou +6 por nível.
- **BBA:** alto.
- **Fortitude:** boa.
- **Reflexos:** ruim.
- **Vontade:** ruim.
- **Foco:** armas e táticas militares.
- **Habilidades:** talentos adicionais no 1º nível, 2º nível e a cada dois níveis subsequentes.

### Ladino

- **Dado de Vida:** d6 ou +4 por nível.
- **BBA:** médio.
- **Fortitude:** ruim.
- **Reflexos:** bons.
- **Vontade:** ruim.
- **Foco:** furtividade, perícias e dano em pontos fracos.
- **Habilidades:** Ataque Furtivo, Encontrar Armadilhas, Evasão, Esquiva Sobrenatural e grande quantidade de perícias.
- **Regra ativa:** Ataque Furtivo temporariamente aplicado contra alvo vulnerável.

### Mago

- **Dado de Vida:** d4 ou +3 por nível.
- **BBA:** baixo.
- **Fortitude:** ruim.
- **Reflexos:** ruim.
- **Vontade:** boa.
- **Atributo mágico:** Inteligência.
- **Foco:** utilidade arcana, controle e estudo mágico.
- **Habilidades:** conjuração arcana preparada, grimório, grande variedade de magias, talento de metamágica inicial e Familiar.

### Monge

- **Dado de Vida:** d8 ou +6 por nível.
- **BBA:** médio.
- **Fortitude:** boa.
- **Reflexos:** bons.
- **Vontade:** boa.
- **Foco:** combate desarmado, mobilidade e defesas místicas.
- **Habilidades:** dano desarmado progressivo, Rajada de Golpes, Sabedoria na CA, Evasão, imunidades progressivas e movimento rápido.
- **Regras ativas:** bônus de Sabedoria na CA e progressão de dano desarmado.

### Paladino

- **Dado de Vida:** d10 ou +6 por nível.
- **BBA:** alto.
- **Fortitude:** boa.
- **Reflexos:** ruim.
- **Vontade:** ruim.
- **Atributo mágico:** Sabedoria.
- **Restrição:** Leal e Bom.
- **Foco:** cavaleiro sagrado, liderança e defesa contra o mal.
- **Habilidades:** Destruir o Mal, Cura pelas Mãos, Graça Divina, Montaria Especial no nível 5 e magias divinas em níveis altos.
- **Regras ativas:** Graça Divina passiva e Destruir o Mal ativado pelo botão de habilidade.

### Ranger

- **Dado de Vida:** d8 ou +5 por nível.
- **BBA:** alto.
- **Fortitude:** boa.
- **Reflexos:** bons.
- **Vontade:** ruim.
- **Atributo mágico:** Sabedoria.
- **Foco:** sobrevivência, rastreamento e combate especializado.
- **Habilidades:** Inimigo Predileto, Estilos de Combate nos níveis 2, 6 e 11, Companheiro Animal e magias divinas limitadas.

---

## Classe de Armadura e testes de resistência

O projeto já possui cálculo de:

```text
CA normal
CA de toque
CA desprevenido
Fortitude
Reflexos
Vontade
```

### CA normal

```text
10 + bônus de armadura + bônus de escudo + modificador de DES + modificador de tamanho + esquiva + deflexão + armadura natural + outros
```

### CA de toque

Ignora armadura física, escudo e armadura natural.

### CA desprevenido

Remove bônus de Destreza e bônus de Esquiva.

### Testes de resistência

```text
1d20 + bônus base da classe + modificador de atributo + bônus mágicos/itens
```

Usos atuais:

- **Fortitude:** Constituição;
- **Reflexos:** Destreza;
- **Vontade:** Sabedoria.

Paladino também soma Carisma nos testes de resistência por causa da Graça Divina.

---

## Sistema de armas

O sistema de armas define:

- tipo de ataque;
- categoria;
- dado de dano;
- quantidade de dados;
- alcance em metros;
- margem de crítico;
- multiplicador crítico;
- uso de uma ou duas mãos;
- necessidade de recarga.

### Armas corpo a corpo

| Arma | Dano | Alcance | Crítico | Observação |
|---|---:|---:|---:|---|
| Soco | 1d3 | 1,5m | 20/x2 | Monge aumenta o dano |
| Adaga | 1d4 | 1,5m | 20/x2 | Corpo a corpo leve |
| Espada Curta | 1d6 | 1,5m | 20/x2 | Espada leve |
| Espada Longa | 1d8 | 1,5m | 20/x2 | Uma mão |
| Espada Bastarda | 1d10 | 1,5m | 20/x2 | Duas mãos |
| Cimitarra | 1d6 | 1,5m | 18-20/x2 | Crítico expandido |
| Martelo de Combate | 1d6 | 1,5m | 20/x2 | Uma mão |
| Martelo de Guerra | 1d10 | 1,5m | 20/x2 | Duas mãos |
| Lança Longa | 1d8 | 3m | 20/x2 | Alcance maior |

### Armas à distância

| Arma | Dano | Alcance | Crítico | Observação |
|---|---:|---:|---:|---|
| Arco Curto | 1d6 | 12m | 20/x2 | Arco |
| Arco Longo | 1d8 | 18m | 20/x2 | Arco |
| Arco Composto | 1d10 | 24m | 20/x2 | Arco |
| Besta Pequena | 1d8 | 9m | 20/x2 | Requer recarga |
| Besta Grande | 1d10 | 12m | 20/x2 | Requer recarga |
| Funda | 1d6 | 12m | 20/x2 | Arma simples |

Regras atuais:

- ataque corpo a corpo usa BBA + Força + tamanho;
- ataque à distância usa BBA + Destreza + tamanho;
- dano corpo a corpo soma Força;
- armas de duas mãos somam 1,5x o modificador de Força;
- ataques à distância não somam Força por enquanto;
- crítico padrão ocorre com 20 natural;
- Cimitarra ameaça crítico entre 18 e 20;
- crítico multiplica o dano por 2;
- bestas exigem recarga e gastam o movimento do turno.

---

## Ataque desarmado e Monge

Ataque desarmado comum:

```text
Soco comum = 1d3
```

Monge usando Soco possui progressão especial:

| Nível | Dano desarmado |
|---:|---:|
| 1-3 | 1d6 |
| 4-7 | 1d8 |
| 8-11 | 1d10 |
| 12-15 | 2d6 |
| 16-19 | 2d8 |
| 20 | 2d10 |

---

## Sistema de combate

O ataque do herói considera:

```text
1d20 + bônus de ataque da arma
```

O ataque acerta se:

```text
resultado total >= CA do alvo
```

Regras atuais:

- 1 natural é falha crítica;
- 20 natural sempre acerta;
- crítico multiplica dano por 2;
- cada personagem faz um ataque normal por turno;
- ataques respeitam o alcance da arma;
- bestas precisam recarregar;
- inimigos também usam armas.

---

## Habilidades de classe ativas/passivas

### Bárbaro - Fúria

A Fúria é ativada pelo botão **Habilidade**.

Efeitos atuais:

```text
+4 FOR
+4 CON
+2 Vontade
-2 CA
HP temporário baseado no nível
Duração por turnos
```

Quando a Fúria acaba:

- os bônus são removidos;
- a CA é restaurada;
- o HP máximo temporário é removido;
- se o HP cair para 0 ou menos, o personagem morre.

### Bárbaro - Redução de Dano

Regra atual:

```text
Nível 1-9: RD 0
Nível 10-14: RD 5
Nível 15-20: RD 10
```

A RD reduz o dano recebido no `take_damage()`.

### Paladino - Destruir o Mal

O botão **Habilidade** prepara o próximo ataque com Destruir o Mal.

Efeitos:

```text
+ modificador de Carisma no ataque
+ nível do Paladino no dano
```

Após o próximo ataque, acertando ou errando, o uso é consumido.

### Paladino - Graça Divina

Passiva já aplicada:

```text
Fortitude + CAR
Reflexos + CAR
Vontade + CAR
```

Apenas modificadores positivos são considerados.

### Monge - Sabedoria na CA

Passiva já aplicada:

```text
CA += modificador de Sabedoria
CA de toque += modificador de Sabedoria
```

### Ladino - Ataque Furtivo

O Ladino possui ataque furtivo implementado de forma provisória.

Regra atual temporária:

```text
Se o inimigo estiver vulnerável, o Ladino soma dano extra de Ataque Furtivo.
```

Progressão atual:

```text
Nível 1: 1d6
Nível 3: 2d6
Nível 5: 3d6
Nível 7: 4d6
```

A regra definitiva ainda será substituída por flanqueamento, invisibilidade, desprevenido, imobilizado ou perda de DES na CA.

---

## Inimigos

O inimigo atual fica em:

```text
Scene/units/Enemy.tscn
Scene/units/enemy.gd
```

Características atuais:

```text
HP máximo: 50
Movimento máximo: 6m
Posição inicial: 10,7
Arma inicial: Adaga
```

O inimigo possui:

- atributos;
- CA;
- ataque corpo a corpo;
- ataque à distância;
- sistema de armas;
- dano por dado de arma;
- crítico;
- recarga;
- ataque de oportunidade.

---

## IA inimiga

A IA inimiga escolhe posições usando pontuação.

Critérios atuais:

- prioriza ficar dentro do alcance da arma equipada;
- aproxima-se do herói;
- evita ocupar a mesma casa;
- reduz gasto de movimento desnecessário;
- já possui estrutura para pontuação de terreno no futuro.

A IA agora considera o alcance da arma. Um inimigo arqueiro, por exemplo, não precisa colar no herói para atacar.

---

## Ataque de oportunidade

Regra implementada:

```text
Se uma unidade estava dentro da área de ameaça de outra
e se move para fora dessa área,
ela sofre ataque de oportunidade.
```

Cada unidade pode realizar apenas um ataque de oportunidade por turno.

---

## HUD de batalha

A HUD de batalha é horizontal, compacta e semitransparente.

Informações exibidas:

- nome;
- raça;
- classe;
- nível;
- XP;
- vida;
- movimento;
- arma equipada;
- redução de dano;
- Fúria restante;
- status de Destruir o Mal;
- CA;
- Fortitude;
- Reflexos;
- Vontade;
- turno atual;
- vida do inimigo.

Botões atuais:

```text
Ataque
Habilidade
Magia
Itens
Terminar Turno
Salvar
Sair
```

Estado atual:

- **Ataque:** funcional;
- **Habilidade:** funcional para Bárbaro e Paladino, informativa para outras classes;
- **Magia:** placeholder;
- **Itens:** placeholder;
- **Terminar Turno:** funcional;
- **Salvar:** cria save manual;
- **Sair:** confirma, salva autosave e volta ao menu.

---

## Sistema de XP e níveis

O sistema usa XP total acumulado.

Regras atuais:

```text
Nível máximo: 20
Nível 1 → 2: 1000 XP total
Cada nova faixa aumenta 1.5x em relação à anterior
```

Exemplo:

```text
Nível 1 → 2: +1000 XP | total 1000
Nível 2 → 3: +1500 XP | total 2500
Nível 3 → 4: +2250 XP | total 4750
Nível 4 → 5: +3375 XP | total 8125
```

A HUD mostra o progresso do nível atual:

```text
Nv 2 | XP 0/1500
```

Ao derrotar o inimigo atual, o herói recebe 1000 XP para teste.

---

## Save e carregamento

O projeto possui dois tipos de save:

```text
Autosave
Save manual
```

### Autosave

Usado quando o jogador abandona a partida pela HUD.

Arquivo:

```text
user://autosave.json
```

### Saves manuais

Criados pelo botão **Salvar**.

Diretório:

```text
user://manual_saves/
```

Modelo atual de save:

- salva o stage atual;
- salva nome, raça e classe;
- salva atributos;
- salva HP máximo, ataque e movimento;
- salva nível e XP;
- salva dados de classe;
- salva dados raciais;
- não salva o estado exato do meio da batalha.

Modelo escolhido:

```text
Se o jogador sair no meio da fase,
ao continuar ele volta para o início da fase atual,
com os presets salvos do personagem.
```

---

## GameState

O projeto usa o Autoload:

```text
GameState
```

Arquivo:

```text
Scene/game_state.gd
```

Responsabilidades:

- guardar se deve carregar save;
- guardar caminho do save selecionado;
- guardar stage atual;
- guardar nome do personagem;
- guardar raça;
- guardar classe;
- guardar atributos;
- guardar HP, ataque e movimento;
- guardar nível e XP;
- guardar dados de raça;
- guardar dados de classe;
- guardar modo de progressão de vida.

Dados principais:

```gdscript
var should_load_save: bool = false
var selected_save_path: String = ""
var selected_stage: int = 1

var player_name: String = "Herói"
var player_class: String = "Sem Classe"
var player_race: String = "Humano"

var hero_max_hp: int = 100
var hero_attack_power: int = 20
var hero_max_movement_meters: float = 9.0

var hero_level: int = 1
var hero_total_xp: int = 0
var hero_xp_to_next_level: int = 1000
var hero_max_level: int = 20

var hero_strength: int = 10
var hero_dexterity: int = 10
var hero_constitution: int = 10
var hero_wisdom: int = 10
var hero_intelligence: int = 10
var hero_charisma: int = 10

var hero_size: String = "Médio"
var hero_size_modifier: int = 0
var hero_favored_class: String = "Qualquer"
var hero_race_traits: Array = []

var hero_class_hit_die: int = 12
var hero_hp_fixed_per_level: int = 8
var hero_hp_progression_mode: String = "fixed"

var hero_base_attack_bonus_type: String = "alto"
var hero_fortitude_type: String = "bom"
var hero_reflex_type: String = "ruim"
var hero_will_type: String = "ruim"

var hero_fortitude_base_bonus: int = 2
var hero_reflex_base_bonus: int = 2
var hero_will_base_bonus: int = 0

var hero_class_movement_bonus: float = 0.0
var hero_damage_reduction: int = 0
var hero_class_features: Array = []
```

---

## Menu inicial

Arquivos:

```text
Scene/main_menu.tscn
Scene/main_menu.gd
```

Opções:

```text
Iniciar
Continuar
Configurações
Sair
```

Funções:

- **Iniciar:** abre criação de personagem;
- **Continuar:** abre lista de saves;
- **Configurações:** abre popup de configurações;
- **Sair:** fecha o jogo.

---

## Configurações

O menu de configurações permite ajustar:

- volume geral;
- volume dos efeitos;
- idioma;
- créditos.

Arquivo de configurações:

```text
user://settings.json
```

O sistema usa o bus `Master` e cria/usa o bus `SFX` para efeitos.

---

## Sistemas ainda planejados

Próximas melhorias previstas:

- sistema completo de magias;
- botão e lógica de cura do Clérigo;
- Música Bárdica do Bardo;
- Forma Selvagem do Druida;
- Familiar do Mago/Feiticeiro;
- Companheiro Animal do Druida/Ranger;
- flanqueamento real para o Ladino;
- Evasão;
- Rajada de Golpes do Monge;
- talentos do Guerreiro;
- Inimigo Predileto do Ranger;
- Montaria Especial do Paladino;
- armaduras e escudos;
- inventário;
- itens consumíveis;
- magias de toque e magias à distância;
- efeitos de status;
- tipos de criatura;
- terreno difícil;
- cobertura;
- terreno alto;
- múltiplos inimigos;
- múltiplas fases;
- balanceamento de XP;
- interface visual para escolher arma;
- sprites e animações definitivas.

---

## Objetivo do projeto

O objetivo de **Táticas do Destino** é construir, passo a passo, um RPG tático funcional com profundidade de RPG de mesa, onde raça, classe, arma, atributo, posicionamento, alcance, defesa e habilidades tenham impacto real no combate.

O projeto também serve como estudo prático de:

- Godot;
- GDScript;
- lógica de jogos táticos;
- organização de código;
- sistemas de RPG;
- IA simples;
- save/load;
- balanceamento de combate.
