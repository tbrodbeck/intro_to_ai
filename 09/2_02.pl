% import the library
:- use_module(library(clpb)).

countNegativeLiterals([],0).
countNegativeLiterals([H | T],N) :- var(H), !, countNegativeLiterals(T, N).
countNegativeLiterals([not(_) | T],N) :- countNegativeLiterals(T, NT), N is NT+1.

% prove all conjunctions
conjunct([]).
conjunct([H|T]) :- disjunct([H]) * conjunct(T).

% prove the disjunctions
disjunct([X]) :-
    L.
disjunct([X,Y]) :-
    disjunct([X]) + disjunct([Y]).
disjunct([X,Y,Z]) :-
    disjunct([X]) + disjunct([Y]) + disjunct([Z]).
% the solve-function
solve(Variables, Lists) :-
              Variables ins 0..1, % possible solutions for the nodes
              conjunct(Lists), % prove the CNF
              label(Variables). % label Variables   , given the parameters
