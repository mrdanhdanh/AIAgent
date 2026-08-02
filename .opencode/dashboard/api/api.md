---
name: dashboard-api
description: Dashboard API — read (snapshot) + control (command). Dashboard không đọc Core trực tiếp.
agent: general
---

# Dashboard API

## 1. Vai trò

Giao diện cho Dashboard UI — read từ snapshot, control qua command.

## 2. Read API (từ Snapshot)

| API | Mô tả |
|-----|-------|
| `GetHealth()` | health scores |
| `GetOverview()` | framework version, counts |
| `GetWorkflows()` | workflow states |
| `GetAgents()` | agent status |
| `GetCapabilities()` | capability stats |
| `GetArtifacts()` | artifact stats |
| `GetEvents()` | event log |
| `GetContext()` | context metrics |
| `GetEvolution()` | proposals |
| `GetPlugins()` | plugin status |
| `GetMetrics()` | dashboard metrics |
| `Search(query)` | search snapshot |

## 3. Control API (Command)

| API | Mô tả |
|-----|-------|
| `RetryWorkflow(id)` | retry workflow |
| `PauseWorkflow(id)` | tạm dừng |
| `ResumeWorkflow(id)` | tiếp tục |
| `StopWorkflow(id)` | dừng |
| `ReplayWorkflow(id)` | replay |
| `SimulateWorkflow(id)` | simulate |
| `InstallPlugin(pkg)` | cài plugin |
| `ApplyEvolution(proposalId)` | apply proposal |

## 4. Permission

- Read API: viewer+.
- Control API: operator+.
- Install/Evolution apply: administrator.

## 5. Không đọc Core

API đọc từ **Snapshot** (Read Model) — không gọi Runtime trực tiếp cho read.
Control gửi **command** → Runtime thực thi → event → projection cập nhật.

## 6. Tương tác

- `projection/` — snapshot nguồn.
- `control/` — command handlers.
- `security` — roles.