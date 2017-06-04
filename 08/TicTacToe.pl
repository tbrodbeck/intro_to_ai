%% Minimax algorithm for TicTacToe
%% with simple game shell
%%
%% From: http://www.emse.fr/~picard/cours/ai/minimax/
%
%
% Assignment 8, Task 6:
%
% Use a evaluation function for Tic Tac Toe
%
% This TicTacToe implementation only uses minimax
% and no evaluation function.
%
% Usage:
%
% ?- play.
%
% Finish all lines entered with a .
%
% Examples:
% x.
% 5.
% 3.
%
% If asked for a move, enter a board position from 1-9.
%
% NOTE: This program works with swish but the board layout is a bit broken.
%       Take a careful look when using swish.
%
% Game states are represented as:
%
% [next player, win/draw/play, [0,0,0, 0,0,0, 0,0,0]]
%
% The 1st parameter is either x or o and represents the player at move
% The 2nd parameter gives the state: Game is won (win) or ended with a draw
%                                    or is stil in progress (play)
% The 3rd parameter represents the 3x3 board as a list of 9 positions:
% - order: first 3 elements = 1st row,
%          next 3 elements = 2nd row,
%          last 3 elements = last row
% - field is empty: 0 (zero)
% - field is taken by player x: x
% - field is taken by player o: o
%
% Values: Win=100 points, Loss=-100 points, Draw=0 points
%
% Extend the program to use an evaluation function:
%
% 1. The evaluation predicate (6 points)
%
% Implement a predicate evaluate(+Board, -Value) that evaluates
% a board from x player prespective. You need to inspect the
% board and calculate a value. Take a look at the Connect-4 evaluation
% function to get some inspiration.
%
% Make sure to test your evaluation function in isolation before integrating
% it into the large program.
%
% Define a test predicate like (replace ??? with your expected values):
%
% test_evaluation :-
%    evaluation([0,0,0,0,0,0,0,0,0], 0),
%    evaluation([0,0,0,0,x,0,0,0,0], 4),
%    evaluation([o,0,0,x,x,0,0,0,0], 28),
%    evaluation([o,x,o,o,x,o,x,o,0], 0).
%
% Hints:
% - Don't try to be too clever. It's ok to use a very explicit implementation
%   that tests possibilities one by one (How many possible combinations of
%   3 fields are there? How many possible placements of x and o that need to
%   be counted exist per combination?)
%
% 2. Depth limit and integration of evaluation predicate
%
% Introduce a depth limit of 3. On the 4th level the algorithm shall use
% the evaluation function and not the recursive case.
%
% Hints:
%
% - Extend minimax/3 with an additional depth parameter that is increased
%   before every recursive call (don't forget to adjust subgoals).
%
% - Wrap the new minimax/4 predicate in a minimax/3 predicate that sets start
%   depth to 0 so the original code still works:
%      minimax(Pos, BestNextPos, Val) :- minimax(Pos, BestNextPos, Val, 0)
%
% - Extend the original utility/2 predicate to include your evaluation
%   predicate if the game is still running:
%      utility([x,play,Board],Val) :- evaluation(Board, Val).
%   Adjust values for player o
%
% Include meaningful comments!
%


% ---------------------------------------------------------
% Problem independent part: Minimax Algorithm
% ---------------------------------------------------------

test_evaluation :-
   evaluation([ 0,0,0,
                0,0,0,
                0,0,0], 0),
   evaluation([ x,0,0,
                0,0,0,
                0,0,0], 12),
   evaluation([ x,o,0,
                0,0,0,
                0,0,0], 0),
   evaluation([x,o,x,0,0,0,0,0,0], 4),
   evaluation([x,o,0,0,0,0,0,0,0], 0),
   evaluation([x,0,o,0,0,0,0,0,0], 0),
   evaluation([x,0,0,o,0,0,0,0,0], 4),
   evaluation([x,0,0,0,o,0,0,0,0], 4),
   evaluation([x,0,0,0,0,o,0,0,0], 4),
   evaluation([x,0,0,0,0,0,o,0,0], 4),
   evaluation([x,0,0,0,0,0,0,o,0], 4),
   evaluation([x,0,0,0,0,0,0,0,o], 4),
   evaluation([0,x,0,0,0,0,0,0,0], 8),
   evaluation([0,0,x,0,0,0,0,0,0], 8),
   evaluation([0,0,0,x,0,0,0,0,0], 12),
   evaluation([0,0,0,0,x,0,0,0,0], 8),
   evaluation([0,0,0,0,0,x,0,0,0], 12),
   evaluation([0,0,0,0,0,0,x,0,0], 12),
   evaluation([0,0,0,0,0,0,0,x,0], 8),
   evaluation([0,0,0,0,0,0,0,0,x], 4),
   evaluation([0,0,0,0,x,0,0,0,0], 0),
   evaluation([o,0,0,x,x,0,0,0,0], 0),
   evaluation([o,x,o,o,x,o,x,o,0], 0).

% minimax(Pos, BestNextPos, Val)
% Pos is a position, Val is its minimax value.
% Best move from Pos leads to position BestNextPos.
minimax(Pos, BestNextPos, Val) :-                     % Pos has successors
    findall(NextPos, move(Pos, NextPos), NextPosList),
    best(NextPosList, BestNextPos, Val), !.

minimax(Pos, _, Val) :-                     % Pos has no successors
    utility(Pos, Val).


best([Pos], Pos, Val) :-
    minimax(Pos, _, Val), !.

best([Pos1 | PosList], BestPos, BestVal) :-
    minimax(Pos1, _, Val1),
    best(PosList, Pos2, Val2),
    betterOf(Pos1, Val1, Pos2, Val2, BestPos, BestVal).



betterOf(Pos0, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
    min_to_move(Pos0),                         % MIN to move in Pos0
    Val0 > Val1, !                             % MAX prefers the greater value
    ;
    max_to_move(Pos0),                         % MAX to move in Pos0
    Val0 < Val1, !.                            % MIN prefers the lesser value

betterOf(_, _, Pos1, Val1, Pos1, Val1).        % Otherwise Pos1 better than Pos0

%
% ---------------------------------------------------------
% Problem specific part: TicTacToe
% ---------------------------------------------------------

% move(+Pos, -NextPos)
% True if there is a legal (according to rules) move from Pos to NextPos.
move([X1, play, Board], [X2, win, NextBoard]) :-
    nextPlayer(X1, X2),
    move_aux(X1, Board, NextBoard),
    winPos(X1, NextBoard), !.

move([X1, play, Board], [X2, draw, NextBoard]) :-
    nextPlayer(X1, X2),
    move_aux(X1, Board, NextBoard),
    drawPos(X1,NextBoard), !.

move([X1, play, Board], [X2, play, NextBoard]) :-
    nextPlayer(X1, X2),
    move_aux(X1, Board, NextBoard).

% move_aux(+Player, +Board, -NextBoard)
% True if NextBoard is Board whith an empty case replaced by Player mark.
move_aux(P, [0|Bs], [P|Bs]).

move_aux(P, [B|Bs], [B|B2s]) :-
    move_aux(P, Bs, B2s).


% min_to_move(+Pos)
% True if the next player to play is the MIN player.
min_to_move([o, _, _]).

% max_to_move(+Pos)
% True if the next player to play is the MAX player.
max_to_move([x, _, _]).

% utility(+Pos, -Val) :-
% True if Val the the result of the evaluation function at Pos.
% We will only evaluate for final position.
% So we will only have MAX win, MIN win or draw.
% We will use  100 when MAX win
%             -100 when MIN win
%              0 otherwise.
utility([o, win, _], 100).       % Previous player (MAX) has win.
utility([x, win, _], -100).      % Previous player (MIN) has win.
utility([_, draw, _], 0).

% winPos(+Player, +Board)
% True if Player win in Board.
winPos(P, [X1, X2, X3, X4, X5, X6, X7, X8, X9]) :-
    equal(X1, X2, X3, P) ;    % 1st line
    equal(X4, X5, X6, P) ;    % 2nd line
    equal(X7, X8, X9, P) ;    % 3rd line
    equal(X1, X4, X7, P) ;    % 1st col
    equal(X2, X5, X8, P) ;    % 2nd col
    equal(X3, X6, X9, P) ;    % 3rd col
    equal(X1, X5, X9, P) ;    % 1st diag
    equal(X3, X5, X7, P).     % 2nd diag

% drawPos(+Player, +Board)
% True if the game is a draw.
drawPos(_,Board) :-
    \+ member(0, Board).


% equal(+W, +X, +Y, +Z).
% True if W = X = Y = Z.
equal(X, X, X, X).


% bestMove(+Pos, -NextPos)
% Compute the best Next Position from Position Pos
% with minimax or alpha-beta algorithm.
bestMove(Pos, NextPos) :-
    minimax(Pos, NextPos, _).

% ===============================================================
% NO NEED TO CHANGE BELOW THIS LINE

% --------------------------------------------------------
% ugly I/O code. ignore it.
% --------------------------------------------------------

% query:
% ?- play.

% play
% Start the game.
play :-
    nl,
    write('===================='), nl,
          write('= Prolog TicTacToe ='), nl,
          write('===================='), nl, nl,
          write('Rem : x starts the game'), nl,
          playAskColor.



% playAskColor
% Ask the color for the human player and start the game with it.
playAskColor :-
          nl, write('Color for human player ? (x or o)'), nl,
          read(Player), nl,
          (
            Player \= o, Player \= x, !,     % If not x or o -> not a valid color
            write('Error : not a valid color !'), nl,
            playAskColor                     % Ask again
            ;
            EmptyBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0],
            show(EmptyBoard), nl,

            % Start the game with color and emptyBoard
            play([x, play, EmptyBoard], Player)
          ).


% play(+Position, +HumanPlayer)
% If next player to play in position is equal to HumanPlayer -> Human must play
% Ask to human what to do.
play([Player, play, Board], Player) :- !,
    nl, write('Next move ?'), nl,
    read(Pos), nl,                                  % Ask human where to play
    (
      humanMove([Player, play, Board], [NextPlayer, State, NextBoard], Pos), !,
      show(NextBoard),
      (
        State = win, !,                             % If Player win -> stop
        nl, write('End of game : '),
        write(Player), write(' win !'), nl, nl
        ;
        State = draw, !,                            % If draw -> stop
        nl, write('End of game : '),
        write(' draw !'), nl, nl
        ;
        play([NextPlayer, play, NextBoard], Player) % Else -> continue the game
      )
      ;
      write('-> Bad Move !'), nl,                % If humanMove fail -> bad move
      play([Player, play, Board], Player)        % Ask again
    ).



% play(+Position, +HumanPlayer)
% If it is not human who must play -> Computer must play
% Compute the best move for computer with minimax or alpha-beta.
play([Player, play, Board], HumanPlayer) :-
    nl, write('Computer play : '), nl, nl,
    % Compute the best move
    bestMove([Player, play, Board], [NextPlayer, State, BestSuccBoard]),
    show(BestSuccBoard),
    (
      State = win, !,                                 % If Player win -> stop
      nl, write('End of game : '),
      write(Player), write(' win !'), nl, nl
      ;
      State = draw, !,                                % If draw -> stop
      nl, write('End of game : '), write(' draw !'), nl, nl
      ;
      % Else -> continue the game
      play([NextPlayer, play, BestSuccBoard], HumanPlayer)
    ).



% nextPlayer(X1, X2)
% True if X2 is the next player to play after X1.
nextPlayer(o, x).
nextPlayer(x, o).

% When human play
humanMove([X1, play, Board], [X2, State, NextBoard], Pos) :-
    nextPlayer(X1, X2),
    set1(Pos, X1, Board, NextBoard),
    (
      winPos(X1, NextBoard), !, State = win ;
      drawPos(X1,NextBoard), !, State = draw ;
      State = play
    ).



% set1(+Elem, +Pos, +List, -ResList).
% Set Elem at Position Pos in List => Result in ResList.
% Rem : counting starts at 1.
set1(1, E, [X|Ls], [E|Ls]) :- !, X = 0.

set1(P, E, [X|Ls], [X|L2s]) :-
    number(P),
    P1 is P - 1,
    set1(P1, E, Ls, L2s).


% show(+Board)
% Show the board to current output.
show([X1, X2, X3, X4, X5, X6, X7, X8, X9]) :-
    write('   '), show2(X1),
    write(' | '), show2(X2),
    write(' | '), show2(X3), nl,
    write('  -----------'), nl,
    write('   '), show2(X4),
    write(' | '), show2(X5),
    write(' | '), show2(X6), nl,
    write('  -----------'), nl,
    write('   '), show2(X7),
    write(' | '), show2(X8),
    write(' | '), show2(X9), nl.



% show2(+Term)
% Write the term to current outupt
% Replace 0 by ' '.
show2(X) :-
    X = 0, !,
    write(' ').

show2(X) :-
    write(X).
