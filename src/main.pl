:- initialization(main).

main :-
    write('hi!'), nl,
    halt.

% Para rodar: 
% 1. Abra o terminal no VS Code
% 2. Execute: swipl -s src/main.pl -g main -t halt