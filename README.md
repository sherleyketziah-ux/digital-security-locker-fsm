# Digital Security Locker using FSM

RTL design and verification of a Digital Security Locker using a Finite State Machine (FSM), simulated on EDA Playground.
Employability Enhancement Course SD0212 - RTL Design and Verification, St. Joseph's Institute of Technology, Chennai.

## Features
- 4-state FSM: IDLE, CHECK, UNLOCKED, LOCKOUT
- 4-bit password stored as a parameter (default `4'b1010`)
- 2-bit wrong-attempt counter
- Buzzer and permanent lockout after 3 wrong attempts (until reset)
- Asynchronous active-high reset

## Files
| File | Description |
|------|-------------|
| `digital_security_locker.v` | RTL design (Verilog) |
| `tb_security_locker.v` | Self-checking testbench |
| `waveform.png` | EPWave simulation output |
| `Digital_Security_Locker_Presentation.pptx` | Project presentation |
| `Project_Report.pdf` | Project report |

## How to run
1. Open [EDA Playground](https://www.edaplayground.com) and choose Verilog.
2. Paste `digital_security_locker.v` into the design pane and `tb_security_locker.v` into the testbench pane.
3. Enable **Open EPWave after run** and click **Run**.
4. The log prints `PASS: Lockout and buzzer verified.` and EPWave shows the waveform.

## Result
attempt_count goes 0 -> 1 -> 2 -> 3 on three wrong passwords, the buzzer turns on at the third wrong attempt, and unlock stays 0 even when the correct password is entered after lockout.

## Team
- P. Prithika (312424106128)
- Sherley Ketziah (312424106162)
- Ranjana Devi (312424106131)
- Yoga (312424106188)
