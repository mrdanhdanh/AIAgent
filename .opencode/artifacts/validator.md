---
name: artifact-validator
description: Artifact Validator — kiểm tra schema, checksum, dependency, duplicate, missing, version.
agent: general
---

# Artifact Validator

## 1. Checks

| # | Mã | Kiểm tra |
|---|-----|----------|
| 1 | ART-001 | Schema — đủ required fields (artifact.schema.yaml) |
| 2 | ART-002 | Type — type nằm trong types.yaml |
| 3 | ART-003 | Checksum — SHA256 khớp với file |
| 4 | ART-004 | Dependency — depends_on id tồn tại |
| 5 | ART-005 | Duplicate — không trùng id |
| 6 | ART-006 | Missing — parent/derived_from tồn tại |
| 7 | ART-007 | Version — version > 0, không trùng version cùng id |
| 8 | ART-008 | Lineage cycle — DAG không cycle |
| 9 | ART-009 | Orphan — artifact không parent, không consumed_by (warning) |

## 2. Validation flow

```
Schema → Type → Checksum → Dependency → Duplicate → Missing → Version → Lineage → Orphan
```

## 3. Error level

- ART-001..007: CRITICAL → block save.
- ART-008: CRITICAL → detect cycle trước save.
- ART-009: WARNING → orphan artifact không chặn.

## 4. Tương tác

- `manager.md` gọi validator trước save.
- `artifact-validator.ps1` — gate script Phase 5.
- Doctor dùng ART-009 để báo artifact dư thừa.