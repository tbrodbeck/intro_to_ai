/*
Design a music database similar to the movie database. Your database should contain
at least 4 artists
at least 3 songs for each artist
at least 2 different genres

The database should contain information about
what artists exist
what genres exist
which song is by which artist
which song belongs to which genre

You should be able to answer queries of the form
?-artist(A).
?-genre(G).
?-songIsBy(S,A).
?-songIsGenre(S,G).

Define a binary predicate performs such that

?-performs(A,G).

can be proved if there exists an artist A that performs genre G.

Use perform to define queries that answer the following questions:
which artists perform a particular genre from your database?
what genres does a particular artist from your database perform?
*/
artist(marteria).
artist(kendrickLamar).
artist(arcadeFire).
artist(redHotChilliPeppers).

genre(rap).
genre(rock).

songIsBy(aliens, marteria).
songIsBy(verstrahlt, marteria).
songIsBy(omg, marteria).
songIsGenre(aliens, rap).
songIsGenre(verstrahlt, rap).
songIsGenre(omg, rap).

songIsBy(moneyTrees, kendrickLamar).
songIsBy(compton, kendrickLamar).
songIsBy(humble, kendrickLamar).
songIsGenre(moneyTrees, rap).
songIsGenre(compton, rap).
songIsGenre(humble, rap).

songIsBy(noCarsGo, arcadeFire).
songIsBy(rokoko, arcadeFire).
songIsBy(readyToStart, arcadeFire).
songIsGenre(noCarsGo, rock).
songIsGenre(rokoko, rock).
songIsGenre(readyToStart, rock).

songIsBy(snow, redHotChilliPeppers).
songIsBy(californication, redHotChilliPeppers).
songIsBy(otherside, redHotChilliPeppers).
songIsGenre(snow, rock).
songIsGenre(californication, rock).
songIsGenre(otherside, rock).

performs(A,G) :- songIsBy(S,A), songIsGenre(S,G).
