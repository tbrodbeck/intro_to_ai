/*
Your task is to define a binary predicate 'contains' that is true if the first
argument is a list and the second argument is an element in this list. You do
not have to deal with invalid inputs. Enter the following things into the text box below.


1. First, you are supposed to implement a recursive solution. Define the base
case(s) and the recursion case(s) in natural language.

2. Give a recursive Prolog implementation of contains.

3. Enter

trace.

in SWI Prolog in order to activate tracing. Then ask the following queries and
copy the output (for the first proof only) into the text field below.
contains([1,2,3],2).
contains([1,2,3],X).
contains(L,2).

4. Use the predicate 'sublistOf' from the course slides to implement contains
with a single rule. Call the predicate contains2 and enter the code.

5. Show the traces for the following queries as in task 3
contains2([1,2,3],2).
contains2([1,2,3],X).
contains2(L,2).
*/
contains([H|_],E) :- H = E.
contains([_|T], E) :- contains(T,E).

contains2(L,E) :- sublistOf([E|_],L).

sublistOf(L1,L2) :- append(L1,_,L2).
sublistOf(L1,[_|T]) :- sublistOf(L1,T).
