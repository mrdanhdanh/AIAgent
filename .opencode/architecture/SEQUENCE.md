---
name: architecture-sequence
description: SEQUENCE — sequence flow của Agent Framework v4: User → Command → Runtime → Resolver → Agent → Artifact → Context → Next Phase.
agent: general
---

# SEQUENCE.md — Sequence Flow

> Mô tả thứ tự tương tác. Không phải code.

## 1. Luồng tổng quát

```
User → Command → Workflow Runtime → Capability Resolver → Agent → Skill → Artifact → Context → Next Phase
```

## 2. Sequence: chạy một workflow

```text
User
  │ /team <yêu cầu>
  ▼
Command Layer
  │ chọn workflow definition
  ▼
Workflow Runtime
  │ validate definition (schema)
  │ state Pending → Running
  ▼
Workflow Runtime ── emit WORKFLOW_STARTED ──▶ Event System
  │
  ├─▶ Phase P01 Ready
  │      │ load context (project)
  │      ▼
  │    Capability Resolver
  │      │ match capability → agent (priority)
  │      ▼
  │    Agent (Running)
  │      │ load skill
  │      ▼
  │    Skill Layer
  │      │ thực thi → output
  │      ▼
  │    Artifact Store
  │      │ sinh artifact (checksum, version)
  │      ▼
  │    Context Engine
  │      │ cập nhật context, tính token
  │      ▼
  │    Phase Done ── emit PHASE_FINISHED ──▶ Event System
  │
  ├─▶ Phase P02 Ready (depends_on P01)
  │      ... lặp lại
  │
  ▼
Workflow Runtime
  │ mọi phase Done
  ▼
Completed ── emit WORKFLOW_FINISHED ──▶ Event System
  │
  ▼
Artifact Store (archive) → User nhận báo cáo
```

## 3. Sequence: retry

```text
Phase Running → Fail
  ▼
Workflow Runtime (đếm retry)
  ├─ retry còn → Phase Failed → Ready
  │     emit PHASE_RETRY → chạy lại
  └─ hết retry → Workflow Failed → Rollback
        emit WORKFLOW_FAILED
```

## 4. Sequence: capability resolution chi tiết

```text
Yêu cầu (intent)
  ▼
Capability Resolver
  │ 1. chuẩn hóa intent → capability id (vd analysis.requirement)
  │ 2. registry lookup
  │ 3. lọc theo status = Active
  │ 4. sort theo priority
  │ 5. fallback nếu không match (error CAP-001)
  ▼
Agent được chọn
```

## 5. Sequence: context isolation

```text
Project context (scope=Project)          ← chia sẻ toàn workflow
  └─ Workflow context (scope=Workflow)   ← per workflow
        └─ Task context (scope=Task)     ← per phase
              └─ Artifact context        ← per artifact
```

Không trộn dữ liệu giữa các scope; child chỉ đọc từ parent.