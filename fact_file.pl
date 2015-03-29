% Author: O. Brochu Dufour, M. Mowbray
% Date: 29-03-2015

%% Facts

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

%% Initial States
initial_state(boot_hw, init)

%% Transitions within init state
transition(boot_hw, senchk, hw_ok, null, null).
transition(senchk, tchk, senok, null, null).
transition(tchk, psichk, t_ok, null, null).
transition(psichk, rwady, psi_ok, null, null).