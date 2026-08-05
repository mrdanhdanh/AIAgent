---
name: workflow-phase-test
description: Chay kiem thu — build + static verification cho landing page + AIHub publish
agent: tester
---

# Phase 11 — Test (WF-20260805-001)

## Ket qua test

| ID | Test case | Ket qua | Evidence |
|----|-----------|---------|----------|
| TC-001 | AIHub build | **PASS** | 0 Warning(s), 0 Error(s), 6.07s |
| TC-002 | AIHub publish Release | **PASS** | Publish thanh cong (da verify o build phase) |
| TC-003 | Landing page 2 cards | **PASS** | Card count: 2 (`/AIAgent/JapaneseLearner/`, `/AIAgent/AIHub/`) |
| TC-004 | deploy.yml co "Publish AIHub" step | **PASS** | `run: dotnet publish AIHub/AIHub.csproj -c Release -o release-aihub --nologo` |
| TC-005 | mkdir -p deploy/AIHub | **PASS** | Co trong Prepare deploy structure |
| TC-006 | sed base href AIHub | **PASS** | `sed -i 's|<base href="/" />|<base href="/AIAgent/AIHub/" />|' deploy/AIHub/index.html` |
| TC-007 | hashed js copy AIHub | **PASS** | Loop `deploy/AIHub/_framework/blazor.webassembly.*.js` |
| TC-008 | JapaneseLearner build van PASS | **PASS** | 0 Warning(s), 0 Error(s), 9.60s |
| TC-009 | YAML no tabs, indent dung | **PASS** | 0 tabs, indentation nhat quan |

## Coverage

- Build: 2/2 project PASS (AIHub + JapaneseLearner)
- Static checks: 7/7 PASS (TC-003..TC-009)

```yaml
status: "PASS"
coverage:
  build: 100%  # 2/2 project
  static_checks: 100%  # 7/7 TC
summary: "Tat ca 9 test cases PASS. Ca 2 project build 0 error. Landing page co 2 cards dung link. deploy.yml day du publish AIHub."
```

## Checklist

- [x] Build AIHub PASS
- [x] Build JapaneseLearner PASS (khong pha)
- [x] Tat ca static checks PASS
- [x] Coverage 100%
- [x] Khong con loi test
