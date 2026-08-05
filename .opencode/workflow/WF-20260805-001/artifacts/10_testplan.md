---
name: workflow-phase-testplan
description: Lap ke hoach test — landing page link + AIHub publish + khong pha JapaneseLearner
agent: test-planner
---

# Phase 10 — Test Plan (WF-20260805-001)

## Test types

| Type | Scope | Co chay? |
|------|-------|----------|
| Build (compile) | AIHub + JapaneseLearner | YES |
| Publish structure | AIHub wwwroot co _framework, index.html | YES |
| Landing page link | index.html co 2 href dung path | YES |
| Base href rewrite | sed pattern khop `<base href="/" />` | YES (manual verify) |
| Unit tests | JapaneseLearner.Tests (khong bi anh huong — chi sua CI/html) | NO — khong lien quan |

## Test cases

| ID | Test case | Expected | Type |
|----|-----------|----------|------|
| TC-001 | `dotnet build AIHub/AIHub.csproj` | Build PASS | Build |
| TC-002 | `dotnet publish AIHub -c Release` | Publish PASS, co wwwroot | Publish |
| TC-003 | Landing page co 2 `<a class="card">` | 2 href: `/AIAgent/JapaneseLearner/`, `/AIAgent/AIHub/` | Static |
| TC-004 | deploy.yml co `dotnet publish AIHub` | Step "Publish AIHub" ton tai | Static |
| TC-005 | deploy.yml co `mkdir -p deploy/AIHub` | Co copy AIHub vao deploy | Static |
| TC-006 | deploy.yml co sed base href AIHub | `deploy/AIHub/index.html` -> `/AIAgent/AIHub/` | Static |
| TC-007 | deploy.yml co hashed js copy AIHub | Loop `deploy/AIHub/_framework/blazor.webassembly.*.js` | Static |
| TC-008 | JapaneseLearner build van PASS | Khong pha luong deploy JL | Build |
| TC-009 | deploy.yml YAML valid (no tab, indent dung) | Parse OK | Static |

## Coverage target

- Build: 2/2 project
- Static checks: TC-003..007, TC-009 (7 cases)
- Khong chay unit tests (khong lien quan source code)

```yaml
status: "PASS"
test_types:
  - "build"
  - "publish_structure"
  - "static_verification"
test_cases:
  - "TC-001..TC-009"
coverage_target: "Build 2 project + 7 static checks"
```

## Checklist

- [x] Ke hoach test co build + static verification
- [x] TC-001..TC-009 day du
- [x] Khong chay unit test khong lien quan (tiet kiem)
- [x] Coverage target ro rang
