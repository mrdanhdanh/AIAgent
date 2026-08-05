---
name: architecture-components
description: COMPONENTS — định nghĩa từng component của Agent Framework v4: Purpose, Responsibilities, Inputs, Outputs, Dependencies.
agent: general
---

# COMPONENTS.md — Component Definitions

> Định nghĩa từng component: Purpose, Responsibilities, Inputs, Outputs, Dependencies.

## 1. Workflow Runtime

| Field | Mô tả |
|-------|-------|
| **Purpose** | Điều phối workflow theo definition, không hardcode |
| **Responsibilities** | load definition → validate → chạy phase → quản lý state/retry/rollback → sinh artifact |
| **Inputs** | Workflow definition (yaml/json), Context, sự kiện |
| **Outputs** | Phase results, Artifact, workflow status |
| **Dependencies** | Workflow loader, state-machine, artifact store |
| **File ref** | `.opencode/workflow-engine/` (8 modules) |

## 2. Capability Registry

| Field | Mô tả |
|-------|-------|
| **Purpose** | Đăng ký và resolve capability → agent/skill |
| **Responsibilities** | CRUD capability, map agent/skill, validate (CR-001..009), coverage |
| **Inputs** | registry yaml (capabilities, agents, skills, commands, contracts) |
| **Outputs** | capability lookup, coverage report |
| **Dependencies** | validator, nơi các phase khác hỏi |
| **File ref** | `.opencode/registry/` |

## 3. Context Engine

| Field | Mô tả |
|-------|-------|
| **Purpose** | Quản lý context theo scope, isolation, compression |
| **Responsibilities** | tạo/lưu/đọc context, tính token, compress, xóa theo scope |
| **Inputs** | context request, scope, data |
| **Outputs** | context versioned, token count |
| **Dependencies** | DATA_MODEL Context, storage |
| **File ref** | (Phase 4 — chưa có) |

## 4. Artifact Store

| Field | Mô tả |
|-------|-------|
| **Purpose** | Quản lý artifact có checksum/version/dependency |
| **Responsibilities** | lưu artifact, tính checksum, version, dependency graph, archive |
| **Inputs** | nội dung artifact, phase sinh |
| **Outputs** | artifact record, checksum, version |
| **Dependencies** | DATA_MODEL Artifact |
| **File ref** | (Phase 5 — chưa có) |

## 5. Event System

| Field | Mô tả |
|-------|-------|
| **Purpose** | Phản ứng sự kiện xuyên suốt |
| **Responsibilities** | emit event, đăng ký handler, route sự kiện → handler |
| **Inputs** | event (name, source, payload) |
| **Outputs** | sự kiện được xử lý, trigger phase |
| **Dependencies** | DATA_MODEL Event |
| **File ref** | (Phase 6 — chưa có) |

## 6. Simulation

| Field | Mô tả |
|-------|-------|
| **Purpose** | Chạy thử workflow/agent không đụng file thật |
| **Responsibilities** | dry-run workflow, benchmark agent, verify capability match |
| **Inputs** | workflow/agent test-set |
| **Outputs** | simulation report |
| **Dependencies** | registry, context, artifact |
| **File ref** | (Phase 7 — chưa có) |

## 7. Diagnostics / Doctor

| Field | Mô tả |
|-------|-------|
| **Purpose** | Kiểm tra sức khỏe hệ thống |
| **Responsibilities** | health check environment/agents/commands/skills/knowledge/workflow/contracts/runtime, health score, self-repair |
| **Inputs** | baseline.json, registry, runtime trạng thái |
| **Outputs** | health report, score |
| **Dependencies** | baseline, registry, validator |
| **File ref** | `.opencode/commands/doctor.md` |

## 8. Knowledge Index

| Field | Mô tả |
|-------|-------|
| **Purpose** | Đánh chỉ mục knowledge/memory |
| **Responsibilities** | build 7 loại index, update, query |
| **Inputs** | knowledge/, memory/, registry |
| **Outputs** | `.opencode/knowledge-index/` |
| **Dependencies** | search-engine skill |
| **File ref** | (Phase 9 — một phần có sẵn) |

## 9. Capability Resolver (trung gian)

| Field | Mô tả |
|-------|-------|
| **Purpose** | Map intent/context → capability → agent tốt nhất |
| **Responsibilities** | match capability theo priority, fallback |
| **Inputs** | yêu cầu, context |
| **Outputs** | agent/skill được chọn |
| **Dependencies** | registry |

## 10. Ma trận phụ thuộc

| Component | Cần component nào |
|-----------|-------------------|
| Workflow Runtime | Resolver, Artifact Store, State Machine |
| Capability Registry | Validator |
| Context Engine | Storage |
| Artifact Store | Storage |
| Event System | Resolver |
| Simulation | Registry, Context |
| Doctor | Baseline, Registry, Validator |
| Knowledge Index | Knowledge Layer |