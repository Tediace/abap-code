CLASS zcl_root_shma DEFINITION.
    PUBLIC FINAL
    CREATE PUBLIC
    SHARED MEMORY ENABLED.
  
    PUBLIC SECTION.
      INTERFACES if_shm_build_instance.
  
      TYPES tty_/scwm/t300 TYPE TABLE OF /scwm/t300.
  
      DATA lt_/scwm/t300 TYPE tty_/scwm/t300.
  ENDCLASS.

CLASS ZCL_ROOT_SHMA IMPLEMENTATION.
    METHOD if_shm_build_instance~build.
      DATA lr_area TYPE REF TO zcl_root_shma_use.
      DATA lr_root TYPE REF TO zcl_root_shma.
      DATA lr_exp  TYPE REF TO cx_root.
  
      TRY.
          lr_area = zcl_root_shma_use=>attach_for_write( ).
        CATCH cx_shm_error INTO lr_exp.
          RAISE EXCEPTION NEW cx_shm_build_failed( previous = lr_exp ).
      ENDTRY.
  
      CREATE OBJECT lr_root AREA HANDLE lr_area.
      lr_area->set_root( lr_root ).
      lr_area->detach_commit( ).
    ENDMETHOD.
ENDCLASS.
  
  