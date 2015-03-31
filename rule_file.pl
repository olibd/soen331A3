% Author: O. Brochu Dufour, M. Mowbray
% Date: 29-03-2015

%% % % % % % % % % % %
%% Rules file
%% % % % % % % % % % %

is_loop(Event, Guard) :- transition(X, Y, Event, Guard, _), X == Y.

all_loops(Set) :- findall([X,Y], is_loop(X, Y),Lst), list_to_set(Lst, Set).

is_edge(Event, Guard):- transition(_, _, Event, Guard, _).

size(Length):- findall(_, is_edge(_,_),Lst), length(Lst, Length).

is_link(Event, Guard):- transition(X, Y, Event, Guard, _), X \== Y.

all_superstates(Set):- findall(X, superstate(X,_), Lst), list_to_set(Lst, Set).

ancestor(Ancestor, Descendant):- superstate(Ancestor, Descendant).

ancestor(Ancestor, Descendant):- superstate(Ancestor, X), ancestor(X, Descendant).

ancestor_transitions(State, Tran) :- ancestor(X, State), transition(X, Y, _, _, _), Tran = [X, Y].
ancestor_transitions(State, Tran) :- ancestor(X, State), transition(Y, X, _, _, _), Tran = [Y, X].

inheritss_transitions(State, List):- findall(Tran, ancestor_transitions(State, Tran), List).

all_states(L) :- findall(State, state(State), L).