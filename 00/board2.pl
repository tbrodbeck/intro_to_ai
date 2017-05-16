% representing the problem
% -------------------------

% these boards are already adjusted for
% the 3-piece-tokens!

board(1,[             % 4x6 = 24 fields = 8 3-piece tokens
  [_,_,_,_,_,_],
  [_,_,_,_,_,_],
  [_,_,_,_,_,_],
  [_,_,_,_,_,_]]).

% a less complex problem

board(2,[ % 3x2
  [_,_,_],
  [_,_,_]]).

board(3,[ % 4x4-1 = 15 fields = 5 3-piece tokens
  [_,_,_,_],
  [_,_,_,_],
  [_,_,_,_],
  [_,_,_,x]]).

board(4, [ % 5x4 - 2 = 18 fields = 6 3-piece-tokens
  [_,_,_,_,x],
  [_,_,_,_,_],
  [_,_,_,_,_],
  [_,_,_,_,x]]).

board(5, [ % 5x4 - 5 = 15 fields = 5 3-piece-tokens
  [x,_,x,_,x],
  [_,_,_,_,_],
  [_,_,_,_,_],
  [x,_,_,_,x]]).

board(6,[            % 6x6 = 36 fields = 12 3-piece tokens
  [_,_,_,_,_,_],
  [_,_,_,_,_,_],
  [_,_,_,_,_,_],
  [_,_,_,_,_,_],
  [_,_,_,_,_,_],
  [_,_,_,_,_,_]]).    % WARNING: This may take some time...


% x marks fields, which are removed

% the blocks we need.
% if we can place all blocks
% the board will be covered!
% we will place a block by unifying its number
% with the fields it covers, therefore
% a covered field, cannot be covered by an other block
% (with a different number).

blocks(1, [1,2,3,4,5,6,7,8]).  % we need 8 blocks to cover board 1
blocks(2, [1,2]). % we need two blocks for problem 2
blocks(3, [1,2,3,4,5]). % we need 5 blocks for problem 3
blocks(4, [1,2,3,4,5,6]). % 6 blocks for problem 4
blocks(5, [1,2,3,4,5]). % we need 5 blocks for problem 3
blocks(6, [1,2,3,4,5,6,7,8,9,a,b,c]).  % we need 4 blocks to cover board 1

% ----------------------------------------------
% solve the problem top down
% ----------------------------------------------

cover(N,Board) :-
  board(N,Board),            % specify the board
  blocks(N,Blocks),          % specify the blocks to use
  test_cover(Blocks,Board).  % check if a covering exists

test_cover([],_Board).               % all blocks placed, the board is coverd!
test_cover([Block|Rest],Board) :-    % put next block
  place(Block,Board),
  test_cover(Rest,Board).            % and check if the rest can be covered

% TASK: change the place/2 predicate to
% place 3-piece-tokens instead of 2-piece-tokens.
%
% The 3-piece-tokens have 4 different placements:
%
% rotation 1
%
%    X X
%    X
%
% rotation 2
%
%    X X
%      X
%
% place rotation 3
%
%      X
%    X X
%
% place rotation 4
%
%    X
%    X X
%
% So, a solution for board 2 would be:
%
% [ 1, 1, 2 ]
% [ 1, 2, 2 ]
%

% ----------------------------------------------------------------------
% NO NEED TO CHANGE BEFORE THIS LINE

% try placing it in a 2x2 region

place(Block,[Row1, Row2|_Rest]) :- % we may place it in the first two rows
  place_c(Block, Row1, Row2).
place(Block,[_Row|Rest]) :- % we may place it somewhere else
  place(Block,Rest).

% we may place it in the first 2 columns
place_c(Block,[Block, Block|_R1],[Block, _|_R2]).  % in Rotation 1
place_c(Block,[Block, Block|_R1],[_, Block|_R2]).  % in Rotation 2
place_c(Block,[_, Block|_R1],[Block, Block|_R2]).  % in Rotation 3
place_c(Block,[Block, _|_R1],[Block, Block|_R2]).  % in Rotation 4
place_c(Block,[_F1|R1],[_F2|R2]) :-     % we may place it somewhere else
  place_c(Block,R1,R2).

% NO NEED TO CHANGE BELOW THIS LINE
% ----------------------------------------------------------------------

% helper for pretty printing (i/o will be covered later!)
print_board([]) :- nl.
print_board([H|T]) :- write(H), nl, print_board(T).

% solve/1 - Try to solve and pretty print first solution.
solve(Number) :-
    cover(Number, Board),
    print_board(Board).

% ---------------------------------------------------
% this is a very typical program structure in prolog!
%
% queries:
% cover(1,Board).
% cover(2,Board).
%
% or:
% solve(1).
%----------------------------------------------------
