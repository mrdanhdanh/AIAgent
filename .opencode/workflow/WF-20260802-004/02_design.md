---
name: sprint2-capability-registry
description: >
  Sprint 2 — Capability Registry. Biến agent thành tập capability. Non-invasive: chỉ xây
  registry layer (registry/, validator, /team-capabilities, CAPABILITY_COVERAGE), không đổi engine.
  Skill-registry mapping thủ công.
agent: general
---

# 02 — Design · WF-20260802-004

## 1. Quyết định thiết kế (đã chốt với user)

| Quyết định | Lựa chọn | Hệ quả |
|-----------|---------|--------|
| Phạm vi | **Chỉ xây registry layer** (non-invasive) | Không sửa engine.md/definitions/phase-runner. Engine v4 giữ nguyên. Registry là layer phía trên, đọc bởi `/team-capabilities`, `capability-validator.ps1`, doctor. |
| Skill mapping | **Thủ công explicit** | skill-registry.yaml ghi rõ `supports:` capability cho từng skill. |

## 2. Kiến trúc tổng thể

```
.opencode/registry/
├── README.md              (tổng quan, cách dùng, graph)
├── registry.schema.yaml   (contract v1.0 cho 4 registry + capability)
├── capabilities.yaml      (danh sách + profile capability)
├── agent-registry.yaml    (metadata 18 agents)
├── skill-registry.yaml    (metadata 29 skills)
├── command-registry.yaml  (metadata commands trọng yếu)
├── resolver.md            (user request -> capability)
├── matcher.md             (capability -> candidate agents/skills/commands)
├── scorer.md              (ranking agent theo score)
└── validator.md           (checklist + rules capability-validator.ps1)
```

## 3. Capability Schema (biên soạn theo spec user)

```yaml
id: implementation.code          # category.specific
name: Code Generation
description: Generate production-ready code
category: implementation
complexity: medium               # (nâng cấp đề xuất)
required_context: [task, project]
optional_context: [knowledge, history]
required_artifacts: [plan.md]
produces_artifacts: [source-code]
success_metrics: [build_success, test_pass_rate]
tags: [code, csharp, blazor]
```

## 4. Agent Registry Schema

```yaml
id: builder
version: "2.0"
priority: 80
enabled: true
capabilities: [implementation.code, implementation.refactor, implementation.fix]
languages: [csharp, python, javascript]
frameworks: [blazor, aspnet]
estimated_tokens: 8000
estimated_time: medium
```

## 5. Skill / Command Registry Schema

```yaml
# skill-registry.yaml
id: impeccable
supports: [implementation.code, implementation.fix, review.code]
priority: 95

# command-registry.yaml
id: team-build
supports: [implementation.code]
```

## 6. Capability Graph & Coverage

Registry sinh:
```
implementation.code
├── builder            (agent)
├── impeccable         (skill)
├── team-build         (command)
```
Coverage report: Capability → có Agent? Skill? Command? → Status (OK / Partial / Missing).

## 7. Nâng cấp: Capability Profile (cầu nối Sprint 3)

Mỗi capability kèm `required_context`, `required_artifacts`, `produces_artifacts`, `success_metrics`
(có trong spec + profile). Giúp Sprint 3 (Context Engine) tự biết cấp context nào — giảm lặp config.
Không bắt buộc mọi capability đều đủ cỗ; nếu thiếu để null/[].

## 8. Non-invasive proof

- Documents mới nằm gọn trong `.opencode/registry/`, `.opencode/reports/`, 1 command `team-capabilities.md`, 1 script `capability-validator.ps1`.
- KHÔNG sửa: engine docs, definitions, agents md, skills md, commands md cũ, doctor.ps1 (trong sprint này).
- Workflow Engine v4 tiếp tục dùng `agent:`/`command:` fixed trong definitions như hiện tại.

## 9. Phạm vi capability list (đề xuất đầy đủ)

analysis: requirement, codebase, error, root-cause, bottleneck
architecture: design, discovery
planning: task, test
implementation: code, refactor, fix, ui
review: code, plan, architecture, security
testing: unit, e2e, ui, strategy
knowledge: learn, retrieve
memory: record, store
deployment: git, backup, rollback
workspace: cleanup
ui: design, audit
security: review, audit
documentation: write, review
orchestration: orchestrate, fallback
release: manage

## 10. Đánh giá rủi ro còn lại

- Registry phải sync với hiện trạng agents/skills/commands. Rủi ro lệch → validator + doctor bắt.
- non-invasive nên rủi ro thấp; attack surface là chất lượng dữ liệu registry, không phải runtime.