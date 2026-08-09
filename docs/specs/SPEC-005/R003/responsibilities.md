---
name: spec-005-r003-responsibilities
description: SPEC-005 R003 — Registry Responsibilities. 18 RRR.
agent: general
---

# R003 — Registry Responsibilities

> **SPEC-005**: Registry · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Registry phải chịu trách nhiệm gì?**

## Invariants

- Một Responsibility chỉ có một Owner.
- Một Responsibility có thể delegate.
- Owner không đổi trong một Entry vòng đời.
- Không Responsibility nào phụ thuộc vòng.

## Delegation

| Responsibility | Delegate cho |
|----------------|--------------|
| Resolution | Runtime (S014) |
| Policy | Runtime (S012) |
| Governance | Runtime (S013) |

## Responsibilities (18)

| ID | Responsibility | Group | Priority |
|----|----------------|-------|----------|
| RRR-001 | Khai báo Entry | Core | Critical |
| RRR-002 | Lưu trữ Entry | Core | Critical |
| RRR-003 | Validate Entry | Validation | Critical |
| RRR-004 | Version Entry | Data | High |
| RRR-005 | Resolve Entry | Execution | Critical |
| RRR-006 | Discover Entry | Data | High |
| RRR-007 | Query Registry | Data | High |
| RRR-008 | Quản lý Domains | Core | High |
| RRR-009 | Check Compatibility | Validation | High |
| RRR-010 | Enforce Ownership | Governance | Critical |
| RRR-011 | Track Lookup | Observability | High |
| RRR-012 | Publish Registry Events | Observability | High |
| RRR-013 | Cache Read | Core | Medium |
| RRR-014 | Quản lý Deprecation | Data | High |
| RRR-015 | Quản lý Groups | Core | Medium |
| RRR-016 | Quản lý Lifecycle | Execution | Critical |
| RRR-017 | Thực thi Registry Governance | Governance | Critical |
| RRR-018 | Từ chối Entry không hợp lệ | Governance | Critical |

## Machine-readable

```text
responsibilities.yaml
ownership.yaml
responsibility-mapping.yaml
responsibility-matrix.yaml
responsibility-registry.yaml
responsibilities.schema.json
```

## Tham chiếu

- R001: `../R001-vision.md`
- S014: `../../SPEC-001/S014/registry.md`
- Constitution: `docs/specs/SPEC-000/`
