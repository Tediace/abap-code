REPORT ZTEST_A.

TRY.
    zcl_root_shma_use=>build( inst_name = cl_shm_area=>default_instance ).
  CATCH cx_shma_not_configured.
  CATCH cx_shma_inconsistent.
  CATCH cx_shm_build_failed.

ENDTRY.

TRY.
    DATA(lr_area) = zcl_root_shma_use=>attach_for_update(
*                      inst_name   = cl_shm_area=>default_instance
*                      attach_mode = cl_shm_area=>attach_mode_default
*                      wait_time   = 0
                    ).
  CATCH cx_shm_inconsistent.            " Different definition between program and area
  CATCH cx_shm_no_active_version.       " No active version exists for an attach
  CATCH cx_shm_exclusive_lock_active.   " Instance already locked
  CATCH cx_shm_version_limit_exceeded.  " No additional versions available
  CATCH cx_shm_change_lock_active.      " A write lock is already active
  CATCH cx_shm_parameter_error.         " Passed parameter has incorrect value
  CATCH cx_shm_pending_lock_removed.    " Shared objects: waiting lock was deleted
ENDTRY.

DATA lr_root TYPE REF TO zcL_root_shma.

TRY.
    lr_root ?= lr_area->get_root( ).
  CATCH cx_shm_already_detached.
ENDTRY.

DATA it_t300 TYPE lr_root->tty_/scwm/t300.

SELECT * FROM /scwm/t300
  UP TO 10 ROWS
  INTO TABLE @lr_root->lt_/scwm/t300.

TRY.
*    lr_root->lt_/scwm/t300 = it_t300.
    lr_area->set_root( lr_root ).
    lr_area->detach_commit( ).
  CATCH cx_shm_wrong_handle.
  CATCH cx_shm_already_detached.
  CATCH cx_shm_secondary_commit.
  CATCH cx_shm_event_execution_failed.
  CATCH cx_shm_completion_error.
ENDTRY.
