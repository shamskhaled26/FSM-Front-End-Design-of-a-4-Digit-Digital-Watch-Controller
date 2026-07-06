# FSM-Based 4-Digit Digital Watch Controller

## Overview

This project presents the RTL implementation of a **4-Digit Digital Watch Controller** using **Verilog HDL**. The design is based on a hierarchical **Finite State Machine (FSM)** architecture that manages multiple operating modes while maintaining a modular and synthesizable RTL structure.

The controller supports real-time clock operation, time setting, alarm configuration, and stopwatch functionality using only two push-button inputs. Functional verification was performed using automated self-checking testbenches in **QuestaSim**.

---

## Features

- 24-hour digital clock (HH:MM)
- Time setting mode
- Alarm setting mode
- Daily and hourly alarm support
- Stopwatch with Start, Stop, Resume, Split, and Clear operations
- Hierarchical FSM-based control logic
- Modular RTL design
- Automated self-checking verification testbenches
- Functional simulation using QuestaSim

---

## System Architecture

The design consists of the following modules:

- **Top Module** – Integrates all system components.
- **Controller FSM** – Controls operating modes and system transitions.
- **Timekeeping Module** – Maintains and updates the real-time clock.
- **Alarm Module** – Configures and triggers daily/hourly alarms.
- **Stopwatch Module** – Implements stopwatch functionality.
- **Display Multiplexer** – Selects the active display output.
- **Push-Button Edge Detector** – Generates single-cycle pulses for button presses.

---

## Verification

The design was verified using dedicated module-level and top-level self-checking testbenches covering:

- System reset
- Normal time counting
- Time-setting functionality
- Alarm configuration
- Daily and hourly alarm triggering
- Stopwatch start, stop, resume, split, and clear operations
- FSM state transitions
- Full system integration

---

## Tools

- **Language:** Verilog HDL
- **Design Methodology:** RTL Design, Finite State Machines (FSM)
- **Simulation:** Siemens QuestaSim
- **Verification:** Self-Checking Testbenches

---

## Repository Structure

```
├── RTL/
│   ├── Controller_FSM.v
│   ├── Time_Display.v
│   ├── Alarm.v
│   ├── Stopwatch.v
│   ├── Display_MUX.v
│   ├── Push_Button_Edge.v
│   └── Top.v
│
├── Testbench/
│   ├── alarm_tb.v
│   ├── stopwatch_tb.v
│   ├── time_display_tb.v
│   └── top_tb.v
│
├── Waveforms/
│
├── Report/
│
└── README.md
```

*(Update the folder names above if your repository structure differs.)*

---

## Key Learning Outcomes

- RTL design using Verilog HDL
- Hierarchical Finite State Machine (FSM) design
- Modular digital system architecture
- Functional verification with self-checking testbenches
- Simulation and debugging using QuestaSim

---

## Authors

- Shams Khaled Ezzat
- Mariz Mamdouh Moris
- Marvey Ehab Fathy
- Ahmed Mohamed Mohamed

---

## License

This project was developed for academic purposes as part of the Digital Design course at Ain Shams University.
