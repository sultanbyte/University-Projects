//Sultan Alneif
//tictactoe.h
//03/10/2019
//Specification file for tictactoe class used for game

#include <iostream>
#include <cassert>
#include <iomanip>

using namespace std;

#ifndef TICTACTOE_H
#define TICTACTOE_H

class TicTacToe

{
  public:
    explicit TicTacToe(int s = 3 );

    TicTacToe(const TicTacToe &obj);

    TicTacToe& operator=(const TicTacToe &obj);
  
    ~TicTacToe();

    void displayGame(ostream &outs);

    bool placePiece(char piece, int row, int col);
                      
    bool isWin(char &piece);

    void resetBoard();
  private:
    int size;
    char **board;
    static const int SIZE = 3;
    static const char SPACE = ' ';
    static const char VERTICAL = '|';
    static const char DASH = '-';
    static const int COL_WIDTH = 3;
};

#endif

