:- initialization(main).

% banco de dados
:- consult('database.pl').
:- dynamic assistido/2. % permite armazenar filmes assistidos por usuarios
:- dynamic preferencias/5. % permite armazenar preferencias de usuarios

% nosso caso, o filme/10 sera definido em 'database.pl':

main :-
    write('Menu'), nl,
    write('Digite "consultar." para ver as opcoes de busca.'), nl, % caso o usuário queira consultar filmes
    write('Digite "recomendar (Filme, Usuario, Preferencias)." para obter recomendacoes.'), nl. % caso o usuário queira uma recomendacao

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
    filme(Titulo, Genero, Diretor, Elenco, Ano, Duracao, Idioma, Pais, IMDb, Classificacao),
    write('Titulo: '), write(Titulo), nl,
    write('Genero: '), write(Genero), nl,
    write('Nota IMDb: '), write(IMDb), nl,
    write('Classificacao: '), write(Classificacao), nl, nl,
    fail.
listar_todos_filmes.

intersecao([], _, []).
intersecao([H|T], L2, [H|R]) :- member(H, L2), !, intersecao(T, L2, R).
intersecao([_|T], L2, R) :- intersecao(T, L2, R).

score(F1, F2, Score) :-
    filme(F1, G1, D1, E1, _, _, _, P1, N1, _),
    filme(F2, G2, D2, E2, _, _, _, P2, N2, _),
    F1 \= F2,
    (G1 == G2 -> S1 = 2 ; S1 = 0),
    (D1 == D2 -> S2 = 1 ; S2 = 0),
    intersecao(E1, E2, I), length(I, S3),
    (N2 > N1 -> S4 = 1 ; S4 = 0),
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
        (G1 == G2 -> Motivo = 'mesmo gênero' ; fail);
        (D1 == D2 -> Motivo = 'mesmo diretor' ; fail);
        (intersecao(E1, E2, I), I \= [], Motivo = 'atores em comum');
        (N2 > N1 -> Motivo = 'nota superior' ; fail);
        (P1 == P2 -> Motivo = 'mesmo país de origem' ; fail)
    ), Motivos),
    atomic_list_concat(Motivos, ', ', MotivosTexto),
    format(atom(Texto),
      'O filme ~w foi recomendado por ter ~w em comum com ~w.',
      [F2, MotivosTexto, F1]).

assistido(usuario1, 'matrix').
assistido(usuario1, 'avatar').


% ---------- dip ----------

% calcular_score(FilmeBase, FilmeComp, AtorPref, Score, Explicacoes) :-


% recomenda filmes
% recomendar(FilmeBase, Usuario, preferencias(Genero, NotaMin, ClassMax, AtorPref)) :-

% exibir_recomendacoes([]) :-
    

% exmplo de estrutura a ser usada mais para frente:
% 1. Buscar todos os filmes diferentes do FilmeBase
% 2. Filtrar por genero, nota mínima e classificacao maxima
% 3. Calcular score com base em criterios combinados
% 4. Excluir filmes jáaassistidos usando: \+ assistido(Usuario, Filme)
% 5. Retornar os filmes ordenados por score (sort/4)

% pontuacao sugerida (exemplo para sua dupla):
% +2 se genero for igual
% +1 se ator preferido estiver no elenco
% +1 se pais for igual
% +1 se nota IMDb for maior que a do filme base
% -1 se for da mesma classificacao mas menor nota