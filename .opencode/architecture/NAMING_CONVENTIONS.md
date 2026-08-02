---
name: architecture-naming-conventions
description: NAMING_CONVENTIONS — quy ước tên ID, file, workflow, capability, event, artifact, command, agent và mã lỗi.
agent: general
---

# NAMING_CONVENTIONS.md — Quy ước Tên

> Thống nhất tên trên toàn framework. Mỗi phase không tự đặt quy ước riêng.

## 1. Tổng quan pattern

| Loại | Pattern | Ví dụ |
|------|---------|-------|
| Capability | `<domain>.<action>` | `implementation.code` |
| Event | `UPPER_SNAKE_CASE` | `BUILD_FINISHED` |
| Artifact | `<name>.v<N>.<ext>` | `plan.v1.md` |
| Workflow file | `<type>.workflow.yaml` | `feature.workflow.yaml` |
| Workflow run | `WF-YYYYMMDD-XXX` | `WF-20260802-004` |
| Command | `team-<verb>` | `team-analyze` |
| Agent | `kebab-case` | `planner`, `root-cause-agent` |
| Skill | `kebab-case` | `playwright-e2e` |
| Mã lỗi | `<PREFIX>-NNN` | `CAP-001` |
| Contract | `contract-<object>-<name>` | `contract-agent-plan` |
| Context | `ctx-<scope>-<id>` | `ctx-task-001` |
| Phase | `P<NN>` | `P01` |
| Registry file | `<type>-registry.yaml` | `capability-registry.yaml` |

## 2. Capability

- `<domain>.<action>` với domain thuộc danh sách: `analysis`, `implementation`, `review`, `test`, `ui`, `security`, `knowledge`, `ops`, `architecture`.
- Ví dụ: `analysis.requirement`, `implementation.code`, `review.architecture`, `test.e2e`.

## 3. Event

- `UPPER_SNAKE_CASE`, prefix nhóm đối tượng.
- Workflow: `WORKFLOW_STARTED`, `WORKFLOW_FINISHED`, `WORKFLOW_FAILED`, `WORKFLOW_RETRY`, `WORKFLOW_ROLLBACK`, `WORKFLOW_ARCHIVED`.
- Phase: `PHASE_STARTED`, `PHASE_FINISHED`, `PHASE_FAILED`, `PHASE_SKIPPED`, `PHASE_RETRY`, `PHASE_ABORTED`.
- Agent: `AGENT_READY`, `AGENT_STARTED`, `AGENT_WAITING`, `AGENT_FINISHED`, `AGENT_FAILED`.
- Build: `BUILD_FINISHED`, `BUILD_FAILED`.

## 4. Artifact

- `<name>.<type>.v<N>.<ext>` — ví dụ `plan.design.v1.md`, `report.test.v2.html`.
- Hoặc `<name>.v<N>.<ext>` — `plan.v1.md`.
- Version tăng theo mỗi lần thay đổi nội dung.

## 5. Workflow

- File definition: `<type>.workflow.yaml` (`feature.workflow.yaml`, `bugfix.workflow.yaml`, `ui.workflow.yaml`).
- Workflow run: `WF-YYYYMMDD-XXX` (XXX tăng dần theo ngày).
- Phase: `P01`...`P99`.

## 6. Command / Agent / Skill

- Command: `team-<verb>` hoặc nhóm chức năng `<verb>` (`test-e2e`, `ask`, `doctor`).
- Agent: `kebab-case`, mô tả vai trò (`planner`, `root-cause-agent`).
- Skill: `kebab-case` (`playwright-e2e`, `flaky-test-detector`).

## 7. Mã lỗi

- `<PREFIX>-<NNN>`, PREFIX 3 chữ cái (WF/AG/CAP/CTX/ART/EVT/CFG/SEC/INF).
- Danh sách đầy đủ ở ERROR_HANDLING.md.

## 8. Quy tắc chung

- Không dấu, không khoảng trắng trong ID (dùng `-` hoặc `.`).
- File `.md` frontmatter name: `kebab-case`.
- Registry id: khớp chính xác với file reference.
- Không tạo quy ước mới ngoài bảng trên khi chưa có ADR.