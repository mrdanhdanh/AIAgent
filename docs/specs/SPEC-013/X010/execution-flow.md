---
name: SPEC-013-x010-execution-flow
description: SPEC-013 X010 - Evolution Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - Evolution Execution Flow

> **SPEC-013**: Evolution Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Evolution chay nhu the nao?**

## XF001 - Flow Philosophy

- Evolution chay nhu Execution cua Runtime (SPEC-001).
- Evolution thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- Evolution khong doi he thong that (RULE-007).

## XF002 - Flow Principles

- **Pipeline** - Diffed -> Planure -> Run -> Observe -> Compare -> Report.
- **Validate truoc khi run** (XFR-002).
- **Isolated** - khong doi he thong that (RULE-007).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Diffed -> Planure -> Run -> Observe -> Compare -> Report
```

(/doctor --Evolution pipeline)

## XF004 - Canonical Evolution Flow

```text
User
  -> Diffed (Evolution_id sinh) [Evolution_DiffedD]
  -> Planure (thong so) [Evolution_Diffed]
  -> Run (isolated) [Evolution_Diffed]
  -> Observe (ket qua) [Evolution_Diffed]
  -> Compare (voi ky vong) [Evolution_COMPARED]
  -> Report (success rate) [Evolution_Diffed]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Diffed | Evolution Engine | Diff | Evolution | Evolution_DiffedD |
| Planure | Evolution Engine | Plan | Diffed | Evolution_Diffed |
| Run | DiffEngine | Plan | Result | Evolution_Diffed |
| Observe | Observer | result | Diffed | Evolution_Diffed |
| Compare | Comparator | result | Compared | Evolution_COMPARED |
| Report | Reporter | compared | Report | Evolution_Diffed |

## XF006 - Failure Modes

- Diffed fail -> khong Evolution + error.
- Planure fail -> Evolution_FAILED + cleanup.
- Run fail -> Evolution_FAILED + partial result.
- Observe fail -> giu result, retry.
- Compare fail -> khong report + event.
- Report fail -> retry (S012).

## XF007 - Lineage

- Root Evolution: parent = null.
- Follow-up Evolution: parent = Evolution_id truoc.

## XF008 - Query Ops

GetEvolution / GetResult / SearchEvolutions / ListByDiff / GetHistory.
Query khong can grant, khong thay doi Evolution.

## XF009 - Storage

- Diff store (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Khong doi he thong that (Doctor X019).

## Tham chieu

- /doctor --Evolution
- S011 Events - SPEC-001
- S012 Policies - SPEC-001
