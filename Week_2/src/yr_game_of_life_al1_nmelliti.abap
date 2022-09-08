REPORT yr_game_of_life_al1_nmelliti.

CLASS lcl_cell DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ENUM state BASE TYPE i,
        empty VALUE IS INITIAL,
        live  VALUE 1,
        dead  VALUE 2,
      END OF ENUM state.

    METHODS :
      constructor IMPORTING iv_state TYPE lcl_cell=>state.

  PRIVATE SECTION.
    DATA mo_state TYPE lcl_cell=>state.
ENDCLASS.

CLASS lcl_cell IMPLEMENTATION.

  METHOD constructor.
    mo_state = iv_state.
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

CLASS lcl_game_of_life DEFINITION.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING io_board TYPE REF TO lcl_board,
      next_generation RETURNING VALUE(rt_board) TYPE lcl_board=>tty_board.

  PRIVATE SECTION.
    DATA mo_board TYPE REF TO lcl_board.

ENDCLASS.

CLASS lcl_game_of_life IMPLEMENTATION.

  METHOD constructor.
    mo_board = io_board.
  ENDMETHOD.

  METHOD next_generation.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      acceptance_test FOR TESTING.
ENDCLASS.


CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD acceptance_test.

    DATA(lt_initial_board) = VALUE lcl_board=>tty_board( ( column1 = NEW lcl_cell( lcl_cell=>dead ) column2 = NEW lcl_cell( lcl_cell=>empty ) column3 = NEW lcl_cell( lcl_cell=>dead ) )
                                                           ( column1 = NEW lcl_cell( lcl_cell=>dead ) column2 = NEW lcl_cell( lcl_cell=>live ) column3 = NEW lcl_cell( lcl_cell=>dead ) )
                                                           ( column1 = NEW lcl_cell( lcl_cell=>dead ) column2 = NEW lcl_cell( lcl_cell=>dead ) column3 = NEW lcl_cell( lcl_cell=>dead ) )
                                                     ).

    DATA(lt_expected_board) = VALUE lcl_board=>tty_board( ( column1 = NEW lcl_cell( lcl_cell=>dead ) column2 = NEW lcl_cell( lcl_cell=>empty ) column3 = NEW lcl_cell( lcl_cell=>live ) )
                                                        ( column1 = NEW lcl_cell( lcl_cell=>dead ) column2 = NEW lcl_cell( lcl_cell=>live ) column3 = NEW lcl_cell( lcl_cell=>live ) )
                                                        ( column1 = NEW lcl_cell( lcl_cell=>dead ) column2 = NEW lcl_cell( lcl_cell=>dead ) column3 = NEW lcl_cell( lcl_cell=>dead ) )
                                                     ).

    DATA(lo_board) = NEW lcl_board( lt_initial_board ).


    cl_abap_unit_assert=>assert_equals( exp = lt_expected_board act = NEW lcl_game_of_life( lo_board )->next_generation(  ) ).

  ENDMETHOD.

ENDCLASS.