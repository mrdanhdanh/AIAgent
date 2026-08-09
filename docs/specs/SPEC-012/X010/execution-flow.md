---
name: spec-012-x010-execution-flow
description: SPEC-012 X010 - Simulation Execution Flow. 6 stages, failure, lineage.
agent: general
---

# X010 - Simulation Execution Flow

> **SPEC-012**: Simulation Engine - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Simulation chay nhu the nao?**

## XF001 - Flow Philosophy

- Simulation chay nhu Execution cua Runtime (SPEC-001).
- Simulation thuc thi pipeline - khong dinh nghia lai.
- Khong buoc nao thieu Event (S011).
- Simulation khong doi he thong that (RULE-007).

## XF002 - Flow Principles

- **Pipeline** - Define -> Configure -> Run -> Observe -> Compare -> Report.
- **Validate truoc khi run** (XFR-002).
- **Isolated** - khong doi he thong that (RULE-007).
- Moi buoc co trace + event (S011).

## XF003 - Execution Stages (6)

```text
Define -> Configure -> Run -> Observe -> Compare -> Report
```

(/doctor --simulation pipeline)

## XF004 - Canonical Simulation Flow

```text
User
  -> Define (simulation_id sinh) [SIMULATION_DEFINED]
  -> Configure (thong so) [SIMULATION_CONFIGURED]
  -> Run (isolated) [SIMULATION_RUNNING]
  -> Observe (ket qua) [SIMULATION_OBSERVED]
  -> Compare (voi ky vong) [SIMULATION_COMPARED]
  -> Report (success rate) [SIMULATION_REPORTED]
```

## XF005 - Stage Detail

| Stage | Actor | Input | Output | Event |
|-------|-------|-------|--------|-------|
| Define | Simulation Engine | scenario | Simulation | SIMULATION_DEFINED |
| Configure | Simulation Engine | config | Configured | SIMULATION_CONFIGURED |
| Run | ScenarioEngine | config | Result | SIMULATION_RUNNING |
| Observe | Observer | result | Observed | SIMULATION_OBSERVED |
| Compare | Comparator | result | Compared | SIMULATION_COMPARED |
| Report | Reporter | compared | Report | SIMULATION_REPORTED |

## XF006 - Failure Modes

- Define fail -> khong simulation + error.
- Configure fail -> SIMULATION_FAILED + cleanup.
- Run fail -> SIMULATION_FAILED + partial result.
- Observe fail -> giu result, retry.
- Compare fail -> khong report + event.
- Report fail -> retry (S012).

## XF007 - Lineage

- Root Simulation: parent = null.
- Follow-up Simulation: parent = simulation_id truoc.

## XF008 - Query Ops

GetSimulation / GetResult / SearchSimulations / ListByScenario / GetHistory.
Query khong can grant, khong thay doi Simulation.

## XF009 - Storage

- Scenario store (P005), persistent.
- Quota theo policy (X012).
- Snapshot optional.

## XF010 - Validation

- Stage order dung pipeline.
- Moi stage co event.
- Khong doi he thong that (Doctor X019).

## Tham chieu

- /doctor --simulation
- S011 Events - SPEC-001
- S012 Policies - SPEC-001
