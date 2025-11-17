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