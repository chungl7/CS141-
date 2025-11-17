eval(N, N) :-
    integer(N), !.


eval(E1 + E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 + V2.

eval(E1 - E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1-V2.

eval(E1 * E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 * V2.

eval(E1 / E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 // V2.

eval(E1 ^ E2, V) :-
    eval(E1, V1),
    eval(E2, V2),
    V is V1 ^ V2.

simplify(E, S) :-
    ground(E),
    eval(E, S), !.

simplify(E, E) :-
    number(E), !.

simplify(E, E) :-
    atom(E), !.

simplify(A + B, S) :-
    simplify(A, S1),
    simplify(B, S2),
    simplify_plus(S1, S2, S).

simplify(A - B, S) :-
    simplify(A, S1),
    simplify(B, S2),
    simplify_minus(S1, S2, S).


simplify(A * B, S) :-
    simplify(A, S1),
    simplify(B, S2),
    simplify_times(S1, S2, S).

simplify(A / B, S) :-
    simplify(A, S1),
    simplify(B, S2),
    simplify_divide(S1, S2, S).

simplify(A ^ B, S) :-
    simplify(A, S1),
    simplify(B, S2),
    simplify_power(S1, S2, S).


simplify_plus(A, B, S) :-
    number(A),
    number(B), !,
    S is A + B.
simplify_plus(0, B, B) :- !.
simplify_plus(A, 0, A) :- !.
simplify_plus(A, B, A + B).

simplify_minus(A, B, S) :-
    number(A), 
    number(B), !,
    S is A - B.
simplify_minus(A, 0, A) :- !.
simplify_minus(A, A, 0) :- !.
simplify_minus(A, B, A - B).

simplify_times(A, B, S) :-
    number(A),
    number(B),
    S is A * B.
simplify_times(0, _, 0) :- !.
simplify_times(_, 0, 0) :- !.
simplify_times(1, B, B) :- !.
simplify_times(A, 1, A) :- !.
simplify_times(A, B, A * B).


simplify_divide(A, B, S) :-
    number(A),
    number(B),
    B =\= 0, !,
    S is A // B.
simplify_divide(0, _, 0) :- !.
simplify_divide(A, 1, A) :- !.
simplify_divide(A, A, 1) :- !.
simplify_divide(A, B, A / B).


simplify_power(A, B, S) :-
    number(A),
    number(B), !,
    S is A ^ B.
simplify_power(_, 0, 1) :- !.
simplify_power(A, 1, A) :- !.
simplify_power(A, B, A ^ B).
