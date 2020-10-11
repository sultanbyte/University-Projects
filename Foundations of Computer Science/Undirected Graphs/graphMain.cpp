#include <iostream>
#include "graph.h"


using namespace std;

Graph userInput();

int main()
{
   Graph graph;
   char status = 'y';
   bool again = false;

   while(status == 'y')
   {
       again = false;
       graph = userInput();

       graph.display();
       
       cout<<"DFS at vertex 0: ";
       graph.displayDFS(0);
       cout << endl;

       cout<<"BFS at vertex 0: ";
       graph.displayBFS(0);
       cout << endl << endl;

       while(again == false)
        {
            cout << "Do you want to try another file? [y/n]" << endl;
            cin >> status;
            if(status== 'y' || status== 'n')
            {
                again = true;
            }
        }
       cout << endl << endl;
   } 
}

Graph userInput()
{
    string filename;
    Graph graph;
    cout << "Input file: ";
    cin >> filename; 
    cout << endl << endl;
    graph.load(filename);
    return graph;
}