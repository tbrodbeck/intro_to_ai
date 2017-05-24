% Introduction to AI, 12: DCGs
% simple grammar for a fragment of english

% Assignment 06, Task 02

% Extend the grammar below to:
%
% 1. Produce a semantic representation of all recognized sentences.
%    Example: ?- s(Sem, [john,likes,mary]). Sem=like(john,mary)
%
% 2. Add a knowledge base (normal prolog predicates) to the program that relates
%    to these semantic representations.
%    Examples: sleep(john). like(john,mary). hate(john,book1). book(book1,red).
%    Add a predicate eval/1 that checks if a semantic representation
%    produced by the dcg is provable from the knowledge base.
%
% You have to include meaningful comments and query examples.
%
% Example:
% book(book1, red). % book1 is a red book.
% likes(john,Book) :- book(_,green). % john likes green books.
% sleeps(john). % only sleep/1 fact in knowledge base
%
% ?- s(Sem,[john,sleeps],[]), eval(Sem).
% Sem=sleeps(john)
% true
% ?- s(Sem,[mary,sleeps],[]), eval(Sem).
% false
%
% Hints:
% - you may use call/1 for querying the knowledge base and =..
%   for constructing representations
% - you can ignore the difference between definite and indefinite articles (a/the),
%   so "John likes a book" is the same as "John likes the book"

% knowledge base
sleeps(john).
like(john,mary).
hate(john,book1).
book(book1,red).

% evaluate
eval(X) :- call(X),!,print(true).
eval(_) :- print(false).

% grammar
s(Sem) --> np(X), vp(Y), {append(Y,X,L), Sem=..L}.
np(X) --> pn(X). % proper noun
np(L) --> det(X), n(Y), {append(X,Y,L)}.
np(L) --> det(X), a(Y), n(Z), {append(X,Y,L1), append(L1,Z,L)}.
n(X) --> cn(X). % countable noun
vp(X) --> iv(X).
vp(L) --> tv(X), np(Y), {append(X,Y,L)}.
iv([sleeps])-->[sleeps].
tv([likes])-->[likes].
tv([hates])-->[hates].
det([the]) -->[the].
det([a]) --> [a].
a([green]) --> [green].
a([red]) --> [red].
cn([book])-->  [book].
cn([table])-->  [table].
pn([john]) --> [john].
pn([mary]) --> [mary].
