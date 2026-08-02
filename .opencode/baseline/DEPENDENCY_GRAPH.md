---
name: dependency-graph
description: DEPENDENCY_GRAPH — graph thành phần và dependency của Agent Framework v3.
agent: general
---

# DEPENDENCY_GRAPH.md — Agent Framework v3

> Biểu đồ dependency giữa các thành phần. Graph cấp thành phần (component-level).

## 1. Component Dependency Graph

```
Command (54)
   ├── Workflow Engine (8 module) ──→ Definitions YAML (5)
   │        └── State Machine / Recovery / Phase Runner
   ├── Agent (18)
   │        └── Skill (29 registry / 38 SKILL.md)
   │             └── Knowledge (lessons, patterns)
   │                  └── Memory (BUG-, LSN-, PAT-)
   └── Capability Registry (Sprint 2)
            ├── capabilities.yaml
            ├── agent-registry.yaml
            ├── skill-registry.yaml
            └── command-registry.yaml
```

## 2. Dependency theo chiều

| Thành phần | Phụ thuộc vào |
|-----------|----------------|
| Command | Agent / Workflow / Skill |
| Workflow Engine | definitions YAML, state.json, phase-runner |
| Agent | Skill, Knowledge, Model (deepseek-v4-flash-free) |
| Skill | Knowledge base, Scripts, Registry |
| Scripts | (framework) can thiệp file |
| Registry | capabilities.yaml (nguồn chân lý) |

## 3. Tech Stack Dependency (project Japanese Learner)

```
Blazor WebAssembly (.NET 10)
  ├── FluentUI 4.14.3
  ├── Blazored.LocalStorage
  ├── xUnit + bUnit + Moq (tests)
  └── Playwright (E2E)
```

## 4. Circular Dependencies (known)

- Không có cycle ryo rõ giữa các component ở mức file.
- Agent md tham chiếu skill mà skill đó lại dùng trong nhiều agent → giàu dạng many-to-many, không cycle.
- Registry mapping thủ công — capability id phải tồn tại trong capabilities.yaml (validator CR-002 bảo đảm, PASS).

## 5. Notes / Caveats

- `.opencode/skills/knowledge/` chứa skill lồng (29 registry vs 38 SKILL.md) — 9 skill phụ thuộc trong knowledge/ cũng nằm ở top-level.
- `baseline.json` là nguồn so sánh máy; `*Dependency*` yêu cầu thủ công lướt lại khi có Skill/Agent mới.