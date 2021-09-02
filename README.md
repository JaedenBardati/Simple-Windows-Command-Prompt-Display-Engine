# Simple Windows Command Prompt Display Engine
 This is an old project that I began in the summer of 2018 and never fully finished. However, I did end up being able to display a square that is movable with the WASD keys. 

 To run the program, run the `Main.bat` file. It will open two CMD windows that are immediately visible and one that is minimized. The visible window entitled "CMD Display Engine" is the visual display of the program. The window entitled "Input Slave Window" is the window that the user can input key inputs to. The "Input Slave Window" should be focused when inputting to the program (the window might have to be dragged out of the way of the "CMD Display Engine" window). The input window communicates with the display window via the "InputDump.txt" file. The minimized "Monitor" window handles the coordination of the windows (such as task-killing when one of the windows is closed).

 In the current implementation of the program, the <kbd>W</kbd>, <kbd>A</kbd>, <kbd>S</kbd> and <kbd>D</kbd> keys will move the square north, west, south and east, respectively.
 