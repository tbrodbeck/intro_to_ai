:- use_module(library(clpfd)).

solve(([Nodes],[]),ColNum,Options).

solve((Nodes,Edges),ColNum,Options) :-
    Board ins 1..ColNum,
    labeling(Options,Var),
    

%
% solve(([Nodes],[]),ColNum,Options).
%
% solve((Nodes,[X-Y|T]),ColNum,Options) :-
%     solve(([Nodes],[T]),ColNum,Options),
%     X #\= Y,
%     set(Nodes,X,ColNum,NNodes,[]),
%     .
%
% solve(([],[L]),N) :-
%
%
% solve(([H|T],[L]),N) :-
%
%
% solve(([L],[]),N) :-
%
%
% solve(([L],[H|T]),N) :-
%
