% 1
wffAL([]).  % base case
wffAL([[_, _] | A]) :- wffAL(A).  % recursion case

% 2
put_assoc(K,A,V,[[K,V]|A]).

% 3
get_assoc(K,[[K,V]|_],V).  % base case
get_assoc(K,[_|T],V) :- get_assoc(K,T,V).  % recusion case

% 4
% the base case checks if the list is empty and the size is 0
size([],0).
% the recursive case checks the length of the tail and adds 1 to the tails length
size([[_,_]|T],L) :- size(T, NL), L is NL + 1.
