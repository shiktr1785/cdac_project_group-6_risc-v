# RV32I RISC-V Architecture Overview

This project implements a fundamental subset of the `RV32I RISC-V Instruction Set Architecture (ISA)`. The design focuses on a modular single-cycle execution flow, prioritizing clear data-paths between the instruction fetch, decoding, and execution stages.

## RV32I RISC-V Subset block diagram

```mermaid

%%{ init:{ 'themeVariables': { 'fontSize': '40px' } } }%%

flowchart LR
    %% ---------- Styling ----------
    classDef largeNode width:300px,height:200px,font-size:40px;

    subgraph InstructionMemory
        direction LR
        A[INSTRUCTION<br/>MEMORY]
    end

    subgraph Decoder
        direction LR
        B[Instruction<br/>Decoder]
    end

    subgraph BranchUnit
        direction LR
        C{BRANCH<br/>UNIT}
    end

    subgraph ALU
        direction LR
        D{ALU}
    end


    subgraph RegFile
        direction LR
        E[REG<br/>FILE<br/>32x32 x0=0]
    end

    subgraph PC
        direction LR
        F[PC]
    end

    A --> F
    F --> B
    B -- "op_type_jal_jalr" --> C
    B -- "op_typebeq_bneblt_bge" --> C
    C -- "imm[31:0]" --> D
    B -- "imm[31:0]" --> D
    B -- "imm[31:0]" --> E
    E -- "rs1[5:0]" --> B
    E -- "rs2[5:0]" --> B
    B -- "imm_en" --> D
    B -- "s_sel" --> D
    B -- "s_valid" --> D
    B -- "op_done" --> D
    D -- "alu_out[31:0]" --> E
    D -- "alu_out_valid" --> E

`````

### Core Architectural Components

The architecture is divided into several specialized functional blocks:

- `Control Flow (PC & Instruction Memory)`: The Program Counter (PC) drives the instruction fetch process from the Instruction Memory, ensuring sequential execution or handling jumps as directed by the logic flow.

- `Instruction Decoder`: Acts as the central intelligence of the processor. It parses incoming instructions to extract opcodes, register addresses `(rs1, rs2)`, and immediate values. It generates control signals such as `imm_en` and `s_sel` to oechestrate the rest of the hardware.

- `Register File (32x32)`: A standard RISC-V bank of 32 genral-purpose registers, for each 32 bits wide. Notably, it implements the hardware requirement where the `x0` register is hardwired to zero.

- `Execution Units`:
    - `ALU (Arithmetic Logic Unit)`: Performs the core computational tasks (addition, subtraction, logical shifts) and outputs the final result `(alu_out)` and a validity signal back to the Register file.

    - `Branch Unit`: Specifically handles control-flow instructions like `JAL`, `JALR`, and conditional branches (`BEQ`, `BNE`, etc), calculating target addresses using sign-extended immediates.

## Data Path & Control Logic

The diagram illustrates a tightly coupled feedback loop between the `Decoder` and the `ALU`. The decoder provides the ALU with necessary operands, whether they are direct immediate values (`imm[31:0]`) or control parameters. While the ALU communicates the completions of operations via `op_done` and `alu_out_valid`. This ensures that data is only written back to the Register File once the execution cycle is successfully completed.