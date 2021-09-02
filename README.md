# Simple Windows Command Prompt Display Engine
This is an old project that I began in the summer of 2018 and never fully finished. However, I did end up being able to display a square that is movable with the WASD keys. 

## Running
Run the `Main.bat` file. It will open two CMD windows that are immediately visible and one that is minimized. The visible window entitled "CMD Display Engine" is the visual display of the program. The window entitled "Input Slave Window" is the window that the user can input key inputs to. The minimized "Monitor" window handles the coordination of the windows (such as task-killing when one of the windows is closed).

The "Input Slave Window" should be focused when inputting to the program (it might have to be dragged out of the way of the "CMD Display Engine" window). It communicates with the display window via the "InputDump.txt" file (don't touch that).

#### Controls
In the current implementation of the program, the <kbd>W</kbd>, <kbd>A</kbd>, <kbd>S</kbd> and <kbd>D</kbd> keys will move the square northward, westward, southward and eastward, respectively. 

##

Yep, that's about all I had managed to do. There is some unfinished dead code for what was going to be implemented next, but I never worked the bugs out. I might revisit it sometime.
