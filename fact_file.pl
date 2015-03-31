% Author: O. Brochu Dufour, M. Mowbray
% Date: 29-03-2015

%% % % % % % % % % % %
%% Facts file
%% %% %% %% %% %% %% %

%% % % % % % % % % % %
%% States
%% % % % % % % % % % %

%% Top-level states
state(dormant).
state(init).
state(idle).
state(monitoring).
state(error_diagnosis).
state(safe_shutdown).
state(system_exit).

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

%% States under error_diagnosis state
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).
state(lockdown_exit).
state(error_diagnosis_exit).

%% States under lockdown state
state(prep_vpurge).
state(alt_temp).
state(alt_psi).
state(risk_assess).
state(safe_status).

%% % % % % % % % % % %
%% Initial States
%% % % % % % % % % % %

%% Initial States
initial_state(boot_hw, init).
initial_state(mon_idle, monitoring).
initial_state(dormant, null).

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

%% Transition from top-level state

transition(system, system_exit, kill, null, null).

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

%% Transitions within the lockdown state

transition(prep_vpurge, alt_temp, initiate_purge, null, lock_doors).
transition(prep_vpurge, alt_psi, initiate_purge, null, lock_doors).
transition(alt_temp, risk_assess, tcyc_comp, null, null).
transition(alt_psi, risk_assess, initiate_purge, null, null).
transition(safe_status, null, null, unlock_doors, lockdown_exit).

%% Transitions within the error_diagnosis state

transition(error_rcv, applicable_rescue, null, 'err_protocol_def = true', null).
transition(error_rcv, reset_module_data, null, 'err_protocol_def = fale', null).
transition(applicable_rescue, error_diagnosis_exit, apply_protocol_rescues, null null).
transition(reset_module_data, error_diagnosis_exit, reset_to_stable, null null).
