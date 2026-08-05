---
name: artifact-tests
description: Artifact Tests — test cases cho CRUD, version, history, checksum, index, dependency, lineage.
agent: general
---

# Artifact Tests

## 1. Test cases

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Create artifact | id generated, v=1, status=created |
| 2 | Update artifact | version bump, history saved |
| 3 | Delete artifact | status=deleted, not in active index |
| 4 | Version history | Manager.History returns all versions |
| 5 | Checksum mismatch | validator ART-003, Doctor detect |
| 6 | Index lookup | FindByType O(1) |
| 7 | Invalid type | validator ART-002 |
| 8 | Missing dependency | validator ART-006 |
| 9 | Duplicate id | validator ART-005 |
| 10 | Lineage cycle | validator ART-008 |
| 11 | Orphan detection | validator ART-009 (warning) |
| 12 | Query by tag | FindByTag returns correct |
| 13 | Contract consume | builder reads plan artifact |
| 14 | Cache reuse | cache hit trên artifact read |
| 15 | Diff generation | diff between v1 and v2 |

## 2. Cách chạy

- Unit test gọi Manager + Validator với mock Repository.
- Không cần server/LLM.
- `artifact-validator.ps1` là gate Phase 5 (validate structure).

## 3. Target

- Coverage: Create/Update/Delete/Query/Validate.
- Lineage DAG cycle detection coverage.