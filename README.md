# I/O Operations and Driver Development

## Overview
This project focuses on creating drivers for memory-mapped I/O hardware components and implementing interactive programs such as a calculator and a Whack-A-Mole game. The drivers simplify interactions with hardware components like slider switches, LEDs, HEX displays, and pushbuttons, while leveraging timers and interrupts for efficiency.

---

# Calculator Program

## Overview
The calculator program implements basic arithmetic operations using slider switches for input, pushbuttons for operation control, and HEX displays for output. It supports addition, subtraction, and multiplication, handles overflow conditions, and displays results dynamically.

---

## Approach

### Input and Control Mechanism
1. **Slider Switches**:
   - SW0-SW3 represent the first number (`n`).
   - SW4-SW7 represent the second number (`m`).

2. **Pushbuttons**:
   - PB0: Clear
   - PB1: Multiply
   - PB2: Subtract
   - PB3: Add

### Core Implementation Steps
1. **Polling for Pushbutton Input**:
   - The edgecapture register is continuously polled in an infinite loop to detect pushbutton releases, determining the selected operation.

2. **Reading Slider Switch Values**:
   - The `read_inputs` subroutine reads the slider switches' memory-mapped address and masks the bits to extract `n` (SW0-SW3) and `m` (SW4-SW7).

3. **Performing Operations**:
   - The selected operation (stored in a register) determines how `n` and `m` are processed. The result is stored in `A4`.
   - Overflow is detected, and if it occurs, the `OVERFLO` message is displayed on the HEX displays.

4. **Handling Negative Results**:
   - If the result is negative, it is converted to positive for proper display formatting, and a negative sign is stored in the 6th HEX display. The result is then processed for display.

5. **Result Display**:
   - The result is split into 4-bit segments and displayed across the first five HEX displays. The sixth HEX display shows a negative sign if needed.
   - A subroutine manages the decoding of 4-bit segments into 7-segment values for the HEX displays.

6. **Return Subroutine**:
   - Frees the stack and returns to the infinite loop to await the next operation.

---

## Challenges

1. **Division for Decimal Representation**:
   - The simulator does not support division, so division was implemented by subtraction. The subroutine continuously subtracts 10 until the result is less than 10. This value is stored and displayed, with the process repeating for the quotient until it reaches 0.

2. **Overflow Handling**:
   - Overflow detection was critical, especially for operations involving large or negative values. The program correctly identifies overflow and displays `OVERFLO` until cleared.

---

## Testing

1. **Basic Operations**:
   - Addition, subtraction, and multiplication were tested with different inputs to ensure correctness. For example:
     - Input: `n=2`, `m=15`, Operation: Subtract.
     - Output: `-13`, displayed as `-00013`.

2. **Clear Functionality**:
   - Tested by performing operations and then pressing PB0 to ensure the result and displays were reset.

3. **Overflow Conditions**:
   - Tested by using large inputs and repeated operations:
     - Input: `n=15`, `m=15`, Operation: Multiply (repeated 5 times).
     - Output: `OVERFLO`.

---

## Shortcomings and Possible Improvements

1. **Polling Inefficiency**:
   - The program continuously polls pushbuttons, which impacts performance. Using interrupts could improve efficiency.

2. **Handling Negative Values**:
   - Current implementation converts negative values to positive for display. Using 2’s complement could streamline operations.

3. **Switch Reset Requirement**:
   - After an overflow condition, all switches must be turned off before clearing the calculator.

4. **Performance Metrics**:
   - The program executes 9,679,320 instructions, performs 3,226,387 data loads, and 68 data stores for a single `15x15` operation. Optimization is needed to reduce these numbers.

---

## Key Observations

1. **Priority Handling**:
   - If two pushbuttons are pressed simultaneously, the program gives priority to the leftmost pushbutton, adhering to the one-hot encoding format.

2. **Accuracy and Robustness**:
   - The calculator handles negative values, overflow, and various operations effectively, ensuring accurate and user-friendly outputs.

3. **Scalability**:
   - The program structure can be extended to include additional operations or support higher precision inputs and outputs.

