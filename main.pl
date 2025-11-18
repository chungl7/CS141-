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
simplify_plus(A, B, S) :-
    B = (K / Val),
    number(K),
    K < 0, !,
    K1 is -K,
    S = A - K1 / Val.

simplify_plus(A, B, A + B).

simplify_minus(A, B, S) :-
    number(A), 
    number(B), !,
    S is A - B.
simplify_minus(A, 0, A) :- !.
simplify_minus(A, A, 0) :- !.

simplify_minus(A, B, S) :-
    B = (K / Val),
    number(K),
    K < 0, !,
    K1 is -K,
    simplify_plus(A, K1 / Val, S).

simplify_minus(A, B, A - B).

simplify_times(A, B, S) :-
    number(A),
    number(B), !,
    S is A * B.
simplify_times(0, _, 0) :- !.
simplify_times(_, 0, 0) :- !.
simplify_times(1, B, B) :- !.
simplify_times(A, 1, A) :- !.

simplify_times(A, B, S) :-
    number(A),
    B = K * R,
    number(K), !.
    C is A * K,
    simplify_times(C, R, S).

simplify_times(A, B, S) :-
    number(B), 
    \+ number(A), !,
    simplify_times(B, A, S).

simplify_times(A, B, A * B).


simplify_divide(A, B, S) :-
    number(A),
    number(B),
    B =\= 0, !,
    S is A // B.
simplify_divide(0, _, 0) :- !.
simplify_divide(A, 1, A) :- !.
simplify_divide(A, A, 1) :- !.
simplify_divide(A * B, B, A) :- !.
simplify_divide(B * A, B, A) :- !.
simplify_divide(A, B, A / B).


simplify_power(A, B, S) :-
    number(A),
    number(B), !,
    S is A ^ B.
simplify_power(_, 0, 1) :- !.
simplify_power(A, 1, A) :- !.
simplify_power(A, B, A ^ B).


deriv(E, D) :-
    simplify(E, Es),
    deriv_help(Es, D0),
    simplify(D0, D).

deriv_help(K * x, K) :-
    number(K), !.

deriv_help(N, 0) :-
    number(N), !.

deriv_help(x, 1) :- !.

deriv_help(V, 0) :-
    atom(V),
    V \= x, !.

deriv_help(K / (x ^ N), D) :-
    number(K),
    integer(N), 
    N > 0, !,
    K1 is -K * N,
    N1 is N + 1,
    D = K1 / (x ^ N1).

deriv_help(K * (x ^ N), D) :-
    number(K),
    integer(N),
    N > 0, !,
    C is K * N,
    N1 is N - 1,
    ( N1 = 0 -> D = C
    ; D = C * (x ^ N1)
    ).

deriv_help(K / x, D) :-
    number(K), !,
    K1 is -K,
    D = K1 / (x ^ 2).

deriv_help(A + B, D1 + D2) :-
    deriv_help(A, D1),
    deriv_help(B, D2).

deriv_help(A - B, D1 - D2) :-
    deriv_help(A, D1),
    deriv_help(B, D2).

deriv_help(A * B, A * D2 + B * D1) :-
    deriv_help(A, D1),
    deriv_help(B, D2).

deriv_help(A ^ N, N * A ^ N1 * DA) :-
    integer(N),
    N > 0,
    N1 is N - 1,
    deriv_help(A, DA).

deriv_help(A / B, (D1 * B - A * D2) / (B ^ 2)) :-
    deriv_help(A, D1),
    deriv_help(B, D2).

guest(X) :-
    male(X).

guest(X) :-
    female(X).

party_seating(L) :-
    findall(G, guest(G), Guests),
    permute_helper(Guests, L),
    length_helper(L, 10),
    valid_seating_helper(L), !.

permute_helper([], []).
permute_helper(L, [X|R]) :-
    select(X, L, L1),
    permute_helper(L1, R).

select(X, [X|T], T).
select(X, [H|T], [H|R]) :-
    select(X, T, R).

valid_seating_helper(L) :-
    no_females(L),
    same_language(L).

no_females([H|T]) :-
    last_element([H|T], Last),
    no_females_linear([H|T]),
    \+ (female(H), female(Last)).

no_females_linear([_]).
no_females_linear([A,B|T]) :-
    \+ (female(A), female(B)),
    no_females_linear([B|T]).

same_language([H|T]) :-
    last_element([H|T], Last),
    same_language_linear([H|T]),
    common_language(Last, H).

same_language_linear([_]).
same_language_linear([A,B|T]) :-
    common_language(A, B),
    same_language_linear([B|T]).

common_language(A, B) :-
    speaks(A, L),
    speaks(B, L).

last_element([X], X).
last_element([_|T], X) :-
    last_element(T, X).
