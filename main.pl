my_length([], 0).
my_length([_|T], R) :-
    my_length(T, R1),
    R is R1 + 1.

my_member(A, [A|_]).
my_member(A, [_|T]) :-
    my_member(A, T).

my_append([], L, L).
my_append([H|T], L2, [H|R]) :-
    my_append(T, L2, R).

my_reverse(L, R) :- 
    my_rev_(L, [], R).
my_rev_([], Acc, Acc).
my_rev_([H|T], Acc, R) :-
    my_rev_(T, [H|Acc], R).

my_nth(L, 1, L) :- !.
my_nth([], _, []) :- !.
my_nth([_|T], N, R) :-
    N > 1,
    N1 is N - 1,
    my_nth(T, N1, R).

my_remove(_, [], []).
my_remove(X, [X|T], R) :- !,
    my_remove(X, T, R).
my_remove(X, [H|T], [H|R]) :-
    H \= X,
    my_remove(X, T, R).
