---
name: aios-sdk
description: >
  AIOS SDK v13.0 — lớp chính thức để lập trình trên AIOS. Agent SDK, Plugin SDK, Workflow SDK...
  Core không bị truy cập trực tiếp; mọi công cụ dùng chung API ổn định.
agent: general
---

# AIOS SDK v13.0

## 1. Vai trò

Lớp chính thức lập trình trên AIOS — Plugin/CLI/Dashboard/IDE Extension dùng chung API.

```text
AIOS SDK
├── Agent SDK
├── Plugin SDK
├── Workflow SDK
├── Context SDK
├── Artifact SDK
├── Event SDK
├── Registry SDK
├── Doctor SDK
├── Simulation SDK
├── Evolution SDK
└── Dashboard SDK
```

## 2. Lợi ích

- **Core không bị truy cập trực tiếp**.
- Plugin/CLI/Dashboard/IDE dùng **chung API ổn định**.
- Thay đổi implementation bên trong **không làm hỏng** plugin/integration.

## 3. Kiến trúc

```text
Plugin · CLI · Dashboard · IDE Extension · Third-party
        │
        ▼
     AIOS SDK
        │
   ┌─────┼─────┐
   │     │     │
Agent  Plugin Workflow ... Dashboard
   │     │     │
   └─────┼─────┘
        │
   Framework Core
```

## 4. Component SDKs

| SDK | Mô tả |
|-----|-------|
| `agent-sdk` | tạo/chạy agent, get agent metadata |
| `plugin-sdk` | plugin lifecycle, exports, permission |
| `workflow-sdk` | chạy/pause/resume workflow |
| `context-sdk` | resolve context, get profile |
| `artifact-sdk` | artifact CRUD + version + lineage |
| `event-sdk` | publish/subscribe, lineage, replay |
| `registry-sdk` | capability/agent/skill/command lookup |
| `doctor-sdk` | run scan, get health |
| `simulation-sdk` | run simulation |
| `evolution-sdk` | proposals, apply |
| `dashboard-sdk` | snapshot read, control |

## 5. Stability & Versioning

- API stability: experimental → stable → frozen.
- SDK version = framework version (semver).
- Backward compatible contract.

## 6. Security

- Permission model (kế thừa plugins/permissions.md).
- Audit log mọi SDK access.
- Key required cho control SDK.

## 7. File hệ thống

| File | Vai trò |
|------|---------|
| `aios-sdk.schema.yaml` | SDK schema |
| `README.md` | Tổng quan |
| `architecture.md` | Kiến trúc SDK |
| `agent-sdk.md` ... `dashboard-sdk.md` | 11 SDK components |
| `security.md` | Permission + audit |
| `versioning.md` | Version policy |
| `tests.md` | SDK tests |