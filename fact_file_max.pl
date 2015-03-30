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

%% Transitions within the top-level (system) state

transition(dormant, init, start, null, null).
transition(init, idle, init_ok, null, null).
transition(idle, monitoring, begin_monitoring, null, null).
transition(init, error_diagnosis, init_crash, null, 'broadcast init_err_msg').
transition(error_diagnosis, init, retry_init, 'retry<3', 'retry++').
transition(error_diagnosis, safe_shutdown, shutdown, 'retry>=3', null).
transition(shutdown, dormant, sleep, null, null).
transition(idle, error_diagnosis, idle_crash, null, 'broadcast idle_err_msg').
transition(error_diagnosis, idle, idle_rescue, null, null).
transition(monitoring, error_diagnosis, monitor_crash, 'inlockdown=false', moni_err_msg).
transition(error_diagnosis, monitoring, moni_rescue, null, null).
transition(system, system_exit, kill, null, null).

%% Transitions within the init state

% Oli did this already

%% Transitions within the lockdown state

transition(prep_vpurge, alt_temp, initiate_purge, null, lock_doors).
transition(prep_vpurge, alt_psi, initiate_purge, null, lock_doors).
transition(alt_temp, risk_assess, tcyc_comp, null, null).
transition(alt_psi, risk_assess, initiate_purge, null, null).

%% Transitions within the monitoring state

%Oli doing this

%% Transitions within the error_diagnosis state

transition(error_rcv, applicable_rescue, null, 'erro_protocol_def = true', null).
transition(error_rcv, reset_module_data, null, 'erro_protocol_def = false', null).
transition(applicable_rescue, error_diagnosis_exit, apply_protocol_rescues, null, null).
transition(reset_module_data, error_diagnosis_exit, reset_to_stable, null, null).

%% eof