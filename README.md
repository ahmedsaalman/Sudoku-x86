

# 🧩 Sudoku 9x9 - x86 Assembly

A fully functional, text-mode Sudoku game written entirely in 16-bit x86 Assembly (NASM). This project features procedural board generation using a backtracking algorithm, background audio integration, and a dedicated notes system.

## 🌟 Key Features

-   **Procedural Board Generation:** Uses a Backtracking Algorithm to generate unique, valid 9x9 grids every time you play.
    
-   **Difficulty Levels:** Choose between Easy, Medium, and Hard (adjusts the number of pre-filled cells).
    
-   **Audio Integration:** Background music playback (`.imf` format).
    
-   **Dual Screen Mode:** Toggle between the main Game Grid and a dedicated Notes Grid.
    
-   **Game Logic:**
    
    -   Real-time move validation.
        
    -   Score tracking (+5 for every correct move).
        
    -   Mistake counter (Game Over after 5 mistakes).
        
-   **Custom UI:** Direct video memory manipulation (`0xb800`) for custom grid rendering and ASCII art.
    

## 🎮 Controls

**Key**

**Action**

**W, A, S, D**

Move the cursor within the grid

**1 - 9**

Input a number into the selected cell

**Arrow Keys**

Swap between Game Screen and Notes Screen

**N**

Toggle Notes mode

**E**

Exit the game immediately

## 🛠️ Technical Details

### The Backtracking Algorithm

The core of this project is the `solve` function. It recursively fills the board to generate a valid solution:

1.  Finds an empty cell.
    
2.  Tries numbers 1-9.
    
3.  Checks validity against Row, Column, and 3x3 Subgrid.
    
4.  If valid, moves to the next cell.
    
5.  If a dead end is reached, it **backtracks** (returns 0) and tries a different number.
    

### Memory Management

-   **Video Memory:** The game writes directly to the VGA video buffer segment `0xb800` for fast, flicker-free rendering.
    
-   **Data Segments:** Separate buffers are maintained for the `easy` (puzzle), `grid10` (solution), and `notes` arrays.
    

## 🚀 How to Build and Run

### Prerequisites

1.  **NASM:** The Netwide Assembler to compile the code.
    
2.  **DOSBox:** To emulate the 16-bit DOS environment.
    

### Compilation

1.  Ensure you have `gimmefan.imf` in the same directory (referenced in code line: `music_data: incbin "gimmefan.imf"`).
    
2.  Open your terminal and run:
    

Bash

```
nasm -f bin sudoku.asm -o sudoku.com

```

### Running in DOSBox

1.  Open DOSBox.
    
2.  Mount your project directory:
    
    Bash
    
    ```
    mount c C:\path\to\your\project
    c:
    
    ```
    
3.  Run the executable:
    
    Bash
    
    ```
    sudoku.com
    
    ```
    

## 🕹️ Game Rules

1.  **Objective:** Fill the 9x9 grid so that each column, each row, and each of the nine 3x3 subgrids contain all of the digits from 1 to 9.
    
2.  **Scoring:** You start with 0 points. Every valid entry awards **+5 points**.
    
3.  **Losing:** If you make **5 mistakes**, the game ends.
    
4.  **Winning:** Completely fill the board without exceeding the mistake limit.
    

## 📂 File Structure

-   `sudoku.asm`: The main source code.
    
-   `gimmefan.imf`: Background music file (required for compilation).
    
-   `README.md`: Project documentation.
    

## 🔮 Future Improvements

-   Implement a timer to track speed.
    
-   Add a "Save Game" feature using file I/O interrupts.
    
-   Add mouse support (Interrupt `33h`).
    

----------

_Created by Ahmed Salman and Aima Aftab_
