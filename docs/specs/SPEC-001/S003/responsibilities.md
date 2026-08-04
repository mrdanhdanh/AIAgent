---
name: spec-001-s003-responsibilities
description: >
  SPEC-001 S003 — Runtime Responsibilities. Trả lời: Runtime chịu trách nhiệm
  về những gì? Phân rã 20 FR thành 14 trách nhiệm kiến trúc.
  Vẫn chưa nói implementation/component/class.
agent: general
---

# S003 — Runtime Responsibilities

> **SPEC-001**: Runtime Kernel · **Version**: 1.0.0 · **Trạng thái**: Draft

## Câu hỏi duy nhất

> **Runtime chịu trách nhiệm về những gì?**

- **S002** trả lời: *Runtime phải làm được gì?* (Requirements)
- **S003** trả lời: *Runtime chịu trách nhiệm về những gì?* (Responsibilities)

## Nguyên tắc phân rã

- Mỗi trách nhiệm gom một nhóm Functional Requirement có cùng mục đích.
- Mỗi trách nhiệm liên kết ≥1 Principle + Rule (Constitution).
- Trách nhiệm **không** nói component/class — chỉ nói "Runtime chịu trách nhiệm X".

## 14 Trách nhiệm

| ID | Responsibility | Priority | Category | Từ FR |
|----|----------------|----------|----------|-------|
| RESP-001 | Execution Initiation | Critical | Core | FR-001, FR-015 |
| RESP-002 | Workflow Management | Critical | Core | FR-002, FR-013 |
| RESP-003 | Capability Resolution | Critical | Core | FR-003, FR-014 |
| RESP-004 | Agent Orchestration | Critical | Execution | FR-004 |
| RESP-005 | Context Management | Critical | State | FR-005, FR-016 |
| RESP-006 | State Management | Critical | State | FR-006 |
| RESP-007 | Event Emission | High | Events | FR-007 |
| RESP-008 | Artifact Production | High | Data | FR-008, FR-020 |
| RESP-009 | Metrics Collection | High | Observability | FR-009 |
| RESP-010 | Simulation Support | Medium | Execution | FR-010 |
| RESP-011 | Replay Support | Medium | Execution | FR-011 |
| RESP-012 | Execution Control | High | Execution | FR-012, FR-017, FR-018 |
| RESP-013 | Lifecycle Management | Critical | Execution | FR-015 |
| RESP-014 | Governance Enforcement | Medium | Governance | FR-019 |

## Chi tiết trách nhiệm

### RESP-001 — Execution Initiation
Runtime chịu trách nhiệm khởi tạo Execution Context và bắt đầu Execution.
- Yêu cầu: FR-001, FR-015
- Principle: P001, P003
- Rule: RULE-004

### RESP-002 — Workflow Management
Runtime chịu trách nhiệm nạp, validate và quản lý Workflow Definition.
- Yêu cầu: FR-002, FR-013
- Principle: P001, P011
- Rule: RULE-004

### RESP-003 — Capability Resolution
Runtime chịu trách nhiệm resolve và validate Capability/Contract.
- Yêu cầu: FR-003, FR-014
- Principle: P007, P002
- Rule: RULE-002, RULE-003

### RESP-004 — Agent Orchestration
Runtime chịu trách nhiệm điều phối Agent theo Capability đã resolve.
- Yêu cầu: FR-004
- Principle: P001, P007
- Rule: RULE-004

### RESP-005 — Context Management
Runtime chịu trách nhiệm tạo/đọc/đóng Execution Context, cô lập giữa các Execution.
- Yêu cầu: FR-005, FR-016
- Principle: P001, P009, P006
- Rule: RULE-006, RULE-005

### RESP-006 — State Management
Runtime chịu trách nhiệm quản lý state trong Execution; mọi thay đổi phát Event.
- Yêu cầu: FR-006
- Principle: P001, P005, P009
- Rule: RULE-005

### RESP-007 — Event Emission
Runtime chịu trách nhiệm phát Event cho mọi state change.
- Yêu cầu: FR-007
- Principle: P005, P014
- Rule: RULE-007

### RESP-008 — Artifact Production
Runtime chịu trách nhiệm thu thập và công bố Artifact (kết quả Execution).
- Yêu cầu: FR-008, FR-020
- Principle: P010, P005
- Rule: RULE-009

### RESP-009 — Metrics Collection
Runtime chịu trách nhiệm thu thập Metrics cho observability.
- Yêu cầu: FR-009
- Principle: P014
- Rule: RULE-014

### RESP-010 — Simulation Support
Runtime chịu trách nhiệm chạy Simulation trước khi Execute.
- Yêu cầu: FR-010
- Principle: P013
- Rule: RULE-004

### RESP-011 — Replay Support
Runtime chịu trách nhiệm Replay Execution từ Event log.
- Yêu cầu: FR-011
- Principle: P005, P013
- Rule: RULE-013

### RESP-012 — Execution Control
Runtime chịu trách nhiệm hủy an toàn, timeout, retry theo policy.
- Yêu cầu: FR-012, FR-017, FR-018
- Principle: P015
- Rule: RULE-012

### RESP-013 — Lifecycle Management
Runtime chịu trách nhiệm quản lý vòng đời Execution (created→running→terminal).
- Yêu cầu: FR-015
- Principle: P001, P005
- Rule: RULE-004

### RESP-014 — Governance Enforcement
Runtime chịu trách nhiệm enforce approval gate và tuân thủ Constitution.
- Yêu cầu: FR-019
- Principle: P016, P020
- Rule: RULE-004, RULE-015

## Nguồn trách nhiệm

| Responsibility | Nhóm FR |
|----------------|---------|
| RESP-001..003 | Core Initiation (FR-001,002,003,013,014,015) |
| RESP-004,010,011,012,013 | Execution (FR-004,010,011,012,015,017,018) |
| RESP-005,006 | State (FR-005,006,016) |
| RESP-007 | Events (FR-007) |
| RESP-008 | Data (FR-008,020) |
| RESP-009 | Observability (FR-009) |
| RESP-014 | Governance (FR-019) |

## Tham chiếu

- `responsibilities.yaml` — nguồn dữ liệu chuẩn (14 responsibilities).
- `responsibility-traceability.yaml` — RESP → FR → P → RULE → SPEC → TEST → DOCTOR.
- `requirements.yaml` — nguồn FR (S002).
- Constitution: `docs/specs/SPEC-000/`
