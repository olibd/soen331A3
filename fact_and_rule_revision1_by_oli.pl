% Author: O. Brochu Dufour, M. Mowbray
% Date: 29-03-2015
%% %% %% %% 
%% Facts file
%% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% 


%% % % % % % % % % % %
%% States
%% % % % % % % % % % %

%% Top-level states
state(dormant).
state(init).
state(idle).
state(monitoring).

%% States under init state
state(boot_hw).
state(senchk).
state(tchk).
state(psichk).
state(ready).

%% States under monitoring state
state(mon_idle).
state(regulate_environment).
state(lockdown).


%% % % % % % % % % % %
%% Initial States
%% % % % % % % % % % %

%% Initial States
initial_state(boot_hw, init).
initial_state(mon_idle, monitoring).

%% % % % % % % % % % %
%% Superstates
%% % % % % % % % % % %

%% Superstates of init
superstate(init, boot_hw).
superstate(init, senchk).
superstate(init, tchk).
superstate(init, psichk).
superstate(init, ready).

%test superstates
%superstate(init2, init).
%superstate(init3, init2).

%% % % % % % % % % % %
%% Transitions
%% % % % % % % % % % %

%% Transitions within init state
transition(boot_hw, senchk, hw_ok, null, null).
transition(senchk, tchk, senok, null, null).
transition(tchk, psichk, t_ok, null, null).
transition(psichk, ready, psi_ok, null, null).

%% Transitions within monitoring state
transition(mon_idle, regulate_environment, no_contagion, null, null).
transition(regulate_environment, mon_idle, after_100ms, null, null).
transition(mon_idle, lockdown, contagion_alert, null, ('broadcast FACILITY_CRIT_MESG'; inlockdown = true)).
transition(lockdown, mon_idle, purge_succ, null, inlockdown = false).

%test loop
%transition(init2, s1, a, b, null).
%transition(s2, init2, c, d, null).
%transition(init3, s3, f, g, null).
%transition(s3, init3, f, g, null).


% Author: O. Brochu Dufour, M. Mowbray
% Date: 29-03-2015
%% %% %% %% 
%% Rules file
%% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% %% 

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







