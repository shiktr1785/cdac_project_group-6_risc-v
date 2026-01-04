# 📐 Naming Conventions

This document defines **mandatory naming rules** for the entire repository.
All contributors must follow these rules.

Violations will result in:
- PR rejection
- CI failure (future)
- Reviewer block

---

## 1️⃣ Global Rules

- Lowercase only
- Snake_case (`_`) naming
- Meaningful, descriptive names
- One block = one naming prefix
- No personal or stylistic variations

✅ Correct:
```
alu_add
regfile_read
instr_mem_model
```


❌ Incorrect:
```
ALUAdd
registerFile
mem1
```


---

## 2️⃣ Directory Naming Rules

>| Category | Rule | Example |
>|-------|------|--------|
>| RTL block | Functional name | `alu/` |
>| TB block | Same as RTL | `tb/alu/` |
>| Shared code | `common/` only | `rtl/common/` |
>| Top-level | `top/` only | `rtl/top/` |

🚫 No nested or custom folders without approval.

---

## 3️⃣ RTL Naming Rules

### Module Names

```
<block>_<function>[_<detail>]
```

Examples:
```
alu
decoder
regfile
instr_mem
riscv_core
```


---

### Package Names
```
<block>_pkg
```


Examples:
```
alu_pkg
regfile_pkg
```

---

### Interface Names
```
<block>_<interface>_if
```
Examples:
```
alu_if
regfile_if
```


---

## 4️⃣ Testbench (UVM) Naming Rules

### Testbench Top
```
<block>_tb_top
```
Examples:
```
alu_tb_top
regfile_tb_top
```

---

### UVM Components
```
<block>_<component>
```
Examples:
```
alu_env
regfile_agent
instr_mem_driver
```


---

### Sequences
```
<block>_<operation>_seq
```


---

### Tests
```
<block>_<scenario>_test
```
Examples:
```
alu_basic_test
regfile_reset_test
```


---

## 5️⃣ Signal Naming Rules

>| Signal Type | Convention |
>|-----------|------------|
>| Clock | `clk` |
>| Reset | `rst_n` |
>| Input | `i_<name>` |
>| Output | `o_<name>` |
>| Enable | `<name>_en` |
>| Valid | `<name>_valid` |
>| Ready | `<name>_ready` |

Example:
