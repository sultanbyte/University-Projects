//Implementation file for tictictoe class

#include "tictactoe.h"
#include <iomanip>

TicTacToe::TicTacToe(int s)
{
	size = s;
  	board = new char*[size];
  	assert(board != nullptr);
  	for (int i = 0 ; i < size; i++)
	{
		board[i] = new char[size];
		assert(board[i] != nullptr);
  	}
  	for (int i = 0; i < size; i++)
	{
		for (int j = 0; j < size; j++)
		{
			board[i][j] = SPACE;
		}
	}
}
 
TicTacToe::TicTacToe(const TicTacToe &obj)
{
  	board = new char*[SIZE];
  	assert (board != nullptr);
  	for (int i = 0; i < SIZE; i++)
	{
		board[i] = new char[SIZE];
        assert(board[i] != nullptr);
    }
  	for (int r = 0; r < SIZE; r++)
	{
		for (int c = 0; c < SIZE; c++)
	  	{
        	board[r][c] = obj.board[r][c];
	  	}
	}
}
  
TicTacToe& TicTacToe::operator=(const TicTacToe &obj)
{
	if (this != &obj){
		for (int i = 0; i < SIZE; i++)
		{
	  		for (int j = 0; j < SIZE; j++)
			{
				board[i][j] = obj.board[i][j];
			}
		}
  }
  return *this;
}

void TicTacToe::displayGame(ostream &outs)
{
	cout << endl << endl;
  	for (int i = 0; i < COL_WIDTH - 1; i++)
		cout << SPACE;
  	for (int i = 0; i < SIZE; i++)
		cout << setw(COL_WIDTH) << i;
  	outs << endl;
  	for (int r = 0; r < SIZE; r++)
	{
		cout << setw(COL_WIDTH) << r;
		for (int c = 0; c < SIZE; c++)
		{
	 		cout << SPACE << board[r][c] << VERTICAL;
		}
		cout << endl;
		for (int i = 0; i < SIZE; i++)
	  		cout << SPACE;
		for (int d = 0; d < SIZE * COL_WIDTH; d++)
	  		cout << DASH;
		cout << endl;
  }
}


bool TicTacToe::placePiece(char piece, int row, int col)
{
  if (row >= 0 && row < SIZE &&
	  col >= 0 && col < SIZE && board[row][col] == SPACE){
	board[row][col] = piece;
	return true;
  }
  else
	return false;
}

bool TicTacToe::isWin(char& piece)
{
  bool won = false;
  int row = 0;
  int col =0;
  int index = 0;
  char checkPiece;
  bool spaces = false;
  while (!won && row < SIZE)
  {
	col = 0;
	checkPiece = board[row][col];
	col++;
	while (col < SIZE && checkPiece == board[row][col])
		col++;
	if (col == SIZE && checkPiece != SPACE)
	{
		won = true;
		piece = checkPiece;
	}
	else
	{
		row++;
	}
  }
  row = 0;
  col = 0;
  while (!won && col < SIZE)
  { 
	row = 0;
	checkPiece = board [row][col];
	row++;
	while (row < SIZE && checkPiece == board[row][col])
	row++;
	if (row == SIZE && checkPiece != SPACE)
	{
		won = true;
		piece = checkPiece;
	}
	else
	{
		col++;
	}
  }
 if (!won)
 {
	checkPiece = board[index][index];
	index++;
	while (index < SIZE && checkPiece == board[index][index])
	  index++;
	if (index == SIZE && checkPiece != SPACE)
	{
	  won = true;
	  piece = checkPiece;
	}
	else
	{
	  index++;
	}
}
index = 0;
  if (!won){
	checkPiece = board[index][size - 1 - index];
	index++;
	while (index < SIZE && checkPiece == board[index][size - 1 - index])
	  index++;
	if (index == SIZE && checkPiece != SPACE){
	  won = true;
	  piece = checkPiece;
	}else{
	  index++;
	}
  }
 row = 0;
  if (!won){
	while (!spaces && row < SIZE){
	  col = 0;
	  while (col < SIZE){
		if (board[row][col] == SPACE)
		  spaces = true;
		col++;
	  }
	  row++;
	}
	if (!spaces)
    won = true;
  }
  
  return won;
}


void TicTacToe::resetBoard()
{
  for (int r = 0; r < SIZE; r++)
	for (int c = 0; c < SIZE; c++)
	  board[r][c] = SPACE;
}

TicTacToe::~TicTacToe()
{
        delete board;
}