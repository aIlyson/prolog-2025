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