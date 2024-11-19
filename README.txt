# I/O Operations and Driver Development

## Overview
This project focuses on creating drivers for memory-mapped I/O hardware components and implementing interactive programs such as a calculator and a Whack-A-Mole game. The drivers simplify interactions with hardware components like slider switches, LEDs, HEX displays, and pushbuttons, while leveraging timers and interrupts for efficiency.

---

# Calculator Program

## Overview
The calculator program uses slider switches for numerical input, pushbuttons for operation control, and HEX displays for output. It supports basic arithmetic operations and provides overflow handling.

## Features
### Input Mechanism
- **Slider Switches**:
  - SW0-SW3 represent the first number (n).
  - SW4-SW7 represent the second number (m).
- **Pushbuttons**:
  - PB0: Clear
  - PB1: Multiply
  - PB2: Subtract
  - PB3: Add

### Output Mechanism
- **HEX Displays**:
  - Results are displayed in sign-and-magnitude hexadecimal format.
  - Negative results include a sign indicator, e.g., `-00006`.
  - Overflow displays `OVRFLO` until cleared.

## Example Scenarios
1. **Subtraction**:
   - **Input**: SW1 (n=2), SW7 (m=8), Push PB2 (Subtract).
   - **Output**: Result = -6, displayed as `-00006`.

2. **Multiplication**:
   - **Input**: SW0, SW1 (n=3), SW5 (m=3), Push PB1 (Multiply).
   - **Output**: Result = 9, displayed as `00009`.

## Key Features
- **Dynamic Updates**: Results update in real-time upon button press.
- **Reset Functionality**: PB0 resets the calculator, clearing the display.
- **Sign Handling**: Positive and negative results are visually distinguished.

---
