# ENSE 352
My solutions to labs in ENSE 352 - Computer Architecture Fundamentals

##Overview
>**Lab 2** - Introduction to ARM Assembly  
>**Lab 3** - ARM Assembly Continued  
>**Lab 4** - Hex Code Reverse Engineering  
>**Lab 5** - Merge Sort  
>**Lab 6** - ARM Assembly Bit Manipulations  
>**Lab 7** - Introduction to GPIO

##Compilation
These compilation instructions apply to **Keil uVision5** and the **STM32F100RB** microcontroller (optional).

To compile in Keil uVision5, 

1. Create a new project, choose `Legacy` under `Software Packs`, search for `STM32F100RB` and select it.
2. Press `No` when prompted to add STM32 Startup Code.

You can either simulate the target using the debugger or connect an STM32F100RB via USB and follow `Running on STM32F100RB` below.

Right click `Source Group 1` and import the `.s` file from this repository into the project.

Then, go to
>Project -> Build Target

then press `Ctrl + F5` to start/stop debug session.

###Running on STM32F100RB
 1. Navigate to `Project -> Options for Target` . In the new window, navigate to the `Debug` tab.
 2. In the upper right corner, select `ST-Link Debugger` from the list. Click the `Use` button to the left of the box. Click `Settings` and select `SW` instead of the default `JTAG` in the `Port` field, and then click `OK`.
 3. Under the `Flash` tab, select a Flash memory to download to. If none exists, select `Add` and find the `STM32F10x med density Flash`. Click `OK` to exit the dialog.
 4. Now you can flash the STM32F100RB device and debug on it. Press `F8` to download to the device and then `Ctrl + F5` to start/stop debug session.

##Details
###Lab 2 - Introduction to ARM Assembly
Introduction to Keil uVision and ARM assembly for the Cortex-M3, volatile (RAM, registers) and non-volatile (ROM, Flash) memory.

###Lab 3 - ARM Assembly Continued
Implemented bit-level factorial operation and string processing.

###Lab 4 - Hex Code Reverse Engineering
A hex file `Objects/lab4.hex` was entered as the executable of a program and analyzed in the IDE to be able to modify the machine code and the functionality of the program. See `lab4/lab4.txt` for explanation.

Use of the `STM32F100RB` is required for this lab.  

###Lab 5 - Merge Sort
Implemented a merge sort algorithm recursively by loading a string to RAM and modifying the positions of bytes in RAM to sort the characters of the string in ascending order.  

###Lab 6 - ARM Assembly Bit Manipulations
Implemented 3 simple subroutines to handle setting, resetting, and counting bits.

###Lab 7 - Introduction to GPIO 
Connected to General Purpose I/O on the `STM32F100RB` microcontroller to use bit manipulations to control devices on the board from assembly (switch, LEDs). Created routines for flashing alternating LEDs and forcing LED to stay on when a switch is held on. 

---
> Written with [StackEdit](https://stackedit.io/).