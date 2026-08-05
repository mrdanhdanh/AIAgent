---
name: knowledge-validator
description: Validator — kiểm tra graph: broken link, missing entity, cycle, duplicate, orphan.
agent: general
---

# Validator

## 1. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | KG-001 | Broken link — relation trỏ entity không tồn tại |
| 2 | KG-002 | Missing entity — entity trống required field |
| 3 | KG-003 | Cycle — graph không cycle (quan hệ phụ thuộc) |
| 4 | KG-004 | Duplicate — trùng entity id / trùng name+type |
| 5 | KG-005 | Orphan — entity không relation (warning) |
| 6 | KG-006 | Schema — đúng entity/relation schema |

## 2. Validation flow

```text
Validate entity schema (KG-006)
  → check duplicate id (KG-004)
  → check relation target/source tồn tại (KG-001)
  → check cycle (KG-003)
  → check orphan (KG-005)
```

## 3. Error level

- KG-001/003/004/006 → CRITICAL (block persist).
- KG-002 → WARNING.
- KG-005 → WARNING (orphan).

## 4. Tương tác

- `indexer.md` — validate trước persist.
- Doctor — gọi validator như static check.
- `knowledge-graph-validator.ps1` — gate Phase 9.