REPORT yr_game_of_life_al1_nmelliti.

INTERFACE lif_cell_state.
  TYPES:
    BEGIN OF ENUM state BASE TYPE i,
      empty VALUE IS INITIAL,
      live  VALUE 1,
      died  VALUE 2,
    END OF ENUM state.
ENDINTERFACE.

CLASS lcl_cell DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING iv_state TYPE lif_cell_state=>state,
      change_state IMPORTING iv_state TYPE lif_cell_state=>state,
      get_actual_state RETURNING VALUE(rv_result) TYPE lif_cell_state=>state.
  PRIVATE SECTION.
    DATA mv_state TYPE lif_cell_state=>state.
ENDCLASS.

CLASS lcl_cell IMPLEMENTATION.

  METHOD constructor.
    mv_state = iv_state.
  ENDMETHOD.

  METHOD change_state.
    mv_state = iv_state.
  ENDMETHOD.

  METHOD get_actual_state.
    rv_result = mv_state.
  ENDMETHOD.

ENDCLASS.

INTERFACE lif_board_type.
  TYPES : BEGIN OF ty_board_type,
            column1 TYPE REF TO lcl_cell,
            column2 TYPE REF TO lcl_cell,
            column3 TYPE REF TO lcl_cell,
          END OF ty_board_type,
          tty_board_type TYPE TABLE OF ty_board_type WITH DEFAULT KEY.
  CONSTANTS : number_of_lines_board   TYPE i VALUE 3,
              number_of_columns_board TYPE i VALUE 3.
ENDINTERFACE.

CLASS lcl_board DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING it_board TYPE lif_board_type=>tty_board_type,
      get_actual_board RETURNING VALUE(rt_result) TYPE lif_board_type=>tty_board_type,
      get_column_name IMPORTING iv_index_column  TYPE syst-index
                      RETURNING VALUE(rv_result) TYPE string,
      number_of_neighboor IMPORTING iv_index_lines   TYPE syst-index
                                    iv_index_column  TYPE syst-index
                          RETURNING VALUE(rv_result) TYPE i.

  PRIVATE SECTION.
    DATA mt_board TYPE lif_board_type=>tty_board_type.
ENDCLASS.

CLASS lcl_board IMPLEMENTATION.

  METHOD constructor.
    mt_board = it_board.
  ENDMETHOD.

  METHOD get_actual_board.
    rt_result = mt_board.
  ENDMETHOD.

  METHOD get_column_name.
    rv_result = |COLUMN| && iv_index_column.
  ENDMETHOD.

  METHOD number_of_neighboor.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS : next_generation,
      actual_board RETURNING VALUE(rt_result) TYPE lif_board_type=>tty_board_type,
      constructor IMPORTING io_board TYPE REF TO lcl_board.

  PRIVATE SECTION.
    DATA mo_board TYPE REF TO lcl_board.
    METHODS process_line
      IMPORTING
        iv_index_lines TYPE syst-index.
    METHODS process_cell
      IMPORTING
        iv_index_lines  TYPE syst-index
        iv_index_column TYPE syst-index.
ENDCLASS.

CLASS lcl_game_of_life IMPLEMENTATION.

  METHOD next_generation.
    DO lif_board_type=>number_of_columns_board TIMES.
      process_line( sy-index ).
    ENDDO.
  ENDMETHOD.

  METHOD actual_board.
    rt_result = mo_board->get_actual_board(  ).
  ENDMETHOD.

  METHOD constructor.
    mo_board = io_board.
  ENDMETHOD.

  METHOD process_line.
    DO lif_board_type=>number_of_columns_board TIMES.
      process_cell( iv_index_lines = iv_index_lines
                    iv_index_column = sy-index ).

    ENDDO.
  ENDMETHOD.

  METHOD process_cell.
    DATA(lv_number_of_neighboor) = mo_board->number_of_neighboor( iv_index_lines = iv_index_lines
                                                                  iv_index_column = iv_index_column ).


    DATA(lv_new_cell_state) = COND lif_cell_state=>state( WHEN lv_number_of_neighboor < 2 THEN lif_cell_state=>died
                                                          WHEN lv_number_of_neighboor = 2 OR lv_number_of_neighboor = 3 THEN lif_cell_state=>live
                                                          WHEN lv_number_of_neighboor > 3 THEN lif_cell_state=>died ).

  ENDMETHOD.


ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA : mo_cut                  TYPE REF TO lcl_game_of_life,
           lt_initial_board        TYPE lif_board_type=>tty_board_type,
           lt_next_generated_board TYPE lif_board_type=>tty_board_type.
    METHODS:
      setup,
      acceptance_test FOR TESTING.
ENDCLASS.


CLASS ltcl_game_of_life IMPLEMENTATION.
  METHOD setup.
    lt_initial_board = VALUE #( ( column1 = NEW lcl_cell( lif_cell_state=>died ) column2 = NEW lcl_cell( lif_cell_state=>empty ) column3 = NEW lcl_cell( lif_cell_state=>died ) )
                                ( column1 = NEW lcl_cell( lif_cell_state=>died ) column2 = NEW lcl_cell( lif_cell_state=>live ) column3 = NEW lcl_cell( lif_cell_state=>died ) )
                                ( column1 = NEW lcl_cell( lif_cell_state=>died ) column2 = NEW lcl_cell( lif_cell_state=>died ) column3 = NEW lcl_cell( lif_cell_state=>died ) )
                             ).
    lt_next_generated_board = VALUE #( ( column1 = NEW lcl_cell( lif_cell_state=>died ) column2 = NEW lcl_cell( lif_cell_state=>empty ) column3 = NEW lcl_cell( lif_cell_state=>died ) )
                              ( column1 = NEW lcl_cell( lif_cell_state=>died ) column2 = NEW lcl_cell( lif_cell_state=>died ) column3 = NEW lcl_cell( lif_cell_state=>died ) )
                              ( column1 = NEW lcl_cell( lif_cell_state=>died ) column2 = NEW lcl_cell( lif_cell_state=>died ) column3 = NEW lcl_cell( lif_cell_state=>died ) )
                           ).

    mo_cut = NEW #( NEW lcl_board( lt_initial_board ) ).
    mo_cut->next_generation(  ).
  ENDMETHOD.

  METHOD acceptance_test.
    cl_abap_unit_assert=>assert_equals( exp = lt_next_generated_board act = mo_cut->actual_board(  ) ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_cell DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_cell.
    METHODS:
      setup,
      change_state_died_to_live FOR TESTING.
ENDCLASS.

CLASS ltcl_board DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_board.
    METHODS:
      setup,
      get_column1_name FOR TESTING,
      get_column2_name FOR TESTING,
      get_column3_name FOR TESTING.
ENDCLASS.

CLASS ltcl_board IMPLEMENTATION.

  METHOD get_column1_name.
    cl_abap_unit_assert=>assert_equals( exp = 'COLUMN1' act = mo_cut->get_column_name( 1 ) ).
  ENDMETHOD.

  METHOD get_column2_name.
    cl_abap_unit_assert=>assert_equals( exp = 'COLUMN2' act = mo_cut->get_column_name( 2 ) ).
  ENDMETHOD.

  METHOD get_column3_name.
    cl_abap_unit_assert=>assert_equals( exp = 'COLUMN3' act = mo_cut->get_column_name( 3 ) ).
  ENDMETHOD.

  METHOD setup.
    mo_cut = NEW #( VALUE #(  ) ).
  ENDMETHOD.

ENDCLASS.
CLASS ltcl_cell IMPLEMENTATION.

  METHOD change_state_died_to_live.
    mo_cut->change_state( lif_cell_state=>live ).
    cl_abap_unit_assert=>assert_equals( exp = lif_cell_state=>live act = mo_cut->get_actual_state(  ) ).
  ENDMETHOD.

  METHOD setup.
    mo_cut = NEW #( lif_cell_state=>died ).
  ENDMETHOD.

ENDCLASS.