---
name: spec-004-a018-evolution
description: >
  SPEC-004 A018 — Agent Evolution. Trả lời: Agent tự học và cải thiện như thế
  nào? Học từ dữ liệu quan sát (A011) — mọi thay đổi qua Approval Gate (A013).
  Mirror C018 (SPEC-003).
agent: general
---

# A018 — Agent Evolution

> **SPEC-004**: Agent System · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Agent tự học và cải thiện như thế nào?**

## AVE001 — Evolution Philosophy

- Agent Evolution học từ dữ liệu quan sát (A011).
- Evolution không quyết định thay con người.
- Mọi thay đổi đều qua Approval Gate (A013).
- Không Breaking Change khi chưa được duyệt.

## AVE002 — Evolution Principles

- **Evidence Based** (A011 + A016) · **Read Only** · **Approved** (A013) · **Versioned** (A014) · **Reversible** · **Non-invasive**.

## AVE003 — Evolution Scope

**Đọc:**

- Agent Event (A011) · Metrics (A011) · Trace (A011) · Audit (A011) · Compliance Report (A016) · Registry (A014).

**Không đọc:**

- Implementation · Business Data · User Data · Agent Internal State · Plugin Internal State.

## AVE004 — Evolution Data Sources

- A011 domains: Event/Metrics/Trace/Audit.
- A016: Compliance Report.
- A014: Registry.
- Mọi dữ liệu có correlation_id (A011).

## AVE005 — Evolution Pipeline

```text
Collect (A011 data)
    ↓
Analyze (patterns, anomalies)
    ↓
Learn (lessons, hypotheses)
    ↓
Propose (evolution proposal)
    ↓
Approval Gate (A013 Governance)
    ↓
Apply (qua Registry A014 + Binding A012)
```

**Rules:** Learn không thay đổi Agent (chỉ Propose); mỗi bước sinh Event + Audit (A011).

## AVE006 — Learning Model

- Học từ patterns + anomalies của Agent Execution.
- Lesson có evidence (A011) — không suy đoán.
- Hypothesis → Proposal.
- Không nói thuật toán.

## AVE007 — Evolution Proposal

```yaml
proposal:
  fields: [id, source, evidence, change, impact, status, approval]
status: [Draft, Submitted, Approved, Rejected, Applied, Rolled Back]
impact: [Low, Medium, High, Breaking]
```

Không evidence → Rejected.

## AVE008 — Approval Gate

- **Low** → auto-approve · **Medium** → Agent · **High/Breaking** → Human bắt buộc.
- Quyết định ghi Audit (A011).
- Breaking cần Simulation (S013 GV011A) trước.

## AVE009 — Evolution Application

- Binding mới là version mới (A012).
- Cập nhật Agent Definition (A009 — Published mới).
- Cập nhật Registry Entry (A014).

## AVE010 — Evolution Safety

- Simulation trước (S013 GV011A).
- Rollback luôn khả dụng.
- Không Breaking Change khi chưa duyệt.
- Apply versioned qua Registry (A014).

## AVE011 — Evolution Events

- AGENT_EVOLUTION_PROPOSED · APPROVED · REJECTED · APPLIED · ROLLED_BACK.

> S011 reuse trực tiếp.

## AVE012 — Evolution Metrics

- proposals · applied · rejected · rolled_back · success_rate · avg_learning_time.

## AVE013 — Evolution Traceability

```text
Evolution Proposal → Evidence (A011) → Agent Execution → Registry Entry (A014)
```

## AVE014 — Evolution Validation

Doctor kiểm tra: Missing Evidence (A011) · Unauthorized Source · Missing Approval (A013) · Breaking Change Without Approval · Invalid Proposal · Apply Không Qua Registry (A014).

## AVE015 — Machine-readable

```text
agent-evolution.yaml
agent-evolution-scope.yaml
agent-evolution-pipeline.yaml
agent-evolution-proposal.yaml
agent-evolution-approval.yaml
agent-evolution-events.yaml
agent-evolution-metrics.yaml
agent-evolution-validation.yaml
agent-evolution.schema.json
```

## AVE016 — Success Criteria

- Evolution chỉ đọc (A011).
- Mọi Proposal có evidence (A011).
- Mọi thay đổi qua Approval Gate (A013).
- Không Breaking Change khi chưa duyệt.
- Mọi Apply versioned + rollback được (A014).
- Doctor xác minh từ machine-readable.

## Tham chiếu

- A011: `../A011/observability.md`
- A012: `../A012/policies.md`
- A013: `../A013/governance.md`
- A014: `../A014/registry.md`
- A016: `../A016/compliance.md`
- C018: `../../SPEC-003/C018/evolution.md` (mẫu)
- Constitution: `docs/specs/SPEC-000/`