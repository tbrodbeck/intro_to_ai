% clp(fd) import
:- use_module(library(clpfd)).

% rewrites a all not(X) entries in a list to 1-X
rewrite([],[]).
rewrite([H|T],[H|T2]) :- var(H),!,rewrite(T,T2).
rewrite([not(H)|T], [B|T2]) :- B = 1-H, rewrite(T,T2).

% calls rewrite with every sublist in given list
rewriteList([],[]).
rewriteList([H|T],[L1|L3]) :- rewrite(H,L1),rewriteList(T,L3).

% lay constraints on every clause of the list
resolve([]).
resolve([H|T]) :- clauses(H), resolve(T).

% the constraints
clauses([A]) :- max(A,0) #= 1. % needs max to evaluate the 1-X cases
clauses([A,B]) :- max(A,B) #= 1. % at least A or B has to be 1
clauses([A,B,C]) :- max(max(A,B),max(B,C)) #= 1. % A,B or C has to be 1

% The solve predicate that rewrites the not(X) in the List and the
% solves the Atoms by the given constraints
solve(Atoms, Clauses) :-
             rewriteList(Clauses,R),
             Atoms ins 0..1,
             resolve(R),
             label(Atoms).
