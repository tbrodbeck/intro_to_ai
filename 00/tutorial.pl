max2([H|T], Max) :- acc_max([H|T], H, Max).

acc_max([], Acc, Acc).
acc_max([H|T], Acc, H) :- H > Acc, acc_max(T, Acc, Max).
acc_max([H|T], Acc, T_Max) :- acc_max(T, Acc, T_Max); H =< T_Max.
