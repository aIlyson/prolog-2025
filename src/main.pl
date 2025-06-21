:- initialization(main).

% banco de dados
:- consult('database.pl').

main :-
    write('Menu'), nl,
    write('Digite "consultar." para ver as opcoes'), nl.

% realiza uma consulta basica
consultar :-
    write('Opcoes de consulta:'), nl,
    write('1. filmes_por_genero(Genero)'), nl,
    write('2. filmes_por_ator(Ator)'), nl,
    write('3. filmes_acima_nota(Nota)'), nl,
    write('4. listar_todos_filmes.'), nl.

% 1. consulta por genero
filmes_por_genero(Genero) :-
    filme(Titulo, Genero, _, _, _, _, _, _, _, _),
    write(Titulo), nl,
    fail.
filmes_por_genero(_).

% 2. consulta por ator
filmes_por_ator(Ator) :-
    filme(Titulo, _, _, Elenco, _, _, _, _, _, _),
    member(Ator, Elenco),
    write(Titulo), nl,
    fail.
filmes_por_ator(_).

% 3. consulta por nota IMDb
filmes_acima_nota(NotaMin) :-
    filme(Titulo, _, _, _, _, _, _, _, IMDb, _),
    IMDb >= NotaMin,
    write(Titulo), nl,
    fail.
filmes_acima_nota(_).

% 4. listar todos os filmes
listar_todos_filmes :-
    filme(Titulo, Genero, Diretor, Elenco, Ano, Duracao, Idioma, Pais, IMDb, Classificacao),
    writeq(filme(Titulo, Genero, Diretor, Elenco, Ano, Duracao, Idioma, Pais, IMDb, Classificacao)),
    write('.'), nl,
    fail.
listar_todos_filmes.
