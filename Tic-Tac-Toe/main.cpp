#include <iostream>
#include <cctype>
#include "tictactoe.h"

using namespace std;

void welcome();

void gameStats(int xWins, int oWins, int ties);

void goodbye();

void playGame();

void checkWinner();

TicTacToe game;
const char X = 'X';
const char O = 'O';
const char TIE = ' ';
int xwon = 0, owon = 0, tie = 0;
int row = 0, col = 0;
bool xTurn = true;
char ans = 'y';
char winningPiece;

int main()
{
	welcome();
  	while (ans  == 'y')
  	{
		winningPiece = ' ';
		game.displayGame(cout);
		playGame();
		checkWinner();
		gameStats(xwon, owon, tie);
		cout << "You want to play again? (y/n)";
		cin >> ans;
		if (ans=='y')
			game.resetBoard();
  	}
  	goodbye();
}

void playGame()
{
	while (!game.isWin(winningPiece))
	{
		if(xTurn)
		{
			cout << "X, it is your turn." << endl;
			cout << "Pick a row ";
			cin >> row;
			cout << "Pick a column ";
			cin >> col;
			if (game.placePiece(X, row, col))
				xTurn = false;
			else
				cout << "Bad location, try again..." << endl;
			game.displayGame(cout);
		}
	  	else
	  	{
			cout << "O, it is your turn." << endl;
			cout << "Pick a row  ";
			cin >> row;
			cout << "Pick a column  ";
			cin >> col;
			if (game.placePiece(O, row, col))
				xTurn = true;
			else
				cout << "Bad location, try again..." << endl;

			game.displayGame(cout);
	  	}
	}
}

void checkWinner()
{
	if (winningPiece == X)
	{
		cout << "X wins! this round" << endl;
	  	xwon++;
	}
	else if (winningPiece == O)
	{
		cout << "O wins this round!" << endl;
	  	owon++;
	}
	else
	{
	  	cout << "Tie!" << endl;
	  	tie++;
	}
}

void gameStats(int xWins, int oWins, int ties)
{
  	cout << endl;
  	cout << "Game stats:" << endl;
  	cout << "X wins: " << xWins << endl;
  	cout << "O wins: " << oWins << endl;
  	cout << "Ties: " << ties << endl;
  	cout << endl;
}

void welcome()
{
  	cout << "Welcome to Tic-Tac-Toe!" << endl;
}

void goodbye()
{
  	cout << "See you again!" << endl << endl;
}


