report ztest_b.

TRY.
    DATA(lr_area) = zcl_root_shma_use=>attach_for_read(
*                        inst_name = cl_shm_area=>default_instance
                    ).
  CATCH cx_shm_inconsistent.          " Different definitions between program and area
  CATCH cx_shm_no_active_version.     " No active version exists for an attach
  CATCH cx_shm_read_lock_active.      " Request for a second read lock
  CATCH cx_shm_exclusive_lock_active. " Instance already locked
  CATCH cx_shm_parameter_error.       " Incorrect parameter passed
  CATCH cx_shm_change_lock_active.    " A change lock is already active
ENDTRY.

DATA lr_root TYPE REF TO zcl_root_shma.

TRY.
    lr_root ?= lr_area->get_root( ).
  CATCH cx_shm_already_detached.      " Handle already released
ENDTRY.

DATA gt_t300 TYPE lr_root->tty_/scwm/t300.

TRY.
    gt_t300 = lr_root->lt_/scwm/t300.

    lr_area->detach( ).
  CATCH cx_shm_wrong_handle.
  CATCH cx_shm_already_detached.
ENDTRY.
