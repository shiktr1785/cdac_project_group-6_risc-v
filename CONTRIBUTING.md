# Contributing Guidelines

Thank you for contributing to this project.

This repository follows a **strict issue-driven workflow** to ensure
clarity, ownership, and fast execution.

---

## ⁉️ Issue Creation Rules

Every issue MUST include:
- One WHAT label (component)
- One WHY label (type)
- One WHEN label (priority)
- One assignee

Issues missing any of these will be closed.

Refer to:
docs/labeling-guide.md

---

## 👑 Ownership Rules
- One issue = one owner
- Owner is responsible for:
  - Implementation
  - Local testing
  - Updating issue status
  - Closing the issue

---

## 👩‍💻 Code Contributions
- All code must reference an issue number
- Small, atomic commits are preferred
- Push only working code

---

## ✅ Example: Correct Contribution Flow

This example demonstrates a **proper contribution** that follows all project rules.

---

### 📌 Example Issue

>
>**[VERIF][MEM] Add sequential address iteration testcase**
>
>**Labels**
>- WHAT: `verification`
>- WHY: `feature`
>- WHEN: `medium`
>
>**Assignee**
>-@contributor1
>
>**Issue Description (summary)**
>- Implement verification testcase for sequential address iteration
>- Validate read/write behavior across address range
>- Add basic checks and logging
>
---

Once assigned:

- The assignee becomes the **sole owner** of the issue
- No one else modifies the same functionality without coordination
- All questions and decisions are discussed **inside the issue**

---

### 💻 Code Contribution

**Branch name** verif/mem-seq-addr-iteration


**Commit message example**
```
[VERIF][MEM] Add sequential address iteration testcase Ref: #42 
```
Rules followed:
- Commit references the issue number
- Commit is small and focused
- Code builds and runs locally

---

### 🔄 Issue Updates

During development:
- Update issue status → `In Progress`
- Post blockers or clarifications as comments
- Attach logs or screenshots if required

After completion:
- Push final code
- Update issue status → `Review`
- Close issue after approval

---

### ❌ Incorrect Contribution Examples

The following are **not allowed**:

- Pushing code without an issue
- One person working on multiple unrelated issues
- Discussing technical decisions only on Discord
- Large commits covering multiple features

---

## 💬 Communication
- Technical discussions happen in issue comments
- Decisions must be documented in issues

---

## 📌 Summary

If you follow this workflow:
- Your contribution will **not be rejected**
- Reviews will be faster
- The project remains clean, traceable, and review-friendly