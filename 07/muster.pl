%------------------------------------------------------
% uninformed search strategies using an agenda:
%
% no information where the goal states are
%
% depth-first breadth-first iterative deepening
%------------------------------------------------------
% demonstrated using:
%
% cannibals and missionaries
%------------------------------------------------------
% representing the problem
%------------------------------------------------------
% what's a state?
%
% Three missionaries and three cannibals must cross a river using a boat
% which can carry at most two people. If there are missionaries present
% on a bank, they cannot be outnumbered by cannibals on that bank.
% The boat cannot cross the river by itself with no cannibal or missionary
% on board. All three cannibals and missionaries start on the left bank
% and must end up on the right bank.
%
% The representation:
%
% Problem states are represented by triples:
%
% state(number of cannibals on the left bank,
% number of missionaries on the left bank,
% boat position).
%
% Example:
% state(3,3,left). % start state: all on the left
%
% The number of individuals on the right bank doesn't have to be
% represented seperately because it can be calculated from
% the given information.
%
% initial configuration
start(1,state(3,3,left)).

%------------------------------------------------------
% state transisions
%-----------------------------------------------------------------------

allowed(state(CannLeft,0, _Boat)) :- % no missionaries on the left: always ok
CannLeft >= 0,
CannLeft =< 3.
allowed(state(CannLeft,3, _Boat)) :- % no missionaries on the right: always ok
CannLeft >= 0,
CannLeft =< 3.
allowed(state(CannLeft,MissLeft, _Boat)) :- % check in detail
CannLeft >= 0,
CannLeft =< 3,
MissLeft >= 1,
MissLeft =< 2,
CannLeft =< MissLeft, % no cannibal overwheight on the left
3-CannLeft =< 3-MissLeft. % no cannibal overwheight on the right

% 1 or 2 missionaries row from left to right
transition(state(CannLeft, MissLeft, left), state(CannLeft, MissLeftNew, right)) :-
member(Num, [1,2]),
MissLeftNew is MissLeft - Num.

% 1 or 2 missionaries row from right to left
transition(state(CannLeft, MissLeft, right), state(CannLeft, MissLeftNew, left)) :-
member(Num, [1,2]),
MissLeftNew is MissLeft + Num.

% 1 or 2 cannibals row from left to right
transition(state(CannLeft, MissLeft, left), state(CannLeftNew, MissLeft, right)) :-
member(Num, [1,2]),
CannLeftNew is CannLeft - Num.

% 1 or 2 cannibals row from right to left
transition(state(CannLeft, MissLeft, right), state(CannLeftNew, MissLeft, left)) :-
member(Num, [1,2]),
CannLeftNew is CannLeft + Num.

% 1 cannibal and 1 missionary row from left to right
transition(state(CannLeft, MissLeft, left), state(CannLeftNew, MissLeftNew, right)) :-
MissLeftNew is MissLeft - 1,
CannLeftNew is CannLeft - 1.

% 1 cannibal and 1 missionary row from right to left
transition(state(CannLeft, MissLeft, right), state(CannLeftNew, MissLeftNew, left)) :-
MissLeftNew is MissLeft + 1,
CannLeftNew is CannLeft + 1.

% find all allowed successor states
transitions(State, States) :-
findall(NewState, (transition(State,NewState), allowed(NewState)), States).

%------------------------------------------------------------
% the goal state
%------------------------------------------------------------

end(state(0,0,_)).

% ---------------------------------------------------
% expanding paths
% ---------------------------------------------------

% ?- expand(+OldPath, +Successors, -ExpandedPaths)
expand(_P,[],[]).
expand(P,[N|R],[[N|P]|R1]) :-
not(member(N,P)), !,
expand(P,R,R1).
expand(P,[_N|R],R1) :-
expand(P,R,R1).

% ---------------------------------------------------
% depth-first/breadth-first search using an agenda
% ---------------------------------------------------
% ?- search_breadth_first(+Nproblem, -SolutionPath)

search_breadth_first(N,SolutionPath) :-
start(N,X),
search_b([[X]],SolutionPath).

% ?- search_b(+Agenda, -SolutionPath)
search_b([[X|Path]|_Agenda],[X|Path]) :-
end(X).

% expand first element of first path
search_b([[X|Path]|Agenda],Solution) :-
transitions(X,S),!,
expand([X|Path],S,Ps),
append(Agenda,Ps,NewAgenda),
% append(Ps,Agenda,NewAgenda),
search_b(NewAgenda,Solution).

% dead end - remove first path
search_b([[_X|_Path]|Agenda],Solution) :-
search_b(Agenda,Solution).


% ---------------------------------------------------
% ?- search_depth_first(+Nproblem, -SolutionPath)

search_depth_first(N,SolutionPath) :-
start(N,X),
search_d([[X]],SolutionPath).

% ?- search_d(+Agenda, -SolutionPath)
search_d([[X|Path]|_Agenda],[X|Path]) :-
end(X).

% expand first element of first path
search_d([[X|Path]|Agenda],Solution) :-
transitions(X,S),!,
expand([X|Path],S,Ps),
% append(Agenda,Ps,NewAgenda),
append(Ps,Agenda,NewAgenda),
search_d(NewAgenda,Solution).

% dead end - remove first path
search_d([[_X|_Path]|Agenda],Solution) :-
search_d(Agenda,Solution).

% ---------------------------------------------------
% ?- search_iterative_deepening(+Nproblem, -SolutionPath)

search_iterative_deepening(N,SolutionPath) :-
search_iterative_deepening(N,SolutionPath,0).

% search up to depth limit and find a solution
search_iterative_deepening(N,SolutionPath,DepthLimit) :-
start(N,X),
search_dl([[X]],SolutionPath,DepthLimit).

% no solution found? Incread depth limit
search_iterative_deepening(N,SolutionPath,DepthLimit) :-
NewDepthLimit is DepthLimit + 1,
search_iterative_deepening(N,SolutionPath,NewDepthLimit).

% ?- search_dl(+Agenda, -SolutionPath, +Depth, +DepthLimit)

% Solution found. First Path in Agenda is solution path.
search_dl([[X|Path]|_Agenda],[X|Path], _DepthLimit) :-
end(X).

% expand first element of first path
search_dl([[X|Path]|Agenda],Solution, DepthLimit) :-
length([X|Path],Depth), % depth = length of path
Depth < DepthLimit, % only continue if depth limit not reached
transitions(X,S),!,
expand([X|Path],S,Ps),
% append(Agenda,Ps,NewAgenda),
append(Ps,Agenda,NewAgenda),
search_dl(NewAgenda,Solution, DepthLimit).

% dead end - remove first path
search_dl([[_X|_Path]|Agenda],Solution, DepthLimit) :-
search_dl(Agenda,Solution,DepthLimit).
