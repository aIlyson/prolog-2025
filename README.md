# Projeto Programação Lógica

**Professor:** Alan Rafael Ferreira dos Santos  
**Autores:** [Alysson Michel](https://github.com/aIlyson) e [Kleber Moura](https://github.com/Kleber232)

---

## Resumo

Este é um projeto de um sistema de recomendação de filmes desenvolvido na linguagem **Prolog**, utilizando base de conhecimento e regras lógicas para sugerir filmes personalizados para o usuário com base em preferências, filmes assistidos e similaridade entre obras.

---

## Funcionalidades

- [x] Consultar filmes por gênero, ator ou nota mínima
- [x] Listar todos os filmes cadastrados
- [x] Registrar filmes assistidos por usuário
- [x] Recomendar filmes personalizados, com pontuação e ordenação
- [x] Explicar por que um filme foi recomendado

### Features

- [x] Entrada interativa via terminal
- [x] Uso de base de dados externa (`database.pl`)
- [x] Pontuação baseada em critérios como gênero, diretor, elenco, nota e país
- [ ] Interface gráfica (não aplicável)

---

## Instalação

### Requisitos

- [SWI-Prolog](https://www.swi-prolog.org) instalado
- IDE com suporte a Prolog (recomendado VS Code + extensão)

### Passo a Passo

1. Clone o repositório:
   ```bash
   git clone https://github.com/aIlyson/filmes-prolog.git
   cd filmes-prolog
   ```

2. Estrutura de arquivos:

   ```
   src/
     ├── main.pl        # Lógica principal do sistema
     └── database.pl    # Base de dados de filmes
   ```

3. Execute o programa:
   ```bash
   swipl src/main.pl
   ```
   ```prolog
   main.
   ```

---

## ☕ Estrutura do Projeto

```
src/
├── main.pl        # Contém:
│                  # - Menu
│                  # - Regras de recomendação
│                  # - Lógica de consulta
│
└── database.pl    # Armazena fatos no formato:
                   # filme(Título, Gênero, Diretor, Elenco,
                   #       Ano, Duração, Idioma, País, Nota, Classificação)
    README.md      # Documento do projeto
```

---

## Exemplos de Uso

1. Consultar filmes de ação:

   ```prolog
   ?- filmes_por_genero(acao).
   ```

2. Registrar filmes assistidos:

   ```prolog
   ?- registrar_assistidos(meu_usuario).
   ```

3. Obter recomendações:

   ```prolog
   ?- recomendar(meu_usuario, 'Matrix', ficcao, 7.0, Recomendacoes).
   ```

4. Entender uma recomendação:
   ```prolog
   ?- explica_recomendacao('Matrix', 'Interestelar', Explicacao), write(Explicacao).
   ```

---

## Sistema de Pontuação

O sistema utiliza os seguintes critérios para calcular a pontuação entre dois filmes:


| Critério             | Pontuação   |
| -------------------- | ----------- |
| Mesmo gênero         | +2          |
| Mesmo diretor        | +1          |
| Atores em comum      | +1 por ator |
| Nota IMDb mais alta  | +1          |
| Mesmo país de origem | +1          |
| Nota inferior        | -1          |

### Exemplo no `database.pl`

```prolog
filme('matrix', ficcao, 'wachowski',
      ['keanu reeves', 'laurence fishburne'],
      1999, 136, ingles, eua, 8.7, 16).
```

## Observações

- O sistema desconsidera filmes já assistidos pelo usuário na recomendação.
- O programa não exige compilação — é executado diretamente via interpretador Prolog.
- Recomendo manter nomes dos filmes em letras minúsculas e sem acentos para evitar erros de leitura no terminal.
