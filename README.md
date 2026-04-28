## VGA Multi-Functional Controller with Audio & SSD Display
This project is a comprehensive SoC (System on Chip) prototype developed in VHDL for FPGA platforms. It implements a high-performance VGA controller capable of real-time geometric rendering, dynamic audio generation, and synchronized 7-segment display (SSD) feedback.
Core FeaturesThe system features four distinct operating modes, selectable via hardware switches (sw(1:0)):1. Chessboard Mode (00)Generates a classic 8x8 checkerboard pattern.Renders the text "TABLA SAH" (Chessboard) across the 8-digit Seven Segment Display.2. Dynamic Geometric Shapes Mode (01)A high-autonomy mode where users can manipulate shapes on the screen using the FPGA directional buttons (btn). The shape type is toggled via the fg input:Square: Implemented via coordinate boundary detection.Circle: Calculated using the Euclidean distance formula: $dist = dx^2 + dy^2$.Triangle: Rendered through custom slope-intercept comparison logic.Rhombus: Based on the Manhattan distance algorithm: $|dx| + |dy| \leq 50$.Random Colorization: Integrated with a RandColorGenerator module to change colors on the fly using the center button.3. Drawing & Grid Mode (10)Displays a 32x32 pixel reference grid.Features a mobile cursor for precision positioning or "drawing" simulation.SSD Feedback: Displays "DESEN" (Draw).4. Alternative Bit-Pattern Mode (11)Generates a complex background pattern by leveraging the bit-logic of the horizontal and vertical counters.
System Architecture
The project follows a modular structural modeling approach:

VGA Controller (Main): Manages H-Sync and V-Sync timing for 640x480 @ 60Hz resolution, including front/back porch and blanking intervals.

MPG (Mono Pulse Generator): A custom-built debouncing circuit that filters mechanical noise from the buttons, ensuring single-pulse execution.

RandColorGenerator: A 12-bit color generator (4 bits per RGB channel) that samples a high-speed counter to produce pseudo-random colors.

SSD (Seven Segment Display) Driver: A multiplexed 8-digit driver that converts 6-bit custom encodings into alphanumeric characters.

SoundGenerator: A real-time audio synthesis module that triggers feedback based on user interaction and movement.

Interface & Control Mapping
Hardware Input,Functional Action
sw(1:0),Operating Mode Selection (Chess / Shapes / Draw / Pattern)
"btn(U, D, L, R)","Movement Control (Up, Down, Left, Right)"
btn(C),Color Trigger (Random Color Generator)
sw(2),Velocity Toggle (Switch between standard and high-speed movement)
fg(1:0),"Shape Morphing (Square, Circle, Triangle, Rhombus)"

Technical Specifications
Resolution: 640 x 480 @ 60Hz.

Master Clock: 100 MHz (internally divided to a 25 MHz Pixel Clock).

Color Depth: 12-bit (4096 colors).

Target Hardware: Xilinx Basys 3 / Nexys A7.

Project Structure
vga.vhd: The Top-Level module integrating all components.

MPG.vhd: The debounce logic.

SSD.vhd: The display driver.

RandColorGenerator.vhd: The color randomization logic.

SoundGenerator.vhd: The audio output module.
