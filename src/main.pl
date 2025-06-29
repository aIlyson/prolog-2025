% :- initialization(main).

% banco de dados
:- consult('database.pl').
:- dynamic assistido/2. % permite armazenar filmes assistidos por usuarios

main :-

write('===== SISTEMA DE RECOMENDACAO DE FILMES ====='), nl,
    repeat,
    nl,
    write('      MENU PRINCIPAL      '), nl,
    write('1. Consultar opcoes de busca'), nl,
    write('2. Registrar filmes assistidos'), nl,
    write('3. Obter recomendacoes'), nl,
    write('4. Explicar recomendacao'), nl,
    write('0. Sair'), nl,
    write('Escolha uma opcao: '),
    read(Opcao),
    nl,
    executar_opcao(Opcao),
    Opcao == 0, !.

% atua como uma especie de "switch case" para as opcoes do menu
executar_opcao(1) :- consultar, !.
executar_opcao(2) :-
    write('Digite o nome do usuario: '),
    read(Usuario),
    registrar_assistidos(Usuario), !.
executar_opcao(3) :-
    write('Digite o nome do usuario: '), read(Usuario),
    write('Digite o filme base: '), read(FilmeBase),
    write('Digite o genero: '), read(Genero),
    write('Digite a nota minima: '), read(NotaMin),
    recomendar(Usuario, FilmeBase, Genero, NotaMin, Lista),
    write('Recomendacoes:'), nl,
    mostrar_lista(Lista), !.
executar_opcao(4) :-
    write('Digite o filme base: '), read(F1),
    write('Digite o filme recomendado: '), read(F2),
    ( explica_recomendacao(F1, F2, Texto) ->
        write(Texto), nl
    ;
        write('Nao foi possivel gerar explicacao para essa recomendacao.'), nl
    ), !.
executar_opcao(0) :-
    write('Encerrando...'), nl, !.
executar_opcao(_) :-
    write('Opcao invalida!'), nl, fail.

mostrar_lista([]).
mostrar_lista([Score-Titulo | T]) :-
    format('~w - ~w~n', [Score, Titulo]),
    mostrar_lista(T).


% realiza uma consulta basica
consultar :-
    nl,
    write('Opcoes de consulta:'), nl,
    write('1. filmes_por_genero(Genero).'), nl,
    write('2. filmes_por_ator(Ator).'), nl,
    write('3. filmes_acima_nota(NotaMin).'), nl,
    write('4. listar_todos_filmes.'), nl.

% lista titulos com um determinado genero
filmes_por_genero(Genero) :-
    filme(Titulo, Genero, _, _, _, _, _, _, _, _),
    write('- '), write(Titulo), nl,
    fail.
filmes_por_genero(_).

% lista filmes com determinado ator no elenco
filmes_por_ator(Ator) :-
    filme(Titulo, _, _, Elenco, _, _, _, _, _, _),
    member(Ator, Elenco),
    write('- '), write(Titulo), nl,
    fail.
filmes_por_ator(_).

% lista filmes com nota IMDb acima de um valor
filmes_acima_nota(NotaMin) :-
    filme(Titulo, _, _, _, _, _, _, _, IMDb, _),
    IMDb >= NotaMin,
    write('- '), write(Titulo), nl,
    fail.
filmes_acima_nota(_).

% lista todos os filmes cadastrados
listar_todos_filmes :-
    filme(Filme, Genero, _, _, _, _, _, _, Nota, Classificacao),
    write('Titulo: '), write(Filme), nl,
    write('Genero: '), write(Genero), nl,
    write('Nota IMDb: '), write(Nota), nl,
    write('Classificacao: '), write(Classificacao), nl, nl,
    fail.
listar_todos_filmes.

intersecao([], _, []).
intersecao([H|T], L2, [H|R]) :- member(H, L2), !, intersecao(T, L2, R).
intersecao([_|T], L2, R) :- intersecao(T, L2, R).

% nosso sistema, o score é calculado com base em critérios combinados
score(F1, F2, Score) :-
    filme(F1, G1, D1, E1, _, _, _, P1, N1, _),
    filme(F2, G2, D2, E2, _, _, _, P2, N2, _),
    F1 \= F2,
    (G1 == G2 -> S1 = 2 ; S1 = 0),
    (D1 == D2 -> S2 = 1 ; S2 = 0),
    intersecao(E1, E2, I), length(I, S3),
    (N2 > N1 -> S4 = 1 ; N2 < N1 -> S4 = -1 ; S4 = 0),
    (P1 == P2 -> S5 = 1 ; S5 = 0),
    Score is S1 + S2 + S3 + S4 + S5.

recomendar(Usuario, FilmeRef, Genero, NotaMin, ListaOrd) :-
    findall(
        Score-Filme,
        (
            filme(Filme, Genero, _, _, _, _, _, _, Nota, _),
            Nota >= NotaMin,
            Filme \= FilmeRef,
            \+ assistido(Usuario, Filme),
            score(FilmeRef, Filme, Score),
            Score > 0
        ),
        Pares
    ),
    keysort(Pares, Ordenado),
    reverse(Ordenado, ListaOrd).

explica_recomendacao(F1, F2, Texto) :-
    filme(F1, G1, D1, E1, _, _, _, P1, N1, _),
    filme(F2, G2, D2, E2, _, _, _, P2, N2, _),
    F1 \= F2,
    findall(Motivo, (
        (G1 == G2 -> Motivo = 'mesmo genero' ; fail);
        (D1 == D2 -> Motivo = 'mesmo diretor' ; fail);
        (intersecao(E1, E2, I), I \= [], Motivo = 'atores em comum');
        (N2 > N1 -> Motivo = 'nota superior' ; fail);
        (P1 == P2 -> Motivo = 'mesmo pais de origem' ; fail)
    ), Motivos),
    atomic_list_concat(Motivos, ', ', MotivosTexto),
    format(atom(Texto),
      'O filme ~w foi recomendado por ter ~w em comum com ~w.',
      [F2, MotivosTexto, F1]).

     :- use_module(library(readutil)). % para read_line_to_string/2

registrar_assistidos(Usuario) :-
    write('Digite os filmes que voce ja assistiu (digite "fim" para terminar):'), nl,
    repetir_leitura_filmes(Usuario).

repetir_leitura_filmes(Usuario) :-
    read_line_to_string(user_input, Linha),
    ( Linha = "fim" ->
        true
    ;
        atom_string(FilmeAtom, Linha),
        ( assistido(Usuario, FilmeAtom) ->
            write('Filme ja registrado: '), write(FilmeAtom), nl
        ;
            assertz(assistido(Usuario, FilmeAtom)),
            write('Registrado: '), write(FilmeAtom), nl
        ),
        repetir_leitura_filmes(Usuario)
    ).
    

% pontuacao sugerida:
% +2 se genero for igual
% +1 se ator preferido estiver no elenco
% +1 se pais for igual
% +1 se nota IMDb for maior que a do filme base
% -1 se for da mesma classificacao mas menor nota