---
phase: 03_plan
agent: planner
workflow_id: WF-20260731-003
status: READY
schema_version: "3.2"
---

# 03 — Plan: Evolution Mode — Sandbox / Simulation Engine

## Strategy

**LARGE** — 10 steps, 4 chunks (1=config, 2=logic, 3=integration, 4=test+docs).
Thứ tự: config → logic (2 engines mới) → integration (orchestrator + health + report) → docs + validation → regenerate report.

## Steps

```yaml
steps:
  - order: 1
    description: "Tạo workflow artifacts + backup cho các file sẽ MODIFY"
    file: ".opencode/workflows/WF-20260731-003/"
    action: CREATE
    logic: "Thư mục artifacts đã tạo ở analyze. Chạy backup-utility.ps1 cho 4 file sẽ sửa: sync-system-docs.ps1, health-score.ps1, evolution-report.ps1, team-syncdocs.md"
    expected_result: "Backup manifest tồn tại tại .opencode/backup/WF-20260731-003/05_backup_manifest.json"
    check: "Test-Path .opencode/backup/WF-20260731-003/05_backup_manifest.json"
    chunk: 1
    risk_level: LOW
    requires_backup: false

  - order: 2
    description: "CREATE simulation-engine.ps1 — Runtime Validation Engine (6 groups)"
    file: ".opencode/scripts/evolution/simulation-engine.ps1"
    action: CREATE
    logic: "Viết engine: param(agentsDir, skillsDir, commandsDir, contractDir, knowledgeDir, outputDir, evolutionMode). 6 groups: agent/skill/command/contract/integration/output validation. Parse frontmatter bằng regex thống nhất. Build dependency graph. Inject fake task cho output validation. Tính runtime_health + verdict + suggested_actions. Xuất JSON report."
    expected_result: "File tồn tại, parse không lỗi syntax, chạy standalone được"
    check: "& .opencode\scripts\evolution\simulation-engine.ps1 -dryRun; [System.Management.Automation.Language.Parser]::ParseFile parse OK"
    chunk: 2
    risk_level: MEDIUM
    requires_backup: false

  - order: 3
    description: "CREATE capability-benchmark.ps1 — Capability Benchmark Engine"
    file: ".opencode/scripts/evolution/capability-benchmark.ps1"
    action: CREATE
    logic: "Viết engine: param(agentsDir, knowledgeDir, contractDir, outputDir). Domain pool 10 domains. Keyword scoring base 40 + 15/hit, đọc thêm knowledge + contracts. Task-type simulation per domain (PASS nếu >= 60). Aggregate per-agent + per-domain. capability_score + verdict. Xuất JSON report."
    expected_result: "File tồn tại, parse OK, chạy standalone được"
    check: "& .opencode\scripts\evolution\capability-benchmark.ps1 -dryRun; Parser parse OK"
    chunk: 2
    risk_level: MEDIUM
    requires_backup: false

  - order: 4
    description: "MODIFY sync-system-docs.ps1 — thêm --simulate, --benchmark, sandbox mode, dispatch 2 engines mới"
    file: ".opencode/scripts/sync-system-docs.ps1"
    action: MODIFY
    logic: "Thêm param [switch]$simulate, [switch]$benchmark. $runSimulation = $simulate -or ($evolutionMode -eq 'sandbox') -or $evolve; $runBenchmark tương tự. Trong block evolution: gọi simulation-engine.ps1 + capability-benchmark.ps1 sau self-healing, trước health-score. Truyền -simulationReport + -benchmarkReport vào health-score.ps1. Thêm evolution steps + issues handling."
    expected_result: "Script parse OK, chạy -dryRun -evolve không lỗi"
    check: "Parser parse OK; & sync-system-docs.ps1 -dryRun -evolutionMode sandbox"
    chunk: 3
    risk_level: HIGH
    requires_backup: true

  - order: 5
    description: "MODIFY health-score.ps1 — thêm Runtime Health + Capability categories"
    file: ".opencode/scripts/evolution/health-score.ps1"
    action: MODIFY
    logic: "Thêm param -simulationReport, -benchmarkReport. Category Runtime = simulation.runtime_health (nếu có report; fallback 50). Category Capability = benchmark.capability_score (fallback 50). Weights: Workflow 0.13, Skills 0.13, Knowledge 0.09, Compatibility 0.13, Agents 0.13, Scripts 0.09, Tests 0.09, Learning 0.09, Runtime 0.06, Capability 0.06 (sum=1.0). Update recommendations."
    expected_result: "Script parse OK, chạy với report cũ không lỗi"
    check: "Parser parse OK; & health-score.ps1 -dryRun"
    chunk: 3
    risk_level: MEDIUM
    requires_backup: true

  - order: 6
    description: "MODIFY evolution-report.ps1 — thêm Simulation + Capability sections"
    file: ".opencode/scripts/evolution/evolution-report.ps1"
    action: MODIFY
    logic: "Thêm param -simulationReport, -benchmarkReport. Load JSON. Section Detected += runtime_errors, integration_issues, capability_issues. Section mới: Runtime Health (runtime_health, verdict, suggested_actions) + Capability Benchmark (capability_score, domain scores). Cập nhật markdown output + console display."
    expected_result: "Script parse OK, chạy với report cũ không lỗi"
    check: "Parser parse OK; & evolution-report.ps1 (không param) không lỗi"
    chunk: 3
    risk_level: MEDIUM
    requires_backup: true

  - order: 7
    description: "MODIFY team-syncdocs.md — docs 3 mode mới + architecture"
    file: ".opencode/commands/team-syncdocs.md"
    action: MODIFY
    logic: "Thêm flags --simulate, --benchmark vào bảng flags. Thêm mode sandbox vào bảng modes. Thêm section mô tả Simulation Engine + Capability Benchmark. Cập nhật architecture diagram + output contract + script examples."
    expected_result: "Frontmatter YAML hợp lệ, internal links có section tương ứng"
    check: "Frontmatter parse OK; kiểm tra các link #simulation-engine có section"
    chunk: 4
    risk_level: LOW
    requires_backup: true

  - order: 8
    description: "Static validation — parse toàn bộ script mới/sửa + frontmatter docs"
    file: ".opencode/scripts/evolution/"
    action: MODIFY
    logic: "Dùng PowerShell Parser kiểm tra syntax 2 engine mới + 3 file sửa. Kiểm tra code block balance trong team-syncdocs.md. Kiểm tra YAML frontmatter."
    expected_result: "Tất cả scripts parse OK, không syntax error"
    check: "Parser trả về 0 errors cho mọi file"
    chunk: 4
    risk_level: LOW
    requires_backup: false

  - order: 9
    description: "Chạy thực tế — sandbox mode + benchmark + stress-test + full evolve"
    file: ".opencode/scripts/sync-system-docs.ps1"
    action: MODIFY
    logic: "Chạy: 1) & sync-system-docs.ps1 -evolutionMode sandbox (simulation + benchmark) 2) & sync-system-docs.ps1 -stressTest -stressCount 20 (verify ổn định) 3) & sync-system-docs.ps1 -evolve (full pipeline, regenerate SYSTEM_EVOLUTION_REPORT.md + SYSTEM_MAP.md). Kiểm tra JSON reports sinh ra + console không lỗi."
    expected_result: "3 lệnh chạy thành công, reports JSON tồn tại, SYSTEM_EVOLUTION_REPORT.md được regenerate có sections Simulation + Capability"
    check: "Get-ChildItem .opencode/scripts/evolution/reports/simulation-engine-*.json | count >= 1; capability-benchmark-*.json >= 1; SYSTEM_EVOLUTION_REPORT.md có 'Runtime Health'"
    chunk: 4
    risk_level: MEDIUM
    requires_backup: false

  - order: 10
    description: "Final report + workflow.json snapshot"
    file: ".opencode/workflows/WF-20260731-003/workflow.json"
    action: CREATE
    logic: "Ghi workflow.json với toàn bộ tracking variables, kết quả từng bước, final report."
    expected_result: "workflow.json tồn tại, hợp lệ"
    check: "Test-Path .opencode/workflows/WF-20260731-003/workflow.json"
    chunk: 4
    risk_level: LOW
    requires_backup: false
```

## Rollback Strategy

```yaml
rollback_strategy:
  enabled: true
  trigger_conditions:
    - "sync-system-docs.ps1 syntax error sau khi MODIFY"
    - "health-score.ps1 / evolution-report.ps1 không chạy được"
    - "Stress test bị phá vỡ (backward compat)"
  restore_order:
    - "& .opencode\scripts\rollback-utility.ps1 -workflowId WF-20260731-003"
  requires_user_confirmation: false
```

## Validate

```yaml
per_step_validation:
  - order: "Mỗi step có expected_result + check rõ ràng"
per_chunk_validate:
  - chunk_2: "2 engine mới chạy standalone không lỗi trước khi integration"
  - chunk_3: "3 file sửa parse OK trước khi chạy pipeline"
final_validation:
  - command: "& .opencode\scripts\sync-system-docs.ps1 -evolutionMode sandbox"
    expected: "Exit 0, simulation-engine JSON + capability-benchmark JSON sinh ra"
  - command: "& .opencode\scripts\sync-system-docs.ps1 -stressTest -stressCount 20"
    expected: "Exit 0, stress-test JSON sinh ra, không crash"
  - command: "& .opencode\scripts\sync-system-docs.ps1 -evolve"
    expected: "Exit 0, SYSTEM_EVOLUTION_REPORT.md có Runtime Health section"
```
