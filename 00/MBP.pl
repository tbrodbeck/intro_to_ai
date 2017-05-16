% So I listed almost every possible move of the monkey:
% Going to: left-down, mid-down, right-down (LD, MD, RD)
% Moving crate: left, mid, right (LC, MC, RC)
% Going up (UU) and going down (DD)
%
%
% move monkey
rs(left, down, C, B, avlb, MD, RD, LC, MC, RC, UU, DD) :-
  rs(_HP, down, C, B, done, MD, RD, LC, MC, RC, UU, DD).
rs(middle, down, C, B, LD, avlb, RD, LC, MC, RC, UU, DD) :-
  rs(_HP, down, C, B, LD, done, RD, LC, MC, RC, UU, DD).
rs(right, down, C, B, LD, LM, avlb, LC, MC, RC, UU, DD) :-
  rs(_HP, down, C, B, LD, LM, done, LC, MC, RC, UU, DD).
% move crate
rs(left, down, left, B, LD, LM, RD, avlb, MC, RC, UU, DD) :-
  rs(HP, down, HP, B, LD, LM, RD, done, MC, RC, UU, DD).
rs(middle, down, middle, B, LD, LM, RD, LC, avlb, RC, UU, DD) :-
  rs(HP, down, HP, B, LD, LM, RD, LC, done, RC, UU, DD).
rs(right, down, right, B, LD, LM, RD, LC, MC, avlb, UU, DD) :-
  rs(HP, down, HP, B, LD, LM, RD, LC, MC, done, UU, DD).
% climb up / down
rs(HP, up, HP, B, LD, LM, RD, LC, MC, RC, avlb, DD) :-
  rs(HP, down, HP, B, LD, LM, RD, LC, MC, RC, done, DD).
rs(HP, down, HP, B, LD, LM, RD, LC, MC, RC, UU, avlb) :-
  rs(HP, up, HP, B, LD, LM, RD, LC, MC, RC, UU, done).
% grab
rs(middle, up, middle, has) :-
  rs(middle, up, middle, has_not, _LD, _LM, _RD, _LC, _MC, _RC, _UU, _DD).
% start situation
rs(left, down, right, has_not, _LD, _LM, _RD, _LC, _MC, _RC, _UU, _DD).
