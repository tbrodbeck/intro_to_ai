/*
Write a grammar which constructs syllables

Syllables have the following structure:

        onset nucleus coda.

The onset consists of consonants, the nucleus of vowels and the code again of consonants.

Write a grammar which constructs simple syllables where
- onset and coda have at most one consonant
- not onset and coda are both empty
- the nucleus has one or two vowels

Use the vowels: a, e, i, o, u
Use the consonants: b, d, f, g, h, k, l, m, n, p, r, s, t

Hint: In DCGs you may write rules of the form

   x --> [].

meaning that x expands to nothing.

Hint: Use an argument to encode that
- the onset is empty (which restricts the coda to be non empty)
- the onset is not empty (which doen't restrict the coda)
- the coda is empty (which restricts the onset to be non empty)
- the coda is not empty (which doesn't restrict the onset)
*/

v --> [a].
v --> [e].
v --> [i].
v --> [o].
v --> [u].

c --> [b].
c --> [d].
c --> [f].
c --> [g].
c --> [h].
c --> [k].
c --> [l].
c --> [m].
c --> [n].
c --> [p].
c --> [r].
c --> [s].
c --> [t].

% your codes goes here:
s --> [], nucleus, coda.
s --> onset, nucleus, [].
s --> onset, nucleus, coda.
onset --> c.
nucleus --> v.
nucleus --> v, v.
coda --> c.
