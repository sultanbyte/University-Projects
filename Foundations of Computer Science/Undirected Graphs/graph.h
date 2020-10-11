#include <iostream>
class Graph
{
    private:
       int n;
       int **adjmatrix;
      
    public:

         Graph();
         void load(std::string filename);
         void RecDFS(int x, bool visited[]);
         void BFS(int x, bool visited[]);
         void display();
         void displayDFS(int vertex);
         void displayBFS(int vertex);
};


