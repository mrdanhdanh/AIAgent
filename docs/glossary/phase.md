---
name: glossary-phase
description: Thuật ngữ Phase — bước trong workflow, gắn với một capability.
agent: general
---

# Term: Phase

**Definition**: A step within a workflow, mapped to a capability to be fulfilled.

**Owns**:
- capability reference
- depends_on (phase trước)
- inputs / outputs (artifact types)

**Does not own**:
- State (thuộc workflow)
- Agent (chọn bởi resolver)
- Context (cấp riêng)

**Quan hệ**:
- Workflow → Phase → Task (Object Model).
- Mỗi phase liên kết đúng 1 capability (P006).
- Phase có thể skip nếu điều kiện không thỏa.

**Format**: `lowercase` — analysis, planning, implementation, review, testing.

**Tham chiếu**: P001, P006.