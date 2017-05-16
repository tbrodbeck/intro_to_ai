% The base case is looking if the searched element is the head of the list.
deep_member(X, [X | _T]).

% The recursion cases:
% This one will try whether the head of the list is another list we can search
deep_member(X, [L|_T]) :- deep_member(X, L).
% In this case we consider we searched in the head already and check the
% tail of the list.
deep_member(X, [_H| T]) :- deep_member(X, T).
