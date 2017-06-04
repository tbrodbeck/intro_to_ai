% Define a similar predicate reduce
% that takes a list L,
% a binary function F that operates on the elements of L and has neutral element N
% and maps them to a number E that is obtained by applying F to the elements of L recursively.

reduce([], _F, E, E).
reduce([H|T], F, N ,E) :- Goal =.. [F,N,H,NNew], call(Goal), reduce(T,F,NNew,E).

add(N1,N2, N) :- N is N1 + N2.
mult(N1,N2, N) :- N is N1 * N2.
