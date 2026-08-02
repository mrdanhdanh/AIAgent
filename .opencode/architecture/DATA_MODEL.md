---
name: architecture-data-model
description: DATA_MODEL — định nghĩa mọi object của Agent Framework v4: Workflow, Phase, Capability, Agent, Skill, Context, Artifact, Event.
agent: general
---

# DATA_MODEL.md — Data Model chuẩn

> Quan trọng nhất của ASP v4. Định nghĩa mọi object với Fields/Required/Optional/Relations.

## 0. Hệ thống object

```
Workflow
   ↓ 1..N
Phase
   ↓ yêu cầu 1..N
Capability
   ↓ resolve 1..N
Agent
   ↓ sở hữu 1..N
Skill
   ↓
Context (đi kèm mọi thứ)
Artifact (sản phẩm mỗi phase)
Event (phản ứng xuyên suốt)
```

## 1. Workflow

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `WF-YYYYMMDD-XXX` |
| name | string | ✅ | tên mô tả |
| description | string | ❌ | mô tả ngắn |
| version | string | ✅ | theo VERSIONING |
| phases | Phase[] | ✅ | tối thiểu 1 phase |
| status | enum | ✅ | Pending/Running/Retry/Failed/Rollback/Completed |
| created_at | datetime | ✅ | |
| updated_at | datetime | ✅ | |
| metadata | map | ❌ | key-value mở rộng |
| artifacts | Artifact[] | ❌ | artifact sinh ra |

**Relations**: 1..N Phase; 0..N Artifact; 1 Context scope project.

## 2. Phase

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `P01`, `P02`... |
| name | string | ✅ | mô tả phase |
| capability | string | ✅ | capability cần (`analysis.requirement`) |
| depends_on | string[] | ❌ | phase id phụ thuộc |
| retry | int | ❌ | số lần retry mặc định 1 |
| state | enum | ✅ | Ready/Running/Skipped/Done/Failed |
| status | enum | ✅ | tiến độ chi tiết |
| context | Context | ❌ | context riêng phase |
| artifacts | Artifact[] | ❌ | artifact sinh ra |

**Relations**: thuộc 1 Workflow; 0..N Artifact; 0..1 Context.

## 3. Capability

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `analysis.requirement` |
| name | string | ✅ | tên hiển thị |
| description | string | ❌ | mô tả năng lực |
| category | enum | ✅ | analysis/implementation/review/test/ui/security/knowledge/ops |
| version | string | ✅ | 1.0 |
| input_contract | Contract | ❌ | định nghĩa đầu vào |
| output_contract | Contract | ❌ | định nghĩa đầu ra |
| providers | Agent[] | ❌ | agent có thể đảm nhận |
| priority | int | ✅ | thứ tự ưu tiên resolve |
| status | enum | ✅ | Active/Partial/Deprecated |
| metadata | map | ❌ | |

**Relations**: 1..N provider Agent; validate bởi registry (CR-001..009).

## 4. Agent

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `planner`, `builder`... |
| name | string | ✅ | tên hiển thị |
| version | string | ✅ | 1.0.0 |
| description | string | ❌ | mô tả role |
| capabilities | string[] | ✅ | danh sách capability id |
| contracts | Contract[] | ❌ | input/output contract |
| priority | int | ✅ | độ ưu tiên khi nhiều agent cùng capability |
| status | enum | ✅ | Loaded/Ready/Running/Waiting/Completed/Failed |
| metadata | map | ❌ | model, access... |
| skills | string[] | ❌ | skill id sở hữu |

**Relations**: sở hữu 1..N Skill; khai báo 1..N Capability; 0..N Contract.

## 5. Skill

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `playwright-e2e` |
| name | string | ✅ | |
| description | string | ✅ | dùng để router chọn |
| capabilities | string[] | ✅ | capability cung cấp |
| source | string | ❌ | SKILL.md location |
| version | string | ✅ | |
| dependencies | string[] | ❌ | skill phụ thuộc |
| status | enum | ❌ | Active/Orphan |

**Relations**: thuộc 1 Agent; cung cấp 1..N Capability; 0..N dependency.

## 6. Context

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `ctx-project-...` |
| scope | enum | ✅ | Project/Workflow/Task/Artifact/Knowledge/Memory/Runtime |
| data | map | ✅ | nội dung context |
| parent_id | string | ❌ | context cha (workflow→project) |
| version | string | ❌ | token compression version |
| token_count | int | ❌ | đo được |
| created_at | datetime | ✅ | |
| updated_at | datetime | ✅ | |

**Relations**: Context Isolation — mỗi scope tách biệt; child kế thừa parent.

## 7. Artifact

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `plan.v1.md` |
| type | enum | ✅ | plan/design/report/test/result/log |
| version | string | ✅ | v1, v2... |
| checksum | string | ✅ | SHA-256 nội dung |
| path | string | ✅ | vị trí lưu |
| dependencies | string[] | ❌ | artifact phụ thuộc |
| status | enum | ✅ | Created/Validated/Versioned/Archived |
| created_at | datetime | ✅ | |
| metadata | map | ❌ | |

**Relations**: sinh bởi 1 Phase; 0..N dependency đến artifact khác.

## 8. Event

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `evt-<uuid>` |
| name | string | ✅ | `BUILD_FINISHED` |
| source | string | ✅ | component sinh (runtime, agent) |
| payload | map | ❌ | dữ liệu kèm |
| workflow_id | string | ❌ | workflow liên quan |
| timestamp | datetime | ✅ | |
| status | enum | ❌ | Emitted/Handled/Dropped |

**Relations**: 0..1 Workflow; 0..N handler.

## 9. Contract (tham chiếu CONTRACTS.md)

| Field | Type | Required |
|-------|------|----------|
| id | string | ✅ |
| version | string | ✅ |
| input | Schema | ✅ |
| output | Schema | ✅ |
| validation | enum | ✅ strict/lenient |

## 10. Quy tắc quan hệ

- Workflow → Phase: bắt buộc, thứ tự do `depends_on`.
- Capability → Agent: nhiều-nhiều, chọn theo `priority`.
- Agent → Skill: 1-nhiều.
- Phase → Artifact: 0-nhiều, artifact là cầu nối giữa phase.
- Context: mọi thứ đều có context, isolation theo scope.
- Event: được emit ở mọi chuyển pha.