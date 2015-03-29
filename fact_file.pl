% Author: O. Brochu Dufour, M. Mowbray
% Date: 29-03-2015

%% Facts

%% Top-level states

state(dormant).
state(init).
state(idle).
state(monitoring).
state(safe_shutdown).
state(error_diagnosis).

%% Transitions within the top-level

transition(dormant, init, start, null, null).
transition(init, idle, init_ok, null, null).
transition(idle, monitoring, begin_monitoring, null, null).
transition(init, error_diagnosis, init_crash, null, 'broadcast init_err_msg').
transition(error_diagnosis, init, retry_init, 'retry<3', 'retry++').
transition(error_diagnosis, safe_shutdown, shutdown, 'retry>=3', null).
transition(shutdown, dormant, sleep, null, null).
transition(idle, error_diagnosis, idle_crash, null, 'broadcast idle_err_msg').
transition(error_diagnosis, idle, idle_rescue, null, null).
transition(monitoring, error_diagnosis, monitor_crash, null, moni_err_msg).
transition(error_diagnosis, monitoring, moni_rescue, null, null).

%% eof