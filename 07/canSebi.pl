%------------------------------------------------------
% uninformed search strategies using an agenda:
%
%     no information where the goal states are
%
% depth-first breadth-first iterative deepening
%------------------------------------------------------
% demonstrated using:
%
%        cannibals and missionaries
%------------------------------------------------------
% representing the problem
%------------------------------------------------------
% what's a state?
%
% Three missionaries and three cannibals must cross a river using a boat
% which can carry at most two people.  If there are missionaries present
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
%       number of missionaries on the left bank,
%       boat position).
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

% the amount of missionaries/cannibals
n(3).

% find all allowed successor states
transitions(State, States) :- findall(X, isValid(State,X), States).

% wrapper-function for state-transitions
isValid(state(X1,Y1,B1),state(X2,Y2,B2)) :- move(X1,Y1,X2,Y2,B1,B2),checkState(X2,Y2).

% rules for possible moves:
% take 1 missionary
% take 2 missionaries
% take 1 cannibal on the boat and move to other site
% take 2 cannibals
% take 1 cannibal and 1 missionary
% the amount of each group cannot be less than 0 or greater than N
% the amount of missionaries cannot be smaller than of the cannibals

% possible moves from left to right
% idea: the new state has the amount of missionaries/cannibals that result from
% the rules mentioned above (with check of boundaries, e.g. amount left > 0 ...)
move(X1,Y1,X2,Y2,left,right) :- X2 is X1-1, X2 >= 0, Y2 = Y1.
move(X1,Y1,X2,Y2,left,right) :- X2 is X1-2, X2 >= 0, Y2 = Y1.
move(X1,Y1,X2,Y2,left,right) :- Y2 is Y1-1, Y2 >= 0, X2 = X1.
move(X1,Y1,X2,Y2,left,right) :- Y2 is Y1-2, Y2 >= 0, X2 = X1.
move(X1,Y1,X2,Y2,left,right) :- X2 is X1-1, Y2 is Y1-1, X2 >= 0, Y2 >= 0.

% possible moves from right to left
move(X1,Y1,X2,Y2,right,left) :- X2 is X1+1, n(N), X2 =< N, Y2 = Y1.
move(X1,Y1,X2,Y2,right,left) :- X2 is X1+2, n(N), X2 =< N, Y2 = Y1.
move(X1,Y1,X2,Y2,right,left) :- Y2 is Y1+1, n(N), Y2 =< N, X2 = X1.
move(X1,Y1,X2,Y2,right,left) :- Y2 is Y1+2, n(N), Y2 =< N, X2 = X1.
move(X1,Y1,X2,Y2,right,left) :- X2 is X1+1, n(N), Y2 is Y1+1, X2 =< N, Y2 =< N.

% check if the state is a valid state (no missionaries outnumbered)
checkState(X,X).
checkState(_,Y) :- Y = 0.
checkState(_,Y) :- n(N), Y = N.

%------------------------------------------------------------
% the goal state
%------------------------------------------------------------

end(state(0,0,right)).

% ############################################################################
% NO NEED TO CHANGE BELOW THIS LINE
% ############################################################################

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
