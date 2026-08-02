---
name: glossary-version
description: Thuật ngữ Version — số hiệu phiên bản bất biến.
agent: general
---

# Term: Version

**Definition**: An immutable integer (or semver) identifying a specific revision of an entity.

**Owns**:
- number (1, 2, 3... hoặc MAJOR.MINOR.PATCH)
- immutability (content không đổi sau publish)

**Does not own**:
- State
- Content biến đổi

**Quan hệ**:
- Mọi entity versioned (P009).
- Không overwrite — tạo version mới (P013).
- Backward compatible (P015).

**Ví dụ**: agent v2, artifact PLAN-001 v3.

**Tham chiếu**: P009, P013, P015.