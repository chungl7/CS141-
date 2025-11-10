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


my_subst(_, _, [], []).
my_subst(X, Y, [X|T], [Y|R]) :- !,
    my_subst(X, Y, T, R).
my_subst(X, Y, [H|T], [H|R]) :-
    H \= X,
    my_subst(X, Y, T, R).


my_subset(_, [], []).
my_subset(P, [H|T], [H|R]) :-
    Goal =.. [P, H],
    call(Goal), !,
    my_subset(P, T, R).
my_subset(P, [_|T], R) :-
    my_subset(P, T, R).

my_add(A, B, R0) :-
    my_add_carry(A, B, 0, R1),
    ( R1 = [] -> R0 = [0]
    ; R0 = R1
    ).

my_add_carry([], [], 0, []) :- !.
my_add_carry([], [], Carry, [Carry]) :- 
    Carry > 0, !.
my_add_carry([D1|T1], [], Carry, [D|R]) :-
    S is D1 + Carry,
    D is S mod 10,
    C1 is S // 10,
    my_add_carry(T1, [], C1, R).
my_add_carry([], [D2|T2], Carry, [D|R]) :-
    S is D2 + Carry,
    D is S mod 10,
    C1 is S // 10,
    my_add_carry([], T2, C1, R).
my_add_carry([D1|T1], [D2|T2], Carry, [D|R]) :-
    S is D1 + D2 + Carry,
    D is S mod 10,
    C1 is S // 10,
    my_add_carry(T1, T2, C1, R).

my_merge([], L, L) :- !.
my_merge(L, [], L) :- !.
my_merge([H1|T1], [H2|T2], [H1|R]) :-
    H1 =< H2, !,
    my_merge(T1, [H2|T2], R).
my_merge([H1|T1], [H2|T2], [H2|R]) :-
    H1 > H2,
    my_merge([H1|T1], T2, R).





