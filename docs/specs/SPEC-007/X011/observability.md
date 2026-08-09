---
name: spec-007-x011-observability
description: SPEC-007 X011 - Artifact Observability. Events, metrics, audit, traces (S011).
agent: general
---

# X011 - Artifact Observability

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Trang thai Artifact quan sat duoc nhu the nao?**

## XO001 - Philosophy

- Artifact la output observable (RULE-014).
- Moi thay doi Artifact phai phat Event (S011).
- Khong the debug Artifact ma khong co event/trace.
- Observability la bat buoc (P005, XNF-004).

## XO002 - Principles

- **Event-first** - moi stage/transition co event.
- **Immutable events** - chi append (P005).
- **Correlated** - correlation_id xuyen suot.
- **Metrics co label** - phan tich duoc.
- **Audit day du** - ai lam gi, khi nao (XFR-016).

## XO003 - Events (12)

| Event | Y nghia |
|-------|---------|
| ARTIFACT_CREATED | Artifact tao |
| ARTIFACT_VALIDATING | Dang validate |
| ARTIFACT_CHECKSUMMED | Checksum tinh xong |
| ARTIFACT_PUBLISHED | Publish immutable |
| ARTIFACT_VERSIONED | Version moi |
| ARTIFACT_INDEXED | Index xong |
| ARTIFACT_CONSUMED | Co consumer doc |
| ARTIFACT_ARCHIVED | Archive |
| ARTIFACT_REJECTED | Tu choi |
| ARTIFACT_CORRUPTED | Checksum khong khop |
| ARTIFACT_OVERWRITE_BLOCKED | Overwrite bi chan |
| ARTIFACT_RESTORED | Phuc hoi |

Event immutable, append-only, co correlation_id (S011).

## XO004 - Metrics (9)

artifact_created_total, artifact_published_total, artifact_rejected_total,
artifact_archived_total, artifact_consumed_total, artifact_storage_bytes,
artifact_checksum_total, artifact_publish_latency_seconds, artifact_overwrite_blocked_total.

Labels: artifact_id, state, execution_id, producer_id.

## XO005 - Traces (8 spans)

artifact.create / validate / checksum / publish / version / index / consume / archive.
Span attrs: artifact_id, execution_id, version, producer_id.

## XO006 - Audit

who / what / when / where / why - append-only (S011).
XFR-016 bat buoc ghi audit moi thay doi Artifact.

## XO007 - Correlation

correlation_id (Artifact) + trace_id (Runtime) + execution_id (Execution)
-> lien ket moi observability voi Execution.

## XO008 - Dashboard

Artifact Activity, Lifecycle, Failures, Storage Usage, Retention Status.
Tool: X020 Artifact Dashboard.

## XO009 - Health Checks (5)

create_ok, checksum_ok (luon khop), publish_ok,
event_ok (day du), policy_ok (S012).
Score tinh trong X019 Doctor.

## Tham chieu

- S011 Observability - SPEC-001
- RULE-014 Observability Contract
- X019 Doctor - SPEC-007
