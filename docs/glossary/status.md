---
name: glossary-status
description: Thuật ngữ Status — mức trưởng thành khai báo của entity.
agent: general
---

# Term: Status

**Definition**: The declared maturity level of an entity (metadata), distinct from runtime state.

**Owns**:
- value (draft/experimental/stable/deprecated/removed)

**Does not own**:
- Runtime state

**Quan hệ**:
- Status là metadata khai báo (P003).
- Status khác State (runtime).
- Deprecated entity → có replacement + deprecation window.

**Ví dụ**: `status: stable`, `status: deprecated`.

**Tham chiếu**: P003, P009, P015.