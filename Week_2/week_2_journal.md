D1 :
I started with the TDD approach by writing the acceptance test from the kata instruction. 
From this acceptance test came several classes: 
- lcl_game_of_life which has the next_generation method that generates the next state of the board.
- lcl_board that represents the board
- lcl_cell that represents cell inside the board

For this first iteration I don't feel like I wrote much code because there was the game understanding and design phase



D2 : I continued with the TDD approach. So I rewrote the same acceptance test to start with. 
	 But I changed my design. The next_generation method does not return anything anymore. A method of the game_of_life class is in charge of returning the current state of the board.
	 I then followed the same approach with my lcl_cell and lcl_board classes except that I output the enumeration in a lcl_cell_state class. 
	 I think for the next iteration I will also output the board definition in a lcl_board_type class.
	 I had time to write with a TDD approach some tests for my lcl_cell class. I then implemented the methods I test. 
     In the next iteration I will focus on the lcl_board class which has a complexity compared to the lcl_cell class



D3 : Same approach as the first 2 days, I started with the acceptance test. 
	 I decided to separate the instantiation of the board in a setup method from the test class to have something more readable and cleaner.
	 I also outputed the board definition in a lcl_board_type class.
     I started to implement the board class but time is going by really fast. It creates a lot of frustration to have to erase everything and start over.






D4 : Same approach as the first 3 days, I started with the acceptance test.
     On the previous iteration, I had created classes for the board type and for the cell states. 
	 Instead, I created interfaces for lif_cell_state and lif_board_type.
	 Then I started to implement the next_generation method but I couldn't finish after 50 minutes.






D5 :
