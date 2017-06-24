% import the library
:- use_module(library(clpfd)).

% prove all conjunctions
conjunct([]).
conjunct([H|T]) :- disjunct([H]), conjunct(T).

% prove the disjunctions
disjunct([X]) :-
    var(X), !, X #= 1;
    X #= 0.
disjunct([X,Y]) :-
    disjunct([X]);
    disjunct([Y]).
disjunct([X,Y,Z]) :-
    disjunct([X]);
    disjunct([Y]);
    disjunct([Z]).

% the solve-function
solve(Variables, Lists) :-
              Variables ins 0..1, % possible solutions for the nodes
              conjunct(Lists), % prove the CNF
              label(Variables). % label Variables given the parameters
