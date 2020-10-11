# Undirected graphs

  This program models an undirected graph from an input file and displays its adjacency matrix, depth first search, and breadth first search.
  
### Sample Input
  graph.txt is a sample input for the program. The first line contains a single integer indicating how many vertices are in the graph and all remaining lines 
  contain two integers that indicate an edge connecting two vertices
  
  
### Sample Output

  Adjacency Matrix

  0 0 1 1 0 0 0 

  0 0 1 1 1 0 0 

  1 1 0 0 0 1 0 

  1 1 0 0 0 1 1 

  0 1 0 0 0 1 1 

  0 0 1 1 1 0 0 

  0 0 0 1 1 0 0 



  DFS at vertex 0: 0 2 1 3 5 4 6 
  
  BFS at vertex 0: 0 2 3 1 5 6 4 
