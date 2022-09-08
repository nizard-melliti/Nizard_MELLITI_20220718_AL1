REPORT yr_game_of_life_al1_nmelliti.

CLASS lcl_cell_state DEFINITION FINAL.
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
      constructor IMPORTING iv_state TYPE lcl_cell_state=>state.
  PRIVATE SECTION.
    DATA mv_state TYPE lcl_cell_state=>state.

ENDCLASS.

CLASS lcl_cell IMPLEMENTATION.

  METHOD constructor.
    mv_state = iv_state.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_board_type DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_board,
              column1 TYPE REF TO lcl_cell,
              column2 TYPE REF TO lcl_cell,
              column3 TYPE REF TO lcl_cell,
            END OF ty_board,
            tty_board TYPE TABLE OF ty_board WITH DEFAULT KEY.
ENDCLASS.

CLASS lcl_board DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING it_board TYPE lcl_board_type=>tty_board,
      get_board RETURNING VALUE(rt_result) TYPE lcl_board_type=>tty_board,
      compute_next_generation.
  PRIVATE SECTION.
    CONSTANTS : number_of_lines   TYPE i VALUE 3,
                number_of_columns TYPE i VALUE 3.
    DATA mt_board TYPE lcl_board_type=>tty_board.
    METHODS change_line_of_board IMPORTING iv_line_index TYPE syst_index.

ENDCLASS.

CLASS lcl_board IMPLEMENTATION.

  METHOD constructor.
    mt_board = it_board.
  ENDMETHOD.

  METHOD get_board.
    rt_result = mt_board.
  ENDMETHOD.

  METHOD compute_next_generation.
    DO number_of_lines TIMES.
      change_line_of_board( sy-index ).
    ENDDO.
  ENDMETHOD.

  METHOD change_line_of_board.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING io_board TYPE REF TO lcl_board,
      next_generation,
      get_actual_board RETURNING VALUE(rt_result) TYPE lcl_board_type=>tty_board.
  PRIVATE SECTION.
    DATA mo_board TYPE REF TO lcl_board.

ENDCLASS.

CLASS lcl_game_of_life IMPLEMENTATION.

  METHOD constructor.
    mo_board = io_board.
  ENDMETHOD.

  METHOD next_generation.
    mo_board->compute_next_generation(  ).
  ENDMETHOD.

  METHOD get_actual_board.
    rt_result = mo_board->get_board(  ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA : lt_initial_board        TYPE lcl_board_type=>tty_board,
           lt_next_generated_board TYPE lcl_board_type=>tty_board,
           mo_cut                  TYPE REF TO lcl_game_of_life.
    METHODS:
      setup,
      acceptance_test FOR TESTING.
ENDCLASS.


CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD setup.
    lt_initial_board = VALUE #( ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                  column2 = NEW lcl_cell( lcl_cell_state=>empty )
                                  column3 = NEW lcl_cell( lcl_cell_state=>dead ) )

                                  ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                    column2 = NEW lcl_cell( lcl_cell_state=>live )
                                    column3 = NEW lcl_cell( lcl_cell_state=>dead ) )

                                    ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                                      column2 = NEW lcl_cell( lcl_cell_state=>dead )
                                      column3 = NEW lcl_cell( lcl_cell_state=>dead ) )
                                ).

    lt_next_generated_board = VALUE #( ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
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

    mo_cut = NEW #( lo_board ).

  ENDMETHOD.

  METHOD acceptance_test.
    mo_cut->next_generation(  ).
    cl_abap_unit_assert=>assert_equals( exp = lt_next_generated_board act = mo_cut->get_actual_board(  ) ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_board DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA : lt_board TYPE lcl_board_type=>tty_board,
           mo_cut   TYPE REF TO lcl_board.
    METHODS:
      setup,
      get_board FOR TESTING.
ENDCLASS.


CLASS ltcl_board IMPLEMENTATION.

  METHOD setup.
    lt_board = VALUE #( ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                          column2 = NEW lcl_cell( lcl_cell_state=>empty )
                          column3 = NEW lcl_cell( lcl_cell_state=>dead ) )

                        ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                          column2 = NEW lcl_cell( lcl_cell_state=>live )
                          column3 = NEW lcl_cell( lcl_cell_state=>dead ) )

                        ( column1 = NEW lcl_cell( lcl_cell_state=>dead )
                          column2 = NEW lcl_cell( lcl_cell_state=>dead )
                          column3 = NEW lcl_cell( lcl_cell_state=>dead ) )
                      ).

    mo_cut = NEW #( lt_board ).
  ENDMETHOD.

  METHOD get_board.
    cl_abap_unit_assert=>assert_equals( exp = lt_board act = mo_cut->get_board(  ) ).
  ENDMETHOD.

ENDCLASS.