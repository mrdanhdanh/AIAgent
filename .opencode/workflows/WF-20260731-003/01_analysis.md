---
phase: 01_analysis
agent: analyst
workflow_id: WF-20260731-003
status: READY
schema_version: "3.2"
---

# 01 — Analysis: Evolution Mode — Sandbox / Simulation Engine

## Summary

Yêu cầu bổ sung khả năng kiểm tra **runtime** (động) cho AI Agent Framework
`.opencode/`, song song với kiểm tra **tĩnh** (static) hiện có (Semantic Diff,
Compatibility Check, Migration, Self-Healing). Hệ thống hiện tại trả lời được
"các file có đúng không?" nhưng chưa trả lời được "nếu chạy thật thì có hoạt
động không?".

Khảo sát hiện trạng cho thấy:
- **Đã có:** `sync-system-docs.ps1` với 7 Evolution Engines + Stress Test Engine
  inline (`-stressTest` flag, 13-step state machine, deterministic seed).
- **Chưa có:** `evolution/simulation-engine.ps1` (Sandbox mode), Capability
  Benchmark, `sandbox` evolution mode, Runtime Health trong Health Score.
- **Liên quan:** Doctor system (`scripts/doctor/`) đã có module `simulation.ps1`
  (scenario-based, 6 scenarios) và `benchmark.ps1` (keyword-based) — nhẹ, phục vụ
  health check nhanh, không phải runtime validation sâu.

## Requirements

- [R1] Tạo `simulation-engine.ps1` trong `evolution/` — runtime validation:
  agent, skill, command, contract, output, dependency.
- [R2] Thêm mode `sandbox` (`--simulate` / `--evolutionMode sandbox`) cho
  `/team-syncdocs` — chạy giả lập toàn bộ Agent/Skill/Command, phát hiện lỗi
  runtime + integration.
- [R3] Thêm Capability Benchmark (`--benchmark`) — đánh giá năng lực từng agent
  theo domain nhiệm vụ.
- [R4] Stress Test đã tồn tại (`--stress-test`) — giữ nguyên, cải thiện khả năng
  tích hợp báo cáo.
- [R5] Health Score = System Health + Runtime Health + Capability Score.
- [R6] Simulation Report tổng hợp: runtime errors, integration issues, capability
  issues, stress test rate, benchmark scores, suggested actions, runtime health.
- [R7] Learning: từ failures của simulation → đề xuất actions (create skill,
  update contract, add validation rule).
- [R8] Cập nhật tài liệu `team-syncdocs.md` + regenerated `SYSTEM_EVOLUTION_REPORT.md`.

## Key Findings

1. `sync-system-docs.ps1` (1013 dòng) — orchestrator: scan → sync → evolution
   (7 engines) → report. Stress test nằm inline ở đầu script (dòng 24-217).
2. `health-score.ps1` — 8 categories, weighted 0.15/0.15/0.10/0.15/0.15/0.10/0.10/0.10.
   Chưa có runtime/capability categories.
3. `evolution-report.ps1` — 6 sections; chưa có simulation/benchmark sections.
4. `evolution/` hiện có 7 scripts + `reports/` — pattern: `<name>-<timestamp>.json`.
5. Contracts: `planner.yaml`, `builder.yaml`, `reviewer.yaml`, `tester.yaml`,
   `workflow.yaml` — hỗ trợ kiểm tra schema version compat.
6. Doctor system đã có simulation + benchmark đơn giản — KHÔNG trùng lặp (khác
   mục đích), nhưng cần đảm bảo naming/location khác biệt rõ ràng.

## Affected Areas

| Area | File | Hiện trạng | Hành động |
|------|------|-----------|-----------|
| Evolution engine | `.opencode/scripts/evolution/simulation-engine.ps1` | Không tồn tại | CREATE |
| Evolution engine | `.opencode/scripts/evolution/capability-benchmark.ps1` | Không tồn tại | CREATE |
| Orchestrator | `.opencode/scripts/sync-system-docs.ps1` | 7 engines + stress test | MODIFY |
| Health score | `.opencode/scripts/evolution/health-score.ps1` | 8 categories | MODIFY |
| Evolution report | `.opencode/scripts/evolution/evolution-report.ps1` | 6 sections | MODIFY |
| Docs | `.opencode/commands/team-syncdocs.md` | 7 engines, 5 modes | MODIFY |
| Report | `.opencode/SYSTEM_EVOLUTION_REPORT.md` | Từ evolution-report | REGENERATE |

## Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| Script syntax lỗi do PowerShell 5.1 quirks (multi-line splatting, hashtable edge cases) | HIGH | Test từng script standalone trước khi chạy pipeline; dùng Parser để validate |
| Trùng lặp naming với doctor modules (simulation.ps1, benchmark.ps1) | LOW | Đặt tên khác hẳn: `simulation-engine.ps1`, `capability-benchmark.ps1`; hàm prefix `Invoke-SimulationEngine`/`Get-CapabilityBenchmark` |
| Break backward compat với `-stressTest` | MEDIUM | Chỉ thêm flags mới, giữ nguyên hành vi stress test |
| Health score weights thay đổi làm score chung đổi | MEDIUM | Thêm category mới + điều chỉnh weights, giữ backward compat khi report cũ |
| `--evolve` chạy thêm engine mới làm chậm | LOW | Simulation/Benchmark chạy lightweight (read-only), không gọi LLM |
| YAML frontmatter parse khác nhau giữa các file | LOW | Dùng regex parse thống nhất (giống sync-system-docs.ps1) |

## Out of Scope

- Refactor Stress Test inline ra file riêng (giữ nguyên hiện trạng, chỉ tích hợp báo cáo).
- Sửa Doctor system (đã hoạt động độc lập).
- Thêm engine mới ngoài simulation/benchmark.

## Dependencies

- Không có dependency ngoài. Scripts sử dụng các thư mục `.opencode/agents`,
  `.opencode/skills`, `.opencode/commands`, `.opencode/system/contracts`,
  `.opencode/knowledge` hiện có.
- PowerShell 5.1 (Windows), không cần module ngoài.
