---
name: glossary-artifact
description: Thuật ngữ Artifact — output versioned + checksum + lineage.
agent: general
---

# Term: Artifact

**Definition**: An immutable output object produced by an agent, with version, checksum, and lineage.

**Owns**:
- Content
- Version
- Checksum (SHA256)
- Lineage (parent, derived_from)

**Does not own**:
- State
- Workflow

**Quan hệ**:
- Agent **produces** artifact.
- Artifact **immutable** (P013) — không sửa, chỉ tạo version.
- Truy cập qua Artifact Store, không đọc file trực tiếp.

**Format**: `PREFIX-NNN` — ví dụ `PLAN-001`.

**Tham chiếu**: P003, P009, P013.