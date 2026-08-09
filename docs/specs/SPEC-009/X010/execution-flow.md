---
name: spec-009-x010-execution-flow
description: SPEC-009 X010 - Contract Execution Flow. 8 stages S007, failure, lineage.
agent: general
---

# X010 - Contract Execution Flow

> **SPEC-009**: Contract System - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Contract chay nhu the nao trong Runtime?**

## XF001 - Flow Philosophy

- Contract chay nhu Execution cua Runtime (SPEC-001).
- Contract System thuc thi S007 - khong dinh nghia lai flow.
- Khong buoc nao thieu Event (S011).
- Contract luon versioned + compatible (P004/XNF-005).

## XF002 - Flow Principles

- **S007** - Declare -> Validate -> CompatCheck -> Publish -> Resolve -> Verify -> Bind -> Retire.
- **Validate truoc khi publish** (XFR-002).
- **Compatible** - khong pha caller (XNF-005).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (8)

```text
Declare -> Validate -> CompatCheck -> Publish -> Resolve -> Verify -> Bind -> Retire
```

(S007 Contract Model - Contract System thuc thi)

## XF004 - Canonical Contract Flow

```text
Provider khai bao
  -> Declare (contract_id sinh) [CONTRACT_DECLARED]
  -> Validate (schema + invariants) [CONTRACT_VALIDATING]
  -> CompatCheck (backward compatible) [CONTRACT_COMPAT_CHECKED]
  -> Publish (versioned) [CONTRACT_PUBLISHED]
Caller goi
  -> Resolve (tra Contract) [CONTRACT_RESOLVED]
  -> Verify (truoc khi dung) [CONTRACT_VERIFIED]
  -> Bind (gan caller) [CONTRACT_BOUND]
Het han
  -> Retire [CONTRACT_RETIRED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Declare | Contract System | interface | Contract | CONTRACT_DECLARED |
| Validate | Contract System | schema | Validated | CONTRACT_VALIDATING |
| CompatCheck | CompatChecker | version | Compat result | CONTRACT_COMPAT_CHECKED |
| Publish | Contract System | validated | Versioned Contract | CONTRACT_PUBLISHED |
| Resolve | Contract System | contract_id | Contract | CONTRACT_RESOLVED |
| Verify | Verifier | contract | Verified | CONTRACT_VERIFIED |
| Bind | Contract System | caller | Binding | CONTRACT_BOUND |
| Retire | Contract System | - | Retired | CONTRACT_RETIRED |

## XF006 - Failure Modes

- Declare fail -> khong tao Contract + error.
- Validate fail -> CONTRACT_REJECTED + cleanup.
- Compat fail -> khong publish + event.
- Publish fail -> retry (S012).
- Resolve fail -> giu Contract, retry.
- Verify fail -> khong cho dung + event.
- Retire fail -> giu Contract, retry.

## XF007 - Lineage

- Root Contract: parent = null.
- Chain Contract: parent = contract_id truoc (extends).

## XF008 - Query Ops

GetContract / GetVersion / SearchContracts / ListByProvider / GetHistory.
Query khong can grant, khong thay doi Contract.

## XF009 - Storage

- Versioned store (P004), persistent.
- Quota theo policy (X012).
- Snapshot optional cho Doctor.

## XF010 - Validation

- Stage order dung S007.
- Moi stage co event.
- Khong direct call (Doctor X019).

## Tham chieu

- S007 Contract Model - SPEC-001
- TERM-014 Contract
- S012 Policies - SPEC-001
