% import the library
:- use_module(library(clpfd)).

% coloring constraints
coloring([]).
coloring([A-B|T]) :- A #\= B, coloring(T).

% wrapper-function for solve without parameters
solve((Nodes, Edges), Colors) :- solve((Nodes,Edges), Colors, []).

% the solve-function
solve((Nodes, Edges), Colors, Params) :-
              Nodes ins 1..Colors, % possible solutions for the nodes
              coloring(Edges), % set the constraints by the edges
              labeling(Params, Nodes). % label Nodes, given the parameters
