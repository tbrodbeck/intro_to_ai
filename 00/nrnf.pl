toNRNF(A,A) :- atomic(A).  % base case

toNRNF(not(A),not(A)) :- atomic(A).  % recursion cases
toNRNF(not(and(F1,F2)), not(and(not(NF1),not(NF2)))) :- toNRNF(not(F1),NF1),toNRNF(not(F2),NF2).
toNRNF(not(or(F1,F2)), and(NF1,NF2)) :- toNRNF(not(F1),NF1),toNRNF(not(F2),NF2).
toNRNF(not(implies(F1,F2)), and(NF1,NF2)) :- toNRNF(F1,NF1),toNRNF(not(F2),NF2).
toNRNF(not(equiv(F1,F2)), not(and(not(NF1),not(NF2)))) :- toNRNF(not(implies(F1,F2)),NF1), toNRNF(not(implies(F2,F1)),NF2).

toNRNF(and(F1,F2), and(NF1,NF2)) :- toNRNF(F1,NF1),toNRNF(F2,NF2).
toNRNF(or(F1,F2), not(and(not(NF1),not(NF2)))) :- toNRNF(F1,NF1),toNRNF(F2,NF2).
toNRNF(implies(F1,F2), NF) :- toNRNF(or(not(F1),F2),NF).
toNRNF(equiv(F1,F2), NF) :- toNRNF(and(implies(F1,F2),implies(F2,F1)),NF).
