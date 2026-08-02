# 10_test_plan.md — WF-20260801-003

## Kế hoạch kiểm thử — Sprint 1 Workflow Engine v4

```yaml
status: "PASS"
scope: "Workflow Engine v4 (docs + definitions + validator + launcher) — không chạy bUnit/Playwright (không đổi code C#)"
test_cases:
  - id: T1
    name: "workflow-validator.ps1 validate 5 definitions"
    steps: "Chạy workflow-validator.ps1, kiểm tra exit code + report JSON"
    expected: "5/5 PASS, exit 0"
  - id: T2
    name: "WF-ERR-009 resolve workflow invalid id"
    steps: "Kiểm tra engine.md có ghi WF-ERR-009 cho workflow không tồn tại"
    expected: "WF-ERR-009 được document"
  - id: T3
    name: "Phase count đúng spec (default=13, bugfix=6, feature=8, ui=6, docs=5)"
    steps: "Đếm phase id trong từng definition yaml"
    expected: ">= spec cho cả 5 definitions"
  - id: T4
    name: "Smoke-test pipeline docs trong temp context (WF_CONTEXT_ROOT)"
    steps: "Chạy pipeline mô phỏng 5 phases trong $env:TEMP/wf-smoke-*/"
    expected: "Đến COMPLETE, git delta = 0"
  - id: T5
    name: "team.md launcher parse --workflow + $ARGUMENTS"
    steps: "Đọc team.md, verify regex --workflow, WF_CONTEXT_ROOT, $ARGUMENTS placeholder"
    expected: "OK"
  - id: T6
    name: "Rollback recovery (backup manifest)"
    steps: "backup-utility.ps1 -action verify -workflowId WF-20260801-003"
    expected: "2/2 integrity PASS"
```

## Test matrix vs definition phases
| Definition | Phase count | Validator | Smoke-test |
|-----------|-------------|-----------|------------|
| default | 13 | PASS | (docs workflow dùng cho smoke) |
| bugfix | 6 | PASS | — |
| feature | 8 | PASS | — |
| ui | 6 | PASS | — |
| docs | 5 | PASS | COMPLETE |

```yaml
risk:
  - "schema-validator.ps1 legacy false positives (không dùng làm gate)"
  - "ConvertFrom-Yaml không available — validator dùng parser YAML subset"
mitigation: "Dùng workflow-validator.ps1 (tự viết) + smoke-test temp context + git delta guard"
