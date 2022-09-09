REPORT yr_game_of_life_al1_nmelliti.

INTERFACE lif_cell_state.
  TYPES:
    BEGIN OF ENUM state BASE TYPE i,
      empty VALUE IS INITIAL,
      live  VALUE 1,
      dead  VALUE 2,
    END OF ENUM state.
ENDINTERFACE.

CLASS lcl_cell DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING iv_state TYPE lif_cell_state=>state.
  PRIVATE SECTION.
    DATA mv_state TYPE lif_cell_state=>state.
ENDCLASS.

CLASS lcl_cell IMPLEMENTATION.

  METHOD constructor.
    mv_state = iv_state.
  ENDMETHOD.

ENDCLASS.

INTERFACE lif_board_type.
  TYPES : BEGIN OF ty_board,
            column1 TYPE REF TO lcl_cell,
            column2 TYPE REF TO lcl_cell,
            column3 TYPE REF TO lcl_cell,
          END OF ty_board,
          tty_board TYPE TABLE OF ty_board WITH DEFAULT KEY.
  CONSTANTS : number_of_lines   TYPE i VALUE 3,
              number_of_columns TYPE i VALUE 3.
ENDINTERFACE.

CLASS lcl_board DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING it_board TYPE lif_board_type=>tty_board,
      get_actual_board
        RETURNING
          VALUE(rt_result) TYPE lif_board_type=>tty_board.
  PRIVATE SECTION.
    DATA mt_board TYPE lif_board_type=>tty_board.
ENDCLASS.

CLASS lcl_board IMPLEMENTATION.

  METHOD constructor.
    mt_board = it_board.
  ENDMETHOD.

  METHOD get_actual_board.
    rt_result = mt_board.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS :
      constructor IMPORTING io_board TYPE REF TO lcl_board,
      next_generation,
      actual_board
        RETURNING
          VALUE(rt_result) TYPE lif_board_type=>tty_board.
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mo_board TYPE REF TO lcl_board.
    METHODS process_line_of_board IMPORTING iv_line TYPE syst-index.
    METHODS process_cell
      IMPORTING
        iv_column TYPE syst-index
        iv_line   TYPE syst-index.
ENDCLASS.

CLASS lcl_game_of_life IMPLEMENTATION.

  METHOD constructor.
    mo_board = io_board.
  ENDMETHOD.

  METHOD next_generation.
    DO lif_board_type=>number_of_lines TIMES.
      process_line_of_board( sy-index ).
    ENDDO.
  ENDMETHOD.

  METHOD actual_board.
    rt_result = mo_board->get_actual_board(  ).
  ENDMETHOD.

  METHOD process_line_of_board.
    DO lif_board_type=>number_of_lines TIMES.
      process_cell( iv_column = sy-index iv_line = iv_line ).
    ENDDO.
  ENDMETHOD.

  METHOD process_cell.

  ENDMETHOD.

ENDCLASS.
CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA : lt_initial_board         TYPE lif_board_type=>tty_board,
           lt_next_generation_board TYPE lif_board_type=>tty_board,
           mo_cut                   TYPE REF TO lcl_game_of_life.
    METHODS:
      setup,
      acceptance_test FOR TESTING.
ENDCLASS.

CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD setup.
    lt_initial_board = VALUE #( ( column1 = NEW lcl_cell( lif_cell_state=>dead ) column2 = NEW lcl_cell( lif_cell_state=>empty ) column3 = NEW lcl_cell( lif_cell_state=>dead ) )
                                ( column1 = NEW lcl_cell( lif_cell_state=>dead ) column2 = NEW lcl_cell( lif_cell_state=>live ) column3 = NEW lcl_cell( lif_cell_state=>dead ) )
                                ( column1 = NEW lcl_cell( lif_cell_state=>dead ) column2 = NEW lcl_cell( lif_cell_state=>dead ) column3 = NEW lcl_cell( lif_cell_state=>dead ) )
                               ).
    lt_next_generation_board = VALUE #( ( column1 = NEW lcl_cell( lif_cell_state=>dead ) column2 = NEW lcl_cell( lif_cell_state=>empty ) column3 = NEW lcl_cell( lif_cell_state=>dead ) )
                             ( column1 = NEW lcl_cell( lif_cell_state=>dead ) column2 = NEW lcl_cell( lif_cell_state=>dead ) column3 = NEW lcl_cell( lif_cell_state=>dead ) )
                             ( column1 = NEW lcl_cell( lif_cell_state=>dead ) column2 = NEW lcl_cell( lif_cell_state=>dead ) column3 = NEW lcl_cell( lif_cell_state=>dead ) )
                            ).
    DATA(lo_board) = NEW lcl_board( lt_initial_board ).
    mo_cut = NEW #( lo_board ).
    mo_cut->next_generation(  ).
  ENDMETHOD.

  METHOD acceptance_test.
    cl_abap_unit_assert=>assert_equals( exp = lt_next_generation_board act = mo_cut->actual_board(  ) ).
  ENDMETHOD.

ENDCLASS.