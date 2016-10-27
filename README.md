# ENSE 352
My solutions to labs in ENSE 352 - Computer Architecture Fundamentals

##Overview
>**Lab 2** - Introduction to ARM Assembly  
>**Lab 3** - ARM Assembly Continued  
>**Lab 4** - Hex Code Reverse Engineering  
>**Lab 5** - Merge Sort  

##Compilation
These compilation instructions apply to **Keil uVision5** and **STM32F100RB** microcontroller.

To compile in Keil uVision5, open the `*.uvproj` file in the folders (lab2, lab3, etc.)

From there, go to
>Project -> Build Target

then press `Ctrl + F5` to start/stop debug session.

###Running on STM32F100RB
 1. Create a project in Keil uVision, choose `Legacy` under `Software Packs`, search for `STM32F100RB` and select it.
 2. Press `No` when prompted to add STM32 Startup Code.
 3. Navigate to `Project -> Options for Target` . In the new window, navigate to the `Debug` tab.
 4. In the upper right corner, select `ST-Link Debugger` from the list. Click the `Use` button to the left of the box. Click `Settings` and select `SW` instead of the default `JTAG` in the `Port` field, and then click `OK`.
 5. Under the `Flash` tab, select a Flash memory to download to. If none exists, select `Add` and find the `STM32F10x med density Flash`. Click `OK` to exit the dialog.
 6. Now you can flash the STM32F100RB device and debug on it. Press `F8` to download to the device and then `Ctrl + F5` to start/stop debug session.

##Details
###Lab 2 - Introduction to ARM Assembly
Introduction to Keil uVision and ARM assembly for the Cortex-M3, volatile (RAM, registers) and non-volatile (ROM, Flash) memory.

###Lab 3 - ARM Assembly Continued
Implemented bit-level factorial operation and string processing.

###Lab 4 - Hex Code Reverse Engineering
A hex file `lab4.hex` was entered as the executable of a program and analyzed in the IDE to be able to modify the machine code and the functionality of the program. See `lab4/lab4.txt` for explanation.  

###Lab 5 - Merge Sort
Implemented a merge sort algorithm recursively by loading a string to RAM and modifying the positions of bytes in RAM to sort the characters of the string in ascending order.  

> Written with [StackEdit](https://stackedit.io/).