#include "graph.h"
#include <iostream>
#include <fstream>
#include <queue>

using namespace std;


Graph::Graph()
{
    n = 0;
    adjmatrix=nullptr;
}

void Graph::load(string filename)
{
    ifstream inputFile;
    inputFile.open(filename.c_str());
    if(!inputFile){
        cout<<"Error! Could not open file..." << endl;
    }
    else
    {
        int x;
        int y; 
    
        inputFile>>n;
        adjmatrix = new int*[n];
        
        for(int i=0; i<n; i++){
        adjmatrix[i] = new int[n];
        }
        for(int i=0; i<n; i++){
            for(int j=0;j<n;j++)
                adjmatrix[i][j]=0;
        }
        while(inputFile>>x>>y){
            adjmatrix[x][y]=1;
            adjmatrix[y][x]=1;
        }
    }      
}

void Graph::RecDFS(int x, bool visited[])
{
    visited[x] = true;
    cout << x << " ";
    for(int i = 0; i <n; ++i){
        if(adjmatrix[x][i] && !visited[i])
            RecDFS(i, visited);
    }
}

void Graph::BFS(int x, bool visited[])
{
    queue<int>Q;
    visited[x] = true;
    Q.push(x);
    while(!Q.empty()){
        int v = Q.front();
        Q.pop();
        cout<<v<<" ";
        for(int i = 0; i <n; ++i) 
        {
            if(adjmatrix[v][i] && !visited[i]) 
            {
                visited[i] = true;
                Q.push(i);
            }
        }
    }
}

void Graph::display()
{
    cout<<"Adjacency Matrix" << endl << endl;
    for(int i=0; i<n; i++){
        for(int j=0; j<n; j++)
            cout<<adjmatrix[i][j]<<" ";
        cout<< endl << endl;  
    }
}

void Graph::displayDFS(int vertex)
{
    bool *visited = new bool[n];
    for (int i = 0; i < n; i++)
        visited[i] = false;

    RecDFS(vertex, visited);
}

void Graph::displayBFS(int vertex)
{
    bool *visited = new bool[n];
    for (int i = 0; i < n; i++)
        visited[i] = false;

    BFS(vertex, visited);
}

