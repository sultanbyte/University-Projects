# Sort By Color

In this project, only an AL5D robotic arm, an external camera, and python software driver were used to sort objects by color in the manipulator's workspace.

Initially, the arm scans its work space for three different objects in three different initial positions, using the external camera mounted on it, pick up the objects, and then move each to its allocated position based on its color using openCV for color detection and Serial for the arm movements. The colors to be sorted are red, blue, yellow, and it is possible to add more colors to the range. The arm will throw away any object with another color. 


