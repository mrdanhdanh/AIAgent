---
name: sprint2-capability-registry
description: >
  Sprint 2 — Capability Registry. Biến agent thành tập capability (thay vì tên).
  Xây registry/ (capabilities, agent/skill/command metadata), resolver, scorer, matcher,
  validator, /team-capabilities, capability-validator.ps1, CAPABILITY_COVERAGE.md.
agent: general
---

# 01 — Analysis · WF-20260802-004

## 1. Mục tiêu

Sự phát triển lớn nhất của v4: tách "Agent là ai" → "Agent làm được gì (Capability)".
Workflow Engine (Sprint 1) hiện dispatch theo `agent:`/`command:` cố định trong definition.
Sprint 2 thêm layer registry: user request → intent → capability → registry → candidate agents → score → execute.
Workflow Engine không còn hardcode `planner/builder/tester` nữa.

## 2. Hiện trạng (baseline, git clean)

| Loại | Số lượng | Vị trí |
|------|---------|--------|
| Agents | 18 | `.opencode/agents/*.md` (subagent, model pro/flash tiered) |
| Commands | 53 | `.opencode/commands/*.md` |
| Skills | 29 | `.opencode/skills/*/SKILL.md` |
| Scripts | 11 | `.opencode/scripts/*.ps1` |
| Workflow definitions | 5 | `.opencode/workflow/definitions/*.workflow.yaml` |
| Workflow Engine modules | 8 | `.opencode/workflow-engine/*.md` |

Registry hiện chưa tồn tại (`.opencode/registry/`, `.opencode/reports/` = False).

## 3. Map Agent → Capability (từ description thực tế)

| Agent | Capability chính (đề xuất) |
|-------|---------------------------|
| planner | architecture.design, planning.task, planning.test |
| builder | implementation.code, implementation.refactor, implementation.fix |
| reviewer | review.code, review.architecture, review.plan |
| tester | testing.unit, testing.e2e, testing.ui |
| analyst | analysis.requirement, analysis.codebase |
| codebase-explorer | analysis.codebase, architecture.discovery |
| test-planner | planning.test, testing.strategy |
| guardian | review.security |
| pusher | deployment.git |
| backup-agent | deployment.backup, workspace.rollback |
| cleaner | workspace.cleanup |
| ui-beautifier | ui.design, ui.audit, implementation.ui |
| knowledge-agent | knowledge.learn, knowledge.retrieve |
| learning-agent | memory.record, knowledge.learn |
| self-improver | knowledge.learn, analysis.bottleneck |
| failure-agent | analysis.error, memory.record |
| root-cause-agent | analysis.root-cause |
| general | orchestration, general.fallback |

## 4. Capability categories (đề xuất dựa trên spec user + hiện trạng)

analysis, architecture, planning, implementation, review, testing, knowledge, memory,
deployment, workspace, ui, security, documentation, orchestration, release.

## 5. Rủi ro / đánh giá

- **Phân tích mới**: registry.yaml là nguồn chân lý mới; nếu sai => routing sai. Cần validator bắt trùng ID, ref không tồn tại, orphan capability (không agent xử lý), vòng phụ thuộc.
- **Non-invasive (không vỡ)**: Sprint 2 chỉ thêm registry + docs + command mới + validator, KHÔNG thay đổi engine hiện có hay definitions — cách ly rủi ro. Engine v4 vẫn chạy như cũ; registry là layer phía trên tùy chọn.
- **Phạm vi**: Sinh 10 registry files + 1 command + 1 validator + 1 report. Không đụng C#. Không đổi workflow definitions.
- **Backward compatible**: agent-registry bổ sung metadata song song; không sửa agent md.

## 6. Files thay đổi (dự kiến)
- CREATE: `.opencode/registry/` (README, registry.schema.yaml, capabilities.yaml, agent-registry.yaml, skill-registry.yaml, command-registry.yaml, resolver.md, matcher.md, scorer.md, validator.md)
- CREATE: `.opencode/commands/team-capabilities.md`
- CREATE: `.opencode/scripts/capability-validator.ps1`
- CREATE: `.opencode/reports/CAPABILITY_COVERAGE.md`
- MODIFY (nil): không sửa file cũ.

## 7. Rủi ro không xác định cần hỏi user
- Có thay đổi workflow definitions để dùng registry routing luôn trong sprint này không, hay chỉ xây registry + validator (non-invasive)?
- Phạm vị skill-registry: mapping thủ công 29 skills hay scan tự động?