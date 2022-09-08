REPORT yr_game_of_life_al1_nmelliti.

CLASS lcl_cell_state DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ENUM state BASE TYPE i,
        empty VALUE IS INITIAL,
        live  VALUE 1,
        dead  VALUE 2,
      END OF ENUM state.
ENDCLASS.

CLASS lcl_cell DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING iv_state TYPE lcl_cell_state=>state,
      get_actual_state
        RETURNING
          VALUE(rv_result) TYPE lcl_cell_state=>state,
      change_state
            IMPORTING
              iv_state TYPE lcl_cell_state=>state.

  PRIVATE SECTION.
    DATA mv_state TYPE lcl_cell_state=>state.
ENDCLASS.

CLASS lcl_cell IMPLEMENTATION.

  METHOD constructor.
    mv_state = iv_state.
  ENDMETHOD.

  METHOD get_actual_state.
    rv_result = mv_state.
  ENDMETHOD.


  METHOD change_state.
    mv_state = iv_state.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_board DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_board,
              column1 TYPE REF TO lcl_cell,
              column2 TYPE REF TO lcl_cell,
              column3 TYPE REF TO lcl_cell,
            END OF ty_board,
            tty_board TYPE TABLE OF ty_board WITH DEFAULT KEY.

    METHODS :
      constructor IMPORTING it_board TYPE tty_board.
  PRIVATE SECTION.
    DATA mo_board TYPE tty_board.
ENDCLASS.

CLASS lcl_board IMPLEMENTATION.

  METHOD constructor.
    mo_board = it_board.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING io_board TYPE REF TO lcl_board,
      next_generation,
      get_board
        RETURNING
          VALUE(rt_result) TYPE lcl_board=>tty_board.

  PRIVATE SECTION.
    DATA mo_board TYPE REF TO lcl_board.
ENDCLASS.

CLASS lcl_game_of_life IMPLEMENTATION.

  METHOD constructor.
    mo_board = io_board.
  ENDMETHOD.

  METHOD next_generation.

  ENDMETHOD.


  METHOD get_board.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS:
      acceptance_test FOR TESTING.
ENDCLASS.


CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD acceptance_test.

    DATA(lt_initial_board) = VALUE lcl_board=>tty_board( ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                                           column2 = NEW lcl_cell( lcl_cell_state=>empty )
                                                           column3 = NEW lcl_cell( lcl_cell_state=>dead ) )

                                                          ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                                            column2 = NEW lcl_cell( lcl_cell_state=>live )
                                                            column3 = NEW lcl_cell( lcl_cell_state=>dead ) )

                                                           ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                                            column2 = NEW lcl_cell( lcl_cell_state=>dead )
                                                            column3 = NEW lcl_cell( lcl_cell_state=>dead ) )
                                                           ).


    DATA(lt_next_generation_board) = VALUE lcl_board=>tty_board( ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                                                   column2 = NEW lcl_cell( lcl_cell_state=>empty )
                                                                   column3 = NEW lcl_cell( lcl_cell_state=>live ) )

                                                                 ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                                                   column2 = NEW lcl_cell( lcl_cell_state=>live )
                                                                   column3 = NEW lcl_cell( lcl_cell_state=>live ) )

                                                                 ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                                                   column2 = NEW lcl_cell( lcl_cell_state=>dead )
                                                                   column3 = NEW lcl_cell( lcl_cell_state=>dead ) )
                                                                 ).


    DATA(lo_board) = NEW lcl_board( lt_initial_board ).
    DATA(lo_game_of_life) = NEW lcl_game_of_life( lo_board ).
    lo_game_of_life->next_generation(  ).

    cl_abap_unit_assert=>assert_equals( exp = lt_next_generation_board act = lo_game_of_life->get_board(  ) ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_cell DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO lcl_cell.
    METHODS:
      setup,
      actual_state FOR TESTING,
      change_state FOR TESTING.
ENDCLASS.


CLASS ltcl_cell IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( lcl_cell_state=>dead ).
  ENDMETHOD.

  METHOD actual_state.
    cl_abap_unit_assert=>assert_equals( exp = lcl_cell_state=>dead act = mo_cut->get_actual_state(  ) ).
  ENDMETHOD.

  METHOD change_state.
    mo_cut->change_state( lcl_cell_state=>live ).
    cl_abap_unit_assert=>assert_equals( exp = lcl_cell_state=>live act = mo_cut->get_actual_state(  ) ).
  ENDMETHOD.

ENDCLASS.