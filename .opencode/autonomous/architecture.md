---
name: autonomous-architecture
description: Kiến trúc Autonomous Mode — autonomy levels, gates, policy-bound execution.
agent: general
---

# Autonomous Mode — Architecture

## 1. Components

```text
Autonomy Config (autonomous.schema.yaml)
        │
        ▼
Gate Orchestrator (simulation → doctor → approval)
        │
        ▼
Auto Execution (via kernel)
        │
        ▼
Auto Review → Auto Evolution → Auto Release
```

## 2. Gate chain

```text
Workflow request
  → Simulation (risk, confidence)
  → risk/confidence theo level? → tiếp
  → Doctor (health gate)
  → health đạt? → tiếp
  → Approval policy (auto/human)
  → execute
```

## 3. Decision table

| Risk | Confidence | Health | Autonomy L3 |
|------|------------|--------|-------------|
| <=30 | >=90 | >=95 | auto execute |
| 31-60 | 70-89 | 90-94 | auto với warning |
| >60 | <70 | <90 | dừng, human |

## 4. Policy-bound

- Autonomous không bao giờ vượt policy allow/deny.
- Trust & Safety là override cuối (không tự vượt).

## 5. Tương tác

- `autonomous.schema.yaml`.
- `simulation/`, `doctor/`, `trust/`, `policy/`.
- `evolution/`, `release/` — tự hoàn tất vòng lặp.