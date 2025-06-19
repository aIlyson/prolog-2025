:- initialization(main).

% importar banco de dados
:- consult('database.pl').

% funcao principal do programa
main :-
    write('hi!'), nl,
    halt.

% para rodar: 
% 1. abra o terminal no VS Code
% 2. execute: swipl -s src/main.pl -g main -t halt