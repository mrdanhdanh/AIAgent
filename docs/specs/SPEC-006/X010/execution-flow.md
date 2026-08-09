---
name: spec-006-x010-execution-flow
description: SPEC-006 X010 - Context Execution Flow. 7 stages EF008, failure, lineage.
agent: general
---

# X010 - Context Execution Flow

> **SPEC-006**: Context Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Execution Context chay nhu the nao trong Runtime?**

## XF001 - Flow Philosophy

- Context chay nhu Execution cua Runtime (SPEC-001).
- Context Engine thuc thi EF008 - khong dinh nghia lai flow.
- Khong buoc nao thieu Event (S011).
- Context luon duoc Release truoc Execution ket thuc.

## XF002 - Flow Principles

- **EF008** - Allocate -> Populate -> Distribute -> Mutate -> Merge -> Collect -> Release.
- **Validate truoc khi mutate** (XFR-009).
- **Isolated** - khong chia se Context (P006).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (7)

```text
Allocate -> Populate -> Distribute -> Mutate -> Merge -> Collect -> Release
```

(S010 EF008 - Context Engine thuc thi)

## XF004 - Canonical Context Flow

```text
Execution Created
  -> Allocate (context_id sinh) [CONTEXT_ALLOCATED]
  -> Populate (sections + items) [CONTEXT_POPULATED]
  -> Distribute (ContextGrant) [CONTEXT_DISTRIBUTED]
  -> Agent/Capability Mutate (grant scope) [CONTEXT_MUTATED]
  -> Merge (sub-workflow Context) [CONTEXT_MERGED]
  -> Collect (ket qua) [CONTEXT_COLLECTED]
Execution End
  -> Release (thu hoi + cleanup) [CONTEXT_RELEASED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Allocate | Context Engine | Execution metadata | Context + context_id | CONTEXT_ALLOCATED |
| Populate | Context Engine | sections/items | Validated Context | CONTEXT_POPULATED |
| Distribute | Context Engine | Agent/Capability | ContextGrant | CONTEXT_DISTRIBUTED |
| Mutate | Agent/Capability | key + value | Updated item | CONTEXT_MUTATED |
| Merge | Context Engine | child Context | Merged Context | CONTEXT_MERGED |
| Collect | Context Engine | - | Result set | CONTEXT_COLLECTED |
| Release | Context Engine | - | Freed memory | CONTEXT_RELEASED |

## XF006 - Failure Modes

- Allocate fail -> khong tao Context + error.
- Populate fail -> CONTEXT_REJECTED + cleanup.
- Distribute fail -> thu hoi grant + retry (S012).
- Mutate fail -> rollback item + event.
- Merge fail -> giu Context cha, bao loi.
- Release fail -> CONTEXT_RELEASED_FAILED + manual.

## XF007 - Lineage

- Root Context: parent = null.
- Child Context (sub-workflow): parent = root context_id.
- Merge chi giua cha-con cung Execution.

## XF008 - Query Ops

GetContext / GetSection / GetItem / ListGrants / GetHistory.
Query khong can grant, khong thay doi Context.

## XF009 - Storage

- In-memory, transient (P009).
- Quota theo policy (X012).
- Snapshot optional cho Doctor.

## XF010 - Validation

- Stage order dung EF008.
- Moi stage co event.
- Khong Context leak (Doctor X019).

## Tham chieu

- S010 EF008 - SPEC-001
- S011 Events - SPEC-001
- S012 Policies - SPEC-001
