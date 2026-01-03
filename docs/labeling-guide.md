# GitHub Labeling Guide (WHAT–WHY–WHEN)

## Purpose
This project uses a strict labeling system to ensure:
- Clear task ownership
- No ambiguity in priorities
- Zero dependency on meetings

Every issue must clearly answer:
- WHAT is affected?
- WHY does this issue exist?
- WHEN should it be completed?

---

## Label Categories

### 1. WHAT — Component Labels
These describe **which part of the system** the issue belongs to.

Examples:
- design-alu
- design-decoder
- design-regfile
- verification-alu
- verification-integration
- docs

Rules:
- Exactly ONE component label per issue
- Must match architecture blocks
- No generic labels like `rtl` or `misc`

---

### 2. WHY — Issue Type Labels
These describe **why the issue exists**.

Allowed labels:
- feature — new functionality
- bug — incorrect or broken behavior
- enhancement — improvement to existing logic
- cleanup — refactoring or formatting
- test — testbench or coverage work

Rules:
- Exactly ONE type label
- Do not mix types

---

### 3. WHEN — Priority Labels
These describe **urgency and execution order**.

Priority levels:
- P0-critical — blocks other work
- P1-high — important
- P2-medium — normal priority
- P3-low — optional / polish

Rules:
- Exactly ONE priority label
- Blocking issues must be P0

---

## Ownership
Ownership is defined by the **Assignee**, not labels.

Rules:
- Exactly ONE assignee per issue
- Assignee is responsible for implementation, testing, and closure

---

## Valid Issue Checklist
An issue is valid only if:
- One WHAT label
- One WHY label
- One WHEN label
- One assignee
- Clear acceptance criteria

---

## Philosophy
Labels provide visibility.
Issues provide ownership.

No meetings required.
