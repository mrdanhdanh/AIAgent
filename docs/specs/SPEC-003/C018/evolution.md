---
name: spec-003-c018-evolution
description: >
  SPEC-003 C018 — Capability Evolution. Trả lời: Capability tự học và cải
  thiện như thế nào? Học từ dữ liệu quan sát (C011) — mọi thay đổi qua
  Approval Gate (C013). Mirror W018 (SPEC-002).
agent: general
---

# C018 — Capability Evolution

> **SPEC-003**: Capability System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Capability tự học và cải thiện như thế nào?**

## CVE001 — Evolution Philosophy

- Capability Evolution học từ dữ liệu quan sát (C011).
- Evolution không quyết định thay con người.
- Mọi thay đổi đều qua Approval Gate (C013).
- Không Breaking Change khi chưa được duyệt.

## CVE002 — Evolution Principles

- **Evidence Based** (C011 + C016) · **Read Only** · **Approved** (C013) · **Versioned** (C014) · **Reversible** · **Non-invasive**.

## CVE003 — Evolution Scope

**Đọc:**

- Capability Event (C011) · Metrics (C011) · Trace (C011) · Audit (C011) · Compliance Report (C016) · Registry (C014).

**Không đọc:**

- Implementation · Business Data · User Data · Agent Internal State · Plugin Internal State.

## CVE004 — Evolution Data Sources

- C011 domains: Event/Metrics/Trace/Audit.
- C016: Compliance Report.
- C014: Registry.
- Mọi dữ liệu có correlation_id (C011).

## CVE005 — Evolution Pipeline

```text
Collect (C011 data)
    ↓
Analyze (patterns, anomalies)
    ↓
Learn (lessons, hypotheses)
    ↓
Propose (evolution proposal)
    ↓
Approval Gate (C013 Governance)
    ↓
Apply (qua Registry C014 + Binding C012)
```

**Rules:** Learn không thay đổi Capability (chỉ Propose); mỗi bước sinh Event + Audit (C011).

## CVE006 — Learning Model

- Học từ patterns + anomalies của Capability Execution.
- Lesson có evidence (C011) — không suy đoán.
- Hypothesis → Proposal.
- Không nói thuật toán.

## CVE007 — Evolution Proposal

```yaml
proposal:
  fields: [id, source, evidence, change, impact, status, approval]
status: [Draft, Submitted, Approved, Rejected, Applied, Rolled Back]
impact: [Low, Medium, High, Breaking]
```

Không evidence → Rejected.

## CVE008 — Approval Gate

- **Low** → auto-approve · **Medium** → Agent · **High/Breaking** → Human bắt buộc.
- Quyết định ghi Audit (C011).
- Breaking cần Simulation (S013 GV011A) trước.

## CVE009 — Evolution Application

- Binding mới là version mới (C012).
- Cập nhật Capability Definition (C009 — Published mới).
- Cập nhật Registry Entry (C014).

## CVE010 — Evolution Safety

- Simulation trước (S013 GV011A).
- Rollback luôn khả dụng.
- Không Breaking Change khi chưa duyệt.
- Apply versioned qua Registry (C014).

## CVE011 — Evolution Events

- CAPABILITY_EVOLUTION_PROPOSED · APPROVED · REJECTED · APPLIED · ROLLED_BACK.

> S011 reuse trực tiếp.

## CVE012 — Evolution Metrics

- proposals · applied · rejected · rolled_back · success_rate · avg_learning_time.

## CVE013 — Evolution Traceability

```text
Evolution Proposal → Evidence (C011) → Capability Execution → Registry Entry (C014)
```

## CVE014 — Evolution Validation

Doctor kiểm tra: Missing Evidence (C011) · Unauthorized Source · Missing Approval (C013) · Breaking Change Without Approval · Invalid Proposal · Apply Không Qua Registry (C014).

## CVE015 — Machine-readable

```text
capability-evolution.yaml
capability-evolution-scope.yaml
capability-evolution-pipeline.yaml
capability-evolution-proposal.yaml
capability-evolution-approval.yaml
capability-evolution-events.yaml
capability-evolution-metrics.yaml
capability-evolution-validation.yaml
capability-evolution.schema.json
```

## CVE016 — Success Criteria

- Evolution chỉ đọc (C011).
- Mọi Proposal có evidence (C011).
- Mọi thay đổi qua Approval Gate (C013).
- Không Breaking Change khi chưa duyệt.
- Mọi Apply versioned + rollback được (C014).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- C011: `../C011/observability.md`
- C012: `../C012/policies.md`
- C013: `../C013/governance.md`
- C014: `../C014/registry.md`
- C016: `../C016/compliance.md`
- W018: `../../SPEC-002/W018/evolution.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`
