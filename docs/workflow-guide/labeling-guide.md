# GitHub Labeling Guide (WHAT–WHY–WHEN)

## 🎯 Purpose
This project uses a strict labeling system to ensure:
- Clear task ownership
- No ambiguity in priorities
- Zero dependency on meetings

Every issue must clearly answer:
- WHAT is affected?
- WHY does this issue exist?
- WHEN should it be completed?

---

## 🏷️ Label Categories



### 1. WHAT — 🛠️ Component Labels
These describe **which part of the system** the issue belongs to.

Examples:

>| Label Name              | Description                   |
>|------------------------|-------------------------------|
>| `design-alu`           | ALU RTL design                | 
>| `design-decoder`       | Instruction decode logic      | 
>| `design-regfile`       | Register file design          |
>| `design-instr-mem`     | Instruction memory design     | 
>| `verification-alu`     | ALU verification              | 
>| `verification-decoder` | Decoder verification          | 
>| `verification-integration` | Integration verification |
>| `verification-instr-mem` | Instruction memory verification | 
>| `integration`          | Cross-module integration      | 
>| `docs`                 | Documentation                 |


Rules:
- Exactly ONE component label per issue
- Must match architecture blocks
- No generic labels like `rtl` or `misc`

---

### 2. WHY — 🧠 Issue Type Labels
These describe **why the issue exists**.

>| Label Name     | Description           |
>|----------------|-----------------------|
>| `feature`      | New functionality     |
>| `bug`          | Bug fix               |
>| `enhancement`  | Improvement           |
>| `cleanup`      | Refactor or cleanup   |

Rules:
- Exactly ONE type label
- Do not mix types

---

### 3. WHEN — ⏱️ Priority Labels
These describe **urgency and execution order**.

>| Label Name     | Description        |
>|----------------|--------------------|
>| `P0-critical`  | Blocks other work  |
>| `P1-high`      | High priority      |
>| `P2-medium`    | Normal priority    |
>| `P3-low`       | Low priority       |

Rules:
- Exactly ONE priority label
- Blocking issues must be P0

---

## 📌 Ownership
Ownership is defined by the **Assignee**, not labels.

Rules:
- Exactly ONE assignee per issue
- Assignee is responsible for implementation, testing, and closure

---

## ✅ Valid Issue Checklist
An issue is valid only if:
- One WHAT label
- One WHY label
- One WHEN label
- One assignee
- Clear acceptance criteria

---

## 🤖 Automated Label Validation

All new issues are **automatically validated** using a GitHub Action.

### What is validated
On issue creation, the workflow checks that:

- Exactly **one WHAT label** is present
- Exactly **one WHY label** is present
- Exactly **one WHEN label** is present
- An **assignee** is set

### What happens if validation fails
- The issue is **automatically flagged**
- A bot comment explains what is missing
- The issue may be **closed automatically** if not fixed

### Important Notes
- Validation is enforced by automation, not manually
- Re-opening an issue without fixing labels will re-trigger validation
- Do **not** bypass the workflow by removing labels later

> 📌 If your issue fails validation, **fix the labels and assignee** — do not create a new issue.

---



## 📖 Philosophy
Labels provide visibility.
Issues provide ownership.

No meetings required.
