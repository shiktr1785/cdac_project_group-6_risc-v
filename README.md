# C-DAC Final Project | Group - 6 | RISC-V

# 🧩 RISC-V Processor Design & Verification Project

This repository contains the **design, verification, and automation setup** for a RISC-V based processor subsystem, developed as part of an academic group project under the guidance of **Dr. Amit Chavan**, following **industry-style workflows**.

---

## 👨‍🏫 Project Guide
- **Mr. Amit Chavan**

---

## 👥 Team Members  
- Alen Sojan  
- Prithwin Prakash  
- Ritik Kalmegh
- Shikhar Mani Tripathi
- Sidharth V Menon  
---

## [📂 Repository Contents](#repository-layout)
- RTL design (SystemVerilog)
- Verification testcases and plans
- GitHub Issues and Project tracking
- CI-based automation
- Project documentation

---

## 🔄 Workflow Summary
- All tasks are tracked via **GitHub Issues**
- Progress is monitored using **GitHub Projects**
- Communication and updates happen via **Discord**
- Verification and checks are automated where feasible

> For detailed workflow guidelines, labeling conventions, and repository structure, please refer to the `docs/` directory.
>
> - [Issue Creation Checklist](docs/workflow-guide/issue-checklist.md)
> - [Labeling Guide](docs/workflow-guide/labeling-guide.md)
> - [Naming Conventions](docs/workflow-guide/naming-convention.md)


---
---

## 📁 Repository Layout

This repository follows a **strict, locked directory structure** to ensure:
- Clean separation of RTL and verification
- Scalable UVM-based verification
- Easy onboarding for new contributors
- CI/CD and automation friendliness
- Industry-aligned project organization

Any deviation from this structure is **not allowed** without maintainer approval.

---

### 📂 Top-Level Structure

```plaintext
riscv-core/
├── docs/
├── rtl/
├── tb/
├── sim/
├── scripts/
└── .github/
```


---

### 📘 docs/
Project documentation only.  
No source code allowed.

```plaintext
docs/
├── architecture/
├── verification/
└── meeting_notes/
```


- `architecture/` – Block diagrams, interfaces, pipeline description
- `verification/` – Test plans, coverage strategy, regression flow
- `meeting_notes/` – Guide discussions, decisions, action items

---

### 🧠 rtl/ (LOCKED)
Contains **only synthesizable RTL**.

```plaintext
rtl/
├── common/
├── alu/
├── decoder/
├── regfile/
├── instr_mem/
└── top/
```


Rules:
- One block per directory
- No testbench or tool files
- Shared definitions go only in `common/`
- Top-level integration lives in `top/`

---

### 🧪 tb/ (LOCKED)
Contains **all verification code**, primarily UVM.

```plainttext
tb/
├── common/
├── alu/
├── decoder/
├── regfile/
├── instr_mem/
└── top/
```


Rules:
- Mirrors `rtl/` one-to-one
- Each block has its own environment
- Shared testbench utilities go in `common/`
- Full-core verification lives in `top/`

---

### ⚙️ sim/
Tool-specific simulation artifacts.

```plaintext
sim/
├── verilator/
├── questasim/
└── vivado/
```


Rules:
- Simulator scripts only
- Can be freely modified
- Nothing here should be required for synthesis

---

### 🔧 scripts/
Utility scripts for developers and CI.

```plaintext
scripts/
````


Examples:
- Simulation launchers
- Lint helpers
- Regression scripts

---

### 🤖 ci/
Continuous Integration helpers.

```plaintext
ci/
```

Examples:
- Verilator CI configuration
- Linting rules
- Regression hooks

---

### 🐙 .github/
GitHub-specific automation.

```plaintext
.github/
└── workflows/
```

Includes:
- CI pipelines
- Issue enforcement
- Discord notifications

---

## 🔒 Lock Policy

The following directories are **strictly locked**:
- `rtl/`
- `tb/`

Only new **block subdirectories** may be added.
No ad-hoc restructuring is permitted.

Violations may result in PR rejection.

---

> 📌 This project emphasizes **verification discipline, collaboration, and documentation**, not just RTL implementation.
>
> 📌 Please adhere to all **guidelines** to ensure a smooth development process.
