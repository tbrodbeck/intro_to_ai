% Introduction to AI, 12: DCGs
% simple grammar for a fragment of english

% Assignment 06, Task 02

% Extend the grammar below to:
%
% 1. Produce a semantic representation of all recognized sentences.
% Exampl: ?- s(Sem, [john,likes,mary],[]). Sem=like(john,mary)
%
% 3. Add a knowledge base (normal prolog predicates) to the program that relates
% to these semantic representations. Examples: sleep(john). like(john,mary).
% Add a predicate eval/1 that checks if a semantic representation
% produced by the dcg is provable from the knowledge base.
%
% Example:
%
% sleeps(john). % only fact in knowledge base
%
% ?- s(Sem,[john,sleeps],[]), eval(Sem).
% Sem=sleeps(john)
% true
% ?- s(Sem,[mary,sleeps],[]), eval(Sem).
% false
%
% Hints:
% - you may use call/1 for querying the knowledge base and ..=
% for constructing representations
% - find a good solution for dealing with adjectives and definite/indefinite articles

% the knowledge base
sleeps(john). % john sleeps, but mary does not
likes(john, book(_)). % john likes all books
likes(mary, table(green)). % mary likes green tables

% the grammar

% verbs are used as functors, subject and object are arguments:
% john likes the red table ==> likes(john,table(red))
s(Sem) --> np(Subj), vp(V,Obj), {Sem =.. [V,Subj,Obj]}.
s(Sem) --> np(Subj), vp(V), {Sem =.. [V,Subj]}.

% if we have no adjective, we represent it as unspecified
% all determiners are treated as 'a'
% the book ==> book(_), a book ==> book(_)
% the red book ==> book(red), a green table ==> table(green)
np(Sem) --> det(_), n(N), { Sem =.. [N,_] }.
np(Sem) --> det(_), a(A), n(N), { Sem =.. [N,A] }.
np(PN) --> pn(PN). % proper noun

n(N) --> cn(N). % countable noun
vp(V) --> iv(V).
vp(V,Obj) --> tv(V), np(Obj).

iv(sleeps) --> [sleeps].
tv(likes) --> [likes].
tv(hates) --> [hates].
det(def) --> [the].
det(indef) --> [a].
a(red) --> [red].
a(green) --> [green].
cn(book) --> [book].
cn(table) --> [table].
pn(john) --> [john].
pn(mary) --> [mary].

% eval predicate
eval(Sem) :-
call(Sem).


% tests
test :-
s(Sem1,[john,likes,the,red,book],[]), eval(Sem1),
s(Sem2,[john,likes,the,green,book],[]), eval(Sem2),
s(Sem3,[mary,likes,the,red,book],[]), not(eval(Sem3)),
s(Sem4,[mary,likes,the,green,table],[]), eval(Sem4),
s(Sem5,[mary,likes,a,table],[]), eval(Sem5),
s(Sem6,[john,likes,a,table],[]), not(eval(Sem6)),
s(Sem7,[john,sleeps],[]), eval(Sem7),
s(Sem8,[mary,sleeps],[]), not(eval(Sem8)).
